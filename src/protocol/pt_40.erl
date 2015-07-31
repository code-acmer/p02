-module(pt_40).

-include("pb_40_pb.hrl").
-include("define_logger.hrl").
-include("define_league.hrl").
-include("define_player.hrl").
-include("define_gifts.hrl").
-include("define_g17_guild.hrl").
-include("define_cross_league_fight.hrl").
-include("define_master_apprentice.hrl").

-export([write/2]).

write(40000, {LeagueList, Size}) ->
    PbLeagueList = 
        lists:map(fun(League) ->
                          ?DEBUG("League : ~w~n", [League]),
                          to_pb_league(League)
                  end, LeagueList),
    pt:pack(40000, #pbleaguelist{league_list = PbLeagueList,
                                 size = Size});
write(40002, League) ->
    PbLeague = to_pb_league(League),
    pt:pack(40002, PbLeague);
write(40003, MemberList) ->
    PbLeagueMemberList = 
        lists:map(fun(Member) ->
                          to_league_member(Member)
                  end, MemberList),
    pt:pack(40003, #pbleaguememberlist{member_list = PbLeagueMemberList});
write(40004, _) ->
    pt:pack(40004, null);
write(40100, GiftsList) ->
    PbOwnGifts = to_pbowngifts(GiftsList),
    pt:pack(40100, PbOwnGifts);

write(40101, {PlayerId, LeagueGiftsList}) ->
    PbLeagueGifts = to_pbleaguegifts({PlayerId, LeagueGiftsList}),
    pt:pack(40101, PbLeagueGifts);

write(40102, {PlayerId, LeagueGiftsList}) -> 
    PbLeagueGifts = to_pbleaguegifts({PlayerId, LeagueGiftsList}),
    pt:pack(40102, PbLeagueGifts);

write(40103, SendSuccess) -> 
    PbOneKeySendMsg = 
        to_pbonekeysendmsg(SendSuccess),
    pt:pack(40103, PbOneKeySendMsg);

write(40104, Value) -> 
    pt:pack(40104, #pbid32{id = Value});

write(40105, RecordList) ->
    PbGiftsRecordList = 
        to_pbgiftsrecordlist(RecordList),
    pt:pack(40105, PbGiftsRecordList);

write(40106, {RecordList, GoldSum}) ->
    PbLeagueHouse = 
        to_pbleagueghouse({RecordList, GoldSum}),
    pt:pack(40106, PbLeagueHouse);

write(40107, MsgList) ->
    PbMemberSendList = 
        to_pbmembersendlist(MsgList),
    pt:pack(40107, PbMemberSendList);

write(40108, RemainGold) ->
    pt:pack(40108, #pbid32{id = RemainGold});

write(40109, _) ->
    pt:pack(40109, null);

write(40111, Num) ->
    pt:pack(40111, #pbid32{id = Num});


write(40110, {BossName, LeagueName, LeagueId}) ->
    PbBossInviteMsg = 
        to_pbbossinvitemsg(BossName, LeagueName, LeagueId),
    pt:pack(40110, PbBossInviteMsg);

write(40200, List) ->
    PbPointSendMsgList = 
        to_pbpointsendmsglist(List),
    pt:pack(40200, PbPointSendMsgList);

write(40201, _) ->
    pt:pack(40201, null);

write(40202, RequestMsgList) ->
    PbRequestGiftsList = 
        to_pbrequestgiftslist(RequestMsgList),
    pt:pack(40202, PbRequestGiftsList);

write(40203, _) ->
    pt:pack(40203, null);

write(40204, MsgList) ->
    PbRequestPlayerGiftsMsgList = 
        to_pbrequestplayergiftsmsglist(MsgList),
    pt:pack(40204, PbRequestPlayerGiftsMsgList);

write(40205, _) ->
    pt:pack(40205, null);

write(40206, _) ->
    pt:pack(40206, null);

write(40207, Num) ->
    pt:pack(40207, #pbid32{id = Num});

write(40208, Num) ->
    pt:pack(40208, #pbid32{id = Num});

write(40300, _) ->
    pt:pack(40300, null);

write(40301, {FightLeagues, Size}) ->
    PbLeagueRankList = 
        lists:map(fun(FightLeague) ->
                          to_pbleaguerankinfo(FightLeague)
                  end, FightLeagues),
    pt:pack(40301, #pbleagueranklist{list = PbLeagueRankList,
                                     size = Size});

write(40302, {Score, Rank}) ->
    PbRankInfo = to_pbleaguefightrankinfo({Score, Rank}),
    pt:pack(40302, PbRankInfo);

write(40303, {Members, Player}) ->
    PbLeagueChallengeList = to_pbleaguechallengelist(Members, Player),
    pt:pack(40303, PbLeagueChallengeList);

write(40304, _) ->
    pt:pack(40304, null);

write(40305, Records) ->
    PbLeagueChallengeList = to_pbchallengeRecordlist(Records),
    pt:pack(40305, PbLeagueChallengeList);

write(40306, _) ->
    pt:pack(40306, null);

write(40400, PointList) ->
    PbLeagueFightPointList = to_pbleaguefightpointlist(PointList),
    pt:pack(40400, PbLeagueFightPointList);

write(40401, ProcetList) ->
    PbPointProcetList = to_pbpointprotectlist(ProcetList),
    pt:pack(40401, PbPointProcetList);

write(40402, _) ->
    pt:pack(40402, null);

write(40403, _) ->
    pt:pack(40403, null);

write(40404, RecordList) ->
    PbPointChallengeRecordInfo = to_pbpointchallengerecordinfo(RecordList),
    pt:pack(40404, PbPointChallengeRecordInfo);

write(40405, _) ->
    pt:pack(40405, null);

write(40406, _) ->
    pt:pack(40406, null);

write(40407, LeagueInfoList) ->
    PbLeagueInfoList = 
        to_pbleagueinfolist(LeagueInfoList),
    pt:pack(40407, PbLeagueInfoList);

write(40408, Num) ->
    pt:pack(40408, #pbid32{id = Num});

write(40409, {Status, EndTimeStamp}) ->
    pt:pack(40409, #pbgetleaguestatu{
                      type = Status,
                      timestamp = EndTimeStamp
                     });
write(40410, {DefRecords, AtkRecords}) ->
    pt:pack(40410, #pbfightrecords{
                      def_records = lists:map(fun(R) -> to_pbchallengerecord(R) end, DefRecords),
                      atk_records = lists:map(fun(R) -> to_pbchallengerecord(R) end, AtkRecords)
                     });
write(40411, CountRecords) ->
    pt:pack(40411, #pbcountrecords{records = lists:map(fun(R) -> to_pbcountrecord(R) end, CountRecords)
                     });

write(40500, League) ->
    ProtoMsg = to_pb_league(League),
    pt:pack(40500, ProtoMsg);
write(40501, _) ->
    pt:pack(40501, null);
write(40502, LeagueMember) ->
    ProtoMsg = to_league_member(LeagueMember),
    pt:pack(40502, ProtoMsg);
write(40503, _) ->
    pt:pack(40503, null);
write(40504, G17GuildList) ->
    ProtoMsg = to_pb_g17_guild_list(G17GuildList),
    pt:pack(40504, ProtoMsg);
write(40505, G17Guild) ->
    ProtoMsg = to_pb_g17_guild(G17Guild),
    pt:pack(40505, ProtoMsg);
write(40506, G17GuildMember) ->
    ProtoMsg = to_pb_g17_guild_member(G17GuildMember),
    pt:pack(40506, ProtoMsg);
write(40507, Leagues) ->
    ProtoMsg = #pbleaguelist{league_list = lists:map(fun(League) ->
                                                             to_pb_league(League)
                                                     end, Leagues)
                            }, 
    pt:pack(40507, ProtoMsg);

write(40600, {MasterCards, ApprenticeCards, RemainNum}) ->
    PbOwnCardsInfo = #pbowncardsinfo{
                        master_card_list = lists:map(fun(MasterApprentice) ->
                                                             to_pbmastercard(MasterApprentice)
                                                     end, MasterCards),
                        apprentice_card_list = lists:map(fun(MasterApprentice) -> 
                                                                 to_pbapprenticecard(MasterApprentice)
                                                         end, ApprenticeCards),
                        remain_master_num = RemainNum
                       },
    pt:pack(40600, PbOwnCardsInfo);

