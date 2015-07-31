%%%-------------------------------------------------------------------
%%% @author Roowe <bestluoliwe@gmail.com>
%%% @copyright (C) 2013, Roowe
%%% @doc
%%%
%%% @end
%%% Created : 25 Oct 2013 by Roowe <bestluoliwe@gmail.com>
%%%-------------------------------------------------------------------
-module(tcp_client_handler).

-behaviour(gen_server).

%% API
-export([
         start_link/1,
         get_state/1,
         stop/1,
         stop_no_notice/1,
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

-define(SOCKET_ALLOW_REC_ONE_MIN,   200).    % 每分钟收包量
%% -record(socket_statistics, {recv_cnt = 0,
%%                             recv_fouled = 0}).

-include("define_logger.hrl").
-include("pb_9_pb.hrl").
-include("pb_10_pb.hrl").
-include("define_info_10.hrl").
-include("define_time.hrl").
-include("define_login.hrl").
-include("define_log.hrl").


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

stop(Pid) ->
    gen_server:cast(Pid, mod_player_stopped).

stop_no_notice(Pid) ->
    gen_server:cast(Pid, stop_no_notice).

send(Pid, Msg) 
  when is_pid(Pid)->
     gen_server:cast(Pid, {cmd_send,Msg});
send(Pid, Msg) ->
    ?WARNING_MSG("not pid pid=~w, msg=~w", [Pid, Msg]),
    ignore.

send_info(Pid, Info)
  when is_pid(Pid), is_integer(Info) ->
    {ok, BinData} = pt:pack(9001, #pberror{error_code = Info}),
    send(Pid, BinData);
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
    erlang:process_flag(trap_exit, true),
    ok = 
        inet:setopts(Socket, 
                     [{active, ?SOCKET_ALLOW_REC_ONE_MIN}, {packet, 2}, {header, 11}, {delay_send, true}, binary]),
    ?DEBUG("~p~n", [prim_inet:getopts(Socket, [sndbuf, recbuf,packet, header, active, nodelay, keepalive, priority, tos,buffer,delay_send,packet_size,high_watermark, low_watermark,sndbuf,exit_on_close,send_timeout, packet_size, high_msgq_watermark, low_msgq_watermark])]),
    %?DEBUG(" ~p~n", [inet:getstat(Socket)]),
    case inet:peername(Socket) of
        {ok, {IP, _Port}} ->
            State = #client{
                       socket = Socket,
                       addr   = IP,
                       client_pid = self(),
                       active_timestamp = time_misc:unixtime()
                      },
            ?DEBUG("IP ~p connected, for socket ~p on ~p.\n", [IP, Socket, _Port]),
            %% 启动收包检测功能
            %% erlang:send_after(?SOCKET_CHECK_DELTA, self(), cmd_socket_statistics),
            {ok, State};
        {error, Reason} ->
            ?WARNING_MSG("tcp_client_handler init stop reason ~p~n", [Reason]),
            gen_tcp:close(Socket),
            {stop, normal}
    end.
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
handle_cast({cmd_send, Msg}, #client{socket = Socket} = State) ->
    %% <<Cmd:16>> = hd(Msg),
    %% put(last_send_packet, {Cmd, Msg}),
    case packet_misc:send(Socket, Msg) of
        keep_alive ->
            {noreply, State};
        shutdown ->
            {stop, normal, State}
    end;
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
    ?WARNING_MSG("mod_player stopped cast ~n", []),
    {stop, normal, State};
handle_cast(stop_no_notice, State) ->
    %% 这是顶号，不通知mod_player说socket进程坏掉了，因为这是mod_player通知过来的。
    {stop, normal, State#client{player_id=0,
                                player_pid = undefined}};
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
handle_info({tcp, Socket, [P1, P2, P3, P4,
                           S1, S2, S3, S4,
                           C1, C2, F| PBBinary]},
            #client{rc4 = OriRC4} = State) ->
    <<PlayerId:32>> = <<P1, P2, P3, P4>>,
    <<RecvSession:32>> = <<S1, S2, S3, S4>>,
    <<Cmd:16>> = <<C1, C2>>,
    {{ok, Data}, NewRC4} = case OriRC4 of
                             undefined when Cmd =/= 10100 ->
                                 {ok, OldRC4} = mod_player:get_rc4(PlayerId),
                                 ?DEBUG("Load Rc4 from mod_player ~p~n",[OldRC4]),
                                 put(rc4_key, OldRC4),
                                 inner_unpack(Cmd, PBBinary, OldRC4);
                             OriRC4 ->
                                 inner_unpack(Cmd, PBBinary, OriRC4)
                         end,
    %% = pt:unpack(Cmd, PBBinary),
    case inner_check_session(Cmd, RecvSession, PlayerId, State#client{rc4 = NewRC4}) of
        {ok, #client{player_pid = Pid} = NState} ->
            if
                Cmd =:= 10100 ->
                    NewState = case pp_account:handle(10100, NState, Data) of
                                   {ok, NewClient} ->
                                       NewClient;
                                   %% {noreply, NewClient};
                                   _->
                                       packet_misc:put_info(?INFO_LOGIN_ACCID_FAIL),
                                       NState
                               end,
                    send_packet_reply(packet_misc:send_packet(10100, 0, Socket), NewState);
                Cmd =:= 10000 ->
                    Begin = os:timestamp(),
                    %statistics:proto_handle_start(10000),
                    NState2 = 
                        case pp_account:handle(10000, NState, Data) of
                            {fail, Reason} ->
                                %% login failed
                                packet_misc:put_info(Reason),
                                NState;
                            {ok, NewState} ->
                                %% lib_log_player:log(#log_player{
                                %%                       event_id = ?LOG_EVENT_ONLINE,
                                %%                       arg1 = PlayerId,
                                %%                       arg2 = hmisc:to_32bit_ip(NewState#client.addr)
                                %%                      }),
                                NewState
                        end,
                    End = os:timestamp(),
                    statistics:proto(10000, timer:now_diff(End, Begin)),
                    %statistics:proto_handle_end(10000),
                    send_packet_reply(packet_misc:send_packet(10000, 0, Socket), NState2);
                Cmd =:= 10001 ->
                    Begin = os:timestamp(),
                    %%statistics:proto_handle_start(10001),
                    NewState = 
                        case pp_account:handle(10001, NState, PlayerId) of
                            {fail, Reason} ->
                                packet_misc:put_info(Reason),
                                NState;
                            {ok, #client{rc4 = NewRc4} = NewState2} ->
                                {ok, Bin} = pt_10:write(10001, <<>>),
                                packet_misc:put_packet(Bin),
                                case NewRc4 of
                                    RC4 ->
                                        ignored;
                                    _ ->
                                        put(rc4_key, NewRc4)
                                end,
                                NewState2
                        end,
                    Flag = mod_player:get_last_flag(PlayerId),
                    ?DEBUG("Flag ~p~n", [Flag]),
                    %%statistics:proto_handle_end(10001),
                    End = os:timestamp(),
                    statistics:proto(10001, timer:now_diff(End, Begin)),
                    send_packet_reply(packet_misc:send_packet(10001, Flag, Socket), NewState);                        
                Cmd =:= 10003 ->
                    Begin = os:timestamp(),
                    NewState = 
                        case pp_account:handle(10003, NState, Data) of
                            {fail, Reason} ->
                                packet_misc:put_info(Reason),
                                NState;
                            {ok, NewState2} ->
                                NewState2
                        end,
                    End = os:timestamp(),
                    statistics:proto(10003, timer:now_diff(End, Begin)),
                    send_packet_reply(packet_misc:send_packet(10003, 0, Socket), NewState);
                %%加入心跳包
                Cmd =:= 10008 ->
                    NBin = [<<10008:16>>, <<>>],
                    send_packet_reply(packet_misc:send(Socket, NBin), NState);
                true ->
                    mod_player:cmd_socket_event(Pid, {F, Cmd, Data}),
                    {noreply, NState}
                    %% case maybe_send_cache(F, Cmd, Socket) of
                    %%     shutdown ->
                    %%         {stop, normal, NState};
                    %%     cache_send ->
                    %%         {noreply, NState};
                    %%     no_cache ->
                    %%         mod_player:cmd_socket_event(Pid, {F, Cmd, Data}),
                    %%         %gen_server:cast(Pid, {cmd_socket_event, Cmd, Data}),
                    %%         {noreply, NState}
                    %% end
            end;
        _ ->
            {ok, Bin} = pt:pack(10030, #pbid32{id = ?SESSION_INVALID}),
            packet_misc:put_packet(Bin),
            send_packet_reply(packet_misc:send_packet(9002, 0, Socket), State)
    end;

handle_info({tcp, _Socket, Data}, State) ->
    ?WARNING_MSG("receive unexpect data: ~p~n", [Data]),
    %inet:setopts(Socket, [{active, once}]),
    {noreply, State};

handle_info({tcp_passive, Socket}, #client{
                                      player_id = PlayerId,
                                      active_timestamp = ActiveTimeStamp
                                     } = State) ->
    Now = time_misc:unixtime(),
    if
        Now - ActiveTimeStamp =< ?ONE_MINITE_SECONDS ->
            ?WARNING_MSG("~p send packet too fast", [PlayerId]),
            {stop, normal, State};
        true ->
            inet:setopts(Socket, [{active, ?SOCKET_ALLOW_REC_ONE_MIN}]),
            {noreply, State#client{
                        active_timestamp = Now
                       }}
    end;

handle_info({tcp_closed, _Socket}, #client{addr = Addr} = StateData) ->
    ?DEBUG("IP ~p disconnected~n", [Addr]),
    {stop, normal, StateData};

%% handle_info({'DOWN', MonitorRef, Type, Object, Info}, State) ->
%%     %% handle info for monitor
%%     erlang:demonitor(MonitorRef, [flush]),
%%     ?INFO_MSG("Down Info ~p~n", 
%%               [{MonitorRef, Type, Object, Info}]),
%%     %% not notice player
%%     {stop, Info, State#client{player_id=0}};

handle_info({'EXIT', _Pid, Reason}, State) ->
    ?DEBUG("tcp_client_handler recv EXIT Reason ~p~n", [Reason]),
    {stop, normal, State};
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
                     player_pid = PlayerPid,
                     socket = Socket
                     }) ->
    ?DEBUG("tcp_client_handler stop Reason ~p~n", [Reason]),
    if
        is_pid(PlayerPid) ->
            unlink(PlayerPid),
            mod_player:tcp_disconnect(PlayerPid);
        true ->
            skip
    end,
    %% 不用主动发消息，通过退出信号
    %% if 
    %%     PlayerId =/= 0 ->
    %%         ?DEBUG("Player ~p disconnect ~n", [PlayerId]),
    %%         mod_player:tcp_disconnect(PlayerId);
    %%     true ->
    %%         ingore
    %% end,
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
%% @doc tcp_client_handler没有存储着Session，尝试去玩家进程拿
inner_check_session(10100, _, _, State) ->
    {ok, State};
inner_check_session(10000, _, _, State) ->
    {ok, State};
inner_check_session(Cmd, RecvSession, _, #client{session = Session} = State)
  when Cmd =:= 10003 orelse Cmd =:= 10001 ->
    if
        RecvSession =:= Session ->
            {ok, State};
        true ->
            fail
    end;
%%断线重连？
inner_check_session(_, RecvSession, PlayerId,
                    #client{
                       session = Session
                      } = State)
  when Session =:= undefined ->
    {PlayerSession, PlayerSessionTimeStamp} = mod_player:get_session(PlayerId),
    case check_session_timeout(PlayerSessionTimeStamp) of
        false ->
            if
                PlayerSession =:= RecvSession ->
                    NState = mod_player:update_client_info(PlayerId, State),
                    ?DEBUG("tcp_client_handler  update_client_info done.~n",[]),
                    {ok, NState#client{session_timestamp = time_misc:unixtime()}};
                true ->
                    ?WARNING_MSG("RecvSession ~p, NewSession ~p~n", [RecvSession, PlayerSession]),
                     {check_session_err, State}
            end;
        true ->
            {session_timeout, State}
    end;
inner_check_session(_, Session, PlayerId,
                    #client{
                       session_timestamp = SessionTimeStamp,
                       session           = Session,
                       player_id         = PlayerId
                      } = State) ->
    %% TODO: no need to do to_integer in future
    case check_session_timeout(SessionTimeStamp) of
        true ->
            ?WARNING_MSG("Session Timeout~n", []),
            {session_timeout, State};
        false ->
            {ok, State#client{session_timestamp = time_misc:unixtime()}}
    end;
inner_check_session(_, _, RecvPlayerId, 
                    #client{
                       player_id = PlayerId
                      } = State) ->
    ?WARNING_MSG("RecvPlayerId ~w, PlayerId ~w~n", [RecvPlayerId, PlayerId]),
    {check_session_err, State}.

check_session_timeout(SessionTimeStamp) ->
    time_misc:unixtime() - SessionTimeStamp >= ?SESSION_TIMEOUT.

send_packet_reply(keep_alive, State) ->
    {noreply, State};
send_packet_reply(ignore, State) ->
    {noreply, State};
send_packet_reply(shutdown, State) ->
    {stop, normal, State}.

%% maybe_send_cache(0, _, _) ->
%%     no_cache;
%% maybe_send_cache(1, Cmd, Socket) ->
%%     case get(last_send_packet) of
%%         {Cmd, BinData} ->
%%             ?DEBUG("send cache Cmd ~p~n", [Cmd]),              
%%             case packet_misc:send(Socket, BinData) of
%%                 keep_alive ->
%%                     cache_send;
%%                 shutdown ->
%%                     shutdown
%%             end;
%%         _ ->
%%             no_cache
%%     end.

inner_unpack(Cmd, PBBinary, RC4) ->
    RET = case Cmd of
              Cmd when Cmd =:= 10100 ->
                  pt:unpack(Cmd, PBBinary);
              _ ->
                  %% ?DEBUG("PBBINARY : ~p Using RC4 : ~p~n",[PBBinary, RC4]),
                  {_NewRC4, NewPBBinary} = crypto:stream_decrypt(RC4, PBBinary),
                  %% ?DEBUG("NewPBBinary : ~p~n",[NewPBBinary]),
                  pt:unpack(Cmd, NewPBBinary)
          end,
    {RET, RC4}.
