-module(lib_cross_pvp).
-include("define_mnesia.hrl").
-include("define_cross_pvp.hrl").
-include("define_time.hrl").
-include("define_player.hrl").
-include("define_info_23.hrl").
-include("define_logger.hrl").
-include("define_arena.hrl").
-include("define_money_cost.hrl").
-include("define_goods_type.hrl").
-include("db_base_vip.hrl").
-include("define_reward.hrl").
-include("db_base_kuafupvp_robot_attribute.hrl").
-include("db_base_kuafupvp_battle_reward.hrl").
-include("db_base_dungeon_area.hrl").
-include("define_log.hrl").

%%战斗记录是cross_pvp_report 结构源用的是async_arena_report
-export([
         attack/2,
         handle_fight_result/3,
         build_islands/1,
         try_load_fighter/1,
         try_take_reward/1,
         do_join_pvp/1,
         buy_times/1,
         daily_reset/1,
         delete_cross_pvp_fighter/1,
         reset_event_timestamp/1,
         reset_island/2,
         update_player/1,
         reset_island_occupy_timestamp/2
        ]).


try_load_fighter(Player) ->
    case get_pvp_fighter(Player#player.id) of
        [] ->
            Fighter = init_pvp_fighter(Player),
            NewFighter = build_islands(Fighter),
            {ok, NewFighter};
        #cross_pvp_fighter{
          } = Fighter ->
            NewFighter = handle_robot_event(Fighter),
            %% {NewIslands, Rewards} = handle_island_rewards(PlayerId, NewFighter#cross_pvp_fighter.islands),
            %% NewRewards = lib_reward:merge_same_goods(Rewards),
            %% RetFighter = NewFighter#cross_pvp_fighter{islands = NewIslands},
            update_cross_pvp_fighter(NewFighter),
            %% ?DEBUG("NewRewards : ~p~n",[NewRewards]),
            %% case NewRewards of
            %%     [] ->
            %%         {ok, RetFighter};
            %%     [#reward_item{num = 0}|_] ->
            %%         {ok, RetFighter};
            %%     _ ->
            %%         {ok, NewModPlayerState} = lib_reward:take_reward(ModPlayerState, NewRewards, ?INCOME_CROSS_PVP, ?REWARD_TYPE_CROSS_PVP_OCCUPY),
            %%         {ok, RetFighter, NewModPlayerState}
            %% end
            {ok, NewFighter}
    end.

%% 统计占领小岛的积累收益
try_take_reward(ModPlayerState) ->
    case get_pvp_fighter(ModPlayerState?PLAYER_ID) of
        [] ->
            %% Fighter = init_pvp_fighter(ModPlayerState?PLAYER),
            %% NewFighter = build_islands(Fighter),
            %% {ok, NewFighter};
            {fail, ?INFO_PVP_ISLAND_NOT_FOUND};
        #cross_pvp_fighter{
           player_id = PlayerId,
           islands = Islands
          } = Fighter ->
            %% NewFighter = handle_robot_event(Fighter),
            {NewIslands, Rewards} = handle_island_rewards(PlayerId, Islands),
            NewRewards = lib_reward:merge_same_goods(Rewards),
            NewFighter = Fighter#cross_pvp_fighter{islands = NewIslands},
            update_cross_pvp_fighter(NewFighter),
            ?DEBUG("NewRewards : ~p~n",[NewRewards]),
            case NewRewards of
                [] ->
                    {fail, ?INFO_UNKNOWN};
                [#reward_item{num = 0}|_] ->
                    {fail, ?INFO_UNKNOWN};
                _ ->
                    {ok, NewModPlayerState} = lib_reward:take_reward(ModPlayerState, NewRewards, ?INCOME_CROSS_PVP, ?REWARD_TYPE_CROSS_PVP_OCCUPY),
                    {ok, NewModPlayerState}
            end
    end.

handle_island_rewards(PlayerId, Islands) ->
    handle_island_rewards(PlayerId, Islands, [], []).

handle_island_rewards(_PlayerId,[], NewIslands, Rewards)  ->
    {lists:reverse(NewIslands), Rewards};
handle_island_rewards(PlayerId, [#cross_pvp_island{occupy_id = OccupyId,
                                                   occupy_robot = IsRobot,
                                                   calc_timestamp = Timestamp,
                                                   occupy_time    = OccupyTime
                                                  } = Island|RestIsland], Islands, Rewards) when Timestamp > 0 ->
    Now = time_misc:unixtime(),
    case IsRobot =:= ?IS_PLAYER_0 andalso PlayerId =:= OccupyId of
        true ->
            %% 仍属自己的小岛处理
            {Cnt, Remain} =  counting_time(Now - Timestamp),
            Reward = #reward_item{goods_id = ?GOODS_TYPE_CROSS_COIN, num = max(Cnt, 0)},
            NewIsland = Island#cross_pvp_island{calc_timestamp = Now - Remain
                                               },
            handle_island_rewards(PlayerId, RestIsland, [NewIsland|Islands], [Reward|Rewards]);
        _  ->
            %% 在上次处理奖励之前被占领的小岛
            {Cnt, _} =  counting_time(OccupyTime - Timestamp),
            Reward = #reward_item{goods_id = ?GOODS_TYPE_CROSS_COIN, num = max(Cnt, 0)},
            NewIsland = Island#cross_pvp_island{calc_timestamp = 0
                                               },
            handle_island_rewards(PlayerId, RestIsland, [NewIsland|Islands], [Reward|Rewards])
    end;
handle_island_rewards(PlayerId, [Island|RestIsland], NewIslands, Rewards) ->
    handle_island_rewards(PlayerId, RestIsland, [Island|NewIslands], Rewards).


-define(ISLAND_REWARD_TIME,   ?TEN_MINITE_SECONDS).
counting_time(Seconds) ->
    Count = Seconds div ?ISLAND_REWARD_TIME,
    Remain = Seconds rem ?ISLAND_REWARD_TIME,
    {Count, Remain}.

