-module(pp_league).
-export([handle/3]).

-include("pb_40_pb.hrl").
-include("define_logger.hrl").
-include("define_player.hrl").
-include("define_info_0.hrl").
-include("define_gifts.hrl").
-include("define_g17_guild.hrl").
-include("define_league.hrl").
-include("define_info_40.hrl").
-include("define_cross_league_fight.hrl").
-include("define_master_apprentice.hrl").

%%工会列表
handle(40000, ModPlayerState, #pbgetleague{last_key = LastRank,
                                           type = Type}) ->
    case lib_league:get_g17_guild_member(ModPlayerState?PLAYER_ACCID) of
        [] ->
            case lib_league:get_league_list(ModPlayerState?PLAYER_SN, LastRank, Type) of
                {fail, Reason} ->
                    packet_misc:put_info(Reason);
                {LeagueList, Size} ->
                    {ok, Bin} = pt_40:write(40000, {LeagueList, Size}),
                    packet_misc:put_packet(Bin)
            end;
        #g17_guild_member{
           guild_id = G17GuildId
          } ->
            case lib_league:get_g17_league_list(ModPlayerState?PLAYER_SN, G17GuildId) of
                [] ->
                    {ok, Bin} = pt_40:write(40000, {[], 0}),
                    packet_misc:put_packet(Bin);
                Leagues ->
                    Size = length(Leagues),
                    {ok, Bin} = pt_40:write(40000, {Leagues, Size}),
                    packet_misc:put_packet(Bin)
            end
    end;


%%创建工会
handle(40001, ModPlayerState, #pbleague{name = Name,
                                        declaration = Decration}) ->
    case lib_league:create_league(ModPlayerState, Name, Decration) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {ok, NewModPlayerState} ->
            {ok, NewModPlayerState}
    end;

%%我的工会
handle(40002, ModPlayerState, _) ->
    case lib_league:get_my_league(ModPlayerState) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        #league{} = League ->            
            ApplyStatus = lib_league_fight:get_apply_status(League#league.id),
            {ok, Bin} = pt_40:write(40002, League#league{apply_league_fight = ApplyStatus
                                                        }),
            packet_misc:put_packet(Bin);
        []  ->
            {ok, Bin} = pt_40:write(40002, []),
            packet_misc:put_packet(Bin)
    end;

%%获取工会成员
handle(40003, ModPlayerState, _) ->
    MemberList = lib_league:get_league_member(ModPlayerState),
    {ok, Bin} = pt_40:write(40003, MemberList),
    packet_misc:put_packet(Bin);

