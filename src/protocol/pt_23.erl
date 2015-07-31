
%%%------------------------------------
%%% @Module     : pt_23
%%% @Created    : 2011.02.15 
%%% @Description: 竞技场处理 
%%%------------------------------------
-module(pt_23).

-export([
         write/2
        ]).

-include("define_logger.hrl").
-include("define_arena.hrl").
-include("define_cross_pvp.hrl").
-include("pb_23_pb.hrl").


write(23000, AsyncRank) ->
    PbArenaInfo = to_pb_arena_info(AsyncRank),
    pt:pack(23000, PbArenaInfo);
write(23001, RankList) ->
    PbArenaInfoList = 
        #pbarenainfolist{arena_player_list = 
                             lists:map(fun(RankInfo) ->
                                               to_pb_arena_info(RankInfo)
                                       end, RankList)},
    pt:pack(23001, PbArenaInfoList);
write(23002, _) ->
    pt:pack(23002, <<>>);
write(23003, ReportList) ->
    PbReport = 
        #pbarenabattlereportlist{report_list = 
                                     lists:map(fun(Report) ->
                                                       to_pb_arena_battle_report(Report)
                                               end, ReportList)},
    pt:pack(23003, PbReport);
write(23005, RankList) ->
    PbArenaInfoList = 
        #pbarenainfolist{arena_player_list = 
                             lists:map(fun(RankInfo) ->
                                               to_pb_arena_info(RankInfo)
                                       end, RankList)},
    pt:pack(23005, PbArenaInfoList);

write(23500, #cross_pvp_fighter{times = Times,
                                buy_times = BuyTimes,
                                islands = Islands,
                                records = Records
                               } = _Fighter) ->
    ProtoMsg =  #pbcrossfighter{
                   times = Times,
                   buy_times = BuyTimes,
                   islands   = lists:map(fun(Island) -> to_pbcrossisland(Island) end, Islands),
                   records   = lists:map(fun(Record) -> to_pbcrossrecord(Record) end, Records)
                  },
    pt:pack(23500, ProtoMsg);
write(23501, Island) ->
    ProtoMsg = to_pbcrossisland(Island),
    pt:pack(23501, ProtoMsg);
%% write(23503, ReportList) ->
%%     PbReport = 
%%         #pbarenabattlereportlist{report_list = 
%%                                      lists:map(fun(Report) ->
%%                                                        to_pb_arena_battle_report(Report)
%%                                                end, ReportList)},
%%     pt:pack(23503, PbReport);
write(23504, #cross_pvp_fighter{times = Times,
                                buy_times = BuyTimes
                               } = _Fighter) ->
    ProtoMsg =  #pbcrossfighter{
                   times = Times,
                   buy_times = BuyTimes
                  },
    pt:pack(23504, ProtoMsg);

write(23505, #cross_pvp_island{} = Island) ->
    ProtoMsg = to_pbcrossisland(Island),
    pt:pack(23505, ProtoMsg);
%% write(23505, HistoryList) ->
%%     PbList = 
%%         lists:map(fun(#cross_pvp_history{rank = Rank,
%%                                          round = Round,
%%                                          timestamp = Time}) ->
%%                           #pbcrosshistory{rank = Rank,
%%                                           round = Round,
%%                                           timestamp = Time}
%%                   end, HistoryList),
%%     pt:pack(23505, #pbcrosshistorylist{list = PbList});
write(23506, _) ->
    pt:pack(23506, null);
write(Cmd, Other) ->
    ?WARNING_MSG("write cmd ~p error Other ~p~n", [Cmd, Other]),
    pt:pack(0, <<>>).
    
to_pb_arena_info(AsyncRank)
  when is_record(AsyncRank, async_arena_rank) ->
    PlayerId = 
        if
            AsyncRank#async_arena_rank.is_robot =:= ?RANK_ROBOT ->
                AsyncRank#async_arena_rank.robot_id;
            true ->
                AsyncRank#async_arena_rank.player_id
        end,
    #async_arena_rank{challenge_times = ChallengeTimes,
                      rank = Rank,
                      nickname = NickName,
                      lv = Lv,
                      battle_ability = BattleAbility,
                      career = Career,
                      win = Win,
                      lose = Lose,
                      rest_challenge_times = RestTimes,
                      buy_times = BuyTimes,
                      is_robot = IsRobot
                     }
        = AsyncRank,
    #pbarenainfo{challenge_times = ChallengeTimes,
                 rest_challenge_times = RestTimes,
                 rank = Rank,
                 win_times = Win,
                 fail_times = Lose,
                 robot = IsRobot,
                 player_id = PlayerId,
                 level = Lv,
                 nickname = NickName,
                 career = Career,
                 buy_times = BuyTimes,
                 battle_ability = BattleAbility
                };
to_pb_arena_info(SyncRank)
  when is_record(SyncRank, sync_arena_rank) ->
    #sync_arena_rank{challenge_times = ChallengeTimes,
                      rank = Rank,
                      player_id = PlayerId,
                      nickname = NickName,
                      lv = Lv,
                      battle_ability = BattleAbility,
                      career = Career,
                      win = Win,
                      lose = Lose,
                      rest_challenge_times = RestTimes
                     }
        = SyncRank,
    #pbarenainfo{challenge_times = ChallengeTimes,
                 rest_challenge_times = RestTimes,
                 rank = Rank,
                 win_times = Win,
                 fail_times = Lose,
                 player_id = PlayerId,
                 level = Lv,
                 nickname = NickName,
                 career = Career,
                 battle_ability = BattleAbility
                }.
