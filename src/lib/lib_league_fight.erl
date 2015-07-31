-module(lib_league_fight).

-include("define_league.hrl").
-include("define_info_40.hrl").
-include("define_player.hrl").
-include("define_money_cost.hrl").
-include("define_goods_type.hrl").
-include("define_logger.hrl").
-include("define_time.hrl").
-include_lib("stdlib/include/qlc.hrl").
-include("define_log_event.hrl").
-include("define_mnesia.hrl").
-include("define_reward.hrl").
-include("define_cross_league_fight.hrl").
-include("db_base_guild_rank_integral.hrl").
-include("define_mail.hrl").
-include("define_log.hrl").

-export([
         daily_reset_league_fight_job/0,
         daily_reset_league_fight_job/1,
         daily_start_arrange_fight_job/0,
         daily_start_arrange_fight_job/1,
         daily_league_fight_reward_job/0,
         daily_league_fight_reward_job/1,
         daily_start_fight_job/0,
         daily_start_fight_job/1,
         month_season_end/0,
         month_season_end/1,
         apply_for_fight/1,
         get_enemy_list/1,
         check_attack_enemy/2,
         handle_attack_member_result/4,
         get_point_list/1,
         get_defend_point_records/3,
         handle_attack_defend_point_result/4,
         check_attack_defne_point/3,
         get_defend_records/1,
         reset_point_defender/3,
         set_point_defender/3,
         check_attack_defend_point/2,
         get_vs_league_info/1,
         get_fight_member_list/1,
         get_rank_list/1,
         get_rank_list/4,
         get_rank_info/1,
         handle_fight_end/2,
         recount_group/1,
         reset_fight_league/1,
         fight_end_reward/1,
         get_fight_league/1,
         update_fight_league/1,
         get_apply_status/1,
         reset_rank_data/0,
         handle_lucky_guys/1,
         do_daily_reward/0,
         get_remain_challenge_num/1,
         reset_challenge_num/1,
         check_ability/2,
         %% get_league_status/1,
         %% get_fight_status_test/0,
         load_fight_members/1,
         check_leave_condition/1,
         backup_fight_league/0,
         get_fight_member/1,
         get_league_fight_status/1,
         get_record_count/1
        ]).

get_apply_status(LeagueId) ->
    case get_fight_league(LeagueId) of
        [] ->
            0;
        _->
            ?ALREADY_APPLY_FIGHT
    end.

%% get_league_fight_status(LeagueId) ->
%%     case get_fight_league(LeagueId) of
%%         [] ->
%%             ?FIGHT_STATUS_NOTJOIN;
%%         _ ->
%%             mod_cross_league_fight:get_fight_status()
%%     end.

month_season_end() ->
    Now = time_misc:unixtime(),
    month_season_end(Now).

month_season_end(Now) ->
    PassDays = time_misc:get_month_second_passed() div ?ONE_DAY_SECONDS + 1,
    if
        PassDays =/= 28 ->
            skip;
        true ->
            ?DEBUG("mod_league_count season_end ... "),
            mod_cross_league_fight:season_end(),
            hdb:dirty_write(server_config, #server_config{k = month_season_end,
                                                          v = Now})
    end.

daily_reset_league_fight_job() ->
    Now = time_misc:unixtime(),
    daily_reset_league_fight_job(Now).

daily_reset_league_fight_job(Now) ->    
    PassDays = time_misc:get_month_second_passed() div ?ONE_DAY_SECONDS + 1,
    if
        PassDays rem 2 =:= 1 ->
            skip;
        true ->
            mod_cross_league_fight:fight_end(),
            hdb:dirty_write(server_config, #server_config{k = daily_reset_league_fight_job,
                                                          v = Now})
    end.

daily_start_arrange_fight_job() ->
    Now = time_misc:unixtime(),
    daily_start_arrange_fight_job(Now).

daily_start_arrange_fight_job(Now) ->
    PassDays = time_misc:get_month_second_passed() div ?ONE_DAY_SECONDS + 1,
    if
        PassDays rem 2 =:= 0 orelse PassDays > 28 ->
            ?WARNING_MSG("daily_start_arrange_fight_job, skip ... "),
            skip;
        true ->
            mod_cross_league_fight:start_arrange_fight(),
            hdb:dirty_write(server_config, #server_config{k = daily_start_arrange_fight_job,
                                                          v = Now})
    end.

daily_league_fight_reward_job() ->
    Now = time_misc:unixtime(),
    daily_league_fight_reward_job(Now).

daily_league_fight_reward_job(Now) ->
    mod_cross_league_fight:daily_reward(),
    hdb:dirty_write(server_config, #server_config{k = daily_league_fight_reward_job,
                                                  v = Now}).

daily_start_fight_job() ->
    daily_start_fight_job(time_misc:unixtime()).

daily_start_fight_job(Now) ->
    PassDays = time_misc:get_month_second_passed() div ?ONE_DAY_SECONDS + 1,
    if
        PassDays rem 2 =:= 0 orelse PassDays > 28 ->
            ?WARNING_MSG("daily_start_fight_job, skip ... "),
            skip;
        true ->
            mod_cross_league_fight:set_fight_status(?FIGHT_STATUS_RUINNG),
            hdb:dirty_write(server_config, #server_config{k = daily_start_fight_job,
                                                          v = Now})
    end.

reset_rank_data() ->
    AllBucketList = 
        lists:map(fun(GroupNum) ->
                          DataList = get_rank_list(GroupNum),
                          lists:foldl(fun(#fight_league{rank = Rank} = FightLeague, AccBucket) ->
                                              bucket_misc:insert(Rank, FightLeague, AccBucket)
                                      end, bucket_misc:new(?SEND_LEAGUE_COUNT), DataList)
                  end, lists:seq(1, ?GROUP_MAX_NUM)),
    mod_league_rank:update_rank_data(AllBucketList).

get_rank_list(Group) ->
    FightLeagues = get_fight_league_by_group(Group),
    SortFun = fun(LA, LB) ->
                      LA#fight_league.rank < LB#fight_league.rank
              end,
    lists:sort(SortFun, FightLeagues).

get_rank_list(#player{sn = Sn}, LastRank, Type, Group) ->
    if
        Group < 0 orelse Group > ?GROUP_MAX_NUM ->
            {fail, ?INFO_LEAGUE_GROUP_ERROR};
        true ->
            mod_league_rank:get_rank_data(Sn, Group, LastRank, Type)
    end.

get_rank_info(#player{id = PlayerId}) ->
    case lib_league:get_league_member_by_id(PlayerId) of
        [] ->
            {fail, ?INFO_LEAGUE_NOT_MEMBER};
        #league_member{league_id = LeagueId} ->
            %case hdb:dirty_read(get_league_relation_table(Sn), LeagueId) of
            case get_fight_league(LeagueId) of
                [] ->
                    {fail, ?INFO_LEAGUE_FIGHT_NOT_RANK};
                #fight_league{
                   score = Score,
                   rank = Rank
                  } ->
                    {Score, Rank}
            end
    end.

apply_for_fight(#mod_player_state{
                   player = Player
                  }) ->
    #player{id = PlayerId, sn = PlayerSn} = Player,
    %case hdb:dirty_read(league_member, PlayerId) of
    case lib_league:get_league_member_by_id(PlayerId) of
        [] ->
            {fail, ?INFO_LEAGUE_NOT_MEMBER};
        #league_member{
           league_id = LeagueId,
           title = Title
          } ->
            case check_title(Title) of
                false ->
                    {fail, ?INFO_LEAGUE_NOT_ENOUGH_POWER};
                true ->
                    case get_fight_league(LeagueId) of
                        #fight_league{} ->
                            {fail, ?INFO_LEAGUE_ALREADY_APPLY};
                        [] ->                            
                            case lib_league:get_league_info(LeagueId, PlayerSn) of
                                [] ->
                                    {fail, ?INFO_CONF_ERR};
                                #league{
                                   cur_num = CurNum,
                                   max_num = MaxNum,
                                   name    = LeagueName,
                                   lv      = Lv,
                                   ability_sum = AbilitySum
                                  } -> 
                                    if
                                        CurNum < ?LEAGUE_APPLY_MEMBER_LIMIT ->
                                            {fail, ?INFO_LEAGUE_APPLY_MEMBER_NUM_LIMIT};
                                        true ->
                                            FightLeague = #fight_league{league_id       = LeagueId,
                                                                        sn              = PlayerSn,
                                                                        group           = ?GROUP_BRONZE,
                                                                        score           = 0, 
                                                                        league_name     = LeagueName,
                                                                        ability_sum     = AbilitySum,
                                                                        lv              = Lv,
                                                                        cur_num         = CurNum,
                                                                        max_num         = MaxNum, 
                                                                        defend_points   = [], %% ?POINT_MAX_NUM
                                                                        enemy_league_id = 0,
                                                                        enemy_league_sn = 0,
                                                                        %% 用时间戳做标识,  =:= 0 则本轮有战斗, >0 则本轮处于等待当中   
                                                                        apply_time      = time_misc:unixtime()
                                                                        %% rank 新需求, 暂时不做
                                                                       },
                                            update_fight_league(FightLeague),
                                            load_fight_members(LeagueId, Player)
                                    end
                            end 
                    end
            end
    end.

