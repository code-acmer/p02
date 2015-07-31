-ifndef(PBADDLEAGUEMSG_PB_H).
-define(PBADDLEAGUEMSG_PB_H, true).
-record(pbaddleaguemsg, {
    league_id,
    type
}).
-endif.

-ifndef(PBALLMASTERINFO_PB_H).
-define(PBALLMASTERINFO_PB_H, true).
-record(pballmasterinfo, {
    list = []
}).
-endif.

-ifndef(PBAPPOINTPLAYER_PB_H).
-define(PBAPPOINTPLAYER_PB_H, true).
-record(pbappointplayer, {
    point_id,
    player_id
}).
-endif.

-ifndef(PBAPPRENTICEBUYCARD_PB_H).
-define(PBAPPRENTICEBUYCARD_PB_H, true).
-record(pbapprenticebuycard, {
    id,
    type
}).
-endif.

-ifndef(PBAPPRENTICECARD_PB_H).
-define(PBAPPRENTICECARD_PB_H, true).
-record(pbapprenticecard, {
    id,
    master_player_id,
    master_player_name,
    apprentice_goods_id,
    card_status,
    work_day
}).
-endif.

-ifndef(PBAPPRENTICEREQUESTINFO_PB_H).
-define(PBAPPRENTICEREQUESTINFO_PB_H, true).
-record(pbapprenticerequestinfo, {
    id,
    name
}).
-endif.

-ifndef(PBATTRIBUTE_PB_H).
-define(PBATTRIBUTE_PB_H, true).
-record(pbattribute, {
    hp_lim,
    hp_cur,
    mana_lim,
    mana_cur,
    hp_rec,
    mana_rec,
    attack,
    def,
    hit,
    dodge,
    crit,
    anti_crit,
    stiff,
    anti_stiff,
    attack_speed,
    move_speed,
    attack_effect,
    def_effect
}).
-endif.

-ifndef(PBBOSSINVITEMSG_PB_H).
-define(PBBOSSINVITEMSG_PB_H, true).
-record(pbbossinvitemsg, {
    boss_name,
    league_name,
    league_id
}).
-endif.

-ifndef(PBBOSSSENDGOLD_PB_H).
-define(PBBOSSSENDGOLD_PB_H, true).
-record(pbbosssendgold, {
    gold_num
}).
-endif.

-ifndef(PBCARDREQUEST_PB_H).
-define(PBCARDREQUEST_PB_H, true).
-record(pbcardrequest, {
    id,
    list = []
}).
-endif.

-ifndef(PBCARDREQUESTLIST_PB_H).
-define(PBCARDREQUESTLIST_PB_H, true).
-record(pbcardrequestlist, {
    list = []
}).
-endif.

-ifndef(PBCARDINFO_PB_H).
-define(PBCARDINFO_PB_H, true).
-record(pbcardinfo, {
    id,
    base_id,
    card_status
}).
-endif.

-ifndef(PBCHALLENGERECORD_PB_H).
-define(PBCHALLENGERECORD_PB_H, true).
-record(pbchallengerecord, {
    timestamp,
    name,
    enemy_name,
    result,
    league_thing
}).
-endif.

-ifndef(PBCHALLENGERECORDLIST_PB_H).
-define(PBCHALLENGERECORDLIST_PB_H, true).
-record(pbchallengerecordlist, {
    list = []
}).
-endif.

-ifndef(PBCOMBATREWARD_PB_H).
-define(PBCOMBATREWARD_PB_H, true).
-record(pbcombatreward, {
    exp,
    mon_drop_list = [],
    dungeon_reward_list = [],
    unique_id,
    seal,
    evaluate,
    point,
    partners = []
}).
-endif.

-ifndef(PBCOUNTRECORD_PB_H).
-define(PBCOUNTRECORD_PB_H, true).
-record(pbcountrecord, {
    player_id,
    player_name,
    win_times,
    loss_times,
    points,
    things
}).
-endif.

