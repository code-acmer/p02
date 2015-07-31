-module(lib_dungeon_match).
-author('liuzhigang@moyou.me').

-include("define_dungeon_match.hrl").
-include("define_dungeon.hrl").
-include("define_player.hrl").
-include("define_logger.hrl").

-export([new/5,
         dungeon_team_id/0,
         lookup_dungeon/4,
         instance_info/3,
         update_dungeon_match/2,
         get_player_dungeon_match_table/0,
         get_player_win_rate/2]).

-export([try_join_dungeon/2,
         leave_dungeon_match/2,
         leave_pass_dungeon/1]).

-export([test/0]).

-define(MATCH(EXPR1, EXPR2), 
        case EXPR1 =:= EXPR2 of
            true ->
                ok;
            _ ->
                ?WARNING_MSG("NOT MATCH ~n"),
                fail
        end).

%%------------------------------------for the test-----------------------------%%
test() ->
    Player1 = {#player{id = 1, lv = 5, battle_ability = 1000}, 0},
    Player2 = {#player{id = 2, lv = 15, battle_ability = 1600}, 0},
    Player3 = {#player{id = 3, lv = 30, battle_ability = 3000}, 0},
    Player4 = {#player{id = 4, lv = 45, battle_ability = 2000}, 50},
    Player5 = {#player{id = 5, lv = 45, battle_ability = 2000}, 70},
    Player6 = {#player{id = 6, lv = 45, battle_ability = 1600}, 50},
    Player7 = to_player(7, 45, 1600, 70),
    Player8 = to_player(8, 50, 3000, 50),
    Player9 = to_player(9, 61, 4000, 30),
    Player10 = to_player(10, 61, 4000, 50),
    Player11 = to_player(11, 62, 5000, 30),
    Player12 = to_player(12, 63, 7000, 30),
    Player13 = to_player(13, 64, 10000, 30),
    Player14 = to_player(14, 66, 10000, 20),
    Player15 = to_player(15, 67, 2000, 30),
    Player16 = to_player(16, 68, 30000, 30),
    ok = test2(Player1, Player2, false),
    ok = test2(Player1, Player3, false),
    ok = test2(Player1, Player4, false),
    ok = test2(Player1, Player8, false),
    ok = test2(Player1, Player9, false),
    ok = test2(Player1, Player12, false),
    ok = test2(Player2, Player3, true),
    ok = test2(Player3, Player2, true),
    ok = test2(Player4, Player5, true),
    ok = test2(Player5, Player4, true),
    ok = test2(Player4, Player6, false),
    ok = test2(Player6, Player4, false),
    ok = test2(Player5, Player6, false),
    ok = test2(Player6, Player5, false),
    ok = test2(Player4, Player7, true),
    ok = test2(Player7, Player4, true),
    ok = test2(Player7, Player8, true),
    ok = test2(Player8, Player7, false),
    ok = test2(Player9, Player10, true),
    ok = test2(Player10, Player9, true),
    ok = test2(Player9, Player11, false),
    ok = test2(Player11, Player9, false),
    ok = test2(Player10, Player11, true),
    ok = test2(Player11, Player10, true),
    ok = test2(Player10, Player12, true),
    ok = test2(Player12, Player10, true),
    ok = test2(Player10, Player13, true),
    ok = test2(Player13, Player10, false),
    ok = test2(Player14, Player15, true),
    ok = test2(Player14, Player16, true),
    ok = test2(Player15, Player16, true),
    ?PRINT("all pass ~n", []).
    

to_player(Id, Lv, Ability, WinRate) ->
    {#player{id = Id, lv = Lv, battle_ability = Ability}, WinRate}.

test2({PlayerA, WinRateA}, {PlayerB, WinRateB}, Bool) ->
    {DungeonMatch, _BaseDungeonMatch} = make_dungeon_match(PlayerB, WinRateB),
    BaseDungeonMatch = data_base_dungeon_match:get(PlayerA#player.lv),
    IfFind = 
        case test_lookup_dungeon(PlayerA, BaseDungeonMatch, WinRateA, [DungeonMatch]) of
            false ->
                false;
            _ ->
                true
        end,
    case ?MATCH(IfFind, Bool) of
        ok ->
            skip;
        _ ->
            ?WARNING_MSG("error ~p => ~p ~p~n", [PlayerA#player.id, PlayerB#player.id, DungeonMatch]),
            throw(not_match)
    end,
    ok.

make_dungeon_match(Player, WinRate) ->
    #base_dungeon_match{id = [Min, Max],
                        num = MaxNum,
                        high_win_rate = HighWin,
                        float_battle_ability = FloatAbilityRate} 
        = BaseDungeonMatch 
        = data_base_dungeon_match:get(Player#player.lv),
    AbilityRange = player_ability_range(WinRate, HighWin, Player#player.battle_ability, FloatAbilityRate),
    {#dungeon_match{id = 123456,
                    dungeon_type = {123456, Min, Max},
                    player_id_list = [Player#player.id],
                    player_lv = Player#player.lv,
                    battle_ability = Player#player.battle_ability,
                    ability_range = AbilityRange,
                    cur_num = 1,
                    max_num = MaxNum,
                    dungeon_info = [],
                    all_drop = []}, BaseDungeonMatch}.

test_lookup_dungeon(#player{battle_ability = PlayerAbility,
                            lv = PlayerLv}, #base_dungeon_match{num = MaxNum,
                                                                id = [MinLv, MaxLv],
                                                                float_lv = FloatLv,
                                                                high_win_rate = HighWin,
                                                                float_battle_ability = FloatAbilityRate}, WinRate, MatchList) ->
    FunAbility = 
        fun(#dungeon_match{ability_range = [MinAbility, MaxAbility]}) ->
                PlayerAbility >= MinAbility andalso PlayerAbility =< MaxAbility
        end,
    AbilityCondition = ability_condition(WinRate, HighWin, PlayerAbility, FloatAbilityRate),
    case list_misc:list_match_one([{#dungeon_match.cur_num, "<", MaxNum},
                                   {#dungeon_match.state, ?STATE_NORMAL},
                                   {#dungeon_match.dungeon_type, {123456, MinLv, MaxLv}},
                                   {#dungeon_match.player_lv, between, [PlayerLv - FloatLv, PlayerLv + FloatLv]},
                                   FunAbility,
                                   AbilityCondition
                                  ], MatchList) of
        [] ->
            false;
        _ ->
            true
    end.
        
%%------------------------------------for the test-----------------------------%%


%%new接口不用经过进程
new(Player, DungeonInfo, AllDrop, WinRate, BaseDungeonMatch) 
  when is_record(DungeonInfo, dungeon_info) ->
    ?DEBUG("new dungeon_match ~n", []),
    #base_dungeon_match{id = [Min, Max],
                        num = MaxNum,
                        high_win_rate = HighWin,
                        float_battle_ability = FloatAbilityRate} = BaseDungeonMatch,
    AbilityRange = player_ability_range(WinRate, HighWin, Player#player.battle_ability, FloatAbilityRate),
    DungeonMatch = 
        #dungeon_match{id = DungeonInfo#dungeon_info.team_id,
                       dungeon_type = {DungeonInfo#dungeon_info.dungeon_id, Min, Max},
                       player_id_list = [Player#player.id],
                       player_lv = Player#player.lv,
                       battle_ability = Player#player.battle_ability,
                       ability_range = AbilityRange,  %%该副本允许的战力范围
                       cur_num = 1,
                       max_num = MaxNum,
                       dungeon_info = DungeonInfo,
                       all_drop = AllDrop},
    hdb:dirty_write(dungeon_match, DungeonMatch).
%%为了较少给mod_dungeon_match发送大量消息，player可以预先检查一下数据库有没有符合自己的
%%数据，没有的话就直接new一个，有再去call进程，如果过程中被抢了，那就new，否则直接拿来用
lookup_dungeon(DungeonId, #player{id = PlayerId,
                                  lv = PlayerLv,
                                  battle_ability = PlayerAbility} = Player, 
               #base_dungeon_match{id = [MinLv, MaxLv],
                                   num = MaxNum,
                                   min_win_rate = MinWinRate,
                                   high_win_rate = HighWin,
                                   float_lv = FloatLv,
                                   float_battle_ability = FloatAbilityRate}, WinRate) ->
    AbilityCondition = ability_condition(WinRate, HighWin, PlayerAbility, FloatAbilityRate),
    FunAbility = 
        fun(#dungeon_match{ability_range = [MinAbility, MaxAbility],
                           player_id_list = PlayerIds}) ->
                case PlayerAbility >= MinAbility andalso PlayerAbility =< MaxAbility of
                    false ->
                        false;
                    true ->
                        ?DEBUG("PlayerId ~p, PlayerIds ~p~n", [PlayerId, PlayerIds]),
                        not lists:member(PlayerId, PlayerIds)
                end
        end,
    if
        %% 只允许单人的就直接返回，没有其它操作了
        MaxNum =< 1 ->
            ?DEBUG("dungeon_match only allow single PlayerId ~p~n", [PlayerId]),
            single_dungeon;
        WinRate < MinWinRate ->
            ?DEBUG("dungeon_match  WinRate ~p < MinWinRate ~p~n", [WinRate, MinWinRate]),
            for_npc;
        true ->
            case hdb:dirty_index_read(dungeon_match, {DungeonId, MinLv, MaxLv}, #dungeon_match.dungeon_type) of
                [] ->
                    ?DEBUG("dungeon_match not find others PlayerId ~p lv ~p ability ~p WinRate ~p DungeonId ~p, LvInfo ~p~n", 
                           [PlayerId, PlayerLv, PlayerAbility, WinRate, DungeonId, {MinLv, MaxLv}]),
                    false;
                MatchList ->
                    case list_misc:list_match_one([{#dungeon_match.cur_num, "<", MaxNum},
                                                   {#dungeon_match.state, ?STATE_NORMAL},
                                                   {#dungeon_match.player_lv, between, [PlayerLv - FloatLv, PlayerLv + FloatLv]},
                                                   FunAbility,
                                                   AbilityCondition
                                                  ], MatchList) of
                        [] ->
                            ?DEBUG("dungeon_match find but limit PlayerId ~p lv ~p  ability ~p WinRate ~p~n",
                                   [PlayerId, PlayerLv, Player#player.battle_ability, WinRate]),
                            false;
                        #dungeon_match{id = TeamId,
                                       player_id_list = PlayerIdList,
                                       battle_ability = TeamAbility} ->
                            ?DEBUG("dungeon_match find PlayerId ~p lv ~p PlayerIdList ~p ability ~p TeamAbility ~p WinRate ~p~n",
                                   [PlayerId, PlayerLv, PlayerIdList, Player#player.battle_ability, TeamAbility, WinRate]),
                            mod_dungeon_match:enter_dungeon(PlayerId, TeamId)
                    end
            end
    end.

ability_condition(WinRate, HighWin, Ability, FloatAbilityRate) ->
    fun(#dungeon_match{battle_ability = TeamAbility}) ->
            Min = TeamAbility*(100 - FloatAbilityRate) div 100,
            Max = TeamAbility*(100 + FloatAbilityRate) div 100,
            if
                WinRate < HighWin ->
                    %?DEBUG("not high Ability ~p TeamAbility ~p~n", [Ability, TeamAbility]),
                    Ability >= TeamAbility;
                true ->
                    %?DEBUG("high Ability ~p TeamAbility ~p~n", [Ability, TeamAbility]),
                    Ability >= Min andalso Ability =< Max                  
            end
    end.

player_ability_range(WinRate, HighWin, Ability, FloatAbilityRate) ->
    Min = max(0, Ability*(100 - FloatAbilityRate) div 100),
    Max = Ability*(100 + FloatAbilityRate) div 100,
    if
        WinRate < HighWin ->
            [Min, Ability];
        true ->
            [Min, Max]                
    end.
    
                
%%HTTP服务器提供的信息
instance_info(InstanceId, SubDungeonId, Invalid) ->
    set_dungeon_reject(InstanceId, SubDungeonId, Invalid).

dungeon_team_id() ->
    lib_counter:update_counter(dungeon_match_uid, 1).

%%用于多人服通知不能进
set_dungeon_reject(TeamId, SubDungeonId, Bool) ->
    case hdb:dirty_read(dungeon_match, TeamId) of
        [] ->
            ?DEBUG("not find DungeonMatch TeamId ~p~n", [TeamId]),
            skip;
         #dungeon_match{dungeon_info = DungeonInfo} = DungeonMatch ->
            ?DEBUG("dungeon_match recv http msg TeamId ~p, SubDungeonId ~p, Bool ~p~n",
                   [TeamId, SubDungeonId, Bool]),
            NewDungeonMatch = 
                if
                    Bool =:= true ->
                        DungeonMatch#dungeon_match{dungeon_info = DungeonInfo#dungeon_info{sub_dungeon_id = SubDungeonId}};
                    true ->
                        DungeonMatch#dungeon_match{dungeon_info = DungeonInfo#dungeon_info{sub_dungeon_id = SubDungeonId},
                                                   state = ?STATE_REJECT}
                end,
            hdb:dirty_write(dungeon_match, NewDungeonMatch)
    end.

update_dungeon_match(#player{id = PlayerId,
                             lv = Lv}, BossFlag) ->
    Table = get_player_dungeon_match_table(),
    case data_base_dungeon_match:get(Lv) of
        [] ->
            skip;
        #base_dungeon_match{id = LvRange} ->
            NewDungeonMatch = 
                case hdb:dirty_read(Table, PlayerId, true) of
                    #player_dungeon_match{lv_range = LvRange} = DungeonMatch ->
                        DungeonMatch;
                    _ ->
                        #player_dungeon_match{player_id = PlayerId,
                                              lv_range = LvRange
                                             }
                end,
            update_dungeon_match2(NewDungeonMatch, BossFlag)
    end.

update_dungeon_match2(#player_dungeon_match{win_times = Win,
                                            fail_times = Fail} = DungeonMatch, BossFlag) -> 
    NewDungeonMatch = 
        if
            BossFlag =:= ?BOSS_FLAG_WIN ->
                DungeonMatch#player_dungeon_match{win_times = Win + 1};
            BossFlag =:= ?BOSS_FLAG_FAIL -> 
                DungeonMatch#player_dungeon_match{fail_times = Fail + 1};
            true ->
                DungeonMatch    
        end,
    Table = get_player_dungeon_match_table(),
    hdb:dirty_write(Table, NewDungeonMatch).

get_player_win_rate(PlayerId, LvRange) ->
    Table = get_player_dungeon_match_table(),
    case hdb:dirty_read(Table, PlayerId, true) of
        #player_dungeon_match{lv_range = LvRange,
                              win_times = Win,
                              fail_times = Fail} ->
            case Win + Fail of
                0 ->
                    100;
                Value ->
                    (Win * 100) div Value  
            end;
        _ ->
            hdb:dirty_write(Table, 
                            #player_dungeon_match{player_id = PlayerId,
                                                  lv_range = LvRange
                                                 }),
            100
    end.

get_player_dungeon_match_table() ->
    case lib_dungeon:is_double_drop_time() of
        true ->
            player_dungeon_match_activity;
        _ ->
            player_dungeon_match
    end.



%%--------------for mod_dungeon_match---------------------------------%%
try_join_dungeon(PlayerId, TeamId) ->
    case hdb:dirty_read(dungeon_match, TeamId) of
        #dungeon_match{player_id_list = PlayerIds,
                       cur_num = CurNum,
                       max_num = MaxNum} = DungeonMatch when CurNum < MaxNum ->
            NewPlayerIds = lists:usort([PlayerId|PlayerIds]),
            NewMatch = DungeonMatch#dungeon_match{player_id_list = NewPlayerIds,
                                                  cur_num = length(NewPlayerIds)},
            hdb:dirty_write(dungeon_match, NewMatch),
            {ok, NewMatch};
        _ ->
            false
    end.

%% 玩家从副本匹配表中移除
leave_dungeon_match(PlayerId, TeamId) ->
    case hdb:dirty_read(dungeon_match, TeamId) of
        [] ->
            skip;
        #dungeon_match{player_id_list = PlayerIdList} = DungeonMatch ->
            case PlayerIdList -- [PlayerId] of
                [] ->
                    ?DEBUG("PlayerIdList ~p PlayerId ~p~n", [PlayerIdList, PlayerId]),
                    hdb:dirty_delete(dungeon_match, TeamId);
                NewIdList ->
                    hdb:dirty_write(dungeon_match, 
                                    DungeonMatch#dungeon_match{player_id_list = NewIdList,
                                                               cur_num = length(NewIdList)})
            end
    end.

leave_pass_dungeon(TeamId) ->
    hdb:dirty_delete(dungeon_match, TeamId).