load_fight_members(LeagueId, #player{id = Id} = Player) ->
    LeagueMembers = lib_league:get_league_member_list(LeagueId),
    lists:map(fun(#league_member{player_id = PlayerId} = LeagueMember) ->
                      if
                          Id =:= PlayerId ->
                              ?DEBUG("Id: ~p", [Id]),
                              FightMember = to_fight_members(LeagueMember, Player),
                              update_fight_member(FightMember);
                          true -> 
                              case lib_player:get_other_player(PlayerId) of
                                  [] ->
                                      ignored;
                                  #player{} = NPlayer ->
                                      FightMember = to_fight_members(LeagueMember, NPlayer),
                                      update_fight_member(FightMember);
                                  Other ->
                                      ?WARNING_MSG("Other: ~p", [Other])
                              end
                      end
              end, LeagueMembers).

%% 加载所有的军团成员至挑战表 新增玩家需求另外加入
load_fight_members(LeagueId) when is_integer(LeagueId) ->
    LeagueMembers = lib_league:get_league_member_list(LeagueId),
    lists:map(fun(#league_member{player_id = PlayerId} = LeagueMember) ->
                      case lib_player:get_other_player(PlayerId) of
                          [] ->
                              ignored;
                          Player ->
                              FightMember = to_fight_members(LeagueMember, Player),
                              update_fight_member(FightMember)
                      end
              end, LeagueMembers);

%% 如果军团已参战则将刚加入的玩家加入军团战
load_fight_members(#player{id = Id} = Player) ->
    case get_fight_member(Id) of
        [] ->     
            case lib_league:get_league_member_by_id(Id) of
                #league_member{league_id = LeagueId
                              } = LeagueMember ->
                    case get_fight_league(LeagueId) of
                        [] ->
                            ignored;
                        _  ->           
                            FightMember = to_fight_members(LeagueMember, Player),
                            update_fight_member(FightMember)

                    end;
                _  ->
                    ignored
            end;  
        _ ->
            %{fail, ?INFO_LEAGUE_MEMBRE_HAVE_FIGHT_RECORD}
            ignored
    end.

to_fight_members(#league_member{
                    league_id = LeagueId,
                    player_id = PlayerId,
                    title = Title,
                    contribute = Con,
                    contribute_lv = ConLv
                   }, #player{
                         nickname = Nickname,
                         high_ability = MaxAbility,
                         lv       = Lv,
                         career   = Career,
                         battle_ability = BattleAbility
                        }) ->
    ?WARNING_MSG("MaxAbility: ~p, battle_ability: ~p", [MaxAbility, BattleAbility]),
    #fight_member{player_id   = PlayerId,
                  player_name = Nickname,
                  player_lv   = Lv,
                  player_title = Title,
                  player_career = Career,
                  contribute = Con,
                  contribute_lv = ConLv,
                  league_id   = LeagueId,
                  ability     = MaxAbility,
                  fight_times = ?DEAFAULT_FIGHT_TIMES,
                  atk_point_times = 0,
                  things      = 0,
                  def_records = [],
                  atk_records = []
                 }.

    %% 自动安排防御人员
auto_arrange_defender(LeagueId) ->
    Members = get_fight_member_list(LeagueId),
    SortFun = fun(MemberA, MemberB) ->
                      MemberA#fight_member.ability >= MemberB#fight_member.ability
              end,
    SortedMember = lists:sort(SortFun, Members),
    %% SortedPlayers = lists:sort(SortFun, Players),
    Len = length(SortedMember),
    GetDefenders = fun(Ps, Pos) ->
                           if
                               Len >= Pos * 2 ->
                                   [lists:nth(Pos * 2 - 1, Ps), lists:nth(Pos * 2, Ps)];
                               Len < Pos * 2 andalso Len >= (Pos*2 -1) ->
                                   [lists:nth(Pos * 2 - 1, Ps)];
                               true -> 
                                   []
                           end
                   end,
    DefendPoints = lists:map(fun(Pos) ->
                                     DefendMembers = GetDefenders(SortedMember, Pos),
                                     Defenders = lists:map(fun(M) ->
                                                                   {M#fight_member.player_name, M#fight_member.player_id}
                                                           end, DefendMembers),
                                     #defend_point{
                                        id = Pos,
                                        pos = Pos,
                                        league_id = LeagueId,
                                        defenders = Defenders,
                                        occupyers = [],
                                        records   = [],
                                        status    = ?DEFEND_POINT_STATUS_NORMAL
                                       }
                             end, lists:seq(1, ?POINT_MAX_NUM)),
    case get_fight_league(LeagueId) of
        [] ->
            ignored;
        #fight_league{
          } = FightLeague ->
            update_fight_league(FightLeague#fight_league{defend_points = DefendPoints
                                                        })
    end,
    ok.



check_title(?LEAGUE_TITLE_BOSS) ->
    true;
check_title(?LEAGUE_TITLE_DEPUTY_BOSS) ->
    true;
check_title(_) ->
    false.

get_defend_records(PlayerId) ->
    case get_fight_member(PlayerId) of
        [] ->
            {fail, ?INFO_LEAGUE_BAD_ENEMY};
        #fight_member{
           def_records = DefendRecords
          } ->
            DefendRecords
    end.



