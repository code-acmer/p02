%%%-------------------------------------------------------------------
%%% @author liu <liuzhigang@gzleshu.com>
%%% @copyright (C) 2014, liu
%%% @doc
%%%
%%% @end
%%% Created :  4 Jul 2014 by liu <liuzhigang@gzleshu.com>
%%%-------------------------------------------------------------------
-module(mod_boss_manage).

-behaviour(gen_server).
-include("define_logger.hrl").
-include("define_boss.hrl").
-include("define_try_catch.hrl").

%% API
-export([start_link/1]).
-export([get_boss/2,
         open_boss/4,
         sys_open_boss/4,
         boss_killed/3]).

-export([get_state/1]).  %%for test
%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-define(SERVER, ?MODULE).

-record(state, {boss_dict}).

%%%===================================================================
%%% API
%%%===================================================================
get_boss(BossIdList, Sn) ->
    DbSn = server_misc:get_mnesia_sn(Sn),
    gen_server:call(server_name(DbSn), {get_boss, BossIdList}).

open_boss(PlayerId, NickName, Sn, BossId) ->
    DbSn = server_misc:get_mnesia_sn(Sn),
    gen_server:call(server_name(DbSn), {open_boss, PlayerId, NickName, DbSn, BossId}).

sys_open_boss(PlayerId, NickName, DbSn, BossId) ->
    ?DEBUG("sys_open_boss DbSn ~p BossId ~p~n", [DbSn, BossId]),
    gen_server:call(server_name(DbSn), {open_boss, PlayerId, NickName, DbSn, BossId}).

boss_killed(Sn, BossId, Pid) ->
    DbSn = server_misc:get_mnesia_sn(Sn),
    gen_server:cast(server_name(DbSn), {boss_down, BossId, Pid}).

get_state(Sn) ->
    DbSn = server_misc:get_mnesia_sn(Sn),
    gen_server:call(server_name(DbSn), get_state).

server_name(DbSn) ->
    server_misc:server_name(?MODULE, DbSn).
%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @spec start_link() -> {ok, Pid} | ignore | {error, Error}
%% @end
%%--------------------------------------------------------------------
start_link(DbSn) ->
     gen_server:start_link({local, server_name(DbSn)}, ?MODULE, [], []).

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
    process_flag(trap_exit, true),
    erlang:send_after(200, self(), init_boss_manage),
    {ok, #state{}}.

handle_call(Req, From, State) ->
    ?DO_HANDLE_CALL(Req, From, State).
handle_cast(Cmd, State) ->
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
do_handle_call({get_boss, BossIdList}, _, #state{boss_dict = BossDict} = State) ->
    BossList= lib_boss:get_player_boss(BossIdList, BossDict),
    {reply, {ok, BossList}, State};

do_handle_call({open_boss, PlayerId, NickName, Sn, BossId}, _, #state{boss_dict = BossDict} = State) ->
    case lib_boss:open_boss(PlayerId, NickName, Sn, BossId, BossDict) of
        {fail, Reason} ->
            {reply, {fail, Reason}, State};
        {ok, NewBoss, SummonReward} ->
            {reply, {ok, NewBoss, SummonReward}, State#state{boss_dict = dict:append(BossId, NewBoss, BossDict)}}
    end;

do_handle_call(get_state, _, State) ->
    Reply = dict:to_list(State#state.boss_dict),
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
do_handle_cast({boss_down, BossId, Pid}, #state{boss_dict = BossDict} = State) ->
    case dict:find(BossId, BossDict) of
        error ->
            ?WARNING_MSG("may be error BossId ~p BossDict ~p~n", [BossId, BossDict]),
            {noreply, State};
        {ok, BossList} ->
            NewBossList = lists:keydelete(Pid, #bossinfo.pid, BossList),
            NewDict = dict:store(BossId, NewBossList, BossDict),
            {noreply, State#state{boss_dict = NewDict}}
    end;
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
do_handle_info(init_boss_manage, #state{} = State) ->
    AllBossId = data_base_dungeon_world_boss:get_all_id(),
    BossDict = lists:foldl(fun(BossId, AccDict) ->
                                   dict:store(BossId, [], AccDict)
                           end, dict:new(), AllBossId),
    {noreply, State#state{boss_dict = BossDict}};

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

