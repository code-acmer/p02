%% mnesia模块的代码参考rabbitmq的mnesia代码，做了不少修改，有兴趣的可以去翻翻原版的代码。

-module(mnesia_misc).

-export([
         init/0, %% 启动初始化mnesia
         node_type/0,
         dir/0,
         cluster_status_from_mnesia/0,

         copy_db/1,
         ensure_mnesia_dir/0,
         fragment_realloc_all/0,
         allocate_n_frag/1,
         start_mnesia/0,
         ensure_mnesia_running/0
        ]).

%% Used internally in rpc calls
-export([node_info/0, remove_node_if_mnesia_running/1]).

-include("common.hrl").

init() ->
    %% dbg:tracer(),
    %% dbg:p(all, [call]),  %% 我们关心函数调用
    %% dbg:tpl(?MODULE, [{'_', [], [{return_trace}]}]),

    ensure_mnesia_running(),
    ensure_mnesia_dir(),
    init_from_config(), %% 游戏DB节点相对稳定的，配置是默认的.app那里，所以不需要像rmq那样去每个节点有份节点配置
    %% We intuitively expect the global name server to be synced when
    %% Mnesia is up. In fact that's not guaranteed to be the case -
    %% let's make it so.
    %% [hdb:fix_table(hdb:table_name(Table, DbSn))|| DbSn <- server_misc:mnesia_sn_list(),
    %%                                               Table <- [league]],   %%有些表可能需要手动去修复(可以优化)
    ok = global:sync(),
    ok.

init_from_config() ->
    TryNodes = app_misc:get_env(db_nodes),
    NodeType = app_misc:get_env(node_type),
    ?WARNING_MSG("TryNodes ~p, NodeType ~p~n", [TryNodes, NodeType]),
    case find_good_node(nodes_excl_me(TryNodes)) of
        {ok, Node} ->
            ?INFO_MSG("Node '~p' selected for clustering from configuration~n", [Node]),
            {ok, {_, DiscNodes, _}} = discover_cluster(Node),
            init_db(DiscNodes, NodeType, true);
            %mod_node_monitor:notify_joined_cluster(); TODO
        none ->
            if
                NodeType =/= disc ->
                    ?WARNING_MSG("Please Ensure Disc Node running, Node is ~p~n", [TryNodes]),
                    throw({disc_nodes_not_running, TryNodes, "Ensure Disc Node running"});
                true ->
                    ?INFO_MSG("First Disc Db Node Start"),
                    init_db([node()], disc, false)
            end
    end.
%%----------------------------------------------------------------------------
%% Queries
%%----------------------------------------------------------------------------

is_running() -> 
    mnesia:system_info(is_running) =:= yes.

%% This function is the actual source of information, since it gets
%% the data from mnesia. Obviously it'll work only when mnesia is
%% running.
cluster_status_from_mnesia() ->
    case is_running() of
        false ->
            {error, mnesia_not_running};
        true ->
            %% If the tables are not present, it means that
            %% `init_db/3' hasn't been run yet. In other words, either
            %% we are a virgin node or a restarted RAM node. In both
            %% cases we're not interested in what mnesia has to say.
            NodeType = case mnesia:system_info(use_dir) of
                           true  -> 
                               disc;
                           false -> 
                               ram
                       end,
            case mnesia_table:is_present() of
                true  -> 
                    AllNodes = mnesia:system_info(db_nodes),
                    DiscCopies = mnesia:table_info(schema, disc_copies),
                    DiscNodes = case NodeType of
                                    disc -> 
                                        nodes_incl_me(DiscCopies);
                                    ram  -> 
                                        DiscCopies
                                end,
                    %% `mnesia:system_info(running_db_nodes)' is safe since
                    %% we know that mnesia is running
                    RunningNodes = mnesia:system_info(running_db_nodes),
                    {ok, {AllNodes, DiscNodes, RunningNodes}};
                false ->
                    {error, tables_not_present}
            end
    end.

node_info() ->
    {erlang:system_info(otp_release), app_misc:version(),
     cluster_status_from_mnesia()}.

%% 从配置文件取mnesia节点信息
node_type() ->
    app_misc:get_env(node_type).

dir() -> 
    mnesia:system_info(directory).

%%----------------------------------------------------------------------------
%% Operations on the db
%%----------------------------------------------------------------------------