-define(ENEMY_FIRST,                             1).
-define(PVP_ROBOT_EVENT_SPAN,    ?ONE_HOUR_SECONDS).
%% 计算机器人占领事件
handle_robot_event(#cross_pvp_fighter{player_id       = PlayerId,
                                      event_timestamp = StartTimestamp,
                                      islands         = Islands,
                                      %% group           = Group,
                                      records         = Records
                                      %% player_ability         = Ability
                                     } = Fighter) ->
    Now = time_misc:unixtime(),    
    if
        Now > StartTimestamp + ?PVP_ROBOT_EVENT_SPAN ->
            NewTimestamp = StartTimestamp + ?PVP_ROBOT_EVENT_SPAN,
            OwnIslands = get_occupied_islands(PlayerId, Islands),
            OwnCnt = length(OwnIslands),
            {Rate, IsEnemyFirst} = get_occupy_rate(OwnCnt),
            Hit = hmisc:rand(0, 999),
            if
                Hit < Rate andalso OwnCnt > 0 ->
                    %% DO OCCUPY
                    %% IgnoreIds = get_ignore_ids(Islands),                    
                    %% EnemiesIds = get_enemy_ids(PlayerId),
                    %% ?DEBUG("IgnoredIds : ~p~n",[IgnoreIds]),
                    case get_new_enemy(IsEnemyFirst, Fighter) of
                        [Attacker] ->
                            OccupyTimestamp = NewTimestamp + hmisc:rand(-1800, 1800),
                            [#cross_pvp_island{id = Id} = Selected|_] = lists:keysort(#cross_pvp_island.occupy_time, OwnIslands),
                            NewIsland  = set_island(Selected, Attacker),
                            NewIslands = lists:keyreplace(Id, #cross_pvp_island.id, Islands, NewIsland#cross_pvp_island{occupy_time = OccupyTimestamp}),  %% 修正占领时间
                            ?DEBUG("Robot Occupy Island : ~p, NewIslands : ~p~n",[NewIsland, NewIslands]),
                            Record = build_record(NewIsland, Selected, ?CHALLENGE_PVP_WIN),
                            NewRecords = try_add_record(Records, Record#cross_pvp_record{timestamp = OccupyTimestamp}), %% 修正记录生成时间
                            handle_robot_event(Fighter#cross_pvp_fighter{
                                                 event_timestamp = NewTimestamp,
                                                 islands = NewIslands,
                                                 records = NewRecords
                                                });
                        {enemy, [Attacker]} ->
                            OccupyTimestamp = NewTimestamp + hmisc:rand(-1800, 1800),
                            [#cross_pvp_island{id = Id} = Selected|_] = lists:keysort(#cross_pvp_island.occupy_time, OwnIslands),
                            NewIsland  = set_island(Selected, Attacker),
                            NewIslands = lists:keyreplace(Id, #cross_pvp_island.id, Islands, NewIsland#cross_pvp_island{occupy_time = OccupyTimestamp, 
                                                                                                                        is_enemy = ?ENEMY_FLAG_TRUE
                                                                                                                       }),  %% 修正占领时间
                            ?DEBUG("Robot Occupy Island : ~p, NewIslands : ~p~n",[NewIsland, NewIslands]),
                            Record = build_record(NewIsland, Selected, ?CHALLENGE_PVP_WIN),
                            NewRecords = try_add_record(Records, Record#cross_pvp_record{timestamp = OccupyTimestamp}), %% 修正记录生成时间
                            handle_robot_event(Fighter#cross_pvp_fighter{
                                                 event_timestamp = NewTimestamp,
                                                 islands = NewIslands,
                                                 records = NewRecords
                                                });
                        _ ->
                            handle_robot_event(Fighter#cross_pvp_fighter{
                                                 event_timestamp = NewTimestamp
                                                })

                    end;
                true -> 
                    handle_robot_event(Fighter#cross_pvp_fighter{
                                         event_timestamp = NewTimestamp
                                        })
            end;
        true -> 
            Fighter
    end.


%% 机器人进攻规则 概率
get_occupy_rate(Cnt) when Cnt =< 4 ->
    {150, 0};
get_occupy_rate(Cnt) when Cnt =:= 5 ->
    {300, ?ENEMY_FIRST};
get_occupy_rate(Cnt) when Cnt >= 6 andalso Cnt =< 9 ->
    {400, 0};
get_occupy_rate(Cnt) when Cnt =:= 10  ->
    {500, ?ENEMY_FIRST};
get_occupy_rate(Cnt) when Cnt >= 11 andalso Cnt =< 14 ->
    {700, 0};
get_occupy_rate(Cnt) when Cnt =:= 15 ->
    {700, ?ENEMY_FIRST};
get_occupy_rate(Cnt) ->
    ?WARNING_MSG("Unknow Cnt : ~p~n", [Cnt]),
    {1000, ?ENEMY_FIRST}.



%% 拉人概率	拉人对象所在战斗力坑位	替补机器人	怪物
%% 40%	玩家当前坑位	离玩家战斗力100%最近的机器人	无
%% 25%	玩家当前坑位的低一个坑位	离玩家战斗力90%最近的机器人	无
%% 15%	玩家当前坑位的高一个坑位	离玩家战斗力110%最近的机器人	无
%% 10%	玩家当前坑位的高两个坑位	离玩家战斗力120%最近的机器人	无
%% 10%	无	无	Boss和小怪
get_rand_list() ->
    [{{0, 1000, 0}, 450},
     {{-1, 900, 0}, 150},
     {{1, 1100, 0}, 150}, 
     {{2, 1200, 0}, 100}, 
     {{0,    0, 1}, 150}].