write(40601, SkillCode) ->
    pt:pack(40601, #pbidstring{id = SkillCode});

write(40602, _) ->
    pt:pack(40602, null);

write(40603, MasterInfo) ->
    PbAllMasterInfo = 
        #pballmasterinfo{
           list = lists:map(fun(Master) ->
                                    to_pbmasterinfo(Master)
                            end, MasterInfo)
          },
    pt:pack(40603, PbAllMasterInfo);

write(40604, _) ->
    pt:pack(40604, null);

write(40605, _) ->
    pt:pack(40605, null);

write(40606, MasterApprenticeList) ->
    PbCardRequestList = 
        #pbcardrequestlist{
           list = lists:map(fun(MasterApprentice) -> 
                                    to_pbcardrequest(MasterApprentice)
                            end, MasterApprenticeList)
          },
    pt:pack(40606, PbCardRequestList);

write(40607, _) ->
    pt:pack(40607, null);

write(40608, _) ->
    pt:pack(40608, null);

write(40609, _) ->
    pt:pack(40609, null);

write(40610, _) ->
    pt:pack(40610, null);


write(Cmd, _R) ->
    ?WARNING_MSG("pt write error Cmd ~p, Reason ~p~n", [Cmd, _R]),
    pt:pack(0, <<>>).