%% Adds the provided nodes to the mnesia cluster, creating a new
%% schema if there is the need to and catching up if there are other
%% nodes in the cluster already. It also updates the cluster status
%% file.
init_db(ClusterNodes, NodeType, CheckOtherNodes) ->
    Nodes = change_extra_db_nodes(ClusterNodes, CheckOtherNodes), %%这个是exl_me节点
    %% 判断mnesia是否有硬盘数据
    WasDiscNode = mnesia:system_info(use_dir),
    ?DEBUG("{Nodes, WasDiscNode, NodeType} ~p~n", [{Nodes, WasDiscNode, NodeType}]),
    case {Nodes, WasDiscNode, NodeType} of
        {[], _, ram} ->
            %% Standalone ram node, we don't want that
            throw({error, cannot_create_standalone_ram_node});
        {[], _, remote} ->
            throw({error, cannot_start_standalone_not_db_node});
        {[], false, disc} ->
            %% 第一次开启中心 disc 节点
            %% RAM -> disc, starting from scratch
            ?INFO_MSG("RAM -> disc will create_schema~n", []),
            ok = create_schema();
        {_, false, disc} ->
            %% 第一次开启其他的disc节点
            start_mnesia(),
            %% 先把center的schema拿过来
            mnesia_table:create_local_copy(schema, disc_copies),
            %% 创建专属本机的专有表, 同步更新schema的信息
            mnesia_upgrade:struct_upgrade_add_tables(),
            %% 加载其他disc的公共数据
            maybe_force_load(),
            %% 修改表的属性
            ok = mnesia_table:create_local_copy(NodeType);
        {_, true, disc} ->
            %% First disc node up
            maybe_force_load(),
            ok; 
        {[_ | _], _, _} ->
            %% Subsequent node in cluster, catch up
            maybe_force_load(),
            %% ok = mnesia_table:wait_for_replicated(), 可以去掉，统一放到最后去wait
            ?DEBUG("maybe_force_load ok ..."),
            ok = mnesia_table:create_local_copy(NodeType),
            ?DEBUG("create_local_copy ok ...")
    end,
    mnesia_table:wait_for_replicated(),
    ensure_schema_integrity(),
    % lib_node_monitor:update_cluster_status(), TODO
    ok.


ensure_mnesia_dir() ->
    MnesiaDir = dir() ++ "/",
    case filelib:ensure_dir(MnesiaDir) of
        {error, Reason} ->
            throw({error, {cannot_create_mnesia_dir, MnesiaDir, Reason}});
        ok ->
            ok
    end.

ensure_mnesia_running() ->
    case mnesia:system_info(is_running) of
        yes ->
            ok;
        starting ->
            wait_for(mnesia_running),
            ensure_mnesia_running();
        Reason when Reason =:= no;
                    Reason =:= stopping ->
            throw({error, mnesia_not_running})
    end.

ensure_mnesia_not_running() ->
    case mnesia:system_info(is_running) of
        no ->
            ok;
        stopping ->
            wait_for(mnesia_not_running),
            ensure_mnesia_not_running();
        Reason when Reason =:= yes; Reason =:= starting ->
            throw({error, mnesia_unexpectedly_running})
    end.

ensure_schema_integrity() ->
    case mnesia_table:check_schema_integrity() of
        ok ->
            %% 结构跟record一致，就可以将备份删除
            mnesia_upgrade:ensure_backup_removed(),
            ok;
        {error, Reason} ->
            throw({error, {schema_integrity_check_failed, Reason}})
    end.

copy_db(Destination) ->
    ok = ensure_mnesia_not_running(),
    file_misc:recursive_copy(dir(), Destination).

force_load_filename() ->
    filename:join(dir(), "force_load").

maybe_force_load() ->
    case filelib:is_file(force_load_filename()) of
        true  -> 
            mnesia_table:force_load(),
            file:delete(force_load_filename());
        false ->
            ok
    end.

%%--------------------------------------------------------------------
%% Internal helpers
%%--------------------------------------------------------------------

discover_cluster([]) ->
    {error, no_nodes_provided};
discover_cluster([Node|RestNodes]) ->
    case discover_cluster(Node) of
        {ok, Res} ->
            {ok, Res};
        {error, _} ->
            discover_cluster(RestNodes)
    end;
discover_cluster(Node) when Node == node() ->
    {error, {cannot_discover_cluster, "Cannot cluster node with itself"}};
discover_cluster(Node) ->
    OfflineError =
        {error, {cannot_discover_cluster,
                 "The nodes provided are either offline or not running"}},
    case rpc:call(Node, mnesia_misc, cluster_status_from_mnesia, []) of
        {badrpc, Reason} ->
            ?WARNING_MSG("Reason: ~p", [Reason]),
            OfflineError;
        {error, mnesia_not_running} -> 
            OfflineError;
        {ok, Res} ->
            {ok, Res}
    end.

