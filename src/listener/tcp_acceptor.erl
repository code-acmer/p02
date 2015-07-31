%%%-----------------------------------
%%% @Module  : tcp_acceptor
%%% @Created : 2011.06.01 
%%% @Description: tcp acceptor
%%%-----------------------------------
-module(tcp_acceptor).
-behaviour(gen_server).
-export([start_link/2]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-include("define_logger.hrl").
-record(state, {
          sock,
          ref,
          callback_mod
         }).

start_link(Module, LSock) ->
    %% ?PRINT("trying to start acceptor:~w~n",[LSock]),
    gen_server:start_link(?MODULE, [Module, LSock], []).

init([Module, LSock]) ->
    %% ?PRINT("ACCEPTOR UP~n",[]),
    process_flag(trap_exit, true),
	hmisc:write_monitor_pid(self(),?MODULE, {}),
    gen_server:cast(self(), accept),
    {ok, #state{
            sock = LSock,
            callback_mod = Module
           }}.

handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_cast(accept, State) ->
    accept(State);

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info({inet_async, LSock, Ref, {ok, Sock}}, State = #state{callback_mod=Module, sock=LSock, ref=Ref}) ->
    case set_sockopt(LSock, Sock) of
        ok -> ok;
        {error, Reason} -> exit({set_sockopt, Reason})
    end,
    start_client(Module, Sock),
    accept(State);

handle_info({inet_async, LSock, Ref, {error, closed}}, State=#state{sock=LSock, ref=Ref}) ->
    {stop, normal, State};

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, State) ->
    gen_tcp:close(State#state.sock),
	hmisc:delete_monitor_pid(self()),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%-------------私有函数--------------

set_sockopt(LSock, Sock) ->
    true = inet_db:register_socket(Sock, inet_tcp),
    case prim_inet:getopts(LSock, [active, nodelay, keepalive, priority, tos]) of
        {ok, Opts} ->
            Opts2 = [{delay_send,false} | Opts],
            case prim_inet:setopts(Sock, Opts2) of
                ok    -> ok;
                Error -> 
                    gen_tcp:close(Sock),
                    Error
            end;
        Error ->
            gen_tcp:close(Sock),
            Error
    end.


accept(State = #state{sock=LSock}) ->
    case prim_inet:async_accept(LSock, -1) of
        {ok, Ref} -> {noreply, State#state{ref=Ref}};
        Error     -> {stop, {cannot_accept, Error}, State}
    end.

%% 开启客户端服务
start_client(Module, CSocket) ->
    %% {ok, Child} = supervisor:start_child(tcp_client_sup, []),
    %% ok = gen_tcp:controlling_process(Sock, Child),
    %% Child ! {go, Sock}.

    case listener_sup:start_child(Module, CSocket) of
        {ok, Pid} ->
            %% Assigns a new controlling process Pid to Socket
            case catch gen_tcp:controlling_process(CSocket, Pid) of
                ok ->
                    pass;
                {error, ReasonTcp} ->
                    ?WARNING_MSG("controlling process failed: ~p~n",
                                 [ReasonTcp]);
                Other ->
                    ?WARNING_MSG("controlling process failed: ~p~n", [Other])
            end;
        {error, Reason2} ->
            ?WARNING_MSG("~p start_child failed: ~p~n",
                         [self(), Reason2])
    end.
%% case tcp_client_handler:start_link(CSocket) of
%%     {ok, Pid} ->
%%         %% Assigns a new controlling process Pid to Socket
%%         case gen_tcp:controlling_process(CSocket, Pid) of
%%             ok ->
%%                 pass;
%%             {error, ReasonTcp} ->
%%                 ?WARNING_MSG("controlling process failed: ~p~n",
%%                              [ReasonTcp])
%%         end;
%%     {error, Reason2} ->
%%         ?WARNING_MSG("~p start_child failed: ~p~n",
%%                      [self(), Reason2])
%% end.
