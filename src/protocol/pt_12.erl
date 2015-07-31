%%%-----------------------------------
%%% @Module  : pt_12
%%% @Created : 2013.11.07
%%% @Description: 12 关卡信息
%%%-----------------------------------
-module(pt_12).
-export([write/2,
         to_pbmugendungeon/1,
         super_battle_to_pbmugendungeon/1]).

-include("define_logger.hrl").
-include("define_dungeon.hrl").
-include("pb_12_pb.hrl").
-include("define_reward.hrl").
-include("define_rank.hrl").
-include("define_dungeon_match.hrl").

%%
%%客户端 -> 服务端 ----------------------------
%%
write(12001, {Id, Type, DungeonInfo, AllDrops}) ->
    NormalRewards = DungeonInfo#dungeon_info.normal_rewards,
    %?PRINT("NormalRewards ~p~n", [NormalRewards]),
    PbDungeonReward        = to_pbdungeon_reward(NormalRewards),
    PbSubDungeonInfo       = to_pb_subdungeon(AllDrops),
    HitReward = 
        case DungeonInfo#dungeon_info.hit_reward of
            [] ->
                undefined;
            [BoxId, BoxNum] ->
                [#pbdungeonreward{
                    goods_id = BoxId,
                    number    = BoxNum
                   }]
        end,
    %io:format("PbSubDungeonInfo ~p~n", [PbSubDungeonInfo]),
    PbDungeon = 
        #pbdungeon{
           id = Id,
           reward         = PbDungeonReward,
           dungeon_info   = PbSubDungeonInfo,
           type = Type,
           relive_times = DungeonInfo#dungeon_info.relive_times,
           team_num = DungeonInfo#dungeon_info.team_id,
           team_type = DungeonInfo#dungeon_info.team_type,
           team_flag = DungeonInfo#dungeon_info.team_flag,
           cur_sub_dungeon = DungeonInfo#dungeon_info.sub_dungeon_id,
           is_extra = DungeonInfo#dungeon_info.grade,
           pass_time = DungeonInfo#dungeon_info.pass_time,
           hit_reward = HitReward,
           hit_reward_detail = to_hit_reward_detail(DungeonInfo#dungeon_info.hit_reward_detail)
          },
    %io:format("PbDungeon ~p~n", [PbDungeon]),
    pt:pack(12001, PbDungeon);

write(12002, _) ->
    pt:pack(12002, <<>>);
write(12003, null) ->
    pt:pack(12003, <<>>);
write(12004, null) ->
    pt:pack(12004, <<>>);
write(Cmd, {SelfInfo, RankList}) 
  when Cmd =:= 12005 orelse Cmd =:= 12006 ->
    SelfRank = 
        case SelfInfo of
            {0, _} ->
                0;
            {Rank, _} ->
                Rank
        end,
    PbRankList = 
        lists:map(fun(Rank) ->
                          to_pb_challengedungeoninfo(Rank)  
                  end, RankList),
        pt:pack(Cmd, #pbchallengedungeonrank{rank_list = PbRankList,
                                             self = SelfRank});

write(12007, null) ->
    pt:pack(12007, <<>>);
write(12008, null) ->
    pt:pack(12008, <<>>);
write(12010, {Id, Type, RewardList, Pos}) ->
    ?DEBUG("RewardList ~p~n", [RewardList]),
    [PbDungeonReward] = to_pbdungeon_reward(RewardList),   %%确认翻牌奖励只有一个，发optional pbdungeonreward
    PbFlipCard = #pbflipcard{
                    dungeon_id = Id,
                    card_type = Type,
                    reward = PbDungeonReward,
                    pos = Pos},
    pt:pack(12010, PbFlipCard);
write(12020, Mugen)
  when is_record(Mugen, pbchallengedungeon) ->
    pt:pack(12020, Mugen);
write(12020, {Mugen, Condition}) 
  when is_record(Mugen, dungeon_mugen) ->
    PbMugen = to_pbmugendungeon({Mugen, Condition}),
    pt:pack(12020, PbMugen);

write(12026, _) ->
    pt:pack(12026, <<>>);

write(12030, SuperBattle)
  when is_record(SuperBattle, pbchallengedungeon) ->
    pt:pack(12030, SuperBattle);
write(12030, SuperBattle) 
  when is_record(SuperBattle, super_battle) ->
    PbSuperBattle = super_battle_to_pbmugendungeon(SuperBattle),
    pt:pack(12030, PbSuperBattle);

