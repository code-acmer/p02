-module(lib_league_fight_old).

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
-include("db_base_guild_rank_integral.hrl").

-export([test/0,
         daily_reset_league_fight_job/1, 
         daily_send_league_reward_job/1,
         get_score_group/1,
         apply_for_fight/1,
         update_league_fight_point_table/1,
         get_rank_list/4,
         get_rank_info/1,
         get_challenge_list/1,
         count_challenge_result/4,
         get_challenge_record/1,
         check_challenge_enemy/2,
         get_all_point_msg/2,
         get_point_protect_list/1,
         appoint_protect/3,
         cancel_appoint_protect/3,
         get_challenge_point_record/1,
         count_challenge_point_result/4,
         check_challenge_point/2,
         get_league_info/1,
         get_group_by_score/1
        ]).

test() ->
    ok.

daily_reset_league_fight_job(Now) ->    
    PassDays = time_misc:get_month_second_passed() div ?ONE_DAY_SECONDS + 1,
    if
        PassDays rem 2 =:= 0 ->
            skip;
        true ->
            mod_league_count:start_count_data(),
            hdb:dirty_write(server_config, #server_config{k = daily_reset_league_fight_job,
                                                          v = Now})
    end.

daily_send_league_reward_job(Now) ->
    hdb:dirty_write(server_config, #server_config{k = daily_send_league_reward_job,
                                                  v = Now}),
    mod_league_reward:daily_send_league_reward().

get_score_group(Score) ->
    get_score_group1(Score, ?GROUP_LIST).

get_score_group1(Score, []) ->
    ?WARNING_MSG("Score Error ... Score: ~p", [Score]),
    0;
get_score_group1(Score, [H | T]) ->
    if
        Score >= H ->
            H;
        true ->
            get_score_group1(Score, T)
    end.

apply_for_fight(#mod_player_state{
                   player = Player
                  }) ->
    PlayerId = Player#player.id,
    PlayerSn = Player#player.sn,
    case hdb:dirty_read(league_member, PlayerId) of
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
                    LeagueTable = get_league_table(PlayerSn),
                    case hdb:dirty_read(LeagueTable, LeagueId) of
                        [] ->
                            {fail, ?INFO_CONF_ERR};
                        #league{
                           apply_league_fight = ApplyFlag,
                           cur_num = CurNum
                          } = League -> 
                            if
                                %% CurNum =< ?LEAGUE_APPLY_MEMBER_LIMIT ->
                                %%     {fail, ?INFO_LEAGUE_APPLY_MEMBER_NUM_LIMIT};
                                ApplyFlag =:= ?ALREADY_APPLY_FIGHT ->
                                    {fail, ?INFO_LEAGUE_ALREADY_APPLY};
                                true ->                                    
                                    ApplyInfoTable = get_apply_info_table(PlayerSn),                                    
                                    hdb:dirty_write(ApplyInfoTable, #league_apply_info{
                                                                       league_id = LeagueId,
                                                                       league_sn = PlayerSn
                                                                      }),
                                    hdb:dirty_write(LeagueTable, League#league{
                                                                   apply_league_fight = ?ALREADY_APPLY_FIGHT
                                                                  }),
                                    update_league_fight_point_table(LeagueId)                                    
                            end
                    end
            end
    end.

