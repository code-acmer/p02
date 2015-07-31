-module(server_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1, info/0]).
-export([get_proc_name/2]).

-include("define_logger.hrl").
-include("define_login.hrl").
-include("define_server.hrl").
-include("define_protocol.hrl").
-include_lib("leshu_db/include/leshu_db.hrl").
-include("define_rank.hrl").

tpl(List) ->
    [dbg:tpl(M, [{'_', [], [{return_trace}]}]) || M <- List].

start(normal, []) ->
    true = register(server, self()),
    %% 动态编译application的config配置
    %dynamic_config:start(), 
    %% 动态编译logs类型
    %% LogLevel = app_misc:get_env(log_level),
    %% hloglevel:set(LogLevel), 启用lager，关闭
    %% 启动监控树
    %% dbg:tracer(),
    %% dbg:p(all, [call]),  %% 我们关心函数调用
    %% tpl(element(2, application:get_key(server, modules))),
    %%ok = server_sup:start_child(mod_gateway, []),
    %% timer:sleep(3000),
    {ok, SupPid} = server_sup:start_link(),
    mnesia_misc:init(),
    mod_alarm_handler:start(),
    cache_misc:start(),
    mysql_misc:init(),
    %% 启动mnesia数据库
    %% try
    %%     server_schema:mnesia_init()
    %% catch
    %%     _:Res ->
    %%         ?WARNING_MSG("mnesia init failed: ~p~n~p~n",
    %%                      [Res, erlang:get_stacktrace()])
    %% end,

    %% init mysql database
    % {_L1, Conf1} = init_db(db_base),
    %{_L2, Conf2} = init_db(db_log),
    %mysql_sup:start_link([L1, L2]),
    %dynamic_db_interface:start([Conf2]),
    sensitive_word_misc:compile_pattern_init(),  %%敏感词初始化
    %% ?DEBUG("update league data begin~n", []),
    %% %lib_league:update_league_data(),
    %% ?DEBUG("update league data ok~n", []),
    ?DEBUG("update_tables_name_cache ... "),
    server_misc:update_tables_name_cache(),
    start_child(),
    ?DEBUG("start_child ... "),
    lib_counter:init(),
    reloader_misc:init(),
    {ok, SupPid}.

stop(_State) ->
    ?WARNING_MSG("server_app stopping.~n",[]),
    void. 

info() ->
    SchedId      = erlang:system_info(scheduler_id),
    SchedNum     = erlang:system_info(schedulers),
    ProcCount    = erlang:system_info(process_count),
    ProcLimit    = erlang:system_info(process_limit),
    ProcMemUsed  = erlang:memory(processes_used),
    ProcMemAlloc = erlang:memory(processes),
    MemTot       = erlang:memory(total),
    ?INFO_MSG("abormal termination:
               ~n   Scheduler id:                         ~p
               ~n   Num scheduler:                        ~p
               ~n   Process count:                        ~p
               ~n   Process limit:                        ~p
               ~n   Memory used by erlang processes:      ~p
               ~n   Memory allocated by erlang processes: ~p
               ~n   The total amount of memory allocated: ~p
               ~n",
              [SchedId, SchedNum, ProcCount, ProcLimit,
               ProcMemUsed, ProcMemAlloc, MemTot]),
    ok.

init_db(Db) ->
    [_Type, Host, Port, User, Password, DataBase, Poolsize, _Encode] = 
        app_misc:get_db_config(Db),
    DbConf = #db_conf{
                mod_name = atom_to_list(Db),
                host = Host,
                poll = Db,
                username = User,
                password = Password,
                database = DataBase,
                worker = Poolsize
               },
    emysql:add_pool(Db, Poolsize, User, Password, Host, Port, DataBase, utf8),
    {[Db, Host, Port, User, Password, DataBase, Poolsize], DbConf}.

