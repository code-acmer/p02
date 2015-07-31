%%%--------------------------------------
%%% @Module  : main
%%% @Created : 2011.06.01 
%%% @Description:  服务器开启  
%%%--------------------------------------
-module(main).

-include("define_logger.hrl"). 

-deprecated({server_started,'_'}).

-export([
         server_start/0,
         server_stop/0,
         server_stop/1,
         server_started/0, stop_and_halt/1,
         is_running/0, is_running/1,
         info/0
        ]).

-export([stop_all_player/0]).

%% ===============================================================
%% WARNING:
%% libs for server start, only for .sh or .bat
%% publish's config be in ./rel/reltool.config
-define(SERVER_APPS, 
        [sasl, hstdlib, mysql, crypto, emysql, leshu_db, mnesia, asn1, public_key, ssl, ibrowse, os_mon, folsom, gproc, inets, g17, reloader, server]).
%%游戏服务器
tpl(List) ->
    [dbg:tpl(M, [{'_', [], [{return_trace}]}]) || M <- List].

server_start()->
    ok = application:load(server),
    ok = application:load(mnesia),
    log_misc:start(),
    app_misc:init(),
    server_misc:init(),  %多个服的设置
    gproc_misc:start(),
    %% dbg:tracer(),
    %% dbg:p(all, [call]),  %% 我们关心函数调用
    %% dbg:tpl(player_upgrade_functions, [{'_', [], [{return_trace}]}]),
    %% dbg:tpl(mnesia_upgrade_functions, [{'_', [], [{return_trace}]}]),
    %% tpl(element(2, application:get_key(mnesia, modules))),
    ?DEBUG("Lager Config ~p~n", [application:get_all_env(lager)]),
    %{ok, _Pid} = mod_counter:start_link(),
    ?DEBUG("mod_counter start ~n", []),
    mnesia_misc:ensure_mnesia_dir(),
    mnesia_upgrade:maybe_upgrade_mnesia(),
    ok = start_applications(?SERVER_APPS).

%%停止游戏服务器 
server_stop() ->
    server_stop(30).

server_started() ->
    RunningApps = application:which_applications(),
    case lists:keyfind(server, 1, RunningApps) of
        false ->
            false;
        _->
            true
    end.                        

is_running() -> 
    is_running(node()).

is_running(Node) -> 
    node_misc:is_process_running(Node, server).
   

%%停止游戏服务器 
server_stop(SleepSeconds) ->
    ?WARNING_MSG("server_stop stopping.~n", []),
    %%首先关闭外部接入，然后停止目前的连接，等全部连接正常退出后，再关闭应用
    %% mod_node_interface:stop_server_access_self(node()),
    %ok = mod_gateway:stop(),
    timer:sleep(SleepSeconds * 1000),
    stop_applications(?SERVER_APPS),
    ok.

stop_and_halt(SleepSeconds) ->
    try
        server_stop(SleepSeconds)
    after
        io_misc:local_info_msg("Halting Erlang VM~n", []),
        init:stop()
    end,
    ok.

%%撤下节点
%% server_remove() ->
%%     %% 首先关闭外部接入，然后停止目前的连接，等全部连接正常退出后，再关闭应用
%%     %% mod_node_interface:stop_server_access_self(node()),
%%     mod_gateway_agent:server_stop(node()),
%%     ok = mod_login:kick_all(),
%%     timer:sleep(30*1000),
%%     ok = stop_applications(?SERVER_APPS),
%%     erlang:halt().

info() ->
    SchedId      = erlang:system_info(scheduler_id),
    SchedNum     = erlang:system_info(schedulers),
    ProcCount    = erlang:system_info(process_count),
    ProcLimit    = erlang:system_info(process_limit),
    ProcMemUsed  = erlang:memory(processes_used),
    ProcMemAlloc = erlang:memory(processes),
    MemTot       = erlang:memory(total),
    ?INFO_MSG( "abormal termination:
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

%%############辅助调用函数##############
manage_applications(Iterate, Do, Undo, SkipError, ErrorTag, Apps) ->
    Iterate(fun(App, Acc) ->
                    case Do(App) of
                        ok -> [App | Acc];%合拢
                        {error, {SkipError, _}} -> Acc;
                        {error, Reason} ->
                            ?ERROR_MSG("App ~p, Reason ~p~n", [App, Reason]),
                            lists:foreach(Undo, Acc),
                            throw({error, {ErrorTag, App, Reason}})
                    end
            end, [], Apps),
    ok.

start_applications(Apps) ->
    manage_applications(fun lists:foldl/3, 
                        fun application:start/1,
                        fun application:stop/1,
                        already_started,
                        cannot_start_application,
                        Apps).

stop_applications(Apps) ->
    ?WARNING_MSG("stop_applications stopping.~n",[]),
    manage_applications(fun lists:foldr/3,
                        fun application:stop/1,
                        fun application:start/1,
                        not_started,
                        cannot_stop_application,
                        Apps).

stop_all_player() ->
    [begin 
         Ref = monitor(process, PlayerPid),
         mod_player:stop(PlayerPid, normal),
         receive
             {'DOWN', Ref, process, _, normal} ->
                 ok;
             {'DOWN', Ref, process, _, Reason} ->
                 exit(Reason)
         end
     end || {_, PlayerPid, _, _} <- supervisor:which_children(player_sup)],
    ok.