update_league_fight_point_table(LeagueId) ->
    case hdb:dirty_index_read(league_fight_point, LeagueId, #league_fight_point.league_id, true) of
        [] ->
            %% {Name, ProtectorId}
            Members = lib_league:get_league_member_list(LeagueId),
            PlayerIds = lists:map(fun(Member) ->
                                          element(#league_member.player_id, Member)
                                  end, Members),
            Players = lists:map(fun(PlayerId) ->
                                        hdb:dirty_read(player, PlayerId)
                                end, PlayerIds),
            SortFun = fun(P1, P2) ->
                              element(#player.high_ability, P1) > element(#player.high_ability, P2)
                      end,
            SortedPlayers = lists:sort(SortFun, Players),
            Len = length(SortedPlayers),
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
            
            lists:map(fun(Pos) ->
                              DefenderPlayers = GetDefenders(Players, Pos),
                              Defenders = lists:map(fun(P) ->
                                                            {element(#player.nickname, P), element(#player.id, P)}
                                                    end, DefenderPlayers),
                              PointId = next_league_fight_point_id(),
                              hdb:dirty_write(league_fight_point, #league_fight_point{
                                                                     id = PointId,
                                                                     league_id = LeagueId,
                                                                     pos = Pos,
                                                                     protect_info = Defenders 
                                                                    })
                      end, lists:seq(1, ?POINT_MAX_NUM));
        List ->
            lists:map(fun(Point) ->
                              hdb:dirty_write(league_fight_point, Point#league_fight_point{
                                                                    status = 0
                                                                    
                                                                   })
                      end, List)
    end.

next_league_fight_point_id() ->
    lib_counter:update_counter(league_fight_point).

get_league_table(Sn) ->
    DbSn = server_misc:get_mnesia_sn(Sn),
    list_to_atom(lists:concat([league, "_", DbSn])).   

get_apply_info_table(Sn) ->
    DbSn = server_misc:get_mnesia_sn(Sn),
    list_to_atom(lists:concat([league_apply_info, "_", DbSn])).   

check_title(?LEAGUE_TITLE_BOSS) ->
    true;
check_title(?LEAGUE_TITLE_DEPUTY_BOSS) ->
    true;
check_title(_) ->
    false.

get_rank_list(#player{sn = Sn}, LastRank, Type, Group) ->
    if
        Group < 0 ->
            {fail, ?INFO_LEAGUE_GROUP_ERROR};
        Group > ?GROUP_MAX_NUM ->
            {fail, ?INFO_LEAGUE_GROUP_ERROR};
        true ->
            mod_league_rank:get_rank_data(Sn, Group, LastRank, Type)
    end.

get_league_relation_table(Sn) ->
    DbSn = server_misc:get_mnesia_sn(Sn),
    list_to_atom(lists:concat([league_relation, "_", DbSn])).   
                    
get_rank_info(#player{id = PlayerId, sn = Sn}) ->
    case hdb:dirty_read(league_member, PlayerId) of
        [] ->
            {fail, ?INFO_LEAGUE_NOT_MEMBER};
        #league_member{league_id = LeagueId} ->
            case hdb:dirty_read(get_league_relation_table(Sn), LeagueId) of
                [] ->
                    {fail, ?INFO_LEAGUE_FIGHT_NOT_RANK};
                #league_relation{
                   league_score = Score,
                   league_rank = Rank
                  } ->
                    {Score, Rank}
            end
    end.

get_league_member_challenge_table(Sn) ->
    DbSn = server_misc:get_mnesia_sn(Sn),
    list_to_atom(lists:concat([league_member_challenge, "_", DbSn])).

get_challenge_list(#player{sn = Sn, id = PlayerId}) ->
    Table = get_league_member_challenge_table(Sn),
    case hdb:dirty_read(league_member, PlayerId) of
        [] ->
            {fail, ?INFO_LEAGUE_NOT_MEMBER};
        #league_member{league_id = LeagueId} ->
            case hdb:dirty_read(get_league_relation_table(Sn), LeagueId) of
                [] ->
                    {fail, ?INFO_LEAGUE_NOT_APPLY};
                #league_relation{not_enemy = true} ->
                    {fail, ?INFO_LEAGUE_NOT_ENEMY};
                #league_relation{enemy_league_id = EnemyLeagueId} ->
                    ?WARNING_MSG("LeagueId: ~p EnemyLeagueId: ~p", [LeagueId, EnemyLeagueId]),
                    case hdb:dirty_index_read(Table, EnemyLeagueId, #league_member_challenge.league_id, true) of
                        %% [] ->
                        %%     {fail, ?INFO_LEAGUE_NOT_APPLY};
                        AllData ->
                            ?WARNING_MSG("AllData: ~p", [AllData]),
                            List = 
                                lists:foldl(fun(#league_member_challenge{
                                                   player_id = Id, 
                                                   grap_thing = Thing,
                                                   grap_num = GrabNum
                                                  }, Acc) ->
                                                    case hdb:dirty_read(player, Id) of
                                                        [] ->
                                                            Acc;
                                                        #player{lv = Lv, career = Career, nickname = Name, high_ability = HighAbility} ->
                                                            case hdb:dirty_read(league_member, Id) of
                                                                [] ->
                                                                    Acc;
                                                                #league_member{title = Title} ->
                                                                    %%[{Id, Name, Lv, Title, AbilitySum, Thing, GrabNum} | Acc]
                                                                    [{Id, Name, Lv, Career, Title, HighAbility, Thing, GrabNum} | Acc]
                                                            end
                                                    end
                                            end, [], AllData),
                            %%按照敌对公会成员战力自上而下降序排列
                            lists:sort(fun({_, _, _, _, _, AbilitySum1, _, _}, {_, _, _, _, _, AbilitySum2, _, _}) -> 
                                               AbilitySum1 < AbilitySum2
                                       end, List)
                    end
            end
    end.

count_challenge_result(ModPlayerState, EnemyId, Result, Energy) ->
    Player = ModPlayerState?PLAYER, 
    #player{
       id = PlayerId, 
       sn = PlayerSn, 
       high_ability = Ability
      } = Player,    
    case hdb:dirty_read(player, EnemyId) of
        [] ->
            {fail, ?INFO_CONF_ERR};
        #player{
           sn = EnemySn, 
           high_ability = EnemyAbility
          } = EnemyPlayer ->
            case check_league_id(PlayerId, PlayerSn, EnemyId, EnemySn) of
                false ->
                    {fail, ?INFO_CHALLENGE_ERROR_MEMBER};
                {LeagueId, EnemyLeagueId} ->
                    ThingReward = get_reward(Result, Ability, EnemyAbility, Energy),
                    update_league_relation_table(LeagueId, PlayerSn, ThingReward, 0),
                    update_league_challenge_record(Player, EnemyPlayer, EnemyLeagueId, Result, ThingReward),
                    update_member_challenge_table(PlayerId, PlayerSn, ThingReward),
                    lib_reward:take_reward(ModPlayerState, [{?GOODS_TYPE_LEAGUE_SEAL, ThingReward}], ?LOG_EVENT_ADD_LEAGUE_SEAL, ?REWARD_TYPE_CROSS_LEAGUE)
            end
    end.

update_league_challenge_record(#player{id = Id, nickname = Name}, 
                               #player{id = EnemyId, nickname = EnemyName}, 
                               EnemyLeagueId, Result, ThingReward) ->
    ChallengeInfo = #mdb_challenge_info{
                       id = Id,
                       name = Name,
                       result = Result,
                       timestamp = time_misc:unixtime(),
                       thing_num = ThingReward
                      },
    Fun = fun() ->
                  case mnesia:wread({league_challenge_record, EnemyId}) of
                      [] ->
                          mnesia:write(league_challenge_record, 
                                       #league_challenge_record{
                                          player_id = EnemyId,
                                          player_name = EnemyName,
                                          league_id = EnemyLeagueId,
                                          record_list = [ChallengeInfo]
                                        }, write);
                      [#league_challenge_record{record_list = List} = Record] ->
                          mnesia:write(league_challenge_record, 
                                       Record#league_challenge_record{
                                         record_list = [ChallengeInfo | List]
                                        }, write);
                      Other ->
                          ?WARNING_MSG("Other: ~p", [Other])
                  end
          end,
    hdb:transaction(Fun).


update_member_challenge_table(Id, Sn, ThingReward) ->
    Table = get_league_member_challenge_table(Sn),
    case hdb:dirty_read(Table, Id) of
        [] ->
            skip;
        #league_member_challenge{
           grap_thing = GrabThing
          } = Record ->
            hdb:dirty_write(Table, Record#league_member_challenge{
                                     grap_thing = GrabThing + ThingReward
                                    })
    end.