-ifndef(PBCOUNTRECORDS_PB_H).
-define(PBCOUNTRECORDS_PB_H, true).
-record(pbcountrecords, {
    records = []
}).
-endif.

-ifndef(PBFIGHTRECORDS_PB_H).
-define(PBFIGHTRECORDS_PB_H, true).
-record(pbfightrecords, {
    def_records = [],
    atk_records = []
}).
-endif.

-ifndef(PBFRIEND_PB_H).
-define(PBFRIEND_PB_H, true).
-record(pbfriend, {
    id,
    nickname,
    level,
    career,
    core = [],
    off_time,
    fashion = [],
    mugen_pass_times,
    mugen_score,
    skill_list = [],
    talent = [],
    battle_ability,
    rela,
    league_name,
    league_title,
    put_on_skill = [],
    attri,
    type
}).
-endif.

-ifndef(PBG17GUILD_PB_H).
-define(PBG17GUILD_PB_H, true).
-record(pbg17guild, {
    guild_id,
    guild_name,
    status,
    owner_user_id
}).
-endif.

-ifndef(PBG17GUILDLIST_PB_H).
-define(PBG17GUILDLIST_PB_H, true).
-record(pbg17guildlist, {
    guilds = []
}).
-endif.

-ifndef(PBG17GUILDMEMBER_PB_H).
-define(PBG17GUILDMEMBER_PB_H, true).
-record(pbg17guildmember, {
    guild_id,
    guild_name,
    title,
    number
}).
-endif.

-ifndef(PBG17GUILDQUERY_PB_H).
-define(PBG17GUILDQUERY_PB_H, true).
-record(pbg17guildquery, {
    name,
    guild_id
}).
-endif.

-ifndef(PBGETLEAGUE_PB_H).
-define(PBGETLEAGUE_PB_H, true).
-record(pbgetleague, {
    last_key,
    type
}).
-endif.

-ifndef(PBGETLEAGUEGROUPRANKINFO_PB_H).
-define(PBGETLEAGUEGROUPRANKINFO_PB_H, true).
-record(pbgetleaguegrouprankinfo, {
    last_key,
    type,
    league_group
}).
-endif.

-ifndef(PBGETLEAGUESTATU_PB_H).
-define(PBGETLEAGUESTATU_PB_H, true).
-record(pbgetleaguestatu, {
    type,
    timestamp
}).
-endif.

-ifndef(PBGETPOINTRECORD_PB_H).
-define(PBGETPOINTRECORD_PB_H, true).
-record(pbgetpointrecord, {
    league_id,
    point_id
}).
-endif.

-ifndef(PBGIFTSID_PB_H).
-define(PBGIFTSID_PB_H, true).
-record(pbgiftsid, {
    gifts_id
}).
-endif.

-ifndef(PBGIFTSRECORD_PB_H).
-define(PBGIFTSRECORD_PB_H, true).
-record(pbgiftsrecord, {
    timestamp,
    send_name,
    recv_name,
    type,
    value
}).
-endif.

-ifndef(PBGIFTSRECORDLIST_PB_H).
-define(PBGIFTSRECORDLIST_PB_H, true).
-record(pbgiftsrecordlist, {
    record_list = []
}).
-endif.

-ifndef(PBGOODS_PB_H).
-define(PBGOODS_PB_H, true).
-record(pbgoods, {
    id,
    goods_id,
    type,
    sub_type,
    player_id,
    container,
    position,
    str_lv,
    star_lv,
    hp_lim,
    bind,
    attack,
    def,
    hit,
    dodge,
    crit,
    anti_crit,
    stiff,
    cost,
    anti_stiff,
    attack_speed,
    move_speed,
    ice,
    fire,
    honly,
    dark,
    anti_ice,
    anti_fire,
    anti_honly,
    anti_dark,
    power,
    quality,
    jewels = [],
    sum,
    hp_lim_ext,
    attack_ext,
    hit_ext,
    dodge_ext,
    def_ext,
    crit_ext,
    anti_crit_ext,
    mana_lim,
    mana_rec,
    mana_lim_ext,
    mana_rec_ext,
    skill_card_exp,
    card_pos_1,
    card_pos_2,
    card_pos_3,
    value = [],
    timestamp,
    skill_card_status
}).
-endif.

