%%%-------------------------------------------------------------------
%%% @author Zhangr <>
%%% @copyright (C) 2013, Zhangr
%%% @doc
%%%
%%% @end
%%% Created : 12 Sep 2013 by Zhangr <>
%%%-------------------------------------------------------------------
-module(udp_client_handler).

%% -behaviour(gen_fsm).

%% %% API
%% -export([start_link/1]).

%% %% gen_fsm callbacks
%% -export([init/1, state_name/2, state_name/3, handle_event/3,
%%          handle_sync_event/4, handle_info/3, terminate/3, code_change/4]).
%% -export([not_login/2, login_success/2, enter_world/2]).

%% -define(SERVER, ?MODULE).

%% -record(state, {socket, addr, client}).
%% -record(socket_statistics, {recv_cnt = 0,
%%                             recv_fouled = 0}).

%% -include("define_logger.hrl").
%% -include("define_login.hrl").
%% -include("pb_10_pb.hrl").
%% -include("define_info_10.hrl").
%% -include("fcm.hrl").

%% -define(TCP_TIMEOUT, 10 * 1000).        % 解析协议超时时间
%% -define(HEART_TIMEOUT, 60 * 60 * 1000). % 心跳包超时时间
%% -define(HEART_TIMEOUT_TIME, 10).        % 心跳包超时次数
%% -define(HEADER_LENGTH, 4).              % 消息头长度
%% -define(SOCKET_ALLOW_REC_PER,   30).    % 指定时间的收包量
%% -define(SOCKET_ALLOW_FOUL_TIMES, 1).    % 允许超出的次数
%% -define(SOCKET_CHECK_DELTA,  10000).    % 发包频率检测
%% -define(TIMEOUT, 120000).


%% %%%===================================================================
%% %%% API
%% %%%===================================================================

%% %%--------------------------------------------------------------------
%% %% @doc
%% %% Creates a gen_fsm process which calls Module:init/1 to
%% %% initialize. To ensure a synchronized start-up procedure, this
%% %% function does not return until Module:init/1 has returned.
%% %%
%% %% @spec start_link() -> {ok, Pid} | ignore | {error, Error}
%% %% @end
%% %%--------------------------------------------------------------------
%% start_link(Socket) ->
%% 	gen_fsm:start_link(?MODULE, [Socket], []).

%% %%%===================================================================
%% %%% gen_fsm callbacks
%% %%%===================================================================