%% We only care about disc nodes since ram nodes are supposed to catch
%% up only
create_schema() ->
    stop_mnesia(),
    err_misc:ensure_ok(mnesia:create_schema([node()]), cannot_create_schema),
    start_mnesia(),
    ok = mnesia_table:create(),
    ensure_schema_integrity(),
    ok.

remove_node_if_mnesia_running(Node) ->
    case is_running() of
        false ->
            {error, mnesia_not_running};
        true ->
            %% Deleting the the schema copy of the node will result in
            %% the node being removed from the cluster, with that
            %% change being propagated to all nodes
            case mnesia:del_table_copy(schema, Node) of
                {atomic, ok} ->
                    mod_node_monitor:notify_left_cluster(Node),
                    ok;
                {aborted, Reason} ->
                    {error, {failed_to_remove_node, Node, Reason}}
            end
    end.

wait_for(Condition) ->
    error_logger:info_msg("Waiting for ~p...~n", [Condition]),
    timer:sleep(1000).

start_mnesia() ->
    err_misc:ensure_ok(mnesia:start(), cannot_start_mnesia),
    ensure_mnesia_running().

stop_mnesia() ->
    stopped = mnesia:stop(),
    ensure_mnesia_not_running().

change_extra_db_nodes(ClusterNodes0, CheckOtherNodes) ->
    ClusterNodes = nodes_excl_me(ClusterNodes0),
    case {mnesia:change_config(extra_db_nodes, ClusterNodes), ClusterNodes} of
        {{ok, []}, [_|_]} when CheckOtherNodes ->
            throw({error, {failed_to_cluster_with, ClusterNodes,
                           "Mnesia could not connect to any nodes."}});
        {{ok, Nodes}, _} ->
            Nodes;
        Other ->
            ?WARNING_MSG("Other: ~p", [Other])
    end.

check_consistency(OTP, Server) ->
    err_misc:sequence_error(
      [check_otp_consistency(OTP),
       check_server_consistency(Server)]).



check_version_consistency(This, Remote, Name) ->
    check_version_consistency(This, Remote, Name, fun (A, B) -> A =:= B end).

check_version_consistency(This, Remote, Name, Comp) ->
    case Comp(This, Remote) of
        true  -> 
            ok;
        false -> 
            version_error(Name, This, Remote)
    end.

version_error(Name, This, Remote) ->
    {error, {inconsistent_cluster,
             io_misc:format("~s version mismatch: local node is ~s, "
                                "remote node ~s", [Name, This, Remote])}}.

check_otp_consistency(Remote) ->
    %% 暂不做版本检查
    check_version_consistency(erlang:system_info(otp_release), Remote, "OTP", 
                              fun(_, _) ->                                      
                                      true
                              end).

check_server_consistency(Remote) ->
    check_version_consistency(app_misc:version(), Remote, "Server").

%% %% This is fairly tricky.  We want to know if the node is in the state
%% %% that a `reset' would leave it in.  We cannot simply check if the
%% %% mnesia tables aren't there because restarted RAM nodes won't have
%% %% tables while still being non-virgin.  What we do instead is to
%% %% check if the mnesia directory is non existant or empty, with the
%% %% exception of the cluster status files, which will be there thanks to
%% %% `lib_node_monitor:prepare_cluster_status_files/0'.
%% is_virgin_node() ->
%%     case file:list_dir(dir()) of
%%         {error, enoent} ->
%%             true;
%%         {ok, []} ->
%%             true;
%%         {ok, [File1, File2]} ->
%%             lists:usort([dir() ++ "/" ++ File1, dir() ++ "/" ++ File2]) =:=
%%                 lists:usort([lib_node_monitor:cluster_status_filename(),
%%                              lib_node_monitor:running_nodes_filename()]);
%%         {ok, _} ->
%%             false
%%     end.

find_good_node([]) ->
    none;
find_good_node([Node | Nodes]) ->
    case rpc:call(Node, mnesia_misc, node_info, []) of
        {badrpc, Reason} ->
            ?WARNING_MSG("Reason: ~p", [Reason]),
            find_good_node(Nodes);
        {OTP, Server, _} -> 
            case check_consistency(OTP, Server) of
                {error, _} -> 
                    find_good_node(Nodes);
                ok -> 
                    {ok, Node}
            end
    end.

nodes_incl_me(Nodes) -> 
    lists:usort([node()|Nodes]).

nodes_excl_me(Nodes) ->
    Nodes -- [node()].