update_league_relation_table(LeagueId, PlayerSn, ThingReward, PointNum) ->
    Table = get_league_relation_table(PlayerSn),
    Fun = fun() ->
                  case mnesia:wread({Table, LeagueId}) of
                      [] ->
                          skip;
                      [#league_relation{
                          league_thing = Thing,
                          league_point = Point
                         } = LeagueRelation] ->
                          mnesia:write(Table, LeagueRelation#league_relation{
                                                league_thing = Thing + ThingReward,
                                                league_point = Point + PointNum
                                               }, write);
                      Other ->
                          ?WARNING_MSG("Other: ~p", [Other])
                  end
          end,
    hdb:transaction(Fun).

check_league_id(PlayerId, PlayerSn, EnemyId, EnemySn) ->
    case hdb:dirty_read(league_member, PlayerId) of
        [] ->
            false;
        #league_member{league_id = LeagueId} ->
            case hdb:dirty_read(get_league_relation_table(PlayerSn), LeagueId) of
                [] -> 
                    false;
                #league_relation{enemy_league_id = EnemyLeagueId} ->
                    case hdb:dirty_read(league_member, EnemyId) of
                        #league_member{league_id = EnemyLeagueId} ->
                            case hdb:dirty_read(get_league_relation_table(EnemySn), EnemyLeagueId) of
                                #league_relation{league_sn = EnemySn} ->
                                    {LeagueId, EnemyLeagueId};
                                _ ->
                                    false
                            end;
                        _ ->
                            false
                    end
            end
    end.

