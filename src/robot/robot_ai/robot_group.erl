%%%-------------------------------------------------------------------
%%% @author liu <liuzhigang@gzleshu.com>
%%% @copyright (C) 2014, liu
%%% @doc
%%%
%%% @end
%%% Created : 25 Jun 2014 by liu <liuzhigang@gzleshu.com>
%%%-------------------------------------------------------------------
-module(robot_group).

-behaviour(gen_server).

-include("define_robot.hrl").
%% API
-export([start_link/2]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-define(SERVER, ?MODULE).

-record(group_state, {robot_list = [],
                      group_id = 0}).
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
start_link(GroupId, Num) ->
    gen_server:start_link(?MODULE, [GroupId, Num], []).

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
init([GroupId, Num]) ->
    erlang:send_after(1000, self(), robot_event),
    Start = GroupId * 100000,
    {ok, #group_state{robot_list = 
                          [#robot_state{id = Id,
                                        account_info = account_info(Id)} || Id <- lists:seq(Start, Start + Num - 1)],
                      group_id = GroupId
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
handle_info(robot_event, #group_state{robot_list = RobotList} = State) ->
    #robot_state{account_info = AccountInfo} = hmisc:rand(RobotList),
    [{exports, Functions} | _ ] = robot_event:module_info(),
    FilterFunctions = [ FName || {FName, _} <- lists:filter(
                                                 fun ({module_info,_}) -> 
                                                         false;
                                                     ({_Fun, 1}) -> 
                                                         true;
                                                     ({_,_}) -> 
                                                         false
                                                 end, Functions)],
    EventFun = hmisc:rand(FilterFunctions),
    %% try
    %%     %robot_event:EventFun(AccountInfo)
         robot_event:boss_event(AccountInfo),
    %% catch What:Why ->
    %%         ?ERROR_MSG("~p~n ~p~n ~p~n", [What, Why, erlang:get_stacktrace()]),
    %%         skip
    %% end,
    erlang:send_after(2000, self(), robot_event),  %%等做完再发包，避免消息过多
    %% case catch robot_event:EventFun(AccountInfo) of
    %%     ok ->
    %%         skip;
    %%     skip ->
    %%         skip;
    %%     Other ->
    %%         io:format("robot_error Reason ~p AccountInfo~p~n", [Other, AccountInfo])
    %% end,
    {noreply, State};
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
    io:format("robot_group terminate reason ~p~n group_id ~p~n", [_Reason, _State#group_state.group_id]),
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
account_info(Num) ->
    #account_info{
       accname = "p03_robot_" ++ integer_to_list(Num),
       password = "p03_robot_" ++ integer_to_list(Num),
       register_name = list_to_atom("robot_" ++ integer_to_list(Num))
      }.