to_pbcardrequest(#master_apprentice{
                    id = Id, 
                    request_card_msg = List
                   }) ->
    #pbcardrequest{
       id = Id,
       list = lists:map(fun(Req) ->
                                to_pbapprenticerequestinfo(Req)
                        end, List)
      }.

to_pbapprenticerequestinfo(#master_request_msg{
                              player_id = Id, 
                              player_name = Name
                             }) ->
    #pbapprenticerequestinfo{
       id = Id,
       name = Name
      }.

to_pbmasterinfo({#master_apprentice{
                    master_player_id = Id,
                    master_player_name = Name,
                    master_lv = Lv,
                    master_ability = Ability,
                    master_contribute = Con, 
                    master_contribute_lv = ConLv,
                    master_title = Title
                   }, InfoList}) ->
    #pbmasterinfo{
       id = Id,
       name = Name,
       lv = Lv,
       ability = Ability,
       contribute = Con,
       title = Title,
       contribute_lv = ConLv,
       card_list = lists:map(fun({Code, BaseId, CardStatus}) -> 
                                     to_pbcardinfo({Code, BaseId, CardStatus})
                             end, InfoList)
      }.

to_pbcardinfo({Code, BaseId, CardStatus}) ->
    #pbcardinfo{
       id = Code,
       base_id = BaseId,
       card_status = CardStatus
      }.

to_pbmastercard(#master_apprentice{
                   id = Id,
                   master_goods_id = GoodsId,
                   apprentice_player_id = PlayerId,
                   apprentice_player_name = Name,
                   skill_card_status = CardStatus,
                   skill_card_work_day = WorkDay
                  } = M) ->
    ?DEBUG("M: ~p", [M]),
    #pbmastercard{
       id = Id,
       master_goods_id = GoodsId,
       apprentice_player_id = PlayerId,
       apprentice_player_name = Name,
       card_status = CardStatus,
       work_day = WorkDay
      }.

