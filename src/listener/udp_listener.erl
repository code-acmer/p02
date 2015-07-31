%%%-----------------------------------
%%% @Module  : udp_listener
%%% @Created : 2011.06.01 
%%% @Description: tcp listerner监听
%%%-----------------------------------

-module(udp_listener).
%% -behaviour(gen_server).

%% -export([start_link/1]).
%% -export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2,
%%          code_change/3]).

%% -include("define_logger.hrl").
%% -include("define_network.hrl").
 
%% -record(state,
%%         {
%%           listener,       % Listening socket
%%           acceptor,       % Asynchronous acceptor's internal reference
%%           active,         % Active info
%%           module          % FSM handling module
%%         }).
 
%% start_link(Port)
%%   when is_integer(Port) ->
%%     gen_server:start_link({local, ?MODULE}, ?MODULE, [Port], []).
 
%% init([Port]) ->
%%     process_flag(trap_exit, true),
%%     hmisc:write_monitor_pid(self(), ?MODULE, {}),
%%     case gen_udp:open(Port, ?UDP_OPTIONS) of
%%         {ok, ListenSocket} ->
%%             %% Create first accepting process
%%             %% proc_lib:init_ack(Module, {ok, self()}),
%%             {ok, Ref} = prim_inet:async_accept(ListenSocket, -1),
%%             gen_server:cast(self(), {cmd_recv_message}),
%%             {ok, #state{listener = ListenSocket,
%%                         acceptor = Ref,
%%                         active   = proplists:get_value(active, ?UDP_OPTIONS)}};
%%         {error, Reason} ->
%%             {stop, Reason}
%%     end.

%% handle_call(_Request, _From, State) ->
%%     {reply, State, State}.

%% handle_cast(_Msg, State) ->
%%     {noreply, State}.
 
%% handle_info({inet_async, ListSock, Ref, {ok, CliSocket}},
%%             #state{listener = ListSock, acceptor = Ref, module = _Module} = State) ->
%%     try
%%         case set_sockopt(ListSock, CliSocket) of
%%             ok ->
%%                 ok;
%% 	        {error, Reason} ->
%%                 exit({set_sockopt, Reason})
%%         end,

%%         %% New client connected - spawn a new process using the simple_one_for_one
%%         %% supervisor.
%%         case listener_sup:start_child({udp, CliSocket}) of
%%             {ok, Pid} ->
%%                 %% Assigns a new controlling process Pid to Socket
%%                 case gen_udp:controlling_process(CliSocket, Pid) of
%%                     ok ->
%%                         pass;
%%                     {error, ReasonTcp} ->
%%                         ?WARNING_MSG("controlling process failed: ~p~n", [ReasonTcp])
%%                 end;
%%             {error, Reason2} ->
%%                 ?WARNING_MSG("~p start_child failed: ~p~n", [self(), Reason2])
%%         end,

%%         %% Signal the network driver that we are ready to accept another connection
%%         case prim_inet:async_accept(ListSock, -1) of
%%             {ok,    NewRef} ->
%%                 {noreply, State#state{acceptor = NewRef}};
%%             {error, NewRef} ->
%%                 exit({async_accept, inet:format_error(NewRef)}),
%%                 {noreply, State#state{acceptor = NewRef}}
%%         end
%%     catch
%%         exit:Why ->
%%             ?ERROR_MSG("Error in async accept: ~p.\n", [Why]),
%%             {stop, Why, State}
%%     end;
 
%% handle_info({inet_async, ListSock, Ref, Error}, 
%%             #state{listener = ListSock, acceptor = Ref} = State) ->
%%     ?ERROR_MSG("Error in socket acceptor: ~p.\n", [Error]),
%%     {stop, Error, State};
 
%% handle_info(_Info, State) ->
%%     {noreply, State}.
 
%% terminate(_Reason, State) ->
%%     gen_tcp:close(State#state.listener),
%%     hmisc:delete_monitor_pid(self()),
%%     ok.
 
%% code_change(_OldVsn, State, _Extra) ->
%%     {ok, State}.
 
%% %% Taken from prim_inet.  We are merely copying some socket options from the
%% %% listening socket to the new client socket.
%% set_sockopt(ListSock, CliSocket) ->
%%     true = inet_db:register_socket(CliSocket, inet_tcp),
%%     case prim_inet:getopts(ListSock, [active, nodelay, keepalive, delay_send, priority, tos]) of
%% 	    {ok, Opts} ->
%% 	        case prim_inet:setopts(CliSocket, Opts) of
%% 		        ok    ->
%%                     ok;
%% 		        Error ->
%%                     gen_tcp:close(CliSocket),
%%                     Error
%% 	        end;
%% 	    Error ->
%% 	        gen_tcp:close(CliSocket),
%%             Error
%%     end.

