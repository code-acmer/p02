%%%-----------------------------------
%%% @Module  : pt_13
%%% @Created : 2010.10.05
%%% @Description: 13角色信息
%%%-----------------------------------
-module(pt_13).

-export([
         write/2,
         get_detail_user_pack_info/2,
         to_pb_skill/1,
         goods_list_to_core_card/1,
         league_info/1,
         to_pb_notice/1,
         goods_to_skill_card/1,
         to_pbattribute/1
        ]).

-include("define_logger.hrl").
-include("pb_13_pb.hrl").
-include("define_player.hrl").
-include("define_team.hrl").
-include("define_goods.hrl").
-include("db_base_pvp_robot_attribute.hrl").
-include("db_base_kuafupvp_robot_attribute.hrl").
-include("define_league.hrl").
-include("define_relationship.hrl").
-include("pb_14_pb.hrl").
-include("db_base_notice.hrl").
-include("define_combat.hrl").

%%
%% @doc 服务端 -> 客户端 ------------------------------------
%%

%% @doc 写入13001信息，传入的参数可以是player的record，也可以是list
%% @spec
%% @end
write(13001, Player)
  when is_record(Player, pbuser) ->
    pt:pack(13001, Player);
write(13001, {Player, LeagueInfo})
  when is_record(Player, player) ->
    pt:pack(13001, get_detail_user_pack_info(Player, LeagueInfo));

%% 查询其他玩家信息
write(13004, PlayerList) ->
    PbUserList = #pbuserlist{
                    user_list =
                        lists:map(fun(Player) ->
                                          get_other_user_pack_info(Player)
                                  end, PlayerList)},
                        ?DEBUG("11111~p~n",[PlayerList]),
    pt:pack(13004, PbUserList);

%% 查询竞技场其他玩家信息
write(13008, PlayerInfoList) ->
    pt:pack(13008, to_pb_arena_user_list(PlayerInfoList));  
    
write(13010, _) ->
    pt:pack(13010, null);


write(13018, {Player, LeagueInfo})
  when is_record(Player, player) ->
    pt:pack(13018, get_detail_user_pack_info(Player, LeagueInfo));
write(13018, Player)
  when is_record(Player, pbuser) andalso 
       Player#pbuser.id =/= 0 ->
    pt:pack(13018, Player);

write(13020, #vip_reward{recv_list = List}) ->
    pt:pack(13020, #pbvipreward{recv_list = List});

write(13140, PvpRobotAttr) ->
    PbPvpRobotAttr = to_pbpvrobotattr(PvpRobotAttr),
    pt:pack(13140, PbPvpRobotAttr);

write(13141, RobotAttr) ->
    PbPvpRobotAttr = to_pbpvrobotattr(RobotAttr),
    pt:pack(13141, PbPvpRobotAttr);

write(13150, _) ->
    pt:pack(13150, <<>>);
write(13151, _) ->
    pt:pack(13151, null);

write(13200, _) ->
    pt:pack(13200, null);
write(13201, {InvitorName, DungeonId, TeamNum}) ->
    PbTeam = 
        #pbteam{nickname = InvitorName,
                dungeon_id = DungeonId,
                team_num = TeamNum},
    pt:pack(13201, PbTeam);
write(13202, _) ->
    pt:pack(13202, null);
write(13203, _) ->
    pt:pack(13203, null);
write(13204, _) ->
    pt:pack(13204, null);
write(13206, _) ->
    pt:pack(13206, null);
write(13205, []) ->
    pt:pack(13205, #pbteam{});
write(13205, Team) ->
    PbTeam = to_pb_team(Team),
    pt:pack(13205, PbTeam);
write(13208, {PlayerId, Msg}) ->
    PbTeamChat = #pbteamchat{player_id = PlayerId,
                             msg = unicode:characters_to_binary(Msg)},
    pt:pack(13208, PbTeamChat);
%% 发送用户卡
%% write(13220, RecUserCard) ->
%%     PbUserCard = #pbusercard{
%%                     str = RecUserCard#rec_user_card.str,
%%                     %% value = ?USER_CARD_FRIEND_PLAYER_GOLD,
%%                     timestamp = RecUserCard#rec_user_card.target_act_time,
%%                     timestamp2 = RecUserCard#rec_user_card.player_act_time
%%                    },
%%     ?DEBUG("pb_user_card: ~w~n", [PbUserCard]),
%%     pt:pack(13220, PbUserCard);