to_pbapprenticecard(#master_apprentice{
                       id = Id,
                       master_player_id = PlayerId,
                       master_player_name = Name,
                       apprentice_goods_id = GoodsId,
                       skill_card_status = CardStatus,
                       skill_card_work_day = WorkDay
                      }) ->
    #pbapprenticecard{
       id = Id,
       master_player_id = PlayerId,
       master_player_name = Name,
       apprentice_goods_id = GoodsId,
       card_status = CardStatus,
       work_day = WorkDay
      }.

to_pbleagueinfolist(LeagueInfoList) ->
    #pbleagueinfolist{
       list = lists:map(fun(LeagueInfo) ->
                                to_pbleagueinfo(LeagueInfo)
                        end, LeagueInfoList)
      }.

to_pbleagueinfo(#fight_league{
                   league_name  = Name, 
                   league_id    = LeagueId, 
                   sn           = Sn, 
                   ability_sum  = AbiSum, 
                   group        = Group, 
                   things       = Thing,
                   occupy_points = OccPointNum, 
                   atk_times    = FightNum}) ->
    #pbleagueinfo{
       name = Name,
       league_id = LeagueId,
       league_sn = Sn,
       ability = AbiSum,
       group_num = Group,
       thing = Thing,
       occ_point_num = OccPointNum,
       remain_fight_num = FightNum
      }.

to_pbpointchallengerecordinfo(RecordList) ->
    #pbpointchallengerecordinfo{
       list = lists:map(fun(Record) ->
                                to_pbpointchallengerecord(Record)
                        end, RecordList)
      }.

to_pbpointchallengerecord(#fight_record{
                             atk_name = Name,
                             result = Result,
                             timestamp = TimeStamp,
                             things = ThingReward
                            }) ->
    #pbpointchallengerecord{
       timestamp = TimeStamp, 
       name = Name, 
       result = Result,
       thing_reward = ThingReward
      }.

to_pbpointprotectlist(ProcetList) ->
    #pbpointprotectlist{
       list = lists:map(fun(Tuple) ->
                                to_pbprotectplayerinfo(Tuple)
                        end, ProcetList)
      }.

to_pbprotectplayerinfo(#fight_member{
                          player_id = Id,
                          player_name = Name, 
                          player_career = Career,
                          player_lv = Lv, 
                          ability = Ability,
                          player_title = Title,
                          contribute = Con, 
                          contribute_lv = ConLv}) ->
    #pbprotectplayerinfo{
       player_id = Id,
       name = Name,
       lv = Lv,
       ability = Ability,
       contribute = Con,
       title = Title,
       contribute_lv = ConLv,
       career = Career
      }.

to_pbleaguefightpointlist(PointList) ->
    #pbleaguefightpointlist{
       list = lists:map(fun(Point) ->
                                to_pbleaguefightpoint(Point)
                        end, PointList)
      }.

to_pbleaguefightpoint(#defend_point{
                         id = PointId,
                         league_id = LeagueId,
                         status = Status,
                         pos = Pos,
                         defenders = ProList,
                         occupyers = OccList
                        }) ->
    #pbleaguefightpoint{
       league_id = LeagueId,
       point_id = PointId,
       pos = Pos,
       status = Status,
       protect_info = lists:map(fun({Name, Id}) ->
                                        #pbprotectinfo{name = Name, id = Id}
                                end, ProList),
       occurpy_info = lists:map(fun({Name, Id}) ->
                                        #pbprotectinfo{name = Name, id = Id}
                                end, OccList)
      }.

to_pbchallengeRecordlist(Records) ->
    #pbchallengerecordlist{
       list = lists:map(fun(Record) ->
                                to_pbchallengerecord(Record)
                         end, Records)
      }.