start_child() ->
    case app_misc:get_env(is_world_gs) of
        true ->
            ?DEBUG("world_gs word ~n", []),
            %% server_sup:start_sup_child(cross_pvp_sup, []),
            %% ok = server_sup:start_child(mod_cross_pvp, []);
            %% start_cross_pvp_srv(),
            %% start_q_coin_srv(),
            ok;
        single ->  %%应对开发服不集群
            %% start_connect_server(),
            %% start_child_srv(),
            %% ok = server_sup:start_child(mod_cross_pvp, []);
            %% start_cross_pvp_srv(),
            %% start_q_coin_srv(),
            ok;
        _ ->
            ?DEBUG("not world_gs skip ~n", []),
            start_connect_server(),
            start_child_srv()
    end.

start_cross_pvp_srv() ->
    lists:map(fun(I) ->
                      %% io:format("starting I : ~p~n",[I]),                      
                      %% ok = server_sup:start_child(get_proc_name(mod_cross_pvp, I), mod_cross_pvp, [I])
                      ok
              end, lists:seq(0, ?CROSS_PVP_WORKER_NUM)).

start_q_coin_srv() ->
    DbSnList = server_misc:mnesia_sn_list(),
    [MaxSn|_] = lists:sort(fun(A, B) -> A > B end,DbSnList),
    lists:map(fun(I) ->
                      %% io:format("starting I : ~p~n",[I]),                      
                      %% ok = server_sup:start_child(get_proc_name(mod_q_coin_srv, I), mod_q_coin_srv, [I])
                      ok
              end, lists:seq(0, MaxSn)).

get_proc_name(Module, WorkerId) ->
    hmisc:create_process_name(Module, [WorkerId]).

start_child_srv() ->
    server_sup:start_sup_child(player_center_sup, []),
    case rank_sup:start_link() of
        {ok, _} ->
            ?WARNING_MSG("rank_sup start ~n", []);
        Err ->
            ?ERROR_MSG("rank_sup start error ~p~n", [Err]),
            throw({rank_sup_error, Err})
    end,
    server_sup:start_sup_child(cross_pvp_sup, []), 

    %%ok = server_sup:start_child(mod_counter, []),
    DbSnList = server_misc:mnesia_sn_list(),
    %ok = server_sup:start_child(mod_monitor, []),
    %%ok = server_sup:start_child(mod_mnesia_statistics, []),
    ok = server_sup:start_child(update, []),
    [ok = server_sup:start_child(server_misc:server_name(mod_boss_manage, Sn), 
                                 mod_boss_manage, [Sn]) || Sn <- DbSnList],
    ok = server_sup:start_child(log_player_p, mod_base_log, lib_log:log_player_args()),
    ok = server_sup:start_child(log_player_mini_p, mod_base_log, lib_log:log_player_mini_args()),
    ok = server_sup:start_child(log_player_feedback_p, mod_base_log, lib_log:log_player_feedback_args()),
    ok = server_sup:start_child(log_pay_info, mod_base_log, lib_log:log_pay_info_args()),
    ok = server_sup:start_child(log_player_create, mod_base_log, lib_log:log_player_create_args()),
    ok = server_sup:start_child(log_player_login, mod_base_log, lib_log:log_player_login_args()),
    ok = server_sup:start_child(log_player_online, mod_base_log, lib_log:log_player_online_args()),
    ok = server_sup:start_child(log_system, mod_base_log, lib_log:log_system_args()),
    [ok = server_sup:start_child(server_misc:server_name(mod_sys_acm, Sn), 
                                 mod_sys_acm, [Sn]) || Sn <- DbSnList],
    [ok = server_sup:start_child(server_misc:server_name(mod_player_rec, Sn), 
                                 mod_player_rec, [Sn]) || Sn <- DbSnList],
    %% ok = server_sup:start_child(mod_league_count, []),
    
    %% 暂时屏蔽
    %% [ok = server_sup:start_child(server_misc:server_name(mod_league_rank, Sn), 
    %%                              mod_league_rank, [Sn]) || Sn <- DbSnList],

    %% [ok = server_sup:start_child(server_misc:server_name(mod_league_reward, Sn), 
    %%                              mod_league_reward, [Sn]) || Sn <- DbSnList],
    %% 待修改
    %ok = server_sup:start_child(mod_table_clear, []),
    ok = server_sup:start_child(mod_timer, []),
    ok = server_sup:start_child(mod_dungeon_match, []),
    %% ok = server_sup:start_child(mod_selling_shop, []),
    %% ok = server_sup:start_child(mod_activity_shop, []),
    %% ok = server_sup:start_child(mod_g17_srv, []),
    %% 暂时屏蔽
    %% ok = server_sup:start_child(mod_cross_league_fight, []),
    %% 暂时屏蔽
    %% [ok = server_sup:start_child(server_misc:server_name(mod_league_cache, Sn), 
    %%                              mod_league_cache, [Sn]) || Sn <- DbSnList],
    [ok = server_sup:start_child(get_proc_name(mod_combat_attri, I), 
                                 mod_combat_attri, [I]) || I <- lists:seq(0, ?COMBAT_ATTRI_WORKER_NUM)],
    %% start_rank_child(DbSnList),
    ok.