write(13300, Skill) ->
    pt:pack(13300, to_pb_skill(Skill));
write(13301, Skill) ->
    pt:pack(13301, to_pb_skill(Skill));
write(13305, Skill) ->
    pt:pack(13305, to_pb_skill(Skill));
write(13400, _) ->
    pt:pack(13400, <<>>);
%% write(13401, CombatAttriList) ->
%%     ProtoMsg = #pbcombatattrilist{
%%                   attri_list = lists:map(fun(CombatAttri) ->
%%                                                  to_pbcombatattri(CombatAttri)
%%                                          end, CombatAttriList)
%%                  },
%%     pt:pack(13400, ProtoMsg);
write(13333, SkillList) ->
    PbSkillList = 
        lists:map(fun(Skill) ->
                          to_pb_skill(Skill)
                  end, SkillList),
    pt:pack(13333, #pbskilllist{skill_list = PbSkillList});

write(13500, PlayerList) ->
    PbUserList = #pbuserlist{
                    user_list =
                        lists:map(fun(#player{id = PlayerId,
                                              sn = Sn} = Player) ->
                                          LeagueInfo = lib_league:league_name_title_new(PlayerId, Sn),
                                          get_detail_user_pack_info(Player, LeagueInfo)
                                  end, PlayerList)},
    pt:pack(13500, PbUserList);