write(12040, DungeonInfoList) ->
    PbDungeonSchedule = 
        #pbdungeonschedule{
           target_info = lists:map(fun(#dungeon{base_id = DungeonId,
                                                target_list = TarIdList,
                                                dungeon_level = Level,
                                                left_times = LeftTimes,
                                                buy_times = BuyTimes,
                                                done = Done,
                                                best_grade = BestGrade}) ->
                                           #pbdungeontarget{dungeon_id = DungeonId,
                                                            target_list = TarIdList,
                                                            dungeon_level = Level,
                                                            left_times = LeftTimes,
                                                            buy_times = BuyTimes,
                                                            done = Done,
                                                            best_grade = BestGrade}
                                   end, DungeonInfoList)
          },
    pt:pack(12040, PbDungeonSchedule);

write(12041, #player_dungeon_match{win_times = Win,
                                   fail_times = Fail}) ->
    WinRate = 
        case Win + Fail of
            0 ->
                100;
            Value ->
                (Win * 100) div Value  
        end,
    pt:pack(12041, #pbwinrate{win_times = Win,
                              fail_times = Fail,
                              win_rate = WinRate});
write(12043, MopUpInfos) ->
    PbMopUpList = 
        #pbmopuplist{mop_up_info = lists:map(fun(MopUp) ->
                                                     to_pb_mop_up(MopUp)
                                             end, MopUpInfos)},
    pt:pack(12043, PbMopUpList);
write(12050, DailyDungeon) 
  when is_record(DailyDungeon, daily_dungeon) ->
    PbDailyDungeon = to_pb_daily_dungeon(DailyDungeon),
    pt:pack(12050, PbDailyDungeon);
write(12060, SourceDungeon)
  when is_record(SourceDungeon, source_dungeon) ->
    PbSourceDungeon = to_pb_source_dungeon(SourceDungeon),
    pt:pack(12060, PbSourceDungeon);
        
write(Cmd, _R) ->
    ?WARNING_MSG("pt write error Cmd ~p Reason ~p~n", [Cmd, _R]),
    pt:pack(0, <<>>).

to_pbmugendungeon({DungeonData, Condition}) ->
    #dungeon_mugen{
       last_dungeon = Id,
       score = Score,
       have_pass_times = PassTimes,
       challenge_list = ChallengeList,
       challenge_times = RestTimes,
       send_lucky_coin = CoinTimes,
       use_lucky_coin = UseTimes,
       max_pass_rec = MaxPass,
       skip_flag = SkipFlag
      } = DungeonData,
    #pbchallengedungeon{dungeon_id = Id,
                        score = Score,
                        type = ?DUNGEON_MEGUN,
                        have_pass_times = PassTimes,
                        condition = Condition,
                        challenge_times = RestTimes,
                        challenge_list = to_pbmugenchallenge(ChallengeList),
                        send_lucky_coin = CoinTimes,
                        use_lucky_coin = UseTimes,
                        max_pass_times = MaxPass,
                        skip_mugen_flag = SkipFlag
                   }.

to_pbmugenchallenge([]) ->
    [];
to_pbmugenchallenge(List) ->
    lists:map(fun({PlayerId, Level}) ->
                      #pbmugenchallenge{player_id = PlayerId,
                                        level = Level}
              end, List).

super_battle_to_pbmugendungeon(DungeonData) ->
    #super_battle{
       last_dungeon = Id,
       next_dungeon = Next,
       score = Score,
       rest = Rest,
       state = State,
       cur_hp = Hp,
       have_pass_times = PassTimes,
       buy_times = BuyTimes,
       ability = Ability
      } = DungeonData,
    #pbchallengedungeon{dungeon_id = Id,
                        next_dungeon_id = Next, 
                        score = Score,
                        type = ?DUNGEON_MEGUN,
                        left_times = Rest,
                        state = State,
                        cur_hp = Hp,
                        buy_times = BuyTimes,
                        have_pass_times = PassTimes,
                        ability = Ability
                   }.

to_pbdungeon_reward(Rewards) ->
    lists:map(
        fun(#common_reward{goods_id  = GoodsId,  
                           goods_sum = Number}) ->                
                #pbdungeonreward{
                   goods_id = GoodsId,
                   number    = Number
                  }
        end, Rewards).

to_pb_subdungeon(AllDrops) ->
    lists:map(fun({SubId, Ports, MonsterDrop, ObjectInfo}) ->
                      #pbsubdungeon{
                         id = SubId,
                         create_portal = Ports,
                         wave_monster = to_pbwavemonster(MonsterDrop),
                         wave_creature = to_pbwavecreature(ObjectInfo)}
              end, AllDrops).

