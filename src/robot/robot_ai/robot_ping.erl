%%%-------------------------------------------------------------------
%%% @author human <humanzhigang@gzleshu.com>
%%% @copyright (C) 2014, human
%%% @doc
%%%
%%% @end
%%% Created : 26 Sep 2014 by human <humanzhigang@gzleshu.com>
%%%-------------------------------------------------------------------
-module(robot_ping).

-behaviour(gen_server).

-include("define_robot.hrl").
%% API
-export([start_link/4,test_one/1]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-define(SERVER,  ?MODULE).
-define(SERVER_INIT,   0).
-define(SERVER_EXCEP, -1).
-define(SERVER_NORMAL, 1).

-record(group_state, {robot_list = [],
                      group_id = 0,
                      robot_state,
                      server_state = 0}).
-record(robot_state, {account_info,
                      id}).

%%%===================================================================
%%% API
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @spec start_link() -> {ok, Pid} | ignore | {error, Error}
%% @end
%%--------------------------------------------------------------------
start_link(Ip, Port, RobotNum, ServerNum) ->
    %?DEBUG(" ~p ~p ~p ~p ",[Ip, Port, RobotNum, ServerNum]),
    gen_server:start_link({local, ?MODULE}, ?MODULE, [Ip, Port, RobotNum, ServerNum], []).

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


test_one(ProcessName) -> 
    ProcessName ! robot_event.

account_info(Ip, Port, RobotNum, ServerNum) ->
    #account_info{
       accname = "p03_robot_" ++ integer_to_list(RobotNum),
       password = "p03_robot_" ++ integer_to_list(RobotNum),
       register_name = list_to_atom("robot_" ++ integer_to_list(RobotNum)),
       ip = Ip,
       port = Port,
       sn = ServerNum
      }.

init([Ip, Port, RobotNum, ServerNum]) ->
    ?WARNING_MSG(" ~p init ~n", [?MODULE]),
    %erlang:send_after(5000, self(), robot_event),  %%等做完再发包，避免消息过多
    {ok, #group_state{
            robot_state = #robot_state{
                             account_info = account_info(Ip, Port, RobotNum, ServerNum)
                            }
           }}.

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


handle_info(robot_event,  #group_state{
                             robot_state = RobotState,
                             server_state = ServerState
                            } = State) ->
    ServerInfo = (catch(ct_robot:ai_handle_cmd(RobotState#robot_state.account_info, 13001, [{required_cmd, 13001}]))),
    erlang:send_after(5000, self(), robot_event),  %%等做完再发包，避免消息过多
    ?DEBUG(" ServerState: ~p ",[ServerInfo]),
    case ServerInfo of 
        ok ->
            if
                ServerState =/= ?SERVER_NORMAL ->
                    ?DEBUG(" 服务器运行正常 ",[]),
                    {noreply, State#group_state{server_state = 1}};
                true ->
                    {noreply, State}
            end;
        {'EXIT', _Msg} ->
            if 
                ServerState =/= ?SERVER_EXCEP ->
                    ?DEBUG(" 服务器运行异常 ",[]),
                    {noreply, State#group_state{server_state = -1}};
                true->
                    {noreply, State}
            end;
        _ ->
            ?DEBUG(" 服务器异常信息 ~p ~n",[ServerInfo]),
            {noreply, State}
    end;
    %% catch What:Why ->
    %%         ?ERROR_MSG("~p~n ~p~n ~p~n", [What, Why, erlang:get_stacktrace()]),
    %%         skip
    %% end,
    
    %% case catch robot_event:EventFun(AccountInfo) of
    %%     ok ->
    %%         skip;
    %%     skip ->
    %%         skip;
    %%     Other ->
    %%         io:format("robot_error Reason ~p AccountInfo~p~n", [Other, AccountInfo])
    %% end,
    %% {noreply, State};
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
    ?WARNING_MSG("robot_group terminate reason ~p~n group_id ~p~n", [_Reason, _State#group_state.group_id]),
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