%% 取随机敌人
get_rand_fighter(#cross_pvp_fighter{
                    group = Group,
                    player_ability = Ability
                   } = _Fighter, IgnoreList) ->
    case hmisc:rand(get_rand_list()) of
        {_,_,1} ->
            %% 特殊类型NPC
            AreaIds = [1300111,1300112,1300113,1300114,1300115],
            AreaId = hmisc:rand(AreaIds),
            BossName = case data_base_dungeon_area:get(AreaId) of
                           #base_dungeon_area{
                              desc = Desc
                             } ->
                               Desc;
                           _ ->
                               "BOSS"
                       end,            
            %%
            NewAbility = max(Ability, 7700),
            [#cross_pvp_npc{id = AreaId, name = BossName, ability = NewAbility}];
        {AddGroup, AbilityRate, 0} ->
            get_fighters_by_group(Ability * AbilityRate/1000, 1 , Group + AddGroup, IgnoreList)
    end.

get_new_enemy(?ENEMY_FIRST, #cross_pvp_fighter{player_id = PlayerId,
                                               player_ability = Ability,
                                               islands   = Islands} = Fighter) ->
    IgnoreIds = get_ignore_ids(Islands),
    EnemyIds  = get_enemy_ids(PlayerId),
    ?DEBUG("EnemyIds : ~p~n",[EnemyIds]),
    case get_enemy_players(1, EnemyIds, Fighter, [], [PlayerId|IgnoreIds]) of
        [] ->
            case get_rand_fighter(Fighter, [PlayerId|IgnoreIds]) of
                [#cross_pvp_fighter{player_id = EnemyId,
                                    player_ability = EnemyAbility} = Enemy | _] = RET ->
                    case lists:member(EnemyId, EnemyIds) of
                        true ->
                            case if_in_ability(Ability, EnemyAbility) of
                                true ->
                                    {enemy, [Enemy]};
                                _ ->
                                    RET
                            end;
                        _ ->
                            RET
                    end;
                RET  ->
                    RET
            end;
        [Enemy|_]->
            ?DEBUG("Enemy : ~p~n",[Enemy]),
            {enemy, [Enemy]}
    end;
get_new_enemy(_, #cross_pvp_fighter{player_id = PlayerId,
                                    islands   = Islands} = Fighter) ->
    IgnoreIds = get_ignore_ids(Islands),
    EnemyIds  = get_enemy_ids(PlayerId),
    get_rand_fighter(Fighter, [PlayerId|IgnoreIds] ++ EnemyIds).

    

attack(PlayerId, IslandId) when is_integer(IslandId) ->
    case check_challenge_time() of
        true ->
            case check_attack(PlayerId, IslandId) of
                {ok, #cross_pvp_fighter{times = Times
                                       } = Fighter, Island} ->
                    if
                        Times > 0 ->
                            NewFighter = Fighter#cross_pvp_fighter{times = Times - 1},
                            update_cross_pvp_fighter(NewFighter),
                            {ok, Island};
                        true ->
                            {fail, ?INFO_PVP_ISLAND_NOT_FOUND}
                    end; 
                {fail, _Error} = RET ->
                    RET
            end;
        false ->
            {fail, ?INFO_CHALLENGE_NOT_TIME}
    end.
check_attack(PlayerId, IslandId) ->
    case get_pvp_fighter(PlayerId) of
        [] ->
            {fail, ?INFO_CHALLENGE_NOT_FOUND};
        #cross_pvp_fighter{
           islands = Islands
          } = Fighter ->
            case lists:keyfind(IslandId, #cross_pvp_island.id, Islands) of
                false ->
                    {fail, ?INFO_PVP_ISLAND_NOT_FOUND};
                #cross_pvp_island{
                   occupy_id = OccupyId,
                   occupy_robot = IsRobot
                  } when IsRobot =/= ?IS_PLAYER_0 andalso 
                         OccupyId =:= PlayerId ->
                    {fail, ?INFO_CANT_ATTACK_SELF};
                #cross_pvp_island{
                  } = Island ->
                    {ok, Fighter, Island}
            end
    end.

