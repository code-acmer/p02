-file("src/pb_15_pb.erl", 1).

-module(pb_15_pb).

-export([encode_pbupgradeskillcard/1,
	 decode_pbupgradeskillcard/1,
	 delimited_decode_pbupgradeskillcard/1,
	 encode_pbstoreproductlist/1,
	 decode_pbstoreproductlist/1,
	 delimited_decode_pbstoreproductlist/1,
	 encode_pbstoreproduct/1, decode_pbstoreproduct/1,
	 delimited_decode_pbstoreproduct/1,
	 encode_pbsteriousshop/1, decode_pbsteriousshop/1,
	 delimited_decode_pbsteriousshop/1, encode_pbsmriti/1,
	 decode_pbsmriti/1, delimited_decode_pbsmriti/1,
	 encode_pbskillidlist/1, decode_pbskillidlist/1,
	 delimited_decode_pbskillidlist/1, encode_pbskillid/1,
	 decode_pbskillid/1, delimited_decode_pbskillid/1,
	 encode_pbskill/1, decode_pbskill/1,
	 delimited_decode_pbskill/1, encode_pbshopmsg/1,
	 decode_pbshopmsg/1, delimited_decode_pbshopmsg/1,
	 encode_pbshopitem/1, decode_pbshopitem/1,
	 delimited_decode_pbshopitem/1, encode_pbshopbuy/1,
	 decode_pbshopbuy/1, delimited_decode_pbshopbuy/1,
	 encode_pbsellingshop/1, decode_pbsellingshop/1,
	 delimited_decode_pbsellingshop/1,
	 encode_pbsellinglist/1, decode_pbsellinglist/1,
	 delimited_decode_pbsellinglist/1, encode_pbrewardlist/1,
	 decode_pbrewardlist/1, delimited_decode_pbrewardlist/1,
	 encode_pbrewarditem/1, decode_pbrewarditem/1,
	 delimited_decode_pbrewarditem/1, encode_pbreward/1,
	 decode_pbreward/1, delimited_decode_pbreward/1,
	 encode_pbresult/1, decode_pbresult/1,
	 delimited_decode_pbresult/1, encode_pbordinarybuy/1,
	 decode_pbordinarybuy/1,
	 delimited_decode_pbordinarybuy/1,
	 encode_pbinlaidjewel/1, decode_pbinlaidjewel/1,
	 delimited_decode_pbinlaidjewel/1, encode_pbidstring/1,
	 decode_pbidstring/1, delimited_decode_pbidstring/1,
	 encode_pbid64r/1, decode_pbid64r/1,
	 delimited_decode_pbid64r/1, encode_pbid64/1,
	 decode_pbid64/1, delimited_decode_pbid64/1,
	 encode_pbid32r/1, decode_pbid32r/1,
	 delimited_decode_pbid32r/1, encode_pbid32/1,
	 decode_pbid32/1, delimited_decode_pbid32/1,
	 encode_pbgoodslist/1, decode_pbgoodslist/1,
	 delimited_decode_pbgoodslist/1, encode_pbgoodsinfo/1,
	 decode_pbgoodsinfo/1, delimited_decode_pbgoodsinfo/1,
	 encode_pbgoodschanged/1, decode_pbgoodschanged/1,
	 delimited_decode_pbgoodschanged/1, encode_pbgoods/1,
	 decode_pbgoods/1, delimited_decode_pbgoods/1,
	 encode_pbgeneralstoreinfo/1,
	 decode_pbgeneralstoreinfo/1,
	 delimited_decode_pbgeneralstoreinfo/1,
	 encode_pbgeneralstorebuy/1, decode_pbgeneralstorebuy/1,
	 delimited_decode_pbgeneralstorebuy/1, encode_pbfriend/1,
	 decode_pbfriend/1, delimited_decode_pbfriend/1,
	 encode_pbequipstrengthen/1, decode_pbequipstrengthen/1,
	 delimited_decode_pbequipstrengthen/1,
	 encode_pbequipmove/1, decode_pbequipmove/1,
	 delimited_decode_pbequipmove/1, encode_pbequipaddstar/1,
	 decode_pbequipaddstar/1,
	 delimited_decode_pbequipaddstar/1,
	 encode_pbcombatreward/1, decode_pbcombatreward/1,
	 delimited_decode_pbcombatreward/1,
	 encode_pbchoujiangresult/1, decode_pbchoujiangresult/1,
	 delimited_decode_pbchoujiangresult/1,
	 encode_pbchoujianginfo/1, decode_pbchoujianginfo/1,
	 delimited_decode_pbchoujianginfo/1,
	 encode_pbchoujianggoods/1, decode_pbchoujianggoods/1,
	 delimited_decode_pbchoujianggoods/1,
	 encode_pbchoujiang/1, decode_pbchoujiang/1,
	 delimited_decode_pbchoujiang/1, encode_pbcdkreward/1,
	 decode_pbcdkreward/1, delimited_decode_pbcdkreward/1,
	 encode_pbattribute/1, decode_pbattribute/1,
	 delimited_decode_pbattribute/1,
	 encode_pbactivityshopmsg/1, decode_pbactivityshopmsg/1,
	 delimited_decode_pbactivityshopmsg/1,
	 encode_pbactivityshop/1, decode_pbactivityshop/1,
	 delimited_decode_pbactivityshop/1]).

-export([has_extension/2, extension_size/1,
	 get_extension/2, set_extension/3]).

-export([decode_extensions/1]).

-export([encode/1, decode/2, delimited_decode/2]).

-export([int_to_enum/2, enum_to_int/2]).

-record(pbupgradeskillcard, {id, consume_list}).

-record(pbstoreproductlist, {product_list}).

-record(pbstoreproduct,
	{id, product_id, gold, reward_gold, money, icon}).

-record(pbsteriousshop,
	{shop_list, shop_refresh_num, shop_last_refresh_time}).

-record(pbsmriti, {id, tid}).

-record(pbskillidlist, {list}).

-record(pbskillid, {id}).

-record(pbskill,
	{id, skill_id, player_id, lv, str_lv, sigil, type}).

-record(pbshopmsg, {base_id, is_buy, pos}).

-record(pbshopitem, {id, num}).

-record(pbshopbuy, {pos}).

-record(pbsellingshop, {base_id, num, buy_times}).

-record(pbsellinglist, {shop_list}).

-record(pbrewardlist,
	{id, type, timestamp, reward_list}).

-record(pbrewarditem, {id, num, goods_id}).

-record(pbreward, {id, goods_id, num, bind, type, day}).

-record(pbresult, {result}).

-record(pbordinarybuy, {base_id, num}).

-record(pbinlaidjewel, {id, tid, num, pos}).

-record(pbidstring, {id}).

-record(pbid64r, {ids}).

-record(pbid64, {id}).

-record(pbid32r, {id}).

-record(pbid32, {id}).

-record(pbgoodslist, {goods_list, update_timestamp}).

-record(pbgoodsinfo, {id, num}).

-record(pbgoodschanged,
	{added_list, deleted_list, updated_list,
	 update_timestamp}).

-record(pbgoods,
	{id, goods_id, type, sub_type, player_id, container,
	 position, str_lv, star_lv, hp_lim, bind, attack, def,
	 hit, dodge, crit, anti_crit, stiff, cost, anti_stiff,
	 attack_speed, move_speed, ice, fire, honly, dark,
	 anti_ice, anti_fire, anti_honly, anti_dark, power,
	 quality, jewels, sum, hp_lim_ext, attack_ext, hit_ext,
	 dodge_ext, def_ext, crit_ext, anti_crit_ext, mana_lim,
	 mana_rec, mana_lim_ext, mana_rec_ext, skill_card_exp,
	 card_pos_1, card_pos_2, card_pos_3, value, timestamp,
	 skill_card_status}).

-record(pbgeneralstoreinfo, {store_type, shop_info}).

-record(pbgeneralstorebuy, {store_type, pos}).

-record(pbfriend,
	{id, nickname, level, career, core, off_time, fashion,
	 mugen_pass_times, mugen_score, skill_list, talent,
	 battle_ability, rela, league_name, league_title,
	 put_on_skill, attri, type}).

-record(pbequipstrengthen, {id, num}).

-record(pbequipmove, {id, pos}).

-record(pbequipaddstar, {id, num}).

-record(pbcombatreward,
	{exp, mon_drop_list, dungeon_reward_list, unique_id,
	 seal, evaluate, point, partners}).

-record(pbchoujiangresult, {result_list}).

-record(pbchoujianginfo,
	{coin_timestamp, gold_timestamp, coin_free_num}).

-record(pbchoujianggoods, {goods_id, num}).

-record(pbchoujiang, {money_type, buy_num, is_free}).

-record(pbcdkreward, {type, cdk}).

-record(pbattribute,
	{hp_lim, hp_cur, mana_lim, mana_cur, hp_rec, mana_rec,
	 attack, def, hit, dodge, crit, anti_crit, stiff,
	 anti_stiff, attack_speed, move_speed, attack_effect,
	 def_effect}).

-record(pbactivityshopmsg,
	{id, activity_remain_num, player_remain_num}).

-record(pbactivityshop,
	{timestamp, activity_id, shop_list}).

encode([]) -> [];
encode(Records) when is_list(Records) ->
    delimited_encode(Records);
encode(Record) -> encode(element(1, Record), Record).