%% to_pb_arena_info(#cross_pvp_fighter{
%%                     player_id   = PlayerId,
%%                     name        = Name,
%%                     career      = Career,
%%                     lv          = Lv,
%%                     sn          = Sn,
%%                     ability     = Ability,
%%                     times       = Times,
%%                     buy_times   = BuyTimes,
%%                     win_cnt     = WinCnt,
%%                     loss_cnt    = LossCnt,
%%                     rank        = Rank,
%%                     robot_id    = RobotId,
%%                     is_robot    = IsRobot,
%%                     score       = Score} = Member) ->


%%     #pbarenainfo{rest_challenge_times = Times,
%%                  rank = Rank,
%%                  win_times = WinCnt,
%%                  player_id = PlayerId,
%%                  level = Lv,
%%                  nickname = Name,
%%                  career = Career,
%%                  sn = Sn,
%%                  score = Score,
%%                  buy_times = BuyTimes,
%%                  battle_ability = Ability,
%%                  robot_id  = RobotId,
%%                  robot = IsRobot
%%                  %% enemy = lib_cross_pvp:get_enemy_ids(PlayerId)  %% 宿敌关系
%%                 }.

%% to_pb_arena_info_other(Member) when is_record(Member, cross_pvp_team) ->
%%     #cross_pvp_team{player_id = PlayerId,
%%                     name = Name,
%%                     career = Career,
%%                     sn = Sn,
%%                     battle_ability = BattleAbility,
%%                     lv = Lv,
%%                     robot_id = RobotId,
%%                     is_robot = IsRobot,
%%                     rank = Rank} = Member,
%%     ArenaerId = get_arenaer_id(PlayerId),
%%     #pbarenainfo{rank = Rank,
%%                  player_id = ArenaerId,
%%                  level = Lv,
%%                  nickname = Name,
%%                  career = Career,
%%                  sn = Sn,
%%                  robot_id = RobotId,
%%                  robot = IsRobot,
%%                  battle_ability = BattleAbility
%%                 }.
    
to_pb_arena_battle_report(Report)
  when is_record(Report, async_arena_report) ->
    #pbarenabattlereport{
       id = Report#async_arena_report.id,
       timestamp = Report#async_arena_report.timestamp,
       result = Report#async_arena_report.result,
       player_id = get_arenaer_id(Report#async_arena_report.attack_id),
       nickname = Report#async_arena_report.nickname,
       deffender_id = get_arenaer_id(Report#async_arena_report.deffender_id),
       deffender_name = Report#async_arena_report.deffender_name,
       rank_change_type = Report#async_arena_report.rank_change_type,
       attack_rank = Report#async_arena_report.attack_rank,
       deffender_rank = Report#async_arena_report.defender_rank};
to_pb_arena_battle_report(#cross_pvp_record{
                             id            = Id,
                             timestamp     = Timestamp,
                             result        = Result,
                             atk_id        = PlayerId,
                             atk_name      = PlayerName,
                             def_id        = DefId,
                             def_name      = DefName
                            }) ->
    #pbarenabattlereport{
       id = Id,
       timestamp = Timestamp,
       result = Result,
       player_id = PlayerId,
       nickname = PlayerName,
       deffender_id = DefId,
       deffender_name = DefName
       %% rank_change_type = Report#async_arena_report.rank_change_type,
       %% attack_rank = Report#async_arena_report.attack_rank,
       %% deffender_rank = Report#async_arena_report.defender_rank
      }.

to_pbcrossisland(#cross_pvp_island{id = Id,
                                   occupy_id          = OccupyId,
                                   occupy_name        = OccupyName,
                                   occupy_career      = Career,
                                   occupy_lv          = Lv,
                                   occupy_sn          = Sn,
                                   occupy_ability     = Ability,
                                   occupy_robot       = IsRobot,
                                   is_enemy           = IsEnemy,
                                   occupy_time        = Timestamp,
                                   calc_timestamp     = CalcTimestamp
                                  } = _Island) ->
    #pbcrossisland{id = Id,
                   occupy_id = OccupyId,
                   occupy_name = hmisc:to_binary(OccupyName),
                   occupy_career = Career,
                   occupy_lv          = Lv,
                   occupy_sn          = Sn,
                   occupy_ability     = Ability,
                   occupy_robot       = IsRobot,
                   is_enemy           = IsEnemy,
                   occupy_time        = Timestamp,
                   calc_timestamp     = CalcTimestamp
                  }.

to_pbcrossrecord(#cross_pvp_record{result = Result,
                                   atk_id = AtkId,
                                   atk_name = AtkName,
                                   def_id = DefId,
                                   def_name = DefName,
                                   timestamp = Timestamp
                                  } = _Record) ->
    #pbcrossrecord{result = Result,
                   atk_id = AtkId,
                   atk_name = hmisc:to_binary(AtkName),
                   def_id = DefId,
                   def_name = hmisc:to_binary(DefName),
                   timestamp = Timestamp
                  }.

get_arenaer_id(PlayerId) ->
    case PlayerId of
        {robot, TRobotId} ->
            TRobotId;
        Other ->
            Other
    end.