handle_fight_result(ModPlayerState, IslandId, Result) ->
    case check_attack(ModPlayerState?PLAYER_ID, IslandId) of
        {ok, 
         #cross_pvp_fighter{records = Records,
                            player_ability = AtkAbility
                           } = Fighter, 
         #cross_pvp_island{occupy_ability = DefAbility,
                           occupy_id    = OccupyPlayerId,
                           occupy_robot = RobotFlag
                          } = Island
        } ->
            Record = build_record(Fighter, Island, Result),
            NewRecords = try_add_record(Records, Record),
            lib_log_player:log_system({ModPlayerState?PLAYER_ID, ?LOG_CROSS_PVP, 1, RobotFlag, Result}),
            case Result of
                ?CHALLENGE_PVP_WIN ->
                    NewIsland  = set_island(Island#cross_pvp_island{calc_timestamp = time_misc:unixtime()}, Fighter),   %% 重置资源收集时间
                    NewIslands = lists:keyreplace(IslandId, #cross_pvp_island.id, Fighter#cross_pvp_fighter.islands, NewIsland),
                    NewFighter = Fighter#cross_pvp_fighter{islands = NewIslands,
                                                           records = NewRecords
                                                          },
                    update_cross_pvp_fighter(NewFighter),
                    try_occupy_enimy_island(Fighter, Island),
                    %% Take Reward
                    NewDefAbility = case RobotFlag of
                                        RobotFlag when RobotFlag =:= ?IS_NPC_2 orelse 
                                                       RobotFlag =:= ?IS_ROBOT_1->
                                            DefAbility;
                                        _->
                                            OccupyPlayer = lib_player:get_player(OccupyPlayerId),
                                            element(#player.high_ability, OccupyPlayer)
                                    end,

                    Rewards = get_fight_reward(RobotFlag, Result, AtkAbility, NewDefAbility),
                    lib_reward:take_reward(ModPlayerState, Rewards, ?INCOME_CROSS_PVP, ?REWARD_TYPE_CROSS_PVP);
                _ ->
                    NewFighter = Fighter#cross_pvp_fighter{records = NewRecords
                                                          },
                    update_cross_pvp_fighter(NewFighter),
                    ok
                    %% Rewards = get_fight_reward(Result, AtkAbility, DefAbility),
                    %% lib_reward:take_reward(ModPlayerState, Rewards, ?INCOME_CROSS_PVP, ?REWARD_TYPE_CROSS_PVP)
            end;
        {fail, _} = RET ->
            RET
    end.

%%金钱量 = ( 较高战力 - 较低战力 ）*0.5 + 5000）。
get_fight_reward(_RobotFlag, Result, _AtkAbility, DefAbility) ->
    case Result of
        ?CHALLENGE_PVP_WIN ->
            %% when (RobotFlag =:= ?IS_PLAYER_0 orelse
            %%                      RobotFlag =:= ?IS_ROBOT_1) 
            %% Rate = 333,
            %% Rand = hmisc:rand(1,1000),
            %% StoneRewards = if
            %%                    Rand < Rate ->
            %%                        [{?AEROLITE_ID, 1}];
            %%                    true ->
            %%                        []
            %%                end,
            %% Coin = max(DefAbility - AtkAbility, 0) * 0.5 + 5000,
            %% Rewards = 
            get_battle_rewards(DefAbility);
            %% StoneRewards ++ Rewards;
        %% ?CHALLENGE_PVP_WIN ->
        %%     Rate = 333,
        %%     Rand = hmisc:rand(1,1000),
        %%     StoneRewards = if
        %%                        Rand < Rate ->
        %%                            [{?AEROLITE_ID, 1}];
        %%                        true ->
        %%                            []
        %%                    end,
        %%     %% Coin = max(DefAbility - AtkAbility, 0) * 0.5 + 5000,
        %%     Rewards = get_battle_rewards(AtkAbility),
        %%     StoneRewards ++ Rewards;
        _->
            %% lib_reward:get_pvp_rewards(cross_pvp, loss)
            []
    end.

get_battle_rewards(Ability) ->
    case data_base_kuafupvp_battle_reward:get(Ability) of
        [] ->
            [];
        #base_kuafupvp_battle_reward{win_reward = WinReward}  ->
            lib_reward:generate_reward_list(lib_reward:convert_common_reward(WinReward))
    end.


%% 检查是否可以占领对应玩家的小岛
try_occupy_enimy_island(#cross_pvp_fighter{
                           player_id = AtkId,
                           player_ability   = AtkAbility
                          } = Fighter, 
                        #cross_pvp_island{occupy_robot = IsRobot,
                                          occupy_id    = OccupyId
                                         } = _Island) when IsRobot =:= ?IS_PLAYER_0 ->
    case get_pvp_fighter(OccupyId) of
        [] ->
            ignored;
        #cross_pvp_fighter{
           player_id = DefId,
           player_ability = DefAbility,
           islands = DefIslands,
           records = Records
          } = Defender ->
            case lists:keyfind(AtkId, #cross_pvp_island.occupy_id, DefIslands) of
                false ->
                    %% 未占有小岛时占领小岛
                    case get_occupied_islands(DefId, DefIslands) of
                        [] ->
                            %% 已无岛可被占领
                            ignored;
                        DefOwnIslands ->                            
                            CrossPvpEnemy = case if_in_ability(AtkAbility, DefAbility) of
                                                true ->
                                                    add_enemy(AtkId, DefId);
                                                _ ->
                                                    #cross_pvp_enemy{}
                                            end,
                            IsEnemy = if
                                          CrossPvpEnemy#cross_pvp_enemy.atk_wins > 0 andalso 
                                          CrossPvpEnemy#cross_pvp_enemy.def_wins > 0  -> 
                                              ?ENEMY_FLAG_TRUE;
                                          true -> 
                                              ?ENEMY_FLAG_FALSE
                                      end,
                            [Selected|_] = lists:keysort(#cross_pvp_island.occupy_time, DefOwnIslands),
                            NewOccupyIsland = set_island(Selected, Fighter),
                            NewDefIslands = lists:keyreplace(Selected#cross_pvp_island.id, #cross_pvp_island.id, DefIslands, NewOccupyIsland#cross_pvp_island{is_enemy = IsEnemy}),
                            Record = build_record(Fighter, Selected, ?CHALLENGE_PVP_WIN),
                            NewRecords = try_add_record(Records, Record),
                            NewDefender = Defender#cross_pvp_fighter{
                                            islands = NewDefIslands,
                                            records = NewRecords
                                           },
                            update_cross_pvp_fighter(NewDefender)
                    end;
                _ ->
                    ignored
            end
    end;
try_occupy_enimy_island(_Fighter, _Island) ->
    ignored.


get_occupied_islands(PlayerId, Islands) ->
    lists:filter(fun(#cross_pvp_island{occupy_id = OccupyId,
                                       occupy_robot = IsRobot}) ->
                         case IsRobot of
                             ?IS_PLAYER_0  ->
                                 OccupyId =:= PlayerId;
                             _->
                                 false
                         end
                 end, Islands).
build_record(#cross_pvp_fighter{player_id = AtkId,
                                player_name = AtkName
                               } = _Fighter,
             #cross_pvp_island{occupy_id = DefId,
                               occupy_name = DefName
                              } = _Island, Result) ->
    #cross_pvp_record{result = Result,
                      atk_id = AtkId,
                      atk_name = AtkName,
                      def_id = DefId,
                      def_name = DefName,
                      timestamp = time_misc:unixtime()
                     };
build_record(#cross_pvp_island{occupy_id = AtkId,
                               occupy_name = AtkName
                              } = _Atk,
             #cross_pvp_island{occupy_id = DefId,
                               occupy_name = DefName
                              } = _Def, Result) ->
    #cross_pvp_record{result = Result,
                      atk_id = AtkId,
                      atk_name = AtkName,
                      def_id = DefId,
                      def_name = DefName,
                      timestamp = time_misc:unixtime()
                     }.


try_add_record(Records, NewRecord) ->
    lists:sublist([NewRecord|Records], ?MAX_RECORD_CNT). 