get_reward(Result, Ability, EnemyAbility, Energy) ->
    case check_ability(Ability, EnemyAbility) of
        false ->
            ?LEAGUE_THING;
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
    ?WARNING_MSG("Energy: ~p", [Energy]).


get_challenge_record(EnemyId) ->
    case hdb:dirty_read(league_challenge_record, EnemyId) of
        [] ->
            {fail, ?INFO_NOT_CHALLENGE_RECORD};
        #league_challenge_record{
           player_name = EnemyName,
           record_list = List
          } ->
            %% {EnemyName, TimeStamp, Name, Result, Thing}
            get_challenge_record1(List, EnemyName, [])
    end.

get_challenge_record1([], _, Acc) ->
    Acc;

get_challenge_record1([H | T], EnemyName, Acc) ->
    #mdb_challenge_info{
       name = Name,
       result = Result,
       timestamp = TimeStamp,
       thing_num = Thing
      } = H,
    get_challenge_record1(T, EnemyName, [{EnemyName, TimeStamp, Name, Result, Thing} | Acc]).

check_challenge_enemy(Player, EnemyPlayerId) ->
    case check_challenge_time() of 
        false ->
            {fail, ?INFO_LEAGUE_NOT_APPLY};
        true ->
            check_challenge_enemy1(Player, EnemyPlayerId)
    end.

