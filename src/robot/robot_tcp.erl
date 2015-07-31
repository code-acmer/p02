-module(robot_tcp).
-export([send_and_recv/3,
         connect/1, ensure_connect/1]).

%-export([test/0]).

-include("define_robot.hrl").
%-define(SER_IP, "192.168.1.177").
%-define(SER_IP, "115.236.76.12").
%-define(SER_IP, "127.0.0.1").
-define(PORT, 9999).
-define(SER_IP, "192.168.1.149").
%% -define(PORT, 7701).
-ifdef(TCP_OPTS).
-undef(TCP_OPTS).
-endif.
-define(TCP_OPTS, [
                   binary,
                   {packet, 2},
                   {header, 2},
                   {reuseaddr, true},   % allow rebind without waiting
                   {nodelay, false},
                   {delay_send, true},
                   {active, false},
                   {send_timeout, 300},
                   {exit_on_close, false}
                  ]).

-define(TCP_TIMEOUT, 10000).
-define(TCP_RECV_TIMEOUT, 10000).

-define(LAST_REPLY_CMD, 9002).

connect(Robot) when is_record(Robot, ct_robot) ->
    #account_info{
       ip=Ip, 
       port=Port 
      } = Robot#ct_robot.account,
    ?DEBUG("ip ~p, port ~p ~n",[Ip, Port]),
    {ok, Socket} = gen_tcp:connect(Ip, Port, ?TCP_OPTS, ?TCP_TIMEOUT),
    Robot#ct_robot{socket=Socket};
connect(Robot) ->
    ?WARNING_MSG("Robot ~p~n", [Robot]),
    Robot.

ensure_connect(#ct_robot{
                  socket = Socket
                 } = Robot) when is_port(Socket) ->
    %% 如果socket已经close了，调用gen_tcp:send不会报错。但是使用gen_tcp:recv的话，socket关闭的话，错误会返回closed
    %% 从而判断socket是否可用
    %% 注意gen_tcp:close(Socket)之后，recv依旧返回closed的错误
    case gen_tcp:recv(Socket, 0, 0) of
        {error, closed} ->
            gen_tcp:close(Socket), %% close的socket，如果不主动调用close，会有端口泄露
            connect(Robot);
        {error, timeout} ->
            Robot;
        {ok, [C1,C2|BinData]} ->
            Cmd = C1 * 256 + C2,
            RecData = pt:unpack_client(BinData),
            PtModule = lib_robot:pt_module(Cmd),
            ?WARNING_MSG("recv server HEAD CMD ~p RecData ~p~n", [Cmd, RecData]),
            NewRobot1 = 
                case catch lib_robot:check_pt_module_function_exist(PtModule, {recv, 3}) of
                    ok ->
                        {ok, NewRobot} = PtModule:recv(Cmd, Robot, RecData),
                        NewRobot;
                    _ ->
                        Robot
                end,
            recv_all_data(NewRobot1, Socket)
    end;
ensure_connect(Robot) ->
    connect(Robot).
    
recv_all_data(Robot, Socket) ->
    case gen_tcp:recv(Socket, 0, 0) of
        {ok, [C1,C2|BinData]} ->
            Cmd = C1 * 256 + C2,
            RecData = pt:unpack_client(BinData),
            PtModule = lib_robot:pt_module(Cmd),
            ?WARNING_MSG("recv server packet HEAD CMD ~p RecData ~p~n", [Cmd, RecData]),
            NewRobot1 = 
                case catch lib_robot:check_pt_module_function_exist(PtModule, {recv, 3}) of
                    ok ->
                        {ok, NewRobot} = PtModule:recv(Cmd, Robot, RecData),
                        NewRobot;
                    _ ->
                        Robot
                end,
            recv_all_data(NewRobot1, Socket);
        _ ->
            Robot
    end.


send_and_recv(#ct_robot{
                 socket = Socket,
                 player_id = PlayerId,
                 session = Session
                }, Cmd, Rec) -> 
    ?DEBUG("Cmd ~p, PlayerId ~p Packet ~p~n", [Cmd, PlayerId, Rec]),
    {ok, Packet} = pt:pack_client(Cmd, PlayerId, Session, Rec),
    send_and_recv_packet(Cmd, Socket, Packet).


send_and_recv_packet(Cmd, Socket, Packet) ->
    ?DEBUG("send_packet, Binary ~p~n", [Packet]),
    case gen_tcp:send(Socket, Packet) of
        ok ->
            ?DEBUG("send_and_recv_packet, send ok~n", []),
            recv(Cmd, Socket);
        {error, SendReason} ->
            ?WARNING_MSG("send_and_recv_packet: ERROR ~p ~n", [SendReason]),
            []
    end.
   

recv(Cmd, Socket) ->
    case gen_tcp:recv(Socket, 0, ?TCP_RECV_TIMEOUT) of
        {ok, [C1, C2|BinData]} ->
            Cmd = C1 * 256 + C2,
            RecData = pt:unpack_client(BinData),          
            ?DEBUG("RecvData ~p~n", [RecData]),
            RecData;
        {error, closed} ->
            ?WARNING_MSG("Socket ~p closed", [Socket]),
            [];
        {error, RecvReason} ->            
            ?WARNING_MSG("Socket ~p, not recv data RecvReason ~p~n", [Socket, RecvReason]),
            []
    end.

%% %% for test
%% test() ->
%%     lib_robot:ensure_ibrowse_started(),
%%     lib_robot:ensure_logger(),
%%     #ct_robot{socket=Socket} = connect(#ct_robot{}),
%%     case get_acc_info_from_php() of
%%         {ok, [AccId, Timestamp, LoginTicket]} ->
%%             Rec = #pbaccount{
%%                      suid = AccId,
%%                      timestamp = list_to_integer(Timestamp),
%%                      login_ticket = LoginTicket,
%%                      server_id = 1,
%%                      acc_name = "weiwei"
%%                     },   
%%             {ok, Packet} = pt:pack_client(10000, 11, 11, Rec),
%%             RecvData = send_and_recv_packet(Socket, Packet),
            
%%             case lib_robot:get_pb(10000, RecvData) of
%%                 {ok, #pbaccountlogin{
%%                        user_info = [#pbuserlogininfo{user_id=PlayerId}|_],
%%                        session = Session
%%                       }} ->
%%                     {ok, Packet13001} = pt:pack_client(13001, PlayerId, Session, <<>>),
%%                     send_and_recv_packet(Socket, Packet13001),
%%                     receive
%%                     after 30000 ->
%%                             ?DEBUG("isSocket ~p~n", [is_port(Socket)]),
%%                             send_and_recv_packet(Socket, Packet13001)
%%                     end;
%%                 _ ->
%%                     ingore
%%             end,
            
%%             gen_tcp:close(Socket);
%%         _ ->
%%             err
%%     end.



%% get_acc_info_from_php() ->
%%     lib_robot:get_acc_info_from_php("weiwei", "weiwei").