write(13501, []) ->
    pt:pack(13501, #pbcombatrespon{});
write(13501, #combat_attri{} = CombatAttri) ->
    PbFriend = pt_14:player_detail_to_friend(CombatAttri, ?RELATIONSHIP_STRANGE),
    pt:pack(13501, #pbcombatrespon{player_attri = PbFriend});
write(13501, #base_kuafupvp_robot_attribute{} = RobotAttri) ->
    PbRobotAttri = to_pbpvrobotattr(RobotAttri),
    pt:pack(13501, #pbcombatrespon{robot_attri = PbRobotAttri});
write(13501, PlayerInfo) ->
    PbFriend = pt_14:player_detail_to_friend(PlayerInfo, ?RELATIONSHIP_STRANGE),
    pt:pack(13501, #pbcombatrespon{player_attri = PbFriend});
write(13600, NoticeList) ->
    PbNoticeList = #pbnoticelist{notice = to_pb_notice(NoticeList)},
    pt:pack(13600,PbNoticeList);
write(13601, Num) ->    
    pt:pack(13601,#pbid32{id = Num});
write(13602, _) ->
    pt:pack(13602, null);
write(Cmd, _R) ->
    ?WARNING_MSG("pt write error Cmd ~p, Reason ~p~n", [Cmd, _R]),
    pt:pack(0, null).

%% @doc 获取角色的详细信息
get_detail_user_pack_info(#player{
                             id = PlayerId,
                             sn = Sn,
                             lv = Lv,
                             exp = Exp
                            } = Player, _LeagueInfo) ->
    {LastDungeon, IsPassDungeon} = 
        case Player#player.last_dungeon of
            undefined   ->
                {undefined, undefined};
            Result      ->
                Result
        end,
    #ets_base_player{exp_next = ExpLim} = data_base_player:get(Lv),    
    NLeagueInfo = lib_league:league_name_title_new(PlayerId, Sn),
    {LeagueId, LeagueName, LeagueTitle} = league_info(NLeagueInfo),
    ?WARNING_MSG("Day: ~p, Flag: ~p", [Player#player.week_login_days, Player#player.login_reward_flag]),
    #pbuser{
       id              = Player#player.id,
       nickname        = Player#player.nickname,
       lv              = Player#player.lv,
       career          = Player#player.career,
       exp             = Exp,
       exp_lim         = ExpLim,
       gold            = Player#player.gold,
       bind_gold       = Player#player.bind_gold,
       seal            = Player#player.seal,
       coin            = Player#player.coin,
       vigor           = Player#player.vigor,
       vigor_lim       = lib_player:vigor_limit(Lv),
       vip_lv          = Player#player.vip,
       vip_exp         = Player#player.vip_exp,
       combat_point    = Player#player.combat_point,
       last_dungeon    = LastDungeon,
       is_pass_dungeon = IsPassDungeon,
       active_skill_ids = Player#player.normal_skill_ids,
       passive_skill_ids = Player#player.passive_skill_ids,
       fpt              = Player#player.fpt,
       cross_coin      = Player#player.cross_coin,
       arena_coin      = Player#player.arena_coin,
       friends_limit = Player#player.friends_limit + Player#player.friends_ext,
       base_friends_limit = Player#player.friends_limit,
       bag_limit = Player#player.bag_limit,
       login_reward_flag = Player#player.login_reward_flag,
       week_login_days = Player#player.week_login_days,
       open_boss_info = to_pbopenboss(Player#player.open_boss_info),
       battle_ability = Player#player.battle_ability,
       beginner_step = Player#player.beginner_step,
       honor = Player#player.honor,
       buy_vigor_times = Player#player.buy_vigor_times,
       league_name = LeagueName,
       league_title = LeagueTitle,
       month_login_days = Player#player.month_login_days,
       month_login_flag = Player#player.month_login_flag,
       return_gold = Player#player.return_gold,
       fashion = Player#player.fashion,
       off_time = Player#player.timestamp_login,
       league_id = LeagueId,
       league_seal = Player#player.league_seal,
       first_recharge_flag = Player#player.first_recharge_flag,
       q_coin = Player#player.q_coin,
       qq = Player#player.qq
      }.

get_other_user_pack_info(Player) ->
    #pbuser{
       id              = Player#player.id,
       nickname        = Player#player.nickname,
       lv              = Player#player.lv,
       career          = Player#player.career,
       vip_lv          = Player#player.vip,
       battle_ability = Player#player.battle_ability,
       off_time = Player#player.timestamp_login
      }.


to_pb_skill(Skill) ->
    #player_skill{
       id = Id,
       skill_id = SkillId,
       player_id = PlayerId,
       lv = Lv,
       str_lv = StrLv,
       sigil = Sigil,
       type = Type
      } = Skill,
    #pbskill{
       id = Id,
       skill_id = SkillId,
       player_id = PlayerId,
       lv = Lv,
       str_lv = StrLv,
       sigil = Sigil,
       type = Type
      }.

  to_pb_notice(NoticeList) ->
      lists:map(
      fun(#base_notice{
        notice_id = NoticeId,
        sort_id = SortId,
        type = Type,
        notice_name = NoticeName,
        headline = HeadLine,
        des = Des,
        show_time = ShowTime,
        activity_time = ActivityTime,
        function_id = FunctionId
      }) ->
        #pbnotice{
        notice_id = NoticeId,
        sort_id = SortId,
        type = Type,
        notice_name = NoticeName,
        headline = HeadLine,
        des = Des,
        show_time = to_pb_ShowTime(ShowTime),
        activity_time = to_pb_ActivityTime(ActivityTime),
        function_id = FunctionId
        } end, NoticeList).

to_pb_ShowTime(ShowTime) ->
      case ShowTime of          
          [] ->
                hmisc:term_to_string([]);

          ShowTime = [OpenTime, CloseTime] -> 
                hmisc:list_to_string([time_misc:datetime_to_timestamp(OpenTime), 
                time_misc:datetime_to_timestamp(CloseTime)])
      end.

to_pb_ActivityTime(ActivityTime) ->
       case ActivityTime of          
          [] ->
                 hmisc:term_to_string([]);

          ActivityTime = [ActivityOpenTime, ActivityCloseTime] -> 
                hmisc:list_to_string([time_misc:datetime_to_timestamp(ActivityOpenTime), 
                time_misc:datetime_to_timestamp(ActivityCloseTime)])
      end. 
              

to_pbopenboss(OpenBossInfoList) ->
    lists:map(fun({BossId, Times, TimestampList}) ->
                      #pbopenboss{boss_id = BossId,
                                  today_open_times = Times,
                                  open_timestamp = TimestampList}
              end, OpenBossInfoList).

to_pb_team(#team{leaderid = LeaderId,
                 members = MembersList,
                 dungeon_id = DungeonId,
                 number = TeamNum,
                 challenge_type = ChallengeType}) ->
    PbMembers = 
        lists:map(fun(#member{player_id = PlayerId,
                              nickname = Nickname,
                              lv = Lv,
                              battle_ability = BattleAbility,
                              career = Career,
                              state = State}) ->
                          #pbmember{player_id = PlayerId,
                                    nickname = Nickname,
                                    lv = Lv,
                                    battle_ability = BattleAbility,
                                    career = Career,
                                    state = State}
                  end, MembersList),
    #pbteam{leaderid = LeaderId,
            members = PbMembers,
            dungeon_id = DungeonId,
            team_num = TeamNum,
            challenge_type = ChallengeType}.