%% 获取可挑战的对手列表
get_enemy_list(#player{id = PlayerId}) ->
    case get_fight_member(PlayerId) of
        [] ->
            %% 军团未参战
            {fail, ?INFO_LEAGUE_NOT_APPLY};
        #fight_member{league_id = LeagueId} ->
            case get_fight_league(LeagueId) of
                [] ->
                    %% 未报名参加本赛季
                    {fail, ?INFO_LEAGUE_NOT_APPLY};
                #fight_league{enemy_league_id = 0} ->
                    {fail, ?INFO_LEAGUE_NOT_ENEMY};
                #fight_league{enemy_league_id = EnemyLeagueId} ->
                    ?DEBUG("LeagueId: ~p EnemyLeagueId: ~p", [LeagueId, EnemyLeagueId]),
                    get_fight_member_list(EnemyLeagueId)
            end
    end.



%%
%% 检查相关挑战条件
%% 
check_attack_enemy(#player{id = PlayerId} = _Player, EnemyPlayerId) ->
    ?DEBUG("AtkId:~p, DefId:~p~n",[PlayerId, EnemyPlayerId]),
    IsAtkFlag = check_challenge_time(),
    if
        IsAtkFlag =:= false ->
            {fail, ?INFO_LEAGUE_FIGHT_NOT_START};
        true ->
            case get_fight_member(PlayerId) of
                [] ->
                    ?DEBUG("Attacker not found. PlayerId:~w~n",[PlayerId]),
                    {fail, ?INFO_LEAGUE_NOT_APPLY};
                #fight_member{fight_times = Times} 
                  when Times =< 0 ->
                    %% 挑战次数已用完
                    {fail, ?INFO_LEAGUE_CHALLENGE_TIMES_LIMIT};
                #fight_member{
                   league_id = LeagueId
                  } = AtkMember ->
                    case get_fight_member(EnemyPlayerId) of
                        [] ->
                            ?DEBUG("Defender not found. PlayerId:~w~n",[EnemyPlayerId]),
                            {fail, ?INFO_LEAGUE_NOT_ENEMY};
                        #fight_member{def_records = Records} 
                          when length(Records) >= ?MAX_ATKED_TIMES->
                            {fail, ?INFO_LEAGUE_ENEMY_GRAP_NUM_LIMIT};
                        #fight_member{
                           league_id = EnemyLeagueId,
                           def_records = Records
                          } = DefMember  ->
                            ?DEBUG("EnemyLeagueId:~p~n", [EnemyLeagueId]),
                            case get_fight_league(LeagueId) of
                                #fight_league{
                                   enemy_league_id = EnemyLeagueId
                                  } ->
                                    case lists:keyfind(PlayerId, #fight_record.atk_id, Records) of
                                        false ->
                                            {ok, LeagueId, AtkMember, EnemyLeagueId, DefMember};
                                        _ ->
                                            {fail, ?INFO_NOT_REPEAT_CHALLENGE_ENEMY}
                                    end;
                                _Other ->
                                    ?DEBUG("AtkLeague : ~p~n", [_Other]),
                                    {fail, ?INFO_CHALLENGE_ERROR_MEMBER}
                            end
                    end   
            end
    end.
%% 
%% 客户端战斗结果进行结算处理
%% 挑战对方军团成员 结果处理
%% 
handle_attack_member_result(ModPlayerState, EnemyId, Result, Energy) ->
    %% Player = #player{
    %%             id = PlayerId,
    %%             high_ability = Ability,
    %%             nickname = Nickname
    %%            } = ModPlayerState?PLAYER, 
    
    case check_attack_enemy(ModPlayerState?PLAYER, EnemyId) of
        {ok, AtkLeagueId, #fight_member{
                             ability = Ability,
                             player_name = Nickname,
                             player_id   = PlayerId
                            } = AtkMember, _DefLeagueId, DefMember} ->
            AtkLeague = get_fight_league(AtkLeagueId),
            ThingReward = get_reward(Result, Ability, DefMember#fight_member.ability, Energy),
            %CombatPointReward = get_combat_point_reward(Result),
            NewAtkLeague = AtkLeague#fight_league{things = AtkLeague#fight_league.things + ThingReward},
            Record = #fight_record{atk_id    = PlayerId,
                                   atk_name  = Nickname,
                                   def_id    = EnemyId,
                                   def_name  = DefMember#fight_member.player_name,
                                   result    = Result,
                                   timestamp = time_misc:unixtime(),
                                   things    = ThingReward
                                  },
            NewDefMember = DefMember#fight_member{
                             def_records = [Record|DefMember#fight_member.def_records]
                            },
            NewAtkMember = AtkMember#fight_member{
                             fight_times = AtkMember#fight_member.fight_times - 1,
                             things      = AtkMember#fight_member.things + ThingReward,
                             atk_records = [Record|AtkMember#fight_member.atk_records]
                            },
            update_fight_league(NewAtkLeague),
            update_fight_member(NewAtkMember),
            update_fight_member(NewDefMember),
            
            lib_log_player:log_system({PlayerId, ?LOG_CROSS_LEAGUE_FIGHT, 1, 0, Result}),
            Rewards = case Result of
                          ?LEAGUE_CHALLENGE_WIN ->
                              EquipRewards = get_equip_rewards(),
                              [EquipRewards ++ {?AEROLITE_ID, 2}, {?GOODS_TYPE_LEAGUE_SEAL, ThingReward}] ++ lib_reward:get_pvp_rewards(league_pvp_sigle, win);
                          _ ->
                              [{?GOODS_TYPE_LEAGUE_SEAL, ThingReward}] ++ lib_reward:get_pvp_rewards(league_pvp_sigle, loss)
                      end,
            lib_reward:take_reward(ModPlayerState, Rewards, ?LOG_EVENT_ADD_LEAGUE_SEAL, ?REWARD_TYPE_CROSS_LEAGUE);
        {fail, Reason} ->
            {fail, Reason}
    end.


%% 获取挑战方与被挑战方的据点列表与信息
get_point_list(AtkPlayerId) ->
    case check_attack_and_defend(AtkPlayerId) of
        {fail, Error} ->
            {fail, Error};
        {ok,
         #fight_league{defend_points = AtkPoints} = _AtkLeague, 
         _AtkMember, 
         #fight_league{defend_points = DefPoints} = _DefLeague} ->
            {ok, AtkPoints, DefPoints}
    end.

%% 检查是否可以挑战该军团
check_attack_and_defend(AtkPlayerId) ->
    case get_fight_member(AtkPlayerId) of
        [] ->
            {fail, ?INFO_LEAGUE_NOT_JOINT_FIGHT};
        #fight_member{
           league_id = AtkLeagueId
          } = AtkMember ->
            case get_fight_league(AtkLeagueId) of
                [] ->
                    {fail, ?INFO_LEAGUE_NOT_JOINT_FIGHT};
                #fight_league{
                   enemy_league_id = DefLeagueId
                  } = AtkLeague ->
                    case get_fight_league(DefLeagueId) of
                        [] ->
                            ?WARNING_MSG("EnemyLeague not found Id : ~p~n",[DefLeagueId]),
                            {fail, ?INFO_LEAGUE_ENEMY_NOT_JOIN};
                        #fight_league{
                          } = DefLeague ->
                            {ok, AtkLeague, AtkMember, DefLeague}
                    end;
                _  ->
                    {fail, ?INFO_LEAGUE_BAD_ENEMY}
            end
    end.