buy_times(Player) ->
    %% MaxBuyTimes = lib_vip:max_cross_buy_times(Player#player.vip),
    case get_pvp_fighter(Player#player.id) of
        [] ->
            {fail, ?INFO_CHALLENGE_NOT_FOUND};
        #cross_pvp_fighter{
           times = Times,
           buy_times = BuyTimes
          } = Fighter ->
            CountTime = min(20, BuyTimes+1),
            case lib_vip:get_vip_cost(cross_challange_times_cost, CountTime) of
                error ->
                    {fail, ?INFO_CONF_ERR};
                {CostType, CostNum} ->
                    case lib_player:cost_money(Player, CostNum, CostType, ?COST_CROSS_CHALLENGE_BUY_TIMES) of
                        {fail, Reason} ->
                            {fail, Reason};
                        {ok, NewPlayer} ->
                            NewFighter = Fighter#cross_pvp_fighter{times = Times + ?EACH_BUY_TIMES_CROSS,
                                                                   buy_times = BuyTimes + 1},
                            update_cross_pvp_fighter(NewFighter),
                            {ok, NewFighter, NewPlayer}
                    end
            end;
        _ ->
            {fail, ?INFO_ARENA_BUY_TIMES_LIMIT}
    end.

%% 每日重置相关
daily_reset(Player) ->
    case get_pvp_fighter(Player#player.id) of
        [] ->
            ignored;
        #cross_pvp_fighter{} = Fighter ->
            NewFighter = Fighter#cross_pvp_fighter{
                           times = ?PVP_DEFAULT_TIMES,
                           buy_times = 0
                          },
            update_cross_pvp_fighter(NewFighter)
    end.

check_challenge_time() ->
    Now = time_misc:unixtime(),
    Sign = pvp_time(Now, ?SIGN_BEGIN_TIME),
    Challenge = pvp_time(Now, ?CHALLENGE_BEGIN),
    not(Now >= Sign andalso Now =< Challenge).

%%当天pvp的时间解释
pvp_time(Now, Define) ->
    {H, M} = Define,
    TodayStart = time_misc:get_timestamp_of_today_start(Now),
    TodayStart + H*?ONE_HOUR_SECONDS + M*?ONE_MINITE_SECONDS.

%% 
get_enemy_ids(PlayerId) ->
    EnemyIds1 = case get_enemeies_by_atk(PlayerId) of
                    [] ->
                        [];
                    Enemies ->
                        lists:foldl(fun(#cross_pvp_enemy{def_id   = DefId, 
                                                         atk_wins = AtkWins,
                                                         def_wins = DefWins}, Rets) ->
                                            if
                                                AtkWins > 0 andalso DefWins > 0 ->
                                                    [DefId|Rets];
                                                true -> 
                                                    Rets
                                            end
                                  end, [], Enemies)
                end,
    EnemyIds2 = case get_enemeies_by_def(PlayerId) of
                    [] ->
                        [];
                    Enemies2 ->
                        lists:foldl(fun(#cross_pvp_enemy{atk_id = AtkId,
                                                       atk_wins = AtkWins,
                                                       def_wins = DefWins}, Rets) ->
                                          if
                                              AtkWins > 0 andalso DefWins > 0 ->
                                                  [AtkId|Rets];
                                              true -> 
                                                  Rets
                                          end
                                  end, [], Enemies2)
                end,
    EnemyIds1 ++ EnemyIds2.

get_enemy(Key) ->
    hdb:dirty_read(cross_pvp_enemy, Key).

update_enemy(CrossPvpEnemy) ->
    hdb:dirty_write(cross_pvp_enemy, CrossPvpEnemy).

get_enemeies_by_atk(AtkId) ->
    hdb:dirty_index_read(cross_pvp_enemy, AtkId, #cross_pvp_enemy.atk_id).
get_enemeies_by_def(DefId) ->
    hdb:dirty_index_read(cross_pvp_enemy, DefId, #cross_pvp_enemy.def_id).

%% 构建玩家的所有小岛数量
build_islands(Fighter) ->
    Enemies = get_enemies(Fighter),
    {Ns, Islands} = lists:foldl(fun(Occupyer, {N, RetIslands}) ->
                                        {N + 1, [set_island(#cross_pvp_island{id = N,
                                                                              calc_timestamp = time_misc:unixtime()
                                                                             }, Occupyer)|RetIslands]}
                                end, {1, []}, Enemies),
    {FN, NewIslands} = if
                           Ns =:= ?PVP_MAX_ISLANDS_CNT -> 
                               Islands;
                           true -> 
                               %% 补充玩家island
                               lists:foldl(fun(Occupyer, {N, RetIslands}) ->
                                                   {N+1, [set_island(#cross_pvp_island{id = N,
                                                                                       calc_timestamp = time_misc:unixtime()
                                                                                      }, Occupyer)|RetIslands]}
                                           end, {Ns, Islands},lists:duplicate(?PVP_MAX_ISLANDS_CNT - Ns + 1, Fighter))
                       end,
    ?DEBUG("Islands Count : ~p~n",[FN]),
    ?DEBUG("Islands : ~p~n",[NewIslands]),
    NewFighter = Fighter#cross_pvp_fighter{islands = lists:reverse(NewIslands),
                                           %% calc_timestamp = time_misc:unixtime(),
                                           times   = ?PVP_DEFAULT_TIMES
                                          },
    update_cross_pvp_fighter(NewFighter),
    NewFighter.

