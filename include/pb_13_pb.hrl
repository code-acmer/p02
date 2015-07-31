-ifndef(PBARENAUSER_PB_H).
-define(PBARENAUSER_PB_H, true).
-record(pbarenauser, {
    id,
    nickname,
    level,
    career,
    core = [],
    put_on_skill = [],
    skill_list = [],
    battle_ability
}).
-endif.

-ifndef(PBARENAUSERLIST_PB_H).
-define(PBARENAUSERLIST_PB_H, true).
-record(pbarenauserlist, {
    list = []
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

-ifndef(PBCOMBATRESPON_PB_H).
-define(PBCOMBATRESPON_PB_H, true).
-record(pbcombatrespon, {
    robot_attri,
    player_attri
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

-ifndef(PBDUNGEONREWARD_PB_H).
-define(PBDUNGEONREWARD_PB_H, true).
-record(pbdungeonreward, {
    goods_id,
    number
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

-ifndef(PBID64LIST_PB_H).
-define(PBID64LIST_PB_H, true).
-record(pbid64list, {
    ids = []
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

-ifndef(PBMEMBER_PB_H).
-define(PBMEMBER_PB_H, true).
-record(pbmember, {
    player_id,
    nickname,
    lv,
    career,
    state,
    battle_ability
}).
-endif.

-ifndef(PBNOTICE_PB_H).
-define(PBNOTICE_PB_H, true).
-record(pbnotice, {
    notice_id,
    sort_id,
    type,
    notice_name,
    headline,
    des,
    show_time,
    activity_time,
    function_id
}).
-endif.

-ifndef(PBNOTICELIST_PB_H).
-define(PBNOTICELIST_PB_H, true).
-record(pbnoticelist, {
    notice = []
}).
-endif.

-ifndef(PBOPENBOSS_PB_H).
-define(PBOPENBOSS_PB_H, true).
-record(pbopenboss, {
    boss_id,
    today_open_times,
    open_timestamp = []
}).
-endif.

-ifndef(PBPVPROBOTATTR_PB_H).
-define(PBPVPROBOTATTR_PB_H, true).
-record(pbpvprobotattr, {
    id,
    robot_id,
    name,
    career,
    lv,
    battle_ability,
    skill_1,
    skill_1_lv,
    skill_2,
    skill_2_lv,
    skill_3,
    skill_3_lv,
    skill_4,
    skill_4_lv,
    equ_weapon,
    equ_clothes,
    equ_shoes,
    equ_neck,
    equ_ring,
    equ_pants,
    weapon_strengthen,
    weapon_star,
    clothes_strengthen,
    clothes_star,
    shoes_strengthen,
    shoes_star,
    neck_strengthen,
    neck_star,
    ring_strengthen,
    ring_star,
    pants_strengthen,
    pants_star
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

-ifndef(PBSIGIL_PB_H).
-define(PBSIGIL_PB_H, true).
-record(pbsigil, {
    id,
    tid
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

-ifndef(PBSKILLLIST_PB_H).
-define(PBSKILLLIST_PB_H, true).
-record(pbskilllist, {
    skill_list = []
}).
-endif.

-ifndef(PBTEAM_PB_H).
-define(PBTEAM_PB_H, true).
-record(pbteam, {
    leaderid,
    nickname,
    members = [],
    dungeon_id,
    team_num,
    challenge_type
}).
-endif.

-ifndef(PBTEAMCHAT_PB_H).
-define(PBTEAMCHAT_PB_H, true).
-record(pbteamchat, {
    player_id,
    msg
}).
-endif.

-ifndef(PBUSER_PB_H).
-define(PBUSER_PB_H, true).
-record(pbuser, {
    id,
    accid,
    accname,
    nickname,
    career,
    lv,
    exp,
    exp_lim,
    vip_lv,
    vip_exp,
    vip_due_time,
    gold,
    cash_gold,
    coin,
    vigor,
    vigor_lim,
    cost,
    fpt,
    friends_limit,
    bag_limit,
    status,
    core_id,
    bind_gold,
    seal,
    cross_coin,
    last_dungeon,
    is_pass_dungeon,
    hp,
    hp_lim,
    hp_rec,
    mana,
    mana_lim,
    mana_rec,
    mana_init,
    fire,
    water,
    wood,
    holy,
    dark,
    attack,
    def,
    power,
    timestamp_logout,
    reward = [],
    active_skill_ids = [],
    passive_skill_ids = [],
    base_friends_limit,
    beginner_step = [],
    login_reward_flag,
    week_login_days,
    open_boss_info = [],
    combat_point,
    battle_ability,
    honor,
    buy_vigor_times,
    league_name,
    league_title,
    month_login_days,
    month_login_flag,
    return_gold,
    fashion,
    off_time,
    league_id,
    arena_coin,
    league_seal,
    first_recharge_flag,
    q_coin,
    qq
}).
-endif.

-ifndef(PBUSERLIST_PB_H).
-define(PBUSERLIST_PB_H, true).
-record(pbuserlist, {
    user_list = []
}).
-endif.

-ifndef(PBUSERNOTIFYUPDATE_PB_H).
-define(PBUSERNOTIFYUPDATE_PB_H, true).
-record(pbusernotifyupdate, {
    type
}).
-endif.

-ifndef(PBVIPREWARD_PB_H).
-define(PBVIPREWARD_PB_H, true).
-record(pbvipreward, {
    recv_list = []
}).
-endif.

