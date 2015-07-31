-module(server_misc).

-include("define_logger.hrl").

-export([init/0,
         get_mnesia_sn/1,
         sn_list/0,
         mnesia_sn_list/0,
         server_name/2,
         set_sn/0,

         get_table_by_key/2,
         get_table_by_record/2,
         load_all_sn_table/0,
         get_local_table/1,
         update_tables/1,
         update_tables/0,
         update_tables_name_cache/0,
         get_tables_name_cache/0,
         get_tables_name/0,
         index_all_sn_tables/1,
         index_sn_tables/1
        ]).

-export([combine_sn/0]).

init() ->
    set_sn(),
    load_all_sn_table(),
    update_tables().

%%逻辑服列表
sn_list() ->
    app_misc:mochi_get(sn_list).

%%实际上db服列表
mnesia_sn_list() ->
    app_misc:mochi_get(mnesia_sn_list).

set_sn() ->
    case app_misc:get_env(server_sn_db) of
        undefined ->
            throw({server_sn_db_error, undefined});
        List ->
            {SnList, DbSnList} =lists:foldl(fun({Sn, TarSn}, {AccSn, AccDbsn}) ->
                                                    set_mnesia_sn(Sn, TarSn),
                                                    {[Sn|AccSn], [TarSn|AccDbsn]}
                                            end, {[], []}, List),
            app_misc:mochi_set(sn_list, SnList),
            app_misc:mochi_set(mnesia_sn_list, lists:usort(DbSnList))
    end.

set_mnesia_sn(Sn, TarSn) ->
    app_misc:mochi_set(sn_key(Sn), TarSn).

get_mnesia_sn(Sn) ->
    case app_misc:mochi_get(sn_key(Sn)) of
        undefined ->
            throw({get_mnesia_sn_error, undefined});
        Other ->
            Other
    end.
%% 所有表名------------------------------------------------------------------------

update_tables_name_cache() ->
    case mnesia_misc:ensure_mnesia_running() of
        ok ->
            AllNodes = mnesia:system_info(db_nodes),
            NewAllNodes = AllNodes -- [node()],
            update_tables_name_cache(NewAllNodes);
        Other ->
            Other
    end.    

update_tables_name_cache([]) ->
    ok;
update_tables_name_cache([Node | RestNodes]) ->
    case update_tables_name_cache(Node) of
        {error, _} ->
            update_tables_name_cache(RestNodes);
        {ok, RemoteSn} ->
            update_tables(RemoteSn),
            update_tables_name_cache(RestNodes)
    end;

update_tables_name_cache(Node) ->
    OfflineError =
        {error, {cannot_discover_cluster,
                 "The nodes provided are either offline or not running"}},
    LocalSn = app_misc:get_env(local_sn_num),
    case rpc:call(Node, server_misc, update_tables, [LocalSn]) of
        {badrpc, Reason} ->
            ?WARNING_MSG("Node: ~p, Reason: ~p", [Node, Reason]),
            OfflineError;
        {error, _} -> 
            OfflineError;
        {ok, Res} ->
            {ok, Res}
    end.

update_tables() ->
    update_key_tables(),
    update_public_tables(),
    LocalSn = app_misc:get_env(local_sn_num),
    update_tables(LocalSn).

update_tables(Sn) ->
    update_sn_tables(Sn),
    LocalSn = app_misc:get_env(local_sn_num),
    {ok, LocalSn}.

update_sn_tables(Sn) ->
    Tables = lists:map(fun(TableInfo) ->
                               element(1, TableInfo)
                       end, mnesia_table:definitions2()),
    NewTables = Tables -- hdb:all_sn_tables() ++ hdb:key_table(),
    lists:map(fun(Table) ->
                      Key = key_table_name(Table),
                      Val = sn_table_name(Table, Sn),
                      update_key_tables(Key, Val)
              end, NewTables).

update_public_tables() ->
    lists:map(fun(Table) -> 
                      Key = key_table_name(Table),
                      update_key_tables(Key, Table)
              end, hdb:all_sn_tables()).

update_key_tables() ->
    lists:map(fun(Table) ->
                      Num = app_misc:get_env(key_table_num),
                      update_key_tables(Num, Table)
              end, hdb:key_table()).

update_key_tables(Num, Table) 
  when is_integer(Num) ->
    Key = key_table_name(Table),
    lists:map(fun(N) -> 
                      Val = sn_table_name(Table, N),
                      update_key_tables(Key, Val)
              end, lists:seq(1, Num));

