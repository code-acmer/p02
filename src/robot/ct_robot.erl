-module(ct_robot).

-behaviour(gen_server).

%% API
-export([start/1]).
-export([stop/1]).

-export([handle_cmd/3, handle_cmd/2, get_robot/1,
         ai_handle_cmd/2, ai_handle_cmd/3]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-include("define_robot.hrl").

-define(SERVER, ?MODULE). 


%%%===================================================================
%%% API
%%%===================================================================
ai_handle_cmd(AccountInfo, Cmd) ->
    ai_handle_cmd(AccountInfo, Cmd, []).

ai_handle_cmd(AccountInfo, Cmd, Opts) ->
    do_call(AccountInfo, {handle_cmd, Cmd, Opts}).

handle_cmd(AccountInfo, Cmd) ->
    handle_cmd(AccountInfo, Cmd, []).

handle_cmd(AccountInfo, Cmd, Opts) ->
    do_test(AccountInfo, {handle_cmd, Cmd, Opts}).

login_init(AccountInfo) ->
    do_call(AccountInfo, login_init).

do_test(AccountInfo, Request) ->
    case do_call(AccountInfo, Request) of
        ok ->
            ok;
        Reason ->
            ct:fail(Reason)
    end.

do_call(AccountInfo, Request) ->
    RobotReg = AccountInfo#account_info.register_name,
    Ref = erlang:monitor(process, RobotReg),
    receive {'DOWN', Ref, _Type, _Object, noproc} -> 
            erlang:demonitor(Ref),
            {ok, _} = start(AccountInfo),
            login_init(AccountInfo),
            do_call(AccountInfo, Request)
    after 0 ->
            %ct:log("Request ~p Reg ~p~n", [Request, whereis(RobotReg)]),
	    Return = gen_server:call(RobotReg, Request, 10000),
	    erlang:demonitor(Ref, [flush]),
	    Return
    end.

get_robot(AccountInfo) ->
    do_call(AccountInfo, get_robot).

%% relogin_init(AccountInfo) ->
%%     gen_server:cast(AccountInfo#account_info.register_name, relogin_init).

%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @spec start_link() -> {ok, Pid} | ignore | {error, Error}
%% @end
%%--------------------------------------------------------------------
start(AccountInfo) ->
    gen_server:start({local, AccountInfo#account_info.register_name},
                     ?MODULE, AccountInfo, []).

stop(AccountInfo) ->
    gen_server:cast(AccountInfo#account_info.register_name, stop).
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
init(AccountInfo) ->
    EnsureConnectRobot = robot_tcp:ensure_connect(#ct_robot{
                                                     account = AccountInfo
                                                    }),
    {ok, EnsureConnectRobot}.

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
handle_call({handle_cmd, Cmd, Opts}, _From, State) ->
    {Reply, NewState} =
        case lib_robot:handle_cmd(Cmd, State, Opts) of
                    {ok, {HandleCmdState, []}} ->
                        {ok, HandleCmdState};
                    {ok, {HandleCmdState, RunState}} ->
                        {{fail, RunState}, HandleCmdState};
                    FailReason ->
                        {{fail, FailReason}, State}
        end,
    {reply, Reply, NewState};

handle_call(login_init, _From, State) ->    
    case lib_robot:login_init(State) of
        init_fail ->
            {reply, init_fail, State};
        NewState ->
            {reply, ok, NewState}
    end;

handle_call(get_robot, _From, State) ->
    {reply, State, State};

handle_call(_Request, _From, State) ->
    ?WARNING_MSG("Unknown _Request ~p~n", [_Request]),
    Reply = {fail, unknown_req},
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
handle_cast(login_init, State) ->    
    NewState = lib_robot:login_init(State),
    {noreply, NewState};
handle_cast(stop, State) ->
    {stop, normal, State};

handle_cast(_Msg, State) ->
    ?WARNING_MSG("Unknown _Msg ~p~n", [_Msg]),
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
handle_info({Cmd, Opts}, State) ->
    {reply, Reply, NewState} = handle_call({handle_cmd, Cmd, Opts}, 0, State),
    if
        Reply =:= ok ->
            skip;
        true ->
            ?WARNING_MSG("ERROR_MSG ~p~n", [Reply])
    end,
    {noreply, NewState};
handle_info(_Info, State) ->
    ?WARNING_MSG("Unknown Info ~p~n", [_Info]),
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
    ?WARNING_MSG("ct_robot terminate Reason ~p~n", [_Reason]),
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
