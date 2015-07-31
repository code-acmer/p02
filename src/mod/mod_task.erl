%%%------------------------------------
%%% @Module  : mod_task
%%% @Created : 2010.12.06
%%% @Description: 任务处理模块
%%%------------------------------------
-module(mod_task).
%% -behaviour(gen_server).

%% -export([start_link/1, stop/0]).
%% -export([
%%          init/1,
%%          handle_call/3,
%%          handle_cast/2,
%%          handle_info/2,
%%          terminate/2,
%%          code_change/3
%%         ]).

%% -include("define_logger.hrl").
%% -include("define_time.hrl").
%% -include("define_try_catch.hrl").

%% -record(state, {player_id = 0, nowtime = 0}).

%% start_link([PlayerId])->
%%     gen_server:start_link(?MODULE, [PlayerId], []).

%% %% 关闭服务器时回调
%% stop() ->
%%     ok.

%% init([PlayerId])->
%%     process_flag(trap_exit, true),	
%%     erlang:send_after(
%%       hmisc_timer:get_seconds_to_tomorrow() * 1000, self(), next_midnight_timer),
%%     hmisc:write_monitor_pid(self(),?MODULE, {}),
%%     State = #state{player_id=PlayerId,nowtime = util:unixtime()},
%%     {ok,State}.


%% %% 同步消息
%% handle_call({cmd_init_task, Player}, _From, State) ->
%%     try
%%         lib_task:flush_role_task(Player)
%%     catch
%%         _:Res ->
%%             ?ERROR_MSG("cmd_init_task failed: ~p~n~p~n",
%%                        [Res, erlang:get_stacktrace()])
%%     end,
%% 	{reply, ok, State};
%% handle_call(_Null, _From, State) ->
%% 	?ERROR_MSG("handle_call, msg: ~p, from: ~p~n", [_Null, _From]),
%% 	{reply, [], State}.

%% %% 异步消息
%% handle_cast(Request, State) ->
%%     try
%%         do_handle_cast(Request, State)
%%     catch
%%         _:Res ->
%%             ?ERROR_MSG("mod task handle cast failed: ~p~n~p~n",
%%                        [Res, erlang:get_stacktrace()]),
%%             {noreply, State}
%%     end.
    
%% %% 初始化玩家任务
%% do_handle_cast({cmd_init_task,PlayerStatus},State)->	
%% 	lib_task:flush_role_task(PlayerStatus),
%% 	{noreply,State};

%% %% 触发任务内容事件，如杀怪
%% do_handle_cast({'task_event', PlayerStatus, Event, Param}, State) ->
%% 	?DEBUG("task_event, Event=~p, Param=~p~n", [Event, Param]),
%% 	lib_task:handle_event(Event, Param, PlayerStatus),
%% 	{noreply,State};

%% %% 加入帮会
%% do_handle_cast({'join_guild', PlayerStatus}, State) ->
%% 	?DEBUG("join_guild, ~n", []),
%% 	pp_task:handle(30900, PlayerStatus, []),
%% 	{noreply,State};

%% %% 离开帮会
%% do_handle_cast({'leave_guild', PlayerStatus}, State) ->
%% 	?DEBUG("leave_guild, ~n", []),
%% 	lib_task:give_up_guild_task(PlayerStatus),
%% 	{noreply,State};
  
%% %%停止进程
%% do_handle_cast({stop, _Reason}, State) ->
%%     {stop, normal, State};

%% do_handle_cast(Msg, State) ->
%% 	?ERROR_MSG("handle_cast, Msg: ~p~n", [Msg]),
%%     {noreply, State}.

%% %% 消息
%% handle_info(next_midnight_timer, State) ->
%% 	?DEBUG("handle_info(next_midnight_timer ~n", []),
%%     ?TRY_BEGIN
%%         erlang:send_after(?ONE_DAY_SECONDS * 1000, self(), next_midnight_timer),
%%         PlayerStatus = lib_player:get_online_info(State#state.player_id),
%%         case PlayerStatus of
%%             [] ->
%%                 ok;
%%             _ ->
%%                 pp_task:handle(30900, PlayerStatus, [])
%%         end
%%         ?TRY_END,
%%     {noreply, State};
%% handle_info(Info, State) ->
%% 	?ERROR_MSG("handle_info, Info: ~p~n", [Info]),	
%%     {noreply, State}.

%% terminate(_Reason, _State) ->
%% 	misc:delete_monitor_pid(self()),
%%     ok.

%% code_change(_OldVsn, State, _Extra) ->
%%     {ok, State}.
	
