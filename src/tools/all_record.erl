-module(all_record).
-include("udp_server.hrl").
-include("rfc4627_jsonrpc.hrl").
-include("pb_common_pb.hrl").
-include("pb_9_pb.hrl").
-include("pb_55_pb.hrl").
-include("pb_44_pb.hrl").
-include("pb_40_pb.hrl").
-include("pb_34_pb.hrl").
-include("pb_32_pb.hrl").
-include("pb_30_pb.hrl").
-include("pb_24_pb.hrl").
-include("pb_23_pb.hrl").
-include("pb_19_pb.hrl").
-include("pb_17_pb.hrl").
-include("pb_16_pb.hrl").
-include("pb_15_pb.hrl").
-include("pb_14_pb.hrl").
-include("pb_13_pb.hrl").
-include("pb_12_pb.hrl").
-include("pb_11_pb.hrl").
-include("pb_10_pb.hrl").
-include("httpd.hrl").
-include("http.hrl").
-include("gpb.hrl").
-include("emongo.hrl").
-include("define_team.hrl").
-include("define_task.hrl").
-include("define_sys_acm.hrl").
-include("define_skyrush.hrl").
-include("define_server.hrl").
-include("define_robot.hrl").
-include("define_reward.hrl").
-include("define_relationship.hrl").
-include("define_rank.hrl").
-include("define_radar.hrl").
-include("define_push.hrl").
-include("define_player.hrl").
-include("define_pay_info.hrl").
-include("define_mysql.hrl").
-include("define_monster.hrl").
-include("define_mnesia_upgrade_functions.hrl").
-include("define_mnesia.hrl").
-include("define_master_apprentice.hrl").
-include("define_mail.hrl").
-include("define_login.hrl").
-include("define_log.hrl").
-include("define_league.hrl").
-include("define_hold_dungeon.hrl").
-include("define_goods_rec.hrl").
-include("define_goods.hrl").
-include("define_gifts.hrl").
-include("define_gateway.hrl").
-include("define_g17_guild.hrl").
-include("define_fashion.hrl").
-include("define_error_common.hrl").
-include("define_dungeon_match.hrl").
-include("define_dungeon.hrl").
-include("define_data_generate.hrl").
-include("define_daily_dungeon_rec.hrl").
-include("define_ct_robot.hrl").
-include("define_cross_pvp.hrl").
-include("define_cross_league_fight.hrl").
-include("define_combat.hrl").
-include("define_chat.hrl").
-include("define_camp.hrl").
-include("define_boss.hrl").
-include("define_battle.hrl").
-include("define_arena.hrl").
-include("define_advance_reward.hrl").
-include("db_url_mini.hrl").
-include("db_pay_info.hrl").
-include("db_log_uplevel.hrl").
-include("db_log_twist_eggs.hrl").
-include("db_log_system.hrl").
-include("db_log_player_online.hrl").
-include("db_log_player_mini.hrl").
-include("db_log_player_login.hrl").
-include("db_log_player_feedback.hrl").
-include("db_log_player_create.hrl").
-include("db_log_player_chat.hrl").
-include("db_log_player.hrl").
-include("db_log_mail.hrl").
-include("db_log_login.hrl").
-include("db_log_device.hrl").
-include("db_base_xunzhang.hrl").
-include("db_base_vip_cost.hrl").
-include("db_base_vip.hrl").
-include("db_base_twist_egg.hrl").
-include("db_base_task.hrl").
-include("db_base_sys_acm.hrl").
-include("db_base_store_product.hrl").
-include("db_base_skill_exp.hrl").
-include("db_base_skill_card.hrl").
-include("db_base_shop_goods.hrl").
-include("db_base_shop_content.hrl").
-include("db_base_shop_activity.hrl").
-include("db_base_shop.hrl").
-include("db_base_rate.hrl").
-include("db_base_rank_reward.hrl").
-include("db_base_qianguizhe.hrl").
-include("db_base_pvp_robot_attribute.hrl").
-include("db_base_pvp_rank_reward.hrl").
-include("db_base_pvp_battle_reward.hrl").
-include("db_base_protocol.hrl").
-include("db_base_player.hrl").
-include("db_base_params.hrl").
-include("db_base_online_gift.hrl").
-include("db_base_notice.hrl").
-include("db_base_mysterious_shop.hrl").
-include("db_base_mugen_tower.hrl").
-include("db_base_month_reward.hrl").
-include("db_base_monster_level_attribute.hrl").
-include("db_base_mon.hrl").
-include("db_base_mail.hrl").
-include("db_base_login_reward.hrl").
-include("db_base_login_gift.hrl").
-include("db_base_log_user.hrl").
-include("db_base_kuafupvp_robot_attribute.hrl").
-include("db_base_kuafupvp_rank_reward.hrl").
-include("db_base_kuafupvp_battle_reward.hrl").
-include("db_base_guild_rank_integral.hrl").
-include("db_base_guild_lv_exp.hrl").
-include("db_base_goods_strengthen.hrl").
-include("db_base_goods_jewel.hrl").
-include("db_base_goods_color_hole.hrl").
-include("db_base_goods_att_rand.hrl").
-include("db_base_goods_att_lv.hrl").
-include("db_base_goods_att_color.hrl").
-include("db_base_goods.hrl").
-include("db_base_general_store.hrl").
-include("db_base_function_open.hrl").
-include("db_base_fashion_combination.hrl").
-include("db_base_fashion.hrl").
-include("db_base_error_list.hrl").
-include("db_base_equipment_upgrade.hrl").
-include("db_base_equipment_property.hrl").
-include("db_base_equipment.hrl").
-include("db_base_dungeon_world_boss.hrl").
-include("db_base_dungeon_target.hrl").
-include("db_base_dungeon_object_attribute.hrl").
-include("db_base_dungeon_monsters_attribute.hrl").
-include("db_base_dungeon_match.hrl").
-include("db_base_dungeon_detail.hrl").
-include("db_base_dungeon_create_portal.hrl").
-include("db_base_dungeon_create_object.hrl").
-include("db_base_dungeon_create_monster.hrl").
-include("db_base_dungeon_area.hrl").
-include("db_base_daily_dungeon_lv.hrl").
-include("db_base_daily_dungeon_info.hrl").
-include("db_base_daily_dungeon_condition.hrl").
-include("db_base_competitive_vice_shop.hrl").
-include("db_base_competitive_main_shop.hrl").
-include("db_base_combat_skill_upgrade.hrl").
-include("db_base_combat_skill_strengthen.hrl").
-include("db_base_combat_skill_passive.hrl").
-include("db_base_combat_skill.hrl").
-include("db_base_combat_buff.hrl").
-include("db_base_choujiang.hrl").
-include("db_base_boss.hrl").
-include("db_base_app_store_product.hrl").
-include("db_base_advance_reward.hrl").
-include("db_base_activity_twist_egg.hrl").
-include("db_base_activity.hrl").
-include("db_base_ability.hrl").
-define(MATCH_SPEC(Record), #Record{_='_'}).
-export([get_fields/1]).
-export([is_record/1]).
-export([match_info/1]).
-export([new/1]).
-export([pr/1]).

is_record(abs_path) ->
    true;
is_record(account_info) ->
    true;
is_record(achieve_data) ->
    true;
is_record(activity_shop_msg) ->
    true;
is_record(activity_shop_record) ->
    true;
is_record(advance_reward) ->
    true;
is_record(async_arena_rank) ->
    true;
is_record(async_arena_report) ->
    true;
is_record(attribute) ->
    true;
is_record(attribute_info) ->
    true;
is_record(base_ability) ->
    true;
is_record(base_activity_twist_egg) ->
    true;
is_record(base_advance_reward) ->
    true;
is_record(base_boss) ->
    true;
is_record(base_choujiang) ->
    true;
is_record(base_combat_buff) ->
    true;
is_record(base_combat_skill) ->
    true;
is_record(base_combat_skill_passive) ->
    true;
is_record(base_combat_skill_strengthen) ->
    true;
is_record(base_combat_skill_upgrade) ->
    true;
is_record(base_competitive_main_shop) ->
    true;
is_record(base_competitive_vice_shop) ->
    true;
is_record(base_daily_dungeon_condition) ->
    true;
is_record(base_daily_dungeon_info) ->
    true;
is_record(base_daily_dungeon_lv) ->
    true;
is_record(base_dungeon_area) ->
    true;
is_record(base_dungeon_create_monster) ->
    true;
is_record(base_dungeon_create_object) ->
    true;
is_record(base_dungeon_create_portal) ->
    true;
is_record(base_dungeon_detail) ->
    true;
is_record(base_dungeon_match) ->
    true;
is_record(base_dungeon_monsters_attribute) ->
    true;
is_record(base_dungeon_object_attribute) ->
    true;
is_record(base_dungeon_target) ->
    true;
is_record(base_dungeon_world_boss) ->
    true;
is_record(base_error_list) ->
    true;
is_record(base_fashion_combination) ->
    true;
is_record(base_function_open) ->
    true;
is_record(base_general_store) ->
    true;
is_record(base_goods) ->
    true;
is_record(base_goods_att_color) ->
    true;
is_record(base_goods_att_lv) ->
    true;
is_record(base_goods_att_rand) ->
    true;
is_record(base_goods_color_hole) ->
    true;
is_record(base_goods_jewel) ->
    true;
is_record(base_goods_strengthen) ->
    true;
is_record(base_guild_lv_exp) ->
    true;
is_record(base_guild_rank_integral) ->
    true;
is_record(base_kuafupvp_battle_reward) ->
    true;
is_record(base_kuafupvp_rank_reward) ->
    true;
is_record(base_kuafupvp_robot_attribute) ->
    true;
is_record(base_log_user) ->
    true;
is_record(base_login_reward) ->
    true;
is_record(base_mail) ->
    true;
is_record(base_monster_level_attribute) ->
    true;
is_record(base_month_reward) ->
    true;
is_record(base_mugen_tower) ->
    true;
is_record(base_mysterious_shop) ->
    true;
is_record(base_notice) ->
    true;
is_record(base_operators_mail) ->
    true;
is_record(base_params) ->
    true;
is_record(base_pvp_battle_reward) ->
    true;
is_record(base_pvp_rank_reward) ->
    true;
is_record(base_pvp_robot_attribute) ->
    true;
is_record(base_qianguizhe) ->
    true;
is_record(base_rank_reward) ->
    true;
is_record(base_rate) ->
    true;
is_record(base_shop) ->
    true;
is_record(base_shop_activity) ->
    true;
is_record(base_shop_content) ->
    true;
is_record(base_skill_card) ->
    true;
is_record(base_skill_exp) ->
    true;
is_record(base_store_product) ->
    true;
is_record(base_task) ->
    true;
is_record(base_twist_egg) ->
    true;
is_record(base_vip) ->
    true;
is_record(base_vip_cost) ->
    true;
is_record(base_xunzhang) ->
    true;
is_record(battle_attribute) ->
    true;
is_record(bossinfo) ->
    true;
is_record(camp) ->
    true;
is_record(chat_league) ->
    true;
is_record(chat_private) ->
    true;
is_record(chats_world) ->
    true;
is_record(choujiang_info) ->
    true;
is_record(client) ->
    true;
is_record(collect_status) ->
    true;
is_record(combat_attri) ->
    true;
is_record(common_reward) ->
    true;
is_record(count_record) ->
    true;
is_record(counter) ->
    true;
is_record(cross_pvp_enemy) ->
    true;
is_record(cross_pvp_event) ->
    true;
is_record(cross_pvp_fighter) ->
    true;
is_record(cross_pvp_island) ->
    true;
is_record(cross_pvp_npc) ->
    true;
is_record(cross_pvp_record) ->
    true;
is_record(ct_robot) ->
    true;
is_record(daily_dungeon) ->
    true;
is_record(data_base_activity) ->
    true;
is_record(data_base_fashion) ->
    true;
is_record(data_mon) ->
    true;
is_record(defend_point) ->
    true;
is_record(df_elem) ->
    true;
is_record(dungeon) ->
    true;
is_record(dungeon_info) ->
    true;
is_record(dungeon_match) ->
    true;
is_record(dungeon_mop_up) ->
    true;
is_record(dungeon_mugen) ->
    true;
is_record(dungeon_rewards) ->
    true;
is_record(dungeon_schedule) ->
    true;
is_record(emo_query) ->
    true;
is_record(equip_attribute) ->
    true;
is_record(error_msg) ->
    true;
is_record(ets_base_app_store_product) ->
    true;
is_record(ets_base_equipment) ->
    true;
is_record(ets_base_equipment_property) ->
    true;
is_record(ets_base_equipment_upgrade) ->
    true;
is_record(ets_base_login_gift) ->
    true;
is_record(ets_base_mon) ->
    true;
is_record(ets_base_online_gift) ->
    true;
is_record(ets_base_player) ->
    true;
is_record(ets_base_protocol) ->
    true;
is_record(ets_base_sys_acm) ->
    true;
is_record(ets_log_mail) ->
    true;
is_record(ets_pay_info) ->
    true;
is_record(ets_process) ->
    true;
is_record(ets_push_schedule) ->
    true;
is_record(ets_shop_goods) ->
    true;
is_record(fashion) ->
    true;
is_record(fashion_record) ->
    true;
is_record(field) ->
    true;
is_record(fight_league) ->
    true;
is_record(fight_league_copy) ->
    true;
is_record(fight_member) ->
    true;
is_record(fight_record) ->
    true;
is_record(fns_elem) ->
    true;
is_record(g17_guild) ->
    true;
is_record(g17_guild_apply) ->
    true;
is_record(g17_guild_member) ->
    true;
is_record(g_feats_elem) ->
    true;
is_record(gateway_agent) ->
    true;
is_record(gateway_client) ->
    true;
is_record(general_store) ->
    true;
is_record(generate_conf) ->
    true;
is_record(goods) ->
    true;
is_record(guild_mem_skyrush_rank) ->
    true;
is_record(guild_skyrush_rank) ->
    true;
is_record(help_battle) ->
    true;
is_record(hold_info) ->
    true;
is_record(http_request) ->
    true;
is_record(http_response) ->
    true;
is_record(init_data) ->
    true;
is_record(league) ->
    true;
is_record(league_apply_info) ->
    true;
is_record(league_challenge_record) ->
    true;
is_record(league_fight_point) ->
    true;
is_record(league_fight_state) ->
    true;
is_record(league_gifts) ->
    true;
is_record(league_gifts_record) ->
    true;
is_record(league_member) ->
    true;
is_record(league_member_challenge) ->
    true;
is_record(league_msg) ->
    true;
is_record(league_recharge_gold_record) ->
    true;
is_record(league_relation) ->
    true;
is_record(log_device) ->
    true;
is_record(log_login) ->
    true;
is_record(log_player) ->
    true;
is_record(log_player_chat) ->
    true;
is_record(log_player_create) ->
    true;
is_record(log_player_feedback) ->
    true;
is_record(log_player_login) ->
    true;
is_record(log_player_mini) ->
    true;
is_record(log_player_online) ->
    true;
is_record(log_state) ->
    true;
is_record(log_system) ->
    true;
is_record(log_twist_eggs) ->
    true;
is_record(log_uplevel) ->
    true;
is_record(lucky_coin) ->
    true;
is_record(mails) ->
    true;
is_record(main_shop) ->
    true;
is_record(main_shop_msg) ->
    true;
is_record(master_apprentice) ->
    true;
is_record(master_request_msg) ->
    true;
is_record(mdb_challenge_info) ->
    true;
is_record(mdb_dungeon_info) ->
    true;
is_record(mdb_shop_msg) ->
    true;
is_record(mem_feats_elem) ->
    true;
is_record(member) ->
    true;
is_record(mnesia_upgrade_conf) ->
    true;
is_record(mod) ->
    true;
is_record(mod_player_state) ->
    true;
is_record(mugen_reward) ->
    true;
is_record(node_status) ->
    true;
is_record(open_boss_rank) ->
    true;
is_record(operators_mail) ->
    true;
is_record(ordinary_shop) ->
    true;
is_record(ordinary_shop_msg) ->
    true;
is_record(own_gift) ->
    true;
is_record(pass_dungeon_info) ->
    true;
is_record(pay_gifts) ->
    true;
is_record(pay_info) ->
    true;
is_record(pbaccount) ->
    true;
is_record(pbaccountlogin) ->
    true;
is_record(pbactivity) ->
    true;
is_record(pbactivitylist) ->
    true;
is_record(pbactivityshop) ->
    true;
is_record(pbactivityshopmsg) ->
    true;
is_record(pbaddleaguemsg) ->
    true;
is_record(pballmasterinfo) ->
    true;
is_record(pbappointplayer) ->
    true;
is_record(pbapprenticebuycard) ->
    true;
is_record(pbapprenticecard) ->
    true;
is_record(pbapprenticerequestinfo) ->
    true;
is_record(pbarenabattlereport) ->
    true;
is_record(pbarenabattlereportlist) ->
    true;
is_record(pbarenachallenge) ->
    true;
is_record(pbarenainfo) ->
    true;
is_record(pbarenainfolist) ->
    true;
is_record(pbarenauser) ->
    true;
is_record(pbarenauserlist) ->
    true;
is_record(pbattribute) ->
    true;
is_record(pbbossinvitemsg) ->
    true;
is_record(pbbosslist) ->
    true;
is_record(pbbosssendgold) ->
    true;
is_record(pbcamp) ->
    true;
is_record(pbcamppos) ->
    true;
is_record(pbcardinfo) ->
    true;
is_record(pbcardrequest) ->
    true;
is_record(pbcardrequestlist) ->
    true;
is_record(pbcdkreward) ->
    true;
is_record(pbchallengedungeon) ->
    true;
is_record(pbchallengedungeoninfo) ->
    true;
is_record(pbchallengedungeonrank) ->
    true;
is_record(pbchallengerecord) ->
    true;
is_record(pbchallengerecordlist) ->
    true;
is_record(pbchat) ->
    true;
is_record(pbchatlist) ->
    true;
is_record(pbchoujiang) ->
    true;
is_record(pbchoujianggoods) ->
    true;
is_record(pbchoujianginfo) ->
    true;
is_record(pbchoujiangresult) ->
    true;
is_record(pbcombatbuff) ->
    true;
is_record(pbcombateffect) ->
    true;
is_record(pbcombatfighter) ->
    true;
is_record(pbcombathurtattri) ->
    true;
is_record(pbcombatreport) ->
    true;
is_record(pbcombatreportlist) ->
    true;
is_record(pbcombatrespon) ->
    true;
is_record(pbcombatreward) ->
    true;
is_record(pbcombatround) ->
    true;
is_record(pbcombattarget) ->
    true;
is_record(pbcountrecord) ->
    true;
is_record(pbcountrecords) ->
    true;
is_record(pbcreatearole) ->
    true;
is_record(pbcreaturedrop) ->
    true;
is_record(pbcritmsg) ->
    true;
is_record(pbcrossfighter) ->
    true;
is_record(pbcrosshistory) ->
    true;
is_record(pbcrosshistorylist) ->
    true;
is_record(pbcrossisland) ->
    true;
is_record(pbcrossrecord) ->
    true;
is_record(pbdailydungeon) ->
    true;
is_record(pbdungeon) ->
    true;
is_record(pbdungeoncondition) ->
    true;
is_record(pbdungeoncreature) ->
    true;
is_record(pbdungeonmonster) ->
    true;
is_record(pbdungeonreward) ->
    true;
is_record(pbdungeonschedule) ->
    true;
is_record(pbdungeonschedulelist) ->
    true;
is_record(pbdungeontarget) ->
    true;
is_record(pbequipaddstar) ->
    true;
is_record(pbequipmove) ->
    true;
is_record(pbequipstrengthen) ->
    true;
is_record(pberror) ->
    true;
is_record(pbfashion) ->
    true;
is_record(pbfashionlist) ->
    true;
is_record(pbfeedbackmsg) ->
    true;
is_record(pbfightrecords) ->
    true;
is_record(pbflipcard) ->
    true;
is_record(pbfriend) ->
    true;
is_record(pbfriendlist) ->
    true;
is_record(pbg17guild) ->
    true;
is_record(pbg17guildlist) ->
    true;
is_record(pbg17guildmember) ->
    true;
is_record(pbg17guildquery) ->
    true;
is_record(pbgeneralstorebuy) ->
    true;
is_record(pbgeneralstoreinfo) ->
    true;
is_record(pbgetleague) ->
    true;
is_record(pbgetleaguegrouprankinfo) ->
    true;
is_record(pbgetleaguestatu) ->
    true;
is_record(pbgetpointrecord) ->
    true;
is_record(pbgiftsid) ->
    true;
is_record(pbgiftsrecord) ->
    true;
is_record(pbgiftsrecordlist) ->
    true;
is_record(pbgoods) ->
    true;
is_record(pbgoodschanged) ->
    true;
is_record(pbgoodsinfo) ->
    true;
is_record(pbgoodslist) ->
    true;
is_record(pbhitrewarddetail) ->
    true;
is_record(pbid32) ->
    true;
is_record(pbid32r) ->
    true;
is_record(pbid64) ->
    true;
is_record(pbid64list) ->
    true;
is_record(pbid64r) ->
    true;
is_record(pbidstring) ->
    true;
is_record(pbinlaidjewel) ->
    true;
is_record(pbleagifts) ->
    true;
is_record(pbleague) ->
    true;
is_record(pbleaguechallengeinfo) ->
    true;
is_record(pbleaguechallengelist) ->
    true;
is_record(pbleaguechallengeresult) ->
    true;
is_record(pbleaguefightpoint) ->
    true;
is_record(pbleaguefightpointlist) ->
    true;
is_record(pbleaguefightrankinfo) ->
    true;
is_record(pbleaguegifts) ->
    true;
is_record(pbleaguehouse) ->
    true;
is_record(pbleaguehouserecord) ->
    true;
is_record(pbleagueinfo) ->
    true;
is_record(pbleagueinfolist) ->
    true;
is_record(pbleaguelist) ->
    true;
is_record(pbleaguemember) ->
    true;
is_record(pbleaguememberlist) ->
    true;
is_record(pbleaguepointchallengeresult) ->
    true;
is_record(pbleaguerankinfo) ->
    true;
is_record(pbleagueranklist) ->
    true;
is_record(pbmail) ->
    true;
is_record(pbmailgoods) ->
    true;
is_record(pbmaillist) ->
    true;
is_record(pbmasteragreemsg) ->
    true;
is_record(pbmastercard) ->
    true;
is_record(pbmasterinfo) ->
    true;
is_record(pbmember) ->
    true;
is_record(pbmembergetlisttype) ->
    true;
is_record(pbmembersendlist) ->
    true;
is_record(pbmembersendmsg) ->
    true;
is_record(pbmonsterdrop) ->
    true;
is_record(pbmopup) ->
    true;
is_record(pbmopuplist) ->
    true;
is_record(pbmugenchallenge) ->
    true;
is_record(pbnewiteminfo) ->
    true;
is_record(pbnewmsg) ->
    true;
is_record(pbnotice) ->
    true;
is_record(pbnoticelist) ->
    true;
is_record(pbnull) ->
    true;
is_record(pbonekeysendmsg) ->
    true;
is_record(pbopenboss) ->
    true;
is_record(pbordinarybuy) ->
    true;
is_record(pbowncardsinfo) ->
    true;
is_record(pbowngifts) ->
    true;
is_record(pbplayerachieve) ->
    true;
is_record(pbplayerachievelist) ->
    true;
is_record(pbplayercamp) ->
    true;
is_record(pbplayergifts) ->
    true;
is_record(pbpointchallengerecord) ->
    true;
is_record(pbpointchallengerecordinfo) ->
    true;
is_record(pbpointprotectlist) ->
    true;
is_record(pbpointsend) ->
    true;
is_record(pbpointsendmsg) ->
    true;
is_record(pbpointsendmsglist) ->
    true;
is_record(pbprivate) ->
    true;
is_record(pbprotectinfo) ->
    true;
is_record(pbprotectplayerinfo) ->
    true;
is_record(pbpvprobotattr) ->
    true;
is_record(pbrank) ->
    true;
is_record(pbrankinfo) ->
    true;
is_record(pbranklist) ->
    true;
is_record(pbrc4) ->
    true;
is_record(pbrequestgiftsmsg) ->
    true;
is_record(pbrequestgiftsmsglist) ->
    true;
is_record(pbrequestplayergiftsmsg) ->
    true;
is_record(pbrequestplayergiftsmsglist) ->
    true;
is_record(pbresult) ->
    true;
is_record(pbreward) ->
    true;
is_record(pbrewarditem) ->
    true;
is_record(pbrewardlist) ->
    true;
is_record(pbsellinglist) ->
    true;
is_record(pbsellingshop) ->
    true;
is_record(pbsendgiftsmsg) ->
    true;
is_record(pbserverstatus) ->
    true;
is_record(pbshopbuy) ->
    true;
is_record(pbshopitem) ->
    true;
is_record(pbshopmsg) ->
    true;
is_record(pbsigil) ->
    true;
is_record(pbskill) ->
    true;
is_record(pbskillid) ->
    true;
is_record(pbskillidlist) ->
    true;
is_record(pbskilllist) ->
    true;
is_record(pbsmriti) ->
    true;
is_record(pbsourcedungeon) ->
    true;
is_record(pbsourcedungeoninfo) ->
    true;
is_record(pbstartcombat) ->
    true;
is_record(pbsteriousshop) ->
    true;
is_record(pbstoreproduct) ->
    true;
is_record(pbstoreproductlist) ->
    true;
is_record(pbsubdungeon) ->
    true;
is_record(pbtask) ->
    true;
is_record(pbtasklist) ->
    true;
is_record(pbteam) ->
    true;
is_record(pbteamchat) ->
    true;
is_record(pbtwistegg) ->
    true;
is_record(pbtwistegglist) ->
    true;
is_record(pbupgradeskillcard) ->
    true;
is_record(pbuser) ->
    true;
is_record(pbuserlist) ->
    true;
is_record(pbuserloginfashioninfo) ->
    true;
is_record(pbuserlogininfo) ->
    true;
is_record(pbusernotifyupdate) ->
    true;
is_record(pbuserresult) ->
    true;
is_record(pbvipreward) ->
    true;
is_record(pbwavecreature) ->
    true;
is_record(pbwavemonster) ->
    true;
is_record(pbwinrate) ->
    true;
is_record(pbworldboss) ->
    true;
is_record(player) ->
    true;
is_record(player_buff) ->
    true;
is_record(player_camp) ->
    true;
is_record(player_cost_state) ->
    true;
is_record(player_count) ->
    true;
is_record(player_dungeon_match) ->
    true;
is_record(player_goods) ->
    true;
is_record(player_info) ->
    true;
is_record(player_month_sign) ->
    true;
is_record(player_other) ->
    true;
is_record(player_pid) ->
    true;
is_record(player_response) ->
    true;
is_record(player_skill) ->
    true;
is_record(player_skill_record) ->
    true;
is_record(private_msg) ->
    true;
is_record(radar_msg) ->
    true;
is_record(rank) ->
    true;
is_record(rank_reset_info) ->
    true;
is_record(record_mysql_info) ->
    true;
is_record(relationship) ->
    true;
is_record(request_gifts_msg) ->
    true;
is_record(response) ->
    true;
is_record(reward_item) ->
    true;
is_record(scheme) ->
    true;
is_record(server_config) ->
    true;
is_record(service) ->
    true;
is_record(service_proc) ->
    true;
is_record(service_proc_param) ->
    true;
is_record(skyrush) ->
    true;
is_record(source_dungeon) ->
    true;
is_record(state) ->
    true;
is_record(sterious_shop) ->
    true;
is_record(super_battle) ->
    true;
is_record(sync_arena_rank) ->
    true;
is_record(sync_arena_report) ->
    true;
is_record(sys_acm_checker) ->
    true;
is_record(task) ->
    true;
is_record(team) ->
    true;
is_record(trial_data) ->
    true;
is_record(udp_server_option) ->
    true;
is_record(url_mini) ->
    true;
is_record(vice_shop) ->
    true;
is_record(vip_reward) ->
    true;
is_record(_) ->
 false.
get_fields(abs_path) ->
    record_info(fields, abs_path);
get_fields(account_info) ->
    record_info(fields, account_info);
get_fields(achieve_data) ->
    record_info(fields, achieve_data);
get_fields(activity_shop_msg) ->
    record_info(fields, activity_shop_msg);
get_fields(activity_shop_record) ->
    record_info(fields, activity_shop_record);
get_fields(advance_reward) ->
    record_info(fields, advance_reward);
get_fields(async_arena_rank) ->
    record_info(fields, async_arena_rank);
get_fields(async_arena_report) ->
    record_info(fields, async_arena_report);
get_fields(attribute) ->
    record_info(fields, attribute);
get_fields(attribute_info) ->
    record_info(fields, attribute_info);
get_fields(base_ability) ->
    record_info(fields, base_ability);
get_fields(base_activity_twist_egg) ->
    record_info(fields, base_activity_twist_egg);
get_fields(base_advance_reward) ->
    record_info(fields, base_advance_reward);
get_fields(base_boss) ->
    record_info(fields, base_boss);
get_fields(base_choujiang) ->
    record_info(fields, base_choujiang);
get_fields(base_combat_buff) ->
    record_info(fields, base_combat_buff);
get_fields(base_combat_skill) ->
    record_info(fields, base_combat_skill);
get_fields(base_combat_skill_passive) ->
    record_info(fields, base_combat_skill_passive);
get_fields(base_combat_skill_strengthen) ->
    record_info(fields, base_combat_skill_strengthen);
get_fields(base_combat_skill_upgrade) ->
    record_info(fields, base_combat_skill_upgrade);
get_fields(base_competitive_main_shop) ->
    record_info(fields, base_competitive_main_shop);
get_fields(base_competitive_vice_shop) ->
    record_info(fields, base_competitive_vice_shop);
get_fields(base_daily_dungeon_condition) ->
    record_info(fields, base_daily_dungeon_condition);
get_fields(base_daily_dungeon_info) ->
    record_info(fields, base_daily_dungeon_info);
get_fields(base_daily_dungeon_lv) ->
    record_info(fields, base_daily_dungeon_lv);
get_fields(base_dungeon_area) ->
    record_info(fields, base_dungeon_area);
get_fields(base_dungeon_create_monster) ->
    record_info(fields, base_dungeon_create_monster);
get_fields(base_dungeon_create_object) ->
    record_info(fields, base_dungeon_create_object);
get_fields(base_dungeon_create_portal) ->
    record_info(fields, base_dungeon_create_portal);
get_fields(base_dungeon_detail) ->
    record_info(fields, base_dungeon_detail);
get_fields(base_dungeon_match) ->
    record_info(fields, base_dungeon_match);
get_fields(base_dungeon_monsters_attribute) ->
    record_info(fields, base_dungeon_monsters_attribute);
get_fields(base_dungeon_object_attribute) ->
    record_info(fields, base_dungeon_object_attribute);
get_fields(base_dungeon_target) ->
    record_info(fields, base_dungeon_target);
get_fields(base_dungeon_world_boss) ->
    record_info(fields, base_dungeon_world_boss);
get_fields(base_error_list) ->
    record_info(fields, base_error_list);
get_fields(base_fashion_combination) ->
    record_info(fields, base_fashion_combination);
get_fields(base_function_open) ->
    record_info(fields, base_function_open);
get_fields(base_general_store) ->
    record_info(fields, base_general_store);
get_fields(base_goods) ->
    record_info(fields, base_goods);
get_fields(base_goods_att_color) ->
    record_info(fields, base_goods_att_color);
get_fields(base_goods_att_lv) ->
    record_info(fields, base_goods_att_lv);
get_fields(base_goods_att_rand) ->
    record_info(fields, base_goods_att_rand);
get_fields(base_goods_color_hole) ->
    record_info(fields, base_goods_color_hole);
get_fields(base_goods_jewel) ->
    record_info(fields, base_goods_jewel);
get_fields(base_goods_strengthen) ->
    record_info(fields, base_goods_strengthen);
get_fields(base_guild_lv_exp) ->
    record_info(fields, base_guild_lv_exp);
get_fields(base_guild_rank_integral) ->
    record_info(fields, base_guild_rank_integral);
get_fields(base_kuafupvp_battle_reward) ->
    record_info(fields, base_kuafupvp_battle_reward);
get_fields(base_kuafupvp_rank_reward) ->
    record_info(fields, base_kuafupvp_rank_reward);
get_fields(base_kuafupvp_robot_attribute) ->
    record_info(fields, base_kuafupvp_robot_attribute);
get_fields(base_log_user) ->
    record_info(fields, base_log_user);
get_fields(base_login_reward) ->
    record_info(fields, base_login_reward);
get_fields(base_mail) ->
    record_info(fields, base_mail);
get_fields(base_monster_level_attribute) ->
    record_info(fields, base_monster_level_attribute);
get_fields(base_month_reward) ->
    record_info(fields, base_month_reward);
get_fields(base_mugen_tower) ->
    record_info(fields, base_mugen_tower);
get_fields(base_mysterious_shop) ->
    record_info(fields, base_mysterious_shop);
get_fields(base_notice) ->
    record_info(fields, base_notice);
get_fields(base_operators_mail) ->
    record_info(fields, base_operators_mail);
get_fields(base_params) ->
    record_info(fields, base_params);
get_fields(base_pvp_battle_reward) ->
    record_info(fields, base_pvp_battle_reward);
get_fields(base_pvp_rank_reward) ->
    record_info(fields, base_pvp_rank_reward);
get_fields(base_pvp_robot_attribute) ->
    record_info(fields, base_pvp_robot_attribute);
get_fields(base_qianguizhe) ->
    record_info(fields, base_qianguizhe);
get_fields(base_rank_reward) ->
    record_info(fields, base_rank_reward);
get_fields(base_rate) ->
    record_info(fields, base_rate);
get_fields(base_shop) ->
    record_info(fields, base_shop);
get_fields(base_shop_activity) ->
    record_info(fields, base_shop_activity);
get_fields(base_shop_content) ->
    record_info(fields, base_shop_content);
get_fields(base_skill_card) ->
    record_info(fields, base_skill_card);
get_fields(base_skill_exp) ->
    record_info(fields, base_skill_exp);
get_fields(base_store_product) ->
    record_info(fields, base_store_product);
get_fields(base_task) ->
    record_info(fields, base_task);
get_fields(base_twist_egg) ->
    record_info(fields, base_twist_egg);
get_fields(base_vip) ->
    record_info(fields, base_vip);
get_fields(base_vip_cost) ->
    record_info(fields, base_vip_cost);
get_fields(base_xunzhang) ->
    record_info(fields, base_xunzhang);
get_fields(battle_attribute) ->
    record_info(fields, battle_attribute);
get_fields(bossinfo) ->
    record_info(fields, bossinfo);
get_fields(camp) ->
    record_info(fields, camp);
get_fields(chat_league) ->
    record_info(fields, chat_league);
get_fields(chat_private) ->
    record_info(fields, chat_private);
get_fields(chats_world) ->
    record_info(fields, chats_world);
get_fields(choujiang_info) ->
    record_info(fields, choujiang_info);
get_fields(client) ->
    record_info(fields, client);
get_fields(collect_status) ->
    record_info(fields, collect_status);
get_fields(combat_attri) ->
    record_info(fields, combat_attri);
get_fields(common_reward) ->
    record_info(fields, common_reward);
get_fields(count_record) ->
    record_info(fields, count_record);
get_fields(counter) ->
    record_info(fields, counter);
get_fields(cross_pvp_enemy) ->
    record_info(fields, cross_pvp_enemy);
get_fields(cross_pvp_event) ->
    record_info(fields, cross_pvp_event);
get_fields(cross_pvp_fighter) ->
    record_info(fields, cross_pvp_fighter);
get_fields(cross_pvp_island) ->
    record_info(fields, cross_pvp_island);
get_fields(cross_pvp_npc) ->
    record_info(fields, cross_pvp_npc);
get_fields(cross_pvp_record) ->
    record_info(fields, cross_pvp_record);
get_fields(ct_robot) ->
    record_info(fields, ct_robot);
get_fields(daily_dungeon) ->
    record_info(fields, daily_dungeon);
get_fields(data_base_activity) ->
    record_info(fields, data_base_activity);
get_fields(data_base_fashion) ->
    record_info(fields, data_base_fashion);
get_fields(data_mon) ->
    record_info(fields, data_mon);
get_fields(defend_point) ->
    record_info(fields, defend_point);
get_fields(df_elem) ->
    record_info(fields, df_elem);
get_fields(dungeon) ->
    record_info(fields, dungeon);
get_fields(dungeon_info) ->
    record_info(fields, dungeon_info);
get_fields(dungeon_match) ->
    record_info(fields, dungeon_match);
get_fields(dungeon_mop_up) ->
    record_info(fields, dungeon_mop_up);
get_fields(dungeon_mugen) ->
    record_info(fields, dungeon_mugen);
get_fields(dungeon_rewards) ->
    record_info(fields, dungeon_rewards);
get_fields(dungeon_schedule) ->
    record_info(fields, dungeon_schedule);
get_fields(emo_query) ->
    record_info(fields, emo_query);
get_fields(equip_attribute) ->
    record_info(fields, equip_attribute);
get_fields(error_msg) ->
    record_info(fields, error_msg);
get_fields(ets_base_app_store_product) ->
    record_info(fields, ets_base_app_store_product);
get_fields(ets_base_equipment) ->
    record_info(fields, ets_base_equipment);
get_fields(ets_base_equipment_property) ->
    record_info(fields, ets_base_equipment_property);
get_fields(ets_base_equipment_upgrade) ->
    record_info(fields, ets_base_equipment_upgrade);
get_fields(ets_base_login_gift) ->
    record_info(fields, ets_base_login_gift);
get_fields(ets_base_mon) ->
    record_info(fields, ets_base_mon);
get_fields(ets_base_online_gift) ->
    record_info(fields, ets_base_online_gift);
get_fields(ets_base_player) ->
    record_info(fields, ets_base_player);
get_fields(ets_base_protocol) ->
    record_info(fields, ets_base_protocol);
get_fields(ets_base_sys_acm) ->
    record_info(fields, ets_base_sys_acm);
get_fields(ets_log_mail) ->
    record_info(fields, ets_log_mail);
get_fields(ets_pay_info) ->
    record_info(fields, ets_pay_info);
get_fields(ets_process) ->
    record_info(fields, ets_process);
get_fields(ets_push_schedule) ->
    record_info(fields, ets_push_schedule);
get_fields(ets_shop_goods) ->
    record_info(fields, ets_shop_goods);
get_fields(fashion) ->
    record_info(fields, fashion);
get_fields(fashion_record) ->
    record_info(fields, fashion_record);
get_fields(field) ->
    record_info(fields, field);
get_fields(fight_league) ->
    record_info(fields, fight_league);
get_fields(fight_league_copy) ->
    record_info(fields, fight_league_copy);
get_fields(fight_member) ->
    record_info(fields, fight_member);
get_fields(fight_record) ->
    record_info(fields, fight_record);
get_fields(fns_elem) ->
    record_info(fields, fns_elem);
get_fields(g17_guild) ->
    record_info(fields, g17_guild);
get_fields(g17_guild_apply) ->
    record_info(fields, g17_guild_apply);
get_fields(g17_guild_member) ->
    record_info(fields, g17_guild_member);
get_fields(g_feats_elem) ->
    record_info(fields, g_feats_elem);
get_fields(gateway_agent) ->
    record_info(fields, gateway_agent);
get_fields(gateway_client) ->
    record_info(fields, gateway_client);
get_fields(general_store) ->
    record_info(fields, general_store);
get_fields(generate_conf) ->
    record_info(fields, generate_conf);
get_fields(goods) ->
    record_info(fields, goods);
get_fields(guild_mem_skyrush_rank) ->
    record_info(fields, guild_mem_skyrush_rank);
get_fields(guild_skyrush_rank) ->
    record_info(fields, guild_skyrush_rank);
get_fields(help_battle) ->
    record_info(fields, help_battle);
get_fields(hold_info) ->
    record_info(fields, hold_info);
get_fields(http_request) ->
    record_info(fields, http_request);
get_fields(http_response) ->
    record_info(fields, http_response);
get_fields(init_data) ->
    record_info(fields, init_data);
get_fields(league) ->
    record_info(fields, league);
get_fields(league_apply_info) ->
    record_info(fields, league_apply_info);
get_fields(league_challenge_record) ->
    record_info(fields, league_challenge_record);
get_fields(league_fight_point) ->
    record_info(fields, league_fight_point);
get_fields(league_fight_state) ->
    record_info(fields, league_fight_state);
get_fields(league_gifts) ->
    record_info(fields, league_gifts);
get_fields(league_gifts_record) ->
    record_info(fields, league_gifts_record);
get_fields(league_member) ->
    record_info(fields, league_member);
get_fields(league_member_challenge) ->
    record_info(fields, league_member_challenge);
get_fields(league_msg) ->
    record_info(fields, league_msg);
get_fields(league_recharge_gold_record) ->
    record_info(fields, league_recharge_gold_record);
get_fields(league_relation) ->
    record_info(fields, league_relation);
get_fields(log_device) ->
    record_info(fields, log_device);
get_fields(log_login) ->
    record_info(fields, log_login);
get_fields(log_player) ->
    record_info(fields, log_player);
get_fields(log_player_chat) ->
    record_info(fields, log_player_chat);
get_fields(log_player_create) ->
    record_info(fields, log_player_create);
get_fields(log_player_feedback) ->
    record_info(fields, log_player_feedback);
get_fields(log_player_login) ->
    record_info(fields, log_player_login);
get_fields(log_player_mini) ->
    record_info(fields, log_player_mini);
get_fields(log_player_online) ->
    record_info(fields, log_player_online);
get_fields(log_state) ->
    record_info(fields, log_state);
get_fields(log_system) ->
    record_info(fields, log_system);
get_fields(log_twist_eggs) ->
    record_info(fields, log_twist_eggs);
get_fields(log_uplevel) ->
    record_info(fields, log_uplevel);
get_fields(lucky_coin) ->
    record_info(fields, lucky_coin);
get_fields(mails) ->
    record_info(fields, mails);
get_fields(main_shop) ->
    record_info(fields, main_shop);
get_fields(main_shop_msg) ->
    record_info(fields, main_shop_msg);
get_fields(master_apprentice) ->
    record_info(fields, master_apprentice);
get_fields(master_request_msg) ->
    record_info(fields, master_request_msg);
get_fields(mdb_challenge_info) ->
    record_info(fields, mdb_challenge_info);
get_fields(mdb_dungeon_info) ->
    record_info(fields, mdb_dungeon_info);
get_fields(mdb_shop_msg) ->
    record_info(fields, mdb_shop_msg);
get_fields(mem_feats_elem) ->
    record_info(fields, mem_feats_elem);
get_fields(member) ->
    record_info(fields, member);
get_fields(mnesia_upgrade_conf) ->
    record_info(fields, mnesia_upgrade_conf);
get_fields(mod) ->
    record_info(fields, mod);
get_fields(mod_player_state) ->
    record_info(fields, mod_player_state);
get_fields(mugen_reward) ->
    record_info(fields, mugen_reward);
get_fields(node_status) ->
    record_info(fields, node_status);
get_fields(open_boss_rank) ->
    record_info(fields, open_boss_rank);
get_fields(operators_mail) ->
    record_info(fields, operators_mail);
get_fields(ordinary_shop) ->
    record_info(fields, ordinary_shop);
get_fields(ordinary_shop_msg) ->
    record_info(fields, ordinary_shop_msg);
get_fields(own_gift) ->
    record_info(fields, own_gift);
get_fields(pass_dungeon_info) ->
    record_info(fields, pass_dungeon_info);
get_fields(pay_gifts) ->
    record_info(fields, pay_gifts);
get_fields(pay_info) ->
    record_info(fields, pay_info);
get_fields(pbaccount) ->
    record_info(fields, pbaccount);
get_fields(pbaccountlogin) ->
    record_info(fields, pbaccountlogin);
get_fields(pbactivity) ->
    record_info(fields, pbactivity);
get_fields(pbactivitylist) ->
    record_info(fields, pbactivitylist);
get_fields(pbactivityshop) ->
    record_info(fields, pbactivityshop);
get_fields(pbactivityshopmsg) ->
    record_info(fields, pbactivityshopmsg);
get_fields(pbaddleaguemsg) ->
    record_info(fields, pbaddleaguemsg);
get_fields(pballmasterinfo) ->
    record_info(fields, pballmasterinfo);
get_fields(pbappointplayer) ->
    record_info(fields, pbappointplayer);
get_fields(pbapprenticebuycard) ->
    record_info(fields, pbapprenticebuycard);
get_fields(pbapprenticecard) ->
    record_info(fields, pbapprenticecard);
get_fields(pbapprenticerequestinfo) ->
    record_info(fields, pbapprenticerequestinfo);
get_fields(pbarenabattlereport) ->
    record_info(fields, pbarenabattlereport);
get_fields(pbarenabattlereportlist) ->
    record_info(fields, pbarenabattlereportlist);
get_fields(pbarenachallenge) ->
    record_info(fields, pbarenachallenge);
get_fields(pbarenainfo) ->
    record_info(fields, pbarenainfo);
get_fields(pbarenainfolist) ->
    record_info(fields, pbarenainfolist);
get_fields(pbarenauser) ->
    record_info(fields, pbarenauser);
get_fields(pbarenauserlist) ->
    record_info(fields, pbarenauserlist);
get_fields(pbattribute) ->
    record_info(fields, pbattribute);
get_fields(pbbossinvitemsg) ->
    record_info(fields, pbbossinvitemsg);
get_fields(pbbosslist) ->
    record_info(fields, pbbosslist);
get_fields(pbbosssendgold) ->
    record_info(fields, pbbosssendgold);
get_fields(pbcamp) ->
    record_info(fields, pbcamp);
get_fields(pbcamppos) ->
    record_info(fields, pbcamppos);
get_fields(pbcardinfo) ->
    record_info(fields, pbcardinfo);
get_fields(pbcardrequest) ->
    record_info(fields, pbcardrequest);
get_fields(pbcardrequestlist) ->
    record_info(fields, pbcardrequestlist);
get_fields(pbcdkreward) ->
    record_info(fields, pbcdkreward);
get_fields(pbchallengedungeon) ->
    record_info(fields, pbchallengedungeon);
get_fields(pbchallengedungeoninfo) ->
    record_info(fields, pbchallengedungeoninfo);
get_fields(pbchallengedungeonrank) ->
    record_info(fields, pbchallengedungeonrank);
get_fields(pbchallengerecord) ->
    record_info(fields, pbchallengerecord);
get_fields(pbchallengerecordlist) ->
    record_info(fields, pbchallengerecordlist);
get_fields(pbchat) ->
    record_info(fields, pbchat);
get_fields(pbchatlist) ->
    record_info(fields, pbchatlist);
get_fields(pbchoujiang) ->
    record_info(fields, pbchoujiang);
get_fields(pbchoujianggoods) ->
    record_info(fields, pbchoujianggoods);
get_fields(pbchoujianginfo) ->
    record_info(fields, pbchoujianginfo);
get_fields(pbchoujiangresult) ->
    record_info(fields, pbchoujiangresult);
get_fields(pbcombatbuff) ->
    record_info(fields, pbcombatbuff);
get_fields(pbcombateffect) ->
    record_info(fields, pbcombateffect);
get_fields(pbcombatfighter) ->
    record_info(fields, pbcombatfighter);
get_fields(pbcombathurtattri) ->
    record_info(fields, pbcombathurtattri);
get_fields(pbcombatreport) ->
    record_info(fields, pbcombatreport);
get_fields(pbcombatreportlist) ->
    record_info(fields, pbcombatreportlist);
get_fields(pbcombatrespon) ->
    record_info(fields, pbcombatrespon);
get_fields(pbcombatreward) ->
    record_info(fields, pbcombatreward);
get_fields(pbcombatround) ->
    record_info(fields, pbcombatround);
get_fields(pbcombattarget) ->
    record_info(fields, pbcombattarget);
get_fields(pbcountrecord) ->
    record_info(fields, pbcountrecord);
get_fields(pbcountrecords) ->
    record_info(fields, pbcountrecords);
get_fields(pbcreatearole) ->
    record_info(fields, pbcreatearole);
get_fields(pbcreaturedrop) ->
    record_info(fields, pbcreaturedrop);
get_fields(pbcritmsg) ->
    record_info(fields, pbcritmsg);
get_fields(pbcrossfighter) ->
    record_info(fields, pbcrossfighter);
get_fields(pbcrosshistory) ->
    record_info(fields, pbcrosshistory);
get_fields(pbcrosshistorylist) ->
    record_info(fields, pbcrosshistorylist);
get_fields(pbcrossisland) ->
    record_info(fields, pbcrossisland);
get_fields(pbcrossrecord) ->
    record_info(fields, pbcrossrecord);
get_fields(pbdailydungeon) ->
    record_info(fields, pbdailydungeon);
get_fields(pbdungeon) ->
    record_info(fields, pbdungeon);
get_fields(pbdungeoncondition) ->
    record_info(fields, pbdungeoncondition);
get_fields(pbdungeoncreature) ->
    record_info(fields, pbdungeoncreature);
get_fields(pbdungeonmonster) ->
    record_info(fields, pbdungeonmonster);
get_fields(pbdungeonreward) ->
    record_info(fields, pbdungeonreward);
get_fields(pbdungeonschedule) ->
    record_info(fields, pbdungeonschedule);
get_fields(pbdungeonschedulelist) ->
    record_info(fields, pbdungeonschedulelist);
get_fields(pbdungeontarget) ->
    record_info(fields, pbdungeontarget);
get_fields(pbequipaddstar) ->
    record_info(fields, pbequipaddstar);
get_fields(pbequipmove) ->
    record_info(fields, pbequipmove);
get_fields(pbequipstrengthen) ->
    record_info(fields, pbequipstrengthen);
get_fields(pberror) ->
    record_info(fields, pberror);
get_fields(pbfashion) ->
    record_info(fields, pbfashion);
get_fields(pbfashionlist) ->
    record_info(fields, pbfashionlist);
get_fields(pbfeedbackmsg) ->
    record_info(fields, pbfeedbackmsg);
get_fields(pbfightrecords) ->
    record_info(fields, pbfightrecords);
get_fields(pbflipcard) ->
    record_info(fields, pbflipcard);
get_fields(pbfriend) ->
    record_info(fields, pbfriend);
get_fields(pbfriendlist) ->
    record_info(fields, pbfriendlist);
get_fields(pbg17guild) ->
    record_info(fields, pbg17guild);
get_fields(pbg17guildlist) ->
    record_info(fields, pbg17guildlist);
get_fields(pbg17guildmember) ->
    record_info(fields, pbg17guildmember);
get_fields(pbg17guildquery) ->
    record_info(fields, pbg17guildquery);
get_fields(pbgeneralstorebuy) ->
    record_info(fields, pbgeneralstorebuy);
get_fields(pbgeneralstoreinfo) ->
    record_info(fields, pbgeneralstoreinfo);
get_fields(pbgetleague) ->
    record_info(fields, pbgetleague);
get_fields(pbgetleaguegrouprankinfo) ->
    record_info(fields, pbgetleaguegrouprankinfo);
get_fields(pbgetleaguestatu) ->
    record_info(fields, pbgetleaguestatu);
get_fields(pbgetpointrecord) ->
    record_info(fields, pbgetpointrecord);
get_fields(pbgiftsid) ->
    record_info(fields, pbgiftsid);
get_fields(pbgiftsrecord) ->
    record_info(fields, pbgiftsrecord);
get_fields(pbgiftsrecordlist) ->
    record_info(fields, pbgiftsrecordlist);
get_fields(pbgoods) ->
    record_info(fields, pbgoods);
get_fields(pbgoodschanged) ->
    record_info(fields, pbgoodschanged);
get_fields(pbgoodsinfo) ->
    record_info(fields, pbgoodsinfo);
get_fields(pbgoodslist) ->
    record_info(fields, pbgoodslist);
get_fields(pbhitrewarddetail) ->
    record_info(fields, pbhitrewarddetail);
get_fields(pbid32) ->
    record_info(fields, pbid32);
get_fields(pbid32r) ->
    record_info(fields, pbid32r);
get_fields(pbid64) ->
    record_info(fields, pbid64);
get_fields(pbid64list) ->
    record_info(fields, pbid64list);
get_fields(pbid64r) ->
    record_info(fields, pbid64r);
get_fields(pbidstring) ->
    record_info(fields, pbidstring);
get_fields(pbinlaidjewel) ->
    record_info(fields, pbinlaidjewel);
get_fields(pbleagifts) ->
    record_info(fields, pbleagifts);
get_fields(pbleague) ->
    record_info(fields, pbleague);
get_fields(pbleaguechallengeinfo) ->
    record_info(fields, pbleaguechallengeinfo);
get_fields(pbleaguechallengelist) ->
    record_info(fields, pbleaguechallengelist);
get_fields(pbleaguechallengeresult) ->
    record_info(fields, pbleaguechallengeresult);
get_fields(pbleaguefightpoint) ->
    record_info(fields, pbleaguefightpoint);
get_fields(pbleaguefightpointlist) ->
    record_info(fields, pbleaguefightpointlist);
get_fields(pbleaguefightrankinfo) ->
    record_info(fields, pbleaguefightrankinfo);
get_fields(pbleaguegifts) ->
    record_info(fields, pbleaguegifts);
get_fields(pbleaguehouse) ->
    record_info(fields, pbleaguehouse);
get_fields(pbleaguehouserecord) ->
    record_info(fields, pbleaguehouserecord);
get_fields(pbleagueinfo) ->
    record_info(fields, pbleagueinfo);
get_fields(pbleagueinfolist) ->
    record_info(fields, pbleagueinfolist);
get_fields(pbleaguelist) ->
    record_info(fields, pbleaguelist);
get_fields(pbleaguemember) ->
    record_info(fields, pbleaguemember);
get_fields(pbleaguememberlist) ->
    record_info(fields, pbleaguememberlist);
get_fields(pbleaguepointchallengeresult) ->
    record_info(fields, pbleaguepointchallengeresult);
get_fields(pbleaguerankinfo) ->
    record_info(fields, pbleaguerankinfo);
get_fields(pbleagueranklist) ->
    record_info(fields, pbleagueranklist);
get_fields(pbmail) ->
    record_info(fields, pbmail);
get_fields(pbmailgoods) ->
    record_info(fields, pbmailgoods);
get_fields(pbmaillist) ->
    record_info(fields, pbmaillist);
get_fields(pbmasteragreemsg) ->
    record_info(fields, pbmasteragreemsg);
get_fields(pbmastercard) ->
    record_info(fields, pbmastercard);
get_fields(pbmasterinfo) ->
    record_info(fields, pbmasterinfo);
get_fields(pbmember) ->
    record_info(fields, pbmember);
get_fields(pbmembergetlisttype) ->
    record_info(fields, pbmembergetlisttype);
get_fields(pbmembersendlist) ->
    record_info(fields, pbmembersendlist);
get_fields(pbmembersendmsg) ->
    record_info(fields, pbmembersendmsg);
get_fields(pbmonsterdrop) ->
    record_info(fields, pbmonsterdrop);
get_fields(pbmopup) ->
    record_info(fields, pbmopup);
get_fields(pbmopuplist) ->
    record_info(fields, pbmopuplist);
get_fields(pbmugenchallenge) ->
    record_info(fields, pbmugenchallenge);
get_fields(pbnewiteminfo) ->
    record_info(fields, pbnewiteminfo);
get_fields(pbnewmsg) ->
    record_info(fields, pbnewmsg);
get_fields(pbnotice) ->
    record_info(fields, pbnotice);
get_fields(pbnoticelist) ->
    record_info(fields, pbnoticelist);
get_fields(pbnull) ->
    record_info(fields, pbnull);
get_fields(pbonekeysendmsg) ->
    record_info(fields, pbonekeysendmsg);
get_fields(pbopenboss) ->
    record_info(fields, pbopenboss);
get_fields(pbordinarybuy) ->
    record_info(fields, pbordinarybuy);
get_fields(pbowncardsinfo) ->
    record_info(fields, pbowncardsinfo);
get_fields(pbowngifts) ->
    record_info(fields, pbowngifts);
get_fields(pbplayerachieve) ->
    record_info(fields, pbplayerachieve);
get_fields(pbplayerachievelist) ->
    record_info(fields, pbplayerachievelist);
get_fields(pbplayercamp) ->
    record_info(fields, pbplayercamp);
get_fields(pbplayergifts) ->
    record_info(fields, pbplayergifts);
get_fields(pbpointchallengerecord) ->
    record_info(fields, pbpointchallengerecord);
get_fields(pbpointchallengerecordinfo) ->
    record_info(fields, pbpointchallengerecordinfo);
get_fields(pbpointprotectlist) ->
    record_info(fields, pbpointprotectlist);
get_fields(pbpointsend) ->
    record_info(fields, pbpointsend);
get_fields(pbpointsendmsg) ->
    record_info(fields, pbpointsendmsg);
get_fields(pbpointsendmsglist) ->
    record_info(fields, pbpointsendmsglist);
get_fields(pbprivate) ->
    record_info(fields, pbprivate);
get_fields(pbprotectinfo) ->
    record_info(fields, pbprotectinfo);
get_fields(pbprotectplayerinfo) ->
    record_info(fields, pbprotectplayerinfo);
get_fields(pbpvprobotattr) ->
    record_info(fields, pbpvprobotattr);
get_fields(pbrank) ->
    record_info(fields, pbrank);
get_fields(pbrankinfo) ->
    record_info(fields, pbrankinfo);
get_fields(pbranklist) ->
    record_info(fields, pbranklist);
get_fields(pbrc4) ->
    record_info(fields, pbrc4);
get_fields(pbrequestgiftsmsg) ->
    record_info(fields, pbrequestgiftsmsg);
get_fields(pbrequestgiftsmsglist) ->
    record_info(fields, pbrequestgiftsmsglist);
get_fields(pbrequestplayergiftsmsg) ->
    record_info(fields, pbrequestplayergiftsmsg);
get_fields(pbrequestplayergiftsmsglist) ->
    record_info(fields, pbrequestplayergiftsmsglist);
get_fields(pbresult) ->
    record_info(fields, pbresult);
get_fields(pbreward) ->
    record_info(fields, pbreward);
get_fields(pbrewarditem) ->
    record_info(fields, pbrewarditem);
get_fields(pbrewardlist) ->
    record_info(fields, pbrewardlist);
get_fields(pbsellinglist) ->
    record_info(fields, pbsellinglist);
get_fields(pbsellingshop) ->
    record_info(fields, pbsellingshop);
get_fields(pbsendgiftsmsg) ->
    record_info(fields, pbsendgiftsmsg);
get_fields(pbserverstatus) ->
    record_info(fields, pbserverstatus);
get_fields(pbshopbuy) ->
    record_info(fields, pbshopbuy);
get_fields(pbshopitem) ->
    record_info(fields, pbshopitem);
get_fields(pbshopmsg) ->
    record_info(fields, pbshopmsg);
get_fields(pbsigil) ->
    record_info(fields, pbsigil);
get_fields(pbskill) ->
    record_info(fields, pbskill);
get_fields(pbskillid) ->
    record_info(fields, pbskillid);
get_fields(pbskillidlist) ->
    record_info(fields, pbskillidlist);
get_fields(pbskilllist) ->
    record_info(fields, pbskilllist);
get_fields(pbsmriti) ->
    record_info(fields, pbsmriti);
get_fields(pbsourcedungeon) ->
    record_info(fields, pbsourcedungeon);
get_fields(pbsourcedungeoninfo) ->
    record_info(fields, pbsourcedungeoninfo);
get_fields(pbstartcombat) ->
    record_info(fields, pbstartcombat);
get_fields(pbsteriousshop) ->
    record_info(fields, pbsteriousshop);
get_fields(pbstoreproduct) ->
    record_info(fields, pbstoreproduct);
get_fields(pbstoreproductlist) ->
    record_info(fields, pbstoreproductlist);
get_fields(pbsubdungeon) ->
    record_info(fields, pbsubdungeon);
get_fields(pbtask) ->
    record_info(fields, pbtask);
get_fields(pbtasklist) ->
    record_info(fields, pbtasklist);
get_fields(pbteam) ->
    record_info(fields, pbteam);
get_fields(pbteamchat) ->
    record_info(fields, pbteamchat);
get_fields(pbtwistegg) ->
    record_info(fields, pbtwistegg);
get_fields(pbtwistegglist) ->
    record_info(fields, pbtwistegglist);
get_fields(pbupgradeskillcard) ->
    record_info(fields, pbupgradeskillcard);
get_fields(pbuser) ->
    record_info(fields, pbuser);
get_fields(pbuserlist) ->
    record_info(fields, pbuserlist);
get_fields(pbuserloginfashioninfo) ->
    record_info(fields, pbuserloginfashioninfo);
get_fields(pbuserlogininfo) ->
    record_info(fields, pbuserlogininfo);
get_fields(pbusernotifyupdate) ->
    record_info(fields, pbusernotifyupdate);
get_fields(pbuserresult) ->
    record_info(fields, pbuserresult);
get_fields(pbvipreward) ->
    record_info(fields, pbvipreward);
get_fields(pbwavecreature) ->
    record_info(fields, pbwavecreature);
get_fields(pbwavemonster) ->
    record_info(fields, pbwavemonster);
get_fields(pbwinrate) ->
    record_info(fields, pbwinrate);
get_fields(pbworldboss) ->
    record_info(fields, pbworldboss);
get_fields(player) ->
    record_info(fields, player);
get_fields(player_buff) ->
    record_info(fields, player_buff);
get_fields(player_camp) ->
    record_info(fields, player_camp);
get_fields(player_cost_state) ->
    record_info(fields, player_cost_state);
get_fields(player_count) ->
    record_info(fields, player_count);
get_fields(player_dungeon_match) ->
    record_info(fields, player_dungeon_match);
get_fields(player_goods) ->
    record_info(fields, player_goods);
get_fields(player_info) ->
    record_info(fields, player_info);
get_fields(player_month_sign) ->
    record_info(fields, player_month_sign);
get_fields(player_other) ->
    record_info(fields, player_other);
get_fields(player_pid) ->
    record_info(fields, player_pid);
get_fields(player_response) ->
    record_info(fields, player_response);
get_fields(player_skill) ->
    record_info(fields, player_skill);
get_fields(player_skill_record) ->
    record_info(fields, player_skill_record);
get_fields(private_msg) ->
    record_info(fields, private_msg);
get_fields(radar_msg) ->
    record_info(fields, radar_msg);
get_fields(rank) ->
    record_info(fields, rank);
get_fields(rank_reset_info) ->
    record_info(fields, rank_reset_info);
get_fields(record_mysql_info) ->
    record_info(fields, record_mysql_info);
get_fields(relationship) ->
    record_info(fields, relationship);
get_fields(request_gifts_msg) ->
    record_info(fields, request_gifts_msg);
get_fields(response) ->
    record_info(fields, response);
get_fields(reward_item) ->
    record_info(fields, reward_item);
get_fields(scheme) ->
    record_info(fields, scheme);
get_fields(server_config) ->
    record_info(fields, server_config);
get_fields(service) ->
    record_info(fields, service);
get_fields(service_proc) ->
    record_info(fields, service_proc);
get_fields(service_proc_param) ->
    record_info(fields, service_proc_param);
get_fields(skyrush) ->
    record_info(fields, skyrush);
get_fields(source_dungeon) ->
    record_info(fields, source_dungeon);
get_fields(state) ->
    record_info(fields, state);
get_fields(sterious_shop) ->
    record_info(fields, sterious_shop);
get_fields(super_battle) ->
    record_info(fields, super_battle);
get_fields(sync_arena_rank) ->
    record_info(fields, sync_arena_rank);
get_fields(sync_arena_report) ->
    record_info(fields, sync_arena_report);
get_fields(sys_acm_checker) ->
    record_info(fields, sys_acm_checker);
get_fields(task) ->
    record_info(fields, task);
get_fields(team) ->
    record_info(fields, team);
get_fields(trial_data) ->
    record_info(fields, trial_data);
get_fields(udp_server_option) ->
    record_info(fields, udp_server_option);
get_fields(url_mini) ->
    record_info(fields, url_mini);
get_fields(vice_shop) ->
    record_info(fields, vice_shop);
get_fields(vip_reward) ->
    record_info(fields, vip_reward);
get_fields(_) ->
    [].
match_info(abs_path) ->
    ?MATCH_SPEC(abs_path);
match_info(account_info) ->
    ?MATCH_SPEC(account_info);
match_info(achieve_data) ->
    ?MATCH_SPEC(achieve_data);
match_info(activity_shop_msg) ->
    ?MATCH_SPEC(activity_shop_msg);
match_info(activity_shop_record) ->
    ?MATCH_SPEC(activity_shop_record);
match_info(advance_reward) ->
    ?MATCH_SPEC(advance_reward);
match_info(async_arena_rank) ->
    ?MATCH_SPEC(async_arena_rank);
match_info(async_arena_report) ->
    ?MATCH_SPEC(async_arena_report);
match_info(attribute) ->
    ?MATCH_SPEC(attribute);
match_info(attribute_info) ->
    ?MATCH_SPEC(attribute_info);
match_info(base_ability) ->
    ?MATCH_SPEC(base_ability);
match_info(base_activity_twist_egg) ->
    ?MATCH_SPEC(base_activity_twist_egg);
match_info(base_advance_reward) ->
    ?MATCH_SPEC(base_advance_reward);
match_info(base_boss) ->
    ?MATCH_SPEC(base_boss);
match_info(base_choujiang) ->
    ?MATCH_SPEC(base_choujiang);
match_info(base_combat_buff) ->
    ?MATCH_SPEC(base_combat_buff);
match_info(base_combat_skill) ->
    ?MATCH_SPEC(base_combat_skill);
match_info(base_combat_skill_passive) ->
    ?MATCH_SPEC(base_combat_skill_passive);
match_info(base_combat_skill_strengthen) ->
    ?MATCH_SPEC(base_combat_skill_strengthen);
match_info(base_combat_skill_upgrade) ->
    ?MATCH_SPEC(base_combat_skill_upgrade);
match_info(base_competitive_main_shop) ->
    ?MATCH_SPEC(base_competitive_main_shop);
match_info(base_competitive_vice_shop) ->
    ?MATCH_SPEC(base_competitive_vice_shop);
match_info(base_daily_dungeon_condition) ->
    ?MATCH_SPEC(base_daily_dungeon_condition);
match_info(base_daily_dungeon_info) ->
    ?MATCH_SPEC(base_daily_dungeon_info);
match_info(base_daily_dungeon_lv) ->
    ?MATCH_SPEC(base_daily_dungeon_lv);
match_info(base_dungeon_area) ->
    ?MATCH_SPEC(base_dungeon_area);
match_info(base_dungeon_create_monster) ->
    ?MATCH_SPEC(base_dungeon_create_monster);
match_info(base_dungeon_create_object) ->
    ?MATCH_SPEC(base_dungeon_create_object);
match_info(base_dungeon_create_portal) ->
    ?MATCH_SPEC(base_dungeon_create_portal);
match_info(base_dungeon_detail) ->
    ?MATCH_SPEC(base_dungeon_detail);
match_info(base_dungeon_match) ->
    ?MATCH_SPEC(base_dungeon_match);
match_info(base_dungeon_monsters_attribute) ->
    ?MATCH_SPEC(base_dungeon_monsters_attribute);
match_info(base_dungeon_object_attribute) ->
    ?MATCH_SPEC(base_dungeon_object_attribute);
match_info(base_dungeon_target) ->
    ?MATCH_SPEC(base_dungeon_target);
match_info(base_dungeon_world_boss) ->
    ?MATCH_SPEC(base_dungeon_world_boss);
match_info(base_error_list) ->
    ?MATCH_SPEC(base_error_list);
match_info(base_fashion_combination) ->
    ?MATCH_SPEC(base_fashion_combination);
match_info(base_function_open) ->
    ?MATCH_SPEC(base_function_open);
match_info(base_general_store) ->
    ?MATCH_SPEC(base_general_store);
match_info(base_goods) ->
    ?MATCH_SPEC(base_goods);
match_info(base_goods_att_color) ->
    ?MATCH_SPEC(base_goods_att_color);
match_info(base_goods_att_lv) ->
    ?MATCH_SPEC(base_goods_att_lv);
match_info(base_goods_att_rand) ->
    ?MATCH_SPEC(base_goods_att_rand);
match_info(base_goods_color_hole) ->
    ?MATCH_SPEC(base_goods_color_hole);
match_info(base_goods_jewel) ->
    ?MATCH_SPEC(base_goods_jewel);
match_info(base_goods_strengthen) ->
    ?MATCH_SPEC(base_goods_strengthen);
match_info(base_guild_lv_exp) ->
    ?MATCH_SPEC(base_guild_lv_exp);
match_info(base_guild_rank_integral) ->
    ?MATCH_SPEC(base_guild_rank_integral);
match_info(base_kuafupvp_battle_reward) ->
    ?MATCH_SPEC(base_kuafupvp_battle_reward);
match_info(base_kuafupvp_rank_reward) ->
    ?MATCH_SPEC(base_kuafupvp_rank_reward);
match_info(base_kuafupvp_robot_attribute) ->
    ?MATCH_SPEC(base_kuafupvp_robot_attribute);
match_info(base_log_user) ->
    ?MATCH_SPEC(base_log_user);
match_info(base_login_reward) ->
    ?MATCH_SPEC(base_login_reward);
match_info(base_mail) ->
    ?MATCH_SPEC(base_mail);
match_info(base_monster_level_attribute) ->
    ?MATCH_SPEC(base_monster_level_attribute);
match_info(base_month_reward) ->
    ?MATCH_SPEC(base_month_reward);
match_info(base_mugen_tower) ->
    ?MATCH_SPEC(base_mugen_tower);
match_info(base_mysterious_shop) ->
    ?MATCH_SPEC(base_mysterious_shop);
match_info(base_notice) ->
    ?MATCH_SPEC(base_notice);
match_info(base_operators_mail) ->
    ?MATCH_SPEC(base_operators_mail);
match_info(base_params) ->
    ?MATCH_SPEC(base_params);
match_info(base_pvp_battle_reward) ->
    ?MATCH_SPEC(base_pvp_battle_reward);
match_info(base_pvp_rank_reward) ->
    ?MATCH_SPEC(base_pvp_rank_reward);
match_info(base_pvp_robot_attribute) ->
    ?MATCH_SPEC(base_pvp_robot_attribute);
match_info(base_qianguizhe) ->
    ?MATCH_SPEC(base_qianguizhe);
match_info(base_rank_reward) ->
    ?MATCH_SPEC(base_rank_reward);
match_info(base_rate) ->
    ?MATCH_SPEC(base_rate);
match_info(base_shop) ->
    ?MATCH_SPEC(base_shop);
match_info(base_shop_activity) ->
    ?MATCH_SPEC(base_shop_activity);
match_info(base_shop_content) ->
    ?MATCH_SPEC(base_shop_content);
match_info(base_skill_card) ->
    ?MATCH_SPEC(base_skill_card);
match_info(base_skill_exp) ->
    ?MATCH_SPEC(base_skill_exp);
match_info(base_store_product) ->
    ?MATCH_SPEC(base_store_product);
match_info(base_task) ->
    ?MATCH_SPEC(base_task);
match_info(base_twist_egg) ->
    ?MATCH_SPEC(base_twist_egg);
match_info(base_vip) ->
    ?MATCH_SPEC(base_vip);
match_info(base_vip_cost) ->
    ?MATCH_SPEC(base_vip_cost);
match_info(base_xunzhang) ->
    ?MATCH_SPEC(base_xunzhang);
match_info(battle_attribute) ->
    ?MATCH_SPEC(battle_attribute);
match_info(bossinfo) ->
    ?MATCH_SPEC(bossinfo);
match_info(camp) ->
    ?MATCH_SPEC(camp);
match_info(chat_league) ->
    ?MATCH_SPEC(chat_league);
match_info(chat_private) ->
    ?MATCH_SPEC(chat_private);
match_info(chats_world) ->
    ?MATCH_SPEC(chats_world);
match_info(choujiang_info) ->
    ?MATCH_SPEC(choujiang_info);
match_info(client) ->
    ?MATCH_SPEC(client);
match_info(collect_status) ->
    ?MATCH_SPEC(collect_status);
match_info(combat_attri) ->
    ?MATCH_SPEC(combat_attri);
match_info(common_reward) ->
    ?MATCH_SPEC(common_reward);
match_info(count_record) ->
    ?MATCH_SPEC(count_record);
match_info(counter) ->
    ?MATCH_SPEC(counter);
match_info(cross_pvp_enemy) ->
    ?MATCH_SPEC(cross_pvp_enemy);
match_info(cross_pvp_event) ->
    ?MATCH_SPEC(cross_pvp_event);
match_info(cross_pvp_fighter) ->
    ?MATCH_SPEC(cross_pvp_fighter);
match_info(cross_pvp_island) ->
    ?MATCH_SPEC(cross_pvp_island);
match_info(cross_pvp_npc) ->
    ?MATCH_SPEC(cross_pvp_npc);
match_info(cross_pvp_record) ->
    ?MATCH_SPEC(cross_pvp_record);
match_info(ct_robot) ->
    ?MATCH_SPEC(ct_robot);
match_info(daily_dungeon) ->
    ?MATCH_SPEC(daily_dungeon);
match_info(data_base_activity) ->
    ?MATCH_SPEC(data_base_activity);
match_info(data_base_fashion) ->
    ?MATCH_SPEC(data_base_fashion);
match_info(data_mon) ->
    ?MATCH_SPEC(data_mon);
match_info(defend_point) ->
    ?MATCH_SPEC(defend_point);
match_info(df_elem) ->
    ?MATCH_SPEC(df_elem);
match_info(dungeon) ->
    ?MATCH_SPEC(dungeon);
match_info(dungeon_info) ->
    ?MATCH_SPEC(dungeon_info);
match_info(dungeon_match) ->
    ?MATCH_SPEC(dungeon_match);
match_info(dungeon_mop_up) ->
    ?MATCH_SPEC(dungeon_mop_up);
match_info(dungeon_mugen) ->
    ?MATCH_SPEC(dungeon_mugen);
match_info(dungeon_rewards) ->
    ?MATCH_SPEC(dungeon_rewards);
match_info(dungeon_schedule) ->
    ?MATCH_SPEC(dungeon_schedule);
match_info(emo_query) ->
    ?MATCH_SPEC(emo_query);
match_info(equip_attribute) ->
    ?MATCH_SPEC(equip_attribute);
match_info(error_msg) ->
    ?MATCH_SPEC(error_msg);
match_info(ets_base_app_store_product) ->
    ?MATCH_SPEC(ets_base_app_store_product);
match_info(ets_base_equipment) ->
    ?MATCH_SPEC(ets_base_equipment);
match_info(ets_base_equipment_property) ->
    ?MATCH_SPEC(ets_base_equipment_property);
match_info(ets_base_equipment_upgrade) ->
    ?MATCH_SPEC(ets_base_equipment_upgrade);
match_info(ets_base_login_gift) ->
    ?MATCH_SPEC(ets_base_login_gift);
match_info(ets_base_mon) ->
    ?MATCH_SPEC(ets_base_mon);
match_info(ets_base_online_gift) ->
    ?MATCH_SPEC(ets_base_online_gift);
match_info(ets_base_player) ->
    ?MATCH_SPEC(ets_base_player);
match_info(ets_base_protocol) ->
    ?MATCH_SPEC(ets_base_protocol);
match_info(ets_base_sys_acm) ->
    ?MATCH_SPEC(ets_base_sys_acm);
match_info(ets_log_mail) ->
    ?MATCH_SPEC(ets_log_mail);
match_info(ets_pay_info) ->
    ?MATCH_SPEC(ets_pay_info);
match_info(ets_process) ->
    ?MATCH_SPEC(ets_process);
match_info(ets_push_schedule) ->
    ?MATCH_SPEC(ets_push_schedule);
match_info(ets_shop_goods) ->
    ?MATCH_SPEC(ets_shop_goods);
match_info(fashion) ->
    ?MATCH_SPEC(fashion);
match_info(fashion_record) ->
    ?MATCH_SPEC(fashion_record);
match_info(field) ->
    ?MATCH_SPEC(field);
match_info(fight_league) ->
    ?MATCH_SPEC(fight_league);
match_info(fight_league_copy) ->
    ?MATCH_SPEC(fight_league_copy);
match_info(fight_member) ->
    ?MATCH_SPEC(fight_member);
match_info(fight_record) ->
    ?MATCH_SPEC(fight_record);
match_info(fns_elem) ->
    ?MATCH_SPEC(fns_elem);
match_info(g17_guild) ->
    ?MATCH_SPEC(g17_guild);
match_info(g17_guild_apply) ->
    ?MATCH_SPEC(g17_guild_apply);
match_info(g17_guild_member) ->
    ?MATCH_SPEC(g17_guild_member);
match_info(g_feats_elem) ->
    ?MATCH_SPEC(g_feats_elem);
match_info(gateway_agent) ->
    ?MATCH_SPEC(gateway_agent);
match_info(gateway_client) ->
    ?MATCH_SPEC(gateway_client);
match_info(general_store) ->
    ?MATCH_SPEC(general_store);
match_info(generate_conf) ->
    ?MATCH_SPEC(generate_conf);
match_info(goods) ->
    ?MATCH_SPEC(goods);
match_info(guild_mem_skyrush_rank) ->
    ?MATCH_SPEC(guild_mem_skyrush_rank);
match_info(guild_skyrush_rank) ->
    ?MATCH_SPEC(guild_skyrush_rank);
match_info(help_battle) ->
    ?MATCH_SPEC(help_battle);
match_info(hold_info) ->
    ?MATCH_SPEC(hold_info);
match_info(http_request) ->
    ?MATCH_SPEC(http_request);
match_info(http_response) ->
    ?MATCH_SPEC(http_response);
match_info(init_data) ->
    ?MATCH_SPEC(init_data);
match_info(league) ->
    ?MATCH_SPEC(league);
match_info(league_apply_info) ->
    ?MATCH_SPEC(league_apply_info);
match_info(league_challenge_record) ->
    ?MATCH_SPEC(league_challenge_record);
match_info(league_fight_point) ->
    ?MATCH_SPEC(league_fight_point);
match_info(league_fight_state) ->
    ?MATCH_SPEC(league_fight_state);
match_info(league_gifts) ->
    ?MATCH_SPEC(league_gifts);
match_info(league_gifts_record) ->
    ?MATCH_SPEC(league_gifts_record);
match_info(league_member) ->
    ?MATCH_SPEC(league_member);
match_info(league_member_challenge) ->
    ?MATCH_SPEC(league_member_challenge);
match_info(league_msg) ->
    ?MATCH_SPEC(league_msg);
match_info(league_recharge_gold_record) ->
    ?MATCH_SPEC(league_recharge_gold_record);
match_info(league_relation) ->
    ?MATCH_SPEC(league_relation);
match_info(log_device) ->
    ?MATCH_SPEC(log_device);
match_info(log_login) ->
    ?MATCH_SPEC(log_login);
match_info(log_player) ->
    ?MATCH_SPEC(log_player);
match_info(log_player_chat) ->
    ?MATCH_SPEC(log_player_chat);
match_info(log_player_create) ->
    ?MATCH_SPEC(log_player_create);
match_info(log_player_feedback) ->
    ?MATCH_SPEC(log_player_feedback);
match_info(log_player_login) ->
    ?MATCH_SPEC(log_player_login);
match_info(log_player_mini) ->
    ?MATCH_SPEC(log_player_mini);
match_info(log_player_online) ->
    ?MATCH_SPEC(log_player_online);
match_info(log_state) ->
    ?MATCH_SPEC(log_state);
match_info(log_system) ->
    ?MATCH_SPEC(log_system);
match_info(log_twist_eggs) ->
    ?MATCH_SPEC(log_twist_eggs);
match_info(log_uplevel) ->
    ?MATCH_SPEC(log_uplevel);
match_info(lucky_coin) ->
    ?MATCH_SPEC(lucky_coin);
match_info(mails) ->
    ?MATCH_SPEC(mails);
match_info(main_shop) ->
    ?MATCH_SPEC(main_shop);
match_info(main_shop_msg) ->
    ?MATCH_SPEC(main_shop_msg);
match_info(master_apprentice) ->
    ?MATCH_SPEC(master_apprentice);
match_info(master_request_msg) ->
    ?MATCH_SPEC(master_request_msg);
match_info(mdb_challenge_info) ->
    ?MATCH_SPEC(mdb_challenge_info);
match_info(mdb_dungeon_info) ->
    ?MATCH_SPEC(mdb_dungeon_info);
match_info(mdb_shop_msg) ->
    ?MATCH_SPEC(mdb_shop_msg);
match_info(mem_feats_elem) ->
    ?MATCH_SPEC(mem_feats_elem);
match_info(member) ->
    ?MATCH_SPEC(member);
match_info(mnesia_upgrade_conf) ->
    ?MATCH_SPEC(mnesia_upgrade_conf);
match_info(mod) ->
    ?MATCH_SPEC(mod);
match_info(mod_player_state) ->
    ?MATCH_SPEC(mod_player_state);
match_info(mugen_reward) ->
    ?MATCH_SPEC(mugen_reward);
match_info(node_status) ->
    ?MATCH_SPEC(node_status);
match_info(open_boss_rank) ->
    ?MATCH_SPEC(open_boss_rank);
match_info(operators_mail) ->
    ?MATCH_SPEC(operators_mail);
match_info(ordinary_shop) ->
    ?MATCH_SPEC(ordinary_shop);
match_info(ordinary_shop_msg) ->
    ?MATCH_SPEC(ordinary_shop_msg);
match_info(own_gift) ->
    ?MATCH_SPEC(own_gift);
match_info(pass_dungeon_info) ->
    ?MATCH_SPEC(pass_dungeon_info);
match_info(pay_gifts) ->
    ?MATCH_SPEC(pay_gifts);
match_info(pay_info) ->
    ?MATCH_SPEC(pay_info);
match_info(pbaccount) ->
    ?MATCH_SPEC(pbaccount);
match_info(pbaccountlogin) ->
    ?MATCH_SPEC(pbaccountlogin);
match_info(pbactivity) ->
    ?MATCH_SPEC(pbactivity);
match_info(pbactivitylist) ->
    ?MATCH_SPEC(pbactivitylist);
match_info(pbactivityshop) ->
    ?MATCH_SPEC(pbactivityshop);
match_info(pbactivityshopmsg) ->
    ?MATCH_SPEC(pbactivityshopmsg);
match_info(pbaddleaguemsg) ->
    ?MATCH_SPEC(pbaddleaguemsg);
match_info(pballmasterinfo) ->
    ?MATCH_SPEC(pballmasterinfo);
match_info(pbappointplayer) ->
    ?MATCH_SPEC(pbappointplayer);
match_info(pbapprenticebuycard) ->
    ?MATCH_SPEC(pbapprenticebuycard);
match_info(pbapprenticecard) ->
    ?MATCH_SPEC(pbapprenticecard);
match_info(pbapprenticerequestinfo) ->
    ?MATCH_SPEC(pbapprenticerequestinfo);
match_info(pbarenabattlereport) ->
    ?MATCH_SPEC(pbarenabattlereport);
match_info(pbarenabattlereportlist) ->
    ?MATCH_SPEC(pbarenabattlereportlist);
match_info(pbarenachallenge) ->
    ?MATCH_SPEC(pbarenachallenge);
match_info(pbarenainfo) ->
    ?MATCH_SPEC(pbarenainfo);
match_info(pbarenainfolist) ->
    ?MATCH_SPEC(pbarenainfolist);
match_info(pbarenauser) ->
    ?MATCH_SPEC(pbarenauser);
match_info(pbarenauserlist) ->
    ?MATCH_SPEC(pbarenauserlist);
match_info(pbattribute) ->
    ?MATCH_SPEC(pbattribute);
match_info(pbbossinvitemsg) ->
    ?MATCH_SPEC(pbbossinvitemsg);
match_info(pbbosslist) ->
    ?MATCH_SPEC(pbbosslist);
match_info(pbbosssendgold) ->
    ?MATCH_SPEC(pbbosssendgold);
match_info(pbcamp) ->
    ?MATCH_SPEC(pbcamp);
match_info(pbcamppos) ->
    ?MATCH_SPEC(pbcamppos);
match_info(pbcardinfo) ->
    ?MATCH_SPEC(pbcardinfo);
match_info(pbcardrequest) ->
    ?MATCH_SPEC(pbcardrequest);
match_info(pbcardrequestlist) ->
    ?MATCH_SPEC(pbcardrequestlist);
match_info(pbcdkreward) ->
    ?MATCH_SPEC(pbcdkreward);
match_info(pbchallengedungeon) ->
    ?MATCH_SPEC(pbchallengedungeon);
match_info(pbchallengedungeoninfo) ->
    ?MATCH_SPEC(pbchallengedungeoninfo);
match_info(pbchallengedungeonrank) ->
    ?MATCH_SPEC(pbchallengedungeonrank);
match_info(pbchallengerecord) ->
    ?MATCH_SPEC(pbchallengerecord);
match_info(pbchallengerecordlist) ->
    ?MATCH_SPEC(pbchallengerecordlist);
match_info(pbchat) ->
    ?MATCH_SPEC(pbchat);
match_info(pbchatlist) ->
    ?MATCH_SPEC(pbchatlist);
match_info(pbchoujiang) ->
    ?MATCH_SPEC(pbchoujiang);
match_info(pbchoujianggoods) ->
    ?MATCH_SPEC(pbchoujianggoods);
match_info(pbchoujianginfo) ->
    ?MATCH_SPEC(pbchoujianginfo);
match_info(pbchoujiangresult) ->
    ?MATCH_SPEC(pbchoujiangresult);
match_info(pbcombatbuff) ->
    ?MATCH_SPEC(pbcombatbuff);
match_info(pbcombateffect) ->
    ?MATCH_SPEC(pbcombateffect);
match_info(pbcombatfighter) ->
    ?MATCH_SPEC(pbcombatfighter);
match_info(pbcombathurtattri) ->
    ?MATCH_SPEC(pbcombathurtattri);
match_info(pbcombatreport) ->
    ?MATCH_SPEC(pbcombatreport);
match_info(pbcombatreportlist) ->
    ?MATCH_SPEC(pbcombatreportlist);
match_info(pbcombatrespon) ->
    ?MATCH_SPEC(pbcombatrespon);
match_info(pbcombatreward) ->
    ?MATCH_SPEC(pbcombatreward);
match_info(pbcombatround) ->
    ?MATCH_SPEC(pbcombatround);
match_info(pbcombattarget) ->
    ?MATCH_SPEC(pbcombattarget);
match_info(pbcountrecord) ->
    ?MATCH_SPEC(pbcountrecord);
match_info(pbcountrecords) ->
    ?MATCH_SPEC(pbcountrecords);
match_info(pbcreatearole) ->
    ?MATCH_SPEC(pbcreatearole);
match_info(pbcreaturedrop) ->
    ?MATCH_SPEC(pbcreaturedrop);
match_info(pbcritmsg) ->
    ?MATCH_SPEC(pbcritmsg);
match_info(pbcrossfighter) ->
    ?MATCH_SPEC(pbcrossfighter);
match_info(pbcrosshistory) ->
    ?MATCH_SPEC(pbcrosshistory);
match_info(pbcrosshistorylist) ->
    ?MATCH_SPEC(pbcrosshistorylist);
match_info(pbcrossisland) ->
    ?MATCH_SPEC(pbcrossisland);
match_info(pbcrossrecord) ->
    ?MATCH_SPEC(pbcrossrecord);
match_info(pbdailydungeon) ->
    ?MATCH_SPEC(pbdailydungeon);
match_info(pbdungeon) ->
    ?MATCH_SPEC(pbdungeon);
match_info(pbdungeoncondition) ->
    ?MATCH_SPEC(pbdungeoncondition);
match_info(pbdungeoncreature) ->
    ?MATCH_SPEC(pbdungeoncreature);
match_info(pbdungeonmonster) ->
    ?MATCH_SPEC(pbdungeonmonster);
match_info(pbdungeonreward) ->
    ?MATCH_SPEC(pbdungeonreward);
match_info(pbdungeonschedule) ->
    ?MATCH_SPEC(pbdungeonschedule);
match_info(pbdungeonschedulelist) ->
    ?MATCH_SPEC(pbdungeonschedulelist);
match_info(pbdungeontarget) ->
    ?MATCH_SPEC(pbdungeontarget);
match_info(pbequipaddstar) ->
    ?MATCH_SPEC(pbequipaddstar);
match_info(pbequipmove) ->
    ?MATCH_SPEC(pbequipmove);
match_info(pbequipstrengthen) ->
    ?MATCH_SPEC(pbequipstrengthen);
match_info(pberror) ->
    ?MATCH_SPEC(pberror);
match_info(pbfashion) ->
    ?MATCH_SPEC(pbfashion);
match_info(pbfashionlist) ->
    ?MATCH_SPEC(pbfashionlist);
match_info(pbfeedbackmsg) ->
    ?MATCH_SPEC(pbfeedbackmsg);
match_info(pbfightrecords) ->
    ?MATCH_SPEC(pbfightrecords);
match_info(pbflipcard) ->
    ?MATCH_SPEC(pbflipcard);
match_info(pbfriend) ->
    ?MATCH_SPEC(pbfriend);
match_info(pbfriendlist) ->
    ?MATCH_SPEC(pbfriendlist);
match_info(pbg17guild) ->
    ?MATCH_SPEC(pbg17guild);
match_info(pbg17guildlist) ->
    ?MATCH_SPEC(pbg17guildlist);
match_info(pbg17guildmember) ->
    ?MATCH_SPEC(pbg17guildmember);
match_info(pbg17guildquery) ->
    ?MATCH_SPEC(pbg17guildquery);
match_info(pbgeneralstorebuy) ->
    ?MATCH_SPEC(pbgeneralstorebuy);
match_info(pbgeneralstoreinfo) ->
    ?MATCH_SPEC(pbgeneralstoreinfo);
match_info(pbgetleague) ->
    ?MATCH_SPEC(pbgetleague);
match_info(pbgetleaguegrouprankinfo) ->
    ?MATCH_SPEC(pbgetleaguegrouprankinfo);
match_info(pbgetleaguestatu) ->
    ?MATCH_SPEC(pbgetleaguestatu);
match_info(pbgetpointrecord) ->
    ?MATCH_SPEC(pbgetpointrecord);
match_info(pbgiftsid) ->
    ?MATCH_SPEC(pbgiftsid);
match_info(pbgiftsrecord) ->
    ?MATCH_SPEC(pbgiftsrecord);
match_info(pbgiftsrecordlist) ->
    ?MATCH_SPEC(pbgiftsrecordlist);
match_info(pbgoods) ->
    ?MATCH_SPEC(pbgoods);
match_info(pbgoodschanged) ->
    ?MATCH_SPEC(pbgoodschanged);
match_info(pbgoodsinfo) ->
    ?MATCH_SPEC(pbgoodsinfo);
match_info(pbgoodslist) ->
    ?MATCH_SPEC(pbgoodslist);
match_info(pbhitrewarddetail) ->
    ?MATCH_SPEC(pbhitrewarddetail);
match_info(pbid32) ->
    ?MATCH_SPEC(pbid32);
match_info(pbid32r) ->
    ?MATCH_SPEC(pbid32r);
match_info(pbid64) ->
    ?MATCH_SPEC(pbid64);
match_info(pbid64list) ->
    ?MATCH_SPEC(pbid64list);
match_info(pbid64r) ->
    ?MATCH_SPEC(pbid64r);
match_info(pbidstring) ->
    ?MATCH_SPEC(pbidstring);
match_info(pbinlaidjewel) ->
    ?MATCH_SPEC(pbinlaidjewel);
match_info(pbleagifts) ->
    ?MATCH_SPEC(pbleagifts);
match_info(pbleague) ->
    ?MATCH_SPEC(pbleague);
match_info(pbleaguechallengeinfo) ->
    ?MATCH_SPEC(pbleaguechallengeinfo);
match_info(pbleaguechallengelist) ->
    ?MATCH_SPEC(pbleaguechallengelist);
match_info(pbleaguechallengeresult) ->
    ?MATCH_SPEC(pbleaguechallengeresult);
match_info(pbleaguefightpoint) ->
    ?MATCH_SPEC(pbleaguefightpoint);
match_info(pbleaguefightpointlist) ->
    ?MATCH_SPEC(pbleaguefightpointlist);
match_info(pbleaguefightrankinfo) ->
    ?MATCH_SPEC(pbleaguefightrankinfo);
match_info(pbleaguegifts) ->
    ?MATCH_SPEC(pbleaguegifts);
match_info(pbleaguehouse) ->
    ?MATCH_SPEC(pbleaguehouse);
match_info(pbleaguehouserecord) ->
    ?MATCH_SPEC(pbleaguehouserecord);
match_info(pbleagueinfo) ->
    ?MATCH_SPEC(pbleagueinfo);
match_info(pbleagueinfolist) ->
    ?MATCH_SPEC(pbleagueinfolist);
match_info(pbleaguelist) ->
    ?MATCH_SPEC(pbleaguelist);
match_info(pbleaguemember) ->
    ?MATCH_SPEC(pbleaguemember);
match_info(pbleaguememberlist) ->
    ?MATCH_SPEC(pbleaguememberlist);
match_info(pbleaguepointchallengeresult) ->
    ?MATCH_SPEC(pbleaguepointchallengeresult);
match_info(pbleaguerankinfo) ->
    ?MATCH_SPEC(pbleaguerankinfo);
match_info(pbleagueranklist) ->
    ?MATCH_SPEC(pbleagueranklist);
match_info(pbmail) ->
    ?MATCH_SPEC(pbmail);
match_info(pbmailgoods) ->
    ?MATCH_SPEC(pbmailgoods);
match_info(pbmaillist) ->
    ?MATCH_SPEC(pbmaillist);
match_info(pbmasteragreemsg) ->
    ?MATCH_SPEC(pbmasteragreemsg);
match_info(pbmastercard) ->
    ?MATCH_SPEC(pbmastercard);
match_info(pbmasterinfo) ->
    ?MATCH_SPEC(pbmasterinfo);
match_info(pbmember) ->
    ?MATCH_SPEC(pbmember);
match_info(pbmembergetlisttype) ->
    ?MATCH_SPEC(pbmembergetlisttype);
match_info(pbmembersendlist) ->
    ?MATCH_SPEC(pbmembersendlist);
match_info(pbmembersendmsg) ->
    ?MATCH_SPEC(pbmembersendmsg);
match_info(pbmonsterdrop) ->
    ?MATCH_SPEC(pbmonsterdrop);
match_info(pbmopup) ->
    ?MATCH_SPEC(pbmopup);
match_info(pbmopuplist) ->
    ?MATCH_SPEC(pbmopuplist);
match_info(pbmugenchallenge) ->
    ?MATCH_SPEC(pbmugenchallenge);
match_info(pbnewiteminfo) ->
    ?MATCH_SPEC(pbnewiteminfo);
match_info(pbnewmsg) ->
    ?MATCH_SPEC(pbnewmsg);
match_info(pbnotice) ->
    ?MATCH_SPEC(pbnotice);
match_info(pbnoticelist) ->
    ?MATCH_SPEC(pbnoticelist);
match_info(pbnull) ->
    ?MATCH_SPEC(pbnull);
match_info(pbonekeysendmsg) ->
    ?MATCH_SPEC(pbonekeysendmsg);
match_info(pbopenboss) ->
    ?MATCH_SPEC(pbopenboss);
match_info(pbordinarybuy) ->
    ?MATCH_SPEC(pbordinarybuy);
match_info(pbowncardsinfo) ->
    ?MATCH_SPEC(pbowncardsinfo);
match_info(pbowngifts) ->
    ?MATCH_SPEC(pbowngifts);
match_info(pbplayerachieve) ->
    ?MATCH_SPEC(pbplayerachieve);
match_info(pbplayerachievelist) ->
    ?MATCH_SPEC(pbplayerachievelist);
match_info(pbplayercamp) ->
    ?MATCH_SPEC(pbplayercamp);
match_info(pbplayergifts) ->
    ?MATCH_SPEC(pbplayergifts);
match_info(pbpointchallengerecord) ->
    ?MATCH_SPEC(pbpointchallengerecord);
match_info(pbpointchallengerecordinfo) ->
    ?MATCH_SPEC(pbpointchallengerecordinfo);
match_info(pbpointprotectlist) ->
    ?MATCH_SPEC(pbpointprotectlist);
match_info(pbpointsend) ->
    ?MATCH_SPEC(pbpointsend);
match_info(pbpointsendmsg) ->
    ?MATCH_SPEC(pbpointsendmsg);
match_info(pbpointsendmsglist) ->
    ?MATCH_SPEC(pbpointsendmsglist);
match_info(pbprivate) ->
    ?MATCH_SPEC(pbprivate);
match_info(pbprotectinfo) ->
    ?MATCH_SPEC(pbprotectinfo);
match_info(pbprotectplayerinfo) ->
    ?MATCH_SPEC(pbprotectplayerinfo);
match_info(pbpvprobotattr) ->
    ?MATCH_SPEC(pbpvprobotattr);
match_info(pbrank) ->
    ?MATCH_SPEC(pbrank);
match_info(pbrankinfo) ->
    ?MATCH_SPEC(pbrankinfo);
match_info(pbranklist) ->
    ?MATCH_SPEC(pbranklist);
match_info(pbrc4) ->
    ?MATCH_SPEC(pbrc4);
match_info(pbrequestgiftsmsg) ->
    ?MATCH_SPEC(pbrequestgiftsmsg);
match_info(pbrequestgiftsmsglist) ->
    ?MATCH_SPEC(pbrequestgiftsmsglist);
match_info(pbrequestplayergiftsmsg) ->
    ?MATCH_SPEC(pbrequestplayergiftsmsg);
match_info(pbrequestplayergiftsmsglist) ->
    ?MATCH_SPEC(pbrequestplayergiftsmsglist);
match_info(pbresult) ->
    ?MATCH_SPEC(pbresult);
match_info(pbreward) ->
    ?MATCH_SPEC(pbreward);
match_info(pbrewarditem) ->
    ?MATCH_SPEC(pbrewarditem);
match_info(pbrewardlist) ->
    ?MATCH_SPEC(pbrewardlist);
match_info(pbsellinglist) ->
    ?MATCH_SPEC(pbsellinglist);
match_info(pbsellingshop) ->
    ?MATCH_SPEC(pbsellingshop);
match_info(pbsendgiftsmsg) ->
    ?MATCH_SPEC(pbsendgiftsmsg);
match_info(pbserverstatus) ->
    ?MATCH_SPEC(pbserverstatus);
match_info(pbshopbuy) ->
    ?MATCH_SPEC(pbshopbuy);
match_info(pbshopitem) ->
    ?MATCH_SPEC(pbshopitem);
match_info(pbshopmsg) ->
    ?MATCH_SPEC(pbshopmsg);
match_info(pbsigil) ->
    ?MATCH_SPEC(pbsigil);
match_info(pbskill) ->
    ?MATCH_SPEC(pbskill);
match_info(pbskillid) ->
    ?MATCH_SPEC(pbskillid);
match_info(pbskillidlist) ->
    ?MATCH_SPEC(pbskillidlist);
match_info(pbskilllist) ->
    ?MATCH_SPEC(pbskilllist);
match_info(pbsmriti) ->
    ?MATCH_SPEC(pbsmriti);
match_info(pbsourcedungeon) ->
    ?MATCH_SPEC(pbsourcedungeon);
match_info(pbsourcedungeoninfo) ->
    ?MATCH_SPEC(pbsourcedungeoninfo);
match_info(pbstartcombat) ->
    ?MATCH_SPEC(pbstartcombat);
match_info(pbsteriousshop) ->
    ?MATCH_SPEC(pbsteriousshop);
match_info(pbstoreproduct) ->
    ?MATCH_SPEC(pbstoreproduct);
match_info(pbstoreproductlist) ->
    ?MATCH_SPEC(pbstoreproductlist);
match_info(pbsubdungeon) ->
    ?MATCH_SPEC(pbsubdungeon);
match_info(pbtask) ->
    ?MATCH_SPEC(pbtask);
match_info(pbtasklist) ->
    ?MATCH_SPEC(pbtasklist);
match_info(pbteam) ->
    ?MATCH_SPEC(pbteam);
match_info(pbteamchat) ->
    ?MATCH_SPEC(pbteamchat);
match_info(pbtwistegg) ->
    ?MATCH_SPEC(pbtwistegg);
match_info(pbtwistegglist) ->
    ?MATCH_SPEC(pbtwistegglist);
match_info(pbupgradeskillcard) ->
    ?MATCH_SPEC(pbupgradeskillcard);
match_info(pbuser) ->
    ?MATCH_SPEC(pbuser);
match_info(pbuserlist) ->
    ?MATCH_SPEC(pbuserlist);
match_info(pbuserloginfashioninfo) ->
    ?MATCH_SPEC(pbuserloginfashioninfo);
match_info(pbuserlogininfo) ->
    ?MATCH_SPEC(pbuserlogininfo);
match_info(pbusernotifyupdate) ->
    ?MATCH_SPEC(pbusernotifyupdate);
match_info(pbuserresult) ->
    ?MATCH_SPEC(pbuserresult);
match_info(pbvipreward) ->
    ?MATCH_SPEC(pbvipreward);
match_info(pbwavecreature) ->
    ?MATCH_SPEC(pbwavecreature);
match_info(pbwavemonster) ->
    ?MATCH_SPEC(pbwavemonster);
match_info(pbwinrate) ->
    ?MATCH_SPEC(pbwinrate);
match_info(pbworldboss) ->
    ?MATCH_SPEC(pbworldboss);
match_info(player) ->
    ?MATCH_SPEC(player);
match_info(player_buff) ->
    ?MATCH_SPEC(player_buff);
match_info(player_camp) ->
    ?MATCH_SPEC(player_camp);
match_info(player_cost_state) ->
    ?MATCH_SPEC(player_cost_state);
match_info(player_count) ->
    ?MATCH_SPEC(player_count);
match_info(player_dungeon_match) ->
    ?MATCH_SPEC(player_dungeon_match);
match_info(player_goods) ->
    ?MATCH_SPEC(player_goods);
match_info(player_info) ->
    ?MATCH_SPEC(player_info);
match_info(player_month_sign) ->
    ?MATCH_SPEC(player_month_sign);
match_info(player_other) ->
    ?MATCH_SPEC(player_other);
match_info(player_pid) ->
    ?MATCH_SPEC(player_pid);
match_info(player_response) ->
    ?MATCH_SPEC(player_response);
match_info(player_skill) ->
    ?MATCH_SPEC(player_skill);
match_info(player_skill_record) ->
    ?MATCH_SPEC(player_skill_record);
match_info(private_msg) ->
    ?MATCH_SPEC(private_msg);
match_info(radar_msg) ->
    ?MATCH_SPEC(radar_msg);
match_info(rank) ->
    ?MATCH_SPEC(rank);
match_info(rank_reset_info) ->
    ?MATCH_SPEC(rank_reset_info);
match_info(record_mysql_info) ->
    ?MATCH_SPEC(record_mysql_info);
match_info(relationship) ->
    ?MATCH_SPEC(relationship);
match_info(request_gifts_msg) ->
    ?MATCH_SPEC(request_gifts_msg);
match_info(response) ->
    ?MATCH_SPEC(response);
match_info(reward_item) ->
    ?MATCH_SPEC(reward_item);
match_info(scheme) ->
    ?MATCH_SPEC(scheme);
match_info(server_config) ->
    ?MATCH_SPEC(server_config);
match_info(service) ->
    ?MATCH_SPEC(service);
match_info(service_proc) ->
    ?MATCH_SPEC(service_proc);
match_info(service_proc_param) ->
    ?MATCH_SPEC(service_proc_param);
match_info(skyrush) ->
    ?MATCH_SPEC(skyrush);
match_info(source_dungeon) ->
    ?MATCH_SPEC(source_dungeon);
match_info(state) ->
    ?MATCH_SPEC(state);
match_info(sterious_shop) ->
    ?MATCH_SPEC(sterious_shop);
match_info(super_battle) ->
    ?MATCH_SPEC(super_battle);
match_info(sync_arena_rank) ->
    ?MATCH_SPEC(sync_arena_rank);
match_info(sync_arena_report) ->
    ?MATCH_SPEC(sync_arena_report);
match_info(sys_acm_checker) ->
    ?MATCH_SPEC(sys_acm_checker);
match_info(task) ->
    ?MATCH_SPEC(task);
match_info(team) ->
    ?MATCH_SPEC(team);
match_info(trial_data) ->
    ?MATCH_SPEC(trial_data);
match_info(udp_server_option) ->
    ?MATCH_SPEC(udp_server_option);
match_info(url_mini) ->
    ?MATCH_SPEC(url_mini);
match_info(vice_shop) ->
    ?MATCH_SPEC(vice_shop);
match_info(vip_reward) ->
    ?MATCH_SPEC(vip_reward);
match_info(Table) ->
    throw({match_info, not_match, Table}).
new(abs_path) ->
     io:format("~w~n", [lists:zip(record_info(fields, abs_path), tl(tuple_to_list(#abs_path{})))]);
new(account_info) ->
     io:format("~w~n", [lists:zip(record_info(fields, account_info), tl(tuple_to_list(#account_info{})))]);
new(achieve_data) ->
     io:format("~w~n", [lists:zip(record_info(fields, achieve_data), tl(tuple_to_list(#achieve_data{})))]);
new(activity_shop_msg) ->
     io:format("~w~n", [lists:zip(record_info(fields, activity_shop_msg), tl(tuple_to_list(#activity_shop_msg{})))]);
new(activity_shop_record) ->
     io:format("~w~n", [lists:zip(record_info(fields, activity_shop_record), tl(tuple_to_list(#activity_shop_record{})))]);
new(advance_reward) ->
     io:format("~w~n", [lists:zip(record_info(fields, advance_reward), tl(tuple_to_list(#advance_reward{})))]);
new(async_arena_rank) ->
     io:format("~w~n", [lists:zip(record_info(fields, async_arena_rank), tl(tuple_to_list(#async_arena_rank{})))]);
new(async_arena_report) ->
     io:format("~w~n", [lists:zip(record_info(fields, async_arena_report), tl(tuple_to_list(#async_arena_report{})))]);
new(attribute) ->
     io:format("~w~n", [lists:zip(record_info(fields, attribute), tl(tuple_to_list(#attribute{})))]);
new(attribute_info) ->
     io:format("~w~n", [lists:zip(record_info(fields, attribute_info), tl(tuple_to_list(#attribute_info{})))]);
new(base_ability) ->
     io:format("~w~n", [lists:zip(record_info(fields, base_ability), tl(tuple_to_list(#base_ability{})))]);
new(base_activity_twist_egg) ->
     io:format("~w~n", [lists:zip(record_info(fields, base_activity_twist_egg), tl(tuple_to_list(#base_activity_twist_egg{})))]);
new(base_advance_reward) ->
     io:format("~w~n", [lists:zip(record_info(fields, base_advance_reward), tl(tuple_to_list(#base_advance_reward{})))]);
new(base_boss) ->
     io:format("~w~n", [lists:zip(record_info(fields, base_boss), tl(tuple_to_list(#base_boss{})))]);
new(base_choujiang) ->
     io:format("~w~n", [lists:zip(record_info(fields, base_choujiang), tl(tuple_to_list(#base_choujiang{})))]);
new(base_combat_buff) ->
     io:format("~w~n", [lists:zip(record_info(fields, base_combat_buff), tl(tuple_to_list(#base_combat_buff{})))]);
new(base_combat_skill) ->
     io:format("~w~n", [lists:zip(record_info(fields, base_combat_skill), tl(tuple_to_list(#base_combat_skill{})))]);
new(base_combat_skill_passive) ->
     io:format("~w~n", [lists:zip(record_info(fields, base_combat_skill_passive), tl(tuple_to_list(#base_combat_skill_passive{})))]);
new(base_combat_skill_strengthen) ->
     io:format("~w~n", [lists:zip(record_info(fields, base_combat_skill_strengthen), tl(tuple_to_list(#base_combat_skill_strengthen{})))]);
new(base_combat_skill_upgrade) ->
     io:format("~w~n", [lists:zip(record_info(fields, base_combat_skill_upgrade), tl(tuple_to_list(#base_combat_skill_upgrade{})))]);
new(base_competitive_main_shop) ->
     io:format("~w~n", [lists:zip(record_info(fields, base_competitive_main_shop), tl(tuple_to_list(#base_competitive_main_shop{})))]);
new(base_competitive_vice_shop) ->
     io:format("~w~n", [lists:zip(record_info(fields, base_competitive_vice_shop), tl(tuple_to_list(#base_competitive_vice_shop{})))]);
new(base_daily_dungeon_condition) ->
     io:format("~w~n", [lists:zip(record_info(fields, base_daily_dungeon_condition), tl(tuple_to_list(#base_daily_dungeon_condition{})))]);
new(base_daily_dungeon_info) ->
     io:format("~w~n", [lists:zip(record_info(fields, base_daily_dungeon_info), tl(tuple_to_list(#base_daily_dungeon_info{})))]);
new(base_daily_dungeon_lv) ->
     io:format("~w~n", [lists:zip(record_info(fields, base_daily_dungeon_lv), tl(tuple_to_list(#base_daily_dungeon_lv{})))]);
new(base_dungeon_area) ->
     io:format("~w~n", [lists:zip(record_info(fields, base_dungeon_area), tl(tuple_to_list(#base_dungeon_area{})))]);
new(base_dungeon_create_monster) ->
     io:format("~w~n", [lists:zip(record_info(fields, base_dungeon_create_monster), tl(tuple_to_list(#base_dungeon_create_monster{})))]);
new(base_dungeon_create_object) ->
     io:format("~w~n", [lists:zip(record_info(fields, base_dungeon_create_object), tl(tuple_to_list(#base_dungeon_create_object{})))]);
new(base_dungeon_create_portal) ->
     io:format("~w~n", [lists:zip(record_info(fields, base_dungeon_create_portal), tl(tuple_to_list(#base_dungeon_create_portal{})))]);
new(base_dungeon_detail) ->
     io:format("~w~n", [lists:zip(record_info(fields, base_dungeon_detail), tl(tuple_to_list(#base_dungeon_detail{})))]);
new(base_dungeon_match) ->
     io:format("~w~n", [lists:zip(record_info(fields, base_dungeon_match), tl(tuple_to_list(#base_dungeon_match{})))]);
new(base_dungeon_monsters_attribute) ->
     io:format("~w~n", [lists:zip(record_info(fields, base_dungeon_monsters_attribute), tl(tuple_to_list(#base_dungeon_monsters_attribute{})))]);
new(base_dungeon_object_attribute) ->
     io:format("~w~n", [lists:zip(record_info(fields, base_dungeon_object_attribute), tl(tuple_to_list(#base_dungeon_object_attribute{})))]);
new(base_dungeon_target) ->
     io:format("~w~n", [lists:zip(record_info(fields, base_dungeon_target), tl(tuple_to_list(#base_dungeon_target{})))]);
new(base_dungeon_world_boss) ->
     io:format("~w~n", [lists:zip(record_info(fields, base_dungeon_world_boss), tl(tuple_to_list(#base_dungeon_world_boss{})))]);
new(base_error_list) ->
     io:format("~w~n", [lists:zip(record_info(fields, base_error_list), tl(tuple_to_list(#base_error_list{})))]);
new(base_fashion_combination) ->
     io:format("~w~n", [lists:zip(record_info(fields, base_fashion_combination), tl(tuple_to_list(#base_fashion_combination{})))]);
new(base_function_open) ->
     io:format("~w~n", [lists:zip(record_info(fields, base_function_open), tl(tuple_to_list(#base_function_open{})))]);
new(base_general_store) ->
     io:format("~w~n", [lists:zip(record_info(fields, base_general_store), tl(tuple_to_list(#base_general_store{})))]);
new(base_goods) ->
     io:format("~w~n", [lists:zip(record_info(fields, base_goods), tl(tuple_to_list(#base_goods{})))]);
new(base_goods_att_color) ->
     io:format("~w~n", [lists:zip(record_info(fields, base_goods_att_color), tl(tuple_to_list(#base_goods_att_color{})))]);
new(base_goods_att_lv) ->
     io:format("~w~n", [lists:zip(record_info(fields, base_goods_att_lv), tl(tuple_to_list(#base_goods_att_lv{})))]);
new(base_goods_att_rand) ->
     io:format("~w~n", [lists:zip(record_info(fields, base_goods_att_rand), tl(tuple_to_list(#base_goods_att_rand{})))]);
new(base_goods_color_hole) ->
     io:format("~w~n", [lists:zip(record_info(fields, base_goods_color_hole), tl(tuple_to_list(#base_goods_color_hole{})))]);
new(base_goods_jewel) ->
     io:format("~w~n", [lists:zip(record_info(fields, base_goods_jewel), tl(tuple_to_list(#base_goods_jewel{})))]);
new(base_goods_strengthen) ->
     io:format("~w~n", [lists:zip(record_info(fields, base_goods_strengthen), tl(tuple_to_list(#base_goods_strengthen{})))]);
new(base_guild_lv_exp) ->
     io:format("~w~n", [lists:zip(record_info(fields, base_guild_lv_exp), tl(tuple_to_list(#base_guild_lv_exp{})))]);
new(base_guild_rank_integral) ->
     io:format("~w~n", [lists:zip(record_info(fields, base_guild_rank_integral), tl(tuple_to_list(#base_guild_rank_integral{})))]);
new(base_kuafupvp_battle_reward) ->
     io:format("~w~n", [lists:zip(record_info(fields, base_kuafupvp_battle_reward), tl(tuple_to_list(#base_kuafupvp_battle_reward{})))]);
new(base_kuafupvp_rank_reward) ->
     io:format("~w~n", [lists:zip(record_info(fields, base_kuafupvp_rank_reward), tl(tuple_to_list(#base_kuafupvp_rank_reward{})))]);
new(base_kuafupvp_robot_attribute) ->
     io:format("~w~n", [lists:zip(record_info(fields, base_kuafupvp_robot_attribute), tl(tuple_to_list(#base_kuafupvp_robot_attribute{})))]);
new(base_log_user) ->
     io:format("~w~n", [lists:zip(record_info(fields, base_log_user), tl(tuple_to_list(#base_log_user{})))]);
new(base_login_reward) ->
     io:format("~w~n", [lists:zip(record_info(fields, base_login_reward), tl(tuple_to_list(#base_login_reward{})))]);
new(base_mail) ->
     io:format("~w~n", [lists:zip(record_info(fields, base_mail), tl(tuple_to_list(#base_mail{})))]);
new(base_monster_level_attribute) ->
     io:format("~w~n", [lists:zip(record_info(fields, base_monster_level_attribute), tl(tuple_to_list(#base_monster_level_attribute{})))]);
new(base_month_reward) ->
     io:format("~w~n", [lists:zip(record_info(fields, base_month_reward), tl(tuple_to_list(#base_month_reward{})))]);
new(base_mugen_tower) ->
     io:format("~w~n", [lists:zip(record_info(fields, base_mugen_tower), tl(tuple_to_list(#base_mugen_tower{})))]);
new(base_mysterious_shop) ->
     io:format("~w~n", [lists:zip(record_info(fields, base_mysterious_shop), tl(tuple_to_list(#base_mysterious_shop{})))]);
new(base_notice) ->
     io:format("~w~n", [lists:zip(record_info(fields, base_notice), tl(tuple_to_list(#base_notice{})))]);
new(base_operators_mail) ->
     io:format("~w~n", [lists:zip(record_info(fields, base_operators_mail), tl(tuple_to_list(#base_operators_mail{})))]);
new(base_params) ->
     io:format("~w~n", [lists:zip(record_info(fields, base_params), tl(tuple_to_list(#base_params{})))]);
new(base_pvp_battle_reward) ->
     io:format("~w~n", [lists:zip(record_info(fields, base_pvp_battle_reward), tl(tuple_to_list(#base_pvp_battle_reward{})))]);
new(base_pvp_rank_reward) ->
     io:format("~w~n", [lists:zip(record_info(fields, base_pvp_rank_reward), tl(tuple_to_list(#base_pvp_rank_reward{})))]);
new(base_pvp_robot_attribute) ->
     io:format("~w~n", [lists:zip(record_info(fields, base_pvp_robot_attribute), tl(tuple_to_list(#base_pvp_robot_attribute{})))]);
new(base_qianguizhe) ->
     io:format("~w~n", [lists:zip(record_info(fields, base_qianguizhe), tl(tuple_to_list(#base_qianguizhe{})))]);
new(base_rank_reward) ->
     io:format("~w~n", [lists:zip(record_info(fields, base_rank_reward), tl(tuple_to_list(#base_rank_reward{})))]);
new(base_rate) ->
     io:format("~w~n", [lists:zip(record_info(fields, base_rate), tl(tuple_to_list(#base_rate{})))]);
new(base_shop) ->
     io:format("~w~n", [lists:zip(record_info(fields, base_shop), tl(tuple_to_list(#base_shop{})))]);
new(base_shop_activity) ->
     io:format("~w~n", [lists:zip(record_info(fields, base_shop_activity), tl(tuple_to_list(#base_shop_activity{})))]);
new(base_shop_content) ->
     io:format("~w~n", [lists:zip(record_info(fields, base_shop_content), tl(tuple_to_list(#base_shop_content{})))]);
new(base_skill_card) ->
     io:format("~w~n", [lists:zip(record_info(fields, base_skill_card), tl(tuple_to_list(#base_skill_card{})))]);
new(base_skill_exp) ->
     io:format("~w~n", [lists:zip(record_info(fields, base_skill_exp), tl(tuple_to_list(#base_skill_exp{})))]);
new(base_store_product) ->
     io:format("~w~n", [lists:zip(record_info(fields, base_store_product), tl(tuple_to_list(#base_store_product{})))]);
new(base_task) ->
     io:format("~w~n", [lists:zip(record_info(fields, base_task), tl(tuple_to_list(#base_task{})))]);
new(base_twist_egg) ->
     io:format("~w~n", [lists:zip(record_info(fields, base_twist_egg), tl(tuple_to_list(#base_twist_egg{})))]);
new(base_vip) ->
     io:format("~w~n", [lists:zip(record_info(fields, base_vip), tl(tuple_to_list(#base_vip{})))]);
new(base_vip_cost) ->
     io:format("~w~n", [lists:zip(record_info(fields, base_vip_cost), tl(tuple_to_list(#base_vip_cost{})))]);
new(base_xunzhang) ->
     io:format("~w~n", [lists:zip(record_info(fields, base_xunzhang), tl(tuple_to_list(#base_xunzhang{})))]);
new(battle_attribute) ->
     io:format("~w~n", [lists:zip(record_info(fields, battle_attribute), tl(tuple_to_list(#battle_attribute{})))]);
new(bossinfo) ->
     io:format("~w~n", [lists:zip(record_info(fields, bossinfo), tl(tuple_to_list(#bossinfo{})))]);
new(camp) ->
     io:format("~w~n", [lists:zip(record_info(fields, camp), tl(tuple_to_list(#camp{})))]);
new(chat_league) ->
     io:format("~w~n", [lists:zip(record_info(fields, chat_league), tl(tuple_to_list(#chat_league{})))]);
new(chat_private) ->
     io:format("~w~n", [lists:zip(record_info(fields, chat_private), tl(tuple_to_list(#chat_private{})))]);
new(chats_world) ->
     io:format("~w~n", [lists:zip(record_info(fields, chats_world), tl(tuple_to_list(#chats_world{})))]);
new(choujiang_info) ->
     io:format("~w~n", [lists:zip(record_info(fields, choujiang_info), tl(tuple_to_list(#choujiang_info{})))]);
new(client) ->
     io:format("~w~n", [lists:zip(record_info(fields, client), tl(tuple_to_list(#client{})))]);
new(collect_status) ->
     io:format("~w~n", [lists:zip(record_info(fields, collect_status), tl(tuple_to_list(#collect_status{})))]);
new(combat_attri) ->
     io:format("~w~n", [lists:zip(record_info(fields, combat_attri), tl(tuple_to_list(#combat_attri{})))]);
new(common_reward) ->
     io:format("~w~n", [lists:zip(record_info(fields, common_reward), tl(tuple_to_list(#common_reward{})))]);
new(count_record) ->
     io:format("~w~n", [lists:zip(record_info(fields, count_record), tl(tuple_to_list(#count_record{})))]);
new(counter) ->
     io:format("~w~n", [lists:zip(record_info(fields, counter), tl(tuple_to_list(#counter{})))]);
new(cross_pvp_enemy) ->
     io:format("~w~n", [lists:zip(record_info(fields, cross_pvp_enemy), tl(tuple_to_list(#cross_pvp_enemy{})))]);
new(cross_pvp_event) ->
     io:format("~w~n", [lists:zip(record_info(fields, cross_pvp_event), tl(tuple_to_list(#cross_pvp_event{})))]);
new(cross_pvp_fighter) ->
     io:format("~w~n", [lists:zip(record_info(fields, cross_pvp_fighter), tl(tuple_to_list(#cross_pvp_fighter{})))]);
new(cross_pvp_island) ->
     io:format("~w~n", [lists:zip(record_info(fields, cross_pvp_island), tl(tuple_to_list(#cross_pvp_island{})))]);
new(cross_pvp_npc) ->
     io:format("~w~n", [lists:zip(record_info(fields, cross_pvp_npc), tl(tuple_to_list(#cross_pvp_npc{})))]);
new(cross_pvp_record) ->
     io:format("~w~n", [lists:zip(record_info(fields, cross_pvp_record), tl(tuple_to_list(#cross_pvp_record{})))]);
new(ct_robot) ->
     io:format("~w~n", [lists:zip(record_info(fields, ct_robot), tl(tuple_to_list(#ct_robot{})))]);
new(daily_dungeon) ->
     io:format("~w~n", [lists:zip(record_info(fields, daily_dungeon), tl(tuple_to_list(#daily_dungeon{})))]);
new(data_base_activity) ->
     io:format("~w~n", [lists:zip(record_info(fields, data_base_activity), tl(tuple_to_list(#data_base_activity{})))]);
new(data_base_fashion) ->
     io:format("~w~n", [lists:zip(record_info(fields, data_base_fashion), tl(tuple_to_list(#data_base_fashion{})))]);
new(data_mon) ->
     io:format("~w~n", [lists:zip(record_info(fields, data_mon), tl(tuple_to_list(#data_mon{})))]);
new(defend_point) ->
     io:format("~w~n", [lists:zip(record_info(fields, defend_point), tl(tuple_to_list(#defend_point{})))]);
new(df_elem) ->
     io:format("~w~n", [lists:zip(record_info(fields, df_elem), tl(tuple_to_list(#df_elem{})))]);
new(dungeon) ->
     io:format("~w~n", [lists:zip(record_info(fields, dungeon), tl(tuple_to_list(#dungeon{})))]);
new(dungeon_info) ->
     io:format("~w~n", [lists:zip(record_info(fields, dungeon_info), tl(tuple_to_list(#dungeon_info{})))]);
new(dungeon_match) ->
     io:format("~w~n", [lists:zip(record_info(fields, dungeon_match), tl(tuple_to_list(#dungeon_match{})))]);
new(dungeon_mop_up) ->
     io:format("~w~n", [lists:zip(record_info(fields, dungeon_mop_up), tl(tuple_to_list(#dungeon_mop_up{})))]);
new(dungeon_mugen) ->
     io:format("~w~n", [lists:zip(record_info(fields, dungeon_mugen), tl(tuple_to_list(#dungeon_mugen{})))]);
new(dungeon_rewards) ->
     io:format("~w~n", [lists:zip(record_info(fields, dungeon_rewards), tl(tuple_to_list(#dungeon_rewards{})))]);
new(dungeon_schedule) ->
     io:format("~w~n", [lists:zip(record_info(fields, dungeon_schedule), tl(tuple_to_list(#dungeon_schedule{})))]);
new(emo_query) ->
     io:format("~w~n", [lists:zip(record_info(fields, emo_query), tl(tuple_to_list(#emo_query{})))]);
new(equip_attribute) ->
     io:format("~w~n", [lists:zip(record_info(fields, equip_attribute), tl(tuple_to_list(#equip_attribute{})))]);
new(error_msg) ->
     io:format("~w~n", [lists:zip(record_info(fields, error_msg), tl(tuple_to_list(#error_msg{})))]);
new(ets_base_app_store_product) ->
     io:format("~w~n", [lists:zip(record_info(fields, ets_base_app_store_product), tl(tuple_to_list(#ets_base_app_store_product{})))]);
new(ets_base_equipment) ->
     io:format("~w~n", [lists:zip(record_info(fields, ets_base_equipment), tl(tuple_to_list(#ets_base_equipment{})))]);
new(ets_base_equipment_property) ->
     io:format("~w~n", [lists:zip(record_info(fields, ets_base_equipment_property), tl(tuple_to_list(#ets_base_equipment_property{})))]);
new(ets_base_equipment_upgrade) ->
     io:format("~w~n", [lists:zip(record_info(fields, ets_base_equipment_upgrade), tl(tuple_to_list(#ets_base_equipment_upgrade{})))]);
new(ets_base_login_gift) ->
     io:format("~w~n", [lists:zip(record_info(fields, ets_base_login_gift), tl(tuple_to_list(#ets_base_login_gift{})))]);
new(ets_base_mon) ->
     io:format("~w~n", [lists:zip(record_info(fields, ets_base_mon), tl(tuple_to_list(#ets_base_mon{})))]);
new(ets_base_online_gift) ->
     io:format("~w~n", [lists:zip(record_info(fields, ets_base_online_gift), tl(tuple_to_list(#ets_base_online_gift{})))]);
new(ets_base_player) ->
     io:format("~w~n", [lists:zip(record_info(fields, ets_base_player), tl(tuple_to_list(#ets_base_player{})))]);
new(ets_base_protocol) ->
     io:format("~w~n", [lists:zip(record_info(fields, ets_base_protocol), tl(tuple_to_list(#ets_base_protocol{})))]);
new(ets_base_sys_acm) ->
     io:format("~w~n", [lists:zip(record_info(fields, ets_base_sys_acm), tl(tuple_to_list(#ets_base_sys_acm{})))]);
new(ets_log_mail) ->
     io:format("~w~n", [lists:zip(record_info(fields, ets_log_mail), tl(tuple_to_list(#ets_log_mail{})))]);
new(ets_pay_info) ->
     io:format("~w~n", [lists:zip(record_info(fields, ets_pay_info), tl(tuple_to_list(#ets_pay_info{})))]);
new(ets_process) ->
     io:format("~w~n", [lists:zip(record_info(fields, ets_process), tl(tuple_to_list(#ets_process{})))]);
new(ets_push_schedule) ->
     io:format("~w~n", [lists:zip(record_info(fields, ets_push_schedule), tl(tuple_to_list(#ets_push_schedule{})))]);
new(ets_shop_goods) ->
     io:format("~w~n", [lists:zip(record_info(fields, ets_shop_goods), tl(tuple_to_list(#ets_shop_goods{})))]);
new(fashion) ->
     io:format("~w~n", [lists:zip(record_info(fields, fashion), tl(tuple_to_list(#fashion{})))]);
new(fashion_record) ->
     io:format("~w~n", [lists:zip(record_info(fields, fashion_record), tl(tuple_to_list(#fashion_record{})))]);
new(field) ->
     io:format("~w~n", [lists:zip(record_info(fields, field), tl(tuple_to_list(#field{})))]);
new(fight_league) ->
     io:format("~w~n", [lists:zip(record_info(fields, fight_league), tl(tuple_to_list(#fight_league{})))]);
new(fight_league_copy) ->
     io:format("~w~n", [lists:zip(record_info(fields, fight_league_copy), tl(tuple_to_list(#fight_league_copy{})))]);
new(fight_member) ->
     io:format("~w~n", [lists:zip(record_info(fields, fight_member), tl(tuple_to_list(#fight_member{})))]);
new(fight_record) ->
     io:format("~w~n", [lists:zip(record_info(fields, fight_record), tl(tuple_to_list(#fight_record{})))]);
new(fns_elem) ->
     io:format("~w~n", [lists:zip(record_info(fields, fns_elem), tl(tuple_to_list(#fns_elem{})))]);
new(g17_guild) ->
     io:format("~w~n", [lists:zip(record_info(fields, g17_guild), tl(tuple_to_list(#g17_guild{})))]);
new(g17_guild_apply) ->
     io:format("~w~n", [lists:zip(record_info(fields, g17_guild_apply), tl(tuple_to_list(#g17_guild_apply{})))]);
new(g17_guild_member) ->
     io:format("~w~n", [lists:zip(record_info(fields, g17_guild_member), tl(tuple_to_list(#g17_guild_member{})))]);
new(g_feats_elem) ->
     io:format("~w~n", [lists:zip(record_info(fields, g_feats_elem), tl(tuple_to_list(#g_feats_elem{})))]);
new(gateway_agent) ->
     io:format("~w~n", [lists:zip(record_info(fields, gateway_agent), tl(tuple_to_list(#gateway_agent{})))]);
new(gateway_client) ->
     io:format("~w~n", [lists:zip(record_info(fields, gateway_client), tl(tuple_to_list(#gateway_client{})))]);
new(general_store) ->
     io:format("~w~n", [lists:zip(record_info(fields, general_store), tl(tuple_to_list(#general_store{})))]);
new(generate_conf) ->
     io:format("~w~n", [lists:zip(record_info(fields, generate_conf), tl(tuple_to_list(#generate_conf{})))]);
new(goods) ->
     io:format("~w~n", [lists:zip(record_info(fields, goods), tl(tuple_to_list(#goods{})))]);
new(guild_mem_skyrush_rank) ->
     io:format("~w~n", [lists:zip(record_info(fields, guild_mem_skyrush_rank), tl(tuple_to_list(#guild_mem_skyrush_rank{})))]);
new(guild_skyrush_rank) ->
     io:format("~w~n", [lists:zip(record_info(fields, guild_skyrush_rank), tl(tuple_to_list(#guild_skyrush_rank{})))]);
new(help_battle) ->
     io:format("~w~n", [lists:zip(record_info(fields, help_battle), tl(tuple_to_list(#help_battle{})))]);
new(hold_info) ->
     io:format("~w~n", [lists:zip(record_info(fields, hold_info), tl(tuple_to_list(#hold_info{})))]);
new(http_request) ->
     io:format("~w~n", [lists:zip(record_info(fields, http_request), tl(tuple_to_list(#http_request{})))]);
new(http_response) ->
     io:format("~w~n", [lists:zip(record_info(fields, http_response), tl(tuple_to_list(#http_response{})))]);
new(init_data) ->
     io:format("~w~n", [lists:zip(record_info(fields, init_data), tl(tuple_to_list(#init_data{})))]);
new(league) ->
     io:format("~w~n", [lists:zip(record_info(fields, league), tl(tuple_to_list(#league{})))]);
new(league_apply_info) ->
     io:format("~w~n", [lists:zip(record_info(fields, league_apply_info), tl(tuple_to_list(#league_apply_info{})))]);
new(league_challenge_record) ->
     io:format("~w~n", [lists:zip(record_info(fields, league_challenge_record), tl(tuple_to_list(#league_challenge_record{})))]);
new(league_fight_point) ->
     io:format("~w~n", [lists:zip(record_info(fields, league_fight_point), tl(tuple_to_list(#league_fight_point{})))]);
new(league_fight_state) ->
     io:format("~w~n", [lists:zip(record_info(fields, league_fight_state), tl(tuple_to_list(#league_fight_state{})))]);
new(league_gifts) ->
     io:format("~w~n", [lists:zip(record_info(fields, league_gifts), tl(tuple_to_list(#league_gifts{})))]);
new(league_gifts_record) ->
     io:format("~w~n", [lists:zip(record_info(fields, league_gifts_record), tl(tuple_to_list(#league_gifts_record{})))]);
new(league_member) ->
     io:format("~w~n", [lists:zip(record_info(fields, league_member), tl(tuple_to_list(#league_member{})))]);
new(league_member_challenge) ->
     io:format("~w~n", [lists:zip(record_info(fields, league_member_challenge), tl(tuple_to_list(#league_member_challenge{})))]);
new(league_msg) ->
     io:format("~w~n", [lists:zip(record_info(fields, league_msg), tl(tuple_to_list(#league_msg{})))]);
new(league_recharge_gold_record) ->
     io:format("~w~n", [lists:zip(record_info(fields, league_recharge_gold_record), tl(tuple_to_list(#league_recharge_gold_record{})))]);
new(league_relation) ->
     io:format("~w~n", [lists:zip(record_info(fields, league_relation), tl(tuple_to_list(#league_relation{})))]);
new(log_device) ->
     io:format("~w~n", [lists:zip(record_info(fields, log_device), tl(tuple_to_list(#log_device{})))]);
new(log_login) ->
     io:format("~w~n", [lists:zip(record_info(fields, log_login), tl(tuple_to_list(#log_login{})))]);
new(log_player) ->
     io:format("~w~n", [lists:zip(record_info(fields, log_player), tl(tuple_to_list(#log_player{})))]);
new(log_player_chat) ->
     io:format("~w~n", [lists:zip(record_info(fields, log_player_chat), tl(tuple_to_list(#log_player_chat{})))]);
new(log_player_create) ->
     io:format("~w~n", [lists:zip(record_info(fields, log_player_create), tl(tuple_to_list(#log_player_create{})))]);
new(log_player_feedback) ->
     io:format("~w~n", [lists:zip(record_info(fields, log_player_feedback), tl(tuple_to_list(#log_player_feedback{})))]);
new(log_player_login) ->
     io:format("~w~n", [lists:zip(record_info(fields, log_player_login), tl(tuple_to_list(#log_player_login{})))]);
new(log_player_mini) ->
     io:format("~w~n", [lists:zip(record_info(fields, log_player_mini), tl(tuple_to_list(#log_player_mini{})))]);
new(log_player_online) ->
     io:format("~w~n", [lists:zip(record_info(fields, log_player_online), tl(tuple_to_list(#log_player_online{})))]);
new(log_state) ->
     io:format("~w~n", [lists:zip(record_info(fields, log_state), tl(tuple_to_list(#log_state{})))]);
new(log_system) ->
     io:format("~w~n", [lists:zip(record_info(fields, log_system), tl(tuple_to_list(#log_system{})))]);
new(log_twist_eggs) ->
     io:format("~w~n", [lists:zip(record_info(fields, log_twist_eggs), tl(tuple_to_list(#log_twist_eggs{})))]);
new(log_uplevel) ->
     io:format("~w~n", [lists:zip(record_info(fields, log_uplevel), tl(tuple_to_list(#log_uplevel{})))]);
new(lucky_coin) ->
     io:format("~w~n", [lists:zip(record_info(fields, lucky_coin), tl(tuple_to_list(#lucky_coin{})))]);
new(mails) ->
     io:format("~w~n", [lists:zip(record_info(fields, mails), tl(tuple_to_list(#mails{})))]);
new(main_shop) ->
     io:format("~w~n", [lists:zip(record_info(fields, main_shop), tl(tuple_to_list(#main_shop{})))]);
new(main_shop_msg) ->
     io:format("~w~n", [lists:zip(record_info(fields, main_shop_msg), tl(tuple_to_list(#main_shop_msg{})))]);
new(master_apprentice) ->
     io:format("~w~n", [lists:zip(record_info(fields, master_apprentice), tl(tuple_to_list(#master_apprentice{})))]);
new(master_request_msg) ->
     io:format("~w~n", [lists:zip(record_info(fields, master_request_msg), tl(tuple_to_list(#master_request_msg{})))]);
new(mdb_challenge_info) ->
     io:format("~w~n", [lists:zip(record_info(fields, mdb_challenge_info), tl(tuple_to_list(#mdb_challenge_info{})))]);
new(mdb_dungeon_info) ->
     io:format("~w~n", [lists:zip(record_info(fields, mdb_dungeon_info), tl(tuple_to_list(#mdb_dungeon_info{})))]);
new(mdb_shop_msg) ->
     io:format("~w~n", [lists:zip(record_info(fields, mdb_shop_msg), tl(tuple_to_list(#mdb_shop_msg{})))]);
new(mem_feats_elem) ->
     io:format("~w~n", [lists:zip(record_info(fields, mem_feats_elem), tl(tuple_to_list(#mem_feats_elem{})))]);
new(member) ->
     io:format("~w~n", [lists:zip(record_info(fields, member), tl(tuple_to_list(#member{})))]);
new(mnesia_upgrade_conf) ->
     io:format("~w~n", [lists:zip(record_info(fields, mnesia_upgrade_conf), tl(tuple_to_list(#mnesia_upgrade_conf{})))]);
new(mod) ->
     io:format("~w~n", [lists:zip(record_info(fields, mod), tl(tuple_to_list(#mod{})))]);
new(mod_player_state) ->
     io:format("~w~n", [lists:zip(record_info(fields, mod_player_state), tl(tuple_to_list(#mod_player_state{})))]);
new(mugen_reward) ->
     io:format("~w~n", [lists:zip(record_info(fields, mugen_reward), tl(tuple_to_list(#mugen_reward{})))]);
new(node_status) ->
     io:format("~w~n", [lists:zip(record_info(fields, node_status), tl(tuple_to_list(#node_status{})))]);
new(open_boss_rank) ->
     io:format("~w~n", [lists:zip(record_info(fields, open_boss_rank), tl(tuple_to_list(#open_boss_rank{})))]);
new(operators_mail) ->
     io:format("~w~n", [lists:zip(record_info(fields, operators_mail), tl(tuple_to_list(#operators_mail{})))]);
new(ordinary_shop) ->
     io:format("~w~n", [lists:zip(record_info(fields, ordinary_shop), tl(tuple_to_list(#ordinary_shop{})))]);
new(ordinary_shop_msg) ->
     io:format("~w~n", [lists:zip(record_info(fields, ordinary_shop_msg), tl(tuple_to_list(#ordinary_shop_msg{})))]);
new(own_gift) ->
     io:format("~w~n", [lists:zip(record_info(fields, own_gift), tl(tuple_to_list(#own_gift{})))]);
new(pass_dungeon_info) ->
     io:format("~w~n", [lists:zip(record_info(fields, pass_dungeon_info), tl(tuple_to_list(#pass_dungeon_info{})))]);
new(pay_gifts) ->
     io:format("~w~n", [lists:zip(record_info(fields, pay_gifts), tl(tuple_to_list(#pay_gifts{})))]);
new(pay_info) ->
     io:format("~w~n", [lists:zip(record_info(fields, pay_info), tl(tuple_to_list(#pay_info{})))]);
new(pbaccount) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbaccount), tl(tuple_to_list(#pbaccount{})))]);
new(pbaccountlogin) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbaccountlogin), tl(tuple_to_list(#pbaccountlogin{})))]);
new(pbactivity) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbactivity), tl(tuple_to_list(#pbactivity{})))]);
new(pbactivitylist) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbactivitylist), tl(tuple_to_list(#pbactivitylist{})))]);
new(pbactivityshop) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbactivityshop), tl(tuple_to_list(#pbactivityshop{})))]);
new(pbactivityshopmsg) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbactivityshopmsg), tl(tuple_to_list(#pbactivityshopmsg{})))]);
new(pbaddleaguemsg) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbaddleaguemsg), tl(tuple_to_list(#pbaddleaguemsg{})))]);
new(pballmasterinfo) ->
     io:format("~w~n", [lists:zip(record_info(fields, pballmasterinfo), tl(tuple_to_list(#pballmasterinfo{})))]);
new(pbappointplayer) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbappointplayer), tl(tuple_to_list(#pbappointplayer{})))]);
new(pbapprenticebuycard) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbapprenticebuycard), tl(tuple_to_list(#pbapprenticebuycard{})))]);
new(pbapprenticecard) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbapprenticecard), tl(tuple_to_list(#pbapprenticecard{})))]);
new(pbapprenticerequestinfo) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbapprenticerequestinfo), tl(tuple_to_list(#pbapprenticerequestinfo{})))]);
new(pbarenabattlereport) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbarenabattlereport), tl(tuple_to_list(#pbarenabattlereport{})))]);
new(pbarenabattlereportlist) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbarenabattlereportlist), tl(tuple_to_list(#pbarenabattlereportlist{})))]);
new(pbarenachallenge) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbarenachallenge), tl(tuple_to_list(#pbarenachallenge{})))]);
new(pbarenainfo) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbarenainfo), tl(tuple_to_list(#pbarenainfo{})))]);
new(pbarenainfolist) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbarenainfolist), tl(tuple_to_list(#pbarenainfolist{})))]);
new(pbarenauser) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbarenauser), tl(tuple_to_list(#pbarenauser{})))]);
new(pbarenauserlist) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbarenauserlist), tl(tuple_to_list(#pbarenauserlist{})))]);
new(pbattribute) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbattribute), tl(tuple_to_list(#pbattribute{})))]);
new(pbbossinvitemsg) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbbossinvitemsg), tl(tuple_to_list(#pbbossinvitemsg{})))]);
new(pbbosslist) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbbosslist), tl(tuple_to_list(#pbbosslist{})))]);
new(pbbosssendgold) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbbosssendgold), tl(tuple_to_list(#pbbosssendgold{})))]);
new(pbcamp) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbcamp), tl(tuple_to_list(#pbcamp{})))]);
new(pbcamppos) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbcamppos), tl(tuple_to_list(#pbcamppos{})))]);
new(pbcardinfo) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbcardinfo), tl(tuple_to_list(#pbcardinfo{})))]);
new(pbcardrequest) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbcardrequest), tl(tuple_to_list(#pbcardrequest{})))]);
new(pbcardrequestlist) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbcardrequestlist), tl(tuple_to_list(#pbcardrequestlist{})))]);
new(pbcdkreward) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbcdkreward), tl(tuple_to_list(#pbcdkreward{})))]);
new(pbchallengedungeon) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbchallengedungeon), tl(tuple_to_list(#pbchallengedungeon{})))]);
new(pbchallengedungeoninfo) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbchallengedungeoninfo), tl(tuple_to_list(#pbchallengedungeoninfo{})))]);
new(pbchallengedungeonrank) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbchallengedungeonrank), tl(tuple_to_list(#pbchallengedungeonrank{})))]);
new(pbchallengerecord) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbchallengerecord), tl(tuple_to_list(#pbchallengerecord{})))]);
new(pbchallengerecordlist) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbchallengerecordlist), tl(tuple_to_list(#pbchallengerecordlist{})))]);
new(pbchat) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbchat), tl(tuple_to_list(#pbchat{})))]);
new(pbchatlist) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbchatlist), tl(tuple_to_list(#pbchatlist{})))]);
new(pbchoujiang) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbchoujiang), tl(tuple_to_list(#pbchoujiang{})))]);
new(pbchoujianggoods) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbchoujianggoods), tl(tuple_to_list(#pbchoujianggoods{})))]);
new(pbchoujianginfo) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbchoujianginfo), tl(tuple_to_list(#pbchoujianginfo{})))]);
new(pbchoujiangresult) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbchoujiangresult), tl(tuple_to_list(#pbchoujiangresult{})))]);
new(pbcombatbuff) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbcombatbuff), tl(tuple_to_list(#pbcombatbuff{})))]);
new(pbcombateffect) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbcombateffect), tl(tuple_to_list(#pbcombateffect{})))]);
new(pbcombatfighter) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbcombatfighter), tl(tuple_to_list(#pbcombatfighter{})))]);
new(pbcombathurtattri) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbcombathurtattri), tl(tuple_to_list(#pbcombathurtattri{})))]);
new(pbcombatreport) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbcombatreport), tl(tuple_to_list(#pbcombatreport{})))]);
new(pbcombatreportlist) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbcombatreportlist), tl(tuple_to_list(#pbcombatreportlist{})))]);
new(pbcombatrespon) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbcombatrespon), tl(tuple_to_list(#pbcombatrespon{})))]);
new(pbcombatreward) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbcombatreward), tl(tuple_to_list(#pbcombatreward{})))]);
new(pbcombatround) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbcombatround), tl(tuple_to_list(#pbcombatround{})))]);
new(pbcombattarget) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbcombattarget), tl(tuple_to_list(#pbcombattarget{})))]);
new(pbcountrecord) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbcountrecord), tl(tuple_to_list(#pbcountrecord{})))]);
new(pbcountrecords) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbcountrecords), tl(tuple_to_list(#pbcountrecords{})))]);
new(pbcreatearole) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbcreatearole), tl(tuple_to_list(#pbcreatearole{})))]);
new(pbcreaturedrop) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbcreaturedrop), tl(tuple_to_list(#pbcreaturedrop{})))]);
new(pbcritmsg) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbcritmsg), tl(tuple_to_list(#pbcritmsg{})))]);
new(pbcrossfighter) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbcrossfighter), tl(tuple_to_list(#pbcrossfighter{})))]);
new(pbcrosshistory) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbcrosshistory), tl(tuple_to_list(#pbcrosshistory{})))]);
new(pbcrosshistorylist) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbcrosshistorylist), tl(tuple_to_list(#pbcrosshistorylist{})))]);
new(pbcrossisland) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbcrossisland), tl(tuple_to_list(#pbcrossisland{})))]);
new(pbcrossrecord) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbcrossrecord), tl(tuple_to_list(#pbcrossrecord{})))]);
new(pbdailydungeon) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbdailydungeon), tl(tuple_to_list(#pbdailydungeon{})))]);
new(pbdungeon) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbdungeon), tl(tuple_to_list(#pbdungeon{})))]);
new(pbdungeoncondition) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbdungeoncondition), tl(tuple_to_list(#pbdungeoncondition{})))]);
new(pbdungeoncreature) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbdungeoncreature), tl(tuple_to_list(#pbdungeoncreature{})))]);
new(pbdungeonmonster) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbdungeonmonster), tl(tuple_to_list(#pbdungeonmonster{})))]);
new(pbdungeonreward) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbdungeonreward), tl(tuple_to_list(#pbdungeonreward{})))]);
new(pbdungeonschedule) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbdungeonschedule), tl(tuple_to_list(#pbdungeonschedule{})))]);
new(pbdungeonschedulelist) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbdungeonschedulelist), tl(tuple_to_list(#pbdungeonschedulelist{})))]);
new(pbdungeontarget) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbdungeontarget), tl(tuple_to_list(#pbdungeontarget{})))]);
new(pbequipaddstar) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbequipaddstar), tl(tuple_to_list(#pbequipaddstar{})))]);
new(pbequipmove) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbequipmove), tl(tuple_to_list(#pbequipmove{})))]);
new(pbequipstrengthen) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbequipstrengthen), tl(tuple_to_list(#pbequipstrengthen{})))]);
new(pberror) ->
     io:format("~w~n", [lists:zip(record_info(fields, pberror), tl(tuple_to_list(#pberror{})))]);
new(pbfashion) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbfashion), tl(tuple_to_list(#pbfashion{})))]);
new(pbfashionlist) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbfashionlist), tl(tuple_to_list(#pbfashionlist{})))]);
new(pbfeedbackmsg) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbfeedbackmsg), tl(tuple_to_list(#pbfeedbackmsg{})))]);
new(pbfightrecords) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbfightrecords), tl(tuple_to_list(#pbfightrecords{})))]);
new(pbflipcard) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbflipcard), tl(tuple_to_list(#pbflipcard{})))]);
new(pbfriend) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbfriend), tl(tuple_to_list(#pbfriend{})))]);
new(pbfriendlist) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbfriendlist), tl(tuple_to_list(#pbfriendlist{})))]);
new(pbg17guild) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbg17guild), tl(tuple_to_list(#pbg17guild{})))]);
new(pbg17guildlist) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbg17guildlist), tl(tuple_to_list(#pbg17guildlist{})))]);
new(pbg17guildmember) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbg17guildmember), tl(tuple_to_list(#pbg17guildmember{})))]);
new(pbg17guildquery) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbg17guildquery), tl(tuple_to_list(#pbg17guildquery{})))]);
new(pbgeneralstorebuy) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbgeneralstorebuy), tl(tuple_to_list(#pbgeneralstorebuy{})))]);
new(pbgeneralstoreinfo) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbgeneralstoreinfo), tl(tuple_to_list(#pbgeneralstoreinfo{})))]);
new(pbgetleague) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbgetleague), tl(tuple_to_list(#pbgetleague{})))]);
new(pbgetleaguegrouprankinfo) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbgetleaguegrouprankinfo), tl(tuple_to_list(#pbgetleaguegrouprankinfo{})))]);
new(pbgetleaguestatu) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbgetleaguestatu), tl(tuple_to_list(#pbgetleaguestatu{})))]);
new(pbgetpointrecord) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbgetpointrecord), tl(tuple_to_list(#pbgetpointrecord{})))]);
new(pbgiftsid) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbgiftsid), tl(tuple_to_list(#pbgiftsid{})))]);
new(pbgiftsrecord) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbgiftsrecord), tl(tuple_to_list(#pbgiftsrecord{})))]);
new(pbgiftsrecordlist) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbgiftsrecordlist), tl(tuple_to_list(#pbgiftsrecordlist{})))]);
new(pbgoods) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbgoods), tl(tuple_to_list(#pbgoods{})))]);
new(pbgoodschanged) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbgoodschanged), tl(tuple_to_list(#pbgoodschanged{})))]);
new(pbgoodsinfo) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbgoodsinfo), tl(tuple_to_list(#pbgoodsinfo{})))]);
new(pbgoodslist) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbgoodslist), tl(tuple_to_list(#pbgoodslist{})))]);
new(pbhitrewarddetail) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbhitrewarddetail), tl(tuple_to_list(#pbhitrewarddetail{})))]);
new(pbid32) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbid32), tl(tuple_to_list(#pbid32{})))]);
new(pbid32r) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbid32r), tl(tuple_to_list(#pbid32r{})))]);
new(pbid64) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbid64), tl(tuple_to_list(#pbid64{})))]);
new(pbid64list) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbid64list), tl(tuple_to_list(#pbid64list{})))]);
new(pbid64r) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbid64r), tl(tuple_to_list(#pbid64r{})))]);
new(pbidstring) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbidstring), tl(tuple_to_list(#pbidstring{})))]);
new(pbinlaidjewel) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbinlaidjewel), tl(tuple_to_list(#pbinlaidjewel{})))]);
new(pbleagifts) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbleagifts), tl(tuple_to_list(#pbleagifts{})))]);
new(pbleague) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbleague), tl(tuple_to_list(#pbleague{})))]);
new(pbleaguechallengeinfo) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbleaguechallengeinfo), tl(tuple_to_list(#pbleaguechallengeinfo{})))]);
new(pbleaguechallengelist) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbleaguechallengelist), tl(tuple_to_list(#pbleaguechallengelist{})))]);
new(pbleaguechallengeresult) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbleaguechallengeresult), tl(tuple_to_list(#pbleaguechallengeresult{})))]);
new(pbleaguefightpoint) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbleaguefightpoint), tl(tuple_to_list(#pbleaguefightpoint{})))]);
new(pbleaguefightpointlist) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbleaguefightpointlist), tl(tuple_to_list(#pbleaguefightpointlist{})))]);
new(pbleaguefightrankinfo) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbleaguefightrankinfo), tl(tuple_to_list(#pbleaguefightrankinfo{})))]);
new(pbleaguegifts) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbleaguegifts), tl(tuple_to_list(#pbleaguegifts{})))]);
new(pbleaguehouse) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbleaguehouse), tl(tuple_to_list(#pbleaguehouse{})))]);
new(pbleaguehouserecord) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbleaguehouserecord), tl(tuple_to_list(#pbleaguehouserecord{})))]);
new(pbleagueinfo) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbleagueinfo), tl(tuple_to_list(#pbleagueinfo{})))]);
new(pbleagueinfolist) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbleagueinfolist), tl(tuple_to_list(#pbleagueinfolist{})))]);
new(pbleaguelist) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbleaguelist), tl(tuple_to_list(#pbleaguelist{})))]);
new(pbleaguemember) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbleaguemember), tl(tuple_to_list(#pbleaguemember{})))]);
new(pbleaguememberlist) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbleaguememberlist), tl(tuple_to_list(#pbleaguememberlist{})))]);
new(pbleaguepointchallengeresult) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbleaguepointchallengeresult), tl(tuple_to_list(#pbleaguepointchallengeresult{})))]);
new(pbleaguerankinfo) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbleaguerankinfo), tl(tuple_to_list(#pbleaguerankinfo{})))]);
new(pbleagueranklist) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbleagueranklist), tl(tuple_to_list(#pbleagueranklist{})))]);
new(pbmail) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbmail), tl(tuple_to_list(#pbmail{})))]);
new(pbmailgoods) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbmailgoods), tl(tuple_to_list(#pbmailgoods{})))]);
new(pbmaillist) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbmaillist), tl(tuple_to_list(#pbmaillist{})))]);
new(pbmasteragreemsg) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbmasteragreemsg), tl(tuple_to_list(#pbmasteragreemsg{})))]);
new(pbmastercard) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbmastercard), tl(tuple_to_list(#pbmastercard{})))]);
new(pbmasterinfo) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbmasterinfo), tl(tuple_to_list(#pbmasterinfo{})))]);
new(pbmember) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbmember), tl(tuple_to_list(#pbmember{})))]);
new(pbmembergetlisttype) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbmembergetlisttype), tl(tuple_to_list(#pbmembergetlisttype{})))]);
new(pbmembersendlist) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbmembersendlist), tl(tuple_to_list(#pbmembersendlist{})))]);
new(pbmembersendmsg) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbmembersendmsg), tl(tuple_to_list(#pbmembersendmsg{})))]);
new(pbmonsterdrop) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbmonsterdrop), tl(tuple_to_list(#pbmonsterdrop{})))]);
new(pbmopup) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbmopup), tl(tuple_to_list(#pbmopup{})))]);
new(pbmopuplist) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbmopuplist), tl(tuple_to_list(#pbmopuplist{})))]);
new(pbmugenchallenge) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbmugenchallenge), tl(tuple_to_list(#pbmugenchallenge{})))]);
new(pbnewiteminfo) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbnewiteminfo), tl(tuple_to_list(#pbnewiteminfo{})))]);
new(pbnewmsg) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbnewmsg), tl(tuple_to_list(#pbnewmsg{})))]);
new(pbnotice) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbnotice), tl(tuple_to_list(#pbnotice{})))]);
new(pbnoticelist) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbnoticelist), tl(tuple_to_list(#pbnoticelist{})))]);
new(pbnull) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbnull), tl(tuple_to_list(#pbnull{})))]);
new(pbonekeysendmsg) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbonekeysendmsg), tl(tuple_to_list(#pbonekeysendmsg{})))]);
new(pbopenboss) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbopenboss), tl(tuple_to_list(#pbopenboss{})))]);
new(pbordinarybuy) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbordinarybuy), tl(tuple_to_list(#pbordinarybuy{})))]);
new(pbowncardsinfo) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbowncardsinfo), tl(tuple_to_list(#pbowncardsinfo{})))]);
new(pbowngifts) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbowngifts), tl(tuple_to_list(#pbowngifts{})))]);
new(pbplayerachieve) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbplayerachieve), tl(tuple_to_list(#pbplayerachieve{})))]);
new(pbplayerachievelist) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbplayerachievelist), tl(tuple_to_list(#pbplayerachievelist{})))]);
new(pbplayercamp) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbplayercamp), tl(tuple_to_list(#pbplayercamp{})))]);
new(pbplayergifts) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbplayergifts), tl(tuple_to_list(#pbplayergifts{})))]);
new(pbpointchallengerecord) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbpointchallengerecord), tl(tuple_to_list(#pbpointchallengerecord{})))]);
new(pbpointchallengerecordinfo) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbpointchallengerecordinfo), tl(tuple_to_list(#pbpointchallengerecordinfo{})))]);
new(pbpointprotectlist) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbpointprotectlist), tl(tuple_to_list(#pbpointprotectlist{})))]);
new(pbpointsend) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbpointsend), tl(tuple_to_list(#pbpointsend{})))]);
new(pbpointsendmsg) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbpointsendmsg), tl(tuple_to_list(#pbpointsendmsg{})))]);
new(pbpointsendmsglist) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbpointsendmsglist), tl(tuple_to_list(#pbpointsendmsglist{})))]);
new(pbprivate) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbprivate), tl(tuple_to_list(#pbprivate{})))]);
new(pbprotectinfo) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbprotectinfo), tl(tuple_to_list(#pbprotectinfo{})))]);
new(pbprotectplayerinfo) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbprotectplayerinfo), tl(tuple_to_list(#pbprotectplayerinfo{})))]);
new(pbpvprobotattr) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbpvprobotattr), tl(tuple_to_list(#pbpvprobotattr{})))]);
new(pbrank) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbrank), tl(tuple_to_list(#pbrank{})))]);
new(pbrankinfo) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbrankinfo), tl(tuple_to_list(#pbrankinfo{})))]);
new(pbranklist) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbranklist), tl(tuple_to_list(#pbranklist{})))]);
new(pbrc4) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbrc4), tl(tuple_to_list(#pbrc4{})))]);
new(pbrequestgiftsmsg) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbrequestgiftsmsg), tl(tuple_to_list(#pbrequestgiftsmsg{})))]);
new(pbrequestgiftsmsglist) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbrequestgiftsmsglist), tl(tuple_to_list(#pbrequestgiftsmsglist{})))]);
new(pbrequestplayergiftsmsg) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbrequestplayergiftsmsg), tl(tuple_to_list(#pbrequestplayergiftsmsg{})))]);
new(pbrequestplayergiftsmsglist) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbrequestplayergiftsmsglist), tl(tuple_to_list(#pbrequestplayergiftsmsglist{})))]);
new(pbresult) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbresult), tl(tuple_to_list(#pbresult{})))]);
new(pbreward) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbreward), tl(tuple_to_list(#pbreward{})))]);
new(pbrewarditem) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbrewarditem), tl(tuple_to_list(#pbrewarditem{})))]);
new(pbrewardlist) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbrewardlist), tl(tuple_to_list(#pbrewardlist{})))]);
new(pbsellinglist) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbsellinglist), tl(tuple_to_list(#pbsellinglist{})))]);
new(pbsellingshop) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbsellingshop), tl(tuple_to_list(#pbsellingshop{})))]);
new(pbsendgiftsmsg) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbsendgiftsmsg), tl(tuple_to_list(#pbsendgiftsmsg{})))]);
new(pbserverstatus) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbserverstatus), tl(tuple_to_list(#pbserverstatus{})))]);
new(pbshopbuy) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbshopbuy), tl(tuple_to_list(#pbshopbuy{})))]);
new(pbshopitem) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbshopitem), tl(tuple_to_list(#pbshopitem{})))]);
new(pbshopmsg) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbshopmsg), tl(tuple_to_list(#pbshopmsg{})))]);
new(pbsigil) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbsigil), tl(tuple_to_list(#pbsigil{})))]);
new(pbskill) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbskill), tl(tuple_to_list(#pbskill{})))]);
new(pbskillid) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbskillid), tl(tuple_to_list(#pbskillid{})))]);
new(pbskillidlist) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbskillidlist), tl(tuple_to_list(#pbskillidlist{})))]);
new(pbskilllist) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbskilllist), tl(tuple_to_list(#pbskilllist{})))]);
new(pbsmriti) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbsmriti), tl(tuple_to_list(#pbsmriti{})))]);
new(pbsourcedungeon) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbsourcedungeon), tl(tuple_to_list(#pbsourcedungeon{})))]);
new(pbsourcedungeoninfo) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbsourcedungeoninfo), tl(tuple_to_list(#pbsourcedungeoninfo{})))]);
new(pbstartcombat) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbstartcombat), tl(tuple_to_list(#pbstartcombat{})))]);
new(pbsteriousshop) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbsteriousshop), tl(tuple_to_list(#pbsteriousshop{})))]);
new(pbstoreproduct) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbstoreproduct), tl(tuple_to_list(#pbstoreproduct{})))]);
new(pbstoreproductlist) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbstoreproductlist), tl(tuple_to_list(#pbstoreproductlist{})))]);
new(pbsubdungeon) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbsubdungeon), tl(tuple_to_list(#pbsubdungeon{})))]);
new(pbtask) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbtask), tl(tuple_to_list(#pbtask{})))]);
new(pbtasklist) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbtasklist), tl(tuple_to_list(#pbtasklist{})))]);
new(pbteam) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbteam), tl(tuple_to_list(#pbteam{})))]);
new(pbteamchat) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbteamchat), tl(tuple_to_list(#pbteamchat{})))]);
new(pbtwistegg) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbtwistegg), tl(tuple_to_list(#pbtwistegg{})))]);
new(pbtwistegglist) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbtwistegglist), tl(tuple_to_list(#pbtwistegglist{})))]);
new(pbupgradeskillcard) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbupgradeskillcard), tl(tuple_to_list(#pbupgradeskillcard{})))]);
new(pbuser) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbuser), tl(tuple_to_list(#pbuser{})))]);
new(pbuserlist) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbuserlist), tl(tuple_to_list(#pbuserlist{})))]);
new(pbuserloginfashioninfo) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbuserloginfashioninfo), tl(tuple_to_list(#pbuserloginfashioninfo{})))]);
new(pbuserlogininfo) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbuserlogininfo), tl(tuple_to_list(#pbuserlogininfo{})))]);
new(pbusernotifyupdate) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbusernotifyupdate), tl(tuple_to_list(#pbusernotifyupdate{})))]);
new(pbuserresult) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbuserresult), tl(tuple_to_list(#pbuserresult{})))]);
new(pbvipreward) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbvipreward), tl(tuple_to_list(#pbvipreward{})))]);
new(pbwavecreature) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbwavecreature), tl(tuple_to_list(#pbwavecreature{})))]);
new(pbwavemonster) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbwavemonster), tl(tuple_to_list(#pbwavemonster{})))]);
new(pbwinrate) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbwinrate), tl(tuple_to_list(#pbwinrate{})))]);
new(pbworldboss) ->
     io:format("~w~n", [lists:zip(record_info(fields, pbworldboss), tl(tuple_to_list(#pbworldboss{})))]);
new(player) ->
     io:format("~w~n", [lists:zip(record_info(fields, player), tl(tuple_to_list(#player{})))]);
new(player_buff) ->
     io:format("~w~n", [lists:zip(record_info(fields, player_buff), tl(tuple_to_list(#player_buff{})))]);
new(player_camp) ->
     io:format("~w~n", [lists:zip(record_info(fields, player_camp), tl(tuple_to_list(#player_camp{})))]);
new(player_cost_state) ->
     io:format("~w~n", [lists:zip(record_info(fields, player_cost_state), tl(tuple_to_list(#player_cost_state{})))]);
new(player_count) ->
     io:format("~w~n", [lists:zip(record_info(fields, player_count), tl(tuple_to_list(#player_count{})))]);
new(player_dungeon_match) ->
     io:format("~w~n", [lists:zip(record_info(fields, player_dungeon_match), tl(tuple_to_list(#player_dungeon_match{})))]);
new(player_goods) ->
     io:format("~w~n", [lists:zip(record_info(fields, player_goods), tl(tuple_to_list(#player_goods{})))]);
new(player_info) ->
     io:format("~w~n", [lists:zip(record_info(fields, player_info), tl(tuple_to_list(#player_info{})))]);
new(player_month_sign) ->
     io:format("~w~n", [lists:zip(record_info(fields, player_month_sign), tl(tuple_to_list(#player_month_sign{})))]);
new(player_other) ->
     io:format("~w~n", [lists:zip(record_info(fields, player_other), tl(tuple_to_list(#player_other{})))]);
new(player_pid) ->
     io:format("~w~n", [lists:zip(record_info(fields, player_pid), tl(tuple_to_list(#player_pid{})))]);
new(player_response) ->
     io:format("~w~n", [lists:zip(record_info(fields, player_response), tl(tuple_to_list(#player_response{})))]);
new(player_skill) ->
     io:format("~w~n", [lists:zip(record_info(fields, player_skill), tl(tuple_to_list(#player_skill{})))]);
new(player_skill_record) ->
     io:format("~w~n", [lists:zip(record_info(fields, player_skill_record), tl(tuple_to_list(#player_skill_record{})))]);
new(private_msg) ->
     io:format("~w~n", [lists:zip(record_info(fields, private_msg), tl(tuple_to_list(#private_msg{})))]);
new(radar_msg) ->
     io:format("~w~n", [lists:zip(record_info(fields, radar_msg), tl(tuple_to_list(#radar_msg{})))]);
new(rank) ->
     io:format("~w~n", [lists:zip(record_info(fields, rank), tl(tuple_to_list(#rank{})))]);
new(rank_reset_info) ->
     io:format("~w~n", [lists:zip(record_info(fields, rank_reset_info), tl(tuple_to_list(#rank_reset_info{})))]);
new(record_mysql_info) ->
     io:format("~w~n", [lists:zip(record_info(fields, record_mysql_info), tl(tuple_to_list(#record_mysql_info{})))]);
new(relationship) ->
     io:format("~w~n", [lists:zip(record_info(fields, relationship), tl(tuple_to_list(#relationship{})))]);
new(request_gifts_msg) ->
     io:format("~w~n", [lists:zip(record_info(fields, request_gifts_msg), tl(tuple_to_list(#request_gifts_msg{})))]);
new(response) ->
     io:format("~w~n", [lists:zip(record_info(fields, response), tl(tuple_to_list(#response{})))]);
new(reward_item) ->
     io:format("~w~n", [lists:zip(record_info(fields, reward_item), tl(tuple_to_list(#reward_item{})))]);
new(scheme) ->
     io:format("~w~n", [lists:zip(record_info(fields, scheme), tl(tuple_to_list(#scheme{})))]);
new(server_config) ->
     io:format("~w~n", [lists:zip(record_info(fields, server_config), tl(tuple_to_list(#server_config{})))]);
new(service) ->
     io:format("~w~n", [lists:zip(record_info(fields, service), tl(tuple_to_list(#service{})))]);
new(service_proc) ->
     io:format("~w~n", [lists:zip(record_info(fields, service_proc), tl(tuple_to_list(#service_proc{})))]);
new(service_proc_param) ->
     io:format("~w~n", [lists:zip(record_info(fields, service_proc_param), tl(tuple_to_list(#service_proc_param{})))]);
new(skyrush) ->
     io:format("~w~n", [lists:zip(record_info(fields, skyrush), tl(tuple_to_list(#skyrush{})))]);
new(source_dungeon) ->
     io:format("~w~n", [lists:zip(record_info(fields, source_dungeon), tl(tuple_to_list(#source_dungeon{})))]);
new(state) ->
     io:format("~w~n", [lists:zip(record_info(fields, state), tl(tuple_to_list(#state{})))]);
new(sterious_shop) ->
     io:format("~w~n", [lists:zip(record_info(fields, sterious_shop), tl(tuple_to_list(#sterious_shop{})))]);
new(super_battle) ->
     io:format("~w~n", [lists:zip(record_info(fields, super_battle), tl(tuple_to_list(#super_battle{})))]);
new(sync_arena_rank) ->
     io:format("~w~n", [lists:zip(record_info(fields, sync_arena_rank), tl(tuple_to_list(#sync_arena_rank{})))]);
new(sync_arena_report) ->
     io:format("~w~n", [lists:zip(record_info(fields, sync_arena_report), tl(tuple_to_list(#sync_arena_report{})))]);
new(sys_acm_checker) ->
     io:format("~w~n", [lists:zip(record_info(fields, sys_acm_checker), tl(tuple_to_list(#sys_acm_checker{})))]);
new(task) ->
     io:format("~w~n", [lists:zip(record_info(fields, task), tl(tuple_to_list(#task{})))]);
new(team) ->
     io:format("~w~n", [lists:zip(record_info(fields, team), tl(tuple_to_list(#team{})))]);
new(trial_data) ->
     io:format("~w~n", [lists:zip(record_info(fields, trial_data), tl(tuple_to_list(#trial_data{})))]);
new(udp_server_option) ->
     io:format("~w~n", [lists:zip(record_info(fields, udp_server_option), tl(tuple_to_list(#udp_server_option{})))]);
new(url_mini) ->
     io:format("~w~n", [lists:zip(record_info(fields, url_mini), tl(tuple_to_list(#url_mini{})))]);
new(vice_shop) ->
     io:format("~w~n", [lists:zip(record_info(fields, vice_shop), tl(tuple_to_list(#vice_shop{})))]);
new(vip_reward) ->
     io:format("~w~n", [lists:zip(record_info(fields, vip_reward), tl(tuple_to_list(#vip_reward{})))]);
new(_) ->
 undefined.

pr(Record) when is_tuple(Record) ->
    RecordName = element(1, Record),
    case get_fields(RecordName) of
        [] ->
            Record;
        RecordFields ->
            RecordValues = 
                lists:map(fun(Val) ->
                                  pr(Val)
                          end, tl(tuple_to_list(Record))),
            RecList = lists:zip(RecordFields, RecordValues),
            {RecordName,[{Key, Value} || {Key, Value} <- RecList, Value =/= [], Value =/= undefined]}
    end;
pr(RecList) when is_list(RecList) ->
    lists:map(fun(Rec) ->
                      pr(Rec)
              end, RecList);
pr(Other) ->
    Other. 

