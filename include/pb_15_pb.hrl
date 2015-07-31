-ifndef(PBACTIVITYSHOP_PB_H).
-define(PBACTIVITYSHOP_PB_H, true).
-record(pbactivityshop, {
    timestamp,
    activity_id,
    shop_list = []
}).
-endif.

-ifndef(PBACTIVITYSHOPMSG_PB_H).
-define(PBACTIVITYSHOPMSG_PB_H, true).
-record(pbactivityshopmsg, {
    id,
    activity_remain_num,
    player_remain_num
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

-ifndef(PBCDKREWARD_PB_H).
-define(PBCDKREWARD_PB_H, true).
-record(pbcdkreward, {
    type,
    cdk
}).
-endif.

-ifndef(PBCHOUJIANG_PB_H).
-define(PBCHOUJIANG_PB_H, true).
-record(pbchoujiang, {
    money_type,
    buy_num,
    is_free
}).
-endif.

-ifndef(PBCHOUJIANGGOODS_PB_H).
-define(PBCHOUJIANGGOODS_PB_H, true).
-record(pbchoujianggoods, {
    goods_id,
    num
}).
-endif.

-ifndef(PBCHOUJIANGINFO_PB_H).
-define(PBCHOUJIANGINFO_PB_H, true).
-record(pbchoujianginfo, {
    coin_timestamp,
    gold_timestamp,
    coin_free_num
}).
-endif.

-ifndef(PBCHOUJIANGRESULT_PB_H).
-define(PBCHOUJIANGRESULT_PB_H, true).
-record(pbchoujiangresult, {
    result_list = []
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

-ifndef(PBEQUIPADDSTAR_PB_H).
-define(PBEQUIPADDSTAR_PB_H, true).
-record(pbequipaddstar, {
    id,
    num
}).
-endif.

-ifndef(PBEQUIPMOVE_PB_H).
-define(PBEQUIPMOVE_PB_H, true).
-record(pbequipmove, {
    id,
    pos
}).
-endif.

-ifndef(PBEQUIPSTRENGTHEN_PB_H).
-define(PBEQUIPSTRENGTHEN_PB_H, true).
-record(pbequipstrengthen, {
    id,
    num
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

-ifndef(PBGENERALSTOREBUY_PB_H).
-define(PBGENERALSTOREBUY_PB_H, true).
-record(pbgeneralstorebuy, {
    store_type,
    pos
}).
-endif.

-ifndef(PBGENERALSTOREINFO_PB_H).
-define(PBGENERALSTOREINFO_PB_H, true).
-record(pbgeneralstoreinfo, {
    store_type,
    shop_info
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

-ifndef(PBGOODSCHANGED_PB_H).
-define(PBGOODSCHANGED_PB_H, true).
-record(pbgoodschanged, {
    added_list,
    deleted_list,
    updated_list,
    update_timestamp
}).
-endif.

-ifndef(PBGOODSINFO_PB_H).
-define(PBGOODSINFO_PB_H, true).
-record(pbgoodsinfo, {
    id,
    num
}).
-endif.

-ifndef(PBGOODSLIST_PB_H).
-define(PBGOODSLIST_PB_H, true).
-record(pbgoodslist, {
    goods_list = [],
    update_timestamp
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

-ifndef(PBINLAIDJEWEL_PB_H).
-define(PBINLAIDJEWEL_PB_H, true).
-record(pbinlaidjewel, {
    id,
    tid,
    num,
    pos
}).
-endif.

-ifndef(PBORDINARYBUY_PB_H).
-define(PBORDINARYBUY_PB_H, true).
-record(pbordinarybuy, {
    base_id,
    num
}).
-endif.

-ifndef(PBRESULT_PB_H).
-define(PBRESULT_PB_H, true).
-record(pbresult, {
    result
}).
-endif.

-ifndef(PBREWARD_PB_H).
-define(PBREWARD_PB_H, true).
-record(pbreward, {
    id,
    goods_id,
    num,
    bind,
    type,
    day
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

-ifndef(PBREWARDLIST_PB_H).
-define(PBREWARDLIST_PB_H, true).
-record(pbrewardlist, {
    id,
    type,
    timestamp,
    reward_list = []
}).
-endif.

-ifndef(PBSELLINGLIST_PB_H).
-define(PBSELLINGLIST_PB_H, true).
-record(pbsellinglist, {
    shop_list = []
}).
-endif.

-ifndef(PBSELLINGSHOP_PB_H).
-define(PBSELLINGSHOP_PB_H, true).
-record(pbsellingshop, {
    base_id,
    num,
    buy_times
}).
-endif.

-ifndef(PBSHOPBUY_PB_H).
-define(PBSHOPBUY_PB_H, true).
-record(pbshopbuy, {
    pos
}).
-endif.

-ifndef(PBSHOPITEM_PB_H).
-define(PBSHOPITEM_PB_H, true).
-record(pbshopitem, {
    id,
    num
}).
-endif.

-ifndef(PBSHOPMSG_PB_H).
-define(PBSHOPMSG_PB_H, true).
-record(pbshopmsg, {
    base_id,
    is_buy,
    pos
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

-ifndef(PBSKILLID_PB_H).
-define(PBSKILLID_PB_H, true).
-record(pbskillid, {
    id
}).
-endif.

-ifndef(PBSKILLIDLIST_PB_H).
-define(PBSKILLIDLIST_PB_H, true).
-record(pbskillidlist, {
    list = []
}).
-endif.

-ifndef(PBSMRITI_PB_H).
-define(PBSMRITI_PB_H, true).
-record(pbsmriti, {
    id,
    tid
}).
-endif.

-ifndef(PBSTERIOUSSHOP_PB_H).
-define(PBSTERIOUSSHOP_PB_H, true).
-record(pbsteriousshop, {
    shop_list = [],
    shop_refresh_num,
    shop_last_refresh_time
}).
-endif.

-ifndef(PBSTOREPRODUCT_PB_H).
-define(PBSTOREPRODUCT_PB_H, true).
-record(pbstoreproduct, {
    id,
    product_id,
    gold,
    reward_gold,
    money,
    icon
}).
-endif.

-ifndef(PBSTOREPRODUCTLIST_PB_H).
-define(PBSTOREPRODUCTLIST_PB_H, true).
-record(pbstoreproductlist, {
    product_list = []
}).
-endif.

-ifndef(PBUPGRADESKILLCARD_PB_H).
-define(PBUPGRADESKILLCARD_PB_H, true).
-record(pbupgradeskillcard, {
    id,
    consume_list = []
}).
-endif.