%% 获取占领小岛的敌人 9 个敌人
get_enemies(#cross_pvp_fighter{player_id = PlayerId} = Fighter) ->
    EnemyIds              = get_enemy_ids(PlayerId),
    ?DEBUG("EnemyIds :~p~n",[EnemyIds]),
    Enemies               = get_enemy_players(2, EnemyIds, Fighter, [], [PlayerId]),    %% 宿敌
    IgnoreList            = get_ignore_ids([Fighter|Enemies]),
    NeedCnt = ?PVP_MAX_ISLANDS_CNT - length(Enemies) - 6,
    RandomEnemies = get_fighter_list(NeedCnt, Fighter, [], IgnoreList ++ EnemyIds),
    Enemies ++ RandomEnemies.

get_fighter_list(0, _Fighter, Fighters, _IgnoreIds) ->
    Fighters;
get_fighter_list(N, Fighter, Fighters, IgnoreIds) ->
    [AddFighter] = get_rand_fighter(Fighter, IgnoreIds),
    NewIgnoredIds = case AddFighter of
                        #cross_pvp_fighter{player_id = PlayerId} ->
                            [PlayerId|IgnoreIds];
                        _ ->
                            IgnoreIds
                    end,
    get_fighter_list(N - 1, Fighter, [AddFighter|Fighters], NewIgnoredIds).
        
get_ignore_ids(Fighters) ->
    lists:foldl(fun(Fighter, IDs) ->
                        case Fighter of
                            #cross_pvp_fighter{player_id = PlayerId} ->
                                [PlayerId|IDs];
                            #cross_pvp_island{occupy_id = OccupyId, 
                                              occupy_robot  = ?IS_PLAYER_0
                                             }  ->
                                [OccupyId|IDs];
                            _ ->
                                IDs
                        end
                end, [], Fighters).


%% 占领小岛
set_island(Island, #cross_pvp_fighter{player_id        = PlayerId,
                                      player_name      = Name,
                                      player_ability   = Ability,
                                      player_sn        = Sn,
                                      player_lv        = Lv,
                                      player_career    = Career
                                     } = _Occupyer) ->
    Island#cross_pvp_island{occupy_id          = PlayerId,
                            occupy_name        = Name,
                            occupy_career      = Career,
                            occupy_lv          = Lv,
                            occupy_sn          = Sn,
                            occupy_ability     = Ability,
                            occupy_robot       = 0,
                            occupy_time        = time_misc:unixtime()
                           };
set_island(Island, #base_kuafupvp_robot_attribute{robot_id = Id,
                                                  career   = Career,
                                                  lv       = Lv,
                                                  battle_ability  = Ability
                                                 }) ->
    Island#cross_pvp_island{occupy_id          = Id,
                            occupy_name        = get_robot_name(),
                            occupy_career      = Career,
                            occupy_lv          = Lv,
                            occupy_sn          = 1,
                            occupy_ability     = Ability,
                            occupy_robot       = ?IS_ROBOT_1,
                            occupy_time        = time_misc:unixtime()
                           };
set_island(Island, #cross_pvp_npc{id = Id,
                                  name = Name,
                                  ability = Ability
                                 }) ->
    Island#cross_pvp_island{occupy_id          = Id,
                            occupy_name        = Name,
                            occupy_ability     = Ability,
                            %% occupy_career      = Career,
                            %% occupy_lv          = Lv,
                            occupy_sn          = 1,
                            %% occupy_ability     = Ability,
                            occupy_robot       = ?IS_NPC_2,
                            occupy_time        = time_misc:unixtime()
                           }.


%% 获取宿敌
%% -define(MAX_ENEMY_CNT, 2).  %% 最大宿敌数
%% get_enemy_fighters(#cross_pvp_fighter{
%%                       player_ability = Ability
%%                      } = _Fighter, EnemyIds) ->
%%     lists:foldl(fun(EnemyId, {Cnt, Enemies}) when Cnt < ?MAX_ENEMY_CNT ->
%%                         case get_pvp_fighter(EnemyId) of
%%                             [] ->
%%                                 %% 玩家已经非活跃
%%                                 {Cnt, Enemies};
%%                             #cross_pvp_fighter{player_ability = EnemyAbility} = EnemyFighter ->
%%                                 case if_in_ability(Ability, EnemyAbility) of
%%                                     true ->
%%                                         {Cnt + 1, [EnemyFighter|Enemies]};
%%                                     _ ->
%%                                         {Cnt, Enemies}
%%                                 end
%%                         end;
%%                    (_, {Cnt, Enemies}) ->
%%                         {Cnt, Enemies}
%%                 end, {0, []}, EnemyIds).


%% 获取宿敌玩家
get_enemy_players(_, [], _Fighter,  EnemyPlayers, _IgnoreIds) ->
    EnemyPlayers;
get_enemy_players(0, _EnemyIds, _Fighter, EnemyPlayers, _IgnoreIds) ->
    EnemyPlayers;
get_enemy_players(N, [EnemyId|EnemyIds], #cross_pvp_fighter{player_ability = Ability
                                                           } = Fighter, EnemyPlayers, IgnoreIds) ->
    case lists:member(EnemyId, IgnoreIds) of
        false ->
            case get_pvp_fighter(EnemyId) of
                [] ->
                    get_enemy_players(N, EnemyIds, Fighter, EnemyPlayers, IgnoreIds);
                #cross_pvp_fighter{
                   player_ability = EnemyAbility
                  } = Enemy ->
                    case if_in_ability(Ability, EnemyAbility) of
                        true ->
                            get_enemy_players(N - 1, EnemyIds, Fighter, [Enemy|EnemyPlayers], [EnemyId|IgnoreIds]);
                        _ ->
                            get_enemy_players(N, EnemyIds, Fighter, EnemyPlayers, IgnoreIds)
                    end
            end;
        _ ->
            get_enemy_players(N, EnemyIds, Fighter, EnemyPlayers, IgnoreIds)
    end.




%% 获取指定分组里不同玩家
get_fighters_by_group(_Ability, 0, _Group, _IgnoreList) ->
    [];