%% 处理据点挑战结果
handle_attack_defend_point_result(ModPlayerState, PointId, Result, Energy) ->
    case check_attack_defne_point(ModPlayerState?PLAYER_ID, PointId, ?DEFEND_POINT_STATUS_ATKING) of
        {ok, AtkLeague, AtkMember, DefLeague, #defend_point{
                                                } = DefendPoint} ->
            ThingReward = get_point_thing_reward(Result, Energy),                      
            ?WARNING_MSG("Result: ~p", [Result]),
            Record = #fight_record{atk_id = ModPlayerState?PLAYER_ID,
                                   atk_name = ModPlayerState?PLAYER_NAME,
                                   result = Result,
                                   things  = ThingReward,
                                   timestamp = hmisctime:unixtime()
                                  },
            NewDefendPoint = if
                                 Result =:= ?LEAGUE_CHALLENGE_WIN -> 
                                     DefendPoint#defend_point{
                                       status = ?DEFEND_POINT_STATUS_OCCUPY,
                                       attacker = 0,
                                       atk_timestamp = 0,
                                       occupyers = [{ModPlayerState?PLAYER_NAME, ModPlayerState?PLAYER_ID}| DefendPoint#defend_point.occupyers],
                                       records = [Record|DefendPoint#defend_point.records]
                                      };
                                 true ->
                                     %% RESET STATUS
                                     DefendPoint#defend_point{
                                       status = ?DEFEND_POINT_STATUS_NORMAL,
                                       attacker = 0,
                                       atk_timestamp = 0,
                                       records = [Record|DefendPoint#defend_point.records]
                                      }
                             end,
            NewDefendPoints = lists:keyreplace(PointId, #defend_point.id, DefLeague#fight_league.defend_points, NewDefendPoint),
            NewDefLeague = DefLeague#fight_league{
                             defend_points = NewDefendPoints
                            },
            NewOccupyTimes = case Result of
                                 ?LEAGUE_CHALLENGE_WIN ->
                                     AtkLeague#fight_league.occupy_points + 1;
                                 _ ->
                                     AtkLeague#fight_league.occupy_points
                             end,

            NewAtkLeague = AtkLeague#fight_league{
                             occupy_points = NewOccupyTimes,
                             things = ThingReward+ AtkLeague#fight_league.things
                            },
            NewAtkMember = AtkMember#fight_member{
                             fight_times = AtkMember#fight_member.fight_times - ?CHALLENGE_POINT_USE_NUM,
                             things      = ThingReward + AtkMember#fight_member.things,
                             atk_point_times = AtkMember#fight_member.atk_point_times + 1,
                             atk_records = [Record|AtkMember#fight_member.atk_records]
                            },
            update_fight_league(NewDefLeague),
            update_fight_league(NewAtkLeague),
            update_fight_member(NewAtkMember),    

            lib_log_player:log_system({ModPlayerState?PLAYER_ID, ?LOG_CROSS_LEAGUE_POINT, 1, 1, Result}),
            Rewards = case Result of
                          ?LEAGUE_CHALLENGE_WIN ->
                              EquipRewards = get_equip_rewards(),
                              [{?AEROLITE_ID, 4}, EquipRewards ++ {?GOODS_TYPE_LEAGUE_SEAL, ThingReward}] ++ lib_reward:get_pvp_rewards(league_pvp_point, win);
                          _ ->
                              [{?GOODS_TYPE_LEAGUE_SEAL, ThingReward}] ++ lib_reward:get_pvp_rewards(league_pvp_point, loss)
                      end,
            {ok, NewModPlayerState} = 
                lib_reward:take_reward(ModPlayerState, Rewards, ?LOG_EVENT_ADD_LEAGUE_SEAL, ?REWARD_TYPE_CROSS_LEAGUE),
            {ok, NewModPlayerState, AtkLeague#fight_league.defend_points ++ NewDefendPoints};
        {fail, Error} ->
            {fail, Error}
    end.

get_point_thing_reward(Result, Energy) ->
    if 
        Result =:= ?LEAGUE_CHALLENGE_FAIL ->
            ?LEAGUE_THING * get_fail_reward() div 10;
        true ->
            ?LEAGUE_THING * get_win_reward(Energy) div 10
    end.

%% 检查据点是否可挑战 如果可挑战直接将状态设置为 交战中    
check_attack_defend_point(PlayerId, PointId) ->
    case check_attack_defne_point(PlayerId, PointId, ?DEFEND_POINT_STATUS_NORMAL) of
        {ok, _AtkLeague, #fight_member{
                           fight_times = FightTimes,
                           atk_point_times = AtkPointTimes
                          } = _AtkMember, DefLeague, #defend_point{
                                                       records = Records
                                                      } = Point} ->
            IsAtkFlag = check_challenge_time(),
            if
                IsAtkFlag =:= false ->
                    {fail, ?INFO_LEAGUE_FIGHT_NOT_START};
                FightTimes < ?CHALLENGE_POINT_USE_NUM ->
                    {fail, ?INFO_MEMBRE_CHALLENGE_NUM_LIMIT};
                AtkPointTimes >= ?MAX_ATTACK_POINT_TIMES -> 
                    {fail, ?INFO_CHALLENGE_POINT_NUM_LIMIT};
                length(Records) >= ?POINT_CHALLENGE_MAX_NUM ->
                    {fail, ?INFO_CHALLENGE_POINT_NUM_LIMIT};
                true -> 
                    %% 
                    case check_member_ability_rank(PlayerId) of
                        {fail, Error} ->
                            {fail, Error};
                        {ok, _FightMember}->
                            %% 设置据点为挑战中状态
                            NewPoint = Point#defend_point{status = ?DEFEND_POINT_STATUS_ATKING,
                                                          attacker = PlayerId,
                                                          atk_timestamp = time_misc:unixtime()
                                                         },
                            NewPointList = lists:keyreplace(PointId, #defend_point.id, DefLeague#fight_league.defend_points, NewPoint),
                            NewDefLeague = DefLeague#fight_league{
                                             defend_points = NewPointList
                                            },
                            update_fight_league(NewDefLeague),
                            ok
                    end
            end;
        {fail, Error} ->
            {fail, Error}
    end.

check_challenge_time() ->
    %% Now = time_misc:unixtime(),
    %% case get_fight_status(Now) of
    %%     {?IN_FIGHT_STATUS, _} ->
    %%         true;
    %%     _ ->
    %%         false
    %% end.
    case mod_cross_league_fight:get_fight_status() of
        ?FIGHT_STATUS_RUINNG ->
            true;
        _ ->
            false
    end.


check_attack_defne_point(PlayerId, PointId, ?DEFEND_POINT_STATUS_ATKING) ->
    case check_attack_and_defend(PlayerId) of
        {ok, AtkLeague, AtkMember, DefLeague} ->
            Now = time_misc:unixtime(),
            case lists:keyfind(PointId, #defend_point.id, DefLeague#fight_league.defend_points) of
                false ->
                    {fail, ?INFO_LEAGUE_DEFEND_POINT_NOT_FOUND};
                #defend_point{
                   status = ?DEFEND_POINT_STATUS_ATKING,
                   atk_timestamp = Timestatmp,
                   attacker = PlayerId
                  } = Point when Timestatmp + ?ELEVEN_MINITE_SECONDS > Now ->
                    {ok, AtkLeague, AtkMember, DefLeague, Point};
                Other ->
                    ?DEBUG("Other: ~p", [Other]),
                    {fail, ?INFO_CHALLENGE_POINT_OVER_TIME}
            end;
        {fail, Error}->
            {fail, Error}
    end;

check_attack_defne_point(PlayerId, PointId, NeedStatus) ->
    case check_attack_and_defend(PlayerId) of
        {ok, AtkLeague, AtkMember, DefLeague} ->
            Now = time_misc:unixtime(),
            case lists:keyfind(PointId, #defend_point.id, DefLeague#fight_league.defend_points) of
                false ->
                    {fail, ?INFO_LEAGUE_DEFEND_POINT_NOT_FOUND};
                #defend_point{
                   status = Status,
                   atk_timestamp = Timestatmp
                  } = Point when ((Status =:= NeedStatus) 
                                  orelse 
                                  %% 处理挑战超时
                                    (Status =:= ?DEFEND_POINT_STATUS_ATKING andalso 
                                     NeedStatus =:= ?DEFEND_POINT_STATUS_NORMAL andalso
                                     Timestatmp + ?ELEVEN_MINITE_SECONDS > Now
                                    ))->
                    {ok, AtkLeague, AtkMember, DefLeague, Point};
                _->
                    {fail, ?INFO_LEAGUE_DEFEND_POINT_STATUS_ERROR}
            end;
        {fail, Error}->
            {fail, Error}
    end.

%% get_combat_point_reward(Result) ->
%%     if
%%         Result =:= ?LEAGUE_CHALLENGE_FAIL ->
%%             20;
%%         true ->
%%             50
%%     end.

