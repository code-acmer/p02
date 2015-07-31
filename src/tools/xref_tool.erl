%%%-------------------------------------------------------------------
%%% @author liu <liuzhigang@gzleshu.com>
%%% @copyright (C) 2014, liu
%%% @doc
%%%
%%% @end
%%% Created : 24 Feb 2014 by liu <liuzhigang@gzleshu.com>
%%%-------------------------------------------------------------------
-module(xref_tool).

-behaviour(gen_server).

%% API
-export([start_link/0]).
-export([analyse/1, stop/0, call_module_undef/1]).
%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-define(SERVER, ?MODULE).

-record(state, {}).

%%%===================================================================
%%% API
%%%===================================================================
%% exports_not_used, undefined_function_calls, undefined_functions and so on.  
%%  http://www.erlang.org/doc/man/xref.html#analyze-2
analyse(Type) ->
    gen_server:call(?SERVER, Type).

stop() ->
    gen_server:call(?SERVER, stop).
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
    xref_init(),
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
handle_call(stop, _, State) ->
    {stop, normal, State};
handle_call(Type, _, State)
  when is_atom(Type)->
    Reply = do_analyse(Type),
    {reply, Reply, State};
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
    xref:stop(xref),
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
xref_init() ->
    {ok, _} = xref:start(xref),
    ok = xref:set_library_path(xref, code:get_path()),
    ok = xref:set_default(xref, [{warnings, true}, {verbose, false}]),
    {ok, _} = xref:add_directory(xref, "./ebin").
 
do_analyse(Options) ->   
    {ok, Analysis} = xref:analyse(xref, Options),
    inner_handle(Analysis, Options).

inner_handle(Analysis, Cmd) 
  when Cmd =:= exports_not_used orelse Cmd =:= undefined_functions ->
    lists:filter(fun({M, _, _}) ->
                         case atom_to_list(M) of
                             "config" ++ _ -> 
                                 false;
                             "pb" ++ _ ->
                                 false;
                             "pt" ++ _ ->
                                 false;
                             "robot" ++ _ ->
                                 false;
                             _ ->
                                 true
                         end
                 end, Analysis);
inner_handle(Analysis, undefined_function_calls) ->
    lists:filter(fun({_, {M, _, _}}) ->
                         case atom_to_list(M) of
                             "config" ++ _ -> 
                                 false;
                             "pb" ++ _ ->
                                 false;
                             "logger" ++ _ ->
                                 false;
                             "pt" ++ _ ->
                                 false;
                             "data" ++ _ ->
                                 false;
                             "robot" ++ _ ->
                                 false;
                             "db_log"->
                                 false;
                             "db_base"->
                                 false;
                             "db_game"->
                                 false;
                             _ ->
                                 true
                         end
                 end, Analysis);
inner_handle(Analysis, _Options) ->
    Analysis.


call_module_undef(Module) ->   
    {ok, Analysis} = xref:analyse(xref, undefined_function_calls),
    lists:filter(fun({_, {M, _, _}}) ->
                         Module =:= M
                 end, Analysis).