to_pbchallengerecord(#fight_record{
                        atk_id = _AtkId,
                        atk_name = AtkName,
                        def_id   = _DefId,
                        def_name = DefName,
                        timestamp = TimeStamp,
                        result    = Result,
                        things    = Thing}) ->
    #pbchallengerecord{
       timestamp = TimeStamp,
       name = AtkName,
       enemy_name = DefName,
       result = Result,
       league_thing = Thing
      }.

to_pbleaguechallengelist(ChallengeList, Player) ->
    #pbleaguechallengelist{
       list = lists:map(fun(R) ->
                                to_pbleaguechallengeinfo(R, Player)
                        end, ChallengeList) 
      }.

to_pbleaguefightrankinfo({Score, Rank}) ->
    #pbleaguefightrankinfo{
       score = Score,
       rank = Rank
      }.

to_pbleaguechallengeinfo(#fight_member{
                            player_id = Id,
                            player_name = Name, 
                            player_lv   = Lv, 
                            player_career = Career, 
                            player_title  = Title,
                            ability = Ability, 
                            things  = Thing,
                            def_records = DefRecords
                           }, #player{high_ability = MaxAbility}) ->
    ?WARNING_MSG("Ability: ~p", [Ability]),
    Mult = case lib_league_fight:check_ability(Ability, MaxAbility) of
               false ->
                   1;
               true ->
                   0
           end,                         
    #pbleaguechallengeinfo{
       player_id = Id, 
       name = Name,
       lv = Lv,
       title = Title,
       ability_sum = Ability,
       thing = Thing, 
       grab_num = ?MAX_ATKED_TIMES - length(DefRecords),
       career = Career,
       mult = Mult
      }.

to_pbleaguerankinfo(#fight_league{
                       league_id = LeagueId,
                       rank = Rank,
                       league_name = Name,
                       score = Score,
                       cur_num = CurNum,
                       ability_sum = AbilitySum,
                       lv = LeagueLv,
                       max_num = MaxNum
                      }) ->
    #pbleaguerankinfo{
       league_id = LeagueId,
       rank = Rank,
       name = Name,
       lv = LeagueLv,
       cur_num = CurNum,
       ability_sum = AbilitySum, 
       score = Score,
       max_num = MaxNum
      }.

to_pbrequestplayergiftsmsglist(MsgList) ->
    #pbrequestplayergiftsmsglist{
       list = lists:map(fun({Name, Id, Num}) ->
                                to_pbrequestplayergiftsmsg({Name, Id, Num})
                        end, MsgList)
      }.

to_pbrequestplayergiftsmsg({Name, Id, _Num}) ->
    #pbrequestplayergiftsmsg{
       name = Name, 
       player_id = Id
      }.

to_pbrequestgiftslist(RequestMsg) ->
    #pbrequestgiftsmsglist{
       list = lists:map(fun(Msg) ->
                                to_pbrequestgifts(Msg)
                        end, RequestMsg)
      }.

to_pbrequestgifts({Name, Lv, Title, GiftsNum, Id, IsRequest}) ->
    #pbrequestgiftsmsg{
       name = Name,
       lv = Lv,
       league_lv = Title,
       gifts_num = GiftsNum,
       player_id = Id,
       is_request = IsRequest
      }.

to_pbpointsendmsglist(List) ->
    #pbpointsendmsglist{
       list = lists:map(fun(Value) ->
                                to_pbpointsendmsg(Value)
                        end, List)
      }.

to_pbpointsendmsg({Name, Lv, Title, Id}) ->
    #pbpointsendmsg{
       name = Name, 
       lv = Lv, 
       league_lv = Title,
       player_id = Id
      }.

to_pbbossinvitemsg(BossName, LeagueName, LeagueId) ->
    #pbbossinvitemsg{
       boss_name = BossName, 
       league_name = LeagueName, 
       league_id = LeagueId
      }.    

to_pbmembersendlist(MsgList) ->
    #pbmembersendlist{
       list = lists:map(fun({Name, GoldSum}) ->
                                to_pbmembersendmsg({Name, GoldSum})
                        end, MsgList)
      }.

