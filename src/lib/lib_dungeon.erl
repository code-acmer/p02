-module(lib_dungeon).

-export([try_entry_dungeon/2,
         get_reward_new/2,
         dungeon_flip_card/4,         
         create_role/1,
         relive/3,
         get_boss_hp/1,
         check_dungeon/2,
         generate_dungeon_item/1,
         generate_dungeon_item/2,
         buy_healing_salve/2,
         is_double_drop/1,
         extra_vip_hit_reward/2,
         series_dungeon_info/2,
         mop_up/4,
         is_double_drop_time/0
        ]).

-export([login_dungeon/1,
         save_dungeon/1,
         daily_reset_dungeon/1,
         buy_dungeon_times/2]).

-export([login_mugen/1,
         reset_mugen/1,
         save_mugen/1,
         skip_mugen/2,
         mugen_challenge/2,
         login_mugen_reward/1,
         save_mugen_reward/1,
         send_lucky_coin/2,
         get_mugen_condition/2]).

%%暂时废弃，策划问题
-export([login_daily_dungeon/1,
         get_daily_dungeon/1,
         save_daily_dungeon/1,
         reset_daily_dungeon/1]).
%%日常副本
-export([login_source_dungeon/1,
         save_source_dungeon/1,
         reset_source_dungeon/1]).

-export([login_super_battle/1,
         save_super_battle/1,
         reset_super_battle/2,
         restart_super_battle/2,
         buy_super_battle_times/1
        ]).

%% 测试查询接口
-export([test_dungeon/0,
         test_dungeon/1,
         get_sub_monsters/1,
         generate_monsters_list_new/2]).

-include("define_logger.hrl").
-include("pb_12_pb.hrl").
-include("define_player.hrl").
-include("define_dungeon.hrl").
-include("define_goods_type.hrl").
-include("define_reward.hrl").
-include("define_info_12.hrl").
-include("define_info_15.hrl").
-include("define_monster.hrl").
-include("define_money_cost.hrl").
-include("define_task.hrl").
-include("define_log.hrl").
-include("define_rank.hrl").
-include("define_mail.hrl").
-include("define_dungeon_match.hrl").
-include("define_mnesia.hrl").
-include("db_base_vip.hrl").

create_role(PlayerId) ->
    Begin = 
        case data_base_mugen_tower:get_mugen_id_range() of
            [] ->
                0;
            [Min, _] ->
                #base_mugen_tower{area_id = Id} = data_base_mugen_tower:get(Min),
                Id
        end,
    hdb:dirty_write(dungeon_mugen, #dungeon_mugen{
                                      player_id = PlayerId,
                                      last_dungeon = Begin}),
    SuperBattleBegin = 
        case data_base_dungeon_area:get_super_battle_id_range() of
            [] ->
                0;
            [Min2, _] ->
                Min2
        end,
    hdb:dirty_write(super_battle, #super_battle{
                                     player_id = PlayerId,
                                     last_dungeon = SuperBattleBegin,
                                     rest = 1,
                                     next_dungeon = get_super_battle_next(SuperBattleBegin)}),
    hdb:dirty_write(source_dungeon, new_source_dungeon(PlayerId)).

        
login_dungeon(PlayerId) ->
    hdb:dirty_index_read(dungeon, PlayerId, #dungeon.player_id, true).

login_mugen(PlayerId) ->
    hdb:dirty_read(dungeon_mugen, PlayerId, true).

new_super_battle(PlayerId) ->
    SuperBattleBegin = 
        case data_base_dungeon_area:get_super_battle_id_range() of
            [] ->
                0;
            [Min2, _] ->
                Min2
        end,
    #super_battle{
       player_id = PlayerId,
       last_dungeon = SuperBattleBegin,
       rest = 1,
       cur_hp = 100,
       next_dungeon = get_super_battle_next(SuperBattleBegin),
       dirty = 1}.