-ifndef(PBGOODSINFO_PB_H).
-define(PBGOODSINFO_PB_H, true).
-record(pbgoodsinfo, {
    id,
    num
}).
-endif.

-ifndef(PBID32_PB_H).
-define(PBID32_PB_H, true).
-record(pbid32, {
    id
}).
-endif.

-ifndef(PBID32R_PB_H).
-define(PBID32R_PB_H, true).
-record(pbid32r, {
    id = []
}).
-endif.

-ifndef(PBID64_PB_H).
-define(PBID64_PB_H, true).
-record(pbid64, {
    id
}).
-endif.

-ifndef(PBID64R_PB_H).
-define(PBID64R_PB_H, true).
-record(pbid64r, {
    ids = []
}).
-endif.

-ifndef(PBIDSTRING_PB_H).
-define(PBIDSTRING_PB_H, true).
-record(pbidstring, {
    id
}).
-endif.

-ifndef(PBLEAGIFTS_PB_H).
-define(PBLEAGIFTS_PB_H, true).
-record(pbleagifts, {
    gifts_id,
    timestamp,
    name,
    all_num,
    remain_num,
    value,
    has_recv
}).
-endif.

-ifndef(PBLEAGUE_PB_H).
-define(PBLEAGUE_PB_H, true).
-record(pbleague, {
    id,
    name,
    cur_num,
    max_num,
    lv,
    ability_sum,
    join_ability,
    declaration,
    president,
    rank,
    league_gifts_num,
    apply_league_fight,
    league_exp,
    g17_guild_id,
    g17_guild_name
}).
-endif.

-ifndef(PBLEAGUECHALLENGEINFO_PB_H).
-define(PBLEAGUECHALLENGEINFO_PB_H, true).
-record(pbleaguechallengeinfo, {
    player_id,
    name,
    lv,
    title,
    ability_sum,
    thing,
    grab_num,
    career,
    mult
}).
-endif.

-ifndef(PBLEAGUECHALLENGELIST_PB_H).
-define(PBLEAGUECHALLENGELIST_PB_H, true).
-record(pbleaguechallengelist, {
    list = []
}).
-endif.

-ifndef(PBLEAGUECHALLENGERESULT_PB_H).
-define(PBLEAGUECHALLENGERESULT_PB_H, true).
-record(pbleaguechallengeresult, {
    enemy_player_id,
    result,
    energy
}).
-endif.

-ifndef(PBLEAGUEFIGHTPOINT_PB_H).
-define(PBLEAGUEFIGHTPOINT_PB_H, true).
-record(pbleaguefightpoint, {
    league_id,
    point_id,
    pos,
    status,
    protect_info = [],
    occurpy_info = []
}).
-endif.

-ifndef(PBLEAGUEFIGHTPOINTLIST_PB_H).
-define(PBLEAGUEFIGHTPOINTLIST_PB_H, true).
-record(pbleaguefightpointlist, {
    list = []
}).
-endif.

-ifndef(PBLEAGUEFIGHTRANKINFO_PB_H).
-define(PBLEAGUEFIGHTRANKINFO_PB_H, true).
-record(pbleaguefightrankinfo, {
    score,
    rank
}).
-endif.

-ifndef(PBLEAGUEGIFTS_PB_H).
-define(PBLEAGUEGIFTS_PB_H, true).
-record(pbleaguegifts, {
    league_gifts_list = []
}).
-endif.

-ifndef(PBLEAGUEHOUSE_PB_H).
-define(PBLEAGUEHOUSE_PB_H, true).
-record(pbleaguehouse, {
    record_list = [],
    gold
}).
-endif.

-ifndef(PBLEAGUEHOUSERECORD_PB_H).
-define(PBLEAGUEHOUSERECORD_PB_H, true).
-record(pbleaguehouserecord, {
    timestamp,
    name,
    value
}).
-endif.