start_rank_child(DbSnList) ->
    %% rank_sup:start_child(async_arena_rank, mod_arena, [async_arena_rank]),
    rank_sup:start_child(sync_arena_rank, mod_arena, [sync_arena_rank]),
    [ lists:foreach(fun(DbSn) ->
                            WriteTable = hdb:table_name(Rank, DbSn),
                            ok = rank_sup:start_child(WriteTable, mod_rank, 
                                                        [Rank, WriteTable, MaxSize, ResetType, RewardFlag])
                    end, DbSnList)
      || {Rank, MaxSize, ResetType, RewardFlag} <- ?ALL_RANK].


start_connect_server() ->
    Ip = proplists:get_value(ip, app_misc:get_env(game_listener)),
    Port = proplists:get_value(port, app_misc:get_env(game_listener)),
    HPort = Port + ?PORT_HTTP_DELTA,
                                                %ServerNo = app_misc:get_env(server_no),

    %% start acceptor_sup
    case tcp_acceptor_sup:start_link(tcp_client_handler) of
        {ok, _TcpAcceptPid} ->
            ?INFO_MSG("acceptor_sup started ~n", []);
        _Other ->
            ?ERROR_MSG("acceptor_sup failed, reason: ~p~n",
                       [_Other])
    end,

    case tcp_acceptor_sup:start_link(tcp_room_handler) of
        {ok, _RoomTcpAcceptPid} ->
            ?INFO_MSG("acceptor_sup started ~n", []);
        _RoomTcpAcceptOther ->
            ?ERROR_MSG("acceptor_sup failed, reason: ~p~n",
                       [_RoomTcpAcceptOther])
    end,

    %% start listener
    %% dbg:tracer(),
    %% dbg:p(all, [call]),  %% 我们关心函数调用
    %% dbg:tpl('_', '_', [{'_', [], []}]), %%以及返回值
    case listener_sup:start_link(Port, tcp_client_handler) of
        {ok, _Pid} ->
            ?INFO_MSG("listener_sup started for port: ~p ... ~n", [Port]);
        Other ->
            ?ERROR_MSG("listener_sup started for port failed, reason: ~p~n",
                       [Other])
    end,

    case listener_sup:start_link(Port+1000, tcp_room_handler) of
        {ok, _RoomPid} ->
            ?INFO_MSG("listener_sup started for port: ~p ... ~n", [Port]);
        RoomOther ->
            ?ERROR_MSG("listener_sup started for port failed, reason: ~p~n",
                       [RoomOther])
    end,
    http_admin:start(Port-1000),
    %% 启动 http 监听
    h_httpd_sup:start_link(HPort, httpd_handler),

    hmisc:write_system_info({self(), tcp_listener}, 
                            tcp_listener, {Ip, Port, now()}).