get_fighters_by_group(Ability, N, Group, IgnoreList) when N > 0 ->
    Fighters = get_fighters_by_group(Group),
    %% 随机 5倍于需求的数量 再进行剃除
    RandList = hmisc:rand_n(5*N, Fighters),
    SelectedFighter = list_misc:keyignore(RandList, #cross_pvp_fighter.player_id, IgnoreList),
    ?DEBUG("SelectedFighter : ~p~n",[SelectedFighter]),
    case lists:sublist(SelectedFighter, N) of
        Selected when length(Selected) =:= N ->
            Selected;
        Selected ->
            Selected ++ get_robots_by_ablity(Ability, N - length(Selected))
    end.

get_robots_by_ablity(_Ability, 0) ->
    [];
get_robots_by_ablity(Ability, N) ->
    RobotAttri  = get_robot_attri(Ability),
    lists:duplicate(N, RobotAttri).

get_robot_attri(Ability) ->
    case data_base_kuafupvp_robot_attribute:get(Ability) of
        [] ->
            data_base_kuafupvp_robot_attribute:get(0);
        Attri ->
            Attri
    end.

get_robot_name() ->
    First = robot_first_name(),
    Last = robot_last_name(),
    <<First/binary, Last/binary>>.

robot_first_name() ->
    hmisc:rand([<<"东方"/utf8>>, <<"诸葛"/utf8>>, <<"皇甫"/utf8>>, <<"赵"/utf8>>, <<"钱"/utf8>>,
                <<"孙"/utf8>>, <<"李"/utf8>>, <<"柳"/utf8>>, <<"燕"/utf8>>, <<"叶"/utf8>>, <<"陈"/utf8>>,
                <<"鲜于"/utf8>>, <<"南宫"/utf8>>, <<"千叶"/utf8>>, <<"凌"/utf8>>, <<"西门"/utf8>>, <<"纪"/utf8>>]).

robot_last_name() ->
    hmisc:rand([<<"一笑"/utf8>>, <<"剑愁"/utf8>>, <<"东方"/utf8>>, <<"天问"/utf8>>, <<"不二"/utf8>>, <<"东方"/utf8>>, 
                <<"无颜"/utf8>>, <<"千愁"/utf8>>, <<"摇枷"/utf8>>, <<"莫言"/utf8>>, <<"青寒"/utf8>>, <<"若冰"/utf8>>, 
                <<"踏歌"/utf8>>, <<"萧潇"/utf8>>, <<"不惜"/utf8>>, <<"幻然"/utf8>>, <<"不悔"/utf8>>, <<"清韵"/utf8>>, 
                <<"淡风"/utf8>>, <<"莫画"/utf8>>, <<"昔雨"/utf8>>, <<"谷雪"/utf8>>, <<"天晴"/utf8>>, <<"灵竹"/utf8>>]).


%% get_fighter(#cross_pvp_sign{player_id = PlayerId}) ->
%%     #cross_pvp_fighter{
%%       };
%% get_fighter(RobotId) ->
%%     #cross_pvp_fighter{}.


%% filter_ignored(Signs, IgnoreList) ->
%%     lists:foldl(fun(#cross_pvp_fighter{player_id = PlayerId
%%                                       } = Sign, RET) ->
%%                         case lists:member(PlayerId, IgnoreList) of
%%                             false ->
%%                                 [Sign|RET];
%%                             true ->
%%                                 RET
%%                         end
%%                 end, [], Signs).   


do_join_pvp(Player) ->
    Fighter = init_pvp_fighter(Player),
    update_cross_pvp_fighter(Fighter).

init_pvp_fighter(#player{id = PlayerId,
                         lv = Lv,
                         sn = Sn,
                         high_ability = Ability,
                         career = Career,
                         nickname = Name
                        } = _Player) ->
    Group = get_group_by_ability(Ability),
    #cross_pvp_fighter{player_id          = PlayerId,
                       player_name        = Name,
                       group              = Group,     %% 战斗力分组
                       player_career      = Career,
                       player_lv          = Lv,
                       player_sn          = Sn,
                       player_ability     = Ability,
                       event_timestamp    = time_misc:unixtime(),
                       times              = 20         %% 可挑战次数等
                      }.

update_cross_pvp_fighter(Fighter) ->
    hdb:dirty_write(cross_pvp_fighter, Fighter).
%% 获取指定战力分组的所有成员
get_fighters_by_group(Group) ->
    hdb:dirty_index_read(cross_pvp_fighter, Group, #cross_pvp_fighter.group, true).

delete_cross_pvp_fighter(PlayerId) ->
    hdb:dirty_delete(cross_pvp_fighter, PlayerId).

%% get_islands(PlayerId) ->
%%     case get_pvp_fighter(PlayerId) of
%%         [] ->
%%             [];
%%         #cross_pvp_fighter{
%%            islands = Islands
%%           } = _PlayerTeam ->
%%             Islands
%%     end.

%% get_player_records(PlayerId) ->
%%     case get_pvp_fighter(PlayerId) of
%%         [] ->
%%             [];
%%         #cross_pvp_fighter{
%%            records = Records
%%           } ->
%%             Records
%%     end.


get_pvp_fighter(PlayerId) ->
    case hdb:dirty_read(cross_pvp_fighter, PlayerId) of
        [] ->
            [];
        #cross_pvp_fighter{
           islands = Islands
           %% records = Records,
           %% events  = Events
          } = Fighter ->
            %% upgrade
            NewIslands = hdb:try_upgrade_record(Islands),
            %% NewRecords = hdb:try_upgrade_record(Records),
            %% NewEvents = hdb:try_upgrade_record(Events),
            Fighter#cross_pvp_fighter{
              islands = NewIslands
              %% records = NewRecords,
              %% events  = NewEvents
             } 
    end.

%%是否势均力敌
if_in_ability(0, _) ->
    false;
if_in_ability(_, 0) ->
    false;
if_in_ability(Ability1, Ability2) when Ability1 >= Ability2 ->
    (Ability1 / Ability2) =< ?ABILITY_FLOW_HIGH;
if_in_ability(Ability1, Ability2) ->
    (Ability2 / Ability1) =< ?ABILITY_FLOW_HIGH.


add_enemy(AtkId, DefId) ->
    {NewAtkId, NewDefId} = Key = get_enemy_key(AtkId, DefId),
    {AddAtkTime, AddDefTime} = case {NewAtkId, NewDefId} of
                                   {AtkId, DefId} ->
                                       {1, 0};
                                   {DefId, AtkId} ->
                                       {0, 1}
                               end,
    case get_enemy(Key) of
        [] ->
            CrossPvpEnemy = #cross_pvp_enemy{key = Key,
                                             atk_id = NewAtkId,
                                             def_id = NewDefId,
                                             atk_wins = AddAtkTime,
                                             def_wins = AddDefTime
                                            },
            update_enemy(CrossPvpEnemy),
            CrossPvpEnemy;
        #cross_pvp_enemy{
           atk_wins = AtkWins,
           def_wins = DefWins
          } = CrossEnemy ->
            NewCrossPvpEnemy = CrossEnemy#cross_pvp_enemy{atk_wins = AtkWins + AddAtkTime,
                                                          def_wins = DefWins + AddDefTime
                                                         },
            update_enemy(NewCrossPvpEnemy),
            NewCrossPvpEnemy
    end.