check_challenge_enemy1(#player{id = Id, sn = Sn}, EnemyPlayerId) ->
    Table = get_league_member_challenge_table(Sn), 
    case hdb:dirty_read(Table, Id) of
        [] ->
            {fail, ?INFO_LEAGUE_NOT_MEMBER};
        #league_member_challenge{use_challenge_num = UseNum}
          when UseNum > ?CHALLENGE_MAX_NUM ->
            {fail, ?INFO_MEMBRE_CHALLENGE_NUM_LIMIT};
        #league_member_challenge{use_challenge_num = UseNum} = PlayerChallenge ->
            EnemyPlayer = hdb:dirty_read(player, EnemyPlayerId),
            EnemySn = EnemyPlayer#player.sn,
            Now = time_misc:unixtime(), 
            EnemyTable = get_league_member_challenge_table(EnemySn), 
            case hdb:dirty_read(EnemyTable, EnemyPlayerId) of
                [] ->
                    {fail, ?INFO_LEAGUE_NOT_MEMBER};
                #league_member_challenge{grap_num = GrabNum} 
                  when GrabNum =< 0 ->
                    {fail, ?INFO_LEAGUE_ENEMY_GRAP_NUM_LIMIT};
                #league_member_challenge{attack_info = {TimeStamp, Id}}
                  when (Now - TimeStamp) < (?TEN_MINITE_SECONDS + ?FIVE_MINITE_SECONDS) ->
                    {fail, ?INFO_CHALLENGE_ENEMY_OVER_TIME};
                #league_member_challenge{grap_num = GrabNum} = EnemyChallenge ->
                    case hdb:dirty_read(league_challenge_record, EnemyPlayerId) of
                        [] ->
                            hdb:dirty_write(EnemyTable, EnemyChallenge#league_member_challenge{
                                                          grap_num = GrabNum - 1,
                                                          attack_info = {Now, Id}
                                                         }),
                            hdb:dirty_write(Table, PlayerChallenge#league_member_challenge{
                                                     use_challenge_num = UseNum + 1
                                                    });
                        #league_challenge_record{record_list = RecordList} ->
                            case lists:keytake(Id, #mdb_challenge_info.id, RecordList) of
                                {value, _, _} ->
                                    {fail, ?INFO_NOT_REPEAT_CHALLENGE_ENEMY};
                                false ->
                                    hdb:dirty_write(EnemyTable, EnemyChallenge#league_member_challenge{
                                                                  grap_num = GrabNum - 1,
                                                                  attack_info = {Now, Id}
                                                                 }),
                                    hdb:dirty_write(Table, PlayerChallenge#league_member_challenge{
                                                             use_challenge_num = UseNum + 1
                                                            })                                    
                            end
                    end
            end
    end.