to_pbwavemonster(MonsterInfo)
  when is_list(MonsterInfo) ->
    lists:map(fun({WaveId, MonDrops}) ->
                      #pbwavemonster{
                         id = WaveId,
                         monster_info = to_pb_dungeon_monster(MonDrops)}
              end, MonsterInfo).

to_pb_dungeon_monster(MonDrops) ->
    lists:map(fun({CreateId, MonId, RewardList}) ->
                      #pbdungeonmonster{
                        monster_id = MonId,
                        monster_drop = to_pb_monster_drop(RewardList),
                        create_id = CreateId}
              end, MonDrops).

to_pb_monster_drop(RewardList) ->
    lists:foldl(fun(#common_reward{goods_id = GoodsId,
                                   goods_sum = Sum}, AccReward) ->
                        case GoodsId of
                            0 ->
                                AccReward;
                            _ ->
                                Drop = 
                                    #pbmonsterdrop{
                                       goods_id = GoodsId,
                                       number = Sum
                                      },
                                [Drop|AccReward]
                        end
              end, [], RewardList).

to_pbwavecreature(ObjectInfo) ->
    lists:map(fun({WaveId, ObjectDrop}) ->
                      #pbwavecreature{id = WaveId,
                                      creature_info = to_pbdungeon_creature(ObjectDrop)}
              end, ObjectInfo).

to_pbdungeon_creature(ObjectDrop) ->
    lists:map(fun({CreateId, ObjectId, RewardList}) ->
                      #pbdungeoncreature{
                         create_id = CreateId,
                         creature_id = ObjectId,
                         creature_drop = to_pb_creature_drop(RewardList)
                        }
              end, ObjectDrop).

to_pb_creature_drop(RewardList) ->
    lists:foldl(fun(#common_reward{goods_id = GoodsId,
                                   goods_sum = Sum}, AccReward) ->
                        case GoodsId of
                            0 ->
                                AccReward;
                            _ ->
                                Drop = 
                                    #pbcreaturedrop{
                                       goods_id = GoodsId,
                                       number = Sum
                                      },
                                [Drop|AccReward]
                        end
              end, [], RewardList).

to_pb_challengedungeoninfo(#rank{value = {Pass, Score, PlayerId},
                                 ext = {Nickname, Lv, Career, BattleAbility}}) ->
    #pbchallengedungeoninfo{
       id = PlayerId,
       name = Nickname,
       lv = Lv,
       career = Career,
       battle_ability = BattleAbility,
       have_pass_times = Pass,
       score = Score};
to_pb_challengedungeoninfo(Other) ->
    ?WARNING_MSG("to_pb_challengedungeoninfo error ~p~n", [Other]),
    #pbchallengedungeoninfo{}.

to_pb_daily_dungeon(DailyDungeon) ->
    #daily_dungeon{
       dungeon_id = DungeonId,
       time = Time,
       damage = Damage,
       hurt = Hurt,
       combo = Combo,
       aircombo = AirCombo,
       skillcancel = SkillCancel,
       crit = Crit,
       left_times = Times
      }
        = DailyDungeon,
    #pbdailydungeon{
       dungeon = #pbdungeon{id = DungeonId},
       condition = #pbdungeoncondition{
                      time = Time,
                      damage = Damage,
                      hurt = Hurt,
                      combo = Combo,
                      aircombo = AirCombo,
                      skillcancel = SkillCancel,
                      crit = Crit
                     },
       left_times = Times}.

to_pb_source_dungeon(#source_dungeon{info = InfoList}) ->
    PbInfo = 
        lists:map(fun({Type, LeftTimes}) ->
                          #pbsourcedungeoninfo{type = Type,
                                               left_times = LeftTimes}
                  end, InfoList),
    #pbsourcedungeon{info = PbInfo}.

to_pb_mop_up(MopUp) ->
    #dungeon_mop_up{normal_reward = PassDungeonReward,
                    boss_reward = BossReward,
                    free_card_reward = FreeCardReward,
                    pay_card_reward = PayCardReward} = MopUp,
    #pbmopup{normal_reward = to_pbdungeon_reward(PassDungeonReward),
             boss_reward = to_pbdungeon_reward(BossReward),
             free_card_reward = to_pbdungeon_reward(FreeCardReward),
             pay_card_reward = to_pbdungeon_reward(PayCardReward)}.
    
to_hit_reward_detail(HitRewardDetail) ->
    lists:map(fun({Combo, Num}) ->
                      #pbhitrewarddetail{combo = Combo,
                                         number = Num}
              end, HitRewardDetail).
