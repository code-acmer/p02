-module(mnesia_upgrade).

-export([maybe_upgrade_mnesia/0,
         ensure_backup_removed/0,
         nodes_running/1,
         struct_upgrade_add_tables/0
        ]).

-include("common.hrl").

-define(VERSION_FILENAME, "schema_version").
-define(LOCK_FILENAME, "schema_upgrade_lock").

%% The upgrade logic is quite involved, due to the existence of
%% clusters.
%%
%% Firstly, we have two different types of upgrades to do: Mnesia and
%% everythinq else. Mnesia upgrades must only be done by one node in
%% the cluster (we treat a non-clustered node as a single-node
%% cluster). This is the primary upgrader. The other upgrades need to
%% be done by all nodes.
%%
%% The primary upgrader has to start first (and do its Mnesia
%% upgrades). Secondary upgraders need to reset their Mnesia database
%% and then rejoin the cluster. They can't do the Mnesia upgrades as
%% well and then merge databases since the cookie for each table will
%% end up different and the merge will fail.
%%
%% This in turn means that we need to determine whether we are the
%% primary or secondary upgrader *before* Mnesia comes up. If we
%% didn't then the secondary upgrader would try to start Mnesia, and
%% either hang waiting for a node which is not yet up, or fail since
%% its schema differs from the other nodes in the cluster.
%%
%% Also, the primary upgrader needs to start Mnesia to do its
%% upgrades, but needs to forcibly load tables rather than wait for
%% them (in case it was not the last node to shut down, in which case
%% it would wait forever).
%%
%% This in turn means that maybe_upgrade_mnesia/0 has to be patched
%% into the boot process by prelaunch before the mnesia application is
%% started. By the time Mnesia is started the upgrades have happened
%% (on the primary), or Mnesia has been reset (on the secondary) and
%% mnesia_misc:init_db_unchecked/2 can then make the node rejoin the cluster
%% in the normal way.
%%
%% The non-mnesia upgrades are then triggered by
%% mnesia_misc:init_db_unchecked/2. Of course, it's possible for a given
%% upgrade process to only require Mnesia upgrades, or only require
%% non-Mnesia upgrades. In the latter case no Mnesia resets and
%% reclusterings occur.
%%
%% The primary upgrader needs to be a disc node. Ideally we would like
%% it to be the last disc node to shut down (since otherwise there's a
%% risk of data loss). On each node we therefore record the disc nodes
%% that were still running when we shut down. A disc node that knows
%% other nodes were up when it shut down, or a ram node, will refuse
%% to be the primary upgrader, and will thus not start when upgrades
%% are needed.
%%
%% However, this is racy if several nodes are shut down at once. Since
%% rabbit records the running nodes, and shuts down before mnesia, the
%% race manifests as all disc nodes thinking they are not the primary
%% upgrader. Therefore the user can remove the record of the last disc
%% node to shut down to get things going again. This may lose any
%% mnesia changes that happened after the node chosen as the primary
%% upgrader was shut down.

%% -------------------------------------------------------------------

ensure_backup_taken() ->
    case filelib:is_file(lock_filename()) of
        false -> 
            case filelib:is_dir(backup_dir()) of
                false -> 
                    ok = take_backup();
                _ -> 
                    ok
            end;
        true  ->
            throw({error, previous_upgrade_failed})
    end.

take_backup() ->
    BackupDir = backup_dir(),
    case mnesia_misc:copy_db(BackupDir) of
        ok -> 
            info("upgrades: Mnesia dir backed up to ~p~n", [BackupDir]);
        {error, E} -> 
            throw({could_not_back_up_mnesia_dir, E})
    end.

ensure_backup_removed() ->
    case filelib:is_dir(backup_dir()) of
        true ->
            ok = remove_backup();
        _ -> 
            ok
    end.

remove_backup() ->
    ok = file_misc:recursive_delete([backup_dir()]),
    info("upgrades: Mnesia backup removed~n", []).