to_pbmembersendmsg({Name, GoldSum}) ->
    #pbmembersendmsg{
       name = Name,
       value = GoldSum
      }.

to_pbleagueghouse({RecordList, GoldSum}) ->
    #pbleaguehouse{
       record_list = lists:map(fun(Record) -> 
                                       to_pbleagueghouserecord(Record)
                               end, RecordList),
       gold = GoldSum
      }.

to_pbleagueghouserecord(#league_recharge_gold_record{
                           timestamp = TimeStamp,
                           recharge_name = Name,
                           value = Value
                          }) ->
    #pbleaguehouserecord{
       timestamp = TimeStamp,
       name = Name,
       value = Value
      }.

to_pb_league([]) ->
    #pbleague{};
to_pb_league(#league{id = Id,
                     name = Name,
                     cur_num = CurNum,
                     max_num = Max,
                     lv = Lv,
                     ability_sum = AbilitySum,
                     join_ability = Join,
                     declaration = Decration,
                     president = PreSident,
                     rank = Rank,
                     league_gifts_num = GiftsNum,
                     apply_league_fight = Fight,
                     league_exp = Exp,
                     g17_guild_id = G17Id,
                     g17_guild_name = G17Name
                    }) ->
    #pbleague{id = Id,
              name = Name,
              cur_num = CurNum,
              max_num = Max,
              lv = Lv,
              ability_sum = AbilitySum,
              join_ability = Join,
              declaration = Decration,
              president = PreSident,
              rank = Rank,
              league_gifts_num = GiftsNum,
              apply_league_fight = Fight,
              league_exp = Exp,
              g17_guild_id = G17Id,
              g17_guild_name = hmisc:to_binary(G17Name)
             }.

to_league_member(#league_member{player_id = PlayerId,
                                title = Title,
                                contribute = Contribute,
                                g17_join_timestamp = G17JoinTimestamp
                               }) ->
    {Name, Lv, Ability} = 
        case hdb:dirty_read(player, PlayerId, true) of
            [] ->
                {0, 0, 0};
            #player{nickname = NickName,
                    lv = PlayerLv,
                    battle_ability = BattleAbility} ->
                {NickName, PlayerLv, BattleAbility}
        end,
    #pbleaguemember{player_id = PlayerId,
                    title = Title,
                    contribute = Contribute,
                    name = Name,
                    lv = Lv,
                    ability = Ability,
                    g17_join_timestamp = G17JoinTimestamp
                   }.

to_pbowngifts(GiftsList) ->
    #pbowngifts{
       own_gifts_list = 
           lists:map(fun(PayGifts) ->
                             to_pbplayergifts(PayGifts)
                     end, GiftsList)
      }.

to_pbplayergifts(PayGifts) ->
    #pbplayergifts{
       gifts_id   = PayGifts#pay_gifts.id,
       timestamp  = PayGifts#pay_gifts.over_time,
       all_num    = PayGifts#pay_gifts.all_num,
       remain_num = PayGifts#pay_gifts.rest_num,
       recharge_gold_num = PayGifts#pay_gifts.recharge_gold_num,
       sum_value  = PayGifts#pay_gifts.sum,
       last_send = PayGifts#pay_gifts.last_send,
       day_remain_num = ?DAY_SEND_GIFTS - PayGifts#pay_gifts.day_num
      }.