%% {mugen_reward,
%%       [
%%        {attributes, record_info(fields, mugen_reward)},
%%        {index, [#mugen_reward.player_id]},
%%        %% {disc_only_copies, [node()]}
%%        {frag_properties, [{n_fragments, ?N_FRAGMENTS_16}, {n_disc_copies, 1}, {node_pool,[node()]}]},
%%        {disc_copies,[node()]}
%%       ]},
%% {base_table,player},
%% {foreign_key,undefined},
%% {hash_module,mnesia_frag_hash},
%% {hash_state,{hash_state,16,1,4,phash2}},
%% {n_fragments,16},
%% {node_pool,['p02_game_88@192.168.1.88']}]


%% 对表分片的数量根据新的配置进行调整
%% 【WARNING】数据量上升到一定级别后，此操作应该特别注意
%% 
fragment_realloc_all() ->
    lists:map(fun(TableDef) ->
                      fragment_realloc(TableDef)
              end, mnesia_table:definitions()).

fragment_realloc({Table, Properties} = _TableDef) ->
    case lists:keyfind(frag_properties, 1, Properties) of
        {frag_properties, NeedFragProperties} ->
            case lists:keyfind(n_fragments, 1, NeedFragProperties) of
                false ->
                    %% Deactive Fragments
                    case mnesia:table_info(Table, frag_properties) of
                        [] ->
                            %% Need Active FragProperties
                            ok;
                        CurFragProperties ->
                            case lists:keyfind(n_fragments, 1, CurFragProperties) of
                                {n_fragments, CurNFragments} ->
                                    %% del fragments
                                    del_fragments(Table, CurNFragments - 1);
                                false ->
                                    ignored
                            end
                    end;
                {n_fragments, NeedNFragments} ->
                    case mnesia:table_info(Table, frag_properties) of
                        [] ->
                            %% Need Active FragProperties
                            case active_fragments(Table) of
                                ok ->
                                    add_fragments(Table, NeedNFragments - 1);
                                _ ->
                                    error
                            end;
                        CurFragProperties ->
                            case lists:keyfind(n_fragments, 1, CurFragProperties) of
                                {n_fragments, NeedNFragments} ->
                                    ok;
                                {n_fragments, CurNFragments} when CurNFragments > NeedNFragments ->
                                    %% del fragments
                                    del_fragments(Table, CurNFragments - NeedNFragments);
                                {n_fragments, CurNFragments} when CurNFragments < NeedNFragments ->
                                    %% add fragments
                                    add_fragments(Table, NeedNFragments - CurNFragments);
                                false ->
                                    ignored
                            end
                    end
            end;
        false ->
            case mnesia:table_info(Table, frag_properties) of
                [] ->
                    %% Need Active FragProperties
                    ok;
                CurFragProperties ->
                    case lists:keyfind(n_fragments, 1, CurFragProperties) of
                        {n_fragments, CurNFragments} ->
                            %% del fragments
                            case del_fragments(Table, CurNFragments - 1) of
                                ok ->
                                    deactive_fragments(Table);
                                _ ->
                                    error
                            end;
                        false ->
                            ignored
                    end
            end
    end.


%% 增加分片
add_fragments(_Table, 0) ->
    ok;
add_fragments(Table, N) ->
    InfoFun = fun(Item) -> mnesia:table_info(Table, Item) end,
    Dist = mnesia:activity(sync_dirty, InfoFun, [frag_dist], mnesia_frag),    
    case mnesia:change_table_frag(Table, {add_frag, Dist}) of
        {atomic, ok} ->
            add_fragments(Table, N - 1);
        Reason ->
            ?WARNING_MSG("add_fragments failed Reason : ~p~n", [Reason]),
            error
    end.

%% 减少分片
del_fragments(_Table, 0) ->
    ok;
del_fragments(Table, N) ->
    %% InfoFun = fun(Item) -> mnesia:table_info(Table, Item) end,
    %% Dist = mnesia:activity(sync_dirty, InfoFun, [frag_dist], mnesia_frag),    
    case mnesia:change_table_frag(Table, del_frag) of
        {atomic, ok} ->
            del_fragments(Table, N - 1);
        Reason ->
            ?WARNING_MSG("del_fragments failed Reason : ~p~n", [Reason]),
            error
    end.

%% 
active_fragments(Table) ->
    case mnesia:change_table_frag(Table, {activate, []}) of
        {atomic, ok} ->
            ok;
        Reason ->
            ?WARNING_MSG("active_fragments failed Reason : ~p~n", [Reason]),
            error
    end.

deactive_fragments(Table) ->
    case mnesia:change_table_frag(Table, deactivate) of
        {atomic, ok} ->
            ok;
        Reason ->
            ?WARNING_MSG("deactive_fragments failed Reason : ~p~n", [Reason]),
            error
    end.

%% {mugen_reward,
%%       [
%%        {attributes, record_info(fields, mugen_reward)},
%%        {index, [#mugen_reward.player_id]},
%%        %% {disc_only_copies, [node()]}
%%        {frag_properties, [{n_fragments, ?N_FRAGMENTS_16}, {n_disc_copies, 1}, {node_pool,[node()]}]},
%%        {disc_copies,[node()]}
%%       ]},


allocate_n_frag(NodePool) ->
    lists:map(fun(Node) ->
                      mnesia:change_table_copy_type(schema, Node, disc_copies)
              end, NodePool),
    lists:map(fun({Table, Properties}) ->
                      DiscCopies     = lists:keyfind(disc_copies, 1, Properties),
                      RamCopies      = lists:keyfind(ram_copies, 1, Properties),
                      DiscOnlyCopies = lists:keyfind(disc_only_copies, 1, Properties),
                      case lists:keyfind(frag_properties, 1, Properties) of
                          {frag_properties, NeedFragProperties} ->
                              case lists:keyfind(n_fragments, 1, NeedFragProperties) of
                                  {n_fragments, N_FRAGMENTS} ->
                                      case {DiscCopies, RamCopies, DiscOnlyCopies} of
                                          {{disc_copies,_}, false, false} ->
                                              allocate_n_frag(Table, disc_copies, N_FRAGMENTS, NodePool);
                                          {false, {ram_copies, _}, false} ->
                                              allocate_n_frag(Table, ram_copies, N_FRAGMENTS, NodePool);
                                          {false, false, {disc_only_copies, _}} ->
                                              allocate_n_frag(Table, disc_only_copies, N_FRAGMENTS, NodePool);
                                          OTHER ->
                                              ?WARNING_MSG("UnkownDiscType Table:~p, OTHER:~p, Properties: ~p~n",[Table, OTHER, Properties]),
                                              ignored
                                      end;
                                  false ->
                                      ignored
                              end;
                          false ->
                              ignored
                      end
              end, mnesia_table:definitions()).



%% 重新分配分片至NODE POOL中的各节点（平均分配）
allocate_n_frag(Table, DiscType, N_FRAGMENTS, NodePool) ->
    ANodes = [node()|nodes()],
    lists:foldl(fun(N, Nodes) ->                       
                        %% NODE POOL 循环
                        {NextNode,RestNodes} = case Nodes of
                                                   [] ->
                                                       [Node | Rest] = NodePool,
                                                       {Node, Rest};
                                                   [Node|Rest] ->
                                                       {Node, Rest}
                                               end,
                        FragTableName = get_table_frag_name(Table, N),
                        case moving_table_frag(NextNode, FragTableName, DiscType) of
                            ok ->
                                del_other_copies(NextNode, ANodes, FragTableName);
                            Bad ->
                                ?WARNING_MSG("moving table frag failed!! Table : ~p, Reason : ~p~n",[FragTableName, Bad])
                        end,
                        RestNodes
                end, [], lists:seq(1, N_FRAGMENTS)),
    ok.
moving_table_frag(NextNode, FragTableName, DiscType) ->
    LocalNode = node(),
    case NextNode of
        LocalNode ->
            case mnesia:table_info(FragTableName, storage_type) of
                unknown ->
                    {atomic,ok} = mnesia:add_table_copy(FragTableName, NextNode, DiscType),
                    ok;
                DiscType ->
                    ok;
                _ ->
                    {atomic,ok} = mnesia:change_table_copy_type(FragTableName, NextNode, DiscType),
                    ok
            end;
        NextNode ->
            case rpc:call(NextNode, mnesia, table_info, [FragTableName, storage_type]) of
                unknown ->
                    {atomic,ok} = mnesia:add_table_copy(FragTableName, NextNode, DiscType),
                    ok;
                DiscType ->
                    ok;
                {badrpc, _} = BAD ->
                    BAD;
                _  ->
                    {atomic,ok} = mnesia:change_table_copy_type(FragTableName, NextNode, DiscType),
                    ok
            end                                
    end.

%% 获取分片表名
get_table_frag_name(Table, N) ->
    case N of
        1 ->
            Table;
        _ ->
            hmisc:to_atom(atom_to_list(Table) ++ "_frag" ++ integer_to_list(N))
    end.
%% 删除其它节点上的该分片
del_other_copies(Node, NodePool, Table) ->
    lists:map(fun(N) ->
                      case N of
                          Node ->
                              ignore;
                          _ ->
                              mnesia:del_table_copy(Table, N)
                      end
              end, NodePool).