maybe_upgrade_mnesia() ->
    case table_version:need_upgrades() of
        {error, starting_from_scratch} ->
            ?INFO_MSG("first run mnesia", []),
            table_version:record_desired(),
            ok;
        {error, _} = Err ->
            throw(Err);
        {ok, true} ->
            case mnesia_misc:node_type() of
                disc ->
                    case mnesia:system_info(use_dir) of
                        true ->
                            ?INFO_MSG("center add sn , need struct upgrade ... ", []),
                            %% 本地新加罗辑服的时候需要升级数据库
                            mnesia_misc:start_mnesia(),
                            %% err_misc:ensure_ok(mnesia:start(), cannot_start_mnesia),
                            struct_upgrade_add_tables();
                        false ->
                            ok
                    end;
                _ ->                    
                    secondary_upgrade(),
                    ?INFO_MSG("not upgrade mnesia", [])
            end,
            ok;
        {ok, false} ->
            ?INFO_MSG("mnesia will upgrade, Upgrades ~n", []),
            ensure_backup_taken(),
            ok = case upgrade_mode() of
                     primary -> 
                         primary_upgrade();
                     secondary -> 
                         secondary_upgrade()
                 end
    end.

upgrade_mode() ->
    case nodes_running(app_misc:get_env(db_nodes)) of
        [] ->
            case mnesia_misc:node_type() of
                disc ->
                    ?DEBUG("primary ... "),
                    primary;
                ram ->
                    die("Cluster upgrade needed but this is a ram node.~n"
                        "Please first start the last disc node to shut down.",
                        []);
                remote ->
                    die("Cluster upgrade needed but this is a remote node.~n"
                        "Please first start the last disc node to shut down.",
                        [])
            end;
        [Another|_] ->
            MyVersion = table_version:desired(),
            ErrFun = fun (ClusterVersion) ->
                             %% The other node(s) are running an
                             %% unexpected version.
                             die("Cluster upgrade needed but other nodes are "
                                 "running ~p~nand I want ~p",
                                 [ClusterVersion, MyVersion])
                     end,
            case rpc:call(Another, table_version, desired, []) of
                {badrpc, {'EXIT', {undef, _}}} -> 
                    ErrFun(unknown_old_version);
                {badrpc, Reason} -> 
                    ErrFun({unknown, Reason});
                CV -> 
                    case table_version:matches(MyVersion, CV) of
                        true  -> 
                            ?DEBUG("secondary ... "),
                            secondary;
                        false ->
                            ErrFun(CV)
                    end
            end
    end.

die(Msg, Args) ->
    %% We don't throw or exit here since that gets thrown
    %% straight out into do_boot, generating an erl_crash.dump
    %% and displaying any error message in a confusing way.
    error_logger:error_msg(Msg, Args),
    io:format("~n~n****~n~n" ++ Msg ++ "~n~n****~n~n~n", Args),
    error_logger:logfile(close),
    halt(1).

primary_upgrade() ->
    ok = file_misc:lock_file(lock_filename()),
    err_misc:ensure_ok(mnesia:start(), cannot_start_mnesia),
    mnesia_table:force_load(),
    case mnesia:system_info(db_nodes) -- [node()] of
        [] -> 
            ok;
        Others  -> 
            info("mnesia upgrades: Breaking cluster~n", []),
            [{atomic, ok} = mnesia:del_table_copy(schema, Node) 
             || Node <- Others]
    end,
    struct_upgrade(),
    info("All upgrades applied successfully~n", []),
    ok = table_version:record_desired(),
    ok = file:delete(lock_filename()),    
    ok.
secondary_upgrade() ->
    %% must do this before we wipe out schema
    ?INFO_MSG("secondary_upgrade"),
    err_misc:ensure_ok(mnesia:delete_schema([node()]),
                          cannot_delete_schema),
    err_misc:ensure_ok(mnesia:start(), cannot_start_mnesia),
    %% ok = mnesia_misc:init(),
    ok = table_version:record_desired(),
    ok.

nodes_running(Nodes) ->
    [N || N <- Nodes, main:is_running(N)].



%% apply_upgrade({M, F}) ->
%%     Result = apply(M, F, []),
%%     info("mnesia upgrades: Applying ~w:~w, Result ~p~n", [M, F, Result]).

%% -------------------------------------------------------------------

dir() -> 
    mnesia_misc:dir().

lock_filename() -> 
    lock_filename(dir()).
lock_filename(Dir) -> 
    filename:join(Dir, ?LOCK_FILENAME).
backup_dir() -> 
    dir() ++ "-upgrade-backup".

