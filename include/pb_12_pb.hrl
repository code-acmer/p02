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

-ifndef(PBCHALLENGEDUNGEON_PB_H).
-define(PBCHALLENGEDUNGEON_PB_H, true).
-record(pbchallengedungeon, {
    dungeon_id,
    next_dungeon_id,
    type,
    reward = [],
    state,
    score,
    left_times,
    have_pass_times,
    sub_route,
    condition = [],
    challenge_times,
    challenge_list = [],
    send_lucky_coin,
    use_lucky_coin,
    max_pass_times,
    skip_mugen_flag,
    cur_hp,
    buy_times,
    ability
}).
-endif.

-ifndef(PBCHALLENGEDUNGEONINFO_PB_H).
-define(PBCHALLENGEDUNGEONINFO_PB_H, true).
-record(pbchallengedungeoninfo, {
    id,
    name,
    lv,
    career,
    have_pass_times,
    score,
    rank,
    battle_ability
}).
-endif.

-ifndef(PBCHALLENGEDUNGEONRANK_PB_H).
-define(PBCHALLENGEDUNGEONRANK_PB_H, true).
-record(pbchallengedungeonrank, {
    rank_list = [],
    self
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

-ifndef(PBCREATUREDROP_PB_H).
-define(PBCREATUREDROP_PB_H, true).
-record(pbcreaturedrop, {
    goods_id,
    number
}).
-endif.

-ifndef(PBDAILYDUNGEON_PB_H).
-define(PBDAILYDUNGEON_PB_H, true).
-record(pbdailydungeon, {
    dungeon,
    condition,
    pass_flag,
    left_times
}).
-endif.

-ifndef(PBDUNGEON_PB_H).
-define(PBDUNGEON_PB_H, true).
-record(pbdungeon, {
    id,
    type,
    is_extra,
    reward = [],
    extra_reward = [],
    special_reward = [],
    state,
    activity_dungeon_reward = [],
    dungeon_info = [],
    sub_route = [],
    score,
    pass_time,
    relive_times,
    team_num,
    team_type,
    cur_sub_dungeon,
    boss_flag,
    team_flag,
    target_list = [],
    hit_reward = [],
    hit_reward_detail = []
}).
-endif.

-ifndef(PBDUNGEONCONDITION_PB_H).
-define(PBDUNGEONCONDITION_PB_H, true).
-record(pbdungeoncondition, {
    time,
    damage,
    hurt,
    combo,
    aircombo,
    skillcancel,
    crit
}).
-endif.

-ifndef(PBDUNGEONCREATURE_PB_H).
-define(PBDUNGEONCREATURE_PB_H, true).
-record(pbdungeoncreature, {
    create_id,
    creature_drop = [],
    creature_id
}).
-endif.

-ifndef(PBDUNGEONMONSTER_PB_H).
-define(PBDUNGEONMONSTER_PB_H, true).
-record(pbdungeonmonster, {
    monster_id,
    monster_drop = [],
    create_id
}).
-endif.

-ifndef(PBDUNGEONREWARD_PB_H).
-define(PBDUNGEONREWARD_PB_H, true).
-record(pbdungeonreward, {
    goods_id,
    number
}).
-endif.

-ifndef(PBDUNGEONSCHEDULE_PB_H).
-define(PBDUNGEONSCHEDULE_PB_H, true).
-record(pbdungeonschedule, {
    dungeon_id,
    last_dungeon,
    state,
    target_info = []
}).
-endif.

-ifndef(PBDUNGEONSCHEDULELIST_PB_H).
-define(PBDUNGEONSCHEDULELIST_PB_H, true).
-record(pbdungeonschedulelist, {
    update_list = []
}).
-endif.

-ifndef(PBDUNGEONTARGET_PB_H).
-define(PBDUNGEONTARGET_PB_H, true).
-record(pbdungeontarget, {
    dungeon_id,
    target_list = [],
    dungeon_level,
    left_times,
    buy_times,
    best_grade,
    done
}).
-endif.

-ifndef(PBFLIPCARD_PB_H).
-define(PBFLIPCARD_PB_H, true).
-record(pbflipcard, {
    dungeon_id,
    card_type,
    reward,
    pos
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

-ifndef(PBHITREWARDDETAIL_PB_H).
-define(PBHITREWARDDETAIL_PB_H, true).
-record(pbhitrewarddetail, {
    combo,
    number
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

-ifndef(PBMONSTERDROP_PB_H).
-define(PBMONSTERDROP_PB_H, true).
-record(pbmonsterdrop, {
    goods_id,
    number
}).
-endif.

-ifndef(PBMOPUP_PB_H).
-define(PBMOPUP_PB_H, true).
-record(pbmopup, {
    normal_reward = [],
    boss_reward = [],
    free_card_reward = [],
    pay_card_reward = []
}).
-endif.

-ifndef(PBMOPUPLIST_PB_H).
-define(PBMOPUPLIST_PB_H, true).
-record(pbmopuplist, {
    dungeon_id,
    times,
    flip_pay_card,
    mop_up_info = []
}).
-endif.

-ifndef(PBMUGENCHALLENGE_PB_H).
-define(PBMUGENCHALLENGE_PB_H, true).
-record(pbmugenchallenge, {
    player_id,
    level
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

-ifndef(PBSOURCEDUNGEON_PB_H).
-define(PBSOURCEDUNGEON_PB_H, true).
-record(pbsourcedungeon, {
    info = []
}).
-endif.

-ifndef(PBSOURCEDUNGEONINFO_PB_H).
-define(PBSOURCEDUNGEONINFO_PB_H, true).
-record(pbsourcedungeoninfo, {
    type,
    left_times
}).
-endif.

-ifndef(PBSUBDUNGEON_PB_H).
-define(PBSUBDUNGEON_PB_H, true).
-record(pbsubdungeon, {
    id,
    create_portal = [],
    wave_monster = [],
    wave_creature = []
}).
-endif.

-ifndef(PBWAVECREATURE_PB_H).
-define(PBWAVECREATURE_PB_H, true).
-record(pbwavecreature, {
    id,
    creature_info = []
}).
-endif.

-ifndef(PBWAVEMONSTER_PB_H).
-define(PBWAVEMONSTER_PB_H, true).
-record(pbwavemonster, {
    id,
    monster_info = []
}).
-endif.

-ifndef(PBWINRATE_PB_H).
-define(PBWINRATE_PB_H, true).
-record(pbwinrate, {
    win_times,
    fail_times,
    win_rate
}).
-endif.