to_pb_arena_user_list(PlayerInfoList) ->
    PbData = 
        lists:map(fun(PlayerInfo) ->
                          to_pb_arena_user(PlayerInfo)
                  end, PlayerInfoList),
    #pbarenauserlist{list = PbData}.

to_pb_arena_user({Player, GoodsList, _LeagueInfo, _Mugen, _SkillList}) ->
    #player{id = Id,
            lv = Level,
            nickname = NickName,
            career = Career,
            %normal_skill_ids = ActiveSkills,
            battle_ability = Ability
           } = Player,
    {Core, PbSkillList} = goods_list_to_core_card(GoodsList),
    #pbarenauser{id = Id,
                 level = Level,
                 nickname = NickName,
                 career = Career,
                 core = Core,
                 skill_list = PbSkillList,
                 battle_ability = Ability}.

goods_to_skill_card(#goods{
                       base_id = Gid,
                       str_lv = StrLv}) ->
    #pbskill{
       skill_id = Gid,
       str_lv = StrLv}.

to_pbpvrobotattr(PvpRobotAttr) 
  when is_record(PvpRobotAttr, base_pvp_robot_attribute) ->
    #pbpvprobotattr{
       id                = PvpRobotAttr#base_pvp_robot_attribute.id,
       robot_id          = PvpRobotAttr#base_pvp_robot_attribute.robot_id,
       name              = PvpRobotAttr#base_pvp_robot_attribute.name,
       career            = PvpRobotAttr#base_pvp_robot_attribute.career,
       lv                = PvpRobotAttr#base_pvp_robot_attribute.lv,
       battle_ability    = PvpRobotAttr#base_pvp_robot_attribute.battle_ability,
       skill_1           = PvpRobotAttr#base_pvp_robot_attribute.skill_1,
       skill_1_lv        = PvpRobotAttr#base_pvp_robot_attribute.skill_1_lv,
       skill_2           = PvpRobotAttr#base_pvp_robot_attribute.skill_2,
       skill_2_lv        = PvpRobotAttr#base_pvp_robot_attribute.skill_2_lv,
       skill_3           = PvpRobotAttr#base_pvp_robot_attribute.skill_3,
       skill_3_lv        = PvpRobotAttr#base_pvp_robot_attribute.skill_3_lv,
       skill_4           = PvpRobotAttr#base_pvp_robot_attribute.skill_4,
       skill_4_lv        = PvpRobotAttr#base_pvp_robot_attribute.skill_4_lv,
       equ_weapon        = PvpRobotAttr#base_pvp_robot_attribute.equ_weapon,
       equ_clothes       = PvpRobotAttr#base_pvp_robot_attribute.equ_clothes,
       equ_shoes         = PvpRobotAttr#base_pvp_robot_attribute.equ_shoes,
       equ_neck          = PvpRobotAttr#base_pvp_robot_attribute.equ_neck,
       equ_ring          = PvpRobotAttr#base_pvp_robot_attribute.equ_ring,
       equ_pants         = PvpRobotAttr#base_pvp_robot_attribute.equ_pants,
       weapon_strengthen = PvpRobotAttr#base_pvp_robot_attribute.weapon_strengthen,
       weapon_star       = PvpRobotAttr#base_pvp_robot_attribute.weapon_star,
       clothes_strengthen = PvpRobotAttr#base_pvp_robot_attribute.clothes_strengthen,
       clothes_star      = PvpRobotAttr#base_pvp_robot_attribute.clothes_star,
       shoes_strengthen  = PvpRobotAttr#base_pvp_robot_attribute.shoes_strengthen,
       shoes_star        = PvpRobotAttr#base_pvp_robot_attribute.shoes_star,
       neck_strengthen   = PvpRobotAttr#base_pvp_robot_attribute.neck_strengthen,
       neck_star         = PvpRobotAttr#base_pvp_robot_attribute.neck_star,
       ring_strengthen   = PvpRobotAttr#base_pvp_robot_attribute.ring_strengthen,
       ring_star         = PvpRobotAttr#base_pvp_robot_attribute.ring_star,
       pants_strengthen  = PvpRobotAttr#base_pvp_robot_attribute.pants_strengthen,
       pants_star        = PvpRobotAttr#base_pvp_robot_attribute.pants_star
      };
