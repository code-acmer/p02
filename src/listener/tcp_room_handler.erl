-module(tcp_room_handler).

-behaviour(gen_server).

%% API
-export([
         start_link/1,
         get_state/1,        
         send/2, send_info/2
        ]).

%% gen_server callbacks
-export([init/1,
         handle_call/3,
         handle_cast/2,
         handle_info/2,
         terminate/2,
         code_change/3]).

-define(SERVER, ?MODULE). 

%% -record(socket_statistics, {recv_cnt = 0,
%%                             recv_fouled = 0}).

-include("define_logger.hrl").
-include("pb_9_pb.hrl").
-include("define_time.hrl").
-include("define_login.hrl").


-define(TCP_TIMEOUT, 10 * 1000).        % 解析协议超时时间
-define(HEART_TIMEOUT, 60 * 60 * 1000). % 心跳包超时时间
-define(HEART_TIMEOUT_TIME, 10).        % 心跳包超时次数
-define(HEADER_LENGTH, 4).              % 消息头长度
-define(SOCKET_ALLOW_REC_PER,   30).    % 指定时间的收包量
-define(SOCKET_ALLOW_FOUL_TIMES, 1).    % 允许超出的次数
-define(SOCKET_CHECK_DELTA,  10000).    % 发包频率检测
-define(TIMEOUT, 120000).

%% Protocol Len
-define(PACKET_LEN_BITS, 16).
-define(PLAYER_ID_BITS,  32).
-define(SESSION_BITS,    32).
-define(CMD_BITS,        16).

%%%===================================================================
%%% API
%%%===================================================================
get_state(Ref) ->
    gen_server:call(Ref, get_state).

send(Pid, Msg) 
  when is_pid(Pid)->
    case Msg of
        {lists, BinaryList} ->
            gen_server:cast(Pid, {cmd_send_binary_list, BinaryList});
        Other ->
            gen_server:cast(Pid, {cmd_send, Other})
    end;
send(Pid, Msg) ->
    ?WARNING_MSG("not pid pid=~w, msg=~w", [Pid, Msg]),
    ignore.

send_info(Pid, Info)
  when is_pid(Pid), is_integer(Info) ->
    gen_server:cast(Pid, {cmd_send_info, Info});
send_info(Pid, Info) ->
    ?WARNING_MSG("not match pid=~w, info=~w", [Pid, Info]),
    ignore.
    

%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @spec start_link() -> {ok, Pid} | ignore | {error, Error}
%% @end
%%--------------------------------------------------------------------
start_link(Socket) ->
    gen_server:start_link(?MODULE, [Socket], [{fullsweep_after, 30}]).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Initializes the server
%%
%% @spec init(Args) -> {ok, State} |
%%                     {ok, State, Timeout} |
%%                     ignore |
%%                     {stop, Reason}
%% @end
%%--------------------------------------------------------------------
init([Socket]) ->
    erlang:process_flag(min_bin_vheap_size, 64*1024),
    inet:setopts(Socket, 
                 [{active, once}, {packet, 2}, {header, 10}, binary]),
    {ok, {IP, _Port}} = inet:peername(Socket),
    State = #client{
               socket = Socket,
               addr   = IP,
               client_pid = self()
	      },
    ?DEBUG("IP ~p connected, for socket ~p on ~p.\n", [IP, Socket, _Port]),
    %% 启动收包检测功能
    %% erlang:send_after(?SOCKET_CHECK_DELTA, self(), cmd_socket_statistics),
    {ok, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling call messages
%%
%% @spec handle_call(Request, From, State) ->
%%                                   {reply, Reply, State} |
%%                                   {reply, Reply, State, Timeout} |
%%                                   {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, Reply, State} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
handle_call(get_state, _From, State) ->
    {reply, State, State};
handle_call(_Request, _From, State) ->
    {reply, ok, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling cast messages
%%
%% @spec handle_cast(Msg, State) -> {noreply, State} |
%%                                  {noreply, State, Timeout} |
%%                                  {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------

handle_cast({cmd_send, BinData}, #client{socket = Socket} = State) ->
    %% ?DEBUG("cmd_send ~p~n", [self()]),
    gen_tcp:send(Socket, BinData),
    {noreply, State};
handle_cast({cmd_send_binary_list, BinDataList},
            #client{socket = Socket} = State) ->
    %% ?DEBUG("cmd_send ~p~n", [self()]),
    lists:foreach(fun(BinData) ->
                          gen_tcp:send(Socket, BinData)
                  end, BinDataList),
    {noreply, State};
handle_cast({cmd_send_info, ErrorCode}, #client{socket = Socket} = State) ->
    {ok, BinData} = pt:pack(9001, #pberror{error_code = ErrorCode}),
    gen_tcp:send(Socket, BinData),
    {noreply, State};
%% handle_cast({cmd_send_player_delta, []}, State) ->
%%     %% 空的变更，什么都不处理
%%     {noreply, State};
%% handle_cast({cmd_send_player_delta, UpdatePlayer}, 
%%             #client{socket = Socket} = State) ->
%%     {ok, BinData} = pt_13:write(13018, UpdatePlayer),
%%     %% ?DEBUG("client player changed: ~p~n", [UpdatePlayer]),
%%     gen_tcp:send(Socket, BinData),
%%     {noreply, State};
handle_cast(mod_player_stopped, State) ->
    {stop, normal, State};
handle_cast(stop_no_notice, State) ->
    %% 这是顶号，不通知mod_player说socket进程坏掉了，因为这是mod_player通知过来的。
    {stop, normal, State#client{player_id=0}};
handle_cast(Msg, State) ->
    ?WARNING_MSG("Unknown Msg ~w~n", [Msg]),
    {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling all non call/cast messages
%%
%% @spec handle_info(Info, State) -> {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
handle_info({tcp, Socket, Data}, State) ->
    ?WARNING_MSG("receive data: ~p~n", [Data]),
    inet:setopts(Socket, [{active, once}]),
    {noreply, State};
 
handle_info({tcp_closed, _Socket}, #client{addr = Addr} = StateData) ->
    ?DEBUG("IP ~p disconnected~n", [Addr]),
    {stop, normal, StateData};

handle_info({'DOWN', MonitorRef, Type, Object, Info}, State) ->
    %% handle info for monitor
    ?INFO_MSG("Down Info ~p~n", 
              [{MonitorRef, Type, Object, Info}]),
    %% not notice player
    {stop, Info, State#client{player_id=0}};

handle_info(Info, State) ->
    ?WARNING_MSG("Unknown Info ~p~n", [Info]),
    {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any
%% necessary cleaning up. When it returns, the gen_server terminates
%% with Reason. The return value is ignored.
%%
%% @spec terminate(Reason, State) -> void()
%% @end
%%--------------------------------------------------------------------
terminate(Reason, #client{
                      player_id = PlayerId,
                      socket = Socket
                     }) ->
    ?DEBUG("tcp_client_handler stop Reason ~p~n", [Reason]),
    if 
        PlayerId =/= 0 ->
            ?DEBUG("Player ~p disconnect ~n", [PlayerId]),
            mod_player:tcp_disconnect(PlayerId);
        true ->
            ingore
    end,
    (catch gen_tcp:close(Socket)),
    ok.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Convert process state when code is changed
%%
%% @spec code_change(OldVsn, State, Extra) -> {ok, NewState}
%% @end
%%--------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

