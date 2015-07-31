-ifndef(PBACCOUNT_PB_H).
-define(PBACCOUNT_PB_H, true).
-record(pbaccount, {
    acc_id,
    acc_name,
    timestamp,
    server_id,
    login_ticket,
    suid,
    platform,
    device_id
}).
-endif.

-ifndef(PBACCOUNTLOGIN_PB_H).
-define(PBACCOUNTLOGIN_PB_H, true).
-record(pbaccountlogin, {
    result,
    total_online,
    user_info = [],
    acc_id,
    session
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

-ifndef(PBCREATEAROLE_PB_H).
-define(PBCREATEAROLE_PB_H, true).
-record(pbcreatearole, {
    server_id,
    acc_id
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

-ifndef(PBRC4_PB_H).
-define(PBRC4_PB_H, true).
-record(pbrc4, {
    p,
    g,
    pub
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

-ifndef(PBSERVERSTATUS_PB_H).
-define(PBSERVERSTATUS_PB_H, true).
-record(pbserverstatus, {
    index,
    ip,
    port,
    state,
    num
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

-ifndef(PBUSERLOGINFASHIONINFO_PB_H).
-define(PBUSERLOGINFASHIONINFO_PB_H, true).
-record(pbuserloginfashioninfo, {
    fashion_base_id,
    sub_type
}).
-endif.

-ifndef(PBUSERLOGININFO_PB_H).
-define(PBUSERLOGININFO_PB_H, true).
-record(pbuserlogininfo, {
    user_id,
    nickname,
    level,
    camp,
    career,
    sex,
    server_id,
    status,
    acc_id,
    acc_name,
    list = []
}).
-endif.

-ifndef(PBUSERRESULT_PB_H).
-define(PBUSERRESULT_PB_H, true).
-record(pbuserresult, {
    result,
    user_id
}).
-endif.