get_reward(Result, Ability, EnemyAbility, Energy) ->
    case check_ability(Ability, EnemyAbility) of
        false ->
            if
                Result =:= ?LEAGUE_CHALLENGE_FAIL ->
                    ?LEAGUE_THING * get_fail_reward() div 10;
                true ->
                    ?LEAGUE_THING 
            end;
        true ->
            if
                Result =:= ?LEAGUE_CHALLENGE_FAIL ->
                    ?LEAGUE_THING * get_fail_reward() div 10;
                true ->
                    ?LEAGUE_THING * get_win_reward(Energy) div 10
            end
    end.

check_ability(Ability, EnemyAbility) ->
    Ability * 80 =< EnemyAbility * 100.

get_fail_reward() -> 
    3.
get_win_reward(Energy) when Energy =:= 100 ->
    20;
get_win_reward(Energy) when 80 =< Energy andalso Energy < 100 ->
    18;
get_win_reward(Energy) when 50 =< Energy andalso Energy < 80 ->
    15;
get_win_reward(Energy) when 20 =< Energy andalso Energy < 50 ->
    12;
get_win_reward(Energy) when 0 =< Energy andalso Energy < 20 ->
    10;
get_win_reward(Energy) ->
    ?WARNING_MSG("Energy: ~p", [Energy]),
    0.

get_defend_ids(Points) ->
    lists:foldl(fun(#defend_point{
                       defenders = Defs 
                      }, Ret) ->
                        case Defs of
                            [] ->
                                Ret;
                            [{_N, ID}] ->
                                [ID|Ret];
                            [{_N1, ID1},{_N2, ID2}] ->
                                [ID1,ID2|Ret]
                        end
                end,[] ,Points).

set_point_defender(Player, PointId, Id) ->
    IsAtkFlag = check_challenge_time(),
    if
        IsAtkFlag =:= true ->
            {fail, ?INFO_LEAGUE_FIGHT_START};
        true ->
            case check_attack_and_defend(Player#player.id) of
                {fail, Error} ->
                    {fail, Error};
                {ok, AtkLeague, #fight_member{player_title = Title} = _AtkMember, DefLeague} when Title =:= ?LEAGUE_TITLE_BOSS->
                    Points = AtkLeague#fight_league.defend_points,
                    case lists:keyfind(PointId, #defend_point.id, Points) of
                        false ->
                            {fail, ?INFO_LEAGUE_NOT_POINT};
                        #defend_point{
                           defenders = Defenders
                          } = Point when length(Defenders) < ?LEAGUE_MAX_DEFENDER ->
                            DefenderIds = get_defend_ids(Points),
                            case lists:member(Id, DefenderIds) of
                                false ->
                                    case get_fight_member(Id) of
                                        [] ->
                                            {fail, ?INFO_LEAGUE_NOT_MEMBER};
                                        #fight_member{player_name = Name} ->
                                            NewDefender = [{Name, Id}|Defenders],
                                            NewPoint = Point#defend_point{defenders = NewDefender
                                                                         },
                                            NewPointList = lists:keyreplace(PointId, #defend_point.id, Points, NewPoint),
                                            NewAtkLeague = AtkLeague#fight_league{defend_points = NewPointList
                                                                                 },
                                            update_fight_league(NewAtkLeague),
                                            {ok, NewPointList, DefLeague#fight_league.defend_points}
                                    end;
                                _ ->
                                    {fail, ?INFO_LEAGUE_APPOINT_ERROR}
                            end;
                        _  ->
                            {fail, ?INFO_LEAGUE_APPOINT_ERROR}
                    end;
                _  ->
                    {fail, ?INFO_LEAGUE_NOT_ENOUGH_POWER}
            end
    end.


reset_point_defender(Player, PointId, Id) ->    
    IsAtkFlag = check_challenge_time(),
    if
        IsAtkFlag =:= true ->
            {fail, ?INFO_LEAGUE_FIGHT_START};
        true ->
            case check_attack_and_defend(Player#player.id) of
                {fail, Error} ->
                    {fail, Error};
                {ok, AtkLeague, #fight_member{player_title = Title}, DefLeague} when Title =:= ?LEAGUE_TITLE_BOSS ->
                    Points = AtkLeague#fight_league.defend_points,
                    case lists:keyfind(PointId, #defend_point.id, Points) of
                        false ->
                            {fail, ?INFO_LEAGUE_NOT_POINT};
                        #defend_point{
                           defenders = Defenders
                          } = Point ->
                            case lists:keytake(Id, 2,Defenders) of
                                false ->
                                    {fail, ?INFO_LEAGUE_APPOINT_ERROR};
                                {value, {_Name, Id}, RestDefenders} ->
                                    NewPoint = Point#defend_point{defenders = RestDefenders
                                                                 },
                                    NewPointList = lists:keyreplace(PointId, #defend_point.id, Points, NewPoint),
                                    NewAtkLeague = AtkLeague#fight_league{defend_points = NewPointList
                                                                         },
                                    update_fight_league(NewAtkLeague),
                                    {ok, NewPointList, DefLeague#fight_league.defend_points}
                            end;
                        _ ->
                            {fail, ?INFO_LEAGUE_APPOINT_ERROR}
                    end;
                _ ->
                    {fail, ?INFO_LEAGUE_NOT_ENOUGH_POWER}
            end
    end.

get_defend_point_records(Player, LeagueId, PointId) ->
    case check_attack_and_defend(Player#player.id) of
        {fail, Error} ->
            {fail, Error};
        {ok, AtkLeague, _AtkMember, DefLeague}->
            if
                LeagueId =:= AtkLeague#fight_league.league_id ->
                    get_defend_point_records(AtkLeague, PointId);
                true ->
                    get_defend_point_records(DefLeague, PointId)
            end
    end.

get_defend_point_records(AtkLeague, PointId) ->
    case lists:keyfind(PointId, #defend_point.id, AtkLeague#fight_league.defend_points) of
        false ->
            {fail, ?INFO_LEAGUE_NOT_POINT};
        #defend_point{
           records = Records
          } = _DefendPoint ->
            {ok, Records}
    end.


%% 检查玩家战力是否在前10名
check_member_ability_rank(PlayerId) ->
    case get_fight_member(PlayerId) of
        [] ->
            {fail, ?INFO_LEAGUE_NOT_MEMBER};
        #fight_member{league_id = LeagueId} = FightMember ->
            AllMember = get_fight_member_list(LeagueId),
            SortFun = fun(MemberA, MemberB) ->
                              MemberA#fight_member.ability >= MemberB#fight_member.ability
                      end,
            SortedMember = lists:sort(SortFun, AllMember),
            case list_misc:keyfind_nth(PlayerId, SortedMember, #fight_member.player_id) of
                0 ->
                    {fail, ?INFO_LEAGUE_NOT_MEMBER};
                Nth when Nth =< ?LEAGUE_CHALLENGE_ABILITY_RANK ->
                    {ok, FightMember};
                _  ->
                    {fail, ?INFO_LEAGUE_ABILITY_ENOUGH}
            end
    end.

get_vs_league_info(#player{id = PlayerId} = _Player) ->
    case check_attack_and_defend(PlayerId) of
        {ok, AtkLeague, AtkMember, DefLeague} ->
            {ok, AtkLeague, AtkMember, DefLeague};
        {fail, _} = Error ->
            Error
    end.


handle_fight_end(#fight_league{things          = AtkThings,
                               win_cnt         = AtkWinCnt,
                               loss_cnt        = AtkLossCnt,
                               ability_sum     = AtkAbilitySum,
                               occupy_points   = AtkOccupyPoints,
                               %% enemy_league_id = EnemyLeagueId,
                               score           = AtkScore
                              } = AtkLeague,  
                 #fight_league{things          = DefThings,
                               win_cnt         = DefWinCnt,
                               loss_cnt        = DefLossCnt,
                               ability_sum     = DefAbilitySum,
                               occupy_points   = DefOccupyPoints,
                               score           = DefScore
                              } = DefLeague) ->
    NewAtkThings = count_things(AtkThings, AtkOccupyPoints),
    NewDefThings = count_things(DefThings, DefOccupyPoints),
    if
        NewAtkThings =:= NewDefThings andalso NewAtkThings =:= 0 ->
            NewAtkScore = max(0, AtkScore - get_loss_score(AtkWinCnt)),
            NewDefScore = max(0, DefScore - get_loss_score(DefLossCnt)),
            NewAtkGroup = get_group_by_score(NewAtkScore),
            NewDefGroup = get_group_by_score(NewDefScore),
            {
              AtkLeague#fight_league{things   = NewAtkThings,
                                     win_cnt  = 0,
                                     loss_cnt = AtkLossCnt + 1,
                                     score    = NewAtkScore,
                                     group    = NewAtkGroup
               },
              DefLeague#fight_league{things   = NewDefThings,
                                     win_cnt  = 0,
                                     loss_cnt = DefLossCnt + 1,
                                     score    = NewDefScore,
                                     group    = NewDefGroup
               }
            };
        (NewAtkThings > NewDefThings) orelse
        (NewAtkThings =:= NewDefThings 
         andalso 
         AtkAbilitySum < DefAbilitySum) ->
            %% Attacker Win
            NewAtkScore = max(0, AtkScore + get_win_score(AtkWinCnt)),
            NewDefScore = max(0, DefScore - get_loss_score(DefLossCnt)),
            NewAtkGroup = get_group_by_score(NewAtkScore),
            NewDefGroup = get_group_by_score(NewDefScore),
            {
              AtkLeague#fight_league{things   = NewAtkThings,
                                     win_cnt  = AtkWinCnt + 1,
                                     loss_cnt = 0,
                                     score    = NewAtkScore,
                                     group    = NewAtkGroup
               },
              DefLeague#fight_league{things   = NewDefThings,
                                     win_cnt  = 0,
                                     loss_cnt = DefLossCnt + 1,
                                     score    = NewDefScore,
                                     group    = NewDefGroup
               }
            };
        true  ->
            %% Attacker Loss
            NewAtkScore = max(0, AtkScore - get_loss_score(AtkLossCnt)),
            NewDefScore = max(0, DefScore + get_win_score(DefWinCnt)),
            NewAtkGroup = get_group_by_score(NewAtkScore),
            NewDefGroup = get_group_by_score(NewDefScore),
            {
              AtkLeague#fight_league{things   = NewAtkThings,
                                     win_cnt  = 0,
                                     loss_cnt = AtkLossCnt + 1,
                                     score    = NewAtkScore,
                                     group    = NewAtkGroup
                                    },
              DefLeague#fight_league{things   = NewDefThings,
                                     win_cnt  = DefWinCnt + 1,
                                     loss_cnt = 0,
                                     score    = NewDefScore,
                                     group    = NewDefGroup
                                    }
            }
    end.

