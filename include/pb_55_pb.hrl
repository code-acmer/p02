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

-ifndef(PBCOMBATBUFF_PB_H).
-define(PBCOMBATBUFF_PB_H, true).
-record(pbcombatbuff, {
    buff_id,
    buff_type,
    continue_value,
    op_type,
    id
}).
-endif.

-ifndef(PBCOMBATEFFECT_PB_H).
-define(PBCOMBATEFFECT_PB_H, true).
-record(pbcombateffect, {
    atk_pos,
    atk_player_id,
    def_pos,
    def_player_id,
    passive_skill_id,
    type,
    effect_point,
    effect_type,
    hurt_list = []
}).
-endif.

-ifndef(PBCOMBATFIGHTER_PB_H).
-define(PBCOMBATFIGHTER_PB_H, true).
-record(pbcombatfighter, {
    unique_id,
    id,
    name,
    lv,
    pos,
    hp_lim,
    hp,
    mp,
    stunt_skill_id,
    resource_id,
    career_id,
    attacker_resource_id,
    deffender_resource_id,
    buffs = [],
    gender,
    career,
    normal_skill_id,
    passive_skill_ids = [],
    weaponbase,
    mountbase,
    equipbase,
    fighter_type,
    stunt_skill_ids = []
}).
-endif.

-ifndef(PBCOMBATHURTATTRI_PB_H).
-define(PBCOMBATHURTATTRI_PB_H, true).
-record(pbcombathurtattri, {
    hp,
    mp,
    buffs = [],
    flag_death,
    flag_frozen,
    flag_sleep,
    flag_swim,
    flag_coma,
    flag_silence,
    flag_chaos,
    flag_fatal,
    flag_meta,
    flag_meta_rate,
    flag_miss,
    flag_beheaded,
    flag_wreck,
    flag_crit,
    flag_parry,
    flag_back_to_bite,
    flag_unyiedlding,
    flag_rebound,
    flag_shift,
    flag_absorb_sub,
    flag_absorb,
    flag_vampire,
    flag_hit_cnt,
    hit_cnt,
    flag_strengthen,
    flag_weaken,
    flag_firm,
    flag_hide,
    hp_lim
}).
-endif.

-ifndef(PBCOMBATREPORT_PB_H).
-define(PBCOMBATREPORT_PB_H, true).
-record(pbcombatreport, {
    report_id,
    result,
    final,
    result_lv,
    copy_id,
    version,
    can_skip,
    attacker_id,
    attacker_unique_id,
    attacker_camp_id,
    attacker_list = [],
    attacker_beast,
    defender_id,
    defender_unique_id,
    defender_camp_id,
    defender_list = [],
    defender_beast,
    report_list = [],
    active_skill_list = [],
    passive_skill_list = [],
    prepare_effect = [],
    attacker_dead = [],
    defender_dead = []
}).
-endif.

-ifndef(PBCOMBATREPORTLIST_PB_H).
-define(PBCOMBATREPORTLIST_PB_H, true).
-record(pbcombatreportlist, {
    combat_report_list = []
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

-ifndef(PBCOMBATROUND_PB_H).
-define(PBCOMBATROUND_PB_H, true).
-record(pbcombatround, {
    unique_id,
    id,
    pos,
    atk_type,
    export_type,
    attacker_id,
    attack_skill,
    master_targets = [],
    round_begin = [],
    before_atk = [],
    before_def = [],
    hurt = [],
    at_atking = [],
    at_defing = [],
    after_def = [],
    after_atk = [],
    ext_hurt = [],
    round_end = [],
    slave_targets = [],
    all_buffs = []
}).
-endif.

-ifndef(PBCOMBATTARGET_PB_H).
-define(PBCOMBATTARGET_PB_H, true).
-record(pbcombattarget, {
    id,
    pos,
    target_type
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

-ifndef(PBSTARTCOMBAT_PB_H).
-define(PBSTARTCOMBAT_PB_H, true).
-record(pbstartcombat, {
    id,
    type,
    value1,
    value2,
    value3
}).
-endif.