update_key_tables(Key, Val)
  when is_atom(Key) ->
    case app_misc:mochi_get(Key) of
        undefined ->
            app_misc:mochi_set(Key, [Val]);
        Tables when is_list(Tables) ->
            case lists:member(Val, Tables) of
                true ->
                    skip;
                false ->
                    app_misc:mochi_set(Key, [Val | Tables])
            end
    end.

key_table_name(Table) ->
    list_to_atom(lists:concat([Table, "_all"])).

index_all_sn_tables(Table) ->
    case app_misc:mochi_get(key_table_name(Table)) of
        undefined ->
            [];
        Tables ->
            Tables
    end.

index_sn_tables(Table) ->
    [].

%% 单表名--------------------------------------------------------------------------
get_local_table(Table) ->
    case lists:member(Table, hdb:key_table() ++ hdb:all_sn_tables()) of
        true ->
            index_all_sn_tables(Table);
        false ->
            get_local_table1(Table)
    end.

get_local_table1(Table) ->
    Sn = app_misc:get_env(local_sn_num),
    [list_to_atom(lists:concat([Table, '_', Sn]))].

%% 开服时加载全服表
load_all_sn_table() ->
    lists:map(fun(Table) ->
                      app_misc:mochi_set(Table, Table)
              end, hdb:all_sn_tables()).

sn_table_name(Table, Sn) ->
    list_to_atom(lists:concat([Table, '_', Sn])).

%% 写入数据库调用
get_table_by_record(Table, Record) 
  when is_tuple(Record) ->
    Key = element(2, Record),
    get_table_by_key(Table, Key).

%% 读取数据库调用
get_table_by_key(Table, Key) ->
    case app_misc:mochi_get(Table) of
        undefined ->
            Sn = get_db_sn(Key),
            sn_table_name(Table, Sn);
        TableName ->
            TableName
    end.    
    
get_db_sn(Key) 
  when is_integer(Key) ->
    Key rem 1000;

get_db_sn(Key) ->
    Rem = app_misc:mochi_get(key_table_num),
    get_db_sn(erlang:phash(Key, 1000), Rem).

get_db_sn(Key, Rem) ->
    Key rem Rem + 1.

get_tables_name() ->
    Tables = [Tab || {Tab, _} <- mnesia_table:definitions2()],
    List = 
        lists:foldl(fun(Tab, Acc) ->
                            NewAcc = 
                                case app_misc:mochi_get(key_table_name(Tab)) of
                                    undefined ->
                                        Acc;
                                    List ->
                                        List ++ Acc
                                end,
                            [Tab | NewAcc]
                    end, [], Tables),
    {ok, lists:usort(List)}.

get_tables_name_cache() ->
    [CenterNode] = app_misc:get_env(db_nodes),
    get_tables_name_cache(CenterNode).

get_tables_name_cache(Node) when Node =:= node() ->
    [];

get_tables_name_cache(CenterNode) ->
    OfflineError =
        {error, {cannot_discover_cluster,
                 "The nodes provided are either offline or not running"}},
    case rpc:call(CenterNode, server_misc, get_tables_name, []) of
        {badrpc, Reason} ->
            ?WARNING_MSG("CenterNode: ~p, Reason: ~p", [CenterNode, Reason]),
            OfflineError;
        {error, _} -> 
            OfflineError;
        {ok, Res} ->
            {ok, Res}
    end.
    
%% -----------------------------------------------------------    

%%因为mochi_set要传入一个原子，所以把服务器号变成一个原子
%%通过这个原子找出，要写入的db在哪里 eg:{db_sn_6, 1}
sn_key(Sn) ->
    list_to_atom(lists:concat(["db_sn_", Sn])).

%%要删掉竞技场战报
%%本节点合服其实很简单,把分服的数据库里面的数据删掉，配置表改一下就完了?
%%合服再分服先不考虑把，那些好友要处理
combine_sn() ->
    case supervisor:which_children(player_sup) of
        [] ->
            AllTables = hdb:all_sn_tables(),
            ServerCount = length(sn_list()),
            lists:foreach(fun(DbSn) ->
                                  [hdb:clear_table(hdb:table_name(Table, DbSn)) || Table <- AllTables]
                          end, lists:seq(1, ServerCount));
        _ ->
            throw({combine_sn_error, has_player_online})
    end.

server_name(Module, DbSn) ->
    list_to_atom(lists:concat([Module, '_', DbSn])).