%% NB: we cannot use rabbit_log here since it may not have been
%% started yet
info(Msg, Args) ->
    %error_logger:info_msg(Msg, Args).
    ?INFO_MSG(Msg, Args).


struct_upgrade_add_tables() ->
    TabList = mnesia:system_info(tables),
     case lists:filter(fun({Tab, _}) ->
                               not lists:member(Tab, TabList)
                       end, mnesia_table:definitions()) of
         [] ->
             ok;
         AddTables ->
             ?INFO_MSG("Create Tables ~p~n", [[Tab || {Tab, _} <- AddTables]]),
             lists:foreach(fun ({Tab, TabDef}) ->
                                   case mnesia:create_table(Tab, TabDef) of
                                       {atomic, ok} -> 
                                           ok;
                                       {aborted, Reason} ->
                                           throw({error, {table_creation_failed,
                                                          Tab, TabDef, Reason}})
                                   end
                           end, AddTables)
     end.
    
struct_upgrade_del_tables() ->
    TabList = mnesia:system_info(tables),
    Tables = mnesia_table:names(),
    case lists:filter(fun (schema) -> 
                              false;
                          (Tab) -> 
                              not lists:member(Tab, Tables)
                      end, TabList) of
        [] ->
            ok;
        OldTables ->
            DelTables = uniq_table(OldTables),
            ?INFO_MSG("delete table ~w~n",[DelTables]),
            lists:foreach(fun(Tab) ->
                                  case mnesia:delete_table(Tab) of
                                      {atomic, ok} -> 
                                          ok;
                                      {aborted, Reason} ->
                                          throw({error, {table_del_failed,
                                                         Tab, Reason}})
                                  end
                          end, DelTables)
    end.

uniq_table(Tables) ->
    lists:foldl(fun(Table, Acc) ->
                        case mnesia_frag:frag_names(Table) of
                            [Table] ->
                                Acc;
                            TableFragNames ->
                                %% 除去_fragx
                                Acc -- lists:delete(Table, TableFragNames)
                        end                            
                end, Tables, Tables).
   
struct_upgrade_index() ->
    [struct_upgrade_index(Tab, TabDef) || {Tab, TabDef} <- mnesia_table:definitions()].

struct_upgrade_index(Tab, TabDef) ->
    Indexs = proplists:get_value(index, TabDef, []),
    ExistIndex = index(Tab),
    struct_upgrade_add_index(Tab, Indexs, ExistIndex),
    struct_upgrade_del_index(Tab, Indexs, ExistIndex).

index(Tab) ->
    case mnesia:table_info(Tab, index) of
        [] ->
            [];
        ExistIndex ->
            ExistIndex
    end.
struct_upgrade_add_index(Tab, Indexs, ExistIndex) ->
    case Indexs -- ExistIndex of
        [] ->
            ok;
        AddIndexList ->
            ?INFO_MSG("Table:~w, AddIndexList : ~w ~n",[Tab, AddIndexList]),
            lists:foreach(fun(Index) ->
                                  ok = hdb:add_table_index(Tab, Index)
                          end, AddIndexList)
    end.    

struct_upgrade_del_index(Tab, Indexs, ExistIndex) ->
    case ExistIndex -- Indexs of
        [] ->
            ok;
        DelIndexList ->
            ?INFO_MSG("Table:~w, DelIndexList : ~w ~n",[Tab, DelIndexList]),
            lists:foreach(fun(Index) ->
                                  ok = hdb:del_table_index(Tab, Index)
                          end, DelIndexList)
    end.

struct_upgrade_table() ->
    [struct_upgrade_table(Tab, TabDef) || {Tab, TabDef} <- mnesia_table:definitions()].

struct_upgrade_table(Tab, TabDef) ->
    Fields = proplists:get_value(attributes, TabDef, []),
    RecordName = proplists:get_value(record_name, TabDef, Tab),
    case hdb:table_info(Tab, attributes) of
        Fields ->
            ok;
        _ ->
            ?INFO_MSG("transform_table ~p~n", [Tab]),
            ok = hdb:transform(Tab, Fields, RecordName)
    end.    
    
struct_upgrade() ->
    struct_upgrade_add_tables(),
    struct_upgrade_del_tables(),
    struct_upgrade_table(), %% 先更新表，后更新索引，否则新加字段作为索引会找不到
    struct_upgrade_index().



