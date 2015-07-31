-module(pt_17).

-include("define_logger.hrl").
-include("pb_17_pb.hrl").
-include("define_boss.hrl").

-export([write/2,
         record_top_ten/3]).

write(17000, UpdateList) ->
    PbUpdateList = 
        lists:map(fun(Boss) ->
                          bossinfo_to_pbworldboss(Boss)
                  end, UpdateList),
    pt:pack(17000, #pbbosslist{update_list = PbUpdateList});

write(17001, {BossLv, HpLim, Damage, Rec, BossState, Rank}) when is_record(Rec, pbworldboss) ->
    PbWorldBoss = 
        Rec#pbworldboss{damage = Damage,
                        rank = Rank,
                        state = BossState,
                        boss_lv = BossLv,
                        hp_lim = HpLim},
    pt:pack(17001, PbWorldBoss);
write(17001, {Damage, Rec, BossState, Rank}) when is_record(Rec, pbworldboss) ->
    write(17001, {0, 0, Damage, Rec, BossState, Rank});
write(17010, Boss) ->
    PbBoss = bossinfo_to_pbworldboss(Boss),
    pt:pack(17010, PbBoss);
write(17011, _) ->
    pt:pack(17011, <<>>);
write(17012, null) ->
    pt:pack(17012, <<>>);
write(17014, null) ->
    pt:pack(17014, <<>>);
write(Cmd, R) ->
    ?ERROR_MSG("Errorcmd ~p ~p~n",[Cmd, R]),
    pt:pack(0, null).

record_top_ten(TopTenInfo, MsgList, BossHp) ->
        player_info_to_pbworldboss(TopTenInfo, MsgList, BossHp).



bossinfo_to_pbworldboss(Boss) ->
    #bossinfo{player_id = PlayerId,
              nickname = NickName,
              boss_id = BossId,
              start = Start,
              stop = Stop
             } = Boss,
    #pbworldboss{boss_id = BossId,
                 player_id = PlayerId,
                 nickname = NickName,
                 start = Start,
                 stop = Stop
                }.

player_info_to_pbworldboss(TopTenInfo, MsgList, BossHp) ->
    PbRankList = lists:map(fun(RankInfo) ->
                                   to_pb_rank(RankInfo)  
                           end, TopTenInfo),
    PbMsgList = 
        lists:map(fun(Msg) ->
                         to_pbcritmsg(Msg)
                 end, MsgList),
    #pbworldboss{hp_cur = BossHp,
                 msg = PbMsgList,
                 rank_info = PbRankList
                }.

to_pb_rank(#player_info{damage = Damage,
                        nickname = NickName,
                        career = Career}) ->
    #pbrank{nickname = NickName,
            damage = Damage,
            career = Career}.

to_pbcritmsg({NickName, CritList}) ->
    #pbcritmsg{nickname = NickName,
               crit_damage = CritList}.
