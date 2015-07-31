%%%-------------------------------------------------------------------
%%% @author Roowe <bestluoliwe@gmail.com>
%%% @copyright (C) 2013, Roowe
%%% @doc
%%% 成就系统
%%% @end
%%% Created : 26 Jun 2013 by Roowe <bestluoliwe@gmail.com>
%%%-------------------------------------------------------------------
-module(mod_achievement).

%% -behaviour(gen_server).

%% -include("define_logger.hrl").
%% -include("define_info_32.hrl").
%% -include("define_player.hrl").

%% %% API
%% -export([start_link/4,
%%          start/4,
%%          get_mod_achieve_pid/0,
%%          add_achieve/4,
%%          receive_achieve_reward/2,
%%          show_achieve_reward/2,      
%%          get_current_player_all_achieve/1]).

%% %% gen_server callbacks
%% -export([init/1, handle_call/3, handle_cast/2, handle_info/2,
%%          terminate/2, code_change/3]).

%% -define(SERVER, ?MODULE). 

%% -record(state, {worker_id  = 0,
%%                 daily_time = 0 %% daily_time记录上一次日处理时间
%%                }).

%% %%%===================================================================
%% %%% API
%% %%%===================================================================
%% %%动态加载成就处理进程 
%% get_mod_achieve_pid() ->
%%     server:get_mod_pid(?MODULE).
%% %%--------------------------------------------------------------------
%% %% @doc 添加成就
%% %% @spec
%% %% @end
%% %%--------------------------------------------------------------------
%% add_achieve(PlayerID, Type, TaskID, Times) ->
%%     gen_server:cast(get_mod_achieve_pid(), {add_achieve, PlayerID, Type, TaskID, Times}).

%% %%--------------------------------------------------------------------
%% %% @doc
%% %% @spec
%% %% @end
%% %%--------------------------------------------------------------------
%% show_achieve_reward(Player, AchieveID) ->
%%     gen_server:call(get_mod_achieve_pid(), {show_achieve_reward, Player, AchieveID}).

%% %%--------------------------------------------------------------------
%% %% @doc 领取成就奖励
%% %% @spec
%% %% @end
%% %%--------------------------------------------------------------------
%% receive_achieve_reward(Player, AchieveID) ->
%%     gen_server:call(get_mod_achieve_pid(), {receive_achieve_reward, Player, AchieveID}).

%% %%--------------------------------------------------------------------
%% %% @doc 当前成就进度
%% %% @spec
%% %% @end
%% %%--------------------------------------------------------------------
%% get_current_player_all_achieve(Player) ->
%%     gen_server:call(get_mod_achieve_pid(), {get_current_player_all_achieve, Player}).

%% %%--------------------------------------------------------------------
%% %% @doc
%% %% Starts the server
%% %%
%% %% @spec start_link() -> {ok, Pid} | ignore | {error, Error}
%% %% @end
%% %%--------------------------------------------------------------------
%% start_link(ProcessName, WorkerNumber, Worker_id, WeightLoad) ->      
%%     gen_server:start_link(?MODULE, [ProcessName, WorkerNumber, Worker_id, WeightLoad], []).

%% %%--------------------------------------------------------------------
%% %% @doc
%% %% start 
%% %% @spec
%% %% @end
%% %%--------------------------------------------------------------------
%% start(ProcessName, WorkerNumber, Worker_id, WeightLoad) ->      
%%     gen_server:start(?MODULE, [ProcessName, WorkerNumber, Worker_id, WeightLoad], []).

%% %%%===================================================================
%% %%% gen_server callbacks
%% %%%===================================================================