remove_enemy(AtkId, DefId) ->
    Key = get_enemy_key(AtkId, DefId),
    case get_enemy(Key) of
        [] ->
            ignored;
        #cross_pvp_enemy{
          } = CrossEnemy ->
            NewCrossPvpEnemy = CrossEnemy#cross_pvp_enemy{atk_wins = 0,
                                                          def_wins = 0
                                                         },
            update_enemy(NewCrossPvpEnemy)
    end.
get_enemy_key(AtkId, DefId) when AtkId < DefId ->
    {AtkId, DefId};
get_enemy_key(AtkId, DefId) ->
    {DefId, AtkId}.

reset_event_timestamp(PlayerId)->
    case get_pvp_fighter(PlayerId) of
        [] ->
            ignored;
        #cross_pvp_fighter{} = Fighter ->
            update_cross_pvp_fighter(Fighter#cross_pvp_fighter{event_timestamp = 0})
    end.

reset_island(#player{id = PlayerId} = Player, IslandId) ->
    case get_pvp_fighter(PlayerId) of
        [] ->
            {fail, ?INFO_PVP_ISLAND_NOT_FOUND};
        #cross_pvp_fighter{
           islands = Islands
           %% records = Records
          } = Fighter ->
            case lists:keyfind(IslandId, #cross_pvp_island.id, Islands) of
                false ->
                    {fail, ?INFO_PVP_ISLAND_NOT_FOUND};
                #cross_pvp_island{occupy_id = OccupyId,
                                  occupy_time = OccupyTime
                                 } = SelectedIsland ->
                    Now = time_misc:unixtime(),
                    if
                        OccupyId =:= Player ->
                            {fail, ?INFO_CANT_RESET_SELF_ISLAND};
                        OccupyTime + 2 * ?ONE_DAY_SECONDS > Now ->
                            {fail, ?INFO_ISLAND_OCCUPY_TIME_NOT_ENOUGH};
                        true -> 
                            case get_new_enemy(?ENEMY_FIRST, Fighter) of
                                [Attacker] ->
                                    NewIsland  = set_island(SelectedIsland, Attacker),
                                    NewIslands = lists:keyreplace(IslandId, #cross_pvp_island.id, Islands, NewIsland#cross_pvp_island{occupy_time = Now}),  %% 修正占领时间
                                    ?DEBUG("Robot Occupy Island : ~p, NewIslands : ~p~n",[NewIsland, NewIslands]),
                                    %% Record = build_record(NewIsland, SelectedIsland, ?CHALLENGE_PVP_WIN),
                                    %% NewRecords = try_add_record(Records, Record#cross_pvp_record{timestamp = Now}), %% 修正记录生成时间
                                    NewFighter = Fighter#cross_pvp_fighter{
                                                   islands = NewIslands
                                                  },
                                    update_cross_pvp_fighter(NewFighter),
                                    remove_enemy(PlayerId, OccupyId),
                                    {ok, NewIsland};
                                {enemy, [Attacker]} ->
                                    NewIsland  = set_island(SelectedIsland, Attacker),
                                    NewIslands = lists:keyreplace(IslandId, #cross_pvp_island.id, Islands, NewIsland#cross_pvp_island{
                                                                                                             occupy_time = Now,
                                                                                                             is_enemy    = ?ENEMY_FLAG_TRUE
                                                                                                            }),  %% 修正占领时间
                                    ?DEBUG("Robot Occupy Island : ~p, NewIslands : ~p~n",[NewIsland, NewIslands]),
                                    %% Record = build_record(NewIsland, SelectedIsland, ?CHALLENGE_PVP_WIN),
                                    %% NewRecords = try_add_record(Records, Record#cross_pvp_record{timestamp = Now}), %% 修正记录生成时间
                                    NewFighter = Fighter#cross_pvp_fighter{
                                                   islands = NewIslands
                                                   %% records = NewRecords
                                                  },
                                    update_cross_pvp_fighter(NewFighter),
                                    remove_enemy(PlayerId, OccupyId),
                                    {ok, NewIsland};
                                _ ->
                                    {fail, ?INFO_CONF_ERR}
                            end
                    end
            end
    end.

reset_island_occupy_timestamp(PlayerId, IslandId) ->
    case get_pvp_fighter(PlayerId) of
        [] ->
            ignored;
        #cross_pvp_fighter{
           islands = Islands
          } = Fighter ->
            case lists:keyfind(IslandId, #cross_pvp_island.id, Islands) of
                false ->
                    ignored;
                #cross_pvp_island{                   
                  } = Island ->
                    NewIslands = lists:keyreplace(IslandId, #cross_pvp_island.id, Islands, Island#cross_pvp_island{occupy_time = 0
                                                                                            }),
                    update_cross_pvp_fighter(Fighter#cross_pvp_fighter{islands = NewIslands
                                              })
            end

    end.

update_player(#player{id = PlayerId} = Player) ->
    case get_pvp_fighter(PlayerId) of
        [] ->
            ignored;
        Fighter ->
            Group = get_group_by_ability(Player#player.high_ability),
            NewFighter = Fighter#cross_pvp_fighter{
                           player_lv = Player#player.lv,
                           player_ability = Player#player.high_ability,
                           group = Group 
                          },
            update_cross_pvp_fighter(NewFighter)
    end.

get_group_by_ability(Ability) ->
    case data_base_ability:get(Ability) of
        [] ->
            1;
        GroupId ->
            GroupId
    end.