get_all_point_msg(Sn, LeagueId) ->
    Table = get_league_relation_table(Sn),
    case hdb:dirty_read(Table, LeagueId) of
        [] ->
            {fail, ?INFO_LEAGUE_NOT_APPLY};
        #league_relation{not_enemy = true} ->
            {fail, ?INFO_LEAGUE_NOT_ENEMY};
        #league_relation{enemy_league_id = EnergyLeagueId} ->
            case hdb:dirty_index_read(league_fight_point, LeagueId, #league_fight_point.league_id, true) of
                [] ->
                    {fail, ?INFO_LEAGUE_NOT_APPLY};
                PointList ->
                    ?DEBUG("PointList: ~p", [PointList]),
                    case hdb:dirty_index_read(league_fight_point, EnergyLeagueId, #league_fight_point.league_id, true) of
                        [] ->
                            {fail, ?INFO_ENEMY_LEAGUE_POINT_ERROR};
                        EnemyPointList ->
                            EnemyPointList ++ PointList
                    end
            end
    end.
    
get_point_protect_list(LeagueId) ->
    case hdb:dirty_index_read(league_member, LeagueId, #league_member.league_id, true) of
        [] ->
            {fail, ?INFO_LEAGUE_NOT_MEMBER};
        AllMember ->
            lists:map(fun(#league_member{
                             player_id = Id, 
                             title = Title,
                             contribute = Con, 
                             contribute_lv = ConLv, 
                             player_name = Name
                            }) ->
                              Player = hdb:dirty_read(player, Id),
                              Lv = Player#player.lv,
                              Ability = Player#player.high_ability,
                              {Id, Name, Lv, Ability, Con, Title, ConLv}
                      end, AllMember)
    end.

appoint_protect(#player{id = Id, sn = Sn}, PointId, ProtectorId) ->
    case hdb:dirty_read(league_member, Id) of
        [] ->
            {fail, ?INFO_LEAGUE_NOT_MEMBER};
        #league_member{
           title = Title,
           league_id = LeagueId
          } -> 
            if
                Title =/= ?LEAGUE_TITLE_BOSS ->
                    {fail, ?INFO_LEAGUE_NOT_ENOUGH_POWER};
                true ->
                    case check_protector(LeagueId, ProtectorId) of
                        {fail, Reason} ->
                            {fail, Reason};
                        PointList ->
                            case lists:keytake(PointId, #league_fight_point.id, PointList) of
                                false ->
                                    {fail, ?INFO_LEAGUE_POINT_ERROR};
                                {value, #league_fight_point{
                                           protect_info = ProInfo
                                          } = Point, _} ->
                                    Player = hdb:dirty_read(player, ProtectorId),
                                    Name = Player#player.nickname, 
                                    hdb:dirty_write(league_fight_point, Point#league_fight_point{
                                                                          protect_info = [{Name, ProtectorId} | ProInfo]
                                                                         }),
                                    get_all_point_msg(Sn, LeagueId)
                            end
                    end
            end
    end.

check_protector(LeagueId, ProtectorId) -> 
    case hdb:dirty_index_read(league_fight_point, LeagueId, #league_fight_point.league_id, true) of
        [] ->
            {fail, ?INFO_LEAGUE_POINT_ERROR};
        PointList ->
            case traversal_point(PointList, ProtectorId) of
                true ->
                    {fail, ?INFO_LEAGUE_APPOINT_ERROR};
                false ->
                    PointList
            end
    end.

traversal_point([], _) ->
    false;

traversal_point([#league_fight_point{protect_info = ProcetInfo} | List], Id) ->
    case lists:keytake(Id, 2, ProcetInfo) of
        false ->
            traversal_point(List, Id);
        {value, _, _} ->
            true
    end.

cancel_appoint_protect(#player{id = Id, sn = Sn}, PointId, ProtectorId) ->
    case hdb:dirty_read(league_member, Id) of
        [] ->
            {fail, ?INFO_LEAGUE_NOT_MEMBER};
        #league_member{
           title = Title,
           league_id = LeagueId
          } -> 
            if
                Title =/= ?LEAGUE_TITLE_BOSS ->
                    {fail, ?INFO_LEAGUE_NOT_ENOUGH_POWER};
                true ->
                    case hdb:dirty_read(league_fight_point, PointId) of
                        [] ->
                            {fail, ?INFO_LEAGUE_POINT_ERROR};
                        #league_fight_point{protect_info = ProcetInfo} = Point ->
                            %% ProcetInfo [{Name, Id} ... ]
                            case lists:keytake(ProtectorId, 2, ProcetInfo) of
                                false ->
                                    {fail, ?INFO_LEAGUE_NOT_MEMBER};
                                {value, {_Name, _Id}, Rest} ->
                                    hdb:dirty_write(league_fight_point, Point#league_fight_point{
                                                                          protect_info = Rest
                                                                         }),
                                    get_all_point_msg(Sn, LeagueId)
                            end
                    end
            end
    end.

get_challenge_point_record(PointId) ->
    case hdb:dirty_read(league_fight_point, PointId) of
        [] ->
            {fail, ?INFO_LEAGUE_NOT_POINT};
        #league_fight_point{record_list = RecordList} ->
            RecordList
    end.

count_challenge_point_result(#mod_player_state{
                                player = #player{id = Id, nickname = Name, sn = Sn}
                               } = ModPlayerState, PointId, Result, Energy) ->
    Member = hdb:dirty_read(league_member, Id),
    LeagueId = Member#league_member.league_id,
    case hdb:dirty_read(league_fight_point, PointId) of
        [] ->
            {fail, ?INFO_LEAGUE_NOT_POINT};
        #league_fight_point{league_id = LeagueId} ->
            {fail, ?INFO_FIGHT_OWN_POINT_ERROR};
        #league_fight_point{attack_info = {_, ChallengeId}} when Id =/= ChallengeId ->
            {fail, ?INFO_CHALLENGE_POINT_OVER_TIME};
        #league_fight_point{
           status = Status,
           occurpy_info = OccInfo,
           record_list = RecordList
          } = Point ->

            ThingReward = ?LEAGUE_THING * get_win_reward(Energy) div 10,
            ChallengeInfo = #mdb_challenge_info{
                               id = Id,
                               name = Name,
                               result = Result,
                               timestamp = time_misc:unixtime(),
                               thing_num = ThingReward
                              },
            if
                Result =/= ?LEAGUE_CHALLENGE_WIN ->
                    hdb:dirty_write(league_fight_point, Point#league_fight_point{record_list = [ChallengeInfo | RecordList]}),
                    get_all_point_msg(Sn, LeagueId);
                true ->
                    if 
                        Status =:= ?POINT_OCC_STATUS ->
                            {fail, ?INFO_LEAGUE_POINT_ALREADY_OCC};
                        true ->
                            hdb:dirty_write(league_fight_point, Point#league_fight_point{
                                                                  status = ?POINT_OCC_STATUS,
                                                                  occurpy_info = [{Name, Id} | OccInfo],
                                                                  record_list = [ChallengeInfo | RecordList]
                                                                 }),
                            update_league_relation_table(LeagueId, Sn, ThingReward, 1),
                            update_member_challenge_table(Id, Sn, ThingReward),
                            {ok, NewModPlayerState} = 
                                lib_reward:take_reward(ModPlayerState, [{?GOODS_TYPE_LEAGUE_SEAL, ThingReward}], ?LOG_EVENT_ADD_LEAGUE_SEAL, ?REWARD_TYPE_CROSS_LEAGUE),
                            {ok, NewModPlayerState, get_all_point_msg(Sn, LeagueId)}
                    end
            end;
        Other ->
            ?WARNING_MSG("Other: ~p", [Other])
    end.