%% %%--------------------------------------------------------------------
%% %% @private
%% %% @doc
%% %% Initializes the server
%% %%
%% %% @spec init(Args) -> {ok, State} |
%% %%                     {ok, State, Timeout} |
%% %%                     ignore |
%% %%                     {stop, Reason}
%% %% @end
%% %%--------------------------------------------------------------------
%% init([ProcessName, WorkerNumber, Worker_id, WeightLoad]) ->
%%     process_flag(trap_exit, true),
%%     misc:register(local, ProcessName, self()),
%%     if 
%%         Worker_id =:= 0 ->
%%             %%监控进程
%%             misc:write_monitor_pid(self(), node, {?MODULE, WorkerNumber, WeightLoad}),
%%             %%系统信息
%%             misc:write_system_info(self(), ?MODULE, {}),
%%             lists:foreach(
%%               fun(WorkerId) -> 
%%                       ProcessName_1 = misc:create_process_name(?MODULE, [WorkerId]),
%%                       start(ProcessName_1, WorkerNumber, WorkerId, WeightLoad)
%%               end,
%%               lists:seq(1, WorkerNumber));
%%         true ->
%%             misc:write_monitor_pid(self(), mod_achieve_worker, {Worker_id})
%%     end,
%%     {ok, #state{worker_id = Worker_id}}.

%% %%--------------------------------------------------------------------
%% %% @private
%% %% @doc
%% %% Handling call messages
%% %%
%% %% @spec handle_call(Request, From, State) ->
%% %%                                   {reply, Reply, State} |
%% %%                                   {reply, Reply, State, Timeout} |
%% %%                                   {noreply, State} |
%% %%                                   {noreply, State, Timeout} |
%% %%                                   {stop, Reason, Reply, State} |
%% %%                                   {stop, Reason, State}
%% %% @end
%% %%--------------------------------------------------------------------
%% handle_call({show_achieve_reward, Player, AchieveID}, _From, State) ->
%%     ?DEBUG("show player achieve~n", []),
%%     Reply = 
%%         try
%%             lib_achieve:show_achieve_reward(Player, AchieveID)
%%         catch 
%%             _:Reason ->
%%                 ?ERROR_MSG("Error ~w~n, Stack~p~n", [Reason, erlang:get_stacktrace()]),
%%                 {fail, ?INFO_RECEIVE_ACHIEVE_REWARD_ERROR}
%%         end,
%%     {reply, Reply, State};

%% handle_call({receive_achieve_reward, Player, AchieveID}, _From, State) ->
%%     ?DEBUG("receive player achieve~n", []),
%%     Reply = 
%%         try
%%             lib_achieve:receive_achieve_reward(Player, AchieveID)
%%         catch 
%%             _:Reason ->
%%                 ?ERROR_MSG("Error ~w~n, Stack~p~n", [Reason, erlang:get_stacktrace()]),
%%                 {fail, ?INFO_RECEIVE_ACHIEVE_REWARD_ERROR}
%%         end,
%%     {reply, Reply, State};

%% handle_call({get_current_player_all_achieve, Player}, _From, State) ->
%%     ?DEBUG("get current achieve id~n", []),
%%     Reply = 
%%         try
%%             {ok, lib_achieve:get_current_player_all_achieve(Player#player.id)}
%%         catch 
%%             _:Reason ->
%%                 ?ERROR_MSG("Error ~w~n, Stack~p~n", [Reason, erlang:get_stacktrace()]),
%%                 {fail, ?INFO_ACHIEVE_CONF_ERROR}
%%         end,
%%     {reply, Reply, State};


%% handle_call(_Request, _From, State) ->
%%     Reply = ok,
%%     {reply, Reply, State}.

%% %%--------------------------------------------------------------------
%% %% @private
%% %% @doc
%% %% Handling cast messages
%% %%
%% %% @spec handle_cast(Msg, State) -> {noreply, State} |
%% %%                                  {noreply, State, Timeout} |
%% %%                                  {stop, Reason, State}
%% %% @end
%% %%--------------------------------------------------------------------
%% handle_cast({add_achieve, PlayerID, Type, TaskID, Times}, State) ->
%%     ?DEBUG("add player achieve~n", []),
%%     try
%%         lib_achieve:add_achieve(PlayerID, Type, TaskID, Times)
%%     catch 
%%         _:Reason ->
%% 	    ?ERROR_MSG("Error ~w~n, Stack~p~n", [Reason, erlang:get_stacktrace()])
%%     end,
%%     {noreply, State};

%% handle_cast(_Msg, State) ->
%%     {noreply, State}.

%% %%--------------------------------------------------------------------
%% %% @private
%% %% @doc
%% %% Handling all non call/cast messages
%% %%
%% %% @spec handle_info(Info, State) -> {noreply, State} |
%% %%                                   {noreply, State, Timeout} |
%% %%                                   {stop, Reason, State}
%% %% @end
%% %%--------------------------------------------------------------------
%% handle_info(_Info, State) ->
%%     {noreply, State}.

%% %%--------------------------------------------------------------------
%% %% @private
%% %% @doc
%% %% This function is called by a gen_server when it is about to
%% %% terminate. It should be the opposite of Module:init/1 and do any
%% %% necessary cleaning up. When it returns, the gen_server terminates
%% %% with Reason. The return value is ignored.
%% %%
%% %% @spec terminate(Reason, State) -> void()
%% %% @end
%% %%--------------------------------------------------------------------
%% terminate(_Reason, _State) ->
%%     misc:delete_monitor_pid(self()),
%%     misc:delete_system_info(self()),
%%     ok.

%% %%--------------------------------------------------------------------
%% %% @private
%% %% @doc
%% %% Convert process state when code is changed
%% %%
%% %% @spec code_change(OldVsn, State, Extra) -> {ok, NewState}
%% %% @end
%% %%--------------------------------------------------------------------
%% code_change(_OldVsn, State, _Extra) ->
%%     {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