%% 轮空处理
handle_lucky_guys(#fight_league{win_cnt         = AtkWinCnt,
                                score           = AtkScore,
                                apply_time      = ApplyTime
                               } = AtkLeague) ->
    case time_misc:is_same_day(ApplyTime, time_misc:unixtime()) of
        true ->
            AtkLeague;
        false ->
            NewAtkScore = max(0, AtkScore + get_win_score(AtkWinCnt)),
            NewAtkGroup = get_group_by_score(NewAtkScore),
            %% 轮空的处理
            AtkLeague#fight_league{things   = 0,
                                   group    = NewAtkGroup,
                                   score    = NewAtkScore,
                                   win_cnt  = AtkWinCnt + 1,
                                   loss_cnt = 0
                                  }
    end.
count_things(Things, OccupyPoints) ->
    hmisc:floor(Things * (1 + OccupyPoints/10)).

get_win_score(WinCnt) ->
    StdScore = ?FIGHT_WIN_INTEGRAL,
    MaxContinueWinScore = ?TEN_FIGHT_SUCCESS,
    ContinueWinScore = 
        if
            WinCnt > 1 -> 
                WinCnt;
            true -> 
                0
        end,
    StdScore + min(MaxContinueWinScore, ContinueWinScore).

get_loss_score(LossCnt) ->
    StkScore = ?FIGHT_FAIL_INTEGRAL,
    MinContinueLossScore = ?FIVE_FIGHT_FAIL,
    ContinueLossScore = 
        if
            LossCnt > 1 ->
                LossCnt;
            true -> 
                0
        end,    
    StkScore + min(MinContinueLossScore, ContinueLossScore).

recount_group(#fight_league{
                 score = Score,
                 group = Group
                } = FightLeague) ->
    case get_group_by_score(Score) of
        Group ->
            %% DO NOTHING
            ok;
        NewGroup ->
            NewFightLeague = FightLeague#fight_league{group = NewGroup
                                                     },
            update_fight_league(NewFightLeague)
    end,
    ok.

get_group_by_score(Score) ->
    Ids = data_base_guild_rank_integral:all(),
    get_group_by_score(Score, Ids, 0).

get_group_by_score(_Score, [], HitGroup) ->
    HitGroup;
get_group_by_score(Score, [Group|Groups], _HitGroup) ->
    case data_base_guild_rank_integral:get(Group) of
        [] ->
            0;
        #base_guild_rank_integral{
           rank_score = RankScore
          } ->
            if
                RankScore > Score -> 
                    Group - 1;
                true -> 
                    get_group_by_score(Score, Groups, Group)
            end
    end.


    


get_fight_member_list(LeagueId) ->
    hdb:dirty_index_read(fight_member, LeagueId, #fight_member.league_id, true).

get_fight_member(PlayerId) ->
    hdb:dirty_read(fight_member, PlayerId).

get_fight_league(LeagueId) ->
    hdb:dirty_read(fight_league, LeagueId).

update_fight_league(FightLeague) ->
    hdb:dirty_write(fight_league, FightLeague).

update_fight_member(FightMember) ->
    hdb:dirty_write(fight_member, FightMember).

get_fight_league_by_group(Group) ->
    hdb:dirty_index_read(fight_league, Group, #fight_league.group, true).

reset_fight_league(#fight_league{sn = Sn, league_id = LeagueId} = FightLeague) ->
    case lib_league:get_league_info(LeagueId, Sn) of
        [] ->
            ?WARNING_MSG("LeagueNotfound : Sn ~p LeagueId: ~p~n",[Sn,LeagueId]),
            {fail, ?INFO_CONF_ERR};
        #league{
           cur_num = CurNum,
           max_num = MaxNum,
           %% name    = LeagueName,
           lv      = Lv,
           ability_sum = AbilitySum
          } -> 
            NewFightLeague = FightLeague#fight_league{
                               things          = 0,
                               ability_sum     = AbilitySum,
                               lv              = Lv,
                               cur_num         = CurNum,
                               max_num         = MaxNum,
                               defend_points   = [],
                               occupy_points   = 0,
                               enemy_league_id = 0,
                               enemy_league_name = "",
                               enemy_league_sn = 0,
                               apply_time = 0
                              },
            update_fight_league(NewFightLeague),
            load_fight_members(LeagueId),
            auto_arrange_defender(LeagueId)
    end.

fight_end_reward(#fight_league{league_id = LeagueId,
                               sn        = Sn,
                               things    = Things,
                               group     = Group,
                               win_cnt   = WinCnt,
                               apply_time = ApplyTime
                              } = FightLeague) ->
    AllExp = data_base_guild_lv_exp:get_all_exp(),
    case lib_league:get_league_info(LeagueId, Sn) of
        [] ->
            ?WARNING_MSG("LeagueInfo Not found!!! LeagueId : ~p~n",[LeagueId]),
            ignored;
        #league{league_exp = Exp} = League ->
            NewExp = Exp + Things,   %% 经验值与公会物资数值相等 1:1
            NewLeague = League#league{
                          league_exp = NewExp,
                          lv = count_league_lv(NewExp, AllExp),
                          league_group = Group
                         },
            lib_league:update_league(NewLeague, Sn),
            case time_misc:is_same_day(time_misc:unixtime(), ApplyTime) of
                true ->
                    skip;
                false ->
                    send_fight_win_reward(FightLeague, WinCnt)
            end
    end.

