%%%-------------------------------------------------------------------
%%% @author liu <liuzhigang@gzleshu.com>
%%% @copyright (C) 2014, liu
%%% @doc
%%%
%%% @end
%%% Created :  4 Jul 2014 by liu <liuzhigang@gzleshu.com>
%%%-------------------------------------------------------------------
-module(mod_boss).

-behaviour(gen_server).

%% API
-export([start_link/2,
         entry_boss_scene/4,
         damage_boss/4,
         quip_boss/2,
         get_count/1,
         get_start_stop/1]).

-export([bossover/2]).  %%for test

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-include("define_boss.hrl").
-include("define_logger.hrl").
-include("define_info_17.hrl").
-include("define_reward.hrl").
-include("define_mnesia.hrl").

-define(SERVER, ?MODULE).
-define(AUTO_SEND_TIME, 5000).

-record(state, {
          boss_id = 0,
          boss_hp = 0,
          boss_lv = 0,
          monster_id = 0,
          state = ?BOSS_STATE_ALIVE,
          msg = [],
          count = 0,
          start_time = 0,
          end_time = 0,
          player_state = [],
          sn,
          boss_hp_lim = 0}).


%%%===================================================================
%%% API
%%%===================================================================
damage_boss(PlayerId, Pid, Hurt, CritList) ->
    gen_server:cast(Pid, {damage_boss, PlayerId, Hurt, CritList}).

entry_boss_scene(PlayerId, NickName, Career, Pid) ->
    gen_server:call(Pid, {entry_boss_scene, PlayerId, NickName, Career}).

quip_boss(PlayerId, Pid) ->
    gen_server:cast(Pid, {quip_boss, PlayerId}).

get_count(Pid) ->
    gen_server:call(Pid, get_count).

get_start_stop(Pid) ->
    gen_server:call(Pid, get_start_stop).

bossover(Pid, Rest) ->
    gen_server:call(Pid, {bossover, Rest}).
%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @spec start_link() -> {ok, Pid} | ignore | {error, Error}
%% @end
%%--------------------------------------------------------------------
start_link(BossId, Sn) ->
    gen_server:start_link(?MODULE, [BossId, Sn], []).

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
init([BossId, Sn]) ->
    {ok, #state{boss_id = BossId,
                sn = Sn}, 0}.

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
handle_call({entry_boss_scene, PlayerId, NickName, Career}, _From, #state{player_state = PlayerState,
                                                                          boss_hp = Hp,
                                                                          boss_id = BossId,
                                                                          start_time = Start,
                                                                          end_time = EndTime,
                                                                          count = Count,
                                                                          boss_lv = BossLv,
                                                                          state = BossState,
                                                                          boss_hp_lim = HpLim} = State) ->
    if
        Hp =:= 0 orelse BossState =:= ?BOSS_STATE_DEAD->
            {reply, {fail, ?BOSS_IS_KILLED}, State};
        true ->
            case lib_boss:check_entry_boss(BossId, Start, EndTime, Count) of
                ok ->
                    AddPlayerState = #player_info{player_id = PlayerId,
                                                  damage = 0,
                                                  nickname = NickName,
                                                  career = Career
                                                 },
                    NewPlayerState = 
                        lists:keystore(PlayerId, #player_info.player_id, PlayerState, AddPlayerState),
                    Reply = 
                        entry_info(Hp, BossLv, HpLim, PlayerState, AddPlayerState),
                    {reply, Reply, State#state{player_state = NewPlayerState,
                                               count = Count + 1}};
                {fail, Reason} ->
                    {reply, {fail, Reason}, State}
            end
    end;
