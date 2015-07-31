%%%-------------------------------------------------------------------
%%% @author Arno <>
%%% @copyright (C) 2013, Arno
%%% @doc
%%%
%%% @end
%%% Created :  2 Dec 2013 by Arno <>
%%%-------------------------------------------------------------------
-module(robot_manager).

-behaviour(gen_server).

%% API
-export([start/2,
         stop/2,
         start_link/0
        ]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-define(SERVER, ?MODULE). 

-record(state, {robot_start_id = 0,
                robot_count    = 0
               }).

%%%===================================================================
%%% API
%%%===================================================================

start(StartId, N) ->
    %% erlang:spawn(fun() ->
    %%                      lists:foreach(fun(J) ->
    %%                                            lists:foreach(fun(I) ->
    %%                                                                  %% timer:sleep(1000),
    %%                                                                  NewI = J * 100 + I,
    %%                                                                  mod_robot_fsm:start(StartId + NewI, "192.168.1.149", 8801)
    %%                                                          end, lists:seq(1, 100))
    %%                                    end, lists:seq(0, (N div 100)))
    %%              end).
    erlang:spawn(fun() ->
                         lists:foreach(fun(I) ->
                                               mod_robot_fsm:start(StartId + I, "192.168.1.149", 8801)
                                       end, lists:seq(1, N))
                 end).


stop(StartId, N) ->
    lists:foreach(
      fun(I) ->
              catch mod_robot_fsm:stop(StartId + I)
      end, lists:seq(1, N)).

%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @spec start_link() -> {ok, Pid} | ignore | {error, Error}
%% @end
%%--------------------------------------------------------------------
start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

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
init([]) ->
    hloglevel:set(3),
    {ok, #state{}}.

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
handle_cast({start, StartAccId, N}, State) ->
    Nodes = ["192.168.1.99","192.168.1.23","192.168.1.149"],
    SelectedNode = lists:nth(random:uniform(length(Nodes)), Nodes),
    lists:foreach(
      fun(I) ->
              mod_robot_fsm:start(StartAccId + I, "192.168.1.99", 8801)
      end, lists:seq(1, N)),
    {noreply, State#state{robot_start_id = StartAccId,
                          robot_count    = N
                         }};
handle_cast(stop, #state{
                     robot_start_id = StartAccId,
                     robot_count    = N
                    } = State) ->
    lists:foreach(
      fun(I) ->
              mod_robot_fsm:stop(StartAccId + I)
      end, lists:seq(1, N)),
    {noreply, State#state{robot_start_id = StartAccId,
                          robot_count    = N
                         }};
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
handle_info(_Info, State) ->
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
terminate(_Reason, _State) ->
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