-ifndef(PBLEAGUEINFO_PB_H).
-define(PBLEAGUEINFO_PB_H, true).
-record(pbleagueinfo, {
    name,
    league_id,
    league_sn,
    ability,
    group_num,
    thing,
    occ_point_num,
    remain_fight_num
}).
-endif.

-ifndef(PBLEAGUEINFOLIST_PB_H).
-define(PBLEAGUEINFOLIST_PB_H, true).
-record(pbleagueinfolist, {
    list = []
}).
-endif.

-ifndef(PBLEAGUELIST_PB_H).
-define(PBLEAGUELIST_PB_H, true).
-record(pbleaguelist, {
    league_list = [],
    size
}).
-endif.

-ifndef(PBLEAGUEMEMBER_PB_H).
-define(PBLEAGUEMEMBER_PB_H, true).
-record(pbleaguemember, {
    player_id,
    title,
    contribute,
    name,
    lv,
    ability,
    g17_join_timestamp
}).
-endif.

-ifndef(PBLEAGUEMEMBERLIST_PB_H).
-define(PBLEAGUEMEMBERLIST_PB_H, true).
-record(pbleaguememberlist, {
    member_list = []
}).
-endif.

-ifndef(PBLEAGUEPOINTCHALLENGERESULT_PB_H).
-define(PBLEAGUEPOINTCHALLENGERESULT_PB_H, true).
-record(pbleaguepointchallengeresult, {
    point_id,
    result,
    energy
}).
-endif.

-ifndef(PBLEAGUERANKINFO_PB_H).
-define(PBLEAGUERANKINFO_PB_H, true).
-record(pbleaguerankinfo, {
    league_id,
    rank,
    name,
    lv,
    cur_num,
    max_num,
    ability_sum,
    score
}).
-endif.

-ifndef(PBLEAGUERANKLIST_PB_H).
-define(PBLEAGUERANKLIST_PB_H, true).
-record(pbleagueranklist, {
    list = [],
    size
}).
-endif.

-ifndef(PBMASTERAGREEMSG_PB_H).
-define(PBMASTERAGREEMSG_PB_H, true).
-record(pbmasteragreemsg, {
    id,
    player_id
}).
-endif.

-ifndef(PBMASTERCARD_PB_H).
-define(PBMASTERCARD_PB_H, true).
-record(pbmastercard, {
    id,
    master_goods_id,
    apprentice_player_id,
    apprentice_player_name,
    card_status,
    work_day
}).
-endif.

-ifndef(PBMASTERINFO_PB_H).
-define(PBMASTERINFO_PB_H, true).
-record(pbmasterinfo, {
    id,
    name,
    lv,
    ability,
    contribute,
    title,
    contribute_lv,
    card_list = []
}).
-endif.

-ifndef(PBMEMBERGETLISTTYPE_PB_H).
-define(PBMEMBERGETLISTTYPE_PB_H, true).
-record(pbmembergetlisttype, {
    type
}).
-endif.

-ifndef(PBMEMBERSENDLIST_PB_H).
-define(PBMEMBERSENDLIST_PB_H, true).
-record(pbmembersendlist, {
    list = []
}).
-endif.

-ifndef(PBMEMBERSENDMSG_PB_H).
-define(PBMEMBERSENDMSG_PB_H, true).
-record(pbmembersendmsg, {
    name,
    value
}).
-endif.

-ifndef(PBONEKEYSENDMSG_PB_H).
-define(PBONEKEYSENDMSG_PB_H, true).
-record(pbonekeysendmsg, {
    send_success_list = []
}).
-endif.

-ifndef(PBOWNCARDSINFO_PB_H).
-define(PBOWNCARDSINFO_PB_H, true).
-record(pbowncardsinfo, {
    master_card_list = [],
    apprentice_card_list = [],
    remain_master_num
}).
-endif.

-ifndef(PBOWNGIFTS_PB_H).
-define(PBOWNGIFTS_PB_H, true).
-record(pbowngifts, {
    own_gifts_list = []
}).
-endif.