%% 轮空
send_fight_win_reward(#fight_league{
                         league_id = LeagueId,
                         enemy_league_id = EnemyLeagueId
                        }, _WinCnt) 
  when EnemyLeagueId =:= 0 ->
    ?WARNING_MSG("LeagueId: ~p", [LeagueId]),
    Title = 
        unicode:characters_to_binary("军团掠夺战奖励"),
    Content1 = 
        unicode:characters_to_binary("本轮军团掠夺战轮空, 恭喜贵军团获得幸运轮空胜利!"), 
    Content2 = 
        unicode:characters_to_binary(lists:concat(["你获得了", ?LEAGUE_REWARD_THING, "军团印章奖励"])),
    Content = 
        <<Content1/binary, Content2/binary>>,
    AllFightMember = lib_league:get_league_member_list(LeagueId),
    lists:map(fun(#league_member{player_id = Id}) ->
                      Mail = lib_mail:mail(?SYSTEM_NAME, Title, Content, [{?GOODS_TYPE_LEAGUE_SEAL, ?LEAGUE_REWARD_THING}]),
                      lib_mail:send_mail(Id, Mail)
              end, AllFightMember);

%% 战败
send_fight_win_reward(#fight_league{league_id = LeagueId}, WinCnt) when WinCnt =:= 0 ->
    Title = 
        unicode:characters_to_binary("军团掠夺战"),
    Content = 
        unicode:characters_to_binary("本轮军团掠夺战失败!"), 
    Mail = lib_mail:mail(?SYSTEM_NAME, Title, Content, []),
    AllFightMember = lib_league:get_league_member_list(LeagueId),
    lists:map(fun(#league_member{player_id = Id}) ->
                      lib_mail:send_mail(Id, Mail)
              end, AllFightMember);

%% 战胜
send_fight_win_reward(#fight_league{
                         league_id = LeagueId,
                         things = Things,
                         enemy_league_name = EnemyLeagueName                         
                        }, _WinCnt) ->
    ?WARNING_MSG("LeagueId win: ~p", [LeagueId]),
    %% 胜利战报邮件
    Title   = unicode:characters_to_binary("军团掠夺战奖励"),
    Content1 = unicode:characters_to_binary("你的军团在与"),
    Content2 = unicode:characters_to_binary(lists:concat(["战斗中, 你们获得了", Things, "军团物资, 已经转化为军团经验!"])),
    Content3 = unicode:characters_to_binary(lists:concat(["恭喜你获得额外奖励"])),
    Content4 = 
        <<Content1/binary, EnemyLeagueName/binary, Content2/binary, Content3/binary>>,
    Mail = lib_mail:mail(?SYSTEM_NAME, Title, Content4, [{?GOODS_TYPE_LEAGUE_SEAL, ?LEAGUE_REWARD_THING}]),
    AllFightMember = lib_league:get_league_member_list(LeagueId),
    lists:map(fun(#league_member{player_id = Id}) ->
                      lib_mail:send_mail(Id, Mail)
              end, AllFightMember).
    
count_league_lv(Thing, AllExp) ->
    count_league_lv(Thing, AllExp, 0).

count_league_lv(Thing, [H | T], LvCount) when Thing >= H ->
    count_league_lv(Thing, T, LvCount + 1);
count_league_lv(_, _, LvCount) ->
    LvCount.

do_daily_reward() ->    
    LeagueList = hdb:tab2list(fight_league),
    lists:map(fun(#fight_league{league_id = LeagueId, 
                                group     = Group
                               } = _League) ->
                      Rewards = get_daily_reward(Group),
                      Mail = lib_mail:mail(?SYSTEM_NAME, <<"军团战每日工资"/utf8>>, <<"">>, Rewards),

                      Members = lib_league:get_league_member_list(LeagueId),
                      PlayerIds = lists:map(fun(Member) ->
                                                    element(#league_member.player_id, Member)
                                            end, Members),
                      lib_mail:send_mail(PlayerIds, Mail)
              end, LeagueList).
get_daily_reward(Group) ->
    case data_base_guild_rank_integral:get(Group) of
        [] ->
            [];
        #base_guild_rank_integral{rank_wage = Wage
                                 }->
            [{?GOODS_TYPE_LEAGUE_SEAL, Wage}]
    end.

get_remain_challenge_num(#player{id = PlayerId}) ->
    case get_fight_member(PlayerId) of    
        [] ->
            0;
            %{fail, ?INFO_LEAGUE_BAD_ENEMY};
        #fight_member{fight_times = FightTimes} ->
            FightTimes
    end.

reset_challenge_num(PlayerId) ->
     case get_fight_member(PlayerId) of    
        [] ->
            0;
            %{fail, ?INFO_LEAGUE_BAD_ENEMY};
        #fight_member{} = FightMember ->
            update_fight_member(FightMember#fight_member{
                                  fight_times = 0
                                 })
    end.

%% get_league_status(#player{id = Id}) ->
%%     case get_fight_member(Id) of
%%         [] ->
%%             {?NO_APPLY_STATUS, get_next_fight_time(time_misc:unixtime())};
%%         #fight_member{league_id = LeagueId} ->
%%             case get_fight_league(LeagueId) of
%%                 #fight_league{
%%                    apply_time = ApplyTime,
%%                    enemy_league_id = EnemyLeagueId
%%                   } = FightLeague ->
%%                     Now = time_misc:unixtime(),
%%                     ?DEBUG("FightLeague: ~p", [FightLeague]),
%%                     ?DEBUG("ApplyTime: ~p", [ApplyTime]),
%%                     if
%%                         %% 报名等待
%%                         ApplyTime =/= 0 -> 
%%                             {?APPLY_STATUS, get_next_fight_time(Now)};
%%                         %% 轮空等待
%%                         EnemyLeagueId =:= 0 ->
%%                             {?NOT_ENEMY_STATUS, get_next_fight_time(Now)};
%%                         true ->
%%                             get_fight_status(Now)
%%                     end
%%             end
%%     end.
get_league_fight_status(#player{id = PlayerId} = _Player) ->
    case get_fight_member(PlayerId) of
        [] ->
            {?FIGHT_STATUS_NOTJOIN, get_next_fight_time(time_misc:unixtime())};
        #fight_member{
           league_id = LeagueId
          } ->
            get_league_fight_status(LeagueId)
    end;
get_league_fight_status(LeagueId) ->
    Now = time_misc:unixtime(),
    case get_fight_league(LeagueId) of
        [] ->
            {?FIGHT_STATUS_NOTJOIN, get_next_fight_time(Now)};
        #fight_league{
           apply_time = ApplyTime,
           enemy_league_id = EnemyLeagueId
          } = _FightLeague ->
            %% Now = time_misc:unixtime(),
            if
                %% 报名等待
                ApplyTime =/= 0 -> 
                    {?FIGHT_STATUS_APPLYED, get_next_timestamp(?FIGHT_STATUS_APPLYED)};
                %% 轮空等待
                ApplyTime =:= 0 andalso 
                EnemyLeagueId =:= 0 ->
                    {?FIGHT_STATUS_EMPTY, get_next_timestamp(?FIGHT_STATUS_EMPTY)};
                true ->
                    %% get_fight_status(Now)
                    Status = mod_cross_league_fight:get_fight_status(),
                    {Status, get_next_timestamp(Status)}
            end
    end.


%% 获取下一次结算的时间
get_next_fight_time(Now) ->
    TodayNum = time_misc:get_month_second_passed() div ?ONE_DAY_SECONDS + 1,
    NextTime = Now + time_misc:get_seconds_to_tomorrow(),
    if
        TodayNum rem 2 =:= 0 ->
            NextTime;
        true ->
            NextTime + ?ONE_DAY_SECONDS
    end.

get_next_arrange_time() ->
    Now = time_misc:unixtime(),
    {{_Y, _M, D}, _} = time_misc:timestamp_to_datetime(Now),
    if
        D > ?LEAGUE_FIGHT_LAST_DAY ->
            time_misc:get_timestamp_of_next_month_start();
        D rem 2 =:= 1 ->
            Now + time_misc:get_seconds_to_tomorrow() + ?ONE_DAY_SECONDS;
        true -> 
            Now + time_misc:get_seconds_to_tomorrow()
    end.

get_next_running_time() ->
    Now = time_misc:unixtime(),
    {{_Y, _M, D}, {HH, _MM, _SS}} = time_misc:timestamp_to_datetime(Now),
    if
        D > ?LEAGUE_FIGHT_LAST_DAY ->
            time_misc:get_timestamp_of_next_month_start() + ?HOUR_13 * ?ONE_HOUR_SECONDS ;
        D rem 2 =:= 1 ->
            if
                HH >= ?HOUR_13 ->
                    Now + time_misc:get_seconds_to_tomorrow() + ?ONE_DAY_SECONDS + ?HOUR_13 * ?ONE_HOUR_SECONDS;
                true -> 
                    Now - time_misc:get_today_second_passed() + ?HOUR_13 * ?ONE_HOUR_SECONDS
            end;
        true -> 
            Now + time_misc:get_seconds_to_tomorrow() + ?HOUR_13 * ?ONE_HOUR_SECONDS
    end.

get_next_timestamp(?FIGHT_STATUS_NOTJOIN) ->
    get_next_arrange_time();
get_next_timestamp(?FIGHT_STATUS_APPLYED) ->
    get_next_arrange_time();
get_next_timestamp(?FIGHT_STATUS_READY) ->
    get_next_running_time();
get_next_timestamp(?FIGHT_STATUS_EMPTY) ->
    get_next_arrange_time();
get_next_timestamp(?FIGHT_STATUS_RUINNG) ->
    get_next_arrange_time();
get_next_timestamp(?FIGHT_STATUS_ENDING) ->
    get_next_arrange_time();
get_next_timestamp(?FIGHT_STATUS_CLOSED) ->
    get_next_arrange_time().

%% %% 获取当前状态
%% get_fight_status(Now) ->
%%     TodayNum = time_misc:get_month_second_passed() div ?ONE_DAY_SECONDS + 1,
%%     NextTime = Now + time_misc:get_seconds_to_tomorrow(),
%%     if
%%         TodayNum > ?FIGHT_END_DATA ->
%%             {?NO_FIGHT_STATUS, Now + time_misc:get_seconds_to_next_month()};
%%         TodayNum rem 2 =:= 0 ->
%%             {?IN_FIGHT_STATUS, NextTime};
%%         true ->
%%             %% 基数天特殊处理
%%             get_fight_status_tody(NextTime)
%%     end.

%% get_fight_status_tody(NextTime) ->
%%     PasssSec = time_misc:get_today_second_passed(),
%%     if
%%         PasssSec - ?ONE_HOUR_SECONDS * ?HOUR_13 >= 0 ->
%%             {?IN_FIGHT_STATUS, NextTime + ?ONE_DAY_SECONDS};
%%         true ->
%%             {?WRITH_FIGHT_STATUS, time_misc:get_timestamp_of_today_start() + ?ONE_HOUR_SECONDS * ?HOUR_13}
%%     end.

%% get_fight_status_test() ->
%%     Now = time_misc:unixtime(),
%%     T1 = time_misc:timestamp_to_datetime(get_next_fight_time(Now)),
%%     {S2, T2} = get_fight_status(Now),
%%     io:format("T1:~p ~n", [T1]),
%%     io:format("S2:~p, T2:~p ~n", [S2, T2]),
%%     ?DEBUG("helllworld: ~p", [Now]),
%%     ok.


%% 2015.05.27 取消退出军团限制
check_leave_condition(#player{id = _Id}) ->
    %% case get_fight_member(Id) of
    %%     [] ->
    %%         true;
    %%     #fight_member{league_id = LeagueId} ->
    %%         case get_fight_league(LeagueId) of
    %%             [] ->
    %%                true;
    %%             #fight_league{apply_time = ApplyTime} ->
    %%                 if
    %%                     %% 报名了还没开打, 是可以离开的
    %%                     ApplyTime =/= 0 ->
    %%                         true;
    %%                     true ->
    %%                         case get_fight_status(time_misc:unixtime()) of
    %%                             {?IN_FIGHT_STATUS, _EndTime} ->
    %%                                 {fail, ?INFO_LEAGUE_FIGHT_STARTING_NOT_LEAVE};
    %%                             _ ->
    %%                                 true
    %%                         end
    %%                 end
    %%         end
    %% end.
    true.

backup_fight_league() ->
    hdb:clear_table(fight_league_copy),
    FightLeagueList =  hdb:read_table(fight_league),
    FightLeagueCopyList = lists:map(fun(FightLeague) ->
                                            to_fightleague_copy(FightLeague)
                                    end, FightLeagueList),
    hdb:dirty_write(fight_league_copy, FightLeagueCopyList).

to_fightleague_copy(FightLeague) ->
    [_RN, Key, _V | T] = tuple_to_list(FightLeague),
    Version = fight_league_copy_version:current_version(),
    List = [fight_league_copy, Key, Version] ++ T,
    list_to_tuple(List).



get_record_count(LeagueId) ->
    case get_fight_member_list(LeagueId) of
        [] ->
            [];
        MemberList ->
            lists:map(fun(#fight_member{player_id = PlayerId, 
                                        player_name = PlayerName,
                                        atk_records = Records}) ->
                              lists:foldl(fun(#fight_record{result    = Result,
                                                            things    = Things,
                                                            def_id    = DefId
                                                           }, CountRecord) ->
                                                  case Result of
                                                      ?LEAGUE_CHALLENGE_WIN ->
                                                          if
                                                              DefId > 0 -> 
                                                                  CountRecord#count_record{
                                                                    win_times = CountRecord#count_record.win_times + 1,
                                                                    things    = CountRecord#count_record.things + Things
                                                                   };
                                                              true -> 
                                                                  CountRecord#count_record{
                                                                    points = CountRecord#count_record.points + 1,
                                                                    things    = CountRecord#count_record.things + Things
                                                                   }
                                                          end;
                                                      _ ->
                                                          CountRecord#count_record{
                                                            loss_times = CountRecord#count_record.loss_times + 1,
                                                            things    = CountRecord#count_record.things + Things
                                                           }
                                                  end
                                          end, #count_record{player_id = PlayerId,
                                                             player_name = PlayerName
                                                            }, Records)
                      end, MemberList)
    end.


get_equip_rewards() ->
    case hmisc:rand1000(500) of
        true ->
            [{280115, 1}];
        _ ->
            []
    end.                             