to_pbpvrobotattr(PvpRobotAttr) 
  when is_record(PvpRobotAttr, base_kuafupvp_robot_attribute) ->
    #pbpvprobotattr{
       id                = PvpRobotAttr#base_kuafupvp_robot_attribute.id,
       robot_id          = PvpRobotAttr#base_kuafupvp_robot_attribute.robot_id,
       career            = PvpRobotAttr#base_kuafupvp_robot_attribute.career,
       lv                = PvpRobotAttr#base_kuafupvp_robot_attribute.lv,
       battle_ability    = PvpRobotAttr#base_kuafupvp_robot_attribute.battle_ability,
       skill_1           = PvpRobotAttr#base_kuafupvp_robot_attribute.skill_1,
       skill_1_lv        = PvpRobotAttr#base_kuafupvp_robot_attribute.skill_1_lv,
       skill_2           = PvpRobotAttr#base_kuafupvp_robot_attribute.skill_2,
       skill_2_lv        = PvpRobotAttr#base_kuafupvp_robot_attribute.skill_2_lv,
       skill_3           = PvpRobotAttr#base_kuafupvp_robot_attribute.skill_3,
       skill_3_lv        = PvpRobotAttr#base_kuafupvp_robot_attribute.skill_3_lv,
       skill_4           = PvpRobotAttr#base_kuafupvp_robot_attribute.skill_4,
       skill_4_lv        = PvpRobotAttr#base_kuafupvp_robot_attribute.skill_4_lv,
       equ_weapon        = PvpRobotAttr#base_kuafupvp_robot_attribute.equ_weapon,
       equ_clothes       = PvpRobotAttr#base_kuafupvp_robot_attribute.equ_clothes,
       equ_shoes         = PvpRobotAttr#base_kuafupvp_robot_attribute.equ_shoes,
       equ_neck          = PvpRobotAttr#base_kuafupvp_robot_attribute.equ_neck,
       equ_ring          = PvpRobotAttr#base_kuafupvp_robot_attribute.equ_ring,
       equ_pants         = PvpRobotAttr#base_kuafupvp_robot_attribute.equ_pants,
       weapon_strengthen = PvpRobotAttr#base_kuafupvp_robot_attribute.weapon_strengthen,
       weapon_star       = PvpRobotAttr#base_kuafupvp_robot_attribute.weapon_star,
       clothes_strengthen = PvpRobotAttr#base_kuafupvp_robot_attribute.clothes_strengthen,
       clothes_star      = PvpRobotAttr#base_kuafupvp_robot_attribute.clothes_star,
       shoes_strengthen  = PvpRobotAttr#base_kuafupvp_robot_attribute.shoes_strengthen,
       shoes_star        = PvpRobotAttr#base_kuafupvp_robot_attribute.shoes_star,
       neck_strengthen   = PvpRobotAttr#base_kuafupvp_robot_attribute.neck_strengthen,
       neck_star         = PvpRobotAttr#base_kuafupvp_robot_attribute.neck_star,
       ring_strengthen   = PvpRobotAttr#base_kuafupvp_robot_attribute.ring_strengthen,
       ring_star         = PvpRobotAttr#base_kuafupvp_robot_attribute.ring_star,
       pants_strengthen  = PvpRobotAttr#base_kuafupvp_robot_attribute.pants_strengthen,
       pants_star        = PvpRobotAttr#base_kuafupvp_robot_attribute.pants_star
      }.