encode_pbupgradeskillcard(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_pbupgradeskillcard(Record)
    when is_record(Record, pbupgradeskillcard) ->
    encode(pbupgradeskillcard, Record).

encode_pbstoreproductlist(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_pbstoreproductlist(Record)
    when is_record(Record, pbstoreproductlist) ->
    encode(pbstoreproductlist, Record).

encode_pbstoreproduct(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbstoreproduct(Record)
    when is_record(Record, pbstoreproduct) ->
    encode(pbstoreproduct, Record).

encode_pbsteriousshop(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbsteriousshop(Record)
    when is_record(Record, pbsteriousshop) ->
    encode(pbsteriousshop, Record).

encode_pbsmriti(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbsmriti(Record)
    when is_record(Record, pbsmriti) ->
    encode(pbsmriti, Record).

encode_pbskillidlist(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbskillidlist(Record)
    when is_record(Record, pbskillidlist) ->
    encode(pbskillidlist, Record).

encode_pbskillid(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbskillid(Record)
    when is_record(Record, pbskillid) ->
    encode(pbskillid, Record).

encode_pbskill(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbskill(Record)
    when is_record(Record, pbskill) ->
    encode(pbskill, Record).

encode_pbshopmsg(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbshopmsg(Record)
    when is_record(Record, pbshopmsg) ->
    encode(pbshopmsg, Record).

encode_pbshopitem(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbshopitem(Record)
    when is_record(Record, pbshopitem) ->
    encode(pbshopitem, Record).

encode_pbshopbuy(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbshopbuy(Record)
    when is_record(Record, pbshopbuy) ->
    encode(pbshopbuy, Record).

encode_pbsellingshop(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbsellingshop(Record)
    when is_record(Record, pbsellingshop) ->
    encode(pbsellingshop, Record).

encode_pbsellinglist(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbsellinglist(Record)
    when is_record(Record, pbsellinglist) ->
    encode(pbsellinglist, Record).

encode_pbrewardlist(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbrewardlist(Record)
    when is_record(Record, pbrewardlist) ->
    encode(pbrewardlist, Record).

encode_pbrewarditem(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbrewarditem(Record)
    when is_record(Record, pbrewarditem) ->
    encode(pbrewarditem, Record).

encode_pbreward(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbreward(Record)
    when is_record(Record, pbreward) ->
    encode(pbreward, Record).

encode_pbresult(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbresult(Record)
    when is_record(Record, pbresult) ->
    encode(pbresult, Record).

encode_pbordinarybuy(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbordinarybuy(Record)
    when is_record(Record, pbordinarybuy) ->
    encode(pbordinarybuy, Record).

encode_pbinlaidjewel(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbinlaidjewel(Record)
    when is_record(Record, pbinlaidjewel) ->
    encode(pbinlaidjewel, Record).

encode_pbidstring(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbidstring(Record)
    when is_record(Record, pbidstring) ->
    encode(pbidstring, Record).

encode_pbid64r(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbid64r(Record)
    when is_record(Record, pbid64r) ->
    encode(pbid64r, Record).

encode_pbid64(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbid64(Record) when is_record(Record, pbid64) ->
    encode(pbid64, Record).

encode_pbid32r(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbid32r(Record)
    when is_record(Record, pbid32r) ->
    encode(pbid32r, Record).

encode_pbid32(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbid32(Record) when is_record(Record, pbid32) ->
    encode(pbid32, Record).

encode_pbgoodslist(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbgoodslist(Record)
    when is_record(Record, pbgoodslist) ->
    encode(pbgoodslist, Record).

encode_pbgoodsinfo(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbgoodsinfo(Record)
    when is_record(Record, pbgoodsinfo) ->
    encode(pbgoodsinfo, Record).

encode_pbgoodschanged(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbgoodschanged(Record)
    when is_record(Record, pbgoodschanged) ->
    encode(pbgoodschanged, Record).

encode_pbgoods(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbgoods(Record)
    when is_record(Record, pbgoods) ->
    encode(pbgoods, Record).

encode_pbgeneralstoreinfo(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_pbgeneralstoreinfo(Record)
    when is_record(Record, pbgeneralstoreinfo) ->
    encode(pbgeneralstoreinfo, Record).

encode_pbgeneralstorebuy(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_pbgeneralstorebuy(Record)
    when is_record(Record, pbgeneralstorebuy) ->
    encode(pbgeneralstorebuy, Record).

encode_pbfriend(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbfriend(Record)
    when is_record(Record, pbfriend) ->
    encode(pbfriend, Record).

encode_pbequipstrengthen(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_pbequipstrengthen(Record)
    when is_record(Record, pbequipstrengthen) ->
    encode(pbequipstrengthen, Record).

encode_pbequipmove(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbequipmove(Record)
    when is_record(Record, pbequipmove) ->
    encode(pbequipmove, Record).

encode_pbequipaddstar(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbequipaddstar(Record)
    when is_record(Record, pbequipaddstar) ->
    encode(pbequipaddstar, Record).

encode_pbcombatreward(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbcombatreward(Record)
    when is_record(Record, pbcombatreward) ->
    encode(pbcombatreward, Record).

encode_pbchoujiangresult(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_pbchoujiangresult(Record)
    when is_record(Record, pbchoujiangresult) ->
    encode(pbchoujiangresult, Record).

encode_pbchoujianginfo(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbchoujianginfo(Record)
    when is_record(Record, pbchoujianginfo) ->
    encode(pbchoujianginfo, Record).

encode_pbchoujianggoods(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_pbchoujianggoods(Record)
    when is_record(Record, pbchoujianggoods) ->
    encode(pbchoujianggoods, Record).

encode_pbchoujiang(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbchoujiang(Record)
    when is_record(Record, pbchoujiang) ->
    encode(pbchoujiang, Record).

encode_pbcdkreward(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbcdkreward(Record)
    when is_record(Record, pbcdkreward) ->
    encode(pbcdkreward, Record).

encode_pbattribute(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbattribute(Record)
    when is_record(Record, pbattribute) ->
    encode(pbattribute, Record).

encode_pbactivityshopmsg(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_pbactivityshopmsg(Record)
    when is_record(Record, pbactivityshopmsg) ->
    encode(pbactivityshopmsg, Record).

encode_pbactivityshop(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbactivityshop(Record)
    when is_record(Record, pbactivityshop) ->
    encode(pbactivityshop, Record).

encode(pbactivityshop, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbactivityshop, Record) ->
    [iolist(pbactivityshop, Record)
     | encode_extensions(Record)];
encode(pbactivityshopmsg, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbactivityshopmsg, Record) ->
    [iolist(pbactivityshopmsg, Record)
     | encode_extensions(Record)];
encode(pbattribute, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbattribute, Record) ->
    [iolist(pbattribute, Record)
     | encode_extensions(Record)];
encode(pbcdkreward, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbcdkreward, Record) ->
    [iolist(pbcdkreward, Record)
     | encode_extensions(Record)];
encode(pbchoujiang, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbchoujiang, Record) ->
    [iolist(pbchoujiang, Record)
     | encode_extensions(Record)];
encode(pbchoujianggoods, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbchoujianggoods, Record) ->
    [iolist(pbchoujianggoods, Record)
     | encode_extensions(Record)];
encode(pbchoujianginfo, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbchoujianginfo, Record) ->
    [iolist(pbchoujianginfo, Record)
     | encode_extensions(Record)];
encode(pbchoujiangresult, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbchoujiangresult, Record) ->
    [iolist(pbchoujiangresult, Record)
     | encode_extensions(Record)];
encode(pbcombatreward, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbcombatreward, Record) ->
    [iolist(pbcombatreward, Record)
     | encode_extensions(Record)];
encode(pbequipaddstar, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbequipaddstar, Record) ->
    [iolist(pbequipaddstar, Record)
     | encode_extensions(Record)];
encode(pbequipmove, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbequipmove, Record) ->
    [iolist(pbequipmove, Record)
     | encode_extensions(Record)];
encode(pbequipstrengthen, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbequipstrengthen, Record) ->
    [iolist(pbequipstrengthen, Record)
     | encode_extensions(Record)];
encode(pbfriend, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbfriend, Record) ->
    [iolist(pbfriend, Record) | encode_extensions(Record)];
encode(pbgeneralstorebuy, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbgeneralstorebuy, Record) ->
    [iolist(pbgeneralstorebuy, Record)
     | encode_extensions(Record)];
encode(pbgeneralstoreinfo, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbgeneralstoreinfo, Record) ->
    [iolist(pbgeneralstoreinfo, Record)
     | encode_extensions(Record)];
encode(pbgoods, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbgoods, Record) ->
    [iolist(pbgoods, Record) | encode_extensions(Record)];
encode(pbgoodschanged, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbgoodschanged, Record) ->
    [iolist(pbgoodschanged, Record)
     | encode_extensions(Record)];
encode(pbgoodsinfo, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbgoodsinfo, Record) ->
    [iolist(pbgoodsinfo, Record)
     | encode_extensions(Record)];
encode(pbgoodslist, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbgoodslist, Record) ->
    [iolist(pbgoodslist, Record)
     | encode_extensions(Record)];
encode(pbid32, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbid32, Record) ->
    [iolist(pbid32, Record) | encode_extensions(Record)];
encode(pbid32r, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbid32r, Record) ->
    [iolist(pbid32r, Record) | encode_extensions(Record)];
encode(pbid64, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbid64, Record) ->
    [iolist(pbid64, Record) | encode_extensions(Record)];
encode(pbid64r, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbid64r, Record) ->
    [iolist(pbid64r, Record) | encode_extensions(Record)];
encode(pbidstring, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbidstring, Record) ->
    [iolist(pbidstring, Record)
     | encode_extensions(Record)];
encode(pbinlaidjewel, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbinlaidjewel, Record) ->
    [iolist(pbinlaidjewel, Record)
     | encode_extensions(Record)];
encode(pbordinarybuy, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbordinarybuy, Record) ->
    [iolist(pbordinarybuy, Record)
     | encode_extensions(Record)];
encode(pbresult, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbresult, Record) ->
    [iolist(pbresult, Record) | encode_extensions(Record)];
encode(pbreward, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbreward, Record) ->
    [iolist(pbreward, Record) | encode_extensions(Record)];
encode(pbrewarditem, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbrewarditem, Record) ->
    [iolist(pbrewarditem, Record)
     | encode_extensions(Record)];
encode(pbrewardlist, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbrewardlist, Record) ->
    [iolist(pbrewardlist, Record)
     | encode_extensions(Record)];
encode(pbsellinglist, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbsellinglist, Record) ->
    [iolist(pbsellinglist, Record)
     | encode_extensions(Record)];
encode(pbsellingshop, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbsellingshop, Record) ->
    [iolist(pbsellingshop, Record)
     | encode_extensions(Record)];
encode(pbshopbuy, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbshopbuy, Record) ->
    [iolist(pbshopbuy, Record) | encode_extensions(Record)];
encode(pbshopitem, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbshopitem, Record) ->
    [iolist(pbshopitem, Record)
     | encode_extensions(Record)];
encode(pbshopmsg, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbshopmsg, Record) ->
    [iolist(pbshopmsg, Record) | encode_extensions(Record)];
encode(pbskill, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbskill, Record) ->
    [iolist(pbskill, Record) | encode_extensions(Record)];
encode(pbskillid, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbskillid, Record) ->
    [iolist(pbskillid, Record) | encode_extensions(Record)];
encode(pbskillidlist, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbskillidlist, Record) ->
    [iolist(pbskillidlist, Record)
     | encode_extensions(Record)];
encode(pbsmriti, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbsmriti, Record) ->
    [iolist(pbsmriti, Record) | encode_extensions(Record)];
encode(pbsteriousshop, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbsteriousshop, Record) ->
    [iolist(pbsteriousshop, Record)
     | encode_extensions(Record)];
encode(pbstoreproduct, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbstoreproduct, Record) ->
    [iolist(pbstoreproduct, Record)
     | encode_extensions(Record)];
encode(pbstoreproductlist, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbstoreproductlist, Record) ->
    [iolist(pbstoreproductlist, Record)
     | encode_extensions(Record)];
encode(pbupgradeskillcard, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbupgradeskillcard, Record) ->
    [iolist(pbupgradeskillcard, Record)
     | encode_extensions(Record)].

encode_extensions(_) -> [].

delimited_encode(Records) ->
    lists:map(fun (Record) ->
		      IoRec = encode(Record),
		      Size = iolist_size(IoRec),
		      [protobuffs:encode_varint(Size), IoRec]
	      end,
	      Records).

iolist(pbactivityshop, Record) ->
    [pack(1, optional,
	  with_default(Record#pbactivityshop.timestamp, none),
	  int32, []),
     pack(2, optional,
	  with_default(Record#pbactivityshop.activity_id, none),
	  int32, []),
     pack(3, repeated,
	  with_default(Record#pbactivityshop.shop_list, none),
	  pbactivityshopmsg, [])];
iolist(pbactivityshopmsg, Record) ->
    [pack(1, optional,
	  with_default(Record#pbactivityshopmsg.id, none), int32,
	  []),
     pack(2, optional,
	  with_default(Record#pbactivityshopmsg.activity_remain_num,
		       none),
	  int32, []),
     pack(3, optional,
	  with_default(Record#pbactivityshopmsg.player_remain_num,
		       none),
	  int32, [])];
iolist(pbattribute, Record) ->
    [pack(1, optional,
	  with_default(Record#pbattribute.hp_lim, none), int32,
	  []),
     pack(2, optional,
	  with_default(Record#pbattribute.hp_cur, none), int32,
	  []),
     pack(3, optional,
	  with_default(Record#pbattribute.mana_lim, none), int32,
	  []),
     pack(4, optional,
	  with_default(Record#pbattribute.mana_cur, none), int32,
	  []),
     pack(5, optional,
	  with_default(Record#pbattribute.hp_rec, none), int32,
	  []),
     pack(6, optional,
	  with_default(Record#pbattribute.mana_rec, none), int32,
	  []),
     pack(7, optional,
	  with_default(Record#pbattribute.attack, none), int32,
	  []),
     pack(8, optional,
	  with_default(Record#pbattribute.def, none), int32, []),
     pack(9, optional,
	  with_default(Record#pbattribute.hit, none), int32, []),
     pack(10, optional,
	  with_default(Record#pbattribute.dodge, none), int32,
	  []),
     pack(11, optional,
	  with_default(Record#pbattribute.crit, none), int32, []),
     pack(12, optional,
	  with_default(Record#pbattribute.anti_crit, none), int32,
	  []),
     pack(13, optional,
	  with_default(Record#pbattribute.stiff, none), int32,
	  []),
     pack(14, optional,
	  with_default(Record#pbattribute.anti_stiff, none),
	  int32, []),
     pack(15, optional,
	  with_default(Record#pbattribute.attack_speed, none),
	  int32, []),
     pack(16, optional,
	  with_default(Record#pbattribute.move_speed, none),
	  int32, []),
     pack(17, optional,
	  with_default(Record#pbattribute.attack_effect, none),
	  int32, []),
     pack(18, optional,
	  with_default(Record#pbattribute.def_effect, none),
	  int32, [])];
iolist(pbcdkreward, Record) ->
    [pack(1, optional,
	  with_default(Record#pbcdkreward.type, none), int32, []),
     pack(2, optional,
	  with_default(Record#pbcdkreward.cdk, none), string,
	  [])];
iolist(pbchoujiang, Record) ->
    [pack(1, optional,
	  with_default(Record#pbchoujiang.money_type, none),
	  int32, []),
     pack(2, optional,
	  with_default(Record#pbchoujiang.buy_num, none), int32,
	  []),
     pack(3, optional,
	  with_default(Record#pbchoujiang.is_free, none), int32,
	  [])];
iolist(pbchoujianggoods, Record) ->
    [pack(1, optional,
	  with_default(Record#pbchoujianggoods.goods_id, none),
	  int32, []),
     pack(2, optional,
	  with_default(Record#pbchoujianggoods.num, none), int32,
	  [])];
iolist(pbchoujianginfo, Record) ->
    [pack(1, optional,
	  with_default(Record#pbchoujianginfo.coin_timestamp,
		       none),
	  int32, []),
     pack(2, optional,
	  with_default(Record#pbchoujianginfo.gold_timestamp,
		       none),
	  int32, []),
     pack(3, optional,
	  with_default(Record#pbchoujianginfo.coin_free_num,
		       none),
	  int32, [])];
iolist(pbchoujiangresult, Record) ->
    [pack(1, repeated,
	  with_default(Record#pbchoujiangresult.result_list,
		       none),
	  pbgoodsinfo, [])];
iolist(pbcombatreward, Record) ->
    [pack(1, optional,
	  with_default(Record#pbcombatreward.exp, none), int32,
	  []),
     pack(2, repeated,
	  with_default(Record#pbcombatreward.mon_drop_list, none),
	  pbrewarditem, []),
     pack(3, repeated,
	  with_default(Record#pbcombatreward.dungeon_reward_list,
		       none),
	  pbrewarditem, []),
     pack(4, optional,
	  with_default(Record#pbcombatreward.unique_id, none),
	  int64, []),
     pack(5, optional,
	  with_default(Record#pbcombatreward.seal, none), int32,
	  []),
     pack(6, optional,
	  with_default(Record#pbcombatreward.evaluate, none),
	  int32, []),
     pack(7, optional,
	  with_default(Record#pbcombatreward.point, none), int32,
	  []),
     pack(8, repeated,
	  with_default(Record#pbcombatreward.partners, none),
	  int64, [])];
iolist(pbequipaddstar, Record) ->
    [pack(1, optional,
	  with_default(Record#pbequipaddstar.id, none), int32,
	  []),
     pack(2, optional,
	  with_default(Record#pbequipaddstar.num, none), int32,
	  [])];
iolist(pbequipmove, Record) ->
    [pack(1, optional,
	  with_default(Record#pbequipmove.id, none), int32, []),
     pack(2, optional,
	  with_default(Record#pbequipmove.pos, none), int32, [])];
iolist(pbequipstrengthen, Record) ->
    [pack(1, optional,
	  with_default(Record#pbequipstrengthen.id, none), int32,
	  []),
     pack(2, optional,
	  with_default(Record#pbequipstrengthen.num, none), int32,
	  [])];
iolist(pbfriend, Record) ->
    [pack(1, optional,
	  with_default(Record#pbfriend.id, none), int64, []),
     pack(2, optional,
	  with_default(Record#pbfriend.nickname, none), string,
	  []),
     pack(3, optional,
	  with_default(Record#pbfriend.level, none), int32, []),
     pack(4, optional,
	  with_default(Record#pbfriend.career, none), int32, []),
     pack(5, repeated,
	  with_default(Record#pbfriend.core, none), pbgoods, []),
     pack(6, optional,
	  with_default(Record#pbfriend.off_time, none), int32,
	  []),
     pack(7, repeated,
	  with_default(Record#pbfriend.fashion, none), pbgoods,
	  []),
     pack(8, optional,
	  with_default(Record#pbfriend.mugen_pass_times, none),
	  int32, []),
     pack(9, optional,
	  with_default(Record#pbfriend.mugen_score, none), int32,
	  []),
     pack(10, repeated,
	  with_default(Record#pbfriend.skill_list, none), pbskill,
	  []),
     pack(11, repeated,
	  with_default(Record#pbfriend.talent, none), pbskill,
	  []),
     pack(12, optional,
	  with_default(Record#pbfriend.battle_ability, none),
	  int32, []),
     pack(13, optional,
	  with_default(Record#pbfriend.rela, none), int32, []),
     pack(14, optional,
	  with_default(Record#pbfriend.league_name, none), string,
	  []),
     pack(15, optional,
	  with_default(Record#pbfriend.league_title, none), int32,
	  []),
     pack(16, repeated,
	  with_default(Record#pbfriend.put_on_skill, none), int32,
	  []),
     pack(17, optional,
	  with_default(Record#pbfriend.attri, none), pbattribute,
	  []),
     pack(18, optional,
	  with_default(Record#pbfriend.type, none), int32, [])];
iolist(pbgeneralstorebuy, Record) ->
    [pack(1, optional,
	  with_default(Record#pbgeneralstorebuy.store_type, none),
	  int32, []),
     pack(2, optional,
	  with_default(Record#pbgeneralstorebuy.pos, none), int32,
	  [])];
iolist(pbgeneralstoreinfo, Record) ->
    [pack(1, optional,
	  with_default(Record#pbgeneralstoreinfo.store_type,
		       none),
	  int32, []),
     pack(2, optional,
	  with_default(Record#pbgeneralstoreinfo.shop_info, none),
	  pbsteriousshop, [])];
iolist(pbgoods, Record) ->
    [pack(1, optional,
	  with_default(Record#pbgoods.id, none), int32, []),
     pack(2, optional,
	  with_default(Record#pbgoods.goods_id, none), int32, []),
     pack(3, optional,
	  with_default(Record#pbgoods.type, none), int32, []),
     pack(4, optional,
	  with_default(Record#pbgoods.sub_type, none), int32, []),
     pack(5, optional,
	  with_default(Record#pbgoods.player_id, none), int64,
	  []),
     pack(6, optional,
	  with_default(Record#pbgoods.container, none), int32,
	  []),
     pack(7, optional,
	  with_default(Record#pbgoods.position, none), int32, []),
     pack(8, optional,
	  with_default(Record#pbgoods.str_lv, none), int32, []),
     pack(9, optional,
	  with_default(Record#pbgoods.star_lv, none), int32, []),
     pack(10, optional,
	  with_default(Record#pbgoods.hp_lim, none), int32, []),
     pack(11, optional,
	  with_default(Record#pbgoods.bind, none), int32, []),
     pack(12, optional,
	  with_default(Record#pbgoods.attack, none), int32, []),
     pack(13, optional,
	  with_default(Record#pbgoods.def, none), int32, []),
     pack(14, optional,
	  with_default(Record#pbgoods.hit, none), int32, []),
     pack(15, optional,
	  with_default(Record#pbgoods.dodge, none), int32, []),
     pack(16, optional,
	  with_default(Record#pbgoods.crit, none), int32, []),
     pack(17, optional,
	  with_default(Record#pbgoods.anti_crit, none), int32,
	  []),
     pack(18, optional,
	  with_default(Record#pbgoods.stiff, none), int32, []),
     pack(19, optional,
	  with_default(Record#pbgoods.cost, none), int32, []),
     pack(20, optional,
	  with_default(Record#pbgoods.anti_stiff, none), int32,
	  []),
     pack(21, optional,
	  with_default(Record#pbgoods.attack_speed, none), int32,
	  []),
     pack(22, optional,
	  with_default(Record#pbgoods.move_speed, none), int32,
	  []),
     pack(23, optional,
	  with_default(Record#pbgoods.ice, none), int32, []),
     pack(24, optional,
	  with_default(Record#pbgoods.fire, none), int32, []),
     pack(25, optional,
	  with_default(Record#pbgoods.honly, none), int32, []),
     pack(26, optional,
	  with_default(Record#pbgoods.dark, none), int32, []),
     pack(27, optional,
	  with_default(Record#pbgoods.anti_ice, none), int32, []),
     pack(28, optional,
	  with_default(Record#pbgoods.anti_fire, none), int32,
	  []),
     pack(29, optional,
	  with_default(Record#pbgoods.anti_honly, none), int32,
	  []),
     pack(30, optional,
	  with_default(Record#pbgoods.anti_dark, none), int32,
	  []),
     pack(31, optional,
	  with_default(Record#pbgoods.power, none), int32, []),
     pack(32, optional,
	  with_default(Record#pbgoods.quality, none), int32, []),
     pack(33, repeated,
	  with_default(Record#pbgoods.jewels, none), int32, []),
     pack(34, optional,
	  with_default(Record#pbgoods.sum, none), int32, []),
     pack(35, optional,
	  with_default(Record#pbgoods.hp_lim_ext, none), int32,
	  []),
     pack(36, optional,
	  with_default(Record#pbgoods.attack_ext, none), int32,
	  []),
     pack(37, optional,
	  with_default(Record#pbgoods.hit_ext, none), int32, []),
     pack(38, optional,
	  with_default(Record#pbgoods.dodge_ext, none), int32,
	  []),
     pack(39, optional,
	  with_default(Record#pbgoods.def_ext, none), int32, []),
     pack(40, optional,
	  with_default(Record#pbgoods.crit_ext, none), int32, []),
     pack(41, optional,
	  with_default(Record#pbgoods.anti_crit_ext, none), int32,
	  []),
     pack(42, optional,
	  with_default(Record#pbgoods.mana_lim, none), int32, []),
     pack(43, optional,
	  with_default(Record#pbgoods.mana_rec, none), int32, []),
     pack(44, optional,
	  with_default(Record#pbgoods.mana_lim_ext, none), int32,
	  []),
     pack(45, optional,
	  with_default(Record#pbgoods.mana_rec_ext, none), int32,
	  []),
     pack(46, optional,
	  with_default(Record#pbgoods.skill_card_exp, none),
	  int32, []),
     pack(47, optional,
	  with_default(Record#pbgoods.card_pos_1, none), int32,
	  []),
     pack(48, optional,
	  with_default(Record#pbgoods.card_pos_2, none), int32,
	  []),
     pack(49, optional,
	  with_default(Record#pbgoods.card_pos_3, none), int32,
	  []),
     pack(50, repeated,
	  with_default(Record#pbgoods.value, none), pbgoodsinfo,
	  []),
     pack(51, optional,
	  with_default(Record#pbgoods.timestamp, none), int32,
	  []),
     pack(52, optional,
	  with_default(Record#pbgoods.skill_card_status, none),
	  int32, [])];
iolist(pbgoodschanged, Record) ->
    [pack(1, optional,
	  with_default(Record#pbgoodschanged.added_list, none),
	  pbgoodslist, []),
     pack(2, optional,
	  with_default(Record#pbgoodschanged.deleted_list, none),
	  pbgoodslist, []),
     pack(3, optional,
	  with_default(Record#pbgoodschanged.updated_list, none),
	  pbgoodslist, []),
     pack(4, optional,
	  with_default(Record#pbgoodschanged.update_timestamp,
		       none),
	  int32, [])];
iolist(pbgoodsinfo, Record) ->
    [pack(1, optional,
	  with_default(Record#pbgoodsinfo.id, none), int32, []),
     pack(2, optional,
	  with_default(Record#pbgoodsinfo.num, none), int32, [])];
iolist(pbgoodslist, Record) ->
    [pack(1, repeated,
	  with_default(Record#pbgoodslist.goods_list, none),
	  pbgoods, []),
     pack(2, optional,
	  with_default(Record#pbgoodslist.update_timestamp, none),
	  int32, [])];
iolist(pbid32, Record) ->
    [pack(1, optional, with_default(Record#pbid32.id, none),
	  int32, [])];
iolist(pbid32r, Record) ->
    [pack(1, repeated,
	  with_default(Record#pbid32r.id, none), int32, [])];
iolist(pbid64, Record) ->
    [pack(1, optional, with_default(Record#pbid64.id, none),
	  int64, [])];
iolist(pbid64r, Record) ->
    [pack(1, repeated,
	  with_default(Record#pbid64r.ids, none), int64, [])];
iolist(pbidstring, Record) ->
    [pack(1, optional,
	  with_default(Record#pbidstring.id, none), string, [])];
iolist(pbinlaidjewel, Record) ->
    [pack(1, optional,
	  with_default(Record#pbinlaidjewel.id, none), int32, []),
     pack(2, optional,
	  with_default(Record#pbinlaidjewel.tid, none), int32,
	  []),
     pack(3, optional,
	  with_default(Record#pbinlaidjewel.num, none), int32,
	  []),
     pack(4, optional,
	  with_default(Record#pbinlaidjewel.pos, none), int32,
	  [])];
iolist(pbordinarybuy, Record) ->
    [pack(1, optional,
	  with_default(Record#pbordinarybuy.base_id, none), int32,
	  []),
     pack(2, optional,
	  with_default(Record#pbordinarybuy.num, none), int32,
	  [])];
iolist(pbresult, Record) ->
    [pack(1, optional,
	  with_default(Record#pbresult.result, none), int32, [])];
iolist(pbreward, Record) ->
    [pack(1, optional,
	  with_default(Record#pbreward.id, none), int32, []),
     pack(2, optional,
	  with_default(Record#pbreward.goods_id, none), int32,
	  []),
     pack(3, optional,
	  with_default(Record#pbreward.num, none), int32, []),
     pack(4, optional,
	  with_default(Record#pbreward.bind, none), int32, []),
     pack(5, optional,
	  with_default(Record#pbreward.type, none), int32, []),
     pack(6, optional,
	  with_default(Record#pbreward.day, none), int32, [])];
iolist(pbrewarditem, Record) ->
    [pack(1, optional,
	  with_default(Record#pbrewarditem.id, none), int32, []),
     pack(3, optional,
	  with_default(Record#pbrewarditem.num, none), int32, []),
     pack(4, optional,
	  with_default(Record#pbrewarditem.goods_id, none), int32,
	  [])];
iolist(pbrewardlist, Record) ->
    [pack(1, optional,
	  with_default(Record#pbrewardlist.id, none), int32, []),
     pack(2, optional,
	  with_default(Record#pbrewardlist.type, none), int32,
	  []),
     pack(3, optional,
	  with_default(Record#pbrewardlist.timestamp, none),
	  int32, []),
     pack(5, repeated,
	  with_default(Record#pbrewardlist.reward_list, none),
	  pbreward, [])];
iolist(pbsellinglist, Record) ->
    [pack(1, repeated,
	  with_default(Record#pbsellinglist.shop_list, none),
	  pbsellingshop, [])];
iolist(pbsellingshop, Record) ->
    [pack(1, optional,
	  with_default(Record#pbsellingshop.base_id, none), int32,
	  []),
     pack(2, optional,
	  with_default(Record#pbsellingshop.num, none), int32,
	  []),
     pack(3, optional,
	  with_default(Record#pbsellingshop.buy_times, none),
	  int32, [])];
iolist(pbshopbuy, Record) ->
    [pack(1, optional,
	  with_default(Record#pbshopbuy.pos, none), int32, [])];
iolist(pbshopitem, Record) ->
    [pack(1, optional,
	  with_default(Record#pbshopitem.id, none), int32, []),
     pack(2, optional,
	  with_default(Record#pbshopitem.num, none), int32, [])];
iolist(pbshopmsg, Record) ->
    [pack(1, optional,
	  with_default(Record#pbshopmsg.base_id, none), int32,
	  []),
     pack(2, optional,
	  with_default(Record#pbshopmsg.is_buy, none), int32, []),
     pack(3, optional,
	  with_default(Record#pbshopmsg.pos, none), int32, [])];
iolist(pbskill, Record) ->
    [pack(1, optional,
	  with_default(Record#pbskill.id, none), int32, []),
     pack(2, optional,
	  with_default(Record#pbskill.skill_id, none), int32, []),
     pack(3, optional,
	  with_default(Record#pbskill.player_id, none), int32,
	  []),
     pack(4, optional, with_default(Record#pbskill.lv, none),
	  int32, []),
     pack(5, optional,
	  with_default(Record#pbskill.str_lv, none), int32, []),
     pack(6, repeated,
	  with_default(Record#pbskill.sigil, none), int32, []),
     pack(7, optional,
	  with_default(Record#pbskill.type, none), int32, [])];
iolist(pbskillid, Record) ->
    [pack(1, optional,
	  with_default(Record#pbskillid.id, none), int32, [])];
iolist(pbskillidlist, Record) ->
    [pack(1, repeated,
	  with_default(Record#pbskillidlist.list, none),
	  pbskillid, [])];
iolist(pbsmriti, Record) ->
    [pack(1, optional,
	  with_default(Record#pbsmriti.id, none), int32, []),
     pack(2, optional,
	  with_default(Record#pbsmriti.tid, none), int32, [])];
iolist(pbsteriousshop, Record) ->
    [pack(1, repeated,
	  with_default(Record#pbsteriousshop.shop_list, none),
	  pbshopmsg, []),
     pack(2, optional,
	  with_default(Record#pbsteriousshop.shop_refresh_num,
		       none),
	  int32, []),
     pack(3, optional,
	  with_default(Record#pbsteriousshop.shop_last_refresh_time,
		       none),
	  int32, [])];
iolist(pbstoreproduct, Record) ->
    [pack(1, optional,
	  with_default(Record#pbstoreproduct.id, none), int32,
	  []),
     pack(2, optional,
	  with_default(Record#pbstoreproduct.product_id, none),
	  string, []),
     pack(3, optional,
	  with_default(Record#pbstoreproduct.gold, none), int32,
	  []),
     pack(4, optional,
	  with_default(Record#pbstoreproduct.reward_gold, none),
	  int32, []),
     pack(5, optional,
	  with_default(Record#pbstoreproduct.money, none), int32,
	  []),
     pack(6, optional,
	  with_default(Record#pbstoreproduct.icon, none), int32,
	  [])];
iolist(pbstoreproductlist, Record) ->
    [pack(1, repeated,
	  with_default(Record#pbstoreproductlist.product_list,
		       none),
	  pbstoreproduct, [])];
iolist(pbupgradeskillcard, Record) ->
    [pack(1, optional,
	  with_default(Record#pbupgradeskillcard.id, none), int32,
	  []),
     pack(2, repeated,
	  with_default(Record#pbupgradeskillcard.consume_list,
		       none),
	  pbgoodsinfo, [])].

with_default(Default, Default) -> undefined;
with_default(Val, _) -> Val.

pack(_, optional, undefined, _, _) -> [];
pack(_, repeated, undefined, _, _) -> [];
pack(_, repeated_packed, undefined, _, _) -> [];
pack(_, repeated_packed, [], _, _) -> [];
pack(FNum, required, undefined, Type, _) ->
    exit({error,
	  {required_field_is_undefined, FNum, Type}});
pack(_, repeated, [], _, Acc) -> lists:reverse(Acc);
pack(FNum, repeated, [Head | Tail], Type, Acc) ->
    pack(FNum, repeated, Tail, Type,
	 [pack(FNum, optional, Head, Type, []) | Acc]);
pack(FNum, repeated_packed, Data, Type, _) ->
    protobuffs:encode_packed(FNum, Data, Type);
pack(FNum, _, Data, _, _) when is_tuple(Data) ->
    [RecName | _] = tuple_to_list(Data),
    protobuffs:encode(FNum, encode(RecName, Data), bytes);
pack(FNum, _, Data, Type, _)
    when Type =:= bool;
	 Type =:= int32;
	 Type =:= uint32;
	 Type =:= int64;
	 Type =:= uint64;
	 Type =:= sint32;
	 Type =:= sint64;
	 Type =:= fixed32;
	 Type =:= sfixed32;
	 Type =:= fixed64;
	 Type =:= sfixed64;
	 Type =:= string;
	 Type =:= bytes;
	 Type =:= float;
	 Type =:= double ->
    protobuffs:encode(FNum, Data, Type);
pack(FNum, _, Data, Type, _) when is_atom(Data) ->
    protobuffs:encode(FNum, enum_to_int(Type, Data), enum).

enum_to_int(pikachu, value) -> 1.

int_to_enum(_, Val) -> Val.

decode_pbupgradeskillcard(Bytes)
    when is_binary(Bytes) ->
    decode(pbupgradeskillcard, Bytes).

decode_pbstoreproductlist(Bytes)
    when is_binary(Bytes) ->
    decode(pbstoreproductlist, Bytes).

decode_pbstoreproduct(Bytes) when is_binary(Bytes) ->
    decode(pbstoreproduct, Bytes).

decode_pbsteriousshop(Bytes) when is_binary(Bytes) ->
    decode(pbsteriousshop, Bytes).

decode_pbsmriti(Bytes) when is_binary(Bytes) ->
    decode(pbsmriti, Bytes).

decode_pbskillidlist(Bytes) when is_binary(Bytes) ->
    decode(pbskillidlist, Bytes).

decode_pbskillid(Bytes) when is_binary(Bytes) ->
    decode(pbskillid, Bytes).

decode_pbskill(Bytes) when is_binary(Bytes) ->
    decode(pbskill, Bytes).

decode_pbshopmsg(Bytes) when is_binary(Bytes) ->
    decode(pbshopmsg, Bytes).

decode_pbshopitem(Bytes) when is_binary(Bytes) ->
    decode(pbshopitem, Bytes).

decode_pbshopbuy(Bytes) when is_binary(Bytes) ->
    decode(pbshopbuy, Bytes).

decode_pbsellingshop(Bytes) when is_binary(Bytes) ->
    decode(pbsellingshop, Bytes).

decode_pbsellinglist(Bytes) when is_binary(Bytes) ->
    decode(pbsellinglist, Bytes).

decode_pbrewardlist(Bytes) when is_binary(Bytes) ->
    decode(pbrewardlist, Bytes).

decode_pbrewarditem(Bytes) when is_binary(Bytes) ->
    decode(pbrewarditem, Bytes).

decode_pbreward(Bytes) when is_binary(Bytes) ->
    decode(pbreward, Bytes).

decode_pbresult(Bytes) when is_binary(Bytes) ->
    decode(pbresult, Bytes).

decode_pbordinarybuy(Bytes) when is_binary(Bytes) ->
    decode(pbordinarybuy, Bytes).

decode_pbinlaidjewel(Bytes) when is_binary(Bytes) ->
    decode(pbinlaidjewel, Bytes).

decode_pbidstring(Bytes) when is_binary(Bytes) ->
    decode(pbidstring, Bytes).

decode_pbid64r(Bytes) when is_binary(Bytes) ->
    decode(pbid64r, Bytes).

decode_pbid64(Bytes) when is_binary(Bytes) ->
    decode(pbid64, Bytes).

decode_pbid32r(Bytes) when is_binary(Bytes) ->
    decode(pbid32r, Bytes).

decode_pbid32(Bytes) when is_binary(Bytes) ->
    decode(pbid32, Bytes).

decode_pbgoodslist(Bytes) when is_binary(Bytes) ->
    decode(pbgoodslist, Bytes).

decode_pbgoodsinfo(Bytes) when is_binary(Bytes) ->
    decode(pbgoodsinfo, Bytes).

decode_pbgoodschanged(Bytes) when is_binary(Bytes) ->
    decode(pbgoodschanged, Bytes).

decode_pbgoods(Bytes) when is_binary(Bytes) ->
    decode(pbgoods, Bytes).

decode_pbgeneralstoreinfo(Bytes)
    when is_binary(Bytes) ->
    decode(pbgeneralstoreinfo, Bytes).

decode_pbgeneralstorebuy(Bytes) when is_binary(Bytes) ->
    decode(pbgeneralstorebuy, Bytes).

decode_pbfriend(Bytes) when is_binary(Bytes) ->
    decode(pbfriend, Bytes).

decode_pbequipstrengthen(Bytes) when is_binary(Bytes) ->
    decode(pbequipstrengthen, Bytes).

decode_pbequipmove(Bytes) when is_binary(Bytes) ->
    decode(pbequipmove, Bytes).

decode_pbequipaddstar(Bytes) when is_binary(Bytes) ->
    decode(pbequipaddstar, Bytes).

decode_pbcombatreward(Bytes) when is_binary(Bytes) ->
    decode(pbcombatreward, Bytes).

decode_pbchoujiangresult(Bytes) when is_binary(Bytes) ->
    decode(pbchoujiangresult, Bytes).

decode_pbchoujianginfo(Bytes) when is_binary(Bytes) ->
    decode(pbchoujianginfo, Bytes).

decode_pbchoujianggoods(Bytes) when is_binary(Bytes) ->
    decode(pbchoujianggoods, Bytes).

decode_pbchoujiang(Bytes) when is_binary(Bytes) ->
    decode(pbchoujiang, Bytes).

decode_pbcdkreward(Bytes) when is_binary(Bytes) ->
    decode(pbcdkreward, Bytes).

decode_pbattribute(Bytes) when is_binary(Bytes) ->
    decode(pbattribute, Bytes).

decode_pbactivityshopmsg(Bytes) when is_binary(Bytes) ->
    decode(pbactivityshopmsg, Bytes).

decode_pbactivityshop(Bytes) when is_binary(Bytes) ->
    decode(pbactivityshop, Bytes).

delimited_decode_pbactivityshop(Bytes) ->
    delimited_decode(pbactivityshop, Bytes).

delimited_decode_pbactivityshopmsg(Bytes) ->
    delimited_decode(pbactivityshopmsg, Bytes).

delimited_decode_pbattribute(Bytes) ->
    delimited_decode(pbattribute, Bytes).

delimited_decode_pbcdkreward(Bytes) ->
    delimited_decode(pbcdkreward, Bytes).

delimited_decode_pbchoujiang(Bytes) ->
    delimited_decode(pbchoujiang, Bytes).

delimited_decode_pbchoujianggoods(Bytes) ->
    delimited_decode(pbchoujianggoods, Bytes).

delimited_decode_pbchoujianginfo(Bytes) ->
    delimited_decode(pbchoujianginfo, Bytes).

delimited_decode_pbchoujiangresult(Bytes) ->
    delimited_decode(pbchoujiangresult, Bytes).

delimited_decode_pbcombatreward(Bytes) ->
    delimited_decode(pbcombatreward, Bytes).

delimited_decode_pbequipaddstar(Bytes) ->
    delimited_decode(pbequipaddstar, Bytes).

delimited_decode_pbequipmove(Bytes) ->
    delimited_decode(pbequipmove, Bytes).

delimited_decode_pbequipstrengthen(Bytes) ->
    delimited_decode(pbequipstrengthen, Bytes).

delimited_decode_pbfriend(Bytes) ->
    delimited_decode(pbfriend, Bytes).

delimited_decode_pbgeneralstorebuy(Bytes) ->
    delimited_decode(pbgeneralstorebuy, Bytes).

delimited_decode_pbgeneralstoreinfo(Bytes) ->
    delimited_decode(pbgeneralstoreinfo, Bytes).

delimited_decode_pbgoods(Bytes) ->
    delimited_decode(pbgoods, Bytes).

delimited_decode_pbgoodschanged(Bytes) ->
    delimited_decode(pbgoodschanged, Bytes).

delimited_decode_pbgoodsinfo(Bytes) ->
    delimited_decode(pbgoodsinfo, Bytes).

delimited_decode_pbgoodslist(Bytes) ->
    delimited_decode(pbgoodslist, Bytes).

delimited_decode_pbid32(Bytes) ->
    delimited_decode(pbid32, Bytes).

delimited_decode_pbid32r(Bytes) ->
    delimited_decode(pbid32r, Bytes).

delimited_decode_pbid64(Bytes) ->
    delimited_decode(pbid64, Bytes).

delimited_decode_pbid64r(Bytes) ->
    delimited_decode(pbid64r, Bytes).

delimited_decode_pbidstring(Bytes) ->
    delimited_decode(pbidstring, Bytes).

delimited_decode_pbinlaidjewel(Bytes) ->
    delimited_decode(pbinlaidjewel, Bytes).

delimited_decode_pbordinarybuy(Bytes) ->
    delimited_decode(pbordinarybuy, Bytes).

delimited_decode_pbresult(Bytes) ->
    delimited_decode(pbresult, Bytes).

delimited_decode_pbreward(Bytes) ->
    delimited_decode(pbreward, Bytes).

delimited_decode_pbrewarditem(Bytes) ->
    delimited_decode(pbrewarditem, Bytes).

delimited_decode_pbrewardlist(Bytes) ->
    delimited_decode(pbrewardlist, Bytes).

delimited_decode_pbsellinglist(Bytes) ->
    delimited_decode(pbsellinglist, Bytes).

delimited_decode_pbsellingshop(Bytes) ->
    delimited_decode(pbsellingshop, Bytes).

delimited_decode_pbshopbuy(Bytes) ->
    delimited_decode(pbshopbuy, Bytes).

delimited_decode_pbshopitem(Bytes) ->
    delimited_decode(pbshopitem, Bytes).

delimited_decode_pbshopmsg(Bytes) ->
    delimited_decode(pbshopmsg, Bytes).

delimited_decode_pbskill(Bytes) ->
    delimited_decode(pbskill, Bytes).

delimited_decode_pbskillid(Bytes) ->
    delimited_decode(pbskillid, Bytes).

delimited_decode_pbskillidlist(Bytes) ->
    delimited_decode(pbskillidlist, Bytes).

delimited_decode_pbsmriti(Bytes) ->
    delimited_decode(pbsmriti, Bytes).

delimited_decode_pbsteriousshop(Bytes) ->
    delimited_decode(pbsteriousshop, Bytes).

delimited_decode_pbstoreproduct(Bytes) ->
    delimited_decode(pbstoreproduct, Bytes).

delimited_decode_pbstoreproductlist(Bytes) ->
    delimited_decode(pbstoreproductlist, Bytes).

delimited_decode_pbupgradeskillcard(Bytes) ->
    delimited_decode(pbupgradeskillcard, Bytes).

delimited_decode(Type, Bytes) when is_binary(Bytes) ->
    delimited_decode(Type, Bytes, []).

delimited_decode(_Type, <<>>, Acc) ->
    {lists:reverse(Acc), <<>>};
delimited_decode(Type, Bytes, Acc) ->
    try protobuffs:decode_varint(Bytes) of
      {Size, Rest} when size(Rest) < Size ->
	  {lists:reverse(Acc), Bytes};
      {Size, Rest} ->
	  <<MessageBytes:Size/binary, Rest2/binary>> = Rest,
	  Message = decode(Type, MessageBytes),
	  delimited_decode(Type, Rest2, [Message | Acc])
    catch
      _What:_Why -> {lists:reverse(Acc), Bytes}
    end.

decode(enummsg_values, 1) -> value1;
decode(pbactivityshop, Bytes) when is_binary(Bytes) ->
    Types = [{3, shop_list, pbactivityshopmsg,
	      [is_record, repeated]},
	     {2, activity_id, int32, []}, {1, timestamp, int32, []}],
    Defaults = [{3, shop_list, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbactivityshop, Decoded);
decode(pbactivityshopmsg, Bytes)
    when is_binary(Bytes) ->
    Types = [{3, player_remain_num, int32, []},
	     {2, activity_remain_num, int32, []},
	     {1, id, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbactivityshopmsg, Decoded);
decode(pbattribute, Bytes) when is_binary(Bytes) ->
    Types = [{18, def_effect, int32, []},
	     {17, attack_effect, int32, []},
	     {16, move_speed, int32, []},
	     {15, attack_speed, int32, []},
	     {14, anti_stiff, int32, []}, {13, stiff, int32, []},
	     {12, anti_crit, int32, []}, {11, crit, int32, []},
	     {10, dodge, int32, []}, {9, hit, int32, []},
	     {8, def, int32, []}, {7, attack, int32, []},
	     {6, mana_rec, int32, []}, {5, hp_rec, int32, []},
	     {4, mana_cur, int32, []}, {3, mana_lim, int32, []},
	     {2, hp_cur, int32, []}, {1, hp_lim, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbattribute, Decoded);
decode(pbcdkreward, Bytes) when is_binary(Bytes) ->
    Types = [{2, cdk, string, []}, {1, type, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbcdkreward, Decoded);
decode(pbchoujiang, Bytes) when is_binary(Bytes) ->
    Types = [{3, is_free, int32, []},
	     {2, buy_num, int32, []}, {1, money_type, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbchoujiang, Decoded);
decode(pbchoujianggoods, Bytes) when is_binary(Bytes) ->
    Types = [{2, num, int32, []}, {1, goods_id, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbchoujianggoods, Decoded);
decode(pbchoujianginfo, Bytes) when is_binary(Bytes) ->
    Types = [{3, coin_free_num, int32, []},
	     {2, gold_timestamp, int32, []},
	     {1, coin_timestamp, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbchoujianginfo, Decoded);
decode(pbchoujiangresult, Bytes)
    when is_binary(Bytes) ->
    Types = [{1, result_list, pbgoodsinfo,
	      [is_record, repeated]}],
    Defaults = [{1, result_list, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbchoujiangresult, Decoded);
decode(pbcombatreward, Bytes) when is_binary(Bytes) ->
    Types = [{8, partners, int64, [repeated]},
	     {7, point, int32, []}, {6, evaluate, int32, []},
	     {5, seal, int32, []}, {4, unique_id, int64, []},
	     {3, dungeon_reward_list, pbrewarditem,
	      [is_record, repeated]},
	     {2, mon_drop_list, pbrewarditem, [is_record, repeated]},
	     {1, exp, int32, []}],
    Defaults = [{2, mon_drop_list, []},
		{3, dungeon_reward_list, []}, {8, partners, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbcombatreward, Decoded);
decode(pbequipaddstar, Bytes) when is_binary(Bytes) ->
    Types = [{2, num, int32, []}, {1, id, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbequipaddstar, Decoded);
decode(pbequipmove, Bytes) when is_binary(Bytes) ->
    Types = [{2, pos, int32, []}, {1, id, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbequipmove, Decoded);
decode(pbequipstrengthen, Bytes)
    when is_binary(Bytes) ->
    Types = [{2, num, int32, []}, {1, id, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbequipstrengthen, Decoded);
decode(pbfriend, Bytes) when is_binary(Bytes) ->
    Types = [{18, type, int32, []},
	     {17, attri, pbattribute, [is_record]},
	     {16, put_on_skill, int32, [repeated]},
	     {15, league_title, int32, []},
	     {14, league_name, string, []}, {13, rela, int32, []},
	     {12, battle_ability, int32, []},
	     {11, talent, pbskill, [is_record, repeated]},
	     {10, skill_list, pbskill, [is_record, repeated]},
	     {9, mugen_score, int32, []},
	     {8, mugen_pass_times, int32, []},
	     {7, fashion, pbgoods, [is_record, repeated]},
	     {6, off_time, int32, []},
	     {5, core, pbgoods, [is_record, repeated]},
	     {4, career, int32, []}, {3, level, int32, []},
	     {2, nickname, string, []}, {1, id, int64, []}],
    Defaults = [{5, core, []}, {7, fashion, []},
		{10, skill_list, []}, {11, talent, []},
		{16, put_on_skill, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbfriend, Decoded);
decode(pbgeneralstorebuy, Bytes)
    when is_binary(Bytes) ->
    Types = [{2, pos, int32, []},
	     {1, store_type, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbgeneralstorebuy, Decoded);
decode(pbgeneralstoreinfo, Bytes)
    when is_binary(Bytes) ->
    Types = [{2, shop_info, pbsteriousshop, [is_record]},
	     {1, store_type, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbgeneralstoreinfo, Decoded);
decode(pbgoods, Bytes) when is_binary(Bytes) ->
    Types = [{52, skill_card_status, int32, []},
	     {51, timestamp, int32, []},
	     {50, value, pbgoodsinfo, [is_record, repeated]},
	     {49, card_pos_3, int32, []},
	     {48, card_pos_2, int32, []},
	     {47, card_pos_1, int32, []},
	     {46, skill_card_exp, int32, []},
	     {45, mana_rec_ext, int32, []},
	     {44, mana_lim_ext, int32, []},
	     {43, mana_rec, int32, []}, {42, mana_lim, int32, []},
	     {41, anti_crit_ext, int32, []},
	     {40, crit_ext, int32, []}, {39, def_ext, int32, []},
	     {38, dodge_ext, int32, []}, {37, hit_ext, int32, []},
	     {36, attack_ext, int32, []},
	     {35, hp_lim_ext, int32, []}, {34, sum, int32, []},
	     {33, jewels, int32, [repeated]},
	     {32, quality, int32, []}, {31, power, int32, []},
	     {30, anti_dark, int32, []}, {29, anti_honly, int32, []},
	     {28, anti_fire, int32, []}, {27, anti_ice, int32, []},
	     {26, dark, int32, []}, {25, honly, int32, []},
	     {24, fire, int32, []}, {23, ice, int32, []},
	     {22, move_speed, int32, []},
	     {21, attack_speed, int32, []},
	     {20, anti_stiff, int32, []}, {19, cost, int32, []},
	     {18, stiff, int32, []}, {17, anti_crit, int32, []},
	     {16, crit, int32, []}, {15, dodge, int32, []},
	     {14, hit, int32, []}, {13, def, int32, []},
	     {12, attack, int32, []}, {11, bind, int32, []},
	     {10, hp_lim, int32, []}, {9, star_lv, int32, []},
	     {8, str_lv, int32, []}, {7, position, int32, []},
	     {6, container, int32, []}, {5, player_id, int64, []},
	     {4, sub_type, int32, []}, {3, type, int32, []},
	     {2, goods_id, int32, []}, {1, id, int32, []}],
    Defaults = [{33, jewels, []}, {50, value, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbgoods, Decoded);
decode(pbgoodschanged, Bytes) when is_binary(Bytes) ->
    Types = [{4, update_timestamp, int32, []},
	     {3, updated_list, pbgoodslist, [is_record]},
	     {2, deleted_list, pbgoodslist, [is_record]},
	     {1, added_list, pbgoodslist, [is_record]}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbgoodschanged, Decoded);
decode(pbgoodsinfo, Bytes) when is_binary(Bytes) ->
    Types = [{2, num, int32, []}, {1, id, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbgoodsinfo, Decoded);
decode(pbgoodslist, Bytes) when is_binary(Bytes) ->
    Types = [{2, update_timestamp, int32, []},
	     {1, goods_list, pbgoods, [is_record, repeated]}],
    Defaults = [{1, goods_list, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbgoodslist, Decoded);
decode(pbid32, Bytes) when is_binary(Bytes) ->
    Types = [{1, id, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbid32, Decoded);
decode(pbid32r, Bytes) when is_binary(Bytes) ->
    Types = [{1, id, int32, [repeated]}],
    Defaults = [{1, id, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbid32r, Decoded);
decode(pbid64, Bytes) when is_binary(Bytes) ->
    Types = [{1, id, int64, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbid64, Decoded);
decode(pbid64r, Bytes) when is_binary(Bytes) ->
    Types = [{1, ids, int64, [repeated]}],
    Defaults = [{1, ids, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbid64r, Decoded);
decode(pbidstring, Bytes) when is_binary(Bytes) ->
    Types = [{1, id, string, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbidstring, Decoded);
decode(pbinlaidjewel, Bytes) when is_binary(Bytes) ->
    Types = [{4, pos, int32, []}, {3, num, int32, []},
	     {2, tid, int32, []}, {1, id, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbinlaidjewel, Decoded);
decode(pbordinarybuy, Bytes) when is_binary(Bytes) ->
    Types = [{2, num, int32, []}, {1, base_id, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbordinarybuy, Decoded);
decode(pbresult, Bytes) when is_binary(Bytes) ->
    Types = [{1, result, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbresult, Decoded);
decode(pbreward, Bytes) when is_binary(Bytes) ->
    Types = [{6, day, int32, []}, {5, type, int32, []},
	     {4, bind, int32, []}, {3, num, int32, []},
	     {2, goods_id, int32, []}, {1, id, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbreward, Decoded);
decode(pbrewarditem, Bytes) when is_binary(Bytes) ->
    Types = [{4, goods_id, int32, []}, {3, num, int32, []},
	     {1, id, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbrewarditem, Decoded);
decode(pbrewardlist, Bytes) when is_binary(Bytes) ->
    Types = [{5, reward_list, pbreward,
	      [is_record, repeated]},
	     {3, timestamp, int32, []}, {2, type, int32, []},
	     {1, id, int32, []}],
    Defaults = [{5, reward_list, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbrewardlist, Decoded);
decode(pbsellinglist, Bytes) when is_binary(Bytes) ->
    Types = [{1, shop_list, pbsellingshop,
	      [is_record, repeated]}],
    Defaults = [{1, shop_list, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbsellinglist, Decoded);
decode(pbsellingshop, Bytes) when is_binary(Bytes) ->
    Types = [{3, buy_times, int32, []}, {2, num, int32, []},
	     {1, base_id, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbsellingshop, Decoded);
decode(pbshopbuy, Bytes) when is_binary(Bytes) ->
    Types = [{1, pos, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbshopbuy, Decoded);
decode(pbshopitem, Bytes) when is_binary(Bytes) ->
    Types = [{2, num, int32, []}, {1, id, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbshopitem, Decoded);
decode(pbshopmsg, Bytes) when is_binary(Bytes) ->
    Types = [{3, pos, int32, []}, {2, is_buy, int32, []},
	     {1, base_id, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbshopmsg, Decoded);
decode(pbskill, Bytes) when is_binary(Bytes) ->
    Types = [{7, type, int32, []},
	     {6, sigil, int32, [repeated]}, {5, str_lv, int32, []},
	     {4, lv, int32, []}, {3, player_id, int32, []},
	     {2, skill_id, int32, []}, {1, id, int32, []}],
    Defaults = [{6, sigil, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbskill, Decoded);
decode(pbskillid, Bytes) when is_binary(Bytes) ->
    Types = [{1, id, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbskillid, Decoded);
decode(pbskillidlist, Bytes) when is_binary(Bytes) ->
    Types = [{1, list, pbskillid, [is_record, repeated]}],
    Defaults = [{1, list, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbskillidlist, Decoded);
decode(pbsmriti, Bytes) when is_binary(Bytes) ->
    Types = [{2, tid, int32, []}, {1, id, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbsmriti, Decoded);
decode(pbsteriousshop, Bytes) when is_binary(Bytes) ->
    Types = [{3, shop_last_refresh_time, int32, []},
	     {2, shop_refresh_num, int32, []},
	     {1, shop_list, pbshopmsg, [is_record, repeated]}],
    Defaults = [{1, shop_list, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbsteriousshop, Decoded);
decode(pbstoreproduct, Bytes) when is_binary(Bytes) ->
    Types = [{6, icon, int32, []}, {5, money, int32, []},
	     {4, reward_gold, int32, []}, {3, gold, int32, []},
	     {2, product_id, string, []}, {1, id, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbstoreproduct, Decoded);
decode(pbstoreproductlist, Bytes)
    when is_binary(Bytes) ->
    Types = [{1, product_list, pbstoreproduct,
	      [is_record, repeated]}],
    Defaults = [{1, product_list, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbstoreproductlist, Decoded);
decode(pbupgradeskillcard, Bytes)
    when is_binary(Bytes) ->
    Types = [{2, consume_list, pbgoodsinfo,
	      [is_record, repeated]},
	     {1, id, int32, []}],
    Defaults = [{2, consume_list, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbupgradeskillcard, Decoded).

decode(<<>>, Types, Acc) ->
    reverse_repeated_fields(Acc, Types);
decode(Bytes, Types, Acc) ->
    {ok, FNum} = protobuffs:next_field_num(Bytes),
    case lists:keyfind(FNum, 1, Types) of
      {FNum, Name, Type, Opts} ->
	  {Value1, Rest1} = case lists:member(is_record, Opts) of
			      true ->
				  {{FNum, V}, R} = protobuffs:decode(Bytes,
								     bytes),
				  RecVal = decode(Type, V),
				  {RecVal, R};
			      false ->
				  case lists:member(repeated_packed, Opts) of
				    true ->
					{{FNum, V}, R} =
					    protobuffs:decode_packed(Bytes,
								     Type),
					{V, R};
				    false ->
					{{FNum, V}, R} =
					    protobuffs:decode(Bytes, Type),
					{unpack_value(V, Type), R}
				  end
			    end,
	  case lists:member(repeated, Opts) of
	    true ->
		case lists:keytake(FNum, 1, Acc) of
		  {value, {FNum, Name, List}, Acc1} ->
		      decode(Rest1, Types,
			     [{FNum, Name, [int_to_enum(Type, Value1) | List]}
			      | Acc1]);
		  false ->
		      decode(Rest1, Types,
			     [{FNum, Name, [int_to_enum(Type, Value1)]} | Acc])
		end;
	    false ->
		decode(Rest1, Types,
		       [{FNum, Name, int_to_enum(Type, Value1)} | Acc])
	  end;
      false ->
	  case lists:keyfind('$extensions', 2, Acc) of
	    {_, _, Dict} ->
		{{FNum, _V}, R} = protobuffs:decode(Bytes, bytes),
		Diff = size(Bytes) - size(R),
		<<V:Diff/binary, _/binary>> = Bytes,
		NewDict = dict:store(FNum, V, Dict),
		NewAcc = lists:keyreplace('$extensions', 2, Acc,
					  {false, '$extensions', NewDict}),
		decode(R, Types, NewAcc);
	    _ ->
		{ok, Skipped} = protobuffs:skip_next_field(Bytes),
		decode(Skipped, Types, Acc)
	  end
    end.

reverse_repeated_fields(FieldList, Types) ->
    [begin
       case lists:keyfind(FNum, 1, Types) of
	 {FNum, Name, _Type, Opts} ->
	     case lists:member(repeated, Opts) of
	       true -> {FNum, Name, lists:reverse(Value)};
	       _ -> Field
	     end;
	 _ -> Field
       end
     end
     || {FNum, Name, Value} = Field <- FieldList].

unpack_value(Binary, string) when is_binary(Binary) ->
    binary_to_list(Binary);
unpack_value(Value, _) -> Value.

to_record(pbactivityshop, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbactivityshop),
						   Record, Name, Val)
			  end,
			  #pbactivityshop{}, DecodedTuples),
    Record1;
to_record(pbactivityshopmsg, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbactivityshopmsg),
						   Record, Name, Val)
			  end,
			  #pbactivityshopmsg{}, DecodedTuples),
    Record1;
to_record(pbattribute, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbattribute),
						   Record, Name, Val)
			  end,
			  #pbattribute{}, DecodedTuples),
    Record1;
to_record(pbcdkreward, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbcdkreward),
						   Record, Name, Val)
			  end,
			  #pbcdkreward{}, DecodedTuples),
    Record1;
to_record(pbchoujiang, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbchoujiang),
						   Record, Name, Val)
			  end,
			  #pbchoujiang{}, DecodedTuples),
    Record1;
to_record(pbchoujianggoods, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbchoujianggoods),
						   Record, Name, Val)
			  end,
			  #pbchoujianggoods{}, DecodedTuples),
    Record1;
to_record(pbchoujianginfo, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbchoujianginfo),
						   Record, Name, Val)
			  end,
			  #pbchoujianginfo{}, DecodedTuples),
    Record1;
to_record(pbchoujiangresult, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbchoujiangresult),
						   Record, Name, Val)
			  end,
			  #pbchoujiangresult{}, DecodedTuples),
    Record1;
to_record(pbcombatreward, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbcombatreward),
						   Record, Name, Val)
			  end,
			  #pbcombatreward{}, DecodedTuples),
    Record1;
to_record(pbequipaddstar, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbequipaddstar),
						   Record, Name, Val)
			  end,
			  #pbequipaddstar{}, DecodedTuples),
    Record1;
to_record(pbequipmove, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbequipmove),
						   Record, Name, Val)
			  end,
			  #pbequipmove{}, DecodedTuples),
    Record1;
to_record(pbequipstrengthen, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbequipstrengthen),
						   Record, Name, Val)
			  end,
			  #pbequipstrengthen{}, DecodedTuples),
    Record1;
to_record(pbfriend, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbfriend),
						   Record, Name, Val)
			  end,
			  #pbfriend{}, DecodedTuples),
    Record1;
to_record(pbgeneralstorebuy, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbgeneralstorebuy),
						   Record, Name, Val)
			  end,
			  #pbgeneralstorebuy{}, DecodedTuples),
    Record1;
to_record(pbgeneralstoreinfo, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbgeneralstoreinfo),
						   Record, Name, Val)
			  end,
			  #pbgeneralstoreinfo{}, DecodedTuples),
    Record1;
to_record(pbgoods, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields, pbgoods),
						   Record, Name, Val)
			  end,
			  #pbgoods{}, DecodedTuples),
    Record1;
to_record(pbgoodschanged, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbgoodschanged),
						   Record, Name, Val)
			  end,
			  #pbgoodschanged{}, DecodedTuples),
    Record1;
to_record(pbgoodsinfo, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbgoodsinfo),
						   Record, Name, Val)
			  end,
			  #pbgoodsinfo{}, DecodedTuples),
    Record1;
to_record(pbgoodslist, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbgoodslist),
						   Record, Name, Val)
			  end,
			  #pbgoodslist{}, DecodedTuples),
    Record1;
to_record(pbid32, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields, pbid32),
						   Record, Name, Val)
			  end,
			  #pbid32{}, DecodedTuples),
    Record1;
to_record(pbid32r, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields, pbid32r),
						   Record, Name, Val)
			  end,
			  #pbid32r{}, DecodedTuples),
    Record1;
to_record(pbid64, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields, pbid64),
						   Record, Name, Val)
			  end,
			  #pbid64{}, DecodedTuples),
    Record1;
to_record(pbid64r, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields, pbid64r),
						   Record, Name, Val)
			  end,
			  #pbid64r{}, DecodedTuples),
    Record1;
to_record(pbidstring, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbidstring),
						   Record, Name, Val)
			  end,
			  #pbidstring{}, DecodedTuples),
    Record1;
to_record(pbinlaidjewel, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbinlaidjewel),
						   Record, Name, Val)
			  end,
			  #pbinlaidjewel{}, DecodedTuples),
    Record1;
to_record(pbordinarybuy, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbordinarybuy),
						   Record, Name, Val)
			  end,
			  #pbordinarybuy{}, DecodedTuples),
    Record1;
to_record(pbresult, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbresult),
						   Record, Name, Val)
			  end,
			  #pbresult{}, DecodedTuples),
    Record1;
to_record(pbreward, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbreward),
						   Record, Name, Val)
			  end,
			  #pbreward{}, DecodedTuples),
    Record1;
to_record(pbrewarditem, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbrewarditem),
						   Record, Name, Val)
			  end,
			  #pbrewarditem{}, DecodedTuples),
    Record1;
to_record(pbrewardlist, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbrewardlist),
						   Record, Name, Val)
			  end,
			  #pbrewardlist{}, DecodedTuples),
    Record1;
to_record(pbsellinglist, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbsellinglist),
						   Record, Name, Val)
			  end,
			  #pbsellinglist{}, DecodedTuples),
    Record1;
to_record(pbsellingshop, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbsellingshop),
						   Record, Name, Val)
			  end,
			  #pbsellingshop{}, DecodedTuples),
    Record1;
to_record(pbshopbuy, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbshopbuy),
						   Record, Name, Val)
			  end,
			  #pbshopbuy{}, DecodedTuples),
    Record1;
to_record(pbshopitem, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbshopitem),
						   Record, Name, Val)
			  end,
			  #pbshopitem{}, DecodedTuples),
    Record1;
to_record(pbshopmsg, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbshopmsg),
						   Record, Name, Val)
			  end,
			  #pbshopmsg{}, DecodedTuples),
    Record1;
to_record(pbskill, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields, pbskill),
						   Record, Name, Val)
			  end,
			  #pbskill{}, DecodedTuples),
    Record1;
to_record(pbskillid, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbskillid),
						   Record, Name, Val)
			  end,
			  #pbskillid{}, DecodedTuples),
    Record1;
to_record(pbskillidlist, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbskillidlist),
						   Record, Name, Val)
			  end,
			  #pbskillidlist{}, DecodedTuples),
    Record1;
to_record(pbsmriti, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbsmriti),
						   Record, Name, Val)
			  end,
			  #pbsmriti{}, DecodedTuples),
    Record1;
to_record(pbsteriousshop, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbsteriousshop),
						   Record, Name, Val)
			  end,
			  #pbsteriousshop{}, DecodedTuples),
    Record1;
to_record(pbstoreproduct, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbstoreproduct),
						   Record, Name, Val)
			  end,
			  #pbstoreproduct{}, DecodedTuples),
    Record1;
to_record(pbstoreproductlist, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbstoreproductlist),
						   Record, Name, Val)
			  end,
			  #pbstoreproductlist{}, DecodedTuples),
    Record1;
to_record(pbupgradeskillcard, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbupgradeskillcard),
						   Record, Name, Val)
			  end,
			  #pbupgradeskillcard{}, DecodedTuples),
    Record1.

decode_extensions(Record) -> Record.

decode_extensions(_Types, [], Acc) ->
    dict:from_list(Acc);
decode_extensions(Types, [{Fnum, Bytes} | Tail], Acc) ->
    NewAcc = case lists:keyfind(Fnum, 1, Types) of
	       {Fnum, Name, Type, Opts} ->
		   {Value1, Rest1} = case lists:member(is_record, Opts) of
				       true ->
					   {{FNum, V}, R} =
					       protobuffs:decode(Bytes, bytes),
					   RecVal = decode(Type, V),
					   {RecVal, R};
				       false ->
					   case lists:member(repeated_packed,
							     Opts)
					       of
					     true ->
						 {{FNum, V}, R} =
						     protobuffs:decode_packed(Bytes,
									      Type),
						 {V, R};
					     false ->
						 {{FNum, V}, R} =
						     protobuffs:decode(Bytes,
								       Type),
						 {unpack_value(V, Type), R}
					   end
				     end,
		   case lists:member(repeated, Opts) of
		     true ->
			 case lists:keytake(FNum, 1, Acc) of
			   {value, {FNum, Name, List}, Acc1} ->
			       decode(Rest1, Types,
				      [{FNum, Name,
					lists:reverse([int_to_enum(Type, Value1)
						       | lists:reverse(List)])}
				       | Acc1]);
			   false ->
			       decode(Rest1, Types,
				      [{FNum, Name, [int_to_enum(Type, Value1)]}
				       | Acc])
			 end;
		     false ->
			 [{Fnum,
			   {optional, int_to_enum(Type, Value1), Type, Opts}}
			  | Acc]
		   end;
	       false -> [{Fnum, Bytes} | Acc]
	     end,
    decode_extensions(Types, Tail, NewAcc).

set_record_field(Fields, Record, '$extensions',
		 Value) ->
    Decodable = [],
    NewValue = decode_extensions(element(1, Record),
				 Decodable, dict:to_list(Value)),
    Index = list_index('$extensions', Fields),
    erlang:setelement(Index + 1, Record, NewValue);
set_record_field(Fields, Record, Field, Value) ->
    Index = list_index(Field, Fields),
    erlang:setelement(Index + 1, Record, Value).

list_index(Target, List) -> list_index(Target, List, 1).

list_index(Target, [Target | _], Index) -> Index;
list_index(Target, [_ | Tail], Index) ->
    list_index(Target, Tail, Index + 1);
list_index(_, [], _) -> -1.

extension_size(_) -> 0.

has_extension(_Record, _FieldName) -> false.

get_extension(_Record, _FieldName) -> undefined.

set_extension(Record, _, _) -> {error, Record}.

