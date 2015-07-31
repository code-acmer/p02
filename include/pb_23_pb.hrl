-ifndef(PBARENABATTLEREPORT_PB_H).
-define(PBARENABATTLEREPORT_PB_H, true).
-record(pbarenabattlereport, {
    id,
    type,
    result,
    timestamp,
    player_id,
    nickname,
    deffender_id,
    deffender_name,
    rank_change_type,
    attack_rank,
    deffender_rank
}).
-endif.

-ifndef(PBARENABATTLEREPORTLIST_PB_H).
-define(PBARENABATTLEREPORTLIST_PB_H, true).
-record(pbarenabattlereportlist, {
    report_list = []
}).
-endif.

-ifndef(PBARENACHALLENGE_PB_H).
-define(PBARENACHALLENGE_PB_H, true).
-record(pbarenachallenge, {
    id,
    result,
    robot
}).
-endif.

-ifndef(PBARENAINFO_PB_H).
-define(PBARENAINFO_PB_H, true).
-record(pbarenainfo, {
    challenge_times,
    rest_challenge_times,
    challenge_timestamp,
    rank,
    win_times,
    fail_times,
    robot,
    player_id,
    level,
    nickname,
    career,
    battle_ability,
    enemy = [],
    sn,
    buy_times,
    score,
    robot_id
}).
-endif.

-ifndef(PBARENAINFOLIST_PB_H).
-define(PBARENAINFOLIST_PB_H, true).
-record(pbarenainfolist, {
    arena_player_list = []
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

-ifndef(PBCROSSFIGHTER_PB_H).
-define(PBCROSSFIGHTER_PB_H, true).
-record(pbcrossfighter, {
    times,
    buy_times,
    islands = [],
    records = []
}).
-endif.

-ifndef(PBCROSSHISTORY_PB_H).
-define(PBCROSSHISTORY_PB_H, true).
-record(pbcrosshistory, {
    rank,
    round,
    timestamp
}).
-endif.

-ifndef(PBCROSSHISTORYLIST_PB_H).
-define(PBCROSSHISTORYLIST_PB_H, true).
-record(pbcrosshistorylist, {
    list = []
}).
-endif.

-ifndef(PBCROSSISLAND_PB_H).
-define(PBCROSSISLAND_PB_H, true).
-record(pbcrossisland, {
    id,
    occupy_id,
    occupy_name,
    occupy_career,
    occupy_lv,
    occupy_sn,
    occupy_ability,
    occupy_robot,
    occupy_time,
    calc_timestamp,
    is_enemy
}).
-endif.

-ifndef(PBCROSSRECORD_PB_H).
-define(PBCROSSRECORD_PB_H, true).
-record(pbcrossrecord, {
    timestamp,
    atk_id,
    atk_name,
    def_id,
    def_name,
    result
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