%% to_pbcombatattri(#combat_attri{player_id   = PlayerId,
%%                                sn          = Sn,
%%                                career      = Career,
%%                                nickname    = Nickname,
%%                                lv          = Lv,
%%                                ability     = Ability,
%%                                high_ability = HighAbility,
%%                                league_id   = LeagueId,
%%                                league_name = LeagueName,
%%                                league_title= LeagueTitile,
%%                                base_attri  = BaseAttri,
%%                                final_attri = FinalAttri,
%%                                equips      = Equips,
%%                                stunts      = Stunts
%%                               } = _CombatAttri) ->
%%     #pbcombatattri{player_id   = PlayerId,
%%                    sn          = Sn,
%%                    career      = Career,
%%                    nickname    = Nickname,
%%                    lv          = Lv,
%%                    ability     = Ability,
%%                    high_ability = HighAbility,
%%                    league_id   = LeagueId,
%%                    league_name = LeagueName,
%%                    league_title= LeagueTitile,
%%                    base_attri  = to_pbattribute(BaseAttri),
%%                    final_attri = to_pbattribute(FinalAttri),
%%                    equips      = lists:map(fun(Goods) ->
%%                                                    pt_15:to_pbgoods(Goods)
%%                                            end, Equips),
%%                    stunts      = Stunts
%%                   }.

to_pbattribute(#attribute{hp_lim             = HpLim,
                          hp_cur             = HpCur,
                          mana_lim           = ManaLim,
                          mana_cur           = ManaCur,
                          hp_rec             = HpRec, 
                          mana_rec           = ManaRec,
                          attack             = Attack,
                          def                = Def,
                          hit                = Hit,
                          dodge              = Dodge,
                          crit               = Crit, 
                          anti_crit          = AntiCrit,
                          stiff              = Stiff,
                          anti_stiff         = AntiStiff,
                          attack_speed       = AttackSpeed,
                          move_speed         = MoveSpeed,
                          attack_effect      = AttackEffect,
                          def_effect         = DefEffect
                         } = _BaseAttri) ->
    #pbattribute{hp_lim             = HpLim,
                 hp_cur             = HpCur,
                 mana_lim           = ManaLim,
                 mana_cur           = ManaCur,
                 hp_rec             = HpRec, 
                 mana_rec           = ManaRec,
                 attack             = Attack,
                 def                = Def,
                 hit                = Hit,
                 dodge              = Dodge,
                 crit               = Crit, 
                 anti_crit          = AntiCrit,
                 stiff              = Stiff,
                 anti_stiff         = AntiStiff,
                 attack_speed       = AttackSpeed,
                 move_speed         = MoveSpeed,
                 attack_effect      = AttackEffect,
                 def_effect         = DefEffect
                }.


league_info([]) ->
    {undefined, undefined, undefined};
league_info(Other) ->
    Other.

goods_list_to_core_card(GoodsList) ->
    lists:foldl(fun
                    (#goods{card_pos_1 = Pos} = Goods, {AccEquip, AccSkillCard}) when Pos > 0 ->
                       {AccEquip, [goods_to_skill_card(Goods)|AccSkillCard]};
                    (#goods{container = ?CONTAINER_EQUIP} = Goods, {AccEquip, AccSkillCard}) ->
                       {[pt_15:to_pbgoods(Goods)|AccEquip], AccSkillCard};
                    (_, {AccEquip, AccSkillCard}) ->
                       {AccEquip, AccSkillCard}
               end, {[], []}, GoodsList).