to_pbleaguegifts({PlayerId, LeagueGiftsList}) ->
    #pbleaguegifts{
       league_gifts_list = 
           lists:foldl(fun(LeagueGifts, AccList) -> 
                               LeagueGiftsId = LeagueGifts#league_gifts.id, 
                               case hdb:dirty_read(league_gifts, LeagueGiftsId) of
                                   [] ->
                                       AccList;
                                   #league_gifts{
                                      id = GiftsId, 
                                      recv_list = RecvList
                                     } ->
                                       NewRecvList = 
                                           case hdb:dirty_read(pay_gifts, GiftsId) of
                                               [] ->
                                                   RecvList;
                                               #pay_gifts{
                                                  recv_list = List
                                                 } ->
                                                   List ++ RecvList
                                           end,
                                       [to_pbleagifts(PlayerId, NewRecvList, LeagueGifts) | AccList]
                               end
                       end, [], LeagueGiftsList)
      }.

to_pbleagifts(PlayerId, RecvList, LeagueGifts) ->
    HasRecv = 
        case lists:member(PlayerId, RecvList) of
            true ->
                1;
            _ ->
                0
        end,
    #pbleagifts{
       gifts_id   = LeagueGifts#league_gifts.id,
       name       = LeagueGifts#league_gifts.player_name,
       remain_num = LeagueGifts#league_gifts.rest_num,
       value      = 
           lists:foldl(fun(V, Sum) ->
                               Sum + V
                       end, 0,  LeagueGifts#league_gifts.one_days_value_list), 
       all_num    = LeagueGifts#league_gifts.sum,
       timestamp  = LeagueGifts#league_gifts.over_time,
       has_recv   = HasRecv
      }.

to_pbonekeysendmsg(SendSuccess) ->
    SendSuccessList = 
        lists:foldl(fun(Gifts, Acc) ->
                            [#pbgiftsid{
                              gifts_id = Gifts#pay_gifts.id
                             } | Acc]
                    end, [], SendSuccess),
    #pbonekeysendmsg{
       send_success_list = SendSuccessList
      }.

to_pbgiftsrecordlist(RecordList) ->
    {_, List} = 
        lists:foldl(fun(LeagueGiftsRecord, {Count, Acc}) ->
                            if 
                                Count < 101 ->
                                    {Count+1, [to_pbgiftsrecord(LeagueGiftsRecord)|Acc]};
                                true ->
                                    {Count, Acc}
                            end
                    end, {0, []}, RecordList),    
    #pbgiftsrecordlist{
       record_list = List
      }.

to_pbgiftsrecord(#league_gifts_record{
                    timestamp = TimeStamp,
                    send_name = SendName,
                    recv_name = RecvName,
                    type = Type, 
                    value = Value
                   }) ->
    #pbgiftsrecord{
       timestamp = TimeStamp, 
       send_name = SendName,
       recv_name = RecvName, 
       type = Type, 
       value = Value
      }.

to_pb_g17_guild_list(G17GuildList) ->
    #pbg17guildlist{
       guilds = lists:map(fun(G17Guild) ->
                                  to_pb_g17_guild(G17Guild)
                          end, G17GuildList)
      }.

to_pb_g17_guild(#g17_guild{
                   guild_id = GuildId,
                   guild_name     = GuildName,
                   status   = ApplyStatus,
                   owner_user_id = OwnerUserId
                  } = _G17Guild) ->
    #pbg17guild{guild_id = GuildId,
                guild_name = hmisc:to_binary(GuildName),
                status = ApplyStatus,
                owner_user_id = hmisc:to_binary(OwnerUserId)
               }.

to_pb_g17_guild_member(#g17_guild_member{
                          guild_id    = GuildId,
                          title_id    = Title,
                          number_id   = Number
                         } = _Member) ->
    #pbg17guildmember{
       guild_id = GuildId,
       title = Title,
       number = Number
      }.
    
to_pbcountrecord(#count_record{player_id = PlayerId,
                               player_name = PlayerName,
                               win_times = WinTimes,
                               loss_times = LossTimes,
                               points = Points,
                               things = Things
                              }) ->
    #pbcountrecord{player_id = PlayerId,
                   player_name = PlayerName,
                   win_times = WinTimes,
                   loss_times = LossTimes,
                   points = Points,
                   things = Things
                  }.
    