%%离开工会
handle(40004, ModPlayerState, _) ->
    case lib_league_fight:check_leave_condition(ModPlayerState?PLAYER) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        true ->
            case reply(lib_league:leave_league(ModPlayerState?PLAYER)) of
                skip ->
                    lib_league_fight:reset_challenge_num(ModPlayerState?PLAYER);
                _ ->
                    skip
            end,
            {ok, ModPlayerState#mod_player_state{league_info = []}}
    end;

%%加入工会
handle(40005, ModPlayerState, #pbaddleaguemsg{league_id = LeagueId, type = AddType}) ->
    case lib_league:add_league(ModPlayerState, LeagueId, AddType) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {ok, NewModPlayerState} ->
            case lib_league_fight:load_fight_members(ModPlayerState?PLAYER) of
                {fail, Reason} ->
                    packet_misc:put_info(Reason);
                _ ->
                    {ok, NewModPlayerState}
            end
    end;

%%kick member
handle(40006, ModPlayerState, #pbid64{id = TarId}) ->
    case reply(lib_league:kick_league_member(ModPlayerState, TarId)) of
        skip ->
            {ok, Binary} = pt_40:write(40004, null),
            mod_player:league_kicked(TarId, Binary);
        _ ->
            skip
    end;

%%任命
handle(40007, ModPlayerState, #pbleaguemember{player_id = TarId,
                                              title = Title}) ->
    reply(lib_league:appoint_member(ModPlayerState?PLAYER, TarId, Title));

%%修改帮派宣言
handle(40008, ModPlayerState, #pbleague{declaration = Msg}) ->
    reply(lib_league:change_league_declaration(ModPlayerState?PLAYER, Msg));

%%修改帮派加入战斗力
handle(40009, ModPlayerState, #pbleague{join_ability = Ability}) ->
    reply(lib_league:change_league_join_ability(ModPlayerState?PLAYER, Ability));


%% 获取自身礼包信息
handle(40100, #mod_player_state{pay_gifts = GiftsList}, _) ->
    NewGiftsList = lib_pay_gifts:pass_zero_gift(GiftsList),
    {ok, Bin} = pt_40:write(40100, NewGiftsList),
    packet_misc:put_packet(Bin);

%% 获取公会礼包信息
handle(40101, #mod_player_state{
                 player = Player
                }, _) ->
    case lib_pay_gifts:get_league_gifts(Player#player.id) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        LeagueGiftsList ->
            {ok, Bin} = pt_40:write(40101, {Player#player.id, LeagueGiftsList}),
            packet_misc:put_packet(Bin)
    end;

%% 玩家单键发送礼包 或 群发礼包
handle(40102, #mod_player_state{
                 player = Player,
                 pay_gifts = GiftsList
                } = ModPlayerState, #pbsendgiftsmsg{
                                       gifts_id = GiftsId,
                                       gifts_num = GiftsNum
                                      }) ->
    case lib_pay_gifts:send_gifts(Player, GiftsId, GiftsNum, GiftsList) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {ok, NewGiftsList} ->
            LeagueGiftsList = 
                lib_pay_gifts:get_league_gifts(Player#player.id),
            {ok, Bin} = pt_40:write(40102, {Player#player.id, LeagueGiftsList}),
            packet_misc:put_packet(Bin),
            hdb:dirty_write(pay_gifts, NewGiftsList),
            {ok, ModPlayerState#mod_player_state{
                   pay_gifts = NewGiftsList
                  }}
    end;

%% 玩家一键发送礼包
handle(40103, #mod_player_state{
                 player = Player,
                 pay_gifts = GiftsList
                } = ModPlayerState, _) ->
    {SendSuccess, SendFail} = 
        lib_pay_gifts:one_key_send_gifts(Player, GiftsList),
    {ok, Bin} = pt_40:write(40103, SendSuccess),
    packet_misc:put_packet(Bin),
    {ok, ModPlayerState#mod_player_state{
           pay_gifts = SendSuccess ++ SendFail
          }};

%% 领取工会礼包
handle(40104, #mod_player_state{
                 player = Player
                } = ModPlayerState, #pbid32{id = GiftsId}) ->
    case lib_pay_gifts:recv_league_gifts(ModPlayerState, GiftsId) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {Value, NModPlayerState} ->
            LeagueGiftsList = 
                lib_pay_gifts:get_league_gifts(Player#player.id),
            {ok, Bin1} = pt_40:write(40101, {Player#player.id, LeagueGiftsList}),
            packet_misc:put_packet(Bin1),
            {ok, Bin2} = pt_40:write(40104, Value),
            packet_misc:put_packet(Bin2),
            {ok, NModPlayerState}
    end;

%% 读取记录
handle(40105, #mod_player_state{player = Player}, _) ->
    case lib_pay_gifts:get_league_record(Player) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {ok, RecordList} ->
            {ok, Bin} = pt_40:write(40105, RecordList),
            packet_misc:put_packet(Bin)
    end;

%% 获取公会仓库信息
handle(40106, #mod_player_state{player = Player}, _) ->
    case lib_pay_gifts:get_league_house(Player) of 
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {RecordList, GoldSum} ->
            {ok, Bin} = pt_40:write(40106, {RecordList, GoldSum}),
            packet_misc:put_packet(Bin)
    end;
%% 获取土豪榜或领取榜
handle(40107, #mod_player_state{player = Player}, #pbmembergetlisttype{type = Type}) ->
    case lib_pay_gifts:get_all_msg(Player#player.id, Type) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        MsgList ->
            {ok, Bin} = pt_40:write(40107, MsgList),
            packet_misc:put_packet(Bin)
    end;

%% 会长把公会的礼金发放出去
handle(40108, #mod_player_state{player = Player}, #pbbosssendgold{gold_num = GoldSum}) ->
    case lib_pay_gifts:boss_send_gifts(Player, GoldSum) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {ok, RemainGold} ->
            {ok, Bin} = pt_40:write(40108, RemainGold),
            packet_misc:put_packet(Bin)
    end;

%% 会长发送邀请
handle(40109, #mod_player_state{player = Player}, #pbid32{id = Id}) ->
    case lib_pay_gifts:invite_in_league(Player, Id) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        ok ->
            {ok, Bin} = pt_40:write(40109, null),
            packet_misc:put_packet(Bin)
    end;

%% 请求指定发送红包列表
handle(40200, ModPlayerState, #pbid32{id = GiftsId}) ->
    case lib_pay_gifts:get_appoint_send_msg(ModPlayerState, GiftsId) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        ResultList ->
            {ok, Bin} = pt_40:write(40200, ResultList),
            packet_misc:put_packet(Bin)
    end;

%% 指定发送红包给玩家
handle(40201, ModPlayerState, #pbpointsend{
                                 gifts_id = GiftsId,
                                 player_id = PlayerId
                                }) ->
    case lib_pay_gifts:appoint_send_gifts(ModPlayerState, GiftsId, PlayerId) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {ok, NewModPlayerState} ->
            {ok, Bin} = pt_40:write(40201, null),
            packet_misc:put_packet(Bin),
            {ok, NewModPlayerState}
    end;

%% 请求索要礼包信息
handle(40202, #mod_player_state{player = Player}, #pbid32{id = LeagueId}) ->
    case lib_pay_gifts:request_gifts_msg(Player, LeagueId) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        RequestMsgList ->
            {ok, Bin} = pt_40:write(40202, RequestMsgList),
            packet_misc:put_packet(Bin)
    end;

%% 索要红包
handle(40203, #mod_player_state{player = Player}, #pbid32{id = PlayerId}) ->
    case lib_pay_gifts:request_player_gifts(Player, PlayerId) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        ok ->
            {ok, Bin} = pt_40:write(40203, null),
            packet_misc:put_packet(Bin)
    end;

%% 获取被索要的信息
handle(40204, #mod_player_state{player = Player}, _) ->
    MsgList = lib_pay_gifts:get_request_msg(Player),
    {ok, Bin} = pt_40:write(40204, MsgList),
    packet_misc:put_packet(Bin);

%% 同意索要红包
handle(40205, ModPlayerState, #pbid32{id = PlayerId}) ->
    case lib_pay_gifts:agree_request_gifts(ModPlayerState, PlayerId) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {ok, NModPlayerState} ->
            {ok, Bin} = pt_40:write(40205, null),
            packet_misc:put_packet(Bin),
            {ok, NModPlayerState}
    end;

%% 拒绝索要红包
handle(40206, #mod_player_state{player = Player}, #pbid32{id = PlayerId}) ->
    case lib_pay_gifts:disagree_request_gifts(Player, PlayerId) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        ok ->
            {ok, Bin} = pt_40:write(40206, null),
            packet_misc:put_packet(Bin)
    end;

%% 获取工会礼包数量
handle(40207, #mod_player_state{player = Player}, _) ->
    case lib_pay_gifts:get_league_gifts_num(Player) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        Num ->
            {ok, Bin} = pt_40:write(40207, Num),
            packet_misc:put_packet(Bin)
    end;

%% 分解礼包
handle(40208, ModPlayerState, #pbid32{id = GoodsId}) ->
    case lib_pay_gifts:decomposition_gift(ModPlayerState, GoodsId) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {ok, NModPlayerState, MultNum} ->
            {ok, Bin} = pt_40:write(40208, MultNum),
            packet_misc:put_packet(Bin),
            {ok, NModPlayerState}
    end;

%% 公会战报名
handle(40300, ModPlayerState, _) ->
    case lib_league_fight:apply_for_fight(ModPlayerState) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        _ ->
            {ok, Bin} = pt_40:write(40300, null),
            packet_misc:put_packet(Bin)
    end;

%% 获取排行榜
handle(40301, ModPlayerState, #pbgetleaguegrouprankinfo{last_key = LastRank,
                                                        type = Type,
                                                        league_group = Group
                                                       }) ->
    case lib_league_fight:get_rank_list(ModPlayerState?PLAYER, LastRank, Type, Group) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {ok, FightLeagues, Size} ->
            %?DEBUG("LeagueRelationList: ~p", [LeagueRelationList]),
            {ok, Bin} = pt_40:write(40301, {FightLeagues, Size}),
            packet_misc:put_packet(Bin)
    end;

%% 获取自身公会排名信息
handle(40302, ModPlayerState, _) ->
    case lib_league_fight:get_rank_info(ModPlayerState?PLAYER) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {Score, Rank} ->
            {ok, Bin} = pt_40:write(40302, {Score, Rank}),
            packet_misc:put_packet(Bin)
    end;

%% 获取公会挑战列表
handle(40303, #mod_player_state{player = Player}, _) ->
    case lib_league_fight:get_enemy_list(Player) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        MemberList ->
            {ok, Bin} = pt_40:write(40303, {MemberList, Player}),
            packet_misc:put_packet(Bin)
    end;

%% 处理公会单人挑战战报
handle(40304, ModPlayerState, #pbleaguechallengeresult{
                                 enemy_player_id = EnemyId,
                                 result = Result,
                                 energy = Energy
                                }) ->
    case lib_league_fight:handle_attack_member_result(ModPlayerState, EnemyId, Result, Energy) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {ok, NewModPlayerState} ->
            {ok, Bin} = pt_40:write(40304, null),
            packet_misc:put_packet(Bin),
            {ok, NewModPlayerState}
    end;

%% 获取挑战记录
handle(40305, _ModPlayerState, #pbid32{id = EnemyPlayerId}) ->
    case lib_league_fight:get_defend_records(EnemyPlayerId) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        Records ->
            {ok, Bin} = pt_40:write(40305, Records),
            packet_misc:put_packet(Bin)
    end;

%% 检查玩家挑战条件
handle(40306, ModPlayerState, #pbid32{id = EnemyPlayerId}) ->
    case lib_league_fight:check_attack_enemy(ModPlayerState?PLAYER, EnemyPlayerId) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        _ ->
            {ok, Bin} = pt_40:write(40306,  null),
            packet_misc:put_packet(Bin)
    end;

%% 获取工会据点信息列表
handle(40400, ModPlayerState, #pbid32{id = _SelfLeagueId}) ->
    case lib_league_fight:get_point_list(ModPlayerState?PLAYER_ID) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {ok, AtkPoints, DefPoints} ->
            {ok, Bin} = pt_40:write(40400, AtkPoints ++ DefPoints),
            packet_misc:put_packet(Bin)
    end;

%% 获取可守卫据点的玩家信息列表
handle(40401, _ModPlayerState, #pbid32{id = LeagueId}) ->
    case lib_league_fight:get_fight_member_list(LeagueId) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        FightMembers ->
            {ok, Bin} = pt_40:write(40401, FightMembers),
            packet_misc:put_packet(Bin)
    end;

%% 指定玩家守卫据点
handle(40402, ModPlayerState, #pbappointplayer{point_id = PointId, player_id = Id}) ->
    case lib_league_fight:set_point_defender(ModPlayerState?PLAYER, PointId, Id) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {ok, AtkPoints, DefPoints} ->
            {ok, Bin} = pt_40:write(40400, AtkPoints ++ DefPoints),
            packet_misc:put_packet(Bin),
            {ok, Bin2} = pt_40:write(40402, null),
            packet_misc:put_packet(Bin2)
    end;

%% 取消玩家守卫据点
handle(40403, ModPlayerState, #pbappointplayer{point_id = PointId, player_id = Id}) ->
    case lib_league_fight:reset_point_defender(ModPlayerState?PLAYER, PointId, Id) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {ok, AtkPoints, DefPoints}  ->
            {ok, Bin} = pt_40:write(40400, AtkPoints ++ DefPoints),
            packet_misc:put_packet(Bin),
            {ok, Bin2} = pt_40:write(40403, null),
            packet_misc:put_packet(Bin2)
    end;

%% 获取据点挑战记录
handle(40404, ModPlayerState, #pbgetpointrecord{
                                 league_id = LeagueId, 
                                 point_id = PointId
                                }) ->
    ?WARNING_MSG("LeagueId: ~p PointId: ~p", [LeagueId, PointId]),
    case lib_league_fight:get_defend_point_records(ModPlayerState?PLAYER, LeagueId, PointId) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {ok, RecordList} ->
            {ok, Bin} = pt_40:write(40404, RecordList),
            packet_misc:put_packet(Bin)
    end;


%% 处理据点挑战战报
handle(40405, ModPlayerState, #pbleaguepointchallengeresult{point_id = PointId,
                                                            result = Result,
                                                            energy = Energy
                                                           }) ->
    case lib_league_fight:handle_attack_defend_point_result(ModPlayerState, PointId, Result, Energy) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);        
        {ok, NewModPlayerState, PointList} ->
            {ok, Bin} = pt_40:write(40400, PointList),
            packet_misc:put_packet(Bin),
            {ok, Bin2} = pt_40:write(40405, null),
            packet_misc:put_packet(Bin2),
            {ok, NewModPlayerState};
        Other ->
            ?DEBUG("40405: ~p", [Other])                
    end;

%% 检查挑战据点的各类条件
handle(40406, ModPlayerState, #pbid32{id = PointId}) ->
    case lib_league_fight:check_attack_defend_point(ModPlayerState?PLAYER_ID, PointId) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        _ ->
            {ok, Bin} = pt_40:write(40406, null),
            packet_misc:put_packet(Bin)
    end;

%% 获取双方公会战斗信息
handle(40407, ModPlayerState, _) ->
    case lib_league_fight:get_vs_league_info(ModPlayerState?PLAYER) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {ok, MyLeague, _MyInfo, EnemyLeague} ->
            ?DEBUG("LeagueInfoList: ~p", [[MyLeague, EnemyLeague]]),
            {ok, Bin} = pt_40:write(40407, [MyLeague, EnemyLeague]),
            packet_misc:put_packet(Bin)
    end;

%% 获取玩家剩余挑战次数
handle(40408, ModPlayerState, _) ->
    case lib_league_fight:get_remain_challenge_num(ModPlayerState?PLAYER) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        Num ->
            {ok, Bin} = pt_40:write(40408, Num),
            packet_misc:put_packet(Bin)
    end;

%% 获取军团当前状态
handle(40409, ModPlayerState, _) ->
    case lib_league_fight:get_league_fight_status(ModPlayerState?PLAYER) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {Status, EndTimeStamp} ->
            {ok, Bin} = pt_40:write(40409, {Status, EndTimeStamp}),
            packet_misc:put_packet(Bin)
    end;
%% 获取攻击与被攻击记录
handle(40410, _ModPlayerState, #pbid64{id = PlayerId}) ->
    case lib_league_fight:get_fight_member(PlayerId) of
        [] ->
            packet_misc:put_info(?INFO_LEAGUE_NOT_JOINT_FIGHT);
        #fight_member{
           def_records = DefRecords,
           atk_records = AtkRecords
          } ->
            {ok, Binary} = pt_40:write(40410, {DefRecords, AtkRecords}),
            packet_misc:put_packet(Binary)
    end;

%% 获取攻击与被攻击记录
handle(40411, _ModPlayerState, #pbid32{id = LeagueId}) ->
    CountRecords =  lib_league_fight:get_record_count(LeagueId),
    {ok, Binary} = pt_40:write(40411, CountRecords),
    packet_misc:put_packet(Binary);

%% g17公会逻辑================================
%% 创建g17公会
handle(40500, ModPlayerState, #pbg17guildquery{name = GuildName
                                              }) ->
    case lib_league:create_g17_guild(ModPlayerState?PLAYER, GuildName) of
        {error, Error} ->
            packet_misc:put_info(Error);
        {ok, NewLeague} ->
            {ok, Binary} = pt_40:write(40500, NewLeague),
            packet_misc:put_packet(Binary)
    end;
%% 军团长申请加入g17公会
handle(40501, ModPlayerState, #pbg17guildquery{guild_id = GuildId
                                              }) ->
    case lib_league:apply_g17_guild(ModPlayerState?PLAYER, GuildId) of
        {error, Error} ->
            packet_misc:put_info(Error);
        ok ->
            {ok, Binary} = pt_40:write(40501, null),
            packet_misc:put_packet(Binary)
    end;
%% 军团长已经加入g17公会后，成员跟随加入公会协议
handle(40502, ModPlayerState, _) ->
    case lib_league:follow_join_g17_guild(ModPlayerState?PLAYER) of
        {ok, LeagueMember} ->
            {ok, Binary} = pt_40:write(40502, LeagueMember),
            packet_misc:put_packet(Binary);
        {error, Error} ->
            packet_misc:put_info(Error)
    end;
%% 退出g17公会 公会长不允许退出公会，只允许转让公会（游戏内部不支持）
handle(40503, ModPlayerState, _) ->
    case lib_league:quit_g17_guild(ModPlayerState?PLAYER) of
        ok ->
            {ok, Binary} = pt_40:write(40503, null),
            packet_misc:put_packet(Binary);
        {error, Error} ->
            packet_misc:put_info(Error)
    end;
%% 获取g17公会列表
handle(40504, _ModPlayerState, _) ->
    G17Guilds = lib_league:get_g17_guild_list(),
    {ok, Binary} = pt_40:write(40504, G17Guilds),
    packet_misc:put_packet(Binary),
    ok;
%% 获取g17公会信息
handle(40505, ModPlayerState, _) ->
    case lib_league:get_my_g17_guild(ModPlayerState?PLAYER) of
        [] ->
            ok;
        #g17_guild{
           guild_id = GuildId
          } = G17Guild ->            
            ApplyStatus = lib_league:get_apply_status(GuildId, ModPlayerState?PLAYER_ACCID),
            NewG17Guild = G17Guild#g17_guild{status = ApplyStatus
                               },
            {ok, Binary} = pt_40:write(40505, NewG17Guild),
            packet_misc:put_packet(Binary)
    end;

%% 获取帐号g17公会属性
handle(40506, ModPlayerState, _) ->
    case lib_league:get_g17_guild_member(ModPlayerState?PLAYER_ACCID) of
        [] ->
            ignored;
        G17GuildMember ->
            {ok, Binary} = pt_40:write(40506, G17GuildMember),
            packet_misc:put_packet(Binary)
    end;
%% 获取帐号g17公会属性
handle(40507, ModPlayerState, _) ->
    case lib_league:get_league_list(ModPlayerState?PLAYER) of
        [] ->
            ignored;
        Leagues ->
            ?DEBUG("Leagues:~p~n", [Leagues]),
            {ok, Binary} = pt_40:write(40507, Leagues),
            packet_misc:put_packet(Binary)
    end;

%% 获取技能卡（师傅和徒弟）
handle(40600, ModPlayerState, _) ->
    case lib_master:get_own_cards_info(ModPlayerState?PLAYER) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);   
        {MasterCards, ApprenticeCards, RemainNum} ->
            {ok, Binary} = pt_40:write(40600, {MasterCards, ApprenticeCards, RemainNum}),
            packet_misc:put_packet(Binary)
    end;

%% 生成技能码
handle(40601, #mod_player_state{
                 player = Player,
                 bag = GoodsList
                } = ModPlayerState, #pbid32{id = GoodsId}) ->
    ?DEBUG("GoodsId: ~p", [GoodsId]),
    case lib_master:get_skill_code(Player, GoodsId, GoodsList) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        SkillCode ->
            {ok, Binary} = pt_40:write(40601, SkillCode),
            packet_misc:put_packet(Binary),
            reply({40600, ModPlayerState?PLAYER})
    end;

%% 输入技能码拜师学艺
handle(40602, ModPlayerState, #pbidstring{id = Code}) ->
    case lib_master:get_card_by_code(ModPlayerState, Code) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {ok, NewModPlayerState} ->
            {ok, Binary} = pt_40:write(40602, null),
            packet_misc:put_packet(Binary),
            %% reply({40600, ModPlayerState?PLAYER}),
            {ok, NewModPlayerState}
    end;

%% 获取本军团所有master
handle(40603, ModPlayerState, _) ->
    case lib_master:get_master_list(ModPlayerState?PLAYER) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        MasterInfo ->
            ?DEBUG("MemberInfo: ~p", [MasterInfo]),
            {ok, Binary} = pt_40:write(40603, MasterInfo),
            packet_misc:put_packet(Binary)
    end;

%% 驱逐徒弟
handle(40604, ModPlayerState, #pbidstring{id = Code}) ->
    case lib_master:deported_apprentice(ModPlayerState?PLAYER_ID, Code) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        _ ->
            {ok, Binary} = pt_40:write(40604, null),
            packet_misc:put_packet(Binary),
            reply({40600, ModPlayerState?PLAYER})
    end;

%% 徒弟销毁技能卡
handle(40605, ModPlayerState, #pbidstring{id = Code}) ->
    case lib_master:apprentice_destroy_card(ModPlayerState, Code) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {ok, NewModPlayerState} ->
            {ok, Binary} = pt_40:write(40605, null),
            packet_misc:put_packet(Binary),
            reply({40600, ModPlayerState?PLAYER}),
            {ok, NewModPlayerState}
    end;

%% 获取所有技能卡的请求信息
handle(40606, ModPlayerState, _) ->
    case lib_master:get_cards_request_msg(ModPlayerState?PLAYER_ID) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        MasterApprenticeList ->
            {ok, Binary} = pt_40:write(40606, MasterApprenticeList),
            packet_misc:put_packet(Binary)
    end;

%% 师傅同意收徒
handle(40607, ModPlayerState, #pbmasteragreemsg{id = Code, player_id = ApprenticeId}) ->
    case lib_master:master_agree_msg(ModPlayerState?PLAYER, Code, ApprenticeId) of
        {fail, Reason} ->
            reply({40600, ModPlayerState?PLAYER}),
            packet_misc:put_info(Reason);
        _ ->
            reply({40600, ModPlayerState?PLAYER})
    end;

%% 领取出师奖励
handle(40608, ModPlayerState, #pbidstring{id = Code}) ->
    case lib_master:recv_master_reward(ModPlayerState, Code) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {ok, NewModPlayerState} ->
            {ok, Binary} = pt_40:write(40608, null),
            packet_misc:put_packet(Binary),
            reply({40600, ModPlayerState?PLAYER}),
            {ok, NewModPlayerState}
    end;

%% 一键删除技能卡请求信息
handle(40609, ModPlayerState, #pbidstring{id = Code}) ->
    case lib_master:one_key_delete_msg(Code) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        _ ->
            {ok, Binary} = pt_40:write(40609, null),
            packet_misc:put_packet(Binary)
    end;

%% 购买师傅技能卡
handle(40610, ModPlayerState, #pbapprenticebuycard{
                                 id = Code, 
                                 type = Type
                                }) ->
    case lib_master:buy_skill_card(Code, Type) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {ok, NewModPlayerState} ->
            {ok, Binary} = pt_40:write(40610, null),
            packet_misc:put_packet(Binary),
            {ok, NewModPlayerState}
    end;


handle(_Cmd, _, _Data) ->
    ?WARNING_MSG("pp_league no match, /Cmd/Data/ = /~p/~p/~n", [_Cmd, _Data]),
    {error, "pp_league no match"}.

reply({fail, Reason}) ->
    packet_misc:put_info(Reason);
reply(ok) ->
    skip;
reply({40600, Player}) ->
    {MasterCards, ApprenticeCards, RemainNum} = 
        lib_master:get_own_cards_info(Player),
    {ok, Binary} = 
        pt_40:write(40600, {MasterCards, ApprenticeCards, RemainNum}),
    packet_misc:put_packet(Binary);
reply(Other) ->
    ?WARNING_MSG("OTHER ~p~n", [Other]),
    packet_misc:put_info(?INFO_PLAYER_PROCESS_ERROR).