handle_call(get_count, _, #state{count = Count} = State) ->
    {reply, {ok, Count}, State};
handle_call(get_start_stop, _, State) ->
    Start = State#state.start_time,
    Stop = State#state.end_time,
    {reply, {Start, Stop}, State};

handle_call({bossover, Rest}, _, State) ->
    Now = time_misc:unixtime(),
    Stop = Now + Rest,
    erlang:send_after(Rest*1000, self(), timeoff),
    {reply, Stop, State#state{end_time = Stop}};
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
handle_cast({damage_boss, PlayerId, Hurt, CritList},  #state{player_state = PlayerState,
                                                             state = BossState} = State) ->
    if
        BossState =:= ?BOSS_STATE_DEAD ->
            {noreply, State};
        true ->
            case lists:keyfind(PlayerId, #player_info.player_id, PlayerState) of
                false ->
                    ?WARNING_MSG("Illegal damage boss PlayerId ~p BossId ~p PlayerState ~p~n", 
                                 [PlayerId, State#state.boss_id, PlayerState]),
                    {noreply, State};
                #player_info{nickname = NickName} ->
                    do_damage_event({PlayerId, NickName, Hurt, CritList}, State)
            end
    end;
handle_cast({quip_boss, PlayerId}, #state{player_state = PlayerState,
                                          count = Count} = State) ->
    NewPlayerState = lists:keydelete(PlayerId, #player_info.player_id, PlayerState),
    {noreply, State#state{player_state = NewPlayerState,
                          count = Count - 1}};
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
handle_info(timeout, #state{boss_id = BossId} = State) ->
    erlang:send_after(?AUTO_SEND_TIME, self(), auto_send_info),
    case data_base_dungeon_world_boss:get(BossId) of
        [] ->
            {stop, normal, State};
        #base_dungeon_world_boss{dungeon_id = DungeonId,
                                 last_time = LastTime} ->
            Now = time_misc:unixtime(),
            {MonstersId, Hp, BossLv} = lib_dungeon:get_boss_hp(DungeonId),
            Start = Now + ?WAIT_BOSS_TIME,
            Stop = Start + LastTime*60,
            erlang:send_after((?WAIT_BOSS_TIME + LastTime*60)*1000, self(), timeoff),
            {noreply, State#state{boss_hp = Hp,
                                  boss_lv = BossLv,
                                  monster_id = MonstersId,
                                  start_time = Start,
                                  end_time = Stop,
                                  boss_hp_lim = Hp}}
    end;
handle_info(auto_send_info, #state{msg = MsgList,
                                   player_state = PlayerState,
                                   state = BossState} = State) ->
    if
        BossState =:= ?BOSS_STATE_DEAD ->
            skip;
        true ->
            erlang:send_after(?AUTO_SEND_TIME, self(), auto_send_info),
            do_send_msg(State#state.boss_hp, MsgList, PlayerState, BossState)
    end,
    {noreply, State#state{msg = []}};
handle_info(timeoff, #state{boss_hp = Hp,
                            msg = MsgList,
                            player_state = PlayerState
                           } = State) ->
    BossState = ?BOSS_STATE_DEAD,
    do_send_msg(Hp, MsgList, PlayerState, BossState),
    {stop, normal, State#state{state = BossState}};
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
terminate(_Reason, #state{boss_id = BossId,
                          boss_hp = Hp,
                          state = BossState,
                          player_state = PlayerState,
                          monster_id = MonstersId,
                          sn = Sn}) ->
    ?DEBUG("mod_boss terminate Reason ~p~n", [_Reason]),
    mod_boss_manage:boss_killed(Sn, BossId, self()),
    BossKillFlag =
        if
            BossState =:= ?BOSS_STATE_DEAD andalso Hp =< 0 ->
                true;
            true ->
                false
        end,
    update_boss_lv(MonstersId, BossKillFlag),
    notice_player(PlayerState, BossId, BossKillFlag),  %%boss 死了要通知玩家
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
do_damage_event({PlayerId, NickName, Hurt, CritList}, #state{boss_hp = Hp,
                                                             player_state = PlayerState,
                                                             msg = Msg
                                                            } = State) ->
    NewMsgList = 
        if
            CritList =:= [] ->
                Msg;
            true ->
               [{NickName, CritList}|Msg]
        end,
    if
        Hurt >= Hp ->
            ?WARNING_MSG("boss ~p dead by hurt ~p Hp ~p PlayerId ~p~n", 
                         [State#state.boss_id, Hurt, Hp, PlayerId]),
            NewPlayerState = update_damage({PlayerId, NickName, Hurt}, PlayerState),
            BossState = ?BOSS_STATE_DEAD,
            NewState = State#state{boss_hp = 0,
                                   state = BossState,
                                   msg = NewMsgList,
                                   player_state = NewPlayerState},
            do_send_msg(0, NewMsgList, NewPlayerState, BossState),
            {stop, normal, NewState};
        true ->
            NewPlayerState = update_damage({PlayerId, NickName, Hurt}, PlayerState),
            {noreply, State#state{boss_hp = Hp - Hurt,
                                  player_state = NewPlayerState,
                                  msg = NewMsgList
                                 }}
    end.

top_info(PlayerState, all) ->
    lists:reverse(lists:keysort(#player_info.damage, PlayerState));
top_info(PlayerState, Count) ->
    lists:sublist(lists:reverse(lists:keysort(#player_info.damage, PlayerState)), Count).

update_damage({PlayerId, NickName, Damage}, PlayerState) ->
    case lists:keytake(PlayerId, #player_info.player_id, PlayerState) of
        false ->
            NewPlayerInfo = 
                #player_info{damage = Damage,
                             player_id = PlayerId,
                             nickname = NickName},
            [NewPlayerInfo|PlayerState];
        {value, #player_info{damage = Hurt} = PlayerInfo, Rest} ->
            [PlayerInfo#player_info{damage = Hurt + Damage}|Rest]
    end.

send_killed_reward(BossId, PlayerState, false) when BossId =/= 3 ->  %% 3号BOSS不需要杀死也有排行奖励
    lists:foreach(fun(#player_info{player_id = PlayerId}) ->
                          mod_player:boss_killed(PlayerId, BossId, [])
                  end, PlayerState);
send_killed_reward(BossId, PlayerState, _) ->
    lists:foldl(fun(#player_info{player_id = PlayerId}, AccRank) ->
                        send_killed_reward2(PlayerId, BossId, AccRank),
                        AccRank + 1
                end, 1, top_info(PlayerState, all)).

send_killed_reward2(PlayerId, BossId, Rank) ->
    case data_base_rank_reward:get(Rank) of
        [] ->
            skip;
        #base_rank_reward{world_boss1 = Reward1,
                          world_boss2 = Reward2,
                          world_boss3 = Reward3} ->
            Reward = if
                         BossId =:= 1 ->
                             Reward1;
                         BossId =:= 2 ->
                             Reward2;
                         BossId =:= 3 ->
                             Reward3;
                         true ->
                             []
                     end,
            mod_player:boss_killed(PlayerId, BossId, Reward)
    end.

do_send_msg(_, _, [], _) ->
    skip;
do_send_msg(Hp, MsgList, PlayerState, BossState) ->
    TopAll = top_info(PlayerState, all),
    TopTen = lists:sublist(TopAll, 10),
    Rec = pt_17:record_top_ten(TopTen, MsgList, Hp),
    lists:foldl(fun(#player_info{player_id = PlayerId,
                                 damage = Damage}, AccRank) ->
                        mod_player:boss_damage(PlayerId, {Damage, Rec, BossState, AccRank}),
                        AccRank + 1
                end, 1, TopAll).
%%进入场景之后要下发一次Boss里面的状态
entry_info(Hp, BossLv, HpLim, PlayerState, #player_info{damage = Damage}) ->
    TopTen = top_info(PlayerState, 10),
    Rec = pt_17:record_top_ten(TopTen, [], Hp),
    pt_17:write(17001, {BossLv, HpLim, Damage, Rec, ?BOSS_STATE_ALIVE, 0}).   %%MSG就等下次同步再发

notice_player(PlayerState, BossId, Flag) ->
    send_killed_reward(BossId, PlayerState, Flag).

update_boss_lv(MonsterId, BossKillFlag) ->
    case hdb:dirty_read(server_config, {?WORLD_BOSS_LV, MonsterId}) of
        [] ->
            ?WARNING_MSG("boss server_config not found ~p~n", [MonsterId]),
            hdb:dirty_write(server_config, #server_config{k = {?WORLD_BOSS_LV, MonsterId},
                                                          v = {0, ?WORLD_BOSS_STATE_NORMAL}});
        #server_config{v = {Value, Stat}} ->
            if
                BossKillFlag =:= true andalso Stat =:= ?WORLD_BOSS_STATE_WIN ->
                    hdb:dirty_write(server_config, #server_config{k = {?WORLD_BOSS_LV, MonsterId},
                                                                  v = {Value + 1, ?WORLD_BOSS_STATE_NORMAL}});
                BossKillFlag =:= false andalso Stat =:= ?WORLD_BOSS_STATE_FAIL ->
                    hdb:dirty_write(server_config, #server_config{k = {?WORLD_BOSS_LV, MonsterId},
                                                                  v = {max(Value - 1, 0), ?WORLD_BOSS_STATE_NORMAL}});
                BossKillFlag =:= true ->
                    hdb:dirty_write(server_config, #server_config{k = {?WORLD_BOSS_LV, MonsterId},
                                                                  v = {Value, ?WORLD_BOSS_STATE_WIN}});
                true ->
                    hdb:dirty_write(server_config, #server_config{k = {?WORLD_BOSS_LV, MonsterId},
                                                                  v = {Value, ?WORLD_BOSS_STATE_FAIL}})   
            end
    end.