login_super_battle(#player{id = PlayerId,
                           high_ability = Ability
                          } = _Player) ->
    case hdb:dirty_read(super_battle, PlayerId, true) of
        [] ->
            SuperBattle = new_super_battle(PlayerId),
            NewAbility = get_super_battle_ability(Ability),
            hdb:dirty_write(super_battle, SuperBattle#super_battle{ability = NewAbility}),
            SuperBattle;
        Other ->
            Other
    end.

login_daily_dungeon(Player) ->
    PlayerId = Player#player.id,
    case hdb:dirty_read(daily_dungeon, PlayerId, true) of
        [] ->
            reset_daily_dungeon(Player);
        Other ->
            Other
    end.
login_mugen_reward(PlayerId) ->
    hdb:dirty_index_read(mugen_reward, PlayerId, #mugen_reward.player_id, true).

login_source_dungeon(PlayerId) ->
    case hdb:dirty_read(source_dungeon, PlayerId, true) of
        [] ->
            dirty_source_dungeon(new_source_dungeon(PlayerId));
        Other ->
            Other
    end.

save_source_dungeon(SourceDungeon) 
  when is_record(SourceDungeon, source_dungeon) ->
    hdb:save(SourceDungeon, #source_dungeon.dirty).

save_mugen_reward(MugenRewardList) ->
    lists:map(fun(MugenReward) ->
                      hdb:save(MugenReward, #mugen_reward.dirty)
              end, MugenRewardList).

save_daily_dungeon([]) ->
    [];
save_daily_dungeon(DailyDungeon) ->
    hdb:save(DailyDungeon, #daily_dungeon.dirty).

save_mugen(DungeonMugen) ->
    hdb:save(DungeonMugen, #dungeon_mugen.dirty).

save_super_battle(SuperBattle)
  when is_record(SuperBattle, super_battle)->
    hdb:save(SuperBattle, #super_battle.dirty).

save_dungeon(DungeonList) ->
    lists:map(fun(Dungeon) ->
                      hdb:save(Dungeon, #dungeon.dirty)
              end, DungeonList).

daily_reset_dungeon(DungeonList) ->
    lists:map(fun(#dungeon{dungeon_level = ?KING_DUNGEON_TYPE} = Dungeon) ->
                      NewDungeon = Dungeon#dungeon{left_times = ?DEFAULT_KING_DUNGEON_TIMES,
                                                   buy_times = 0,
                                                   boss_reward_flag = 0
                                                  },
                      hdb:dirty(NewDungeon, #dungeon.dirty);
                 (Other) ->
                      Other
              end, DungeonList).

new_source_dungeon(PlayerId) ->
    #source_dungeon{player_id = PlayerId,
                    info = []}.

reset_source_dungeon(#source_dungeon{} = SourceDungeon) 
  when is_record(SourceDungeon, source_dungeon) ->
    dirty_source_dungeon(SourceDungeon#source_dungeon{
                           info = []}).

reset_mugen(DungeonMugen) ->
    Begin = 
        case data_base_mugen_tower:get_mugen_id_range() of
            [] ->
                0;
            [Min, _] ->
                #base_mugen_tower{area_id = Id} = data_base_mugen_tower:get(Min),
                Id
        end,
    NewMugen = DungeonMugen#dungeon_mugen{last_dungeon = Begin,
                                          have_pass_times = 0,
                                          rest = 1,
                                          send_lucky_coin = 0,
                                          use_lucky_coin = 0,
                                          challenge_list = [],
                                          challenge_times = 1,
                                          skip_flag = ?SKIP_MUGEN_ON},
    dirty_mugen(NewMugen).

reset_super_battle(SuperBattle, Player) ->
    %% Begin = 
    %%     case data_base_dungeon_area:get_super_battle_id_range() of
    %%         [] ->
    %%             0;
    %%         [Min, _] ->
    %%             Min
    %%     end,
    ResetTimes = lib_vip:max_reset_super_battle(Player#player.vip),
    dirty_super_battle(SuperBattle#super_battle{rest = ResetTimes,
                                                %% last_dungeon = Begin,
                                                %% cur_hp = 100,
                                                buy_times = 0
                                                %% next_dungeon = get_super_battle_next(Begin)
                                               }).

reset_daily_dungeon(Player) ->
    PlayerId = Player#player.id,
    case get_daily_dungeon(Player#player.lv) of
        {DungeonId, Condition} when is_integer(DungeonId)->
            DailyDungeon = set_condition(#daily_dungeon{}, Condition),
            dirty_daily_dungeon(DailyDungeon#daily_dungeon{player_id = PlayerId,
                                                           dungeon_id = DungeonId,
                                                           left_times = 1});
        _ ->
            dirty_daily_dungeon(#daily_dungeon{player_id = PlayerId})
    end.

set_condition(DailyDungeon, Condition)
  when is_record(DailyDungeon, daily_dungeon) ->
    lists:foldl(fun({Key, Value}, AccDailyDungeon) ->
                        dynarec_daily_dungeon_misc:rec_set_value(Key, Value, AccDailyDungeon)
                end, DailyDungeon, Condition).

dirty_daily_dungeon(DailyDungeon) ->
    hdb:dirty(DailyDungeon, #daily_dungeon.dirty).

check_dungeon(#mod_player_state{player = Player} = ModPlayerState, DungeonId) ->
    case data_base_dungeon_area:get(DungeonId) of
        [] -> 
            {fail, ?INFO_DUNGEON_DUNGEON_NOT_EXIST};
        #base_dungeon_area{req_time = ReqTime,
                           req_vigor = ReqVigor,
                           lv = ReqLv
                          } = Dungeon  ->
            IsInTime = check_req_time(ReqTime),
            IsEnoughLv = check_req_lv(ReqLv, Player#player.lv, Dungeon#base_dungeon_area.dungeon_type),         
            if
                IsInTime =:= false ->
                    {fail, ?INFO_DUNGEON_IN_TIME};
                IsEnoughLv =:= false ->
                    {fail, ?INFO_NOT_ENOUGH_LEVEL};
                Player#player.vigor < ReqVigor ->
                    {fail, ?INFO_NOT_ENOUGH_VIGOR};
                true  ->
                    case check_entry_dungeon(ModPlayerState, Dungeon) of 
                        {fail, Reason} ->
                            {fail, Reason};
                        true  ->
                            {true, ModPlayerState, Dungeon};
                        {true, NewModPlayerState} ->
                            {true, NewModPlayerState, Dungeon}
                    end
            end
    end.

%% 尝试进入关卡
try_entry_dungeon(#mod_player_state{player = Player,
                                    dungeon_list = DungeonList,
                                    dungeon_info = OldDungeonInfo} = ModPlayerState, Id) ->
    if
        is_record(OldDungeonInfo, dungeon_info) ->
            if
                %% 黄雀在后组队副本
                OldDungeonInfo#dungeon_info.team_type =:= ?TEAM_TYPE_MASTER andalso 
                OldDungeonInfo#dungeon_info.team_id > 0 ->
                    mod_dungeon_match:leave(Player#player.id, OldDungeonInfo#dungeon_info.team_id);
                true ->
                    skip
            end;
        true ->
            skip
    end,
    case check_dungeon(ModPlayerState, Id) of
        {fail, Reason} ->
            {fail, Reason};
        {true, NewModPlayerState, Dungeon} ->
            case get_dungeon_info(Dungeon, Player) of
                {ok, DungeonInfo, AllDrop} ->
                    {Grade, Pass} = get_dungeon_grade_time(Id, Dungeon#base_dungeon_area.dungeon_type, DungeonList),
                    lib_log_player:add_log(?LOG_EVENT_ENTER_DUNGEON, Id, Player#player.lv),
                    {ok, NewModPlayerState#mod_player_state{dungeon_info = 
                                                                DungeonInfo#dungeon_info{grade = Grade,
                                                                                         pass_time = Pass}}, AllDrop};
                {fail, Reason} ->
                    {fail, Reason}
            end
    end.

get_dungeon_grade_time(Id, ?DUNGEON_MASTER, DungeonList) ->
    case lists:keyfind(Id, #dungeon.base_id, DungeonList) of
        false ->
            {0, 0};
        #dungeon{best_grade = Grade,
                 best_pass = Pass} ->
            {Grade, Pass}
    end;
get_dungeon_grade_time(_, _, _) ->
    {0, 0}.

get_dungeon_info(#base_dungeon_area{
                    id = DungeonId,
                    dungeon_type = ?DUNGEON_MASTER} = Dungeon, Player) ->
    case data_base_dungeon_match:get(Player#player.lv) of
        [] ->
            get_dungeon_info2(Dungeon, 0, ?TEAM_FLAG_NONE);
        BaseDungeonMatch ->
            WinRate = lib_dungeon_match:get_player_win_rate(Player#player.id, BaseDungeonMatch#base_dungeon_match.id),
            TeamId = lib_dungeon_match:dungeon_team_id(),
            case catch lib_dungeon_match:lookup_dungeon(DungeonId, Player, BaseDungeonMatch, WinRate) of
                single_dungeon ->
                    get_dungeon_info2(Dungeon, TeamId, ?TEAM_FLAG_NONE);
                for_npc ->
                    get_dungeon_info2(Dungeon, TeamId, ?TEAM_FLAG_NPC);
                false ->
                    case get_dungeon_info2(Dungeon, TeamId, ?TEAM_FLAG_PLAYER) of
                        {fail, Reason} ->
                            {fail, Reason};
                        {ok, DungeonInfo, AllDrop} ->
                            NewDungeonInfo = DungeonInfo#dungeon_info{team_type = ?TEAM_TYPE_MASTER},
                            lib_dungeon_match:new(Player, NewDungeonInfo, AllDrop, WinRate, BaseDungeonMatch),
                            {ok, NewDungeonInfo, AllDrop}
                    end;
                {ok, NewMatch} ->
                    get_dungeon_info2(NewMatch);
                Other ->
                    ?WARNING_MSG("mod_dungeon_match:lookup error ~p~n", [Other]),
                    throw({lookup_dungeon_match_error})
            end
    end;
get_dungeon_info(#base_dungeon_area{dungeon_type = DungeonType} = Dungeon, Player) 
  when DungeonType =:= ?DUNGEON_SOURCE_GOLD orelse 
       DungeonType =:= ?DUNGEON_SOURCE_COIN orelse 
       DungeonType =:= ?DUNGEON_SOURCE_EXP -> 
    case get_dungeon_info2(Dungeon, 0, ?TEAM_FLAG_NONE) of
        {fail, Reason} ->
            {fail, Reason};
        {ok, #dungeon_info{pay_card_times = OldTimes} = DungeonInfo, AllDrop} ->
            ExtraTimes = extra_flip_card(Player#player.vip),
            {ok, DungeonInfo#dungeon_info{pay_card_times = OldTimes + ExtraTimes}, AllDrop}
    end;
        
get_dungeon_info(Dungeon, _Player) ->
    get_dungeon_info2(Dungeon, 0, ?TEAM_FLAG_NONE).

get_dungeon_info2(DungeonMatch)
  when is_record(DungeonMatch, dungeon_match) ->
    {ok, DungeonMatch#dungeon_match.dungeon_info, DungeonMatch#dungeon_match.all_drop}.

get_dungeon_info2(Dungeon, TeamId, TeamFlag) ->
    case generate_dungeon_item(Dungeon) of
        {fail, Reason} ->
            {fail, Reason};
        {ok, AllDropInfoList, AllDrop} ->
            TeamType = 
                if
                    Dungeon#base_dungeon_area.dungeon_type =:= ?DUNGEON_MASTER ->
                        ?TEAM_TYPE_MASTER;
                    true ->
                        0
                end,
            HitRewardDetail = Dungeon#base_dungeon_area.hit_reward_detail,
            DungeonInfo = #dungeon_info{
                             dungeon_id = Dungeon#base_dungeon_area.id,
                             team_id = TeamId,
                             monsters_rewards = AllDropInfoList,
                             free_card_times = Dungeon#base_dungeon_area.free_card_times,
                             pay_card_times  = Dungeon#base_dungeon_area.pay_card_times,
                             relive_times = Dungeon#base_dungeon_area.relive,
                             hit_reward = Dungeon#base_dungeon_area.hit_reward,
                             hit_reward_detail = Dungeon#base_dungeon_area.hit_reward_detail,
                             team_type = TeamType,
                             team_flag = TeamFlag},
            {ok, DungeonInfo, AllDrop}
    end.

generate_dungeon_item(#base_dungeon_area{
                         id = Id,
                         sub_dungeon_id = SubIds} = BaseDungeon) ->
    SubDungeonId = hmisc:rand(SubIds),
    case get_sub_dungeon_info(SubDungeonId) of  
        [] ->
            {fail, ?INFO_CONF_ERR};
        SubDungeonInfos ->
            BossRewardDegree = make_boss_reward_degree(BaseDungeon),
            ?DEBUG("BossRewardDegree ~p~n", [BossRewardDegree]),
            AllDrops = %%AllDrops = [{SubDungeonId, Ports, DungeonDropInfo, ObjectDrop}...]
                generate_rewards_new(Id, SubDungeonInfos, BossRewardDegree),  %%新的生成奖励
            AllDropInfoList = get_all_dungeon_drop(AllDrops),  %%[{subid, 传送门，怪物统计， 怪物掉落， 物件掉落}]
            {ok, AllDropInfoList, AllDrops}
    end.

generate_dungeon_item(#base_dungeon_area{
                         id = Id,
                         sub_dungeon_id = SubIds}, BossRewardDegree) ->
    SubDungeonId = hmisc:rand(SubIds),
    case get_sub_dungeon_info(SubDungeonId) of  
        [] ->
            {fail, ?INFO_CONF_ERR};
        SubDungeonInfos ->
            ?DEBUG("BossRewardDegree ~p~n", [BossRewardDegree]),
            AllDrops = %%AllDrops = [{SubDungeonId, Ports, DungeonDropInfo, ObjectDrop}...]
                generate_rewards_new(Id, SubDungeonInfos, BossRewardDegree),  %%新的生成奖励
            AllDropInfoList = get_all_dungeon_drop(AllDrops),  %%[{subid, 传送门，怪物统计， 怪物掉落， 物件掉落}]
            {ok, AllDropInfoList, AllDrops}
    end.

make_boss_reward_degree(BaseDungeon) ->
    %% 王者副本才开放多倍掉落
    case is_double_drop(BaseDungeon) of
        true ->
            2;
        false ->
            1
    end.

is_double_drop(#base_dungeon_area{dungeon_type = ?DUNGEON_MASTER} = BaseDungeon) ->
    case dungeon_level(BaseDungeon) of
        3 -> %% 王者副本才开放多倍掉落
            is_double_drop_time();
        _ ->
            false
    end;
is_double_drop(_) ->
    false.

is_double_drop_time() ->
    case app_misc:mochi_get(boss_double_drop_timestamp) of
        undefined ->
            false;
        TimeInfoList ->
            TimeStampList = 
                lists:map(fun({From, To}) ->
                                  {time_misc:datetime_to_timestamp(From), time_misc:datetime_to_timestamp(To)}
                          end, TimeInfoList),
            ?DEBUG("TimeStampList ~p~n", [TimeStampList]),
            Now = time_misc:unixtime(),
            if_in_double_drop_time(Now, TimeStampList)
    end.

if_in_double_drop_time(_, []) ->
    false;
if_in_double_drop_time(Now, [{From, To}|_Tail])
  when From =< Now andalso Now =< To ->
    true;
if_in_double_drop_time(Now, [_|Tail]) ->
    if_in_double_drop_time(Now, Tail).

%%检查是否在指定时间
check_req_time(_)->
    true.

check_req_lv(_ReqLv, _PlayerLv, ?DUNGEON_DAILY) ->
    true;
check_req_lv(_ReqLv, _PlayerLv, ?DUNGEON_CROSS_PVP_BOSS) ->
    true;
check_req_lv(ReqLv, PlayerLv, _) ->
    PlayerLv >= ReqLv.
    

%% 构建通过奖励，额外加成奖励，怪物掉落，第一次进入关卡奖励
generate_rewards_new(_DungeonId, SubDungeonInfoList, BossRewardDegree) ->  %%新的生成奖励
    %%怪物掉落
    AllDrops = 
        lists:foldl(fun({SubDungeonId, Ports, WaveCreates, CreatureCreateIds}, Info) ->
                            DungeonDropInfo = 
                                lists:map(fun(CreateId) ->
                                                  {CreateId, generate_monsters_list_new(CreateId, BossRewardDegree)}
                                          end, rand_wave_id(WaveCreates)),
                            %io:format("DungeonDropInfo ~p~n", [DungeonDropInfo]),
                            ObjectDropInfo = 
                                lists:map(fun(WaveId) ->
                                                  {WaveId, generate_creature_list(WaveId)}
                                          end, rand_wave_id(CreatureCreateIds)),

                            %?PRINT("ObjectDropInfo ~p~n", [ObjectDropInfo]),
                            [{SubDungeonId, Ports, DungeonDropInfo, ObjectDropInfo}|Info]
                    end, [], unique(SubDungeonInfoList, [])),
    %?PRINT("AllDrops ~p~n", [AllDrops]),
    AllDrops.

rand_wave_id(WaveCreates) ->
    lists:map(fun(RandList) ->
                      hmisc:rand(RandList)
              end, WaveCreates).

%%SubDungeonInfoList要处理，去掉重复的
unique([], List) ->
    List;
unique([{SubDungeonId, _, _, _} = H|T], List) ->
    case lists:keymember(SubDungeonId, 1, List) of
        false ->
            unique(T, [H|List]);
        true ->
            unique(T, List)
    end.

generate_creature_list(0) ->
    [];
generate_creature_list(WaveId) ->
    case data_base_dungeon_create_object:get(WaveId) of
        [] ->
            [];
        #base_dungeon_create_object{create_count = Count,    
                                    create_range = Range} ->
            CreateIdList = hmisc:rand_n(Count, range_confirm(Range)),
            get_object_drop(CreateIdList)
    end.

get_object_drop(CreateIdList) ->
    [get_object_drop2(ObjectCreateId) || ObjectCreateId <- CreateIdList].

get_object_drop2(ObjectCreateId) ->
    case data_base_dungeon_create_object:get(ObjectCreateId) of
        [] ->
            {ObjectCreateId, 0, []};
        #base_dungeon_create_object{create_probability = CreatureRand} ->
            AttrId = hmisc:rand(CreatureRand, ?RANDOM_BASE),
            case data_base_dungeon_object_attribute:get(AttrId) of
                [] ->
                    {ObjectCreateId, AttrId, []};
                #base_dungeon_object_attribute{object_drop = Drop} ->
                    {ObjectCreateId, AttrId, lib_reward:generate_reward_list(Drop)}
            end
    end.

generate_monsters_list_new(CreateId, BossRewardDegree) ->
    case data_base_dungeon_create_monster:get(CreateId) of
        [] ->
            [];
        #base_dungeon_create_monster{create_count = Count,
                                     create_range = Range} ->
            %?DEBUG("CreateId ~p Range ~p~n", [CreateId, Range]),
            CreateIdList = hmisc:rand_n(Count, range_confirm(Range)), %%在表中随机取Count个
            %% ?ERROR_MSG("CreateIdList ~p~n", [CreateIdList]),
            get_monster_drop(CreateIdList, BossRewardDegree)
    end.

get_monster_drop(CreateIdList, BossRewardDegree) ->
    [get_monster_drop2(Id, BossRewardDegree) || Id <- CreateIdList].

get_monster_drop2(CreateId, BossRewardDegree) ->
    #base_dungeon_create_monster{create_probability = MonstersRand} = 
        data_base_dungeon_create_monster:get(CreateId),
    case hmisc:rand(MonstersRand, ?RANDOM_BASE) of   %%默认总概论是10000
        [] ->
            ?ERROR_MSG("base_dungeon_create_monster error CreateId ~p~n", [CreateId]),
            [];
        MonstersId ->
            case data_base_dungeon_monsters_attribute:get(MonstersId) of
                [] ->
                    [];
                #base_dungeon_monsters_attribute{mon_drop = Drop,
                                                 type = MonsType,
                                                 mon_drop2 = Drop2} ->
                    NewDrop = make_mon_drop(Drop, Drop2, MonsType, BossRewardDegree),
                    %?WARNING_MSG("MonstersId ~p~n NewDrop ~p~n", [MonstersId, NewDrop]),
                    {CreateId, MonstersId, NewDrop}  %%返回怪物和奖励
            end
    end.

make_mon_drop(Drop, Drop2, ?DOUBLE_DROP_MONS_TYPE, BossRewardDegree)
  when BossRewardDegree > 1 ->
    ?DEBUG("Drop : ~p~n",[Drop]),
    NewDrop = lib_reward:generate_reward_list(Drop), %%boss掉落
    ?DEBUG("NewDrop : ~p~n",[NewDrop]),
    NewDrop2 = case is_double_drop_time() of
                   true ->
                       lib_reward:generate_reward_list(Drop2); %%连击宝箱
                   _ ->
                       []
               end,        
    AddQCoinDrop2 = lists:foldl(fun(#common_reward{goods_id = GoodsId, goods_sum = Num} = Reward, RET) ->
                                        case GoodsId of
                                            ?GOODS_TYPE_Q_COIN ->
                                                case mod_q_coin_srv:get_q_coin(1, Num) of
                                                    Num  ->
                                                        [Reward|RET];
                                                    _ ->
                                                        RET
                                                end;
                                            _ ->
                                                [Reward|RET]
                                        end
                                end, [], NewDrop2),
    ?DEBUG("Drop2 ~p NewDrop2 ~p AddQCoinDrop2:~p ~n", [Drop2, NewDrop2, AddQCoinDrop2]),
    BossDrop = 
        lists:map(fun(#common_reward{goods_sum = Sum} = Reward) ->
                          Reward#common_reward{goods_sum = trunc(Sum * BossRewardDegree)}
                  end, NewDrop),
    BossDrop ++ AddQCoinDrop2;
make_mon_drop(Drop, _, _, _) -> %%只有boss享受双倍和drop2的掉落
    lib_reward:generate_reward_list(Drop).

%%获取副本的难度(参数DungeonId是配置表中的dungeon_id，不是base_id)
dungeon_level(#base_dungeon_area{id = BaseId,
                                 dungeon_id = DungeonId}) ->
    BaseId - DungeonId * 10.    %%默认系列id * 10 + 难度 = base_id

%% 检测是否能够进入该关卡
check_entry_dungeon(ModPlayerState, #base_dungeon_area{dungeon_type = DungeonType,
                                                       id = DungeonId,
                                                       task_id = TaskId
                                                      } = Dungeon) ->
    case DungeonType of
        ?DUNGEON_MASTER ->
            DungeonList = ModPlayerState#mod_player_state.dungeon_list,
            case dungeon_level(Dungeon) of
                1 ->     %%普通难度要通关一些任务
                    TaskList = ModPlayerState#mod_player_state.task_list,
                    check_dungeon_task(TaskList, TaskId);
                DungeonLevel ->
                    NeedLast = DungeonId - 1,
                    case lists:keyfind(NeedLast, #dungeon.base_id, DungeonList) of
                        #dungeon{done = Done} when Done > 0 ->
                            check_king_dungeon_times(DungeonLevel, DungeonList, DungeonId);
                        false ->
                            {fail, ?INFO_DUNGEON_NEED_PREV}
                    end
            end;
        ?DUNGEON_MEGUN ->
            case ModPlayerState#mod_player_state.dungeon_mugen of
                #dungeon_mugen{
                   last_dungeon = DungeonId} when DungeonId > 0 ->
                    true;
                _ ->
                    {fail, ?INFO_DUNGEON_ONT_ENABLE}
            end;
        ?DUNGEON_ACTIVITY ->
            true;
        ?DUNGEON_SUPER_BATTLE ->
            case ModPlayerState#mod_player_state.super_battle of
                %% #super_battle{state = ?PLAYER_DEAD} ->
                %%     {fail, ?INFO_DUNGEON_SUPER_BATTLE_DEAD};
                #super_battle{
                   last_dungeon = DungeonId,
                   rest = Rest} when Rest >= 0 ->
                    true;
                %% #super_battle{rest = Rest} when Rest =< 0 ->
                %%     {fail, ?INFO_SUPER_BATTLE_OUT_OF_TIMES};
                _ ->
                    {fail, ?INFO_CONF_ERR}
            end;
        ?DUNGEON_DAILY ->
            case ModPlayerState#mod_player_state.daily_dungeon of
                #daily_dungeon{dungeon_id = TarId,
                               left_times = Left} ->
                    if
                        TarId =:= 0 ->
                            {fail, ?INFO_DUNGEON_NO_DAILY};
                        Left =< 0 ->
                            {fail, ?INFO_DUNGEON_DAILY_OUT_OF_TIMES};
                        true ->
                            true
                    end;
                _ ->
                    {fail, ?INFO_CONF_ERR}
            end;
        ?DUNGEON_CROSS_PVP_BOSS ->
            true;
        DungeonType when DungeonType =:= ?DUNGEON_SOURCE_GOLD orelse 
                         DungeonType =:= ?DUNGEON_SOURCE_COIN orelse 
                         DungeonType =:= ?DUNGEON_SOURCE_EXP ->
            case ModPlayerState#mod_player_state.source_dungeon of
                #source_dungeon{info = InfoList} = SourceDungeon ->
                    case check_source_dungeon(InfoList, DungeonId) of
                        {fail, Reason} ->
                            {fail, Reason};
                        {true, NewInfoList} ->
                            {true, ModPlayerState#mod_player_state{
                                     source_dungeon = SourceDungeon#source_dungeon{info = NewInfoList}}}
                    end;
                What ->
                    ?WARNING_MSG("error ~p~n", [What]),
                    {fail, ?INFO_CONF_ERR}
            end;
        _ -> 
            ?WARNING_MSG("DungeonType error ~p~n", [DungeonType]),
            {fail, ?INFO_DUNGEON_ONT_ENABLE}
    end.

%% 检查副本要完成的任务
check_dungeon_task(_TaskList, 0) ->
    true;
check_dungeon_task(TaskList, TaskId) ->
    case data_base_task:get(TaskId) of
        [] ->
            {fail, ?INFO_CONF_ERR};
        #base_task{subtype = SubType} ->
            case lists:keyfind(SubType, #task.subtype, TaskList) of
                false ->
                    {fail, ?INFO_DUNGEON_NEED_PREV_TASK};
                #task{task_id = NowTask} when NowTask >= TaskId ->
                    true;
                _ ->
                    {fail, ?INFO_DUNGEON_NEED_PREV_TASK}
            end
    end.

%%没有记录的话默认是可以打的，有问题的话也是策划问题 DEFAULT_KING_DUNGEON_TIMES，3
check_king_dungeon_times(?KING_DUNGEON_TYPE, DungeonList, BaseId) ->
    case lists:keytake(BaseId, #dungeon.base_id, DungeonList) of
        false ->
            true;
        {value, #dungeon{left_times = Left}, _} when Left > 0 ->
            true;
        _ ->
            {fail, ?INFO_SUPER_BATTLE_OUT_OF_TIMES}
    end;
check_king_dungeon_times(_, _, _) ->
    true.


check_source_dungeon(InfoList, DungeonId) ->
    case proplists:get_value(DungeonId, InfoList) of
        undefined ->
            {true, [{DungeonId, souce_dungeon_times()}|InfoList]};
        LeftTimes when LeftTimes > 0 ->
            {true, InfoList};
        _ ->
           {fail, ?INFO_DUNGEON_SOURCE_OUT_OF_TIMES}
    end.

souce_dungeon_times() ->
    ?SOURCE_DUNGEON_TIMES.

get_next_dungeon() ->
    lib_counter:update_counter(dungeon_uid).

%%获取create表的ids，这个决定有几波怪
get_sub_dungeon_info(SubDungeonId) ->
    case data_base_dungeon_detail:get(SubDungeonId) of
        [] ->
            [];
        _ ->
            get_sub_monsters(SubDungeonId)  
    end. 
%%或取所有子关卡的信息，传第一个子关卡id进来
get_sub_monsters(SubDungeonIds)
  when is_list(SubDungeonIds) ->
    lists:foldl(fun(SubDungeonId, SubInfo) ->
                        NewInfo = get_sub_monsters(SubDungeonId),
                        NewInfo ++ SubInfo
                end, [], SubDungeonIds);
get_sub_monsters(SubDungeonId) ->
    case data_base_dungeon_detail:get(SubDungeonId) of
        [] ->
            %?ERROR_MSG("base_dungeon_detail error Id ~p~n", [SubDungeonId]),
            [];
         #base_dungeon_detail{portal_create_id = PortCreateIds,
                              monster_create_id = MonsterIds,
                              object_create_id = ObjectIds} ->
            case PortCreateIds of
                [] ->
                    ?DEBUG("SubDungeonId ~p~n PortalIds ~p~n MonsterIds ~p~n", [SubDungeonId, [], MonsterIds]),
                    [{SubDungeonId, [], MonsterIds, ObjectIds}];
                [PortCreateId] ->
                    {PortalIds, NextSubIds} = get_sub_id_from_port(PortCreateId),    %%[{portid, nextsub}....
                    %io:format("PortalIds ~p, NextSubIds ~p~n", [PortalIds, NextSubIds]),
                    ?DEBUG("SubDungeonId ~p~n PortalIds ~p~n MonsterIds ~p~n", [SubDungeonId, PortalIds, MonsterIds]),
                    [{SubDungeonId, PortalIds, MonsterIds, ObjectIds}|get_sub_monsters(NextSubIds)]
            end
    end.


get_sub_id_from_port(PortId) ->
    case data_base_dungeon_create_portal:get(PortId) of
        [] ->
            %?ERROR_MSG("base_create_portal error PortId ~p~n", [PortId]),
            {[], 0};
        #base_dungeon_create_portal{create_count = Count,
                                    create_range = Range} -> 
            PortalIds = hmisc:rand_n(Count, range_confirm(Range)),
            %io:format("PortalIds ~p~n", [PortalIds]),
            {PortalIdList, NextSubIdList} = 
                lists:foldl(fun(PortalId, {AccPortIds, AccNextSubs}) ->
                                    case data_base_dungeon_create_portal:get(PortalId) of
                                        [] ->
                                            {AccPortIds, AccNextSubs};
                                        #base_dungeon_create_portal{next_id = NextId} ->
                                            {[PortalId|AccPortIds], [NextId|AccNextSubs]}
                                    end
                            end, {[], []}, PortalIds),
            {lists:sort(PortalIdList), NextSubIdList}  %%传送门排序
    end.

get_reward_new(#mod_player_state{dungeon_info = DungeonInfo, 
                                 player = Player} = ModPlayerState, #pass_dungeon_info{
                                                                       id = Id,
                                                                       route = Route,
                                                                       score = Score,
                                                                       reward = ClientReward,
                                                                       state = PassState,
                                                                       is_extra = IsExtra,
                                                                       cost_time = Pass,
                                                                       condition = Condition,
                                                                       boss_flag = BossFlag,
                                                                       target_list = TargetList,
                                                                       cur_hp = CurHp,
                                                                       hit_reward = HitReward}) ->
    ?DEBUG("Client send Reward ~p Client HitReward~p~n", [ClientReward, HitReward]),
    ?DEBUG("Condition ~p~n", [Condition]),
    case data_base_dungeon_area:get(Id) of
        [] ->
            {fail, ?INFO_DUNGEON_DUNGEON_NOT_EXIST};
        #base_dungeon_area{dungeon_type = Type,
                           area_id = AreaId,
                           req_vigor = ReqVigor} = BaseDungeon ->
            if
                DungeonInfo =:= [] ->
                    {fail, ?INFO_SERVER_DATA_ERROR};
                DungeonInfo#dungeon_info.flag =:= ?FLAG_TAKE_REWARD ->
                    {fail, ?INFO_DUNGEON_TAKEN_REWARD};
                DungeonInfo#dungeon_info.dungeon_id =/= Id ->
                    {fail, ?INFO_CONF_ERR};
                PassState =:= ?PLAYER_ALIVE ->
                    case lib_player:cost_money(Player, ReqVigor, ?GOODS_TYPE_VIGOR, ?COST_ENTRY_DUNGEON) of
                        {fail, Reason} ->
                            {fail, Reason};
                        {ok, NewPlayer} ->
                            ModPlayerStateCostVigor = ModPlayerState#mod_player_state{player = NewPlayer},
                            PvpRewards = case DungeonInfo of
                                             #dungeon_info{team_flag = TeamFlag} when TeamFlag =:= ?TEAM_FLAG_NPC orelse
                                                                                      TeamFlag =:= ?TEAM_FLAG_PLAYER->
                                                 case BossFlag of
                                                     ?BOSS_FLAG_WIN ->                                                        
                                                         lib_reward:get_pvp_rewards(dungeon_pvp, win);
                                                     _ ->
                                                         lib_reward:get_pvp_rewards(dungeon_pvp, loss)
                                                 end;
                                             _ ->
                                                 [{?GOODS_TYPE_COIN,1}]
                                         end,
                            
                            case get_dungeon_reward2(ModPlayerStateCostVigor, BaseDungeon, Route, 
                                                     {IsExtra, ClientReward, HitReward, PvpRewards}, Condition, TargetList) of
                                {ok, NewModPlayerState, MonsterList} ->
                                   
                                    %%可能处理排行榜事件
                                    case may_handle_db_data(NewModPlayerState, {Id, Type, Score, Pass, BossFlag, CurHp, IsExtra}) of
                                        {fail, Reason} ->
                                            {fail, Reason};
                                        NModPlayerState ->
                                            DungeonLevel = dungeon_level(BaseDungeon),
                                            handle_monster_task_event(ModPlayerState?PLAYER_PID, AreaId, DungeonLevel),  %%区域类型
                                            handle_monster_task_event(ModPlayerState?PLAYER_PID, MonsterList),  %%处理怪物任务
                                            handle_dungeon_task_event(ModPlayerState?PLAYER_PID, Id, Pass, Score),
                                            handle_teamdungeon_task_event(ModPlayerState?PLAYER_PID, DungeonInfo#dungeon_info.team_type), %处理组队任务

                                            LogType = get_log_dungeon_type(Type, DungeonLevel),
                                            %% 记录统统计日志
                                            lib_log_player:log_system({Player#player.id,
                                                                       LogType,
                                                                       DungeonInfo#dungeon_info.dungeon_id,
                                                                       DungeonInfo#dungeon_info.team_flag,
                                                                       BossFlag
                                                                      }),
                                            {ok, NModPlayerState#mod_player_state{
                                                   dungeon_info = DungeonInfo#dungeon_info{monsters_rewards = [],
                                                                                           team_type = 0,
                                                                                           team_id = 0,
                                                                                           flag = ?FLAG_TAKE_REWARD}}}
                                    end;
                                {fail, Reason} ->
                                    {fail, Reason}
                            end
                    end;
                true  ->
                    ?DEBUG("player dead ~n", []),
                    %%以死亡形式退出副本
                    case deaded_out_dungeon(BaseDungeon, ModPlayerState, Type) of
                        {fail, Reason} ->
                            {fail, Reason};
                        {ok, NewModPlayerState} ->
                            case handle_schedule(NewModPlayerState, BaseDungeon, TargetList, false) of
                                {fail, Reason} ->
                                    {fail, Reason};
                                {ok, NModPlayerState, _, NewDungeon} ->
                                    send_schedule(NewDungeon),
                                    {ok, NModPlayerState}
                            end
                    end
            end
    end.

%%爬塔的奖励
get_dungeon_reward2(#mod_player_state{dungeon_mugen = Mugen,
                                      mugen_reward = MugenRewardList} = ModPlayerState, 
                    #base_dungeon_area{dungeon_type = ?DUNGEON_MEGUN}, _, {_IsExtra, _ClientReward, _, _}, Condition, _) ->
    TowerLevel = Mugen#dungeon_mugen.have_pass_times + 1,
    case data_base_mugen_tower:get(TowerLevel) of
        #base_mugen_tower{} = MugenTower ->
            {NewMugenRewardList, LuckyReward, NormalReward, ConditionReward, NewMugen} = 
                get_mugen_condition_reward(Mugen, MugenTower, Condition, MugenRewardList),
            AllGetReward = NormalReward ++ ConditionReward,
            case lib_reward:take_reward(ModPlayerState, LuckyReward, ?INCOME_MUGEN_DUNGEON_REWARD, ?REWARD_TYPE_RECV_LUCKY_COIN) of
                {ok, NModPlayerState} ->                
                    case lib_reward:take_reward(NModPlayerState, AllGetReward, ?INCOME_MUGEN_DUNGEON_REWARD) of
                        {ok, NewModPlayerState} ->
                            {ok, NewModPlayerState#mod_player_state{mugen_reward = NewMugenRewardList,
                                                                    dungeon_mugen = NewMugen}, []};  %%爬塔打的怪不打算拿去做任务
                        {fail, Reason} ->
                            {fail, Reason}
                    end;
                {fail, Reason} ->
                    {fail, Reason}
            end;
        _ ->
            {fail, ?INFO_CONF_ERR}
    end;
%%其他副本的奖励
get_dungeon_reward2(#mod_player_state{dungeon_info = DungeonInfo} = ModPlayerState, 
                    #base_dungeon_area{dungeon_type = Type,
                                       first_reward = FirstReward,
                                       score_reward = Goal,
                                       hit_reward = OHitReward,
                                       reward = PassDungeonReward} = BaseDungeon, Route, {IsExtra, ClientReward, HitReward,PvpRewards}, _, TargetList) ->
    MonstersRewards = DungeonInfo#dungeon_info.monsters_rewards,
    Grade = DungeonInfo#dungeon_info.grade,
    Vip = ModPlayerState?PLAYER_VIP,
    VipHitReward = DungeonInfo#dungeon_info.hit_reward,   %这个是最大的连击宝箱数，算上vip加成的 HitReward是客户端实际拿的
    case check_dungeon_route(MonstersRewards, Route) of
        false ->
            ?WARNING_MSG("error dungeon route ~p~n", [Route]),
            {fail, ?INFO_DUNGEON_ROUTE_ERROR};
        {MonsterList, RewardAfterCheck} ->
            NewClientRewards = case DungeonInfo#dungeon_info.dungeon_id of
                                   SpecialId when PvpRewards =/= [] 
                                                  %% andalso (SpecialId =:= 1102101 orelse  
                                                  %%          SpecialId =:= 1102102 orelse
                                                  %%          SpecialId =:= 1102103)
                                                  ->
                                       %% 2015 07 10 临时对机器人处理
                                       RewardAfterCheck;
                                   _ ->
                                       []
                               end,
            case check_client_reward(NewClientRewards, RewardAfterCheck) andalso check_hit_reward(VipHitReward, HitReward) of
                true ->
                    FirstPassReward = lib_reward:generate_reward_list(FirstReward),
                    case may_update_schedule(ModPlayerState, BaseDungeon, Type, TargetList, FirstPassReward) of
                        {fail, Reason} ->
                            {fail, Reason};
                        {ok, ModPlayerStateAfterSchedule} ->
                            NormalReward  = lib_reward:generate_reward_list(PassDungeonReward),       %%普通奖励
                            ExtraHitReward = extra_reward(Type, Vip, IsExtra, Goal, Grade, OHitReward),  %%额外奖励变成评级宝箱
                            ?DEBUG("HitReward ~p Score ExtraHitReward ~p NewClientRewards ~p~n",
                                   [HitReward, ExtraHitReward, ClientReward]),
                            case take_normal_reward(ModPlayerStateAfterSchedule, NewClientRewards ++ NormalReward ++ ExtraHitReward ++ HitReward ++ PvpRewards, Type) of
                                {ok, NewModPlayerState} ->
                                    {ok, NewModPlayerState, MonsterList};
                                Other ->
                                    Other
                            end
                    end;
                false ->
                    ?WARNING_MSG("reward not legal, MonstersRewards ~p, ClientReward ~p~n", [MonstersRewards, ClientReward]),
                    {fail, ?INFO_DUNGEON_REWARD_ERROR}
            end
    end.

check_hit_reward(_, []) ->
    true;
check_hit_reward([GoodsId, ONum], [{GoodsId, RecvNum}]) when ONum >= RecvNum ->
    true;
check_hit_reward(OHitReward, HitReward) ->
    ?DEBUG("OHitReward ~p, HitReward ~p~n", [OHitReward, HitReward]),
    false.

take_normal_reward(ModPlayerState, Reward, ?DUNGEON_SUPER_BATTLE) ->
    ?DEBUG("Reward ~p~n", [Reward]),
    lib_reward:take_reward(ModPlayerState, Reward, ?INCOME_DUNGEON_REWARD, ?REWARD_TYPE_SUPER_BATTLE);
take_normal_reward(ModPlayerState, Reward, _) ->
    ?DEBUG("Reward ~p~n", [Reward]),
    lib_reward:take_reward(ModPlayerState, Reward, ?INCOME_DUNGEON_REWARD).

leave_dungeon_match(PlayerId, #dungeon_info{team_id = TeamId}, Flag) 
  when TeamId =/= 0 ->
    if
        Flag =:= pass_dungeon ->
            mod_dungeon_match:leave_pass_dungeon(TeamId);
        true ->
            mod_dungeon_match:leave(PlayerId, TeamId)
    end;
leave_dungeon_match(_, _, _) ->
    skip.


get_mugen_condition_reward(#dungeon_mugen{player_id = PlayerId} = Mugen, 
                           #base_mugen_tower{id = Level,
                                             normal_reward = NormalReward,
                                             lucky_reward = LuckyReward,
                                             reward1 = Reward1,
                                             reward2 = Reward2,
                                             reward3 = Reward3,
                                             reward4 = Reward4}, Condition, MugenRewardList) ->
    GetLuckyReward = get_lucky_reward(Mugen, LuckyReward),
    {MugenReward, RestList} = 
        case lists:keytake(Level, #mugen_reward.level, MugenRewardList) of
            false ->
                {#mugen_reward{id = get_next_mugen_reward(),
                               player_id = PlayerId,
                               level = Level}, MugenRewardList};
            {value, Value, Rest} ->
                {Value, Rest}
        end,
    {NewMugenReward, GetReward} = get_mugen_condition_reward2(MugenReward, Condition, [Reward1, Reward2, Reward3, Reward4]),
    NewMugen = 
        if
            GetLuckyReward =:= [] ->
                Mugen;
            true ->
                Mugen#dungeon_mugen{use_lucky_coin = Mugen#dungeon_mugen.use_lucky_coin + 1}
        end,
    {[dirty_mugen_reward(NewMugenReward)|RestList], GetLuckyReward, NormalReward, GetReward, NewMugen}.

get_mugen_condition_reward2(#mugen_reward{reward1 = Flag1,
                                          reward2 = Flag2,
                                          reward3 = Flag3,
                                          reward4 = Flag4} = MugenReward, 
                            [C1, C2, C3, C4], [Reward1, Reward2, Reward3, Reward4]) ->
    {NewFlag1, NewReward1} = mugen_condition(Flag1, C1, Reward1),
    {NewFlag2, NewReward2} = mugen_condition(Flag2, C2, Reward2),
    {NewFlag3, NewReward3} = mugen_condition(Flag3, C3, Reward3),
    {NewFlag4, NewReward4} = mugen_condition(Flag4, C4, Reward4),
    {MugenReward#mugen_reward{reward1 = NewFlag1,
                              reward2 = NewFlag2,
                              reward3 = NewFlag3,
                              reward4 = NewFlag4}, NewReward1 ++ NewReward2 ++ NewReward3 ++ NewReward4}.
    
mugen_condition(1, _, _) ->
    {1, []};
mugen_condition(0, 0, _) ->
    {0, []};
mugen_condition(0, 1, Reward) ->
    {1, Reward}.

get_lucky_reward(#dungeon_mugen{
                    player_id = PlayerId,
                    use_lucky_coin = UseTimes}, LuckyReward) ->
    case hdb:dirty_index_read(lucky_coin, PlayerId, #lucky_coin.recv, true) of
        [] ->
            [];
        List ->
            RestList = 
                lists:filter(fun(#lucky_coin{state = ?LUCKY_COIN_RECV}) ->
                                     false;
                                (_) ->
                                     true
                             end, List),
            handle_recv_coin(RestList),
            if
                UseTimes >= ?MAX_LUCKY_COINS ->
                    [];
                RestList =:= [] ->
                    [];
                true ->
                    lists:map(fun({Id, Sum}) ->
                                      {Id, Sum div 5}
                              end, LuckyReward)              
            end
    end.

handle_recv_coin([]) ->
    skip;
handle_recv_coin([LuckyCoin|_]) ->
    write_lucky_coin(LuckyCoin#lucky_coin{state = ?LUCKY_COIN_RECV}).

deaded_out_dungeon(_, ModPlayerState, ?DUNGEON_MEGUN) ->
    {ok, ModPlayerState};
deaded_out_dungeon(#base_dungeon_area{id = _Id}, 
                   #mod_player_state{dungeon_info = DungeonInfo} = ModPlayerState, ?DUNGEON_SUPER_BATTLE) ->
    %%公平竞技改成死亡之后什么都不做
    {ok, ModPlayerState#mod_player_state{dungeon_info = DungeonInfo#dungeon_info{flag = ?FLAG_TAKE_REWARD}}};
deaded_out_dungeon(_, #mod_player_state{player = Player,
                                        dungeon_info = DungeonInfo} = ModPlayerState, ?DUNGEON_MASTER) ->
    leave_dungeon_match(Player#player.id, DungeonInfo, dead_out),
    {ok, ModPlayerState#mod_player_state{dungeon_info = #dungeon_info{}}};
deaded_out_dungeon(_, ModPlayerState, ?DUNGEON_DAILY) ->
    {ok, ModPlayerState};
deaded_out_dungeon(_, _, TYPE) ->
    ?WARNING_MSG("deaded_out_dungeon error type ~p~n", [TYPE]),
    {fail, ?INFO_CONF_ERR}.
        
%%不同种类的副本维护不同的数据库信息
may_handle_db_data(#mod_player_state{dungeon_mugen = #dungeon_mugen{
                                                        have_pass_times = PassTimes,
                                                        score = OldScore,
                                                        max_pass_rec = MaxRec} = DungeonMugen,
                                     player = Player} = ModPlayerState, {_DungeonId, ?DUNGEON_MEGUN, Score, _Pass, _, _, _IsExtra}) ->
    HavePass = PassTimes + 1,
    NextDungeonId = 
        case data_base_mugen_tower:get(HavePass + 1) of
            [] ->
                0;
            #base_mugen_tower{area_id = AreaId} ->
                AreaId
        end,
    NewDungeonMugen = DungeonMugen#dungeon_mugen{
                        last_dungeon = NextDungeonId,
                        score = min(OldScore + Score, ?MAX_INT_32),
                        have_pass_times = HavePass,
                        max_pass_rec = max(MaxRec, HavePass),
                        skip_flag = ?SKIP_MUGEN_ON},
    insert_rank(Player#player.sn, mugen_rank, NewDungeonMugen, Player),
    NewModPlayerState = ModPlayerState#mod_player_state{dungeon_mugen = 
                                                            dirty_mugen(NewDungeonMugen)},
    case do_handle_mugen_challenge(NewModPlayerState) of
        {fail, Reason} ->
            {fail, Reason};
        {ok, NModPlayerState} ->
            %%不触发任务事件了，等客户端检测
            %%handle_mugen_task(NModPlayerState?PLAYER_PID, NModPlayerState#mod_player_state.dungeon_mugen),
            NModPlayerState
    end;
may_handle_db_data(#mod_player_state{super_battle = SuperBattle} = ModPlayerState, 
                   {DungeonId, ?DUNGEON_SUPER_BATTLE, Score, _Pass, _, CurHp, _IsExtra}) ->
    if
        is_integer(CurHp) andalso CurHp > 0 andalso CurHp =< 100 ->
            Next = get_super_battle_next(DungeonId),
            NewPass = SuperBattle#super_battle.have_pass_times + 1,
            NewSuperBattle = SuperBattle#super_battle{
                               last_dungeon = Next,
                               next_dungeon = get_super_battle_next(Next),
                               score = SuperBattle#super_battle.score + Score,
                               cur_hp = CurHp,
                               have_pass_times = NewPass},
            NewModPlayerState = lib_task:task_event(ModPlayerState, {?TASK_SUPER_BATTLE, NewPass}),
            %insert_rank(Player#player.sn, super_battle_rank, NewSuperBattle, Player),
            NewModPlayerState#mod_player_state{super_battle = dirty_super_battle(NewSuperBattle)};
        true ->
            {fail, ?INFO_NOT_LEGAL_INT}
    end;
may_handle_db_data(#mod_player_state{daily_dungeon = #daily_dungeon{left_times = Rest} = DailyDungeon} = ModPlayerState,
                   {_, ?DUNGEON_DAILY, _, _, _, _, _IsExtra}) ->
    NewDailyDungeon =
        case Rest - 1 > 0 of
            true ->
                DailyDungeonReset = reset_daily_dungeon(ModPlayerState#mod_player_state.player),
                DailyDungeonReset#daily_dungeon{left_times = Rest - 1};
            _ ->
                DailyDungeon
        end,
    ModPlayerState#mod_player_state{daily_dungeon = hdb:dirty(NewDailyDungeon#daily_dungeon{left_times = Rest - 1}, #daily_dungeon.dirty)};

may_handle_db_data(#mod_player_state{source_dungeon = SourceDungeon} = ModPlayerState, {DungeonId, DungeonType, _, _, _, _, _IsExtra}) 
  when DungeonType =:= ?DUNGEON_SOURCE_GOLD orelse
       DungeonType =:= ?DUNGEON_SOURCE_COIN orelse
       DungeonType =:= ?DUNGEON_SOURCE_EXP ->
    case lists:keytake(DungeonId, 1, SourceDungeon#source_dungeon.info) of 
        false ->
            ?WARNING_MSG("source_dungeon_not_found_id id~p SourceDungeon ~p~n", [DungeonId, SourceDungeon]),
            throw({source_dungeon_not_found_id, DungeonId, SourceDungeon});
        {value, {_, RestTimes}, RestInfo} ->
            NewSourceDungeon = SourceDungeon#source_dungeon{info = [{DungeonId, RestTimes - 1}|RestInfo]},
            {ok, Bin} = pt_12:write(12060, NewSourceDungeon),
            packet_misc:put_packet(Bin),
            ModPlayerState#mod_player_state{source_dungeon = dirty_source_dungeon(NewSourceDungeon)}
    end;

may_handle_db_data(#mod_player_state{dungeon_list = DungeonList,
                                     dungeon_info = DungeonInfo} = ModPlayerState, 
                   {Id, ?DUNGEON_MASTER, Score, Pass, BossFlag, _, IsExtra}) -> 
    NewDungeon = 
        case lists:keyfind(Id, #dungeon.base_id, DungeonList) of
            false ->
                Dungeon = 
                    #dungeon{id = get_next_dungeon(),
                             player_id = ModPlayerState?PLAYER_ID,
                             base_id = Id,
                             best_score = Score,
                             best_pass = Pass,
                             best_grade = best_grade(IsExtra, 0),
                             done = 1
                            },
                hdb:dirty(Dungeon, #dungeon.dirty);
            #dungeon{best_score = BScore,
                     best_pass = BPass,
                     done = Done,
                     dungeon_level = DungeonLevel,
                     boss_win_times = _Win,
                     left_times = Lefts,
                     best_grade = Grade,
                     boss_fail_times = _Fail} = OldDungeon ->
                BestGrade = best_grade(IsExtra, Grade),
                NewPassTime = best_pass(Pass, BPass),
                NewLefts = 
                    if
                        DungeonLevel =:= ?KING_DUNGEON_TYPE ->
                            Lefts - 1;
                        true ->
                            Lefts
                    end,
                NOldDungeon = 
                    OldDungeon#dungeon{best_score = max(BScore, Score),
                                       best_pass = NewPassTime,
                                       best_grade = BestGrade,
                                       left_times = NewLefts,
                                       done = Done + 1},
                NDungeon = NOldDungeon,
                %% NDungeon = 
                %%     if
                %%         BossFlag =:= ?BOSS_FLAG_WIN ->
                %%             NOldDungeon#dungeon{boss_win_times = Win + 1};
                %%         BossFlag =:= ?BOSS_FLAG_FAIL -> 
                %%             NOldDungeon#dungeon{boss_fail_times = Fail + 1};
                %%         true ->
                %%             NOldDungeon    
                %%     end,
                hdb:dirty(NDungeon, #dungeon.dirty)
        end,
    lib_dungeon_match:update_dungeon_match(ModPlayerState?PLAYER, BossFlag),
    if
        DungeonInfo#dungeon_info.team_type =:= ?TEAM_TYPE_MASTER ->
            leave_dungeon_match(ModPlayerState?PLAYER_ID, DungeonInfo, pass_dungeon);
        true ->
            skip
    end,
    send_schedule(NewDungeon),
    ModPlayerState#mod_player_state{dungeon_list = lists:keystore(Id, #dungeon.base_id, DungeonList, NewDungeon)};
may_handle_db_data(ModPlayerState, Other) ->
    ?WARNING_MSG("may_handle_db_data error ~p~n", [Other]),
    ModPlayerState.

best_grade(undefined, undefined) ->
    0;
best_grade(undefined, Grade) ->
    Grade;
best_grade(IsExtra, undefined) ->
    IsExtra;
best_grade(IsExtra, Grade) 
  when is_integer(IsExtra) andalso is_integer(Grade) ->
    max(IsExtra, Grade);
best_grade(_, _) ->
    0.

best_pass(undefined, undefined) ->
    0;
best_pass(undefined, BPass) ->
    BPass;
best_pass(Pass, 0) ->
    Pass;
best_pass(Pass, BPass) ->
    min(Pass, BPass).
    
       

%%主线本去领取首次通关奖励和目标奖励
may_update_schedule(ModPlayerState, BaseDungeon, ?DUNGEON_MASTER, TargetList, FirstPassReward) ->
    case handle_schedule(ModPlayerState, BaseDungeon, TargetList, true) of
        {fail, Reason} ->
            {fail, Reason};
        {ok, NewModPlayerState, true, _} ->
            lib_reward:take_reward(NewModPlayerState, FirstPassReward, ?INCOME_DUNGEON_REWARD, ?REWARD_TYPE_DUNGEON_FIRST_PASS);
        {ok, NewModPlayerState, _, _} ->
            {ok, NewModPlayerState}
    end;
may_update_schedule(ModPlayerState, _, _, _, _) ->
    {ok, ModPlayerState}.

%%是否通关标志
%%处理进度要分是否通关来区分
handle_schedule(ModPlayerState, #base_dungeon_area{dungeon_type = ?DUNGEON_MASTER} = BaseDungeon, TargetList, PassFlag) ->
    {IsFirstPass, Dungeon, RestDungeon} = 
        new_schedule(ModPlayerState, BaseDungeon, PassFlag),
    case take_target_reward(ModPlayerState, BaseDungeon, Dungeon, TargetList) of
        {fail, Reason} ->
            {fail, Reason};
        {ok, NewModPlayerState, NewDungeon} ->
            {ok, NewModPlayerState#mod_player_state{dungeon_list = 
                                                        [hdb:dirty(NewDungeon, #dungeon.dirty)|RestDungeon]}, IsFirstPass, NewDungeon}
    end;
handle_schedule(ModPlayerState,_, _, _) ->
    {ok, ModPlayerState, false, []}.

send_schedule(Dungeon) when is_record(Dungeon, dungeon) ->
    {ok, Bin} = pt_12:write(12040, [Dungeon]),
    packet_misc:put_packet(Bin);
send_schedule(_) ->
    skip.

new_schedule(#mod_player_state{dungeon_list = DungeonList} = ModPlayerState,
             #base_dungeon_area{id = BaseId} = BaseDungeon, true) ->    
    case lists:keytake(BaseId, #dungeon.base_id, DungeonList) of
        false ->
            Dungeon = new_dungeon(BaseDungeon, ModPlayerState?PLAYER_ID),
            {true, Dungeon, DungeonList};
        {value, Dungeon, Rest} ->
            if
                Dungeon#dungeon.done =< 0 ->
                    {true, Dungeon, Rest};
                true ->
                    {false, Dungeon, Rest}
            end
    end;
new_schedule(#mod_player_state{dungeon_list = DungeonList} = ModPlayerState, #base_dungeon_area{id = BaseId} = BaseDungeon, false) ->
    case lists:keytake(BaseId, #dungeon.base_id, DungeonList) of
        false ->
            Dungeon = new_dungeon(BaseDungeon, ModPlayerState?PLAYER_ID),
            {false, Dungeon, DungeonList};
        {value, Dungeon, Rest} ->
            {false, Dungeon, Rest}
    end.

new_dungeon(#base_dungeon_area{id = BaseId} = BaseDungeon, PlayerId) ->
    Level = dungeon_level(BaseDungeon),
    LeftTimes = 
        if
            Level =:= ?KING_DUNGEON_TYPE ->
                ?DEFAULT_KING_DUNGEON_TIMES;
            true ->
                0
        end,
    #dungeon{id = get_next_dungeon(),
             base_id = BaseId,
             player_id = PlayerId,
             dungeon_level = dungeon_level(BaseDungeon),
             left_times = LeftTimes}.

take_target_reward(ModPlayerState, #base_dungeon_area{target_reward = BaseTarList},
                   Dungeon, TargetList) ->
    {NewTargetList, RewardList} = 
        lists:foldl(fun(TarId, {AccTargetList, AccReward}) ->
                            case {data_base_dungeon_target:get(TarId), lists:member(TarId, BaseTarList)} of
                                {[], _} ->
                                    {AccTargetList, AccReward};
                                {_, false} ->
                                    ?WARNING_MSG("not found TarId ~p BaseTarList ~p~n", [TarId, BaseTarList]),
                                    {AccTargetList, AccReward};
                                {#base_dungeon_target{reward = Reward}, true} ->
                                    case lists:member(TarId, AccTargetList) of 
                                        true ->
                                            {AccTargetList, AccReward};
                                        false ->
                                            {[TarId|AccTargetList], Reward ++ AccReward}
                                    end
                            end
                    end, {Dungeon#dungeon.target_list, []}, TargetList),
    ?DEBUG("NewTarMdbInfo ~p~n", [NewTargetList]),
    ?DEBUG("target_reward ~p~n", [RewardList]),
    case lib_reward:take_reward(ModPlayerState, RewardList, ?INCOME_DUNGEON_REWARD) of
        {fail, Reason} ->
            {fail, Reason};
        {ok, NewModPlayerState} ->
            {ok, NewModPlayerState, Dungeon#dungeon{target_list = NewTargetList}}
    end.


insert_rank(Sn, mugen_rank, NewDungeonMugen, Player) ->
    WriteTable = hdb:sn_table(mugen_rank, Sn),
    PlayerId = Player#player.id,
    Nickname = Player#player.nickname,
    NewPass = NewDungeonMugen#dungeon_mugen.have_pass_times,
    NewScore = NewDungeonMugen#dungeon_mugen.score,
    NewValue = {NewPass, NewScore, PlayerId},
    insert_rank2(WriteTable, Player#player.id, NewValue, 
                 {Nickname, Player#player.lv, Player#player.career, Player#player.battle_ability});
%% insert_rank(Sn, super_battle_rank, NewSuperBattle, Player) ->
%%     WriteTable = hdb:sn_table(mugen_rank, Sn),
%%     PlayerId = Player#player.id,
%%     Nickname = Player#player.nickname,
%%     NewPass = NewSuperBattle#super_battle.have_pass_times,
%%     NewScore = NewSuperBattle#super_battle.score,
%%     NewValue = {NewPass, NewScore, PlayerId},
%%     insert_rank2(WriteTable, Player#player.id, NewValue,
%%                  {Nickname, Player#player.lv, Player#player.career, Player#player.battle_ability});
insert_rank(_, _, _, _) ->
    ignore.

insert_rank2(WriteTable, PlayerId, NewValue, Ext) ->
    ?DEBUG("Table ~p, NewValue ~p, Ext ~p~n", [WriteTable, NewValue, Ext]),
    mod_rank:insert(WriteTable, PlayerId, NewValue, Ext).
%%检查客户端发过来的奖励是否合法
check_client_reward([], _) ->
    true;
check_client_reward([{GoodsId, Num}|Tail], Reward) ->
    Count = 
        lists:foldl(fun
                        ({BaseId, Sum}, Info) 
                          when BaseId =:= GoodsId ->
                           Sum + Info;
                        (_, Info) ->
                           Info
                    end, 0, Reward),
    if
        Num > Count ->
            false;
        true ->
            check_client_reward(Tail, Reward)
    end.

handle_dungeon_task_event(Pid, DungeonId, TimeCost, Score) ->
    mod_player:task_event(Pid, {?TASK_DUNGEON, DungeonId, 1, TimeCost, Score}).
handle_monster_task_event(Pid, AreaId, DungeonLv) ->
    mod_player:task_event(Pid, {?TASK_DUNGEON_AREA, AreaId, DungeonLv, 1}).
handle_teamdungeon_task_event(Pid, TeamType) ->
    mod_player:task_event(Pid, {?TASK_TEAM_DUNGEON, TeamType, 1}).    
handle_monster_task_event(Pid, MonsterList) ->
    if
        MonsterList =:= [] ->
            skip;
        true ->
            EventList = 
                lists:map(fun({MonstersId, Num}) ->
                                  {?TASK_MONSTER, MonstersId, Num}
                          end, MonsterList),
            mod_player:task_event_list(Pid, EventList)
    end.

%%不触发任务事件了，等客户端检测
%% handle_mugen_task(Pid, Mugen) ->
%%     mod_player:task_event(Pid, {?TASK_MUGEN, Mugen#dungeon_mugen.have_pass_times}).


check_dungeon_route(_, []) ->
    false;
check_dungeon_route(MonstersRewards, [Id|LeftIds]) ->
    case check_dungeon_route2(MonstersRewards, Id, LeftIds) of
        false ->
            false;
        Other ->
            Other
    end.


check_dungeon_route2(MonstersRewards, Id, []) ->
    case lists:keyfind(Id, 1, MonstersRewards) of
        false ->
            false;
        {_, _, MonsList, RewardList, ObjectReward} ->
            {MonsList, RewardList ++ ObjectReward}
    end;
check_dungeon_route2(MonstersRewards, Id, [NextId|LeftIds]) ->
    case lists:keyfind(Id, 1, MonstersRewards) of
        false ->
            false;
        {_, Ports, MonsList, RewardList, ObjectReward} ->
            %io:format("Ports ~p, nextsubids ~p~n", [Ports, get_next_sub_ids(Ports)]),
            case lists:member(NextId, get_next_sub_ids(Ports)) of
                false ->
                    false;
                true ->
                    case check_dungeon_route2(MonstersRewards, NextId, LeftIds) of
                        false ->
                            false;
                        {AddMons, AddRewards} ->
                            {AddMons ++ MonsList, AddRewards ++ RewardList ++ ObjectReward}
                    end
            end
    end.
get_next_sub_ids(Ports) ->
    lists:foldl(fun(Port, NextSubIds) ->
                        case data_base_dungeon_create_portal:get(Port) of
                            [] ->
                                ?WARNING_MSG("data_base_dungeon_create_portal error id~p~n", [Port]),
                                NextSubIds;
                            #base_dungeon_create_portal{next_id = NextId} ->
                                [NextId|NextSubIds]
                        end
                end, [], Ports).
%%主线副本要根据评级给额外奖励
extra_reward(?DUNGEON_MASTER, Vip, ClientGold, BaseGoal, BestGrade, [BoxId, _]) ->
    lists:foldl(fun({GoldId, AddSum}, [{GoodsId, AccNum}]) ->
                        if
                            GoldId > BestGrade andalso GoldId =< ClientGold ->
                                NewAdd = extra_vip_score_reward(Vip, AddSum),
                                ?DEBUG("AddSum ~p vip NewAdd ~p~n", [AddSum, NewAdd]),
                                [{GoodsId, AccNum + NewAdd}];
                            true ->
                                [{GoodsId, AccNum}]
                        end
                end, [{BoxId, 0}], BaseGoal);
extra_reward(_, _, _, _, _, _) ->
    [].

%% term_to_reward([]) ->
%%     [];
%% term_to_reward(RewardAfterCheck) ->   %%奇葩的结构[{{baseid, bind}, num} ......]
%%     lists:map(fun
%%                   ({{BaseId, _Bind}, Sum}) ->
%%                       {BaseId, Sum};
%%                   (#common_reward{goods_id = BaseId,
%%                                   goods_sum = Sum}) ->
%%                       {BaseId, Sum}
%%               end, RewardAfterCheck).
%%------------这几个函数是把怪物掉落解出来--------------------
get_all_dungeon_drop(AllDrops) ->
    lists:foldl(fun({SubId, Portals, WavesInfo, ObjectInfo}, DropInfo) ->
                        {MonsDict, RewardDict} = get_waves_drop(WavesInfo),
                        ObjectDrop = get_object_info(ObjectInfo),   %%物件掉落也解出来
                        [{SubId, Portals, dict:to_list(MonsDict), dict:to_list(RewardDict), dict:to_list(ObjectDrop)}|DropInfo]
                end, [], AllDrops).

get_object_info(ObjectInfo) ->
    %?QPRINT(ObjectInfo),
    lists:foldl(fun({_, WaveInfos}, AccDrop) ->
                        get_waves_drop(WaveInfos, AccDrop)
                end, dict:new(), ObjectInfo).

get_waves_drop(WaveInfos, Dict) ->
    lists:foldl(fun({_, _, RewardList}, AccDict) ->
                        count_reward(AccDict, RewardList)
                end, Dict, WaveInfos).

count_reward(Dict, RewardList) ->
    lists:foldl(fun(#common_reward{goods_id = BaseId,
                                   goods_sum = Sum}, AddDict) ->
                        if
                            BaseId =:= 0 ->
                                AddDict;
                            true ->
                                dict:update_counter(BaseId, Sum, AddDict)
                        end
                end, Dict, RewardList). 

get_waves_drop(WavesInfo) ->
    lists:foldl(fun({_, MonsterInfo}, {MonsDict, RewardDict}) ->
                        get_monster_drop(MonsterInfo, MonsDict, RewardDict)
                end, {dict:new(), dict:new()}, WavesInfo).

get_monster_drop(MonsterInfo, MonsDict, RewardDict) ->
    lists:foldl(fun({_, MonstersId, RewardList}, {AccMons, AccReward}) ->
                        NewRewardDict = count_reward(AccReward, RewardList),
                        {dict:update_counter(MonstersId, 1, AccMons), NewRewardDict}
                end, {MonsDict, RewardDict}, MonsterInfo).

%%=================================== only use to check dungeon ==========================================
%%这里是测试所有副本的接口，主要是内部检测副本问题，不对外使用
test_dungeon() ->
    lager:start(),
    application:start(hstdlib),
    lager:trace_file("/home/liu/server_p02/logs/dungeon.log", [{module, ?MODULE}], error),
    MugenIdList = [],  %%暂时先关掉，因为策划还没开始搞
        %% case data_base_dungeon_area:get_mugen_id_range() of
        %%     [] ->
        %%         [];
        %%     [From, To] ->
        %%         lists:seq(From, To)
        %% end,
    DungeonIdList = data_base_dungeon_area:get_dungeon_all_id() ++ MugenIdList,
    lists:foreach(fun(Id) ->
                          try 
                              test_dungeon(Id)
                          catch 
                              _:_ ->
                                  ?ERROR_MSG("dungeon error ~p~n", [Id])
                          end
                  end, DungeonIdList),
    io:format("run ok ~n", []).

test_dungeon(Id) ->
    case data_base_dungeon_area:get(Id) of
        [] ->
            skip;
        Dungeon  ->
            generate_dungeon_item(Dungeon)
    end.

%%=================================== only use to check dungeon ==========================================
         
%%翻牌（先领奖再翻牌）
dungeon_flip_card(#mod_player_state{
                     dungeon_info = DungeonInfo} = ModPlayerState, DungeonId, ?TYPE_FLIP_CARD_FREE, Pos) ->
    #dungeon_info{dungeon_id = Id,
                  free_card_times = Times} = DungeonInfo,
    case data_base_dungeon_area:get(Id) of
        [] ->
            {fail, ?INFO_CONF_ERR};
        #base_dungeon_area{free_card_reward = RewardList} ->
            case check_filp_card(Id, DungeonId, RewardList, Times) of
                {fail, Reason} ->
                    {fail, Reason};
                true ->
                    case inner_take_flip_card_reward(Id, ModPlayerState, RewardList, ?TYPE_FLIP_CARD_FREE, Pos) of
                        {fail, Reason} ->
                            {fail, Reason};
                        {ok, NewModPlayerState} ->
                            {ok, NewModPlayerState#mod_player_state{dungeon_info = DungeonInfo#dungeon_info{free_card_times = Times - 1}}}
                    end                    
            end
    end;
dungeon_flip_card(#mod_player_state{dungeon_info = #dungeon_info{
                                                      dungeon_id = Id,
                                                      pay_card_times = Times} = DungeonInfo,
                                    player = Player} = ModPlayerState, DungeonId, ?TYPE_FLIP_CARD_PAY, Pos) ->
    case data_base_dungeon_area:get(Id) of
        [] ->
            {fail, ?INFO_CONF_ERR};
        #base_dungeon_area{pay_card_reward = RewardList,
                           pay_card_consume = Consume} ->
            case check_filp_card(Id, DungeonId, RewardList, Times) of
                {fail, Reason} ->
                    {fail, Reason};
                true ->
                    case lib_player:cost_money(Player, Consume, ?COST_FLIP_CARD) of
                        {ok, NewPlayer} ->
                            case inner_take_flip_card_reward(Id, ModPlayerState#mod_player_state{player = NewPlayer}, RewardList, ?TYPE_FLIP_CARD_PAY, Pos) of
                                {fail, Reason} ->
                                    {fail, Reason};
                                {ok, NewModPlayerState} ->
                                    LogType = get_log_card_type(Id),
                                    lib_log_player:log_system({Player#player.id, LogType, Id, 0, 0}),
                                    {ok, NewModPlayerState#mod_player_state{dungeon_info = DungeonInfo#dungeon_info{pay_card_times = Times - 1}}}
                            end;
                        {fail, Reason} ->
                            {fail, Reason}
                    end
            end
    end;
dungeon_flip_card(_, _, _, _) ->
    {fail, ?INFO_FLIP_CARD_ERROR_TYPE}.

inner_take_flip_card_reward(Id, ModPlayerState, RewardList, Type, Pos) ->
    CardReward = get_flip_card_reward(RewardList),
    Career = ModPlayerState#mod_player_state.player#player.career,
    Reward = 
        lists:filter(fun(#common_reward{goods_id = Gid}) ->
                             case data_base_goods:get(Gid) of
                                 #base_goods{career = NeedCareer} 
                                   when NeedCareer =:= 0 orelse NeedCareer =:= Career ->
                                     true;
                                 _ ->
                                     false
                             end
                     end, CardReward),
    ?DEBUG("OldReward ~p, Reward ~p~n", [RewardList, Reward]),
    case lib_reward:take_reward(ModPlayerState, Reward, 12010) of
        {ok, NewModPlayerState} ->
            {ok, BinData} = pt_12:write(12010, {Id, Type, Reward, Pos}),
            packet_misc:put_packet(BinData),
            {ok, NewModPlayerState};
        {fail, Reason} ->
            {fail, Reason}
    end.

check_filp_card(Id, DungeonId, RewardList, Times) ->
    if
        Id =/= DungeonId ->
            ?WARNING_MSG("not match Id ~p  ClientDungeonId ~p~n", [Id, DungeonId]),
            {fail, ?INFO_FLIP_CARD_REWARD_NOT_MATCH};
        Times =< 0 ->
            {fail, ?INFO_FLIP_CARD_TIMES_OUT};
        RewardList =:= [] ->
            {fail, ?INFO_FLIP_CARD_NO_REWARD};
        true ->
            true
    end.

get_flip_card_reward(RewardList) ->
    lib_reward:generate_reward_list(RewardList).

dirty_super_battle(SuperBattle) ->
    hdb:dirty(SuperBattle, #super_battle.dirty).

dirty_mugen(DungeonMugen) ->
    hdb:dirty(DungeonMugen, #dungeon_mugen.dirty).

dirty_mugen_reward(MugenReward) ->
    hdb:dirty(MugenReward, #mugen_reward.dirty).

dirty_source_dungeon(SourceDungeon) ->
    hdb:dirty(SourceDungeon, #source_dungeon.dirty).

get_super_battle_next(DungeonId) ->
    case data_base_dungeon_area:get_super_battle_id_range() of
        [] ->
            0;
        [_Min, Max] ->
            if
                DungeonId >= Max ->
                    0;
                true ->
                    DungeonId + 1
            end
    end.   

%% get_super_battle_last(DungeonId) ->
%%     case data_base_dungeon_area:get_super_battle_id_range() of
%%         [] ->
%%             false;
%%         [Min, Max] ->
%%             Last = DungeonId - 1,
%%             if
%%                 Last >= Min andalso Last < Max ->
%%                     Last;
%%                 true ->
%%                     false
%%             end
%%     end.

relive(Player, DungeonId, Times) ->
    if
        Times =< 0 ->
            {fail, ?INFO_RELIVE_TIMES_OUT};
        true ->
            case data_base_dungeon_area:get(DungeonId) of
                [] ->
                    {fail, ?INFO_CONF_ERR};
                #base_dungeon_area{relive_cost = Cost} ->
                    lib_player:cost_money(Player, Cost, ?COST_BUY_LIFE)
            end
    end.

buy_healing_salve(Player, Times) ->
    Cost = cost_buy_healing_salve(Times, 0),
    ?DEBUG("Cost ~p~n", [Cost]),
    lib_player:cost_money(Player, Cost, ?GOODS_TYPE_COIN, ?COST_BUY_HEALING_SALVE).

cost_buy_healing_salve(0, AccCost) ->
    AccCost;
cost_buy_healing_salve(Times, AccCost) 
  when Times > 0 ->
    NewCost = (1 bsl ((Times - 1) div 2)) * 500,
    cost_buy_healing_salve(Times - 1, AccCost + NewCost).


%%为了防止策划配错导致服务器崩溃，副本create_range要处理一下
range_confirm([From, To]) ->
    Range = To - From,
    if
        Range < 0 ->
            ?ERROR_MSG("config error ~p~n", [[From, To]]),
            [];
        true ->
            NewRange = min(Range, ?MAX_RANGE),
            lists:seq(From, From + NewRange)
    end.

get_boss_hp(AreaId) ->
    case data_base_dungeon_area:get(AreaId) of
        #base_dungeon_area{sub_dungeon_id = [SubId]} ->
            case data_base_dungeon_detail:get(SubId) of
                #base_dungeon_detail{monster_create_id = [[CreateId]|_]} ->
                    get_boss_hp2(CreateId);                        
                Other ->
                    ?WARNING_MSG("get dungeon detail  error ~p~n", [Other]),
                    {0, 0, 0}
            end;
        Other ->
            ?WARNING_MSG("get area error ~p~n", [Other]),
            {0, 0, 0}
    end.

get_boss_hp2(CreateId) ->
    case data_base_dungeon_create_monster:get(CreateId) of
        #base_dungeon_create_monster{create_range = [Id, Id]} ->
            case data_base_dungeon_create_monster:get(Id) of
                #base_dungeon_create_monster{create_probability = [{MonsterId, _}]} ->
                    case data_base_dungeon_monsters_attribute:get(MonsterId) of
                        #base_dungeon_monsters_attribute{
                           lv = Lv,   %%这个是boss的基础等级，升级是在这个基础上加的
                           hp_lim = OHp} ->
                            NowLv = Lv + get_world_boss_now_lv(MonsterId),
                            case data_base_monster_level_attribute:get(NowLv) of
                                [] ->
                                    {MonsterId, 0, NowLv};
                                #base_monster_level_attribute{hp_lim = LvHp} ->
                                    {MonsterId, hmisc:ceil(OHp / 100 * LvHp), NowLv}
                            end;
                        Other ->
                            ?WARNING_MSG("get monsters_attribute error ~p~n", [Other]),
                            {0, 0, 0}
                    end;
                Other ->
                    ?WARNING_MSG("get create_monster error ~p~n", [Other]),
                    {0, 0, 0}
            end;
        Other ->
            ?WARNING_MSG("get area error ~p~n", [Other]),
            {0, 0, 0}
    end.

get_world_boss_now_lv(MonsterId) ->
    case hdb:dirty_read(server_config, {?WORLD_BOSS_LV, MonsterId}) of
        [] ->
            hdb:dirty_write(server_config, #server_config{k = {?WORLD_BOSS_LV, MonsterId},
                                                          v = {0, ?WORLD_BOSS_STATE_NORMAL}}),
            0;
        #server_config{v = {Value, _}} ->
            Value
    end.

get_daily_dungeon(Lv) ->
    case data_base_daily_dungeon_info:get(Lv) of
        [] ->
            [];
        #base_daily_dungeon_info{id = Id,
                                 lv_condition = LvCondition,
                                 pass_condition = PassCondition} ->
            DungeonId = get_daily_dungeon2(Lv, LvCondition),
            Condition = get_dungeon_pass_condition(Id, PassCondition),
            {DungeonId, Condition}
    end.

get_daily_dungeon2(PlayerLv, LvCondition) ->
    LvType = hmisc:rand(LvCondition),
    case data_base_daily_dungeon_lv:get(LvType) of
        [] ->
            [];
        #base_daily_dungeon_lv{lv = [Min, Max]} ->
            MinLv = max(PlayerLv + Min, 0),
            MaxLv = max(PlayerLv + Max, 0),
            DungeonLv = hmisc:rand(MinLv, MaxLv),
            ?DEBUG("get daily dungeon Lv ~p~n", [DungeonLv]),
            case data_base_dungeon_area:get_daily_dungeon_by_lv(DungeonLv) of
                [] ->
                    [];
                DungeonIdList ->
                    GetDungeonId = hmisc:rand(DungeonIdList),
                    ?DEBUG("get daily dungeon Id ~p~n", [GetDungeonId]),
                    case data_base_dungeon_area:get(GetDungeonId) of
                        [] ->
                            [];
                        Dungeon ->
                            Dungeon#base_dungeon_area.id
                    end
            end
    end.

get_dungeon_pass_condition(Id, PassCondition) ->
    ConditionCount = hmisc:rand(PassCondition),  %%通关条件的数量
    case data_base_daily_dungeon_condition:get(Id) of
        [] ->
            [];
        ConditionList ->
            hmisc:rand_n(ConditionCount, ConditionList)
    end.

skip_mugen(ModPlayerState, Type) ->
    case check_skip_mugen(ModPlayerState, Type) of
        {fail, Reason} ->
            {fail, Reason};
        {ok, #mod_player_state{dungeon_mugen = NewDungeonMugen,
                               player = Player} = NewModPlayerState} ->
            insert_rank(ModPlayerState?PLAYER_SN, mugen_rank, NewDungeonMugen, Player),
            case do_handle_mugen_challenge(NewModPlayerState) of
                {fail, Reason} ->
                    {fail, Reason};
                {ok, NModPlayerState} ->
                    %%不触发任务事件了，等客户端检测
                    %handle_mugen_task(NModPlayerState?PLAYER_PID, NModPlayerState#mod_player_state.dungeon_mugen),
                    {ok, NModPlayerState}
            end
    end.

check_skip_mugen(#mod_player_state{dungeon_mugen = #dungeon_mugen{skip_flag = ?SKIP_MUGEN_OFF}}, _) ->
    {fail, ?INFO_DUNGEON_MUGEN_CAN_NOT_SKIP};
check_skip_mugen(#mod_player_state{dungeon_mugen = #dungeon_mugen{have_pass_times = PassTimes,
                                                                  max_pass_rec = MaxRec}= Mugen,
                                   player = Player} = ModPlayerState, Type) ->
    case check_skip_mugen2(PassTimes) of
        {ok, Max, Cost1, Cost2} ->
            {Cost, NowPass} = 
                if
                    Type =:= ?SKIP_MUGEN_1 ->
                        SkipSize = hmisc:rand(?SKIP_MIN_SIZE, ?SKIP_MAX_SIZE),
                        NewPass = min(PassTimes + SkipSize, Max),
                        {Cost1, NewPass};
                    true ->
                        NewPass = min(PassTimes + ?SKIP_MUGEN2_SIZE, Max),
                        {Cost2, NewPass}
                end,
            case lib_player:cost_money(Player, Cost, ?COST_SKIP_MUGEN) of
                {ok, NewPlayer} ->
                    DungeonId = mugen_get_dungeon_id(NowPass + 1),
                    NewMugen = Mugen#dungeon_mugen{have_pass_times = NowPass,
                                                   last_dungeon = DungeonId,
                                                   max_pass_rec = max(MaxRec, NowPass),
                                                   skip_flag = ?SKIP_MUGEN_OFF},
                    NewModPlayerState = ModPlayerState#mod_player_state{dungeon_mugen = NewMugen,
                                                                        player = NewPlayer},
                    case take_skip_mugen_reward(NewModPlayerState, PassTimes, NowPass) of
                        {ok, NModPlayerState} ->
                            {ok, NModPlayerState};
                        Other ->
                            Other
                    end;
                Other ->
                    Other
            end;
        Other ->
            Other
    end.

check_skip_mugen2(PassTimes) ->
    case data_base_mugen_tower:get_mugen_id_range() of
        [] ->
            {fail, ?INFO_CONF_ERR};
        [_Min, Max] ->
            if 
                PassTimes >= Max ->
                    {fail, ?INFO_DUNGEON_MUGEN_PASS_ALL};
                PassTimes >= ?MAX_PASS_SKIP_MUGEN ->
                    {fail, ?INFO_DUNGEON_MUGEN_CAN_NOT_SKIP};
                true ->
                    case data_base_mugen_tower:get(PassTimes + 1) of
                        [] ->
                            {fail, ?INFO_CONF_ERR};
                        #base_mugen_tower{skip_cost1 = Cost1,
                                          skip_cost2 = Cost2} ->
                            {ok, Max, Cost1, Cost2}
                    end
            end
    end.

take_skip_mugen_reward(ModPlayerState, PassTimes, PassTimes) ->
    {ok, ModPlayerState};
take_skip_mugen_reward(ModPlayerState, PassTimes, NewPass) ->
    AllRewards = 
        lists:foldl(fun(Level, AccReward) ->
                            case data_base_mugen_tower:get(Level) of
                                [] ->
                                    AccReward;
                                #base_mugen_tower{normal_reward = Reward} ->
                                    Reward ++ AccReward
                            end
                    end, [], lists:seq(PassTimes + 1, NewPass)),
    ?DEBUG("AllRewards ~p~n", [AllRewards]),
    lib_reward:take_reward(ModPlayerState, AllRewards, ?INCOME_SKIP_MUGEN).
        
mugen_get_dungeon_id(Level) -> %%层数
    case data_base_mugen_tower:get(Level) of
        [] ->
            0;
        #base_mugen_tower{area_id = AreaId} ->
            AreaId
    end.

mugen_challenge(#dungeon_mugen{challenge_times = RestTimes} = Mugen, PlayerId) ->
    case check_mugen_challenge(Mugen, PlayerId) of
        {fail, Reason} ->
            {fail, Reason};
        {ok, TarPass} ->
            {ok, dirty_mugen(Mugen#dungeon_mugen{challenge_list = [{PlayerId, TarPass}],
                                                 challenge_times = RestTimes - 1})}
    end.

                    

check_mugen_challenge(#dungeon_mugen{challenge_list = ChallengeList,
                                     challenge_times = RestTimes,
                                     have_pass_times = Pass}, PlayerId) ->
    case length(ChallengeList) > ?MAX_MUGEN_CHALLENGE_COUNT of
        true ->
            {fail, ?INFO_DUNGEON_MUGEN_CHALLENGE_MAX};
        false ->
            if
                RestTimes < 1 ->
                    {fail, ?INFO_DUNGEON_MUGEN_CHALLENGE_LIMIT};
                true ->
                    case lib_player:get_other_player_mugen(PlayerId) of
                        [] ->
                            {fail, ?INFO_CONF_ERR};
                        #dungeon_mugen{have_pass_times = TarPass} when Pass < TarPass ->
                            {ok, TarPass};
                        _ ->
                            {fail, ?INFO_DUNGEON_MUGEN_CHALLENGE_LESS}
                    end                            
            end
    end.

%%检查是否完成了挑战好友
do_handle_mugen_challenge(ModPlayerState) ->
    case do_handle_mugen_challenge2(ModPlayerState, []) of
        {fail, Reason} ->
            {fail, Reason};
        {ok, NewModPlayerState} ->
            {ok, NewModPlayerState}
    end.

do_handle_mugen_challenge2(#mod_player_state{dungeon_mugen = #dungeon_mugen{
                                                                challenge_list = []} = Mugen} = ModPlayerState, NewChallengeList) ->
    {ok, ModPlayerState#mod_player_state{dungeon_mugen = Mugen#dungeon_mugen{challenge_list = NewChallengeList}}};
do_handle_mugen_challenge2(#mod_player_state{dungeon_mugen = #dungeon_mugen{
                                                                challenge_list = [{_PlayerId, TarPass}|Rest],
                                                                have_pass_times = Pass} = Mugen} = ModPlayerState, NewChallengeList) when Pass >= TarPass ->
    case mugen_challenge_reward(ModPlayerState, TarPass) of
        {fail, Reason} ->
            {fail, Reason};
        {ok, NewModPlayerState} ->
            do_handle_mugen_challenge2(NewModPlayerState#mod_player_state{dungeon_mugen = Mugen#dungeon_mugen{challenge_list = Rest}}, NewChallengeList)
    end;
do_handle_mugen_challenge2(#mod_player_state{dungeon_mugen = #dungeon_mugen{challenge_list = [H|Rest]} = Mugen} = ModPlayerState, NewChallengeList) ->
    do_handle_mugen_challenge2(ModPlayerState#mod_player_state{dungeon_mugen = Mugen#dungeon_mugen{challenge_list = Rest}}, [H|NewChallengeList]).

mugen_challenge_reward(ModPlayerState, TarPass) ->
    case data_base_mugen_tower:get(TarPass) of
        [] ->
            {fail, ?INFO_CONF_ERR};
        #base_mugen_tower{challenge_reward = Reward} ->
            lib_reward:take_reward(ModPlayerState, Reward, ?INCOME_MUGEN_DUNGEON_CHALLENGE)
    end.
                    
get_next_mugen_reward() ->
    lib_counter:update_counter(mugen_reward_uid).

send_lucky_coin(#mod_player_state{dungeon_mugen = Mugen} = ModPlayerState, TarId) ->
    #dungeon_mugen{player_id = PlayerId,
                   send_lucky_coin = Times,
                   have_pass_times = PassTimes} = Mugen,
    case check_send_lucky_coin(Mugen, TarId) of
        {fail, Reason} ->
            {fail, Reason};
        ok ->
            case data_base_mugen_tower:get(PassTimes) of
                [] ->
                    {fail, ?INFO_CONF_ERR};
                #base_mugen_tower{lucky_reward = LuckyReward} ->
                    case lib_reward:take_reward(ModPlayerState, LuckyReward, ?INCOME_LUCKY_SEND_COIN, ?REWARD_TYPE_SEND_LUCKY_COIN) of
                        {fail, Reason} ->
                            {fail, Reason};
                        {ok, NewModPlayerState} ->
                            write_lucky_coin(#lucky_coin{key = {PlayerId, TarId},
                                                         send = PlayerId,
                                                         recv = TarId}),
                            NewMugen = Mugen#dungeon_mugen{send_lucky_coin = Times + 1},
                            {ok, NewModPlayerState#mod_player_state{dungeon_mugen = NewMugen}}
                    end
            end
    end.
            

check_send_lucky_coin(#dungeon_mugen{player_id = PlayerId,
                                     send_lucky_coin = Times}, TarId) when is_integer(TarId) ->
    if
        Times > ?MAX_LUCKY_COINS ->
            {fail, ?INFO_DUNGEON_MUGEN_LUCKY_COIN_LIMIT};
        true ->
            case hdb:dirty_read(lucky_coin, {PlayerId, TarId}) of
                [] ->
                    ok;
                _ ->
                    {fail, ?INFO_DUNGEON_LUCKY_COIN_DUNPLICATE}
            end
    end.

write_lucky_coin(LuckyCoin) ->
    hdb:dirty_write(lucky_coin, LuckyCoin).

get_mugen_condition(#dungeon_mugen{have_pass_times = Pass}, MugenRewardList) ->
    case lists:keyfind(Pass + 1, #mugen_reward.level, MugenRewardList) of
        false ->
            [];
        #mugen_reward{
           reward1 = R1,
           reward2 = R2,  
           reward3 = R3, 
           reward4 = R4} ->
            [R1, R2, R3, R4]
    end.

get_super_battle_ability(Ability) ->
    max(Ability, 7700).


restart_super_battle(#super_battle{
                        player_id = PlayerId,
                        buy_times = BuyTimes,
                        rest = Rest}, Player) when Rest > 0 ->
    NewSuperBattle = new_super_battle(PlayerId),
    NewAbility = get_super_battle_ability(Player#player.high_ability),
    {ok, NewSuperBattle#super_battle{rest = Rest - 1,
                                     buy_times = BuyTimes,
                                     ability = NewAbility
                                    }};
restart_super_battle(_, _) ->
    {fail, ?INFO_SUPER_BATTLE_OUT_OF_TIMES}.

buy_super_battle_times(#mod_player_state{super_battle = #super_battle{buy_times = BuyTimes,
                                                                      rest = Rest} = SuperBattle,
                                         player = Player} = ModPlayerState) ->
    MaxTimes = lib_vip:max_buy_super_battle(Player#player.vip),
    if
        BuyTimes >= MaxTimes ->
            {fail, ?INFO_DUNGEON_SUPER_BATTLE_BUY_LIMIT};
       true ->
            case lib_vip:get_vip_cost(fair_challange_times_cost, BuyTimes + 1) of
                error ->
                    {fail, ?INFO_CONF_ERR};
                {CostType, CostNum} ->
                    case lib_player:cost_money(Player, CostNum, CostType, ?COST_BUY_SUPER_BATTLE) of
                        {fail, Reason} ->
                            {fail, Reason};
                        {ok, NewPlayer} ->
                            NewSuperBattle = dirty_super_battle(SuperBattle#super_battle{buy_times = BuyTimes + 1,
                                                                                         rest = Rest + ?EACH_BUY_SUPER_BATTLE_TIMES}),
                            {ok, ModPlayerState#mod_player_state{super_battle = NewSuperBattle,
                                                                 player = NewPlayer}}
                    end
            end
    end.

extra_flip_card(Vip) ->
    case data_base_vip:get(Vip) of
        [] ->
            0;
        #base_vip{day_resource_refresh = Times} ->
            Times
    end.

extra_vip_hit_reward(_Vip, []) ->
    [];
extra_vip_hit_reward(Vip, [BoxId, Count]) ->
    case data_base_vip:get(Vip) of
        [] ->
            [BoxId, Count];
        #base_vip{combo_ratio = Radio} ->
            NewCount = Count*Radio div 100,
            [BoxId, NewCount]
    end.

extra_vip_score_reward(Vip, OldCount) ->
    case data_base_vip:get(Vip) of
        [] ->
            OldCount;
        #base_vip{dungeon_score_ratio = Radio} ->
            OldCount*Radio div 100
    end.

%%获取副本区域的进度
series_dungeon_info(DungeonList, SeriesId) ->
    DungeonIds = data_base_dungeon_area:get_series_ids(SeriesId),
    lists:foldl(fun(DungeonId, AccDungeon) ->
                        case lists:keyfind(DungeonId, #dungeon.base_id, DungeonList) of
                            false ->
                                AccDungeon;
                            Dungeon ->
                                [Dungeon|AccDungeon]
                        end
                end, [], DungeonIds).

buy_dungeon_times(#mod_player_state{dungeon_list = DungeonList,
                                    player = Player} = ModPlayerState, BaseDungeonId) ->
    case lists:keytake(BaseDungeonId, #dungeon.base_id, DungeonList) of
        false ->
            {fail, ?INFO_DUNGEON_ONT_ENABLE};
        {value, #dungeon{buy_times = BuyTimes,
                         dungeon_level = ?KING_DUNGEON_TYPE,
                         left_times = LeftTimes} = Dungeon, Rest} ->
            MaxBuyTimes = lib_vip:vip_king_dungeon_buy(Player#player.vip),
            if
                BuyTimes >= MaxBuyTimes ->
                    {fail, ?INFO_KING_DUNGEON_BUY_TIMES_LIMIT};
                true ->
                    case buy_dungeon_times2(Player, BuyTimes) of
                        {fail, Reason} ->
                            {fail, Reason};
                        {ok, NewPlayer} ->
                            NewDungeon = hdb:dirty(Dungeon#dungeon{buy_times = BuyTimes + 1,
                                                                   left_times = LeftTimes + ?DEFAULT_KING_DUNGEON_TIMES,
                                                                   boss_reward_flag = 0
                                                                  },
                                                   #dungeon.dirty),
                            {ok, ModPlayerState#mod_player_state{player = NewPlayer,
                                                                 dungeon_list = [NewDungeon|Rest]}, NewDungeon}
                    end
            end;
        _ ->
            {fail, ?INFO_TYPE_NOT_KING_DUNGEON}
    end.

buy_dungeon_times2(Player, BuyTimes) ->
    case lib_vip:get_vip_cost(king_dungeon_cost, BuyTimes + 1) of
        error ->
            {fail, ?INFO_CONF_ERR};
        {CostType, CostNum} ->
            lib_player:cost_money(Player, CostNum, CostType, ?COST_BUY_KING_DUNGEON)
    end.

%%扫荡相关
mop_up(#mod_player_state{dungeon_list = DungeonList} = ModPlayerState, DungeonId, Times, CardFlag) ->
    case lib_vip:can_mop_up(ModPlayerState?PLAYER_VIP, Times) of
        false ->
            {fail, ?INFO_VIP_LEVEL_TOO_LOW};
        true ->
            case lists:keytake(DungeonId, #dungeon.base_id, DungeonList) of
                false ->
                    {fail, ?INFO_DUNGEON_CANNOT_MOP_UP};
                {value, #dungeon{best_grade = Grade,
                                 dungeon_level = ?KING_DUNGEON_TYPE,
                                 left_times = LeftTimes} = Dungeon, Rest} 
                  when Grade >= ?DEFINE_GRADE_S ->
                    MinTime = min(LeftTimes, Times),
                    if
                        MinTime > 0 ->
                            case mop_up_2(ModPlayerState, Dungeon, MinTime, CardFlag) of
                                {fail, Reason} ->
                                    {fail, Reason};
                                {ok, NewModPlayerState, MopUpInfos, BossRewardFlag} ->
                                    NewBossRewardFlag = case BossRewardFlag orelse Dungeon#dungeon.boss_reward_flag =:= 1 of
                                                            true ->
                                                                1;
                                                            _ ->
                                                                Dungeon#dungeon.boss_reward_flag
                                                        end,
                                    NewDungeon = hdb:dirty(Dungeon#dungeon{left_times = LeftTimes - MinTime, 
                                                                           boss_reward_flag = NewBossRewardFlag
                                                                          }, #dungeon.dirty),
                                    {ok, Bin} = pt_12:write(12040, [NewDungeon]),
                                    packet_misc:put_packet(Bin),
                                    {ok, NewModPlayerState#mod_player_state{dungeon_list = [NewDungeon|Rest]}, MopUpInfos, BossRewardFlag}
                            end;
                        true ->
                            {fail, ?INFO_SUPER_BATTLE_OUT_OF_TIMES}
                    end;
                {value, #dungeon{best_grade = Grade} = Dungeon, _Rest} when Grade >= ?DEFINE_GRADE_S ->
                    mop_up_2(ModPlayerState, Dungeon, Times, CardFlag);
                _ ->
                    {fail, ?INFO_DUNGEON_CANNOT_MOP_UP}
            end
    end.

mop_up_2(ModPlayerState, #dungeon{base_id = DungeonId} = Dungeon, Times, CardFlag) ->
    case data_base_dungeon_area:get(DungeonId) of
        [] ->
            {fail, ?INFO_CONF_ERR};
        #base_dungeon_area{
           %% boss_id = BossId,
           req_vigor = Vigor,
           pay_card_consume = CardConsume,
           %% reward = NormalReward,
           pay_card_reward = PayCardReward
           %% free_card_reward = FreeReward,
           %% boss_skill_piece = BossSkillPiece
          } = BaseDungeonArea ->
            case mop_up_consume(ModPlayerState, Vigor, CardConsume, CardFlag, Times) of
                {fail, Reason} ->
                    {fail, Reason};
                {ok, #player{bag_cnt = BagCnt} = NewPlayer, NewGoodsList, Update, Del} ->
                    PayReward = 
                        if
                            CardFlag =:= ?MOP_UP_PAY_CARD ->
                                PayCardReward;
                            true ->
                                []
                        end,
                    case take_mop_up_reward(ModPlayerState#mod_player_state{
                                              player = NewPlayer#player{
                                                         bag_cnt = BagCnt - length(Del)
                                                        },
                                              bag = NewGoodsList}, BaseDungeonArea, PayReward, Times, Dungeon) of
                        {fail, Reason} ->
                            {fail, Reason};
                        {ok, #mod_player_state{bag = NGoodsList} = NewModPlayerState, MopUpInfos, BossRewardFlag} ->
                            lib_goods:db_delete_goods(Del),
                            UpdateGoodsList = lib_goods:update_goods_info(Update, NGoodsList),
                            pt_15:pack_goods([], Update, Del),
                            packet_misc:send_packet(0, 0, ModPlayerState#mod_player_state.client_pid),
                            {ok, NewModPlayerState#mod_player_state{bag = UpdateGoodsList}, MopUpInfos, BossRewardFlag}
                    end
            end
    end.

%%扫荡券先不管
all_mop_up_consume(Vigor, CardConsume, CardFlag, Times) ->
    CostVigor = {?GOODS_TYPE_VIGOR, Vigor*Times},
    if
        CardFlag =:= ?MOP_UP_PAY_CARD ->
            [CostVigor, {?MOP_UP_CARD, 1*Times} | [{Id, Sum*Times} || {Id, Sum} <- CardConsume]];
        true ->
            [{?MOP_UP_CARD, 1*Times}, CostVigor]
    end.

mop_up_consume(#mod_player_state{player = Player,
                                 bag = GoodsList}, Vigor, CardConsume, CardFlag, Times) ->
    AllCost = all_mop_up_consume(Vigor, CardConsume, CardFlag, Times),
    lib_goods:consume_goods(Player, AllCost, GoodsList).

take_mop_up_reward(ModPlayerState, #base_dungeon_area{boss_id = BossId,
                                                      reward = NormalReward,
                                                      free_card_reward= FreeReward,
                                                      boss_skill_piece = BossSkillPiece
                                                     } = _BaseDungeonArea, PayReward, Times, #dungeon{left_times = LeftTimes,
                                                                                                      boss_reward_flag = BossRewardFlag
                                                                                                     } = Dungeon) ->
    BossDrop = 
        if
            BossId =:= 0 ->
                [];
            true ->
                case data_base_dungeon_monsters_attribute:get(BossId) of
                    [] ->
                        [];
                    #base_dungeon_monsters_attribute{mon_drop = Drop} ->
                        Drop
                end
        end,
    {RewardList, MopUpInfos} = 
        lists:foldl(fun(_, {AccReward, AccMopUp}) ->
                            BossReward = lib_reward:generate_reward_list(BossDrop),
                            PassDungeonReward = lib_reward:generate_reward_list(NormalReward),
                            FreeCardReward = lib_reward:generate_reward_list(FreeReward),
                            PayCardReward = lib_reward:generate_reward_list(PayReward),
                            AllReward = BossReward ++ PassDungeonReward ++ FreeCardReward ++ PayCardReward ++ AccReward,
                            MopUp = 
                                #dungeon_mop_up{normal_reward = PassDungeonReward,
                                                boss_reward = BossReward,
                                                free_card_reward = FreeCardReward,
                                                pay_card_reward = PayCardReward},
                            {AllReward, [MopUp|AccMopUp]}
                    end, {[], []}, lists:seq(1, Times)),
    ?DEBUG("RewardList ~p MopUpInfos ~p~n", [RewardList, MopUpInfos]),   
    IsDropBossReward = lists:foldl(fun({Gid, _Num}, IsDropRet) ->
                                           case lists:keyfind(Gid, #common_reward.goods_id, RewardList) of
                                               #common_reward{} when IsDropRet =:= false ->
                                                   true;
                                               _ ->
                                                   IsDropRet
                                           end
                                   end, false, BossSkillPiece),
    ?DEBUG("IsDropBossReward:~p,LeftTimes:~p,Times:~p,BossRewardFlag:~p~n",[IsDropBossReward,LeftTimes,Times, BossRewardFlag]),
    %% 
    %% 王者FB潜规触发条件
    %%
    {ActionFlag, NewRewards, NewMopUpInfos} =
        case ((not IsDropBossReward) andalso (LeftTimes > 0) andalso (LeftTimes =:= Times) andalso (BossRewardFlag=/=1))  of
            true ->
                ?DEBUG("ACTION~n",[]),
                [H|REST]= MopUpInfos,
                AddRewards = lists:map(fun({GoodsId, Num}) ->#common_reward{goods_id = GoodsId, goods_sum = Num, bind = 0} end, BossSkillPiece),
                NewH= H#dungeon_mop_up{boss_reward = AddRewards},
                NewRewardList = lists:foldl(fun(Del, RetRewardList) ->
                                                    lists:delete(Del, RetRewardList)
                                            end, RewardList, H#dungeon_mop_up.boss_reward),
                {true, NewRewardList ++ BossSkillPiece, [NewH|REST]};
            false ->
                {false, RewardList, MopUpInfos}
        end,
    NewBossRewardFlag = IsDropBossReward orelse BossRewardFlag=:=1 orelse ActionFlag,
    case lib_reward:take_reward(ModPlayerState, NewRewards, ?INCOME_DUNGEON_MOP_UP) of
        {fail, Reason} ->
            {fail, Reason};
        {ok, NewModPlayerState} ->
            {ok, NewModPlayerState, NewMopUpInfos, NewBossRewardFlag}
    end.


get_log_dungeon_type(Type, DungeonLevel) ->
    case Type of
        Type when Type =:= ?DUNGEON_SOURCE_EXP orelse
                  Type =:= ?DUNGEON_SOURCE_GOLD orelse
                  Type =:= ?DUNGEON_SOURCE_COIN ->
            ?LOG_RESOURCE_DUNGEON;
        ?DUNGEON_MASTER ->
            case DungeonLevel of
                1 ->
                    ?LOG_NORMAL_DUNGEON;
                2 ->
                    ?LOG_VENTURE_DUNGEON;
                3 ->
                    case is_double_drop_time() of
                        true ->
                            ?LOG_ACTIVITY_KING_DUNGEON;
                        _ ->
                            ?LOG_KING_DUNGEON
                    end
            end;
        ?DUNGEON_MEGUN ->
            ?LOG_MUGEON;
        ?DUNGEON_SUPER_BATTLE ->
            ?LOG_SUPER_BATTLE;
        _ ->
            ?DEBUG("UnkownDungeonTyupe:~p~n",[Type]),
            0
    end.

get_log_card_type(DungeonId) ->
    case data_base_dungeon_area:get(DungeonId) of
        [] ->
            0;
        #base_dungeon_area{
           dungeon_type = Type
          } = BaseDungeon ->
            DungeonLevel = dungeon_level(BaseDungeon),
            case Type of
                Type when Type =:= ?DUNGEON_SOURCE_EXP orelse
                          Type =:= ?DUNGEON_SOURCE_GOLD orelse
                          Type =:= ?DUNGEON_SOURCE_COIN ->
                    ?LOG_RESOURCE_CARD;
                ?DUNGEON_MASTER ->
                    case DungeonLevel of
                        1 ->
                            ?LOG_NORMAL_CARD;
                        2 ->
                            ?LOG_VENTURE_CARD;
                        3 ->
                            ?LOG_KING_CARD
                    end;
                _ ->
                    ?DEBUG("UnkownDungeonTyupe:~p~n",[Type]),
                    0
            end
    end.