check_challenge_point(Player, PointId) ->
    %% 检查开战时间内
    case check_challenge_time() of
        false ->
            skip;            
        true ->
            %% 检查挑战次数
            case check_challenge_num(Player) of
                {fail, Reason} ->
                    {fail, Reason};
                {LeagueChallenge, Table} ->
                    %% 检查战斗力是否排在前十
                    case check_player_ability_rank(Player) of
                        {fail, Reason} ->
                            {fail, Reason};
                        false ->
                            {fail, ?INFO_LEAGUE_ABILITY_ENOUGH};
                        true ->
                            %% 检查据点的状态,已经是否有其他玩家正在攻击
                            case check_point_status(PointId, Player) of
                                {fail, Reason} ->
                                    {fail, Reason};
                                Point ->
                                    hdb:dirty_write(league_fight_point, 
                                                    Point#league_fight_point{
                                                      attack_info = {time_misc:unixtime(), Player#player.id}
                                                     }),
                                    hdb:dirty_write(Table, LeagueChallenge)
                            end
                    end
            end
    end.

check_player_ability_rank(Player) ->
    case hdb:dirty_read(league_member, Player#player.id) of
        [] ->
            {fail, ?INFO_LEAGUE_NOT_MEMBER};
        #league_member{league_id = LeagueId} ->
            AllMember = 
                hdb:dirty_index_read(league_member, LeagueId, #league_member.league_id, true),
            AbilityList = 
                lists:map(fun(#league_member{player_id = Id}) ->
                                  #player{high_ability = HAbi} = hdb:dirty_read(player, Id),
                                  HAbi
                          end, AllMember),
            NAbilityList = 
                lists:sort(fun(A, B) -> A > B end, AbilityList),
            if
                length(NAbilityList) < ?LEAGUE_CHALLENGE_ABILITY_RANK ->
                    true;
                true ->
                    Ability = lists:nth(?LEAGUE_CHALLENGE_ABILITY_RANK, NAbilityList),
                    Player#player.high_ability > Ability
            end
    end.

check_challenge_time() ->
    true.

check_challenge_num(#player{id = Id, sn = Sn}) ->
    Table = get_league_member_challenge_table(Sn),
    case hdb:dirty_read(Table, Id) of
        [] ->
            {fail, ?INFO_LEAGUE_NOT_MEMBER};
        #league_member_challenge{use_challenge_num = UseNum} = LeagueChallenge ->
            if
                UseNum + ?CHALLENGE_POINT_USE_NUM > ?CHALLENGE_MAX_NUM ->
                    {fail, ?INFO_LEAGUE_CHALLENGE_TIMES_LIMIT}; 
                true ->
                    {LeagueChallenge#league_member_challenge{
                       use_challenge_num = UseNum + ?CHALLENGE_POINT_USE_NUM
                      }, Table}
            end            
    end.

check_point_status(PointId, #player{id = PlayerId}) ->
    case hdb:dirty_read(league_fight_point, PointId) of
        [] ->
            {fail, ?INFO_LEAGUE_NOT_POINT};
        #league_fight_point{
           league_id = EnemyLeagueId,
           status = Status,
           attack_info = AttInfo,
           record_list = RecordList
          } = Point ->
            #league_member{league_id = LeagueId} =
                hdb:dirty_read(league_member, PlayerId),
            if
                Status =:= ?POINT_OCC_STATUS ->
                    {fail, ?INFO_LEAGUE_POINT_ALREADY_OCC};
                length(RecordList) > ?POINT_CHALLENGE_MAX_NUM ->
                    {fail, ?INFO_CHALLENGE_POINT_NUM_LIMIT};
                LeagueId =:= EnemyLeagueId ->
                    {fail, ?INFO_FIGHT_OWN_POINT_ERROR};
                true ->
                    case travers_record_list(RecordList, PlayerId) of
                        true ->
                            {fail, ?INFO_LEAGUE_CHALLENGE_POINT_SAME};
                        false ->
                            case AttInfo of
                                [] ->
                                    Point;
                                {TimeStamp, _Id} ->
                                    Now = time_misc:unixtime(),
                                    if
                                        %% 默认15分钟解锁吧
                                        (Now - TimeStamp) < (?TEN_MINITE_SECONDS + ?FIVE_MINITE_SECONDS) ->
                                            {fail, ?INFO_LEAGUE_POINT_ATTACK};
                                        true ->
                                            Point
                                    end
                            end
                    end
            end
    end.

travers_record_list([], _) ->
    false;
travers_record_list([#mdb_challenge_info{id = PlayerId}], PlayerId) ->
    true;
travers_record_list([_ | T], PlayerId) ->
    travers_record_list(T, PlayerId).

get_league_info(#player{id = Id, sn = Sn}) ->
    case hdb:dirty_read(league_member, Id) of
        [] ->
            {fail, ?INFO_LEAGUE_NOT_MEMBER};
        #league_member{league_id = LeagueId}->
            case hdb:dirty_read(get_league_relation_table(Sn), LeagueId) of
                [] ->
                    {fail, ?INFO_LEAGUE_NOT_APPLY};
                #league_relation{not_enemy = true} ->
                    {fail, ?INFO_LEAGUE_NOT_ENEMY};
                #league_relation{
                   league_group = Group, 
                   league_name = Name, 
                   ability_sum = AbiSum,  
                   league_thing = Thing,
                   league_point = OccPointNum,
                   enemy_league_id = EnemyLeagueId,
                   enemy_league_sn = EnemyLeagueSn
                  } ->
                    %% 掠夺次数 暂时默认 0
                    LeagueInfo = 
                        [{Name, LeagueId, Sn, AbiSum, Group, Thing, OccPointNum, 0}],
                    case hdb:dirty_read(get_league_relation_table(EnemyLeagueSn), EnemyLeagueId) of
                        [] ->
                            ?WARNING_MSG("EnemyLeagueId: ~p, EnemyLeagueSn: ~p", [EnemyLeagueId, EnemyLeagueSn]);
                        #league_relation{
                           league_group = EnemyGroup, 
                           league_name = EnemyName, 
                           ability_sum = EnemyAbiSum,  
                           league_thing = EnemyThing,
                           league_point = EnemyOccPointNum
                          } ->
                            EnemyLeagueInfo = 
                                [{EnemyName, EnemyLeagueId, EnemyLeagueSn, EnemyAbiSum, 
                                  EnemyGroup, EnemyThing, EnemyOccPointNum, 0}],
                            LeagueInfo ++ EnemyLeagueInfo
                    end                    
            end
    end.
            
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
                RankScore >= Score -> 
                    Group;
                true -> 
                    get_group_by_score(Score, Groups, Group)
            end
    end.