%% %%--------------------------------------------------------------------
%% %% @private
%% %% @doc
%% %% Whenever a gen_fsm is started using gen_fsm:start/[3,4] or
%% %% gen_fsm:start_link/[3,4], this function is called by the new
%% %% process to initialize.
%% %%
%% %% @spec init(Args) -> {ok, StateName, State} |
%% %%                     {ok, StateName, State, Timeout} |
%% %%                     ignore |
%% %%                     {stop, StopReason}
%% %% @end
%% %%--------------------------------------------------------------------
%% init([Socket]) ->
%% 	inet:setopts(Socket, [{active, once}, {packet, 0}, binary]),
%%     Client = #client{
%%                 player_pid = undefined,
%%                 login      = 0,
%%                 accid      = 0,
%%                 accname    = undefined,
%%                 timeout    = 0,
%%                 socket     = Socket},
%%     {ok, {IP, _Port}} = inet:peername(Socket),
%%     ?DEBUG("~p Client ~p connected, for socket ~p.\n", [self(), IP, Socket]),
%%     %% 启动收包检测功能
%%     erlang:send_after(?SOCKET_CHECK_DELTA, self(), cmd_socket_statistics),
%%     {ok, not_login, #state{socket = Socket, addr = IP, client = Client}}.

%% %%--------------------------------------------------------------------
%% %% @private
%% %% @doc
%% %% There should be one instance of this function for each possible
%% %% state name. Whenever a gen_fsm receives an event sent using
%% %% gen_fsm:send_event/2, the instance of this function with the same
%% %% name as the current state name StateName is called to handle
%% %% the event. It is also called if a timeout occurs.
%% %%
%% %% @spec state_name(Event, State) ->
%% %%                   {next_state, NextStateName, NextState} |
%% %%                   {next_state, NextStateName, NextState, Timeout} |
%% %%                   {stop, Reason, NewState}
%% %% @end
%% %%--------------------------------------------------------------------

%% %% @doc 未登录状态
%% %% @spec
%% %% @end
%% not_login({tcp, Socket, <<_Len:16, 10000:16, BinData/binary>>}, State) ->
%%     %% BinLen = Len - ?HEADER_LENGTH,
%%     %% <<CheckedBinData:BinLen, _/binary>> = BinData,
%%     %% NewBin = unicode:characters_to_binary(BinData, utf8, latin1),
%%     {ok, Data} = pt:unpack(10000, BinData),
%%     %% ?DEBUG("10000 data: ~p~n", [Data]),
%%     case pp_account:handle(10000, Socket, State#state.client, Data) of
%%         {ok, NewClient} ->
%%             %% 登录成功
%%             {next_state, login_success, State#state{client = NewClient}, ?TIMEOUT};
%%         {timeout, NewClient} ->
%%             %% 登录超时
%%             {next_state, not_login, State#state{client = NewClient}, ?TIMEOUT};
%%         {deny, NewClient} ->
%%             %% 登录被拒绝
%%             {next_state, not_login, State#state{client = NewClient}, ?TIMEOUT};
%%         {fail, _} ->
%%             %% 登录失败
%%             {next_state, not_login, State, ?TIMEOUT};
%%         _ ->
%%             {next_state, not_login, State, ?TIMEOUT}
%%     end;
%% not_login({tcp, Socket, <<_Len:16, 10009:16, BinData/binary>>}, State) ->
%%     %% 日志记录
%%     {ok, Data} = pt:unpack(10009, BinData),
%%     pp_account:handle(10009, Socket, State#state.client, Data),
%%     {next_state, not_login, State, ?TIMEOUT};
%% not_login({tcp, Socket, <<_Len:16, 10010:16, BinData/binary>>}, State) ->
%%     {ok, Data} = pt:unpack(10010, BinData),
%%     case pp_account:handle(10010, Socket, State#state.client, Data) of
%%         {true, AccId, RoleId, _NickName} ->
%%             %% 登录成功
%%             {ok, Bin} = pt_10:write(10010, {AccId, RoleId, State#state.client#client.accname}),
%%             lib_send:send_one(Socket, Bin),
%%             {next_state, enter_world, State, ?TIMEOUT};
%%         fail ->
%%             %% 登录失败
%%             {next_state, not_login, State, ?TIMEOUT}
%%     end;
%% not_login({tcp, Socket, <<_Len:16, 10020:16, BinData/binary>>}, State) ->
%%     %% 随机名申请
%%     {ok, #pbid32{id = Sex}} = pt:unpack(10020, BinData),
%%     {ok, Bin} = pt:pack(10020, #pbid32r{id = mod_random_role_name:random_name(Sex)}),
%%     lib_send:send_one(Socket, Bin),
%%     {next_state, not_login, State, ?TIMEOUT};
%% not_login({tcp, Socket, Data}, State) ->
%%     %% http请求回调
%%     ?WARNING_MSG("unknown handle in not login: ~p~n", [Data]),
%%     {next_state, not_login, State, ?TIMEOUT};
%% not_login(timeout, State) ->
%%     %% 连接超时了
%%     ?DEBUG("~p timeout: ~p~n", [self(), State#state.socket]),
%%     {stop, normal, State};
%% not_login(Data, State) ->
%%     ?WARNING_MSG("~p Ignoring data in not_login: ~p~n", [self(), Data]),
%%     {next_state, not_login, State, ?TIMEOUT}.

%% %% @doc 登录成功状态
%% login_success({tcp, Socket, <<_Len:16, Cmd:16, BinData/binary>>}, #state{client = Client} = State) ->
%%     %% 读取角色列表
%%     {ok, Data} = pt:unpack(Cmd, BinData),
%%     %% 登录成功后才允许进行的操作
%%     case pp_account:handle(Cmd, Socket, Client, Data) of
%%         {enter_world, NewClient} ->
%%             %% 进入到游戏世界
%%             {next_state, enter_world, State#state{client = NewClient}, ?TIMEOUT};
%%         _ ->
%%             {next_state, login_success, State, ?TIMEOUT}
%%     end;
%% login_success(timeout, State) ->
%%     ?WARNING_MSG("~p Client connection timeout - closing.\n", [self()]),
%%     {stop, normal, State};
%% login_success(Data, State) ->
%%     ?WARNING_MSG("~p Ignoring data in login_success: ~p\n", [self(), Data]),
%%     {next_state, login_success, State, ?TIMEOUT}.

%% %% @doc 进入游戏状态，此时已经有角色进程
%% %% @spec
%% %% @end
%% enter_world({tcp, _Socket, <<_Len:16, Cmd:16, BinData/binary>>}, 
%%             #state{client = Client} = State) ->
%%     %% 初始化角色进程后的回调，交给mod_player进程进行处理
%%     gen_server:cast(Client#client.player_pid, {socket_event, Cmd, BinData}),
%%     {next_state, enter_world, State, ?TIMEOUT};
%% enter_world(timeout, State) ->
%%     {stop, normal, State};
%% enter_world(Data, State) ->
%%     ?WARNING_MSG("~p Ignoring data in enter_world: ~p\n", [self(), Data]),
%%     {next_state, enter_world, State, ?TIMEOUT}.

%% state_name(_Event, State) ->
%%     {next_state, state_name, State}.

%% %%--------------------------------------------------------------------
%% %% @private
%% %% @doc
%% %% There should be one instance of this function for each possible
%% %% state name. Whenever a gen_fsm receives an event sent using
%% %% gen_fsm:sync_send_event/[2,3], the instance of this function with
%% %% the same name as the current state name StateName is called to
%% %% handle the event.
%% %%
%% %% @spec state_name(Event, From, State) ->
%% %%                   {next_state, NextStateName, NextState} |
%% %%                   {next_state, NextStateName, NextState, Timeout} |
%% %%                   {reply, Reply, NextStateName, NextState} |
%% %%                   {reply, Reply, NextStateName, NextState, Timeout} |
%% %%                   {stop, Reason, NewState} |
%% %%                   {stop, Reason, Reply, NewState}
%% %% @end
%% %%--------------------------------------------------------------------
%% state_name(_Event, _From, State) ->
%%     Reply = ok,
%%     {reply, Reply, state_name, State}.

%% %%--------------------------------------------------------------------
%% %% @private
%% %% @doc
%% %% Whenever a gen_fsm receives an event sent using
%% %% gen_fsm:send_all_state_event/2, this function is called to handle
%% %% the event.
%% %%
%% %% @spec handle_event(Event, StateName, State) ->
%% %%                   {next_state, NextStateName, NextState} |
%% %%                   {next_state, NextStateName, NextState, Timeout} |
%% %%                   {stop, Reason, NewState}
%% %% @end
%% %%--------------------------------------------------------------------
%% handle_event(_Event, StateName, State) ->
%%     {next_state, StateName, State}.

%% %%--------------------------------------------------------------------
%% %% @private
%% %% @doc
%% %% Whenever a gen_fsm receives an event sent using
%% %% gen_fsm:sync_send_all_state_event/[2,3], this function is called
%% %% to handle the event.
%% %%
%% %% @spec handle_sync_event(Event, From, StateName, State) ->
%% %%                   {next_state, NextStateName, NextState} |
%% %%                   {next_state, NextStateName, NextState, Timeout} |
%% %%                   {reply, Reply, NextStateName, NextState} |
%% %%                   {reply, Reply, NextStateName, NextState, Timeout} |
%% %%                   {stop, Reason, NewState} |
%% %%                   {stop, Reason, Reply, NewState}
%% %% @end
%% %%--------------------------------------------------------------------
%% handle_sync_event(_Event, _From, StateName, State) ->
%%     Reply = ok,
%%     {reply, Reply, StateName, State}.

%% %%--------------------------------------------------------------------
%% %% @private
%% %% @doc
%% %% This function is called by a gen_fsm when it receives any
%% %% message other than a synchronous or asynchronous event
%% %% (or a system message).
%% %%
%% %% @spec handle_info(Info,StateName,State)->
%% %%                   {next_state, NextStateName, NextState} |
%% %%                   {next_state, NextStateName, NextState, Timeout} |
%% %%                   {stop, Reason, NewState}
%% %% @end
%% %%--------------------------------------------------------------------
%% handle_info({tcp, Socket, Bin}, not_login, State) ->
%%     %% Flow control: enable forwarding of next TCP message
%%     inet:setopts(Socket, [{active, once}]),
%%     not_login({tcp, Socket, Bin}, State);
%% handle_info({tcp, Socket, Bin}, login_success, State) ->
%%     inet:setopts(Socket, [{active, once}]),
%%     login_success({tcp, Socket, Bin}, State);
%% handle_info({tcp, Socket, Bin}, enter_world, State) ->
%%     inet:setopts(Socket, [{active, once}]),
%%     enter_world({tcp, Socket, Bin}, State);
%% handle_info({tcp_closed, _Socket}, _StateName, StateData) ->
%%     {stop, normal, StateData};
%% handle_info(cmd_socket_statistics, StateName, #state{socket = Socket} = State) ->
%%     erlang:send_after(?SOCKET_CHECK_DELTA, self(), cmd_socket_statistics),
%%     case inet:getstat(Socket, [recv_cnt]) of
%%         {ok, [{recv_cnt, RecvCnt}]} ->
%%             case inner_update_socket_statistics(RecvCnt) of
%%                 ok ->
%%                     %% 检测通过了，继续
%%                     {next_state, StateName, State};
%%                 fail ->
%%                     %% 检测失败了，直接关闭该socket
%%                     ?WARNING_MSG("~p socket recv too much data: ~p", [self(), RecvCnt]),
%%                     {stop, normal, State}
%%             end;
%%         Other ->
%%             ?WARNING_MSG("~p socket inet failed: ~p~n", [self(), Other]),
%%             {stop, normal, State}
%%     end;
%% handle_info(_Info, StateName, State) ->
%%     {next_state, StateName, State}.

%% %%--------------------------------------------------------------------
%% %% @private
%% %% @doc
%% %% This function is called by a gen_fsm when it is about to
%% %% terminate. It should be the opposite of Module:init/1 and do any
%% %% necessary cleaning up. When it returns, the gen_fsm terminates with
%% %% Reason. The return value is ignored.
%% %%
%% %% @spec terminate(Reason, StateName, State) -> void()
%% %% @end
%% %%--------------------------------------------------------------------
%% terminate(_Reason, enter_world, #state{socket = Socket, client = Client}) ->
%%     %% 断开连接前，先发送信息给客户端
%%     {ok, BinData} = pt_10:write(10007, ?STOP_REASON_NORMAL),
%%     lib_send:send_one(Socket, BinData),
%%     mod_player:stop(Client#client.player_pid, ?STOP_REASON_NORMAL),
%%     (catch gen_tcp:close(Socket)),
%%     ok;
%% terminate(_Reason, _StateName, #state{socket = Socket, addr = Addr}) ->
%%     ?DEBUG("~p Client ~p disconnected, for socket ~p.\n", [self(), Addr, Socket]),
%%     (catch gen_tcp:close(Socket)),
%%     ok.

%% %%--------------------------------------------------------------------
%% %% @private
%% %% @doc
%% %% Convert process state when code is changed
%% %%
%% %% @spec code_change(OldVsn, StateName, State, Extra) ->
%% %%                   {ok, StateName, NewState}
%% %% @end
%% %%--------------------------------------------------------------------
%% code_change(_OldVsn, StateName, State, _Extra) ->
%%     {ok, StateName, State}.

%% %%%===================================================================
%% %%% Internal functions
%% %%%===================================================================

%% %% @doc 更新统计状态
%% inner_update_socket_statistics(NewCnt) ->
%%     case get(socket_statistics) of
%%         undefined ->
%%             %% 初始化统计数据
%%             put(socket_statistics, #socket_statistics{recv_cnt = NewCnt}),
%%             ok;
%%         #socket_statistics{recv_cnt = OldCnt,
%%                            recv_fouled = OldFouled} = OldStat ->
%%             if
%%                 NewCnt - OldCnt > ?SOCKET_ALLOW_REC_PER ->
%%                     %% 犯规，记一次
%%                     NewFouled = OldFouled + 1,
%%                     put(socket_statistics, 
%%                         OldStat#socket_statistics{recv_cnt = NewCnt,
%%                                                   recv_fouled = NewFouled}),
%%                     if
%%                         NewFouled > ?SOCKET_ALLOW_FOUL_TIMES ->
%%                             %% 检测到多次超标，判定为非法
%%                             fail;
%%                         true ->
%%                             ok
%%                     end;
%%                 true ->
%%                     put(socket_statistics, OldStat#socket_statistics{recv_cnt = NewCnt}),
%%                     ok
%%             end
%%     end.

