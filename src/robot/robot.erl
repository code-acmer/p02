%% 该robot不会用来压力测试，
%% 仅仅是开发期间方便构造数据包来进行初期的测试，
%% 压力测试会有专门的模块，集成测试写ct去。
-module(robot).
-behaviour(gen_server).
-include("define_robot.hrl").

%% API

-export([start/1, start/0]).
-export([
         %% start/0,
         test_pt/1,
         test_pt/2,
         get_state/0,
         stop/0,
         connect/0,
         disconnect/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-define(SERVER, ?MODULE). 

-ifdef(TCP_OPTS).
-undef(TCP_OPTS).
-endif.
-define(TCP_OPTS, [
                   binary,
                   {packet, 2},
                   {header, 3},
                   {reuseaddr, true},   % allow rebind without waiting
                   {nodelay, false},
                   {delay_send, true},
                   {active, false},
                   {exit_on_close, false}
                  ]).
-define(TCP_CONNECT_TIMEOUT, 10000).


%%%===================================================================
%%% API
%%%===================================================================
opt_spec_list() ->
    [
     {accname, undefined, "accname", {string, weiwei}, "机器人账户"},
     {server_ip, undefined, "server_ip", {string, "127.0.0.1"}, "服务器IP"},
     {port, undefined, "port", {integer, 8801}, "服务器端口"}
    ].

get_accname(CmdLine) ->
    {ok, {Opts, []}} =  getopt:parse(opt_spec_list(), CmdLine),
    Opts.

start() ->
    Opts = get_accname(init:get_plain_arguments()),
    AccName = proplists:get_value(accname, Opts),
    ServerIP = proplists:get_value(server_ip, Opts),
    Port = proplists:get_value(port, Opts),
    start(#state{accname = AccName,
                 acc_passwd = AccName,
                 server_ip = ServerIP,
                 port = Port
                }).

count_rc4_info() ->
    [P, G] = crypto:dh_generate_parameters(64, 5),
    {PubClient, PriClient} = crypto:generate_key(dh, [P, G]),
    {P, G, PubClient, PriClient}.

test_pt(Cmd) ->
    test_pt(Cmd, []).

test_pt(Cmd, Args) when is_list(Args)->
    do_cast({send, Cmd, Args});
test_pt(_Cmd, Args) ->
    ?WARNING_MSG("Args not list ~p~n", [Args]).


get_state() ->
    do_call(get_state).

disconnect() ->
    do_cast(disconnect).

connect() ->
    do_cast(connect).

stop() ->
    do_cast(stop).

start(Robot) ->
    gen_server:start({local, ?SERVER}, ?MODULE, [Robot], []).


do_call(Request) ->
    handle_msg(Request, call).

do_cast(Msg) ->
    handle_msg(Msg, cast).

handle_msg(Request, Method) ->
    Ref = erlang:monitor(process, ?SERVER),
    receive {'DOWN', Ref, _Type, _Object, noproc} -> 
            erlang:demonitor(Ref),
            {ok, _} = start(),
            timer:sleep(1000), %% waiting login
            handle_msg(Request, Method)
    after 0 ->
	    Return = gen_server:Method(?SERVER, Request),
	    erlang:demonitor(Ref, [flush]),
	    Return
    end.


    
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
init([#state{
         server_ip = ServerIP,
         port = Port
        } = Robot]) ->
    hloglevel:set(6),
    ssl:start(),
    ibrowse:start_link(),
    mod_cache:start_link(),
    application:start(hstdlib),
    Rc4Info = count_rc4_info(),
    io:format("rc4_info : ~p~n", [Rc4Info]),
    put(rc4_info, Rc4Info),
    case gen_tcp:connect(ServerIP, Port, ?TCP_OPTS, ?TCP_CONNECT_TIMEOUT) of
        {ok, Socket} ->
            inet:setopts(Socket, [{active, once}, binary]),
            NewRobot = Robot#state{
                         socket = Socket,
                         pid = self()
                        },
            %test_pt(10000),   %%因为加入了服务器号,还是自己输入要登陆哪个服
            test_pt(10100),
            {ok, NewRobot};
        Err ->
            ?DEBUG("Start ServerIP ~p, Port~p Err ~p~n", [ServerIP, Port, Err]),
            {stop, normal, #state{}}
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
    Reply = ok,
    {reply, Reply, State}.

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
handle_cast({send, Cmd, Args}, #state{socket=undefined}=OState) ->
    ?DEBUG("reconnect server ~n", []),
    State = reconnect(OState),
    {ok, Keep, NState} = pt_send(Cmd, Args, State),
    keep_alive_or_close(Keep, NState);
handle_cast({send, Cmd, Args}, State) ->
    {ok, Keep, NState} = pt_send(Cmd, Args, State),
    keep_alive_or_close(Keep, NState);
handle_cast(disconnect, State) ->
    gen_tcp:close(State#state.socket),
    {noreply, State#state{socket=undefined}};
handle_cast(connect, State) ->    
    {noreply, reconnect(State)};
handle_cast(stop, State) ->
    ?DEBUG("recv Stop~n", []),
    {stop, normal, State};
handle_cast(_Msg, State) ->
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
%% 10000登陆协议
handle_info({tcp, Socket, [39, 16, _F| BinData]}, #state{last_msg=LastMsg}=State) ->
    inet:setopts(Socket, [{active, once}]),
    ?DEBUG("Recv Cmd ~w, BinData ~p", [10000, BinData]),
    [{10000, #pbaccountlogin{
                user_info = UserInfo,
                session = Session
              } = Rec}] = pt:unpack_client(BinData),
    ?DEBUG("Recv ~p ~p~n", [10000, Rec]), 
    PlayerId =
        case UserInfo of
            [HD|_] ->
                HD#pbuserlogininfo.user_id;
            _ ->
                ?WARNING_MSG("Rec ~p~n", [Rec]),
                erlang:send_after(300, self(), {send, 10003}),
                0
        end,                
    NState = State#state{session=Session, player_id=PlayerId},
    {noreply, NState#state{last_msg = [{10000, Rec} | LastMsg]}};
%% %% 10003创建角色
%% handle_info({tcp, Socket,[39, 19 | BinData]}, #state{last_msg=LastMsg}=State) ->
%%     inet:setopts(Socket, [{active, once}]),
%%     ?DEBUG("Cmd ~w, BinData ~p", [10003, BinData]),
%%     {ok, #pbuserresult{
%%             user_id = UserId
%%            } = Rec} = pt:unpack_client(10003, BinData),
%%     ?DEBUG("Recv ~p ~p~n", [10003, Rec]),
%%     NState = State#state{player_id=UserId},
%%     {noreply, NState#state{last_msg = [{10003, Rec}|LastMsg]}};
%% %% 9001错误码
%% handle_info({tcp, Socket,[35, 41 | BinData]}, #state{last_msg=LastMsg}=State) ->
%%     inet:setopts(Socket, [{active, once}]),
%%     ?DEBUG("Cmd ~w, BinData ~p", [9001, BinData]),
%%     {ok, #pberror{
%%             error_code = ErrorCode
%%            }=Rec} = pt:unpack_client(9001, BinData),
%%     case data_base_error_list:get(ErrorCode) of
%%         [] ->
%%             ?DEBUG("Recv 9001 ~p~n", [ErrorCode]);
%%         #base_error_list{
%%            error_desc = ErrorDesc
%%           } ->
%%             ?DEBUG("Recv 9001 ~p ~ts~n", [ErrorCode, ErrorDesc])
%%     end,
%%     {noreply, State#state{last_msg = [{9001, Rec}|LastMsg]}};

%% %% 10030 session error, relogin 10000
%% handle_info({tcp, Socket,[39, 46 | _BinData]}, 
%%             #state{
%%                last_send = {Cmd, Rec}
%%               }=State) ->
%%     inet:setopts(Socket, [{active, once}]),
%%     test_pt(10000),
%%     ?DEBUG("will resend ~p Data ~p~n", [Cmd, Rec]),
%%     erlang:send_after(1000, self(), {send, Cmd, Rec}),
%%     {noreply, State};

handle_info({tcp, Socket,[C1, C2, F| BinData]}, #state{last_msg=LastMsg}=State) ->
    inet:setopts(Socket, [{active, once}]),
    <<Cmd:16>> = <<C1, C2>>,
    ?DEBUG("Recv head Cmd ~p F ~p~n", [Cmd, F]),
    RecDatas = pt:unpack_client(BinData),
    print_recv_rec(RecDatas),
    {noreply, State#state{last_msg = [{Cmd, RecDatas}| LastMsg]}};

handle_info({tcp_closed, Socket}, #state{socket=Socket}=State) ->
    ?DEBUG("Recv tcp_closed~n", []),
    (catch gen_tcp:close(Socket)),
    {noreply, State#state{socket=undefined}};
handle_info(timeout, State) ->
    test_pt(self(), 13001),
    {noreply, State, 9000};
handle_info({send, Cmd, Rec}, State) ->
    {ok, Keep, NState} = send(Cmd, Rec, State),
    keep_alive_or_close(Keep, NState);
handle_info({send, Cmd}, State) ->
    test_pt(Cmd),
    {noreply, State};
handle_info({send_bin, Bin}, #state{
                                socket=Socket
                               }=State) ->
    send(Socket, Bin),
    {noreply, State};
handle_info(Info, State) ->
    ?DEBUG("Unknow Info ~p~n", [Info]),
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
terminate(Reason, _State) ->
    ?DEBUG("Recv Stop, Reason ~p~n", [Reason]),
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

send(Cmd, Rec, #state{
                  session = Session,
                  player_id = PlayerId,
                  socket = Socket
                 }=State) 
  when is_tuple(Rec) orelse Rec =:= <<>> ->
    ?DEBUG("send ... ~p ~p~n", [Cmd, pretty_print_record(Rec)]),
    {ok, Bin} = pt:pack_client(Cmd, PlayerId, Session, Rec),
    {ok, send(Socket, Bin), State#state{last_msg = [], last_send={Cmd, Rec}}};
send(Cmd, OtherData, State) ->
    ?WARNING_MSG("send not match {Cmd, OtherData} ~p~n", [{Cmd, OtherData}]),
    {ok, keep_alive, State}.

send(Socket, Bin) 
  when is_port(Socket)->
    case gen_tcp:send(Socket, Bin) of
        ok ->
            ?DEBUG("send ok~n", []),
            keep_alive;
        _ ->
            shutdown
    end.

pt_send(Cmd, Args, State) ->
    Prefix = Cmd div 1000,
    RobotPt = hmisc:to_atom(lists:concat([robot_pt_send, "_", Prefix])),
    RunPtFun  = fun
                  ([]) ->
                      RobotPt:pack_rec(Cmd, State);
                  (RobotArgs) ->
                      RobotPt:pack_rec(Cmd, State, RobotArgs)
              end,
    {Rec, NewStatus} = 
        try 
            case RunPtFun(Args)  of
                {TmpRec, TmpStatus} when is_record(TmpStatus, state) ->
                    {TmpRec, TmpStatus};
                TmpRec when is_tuple(TmpRec) orelse TmpRec =:= <<>> ->
                    {TmpRec, State};
                Other ->
                    ?WARNING_MSG("Other ~p~n", [Other]),
                    {error, State}
            end
        catch Error:Reason->
                ?WARNING_MSG("Error ~p, Reason ~p~n", [Error, Reason]),
                ?WARNING_MSG("Stack ~p~n", [erlang:get_stacktrace()]),  
                {error, State}
        end,
    send(Cmd, Rec, NewStatus).

keep_alive_or_close(Keep, State) ->
    if 
        Keep /= keep_alive ->
            ?DEBUG("Stop, Keep /= keep_alive~n", []),
            gen_tcp:close(State#state.socket),
            {stop, normal, State};
        true ->
            {noreply, State}
    end.

reconnect(#state{
             server_ip = ServerIP,
             port = Port
            } = State) ->
    case gen_tcp:connect(ServerIP, Port, ?TCP_OPTS, ?TCP_CONNECT_TIMEOUT) of
        {ok, Socket} ->
            inet:setopts(Socket, [{active, once}]),
            State#state{
              socket = Socket
             };
        Err ->
            ?DEBUG("Connect Err ~p~n", [Err]),
            State
    end.



pr(Record) ->    
    RecordName = element(1, Record),
    case all_record:get_fields(RecordName) of
        [] ->
            Record;
        RecordFields ->                                        
            lists:zip(RecordFields, tl(tuple_to_list(Record)))
    end.

short_record(undefined) ->
    undefined;
short_record([]) ->
    [];
%% for repeat field, it is a tuple list
short_record(RecordList) 
  when is_list(RecordList),
       is_tuple(hd(RecordList)) ->
    [short_record(Record) || Record <- RecordList];
short_record(Record) 
  when is_tuple(Record) ->
    case pr(Record) of
        Record ->
            Record;
        ValList ->
            {element(1, Record), 
             lists:reverse(lists:foldl(fun({Field, Val}, Acc) ->
                                               case short_record(Val) of
                                                   undefined ->
                                                       Acc;
                                                   ShortVal ->
                                                       [{Field, ShortVal}|Acc]
                                               end
                                       end, [], ValList))}
    end;
short_record(Other) ->
    Other.

pretty_print_record(Record) ->
    short_record(Record).

print_recv_rec([]) ->
    ?WARNING_MSG("recv rec data [] ~n", []);
print_recv_rec(RecDatas) ->
    lists:foreach(fun
                      ({Cmd, <<>>}) ->
                          ?DEBUG("Recv Cmd ~p, <<>>~n", [Cmd]);
                      ({9001, #pberror{error_code = ErrorCode}}) ->
                          case data_base_error_list:get(ErrorCode) of
                              [] ->
                                  ?DEBUG("Recv 9001 ~p~n", [ErrorCode]);
                              #base_error_list{
                                 error_desc = ErrorDesc
                                } ->
                                  ?DEBUG("Recv 9001 ~p ~ts~n", [ErrorCode, ErrorDesc])
                          end;
                      ({Cmd, Rec}) ->
                          ?DEBUG("Recv Cmd ~p, ~p ~p ~n", [Cmd, element(1, Rec), pretty_print_record(Rec)])
                  end, RecDatas).
