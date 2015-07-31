%%%-------------------------------------------------------------------
%%% @author liu <liuzhigang@moyou.me>
%%% @copyright (C) 2014, liu
%%% @doc
%%% 主线副本匹配机制(也许或根据等级段分开多个进程)
%%% @end
%%% Created : 20 Oct 2014 by liu <liuzhigang@moyou.me>
%%%-------------------------------------------------------------------
-module(mod_dungeon_match).

-behaviour(gen_server).

-include("define_player.hrl").
-include("define_dungeon.hrl").
-include("define_logger.hrl").
-include("define_try_catch.hrl").

%% API
-export([enter_dungeon/2,
         leave/2,
         leave_pass_dungeon/1]).
-export([start_link/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-define(SERVER, ?MODULE).

-record(state, {}).

%%%===================================================================
%%% API
%%%===================================================================

%%中途离开队伍
leave(PlayerId, TeamId) ->
    gen_server:cast(?MODULE, {leave, PlayerId, TeamId}).

%%通关删除队伍
leave_pass_dungeon(TeamId) ->
    gen_server:cast(?MODULE, {leave_pass_dungeon, TeamId}).

enter_dungeon(PlayerId, TeamId) ->
    gen_server:call(?MODULE, {enter_dungeon, PlayerId, TeamId}).

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
    {ok, #state{}}.

handle_call(Req, From, State) ->
    ?DO_HANDLE_CALL(Req, From, State).
handle_cast(Cmd,  State) ->
    ?DO_HANDLE_CAST(Cmd, State).
handle_info(Cmd, State) ->
    ?DO_HANDLE_INFO(Cmd, State).

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

do_handle_call({enter_dungeon, PlayerId, TeamId}, _, State) ->
    Reply = lib_dungeon_match:try_join_dungeon(PlayerId, TeamId),
    {reply, Reply, State};

do_handle_call(_Request, _From, State) ->
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
do_handle_cast({leave_pass_dungeon, TeamId}, State) ->
    lib_dungeon_match:leave_pass_dungeon(TeamId),
    {noreply, State};
do_handle_cast({leave, PlayerId, TeamId}, State) ->
    ?DEBUG("dungeon_match leave TeamId ~p PlayerId ~p~n", [TeamId, PlayerId]),
    lib_dungeon_match:leave_dungeon_match(PlayerId, TeamId),
    {noreply, State};

do_handle_cast(_Msg, State) ->
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
do_handle_info(_Info, State) ->
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
    ?WARNING_MSG("~p terminate reason ~p~n", [?MODULE, Reason]),
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


