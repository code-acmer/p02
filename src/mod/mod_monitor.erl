%%%------------------------------------
%%% @Module     : mod_monitor
%%% @Created    : 2012.01.07
%%% @Description: 平台监控接口
%%% @Author	: HeeJan
%%%------------------------------------
-module(mod_monitor).
-behaviour(gen_server).

-include("define_logger.hrl").

%% --------------------------------------------------------------------
-export([
         start_link/0
         %% chatmsg/1
        ]).

-export([
         init/1, 
         handle_call/3, 
         handle_cast/2, 
         handle_info/2,
         get_player_count/0,
         reset_player_online_count/0,
         set_player_online_count/0,
         terminate/2, 
         code_change/3]).

-define(NoConn, no_conn).

-define(DEFAULT_HOST, "113.107.161.101").
-define(DEFAULT_PORT, 4399).

%%重连间隔
-define(RECONN_INTV, 30).

%%-define(DEFAULT_PORT, 5555).
%%-define(DEFAULT_HOST,"192.168.5.39").

-record(state, 
        {tcpsocket = ?NoConn, 
         work      = true,
         player_count = 0}).

%% ====================================================================


set_player_online_count() ->
    %% mnesia:dirty_update_counter(player_count, player_count, 1).
    gen_server:cast(?MODULE, {cmd_update_player_count, 1}).
reset_player_online_count() ->
    %% mnesia:dirty_update_counter(player_count, player_count, -1).
    gen_server:cast(?MODULE, {cmd_update_player_count, -1}).

get_player_count() ->
    gen_server:call(?MODULE, cmd_query_player_count).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% --------------------------------------------------------------------
init([]) ->
    hmisc:write_monitor_pid(self(), ?MODULE, {0}),
    %% Socket = try_reconnect(?NoConn),
    Work =
        case app_misc:get_env(can_gmcmd) of
            1 ->
                false;
            _ ->
                true
	end,
    {ok, #state{work = Work}}.

%% chatmsg(FinalStr)->
%%     gen_server:cast(?MODULE , {cmd_chatmsg, FinalStr}).

%% --------------------------------------------------------------------
handle_call(cmd_query_player_count, _From, 
            #state{player_count = PlayerCount} = State) ->
    %% ?DEBUG("current player count: ~p~n", [PlayerCount]),
    {reply, PlayerCount, State};
handle_call(Request, From, State) ->
    %%io:format("unexpected call ~w from ~w", [Request, From]),
    ?ERROR_MSG("unexpected call ~w from ~w", [Request, From]),
    {reply, ok, State}.

%% --------------------------------------------------------------------
handle_cast({cmd_update_player_count, Count}, 
            #state{player_count = PCount} = State) ->
    NewCount = mnesia:dirty_update_counter(
                   player_count, player_count, Count),
    ?WARNING_MSG("NewCount : ~w~n",[NewCount]),
    %?DEBUG("new player count: ~p~n", [NewCount]),
    {noreply, State#state{player_count = PCount + Count}};
%% handle_cast({cmd_chatmsg, Msg}, State) ->
%%     %% ?ERROR_MSG("XXXXXXXXXXXXXXX monitor get chatmsg: ~ts" , [Msg]),
%%     %% Msg是个list ，并且每发一条要\r\n分隔
%%     Socket = State#state.tcpsocket,
%%     if
%%         State#state.work =:= false ->
%%             {noreply, State};
%%         Socket == ?NoConn ->
%%             %%试着重连
%%             NewSocket = try_reconnect(Socket),
%%             %%简单点略过此聊天信息，连上也懒得发，反正不重要
%%             {noreply, State#state{tcpsocket = NewSocket} };
%%         true->
%%             case gen_tcp:send(Socket,util:thing_to_list(Msg ++ [13,10])) of
%%                 ok->
%%                     %%Host = inet:peername(Socket) ,
%%                     %%?ERROR_MSG("OOOOK send ~p" , [Host]),	
%%                     ?DEBUG("~n Send Msg=~p",[Msg]),
%%                     {noreply, State};
%%                 Other->	
%%                     ?ERROR_MSG("send fail ,reason ,~p ~p" ,[Other, Socket]),
%%                     NewSocket = try_reconnect(Socket),
%%                     {noreply, State#state{tcpsocket = NewSocket} }
%%             end
%%     end;
handle_cast(Msg, State) ->
    ?ERROR_MSG("unexpected cast ~w", [Msg]),
    {noreply, State}.

%% --------------------------------------------------------------------

handle_info({reconn, IP, Port, PackLen}, State)->
    %% debug code:
    %% global:send(mgeec_monitor,{reconn,"113.107.161.101",4398,0}).
    %% io:format("XXXXXXXXXXXXXXX reconnect to ~s ~p" , [IP,Port]),

    case State#state.tcpsocket of
        ?NoConn ->
            nil;
        _-> 
            gen_tcp:close(State#state.tcpsocket)
    end,

    %%?ERROR_MSG("Close OK ",[]),
    case gen_tcp:connect( IP,Port ,[binary,{packet,PackLen}] ,10000) of
        {ok,Socket} ->
            %%Host = inet:peername(Socket) ,
            %%?ERROR_MSG("XXXXXXXXXXXXXXX reconnect OOOOOOOOKKKKKK ~p  " , [Host]),	
            %%gen_tcp:send(Socket,<<100:16>>),

            {noreply, State#state{tcpsocket = Socket}};
        _Other->
            %%?ERROR_MSG("XXXXXXXXXXXXXXX reconnect Faile ,reason ~p" , [_Other]),

            {noreply, State}
    end;
handle_info(stop_work,State)->
    {noreply, State#state{work=false}};
handle_info(start_work,State)->
    {noreply, State#state{work=true}};
handle_info({tcp_closed, _}, State) ->
    {noreply, State#state{tcpsocket = ?NoConn}};
handle_info(_Info, State) ->
    %%?INFO_MSG("unexpected info ~w", [_Info]),
    {noreply, State}.

%% --------------------------------------------------------------------
terminate(Reason, State) ->
    hmisc:delete_monitor_pid(self()),
    ?ERROR_MSG("mod_monitor ~w terminate : ~w, ~w",
               [self(), Reason, State]),
    ok.

%% --------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

try_reconnect(S)->
    %% 一段时间重试
    case get(last_try_conn) of
        undefined->
            %%允许重置
            put(last_try_conn, time_misc:unixtime()),
            try_reconnect_2(S);
        LastTry->
            Diff  = time_misc:unixtime() - LastTry,
            %%?ERROR_MSG("TimeDiff Diff:~p  ,LastTry:~p",[Diff,LastTry]),
            case Diff>?RECONN_INTV of
                true->
                    put(last_try_conn, time_misc:unixtime()),
                    try_reconnect_2(S);
                false->
                    S
            end
    end.

try_reconnect_2(S)->
    %% 关闭
    case S of
        ?NoConn ->
            nil;
        _-> 
            catch gen_tcp:close(S)
    end,

    %%新建
    NewSocket = 
        case gen_tcp:connect(
               ?DEFAULT_HOST, ?DEFAULT_PORT, [binary, {packet, 0}], 10000) of
            {ok, Socket} ->
                %%io:format("Connection OK !!!! ",[]),
                %%?ERROR_MSG("Connection OK !!!! ",[]),
                Socket;
            Error ->
                ?ERROR_MSG("Connection Err !!!! ~p Dest:~p, ~p",
                           [Error, ?DEFAULT_HOST, ?DEFAULT_PORT]),
                ?NoConn
        end,
    NewSocket.