-ifndef(PBPLAYERGIFTS_PB_H).
-define(PBPLAYERGIFTS_PB_H, true).
-record(pbplayergifts, {
    gifts_id,
    timestamp,
    all_num,
    remain_num,
    recharge_gold_num,
    sum_value,
    last_send,
    day_remain_num
}).
-endif.

-ifndef(PBPOINTCHALLENGERECORD_PB_H).
-define(PBPOINTCHALLENGERECORD_PB_H, true).
-record(pbpointchallengerecord, {
    timestamp,
    name,
    result,
    thing_reward
}).
-endif.

-ifndef(PBPOINTCHALLENGERECORDINFO_PB_H).
-define(PBPOINTCHALLENGERECORDINFO_PB_H, true).
-record(pbpointchallengerecordinfo, {
    list = []
}).
-endif.

-ifndef(PBPOINTPROTECTLIST_PB_H).
-define(PBPOINTPROTECTLIST_PB_H, true).
-record(pbpointprotectlist, {
    list = []
}).
-endif.

-ifndef(PBPOINTSEND_PB_H).
-define(PBPOINTSEND_PB_H, true).
-record(pbpointsend, {
    gifts_id,
    player_id
}).
-endif.

-ifndef(PBPOINTSENDMSG_PB_H).
-define(PBPOINTSENDMSG_PB_H, true).
-record(pbpointsendmsg, {
    name,
    lv,
    league_lv,
    player_id
}).
-endif.

-ifndef(PBPOINTSENDMSGLIST_PB_H).
-define(PBPOINTSENDMSGLIST_PB_H, true).
-record(pbpointsendmsglist, {
    list = []
}).
-endif.

-ifndef(PBPROTECTINFO_PB_H).
-define(PBPROTECTINFO_PB_H, true).
-record(pbprotectinfo, {
    name,
    id
}).
-endif.

-ifndef(PBPROTECTPLAYERINFO_PB_H).
-define(PBPROTECTPLAYERINFO_PB_H, true).
-record(pbprotectplayerinfo, {
    player_id,
    name,
    lv,
    ability,
    contribute,
    title,
    contribute_lv,
    career
}).
-endif.

-ifndef(PBREQUESTGIFTSMSG_PB_H).
-define(PBREQUESTGIFTSMSG_PB_H, true).
-record(pbrequestgiftsmsg, {
    name,
    lv,
    league_lv,
    gifts_num,
    player_id,
    is_request
}).
-endif.

-ifndef(PBREQUESTGIFTSMSGLIST_PB_H).
-define(PBREQUESTGIFTSMSGLIST_PB_H, true).
-record(pbrequestgiftsmsglist, {
    list = []
}).
-endif.

-ifndef(PBREQUESTPLAYERGIFTSMSG_PB_H).
-define(PBREQUESTPLAYERGIFTSMSG_PB_H, true).
-record(pbrequestplayergiftsmsg, {
    name,
    player_id
}).
-endif.

-ifndef(PBREQUESTPLAYERGIFTSMSGLIST_PB_H).
-define(PBREQUESTPLAYERGIFTSMSGLIST_PB_H, true).
-record(pbrequestplayergiftsmsglist, {
    list = []
}).
-endif.

-ifndef(PBRESULT_PB_H).
-define(PBRESULT_PB_H, true).
-record(pbresult, {
    result
}).
-endif.

-ifndef(PBREWARDITEM_PB_H).
-define(PBREWARDITEM_PB_H, true).
-record(pbrewarditem, {
    id,
    num,
    goods_id
}).
-endif.

-ifndef(PBSENDGIFTSMSG_PB_H).
-define(PBSENDGIFTSMSG_PB_H, true).
-record(pbsendgiftsmsg, {
    gifts_id,
    gifts_num
}).
-endif.

-ifndef(PBSKILL_PB_H).
-define(PBSKILL_PB_H, true).
-record(pbskill, {
    id,
    skill_id,
    player_id,
    lv,
    str_lv,
    sigil = [],
    type
}).
-endif.

