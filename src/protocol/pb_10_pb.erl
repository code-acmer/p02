-file("src/pb_10_pb.erl", 1).

-module(pb_10_pb).

-export([encode_pbuserresult/1, decode_pbuserresult/1,
	 delimited_decode_pbuserresult/1,
	 encode_pbuserlogininfo/1, decode_pbuserlogininfo/1,
	 delimited_decode_pbuserlogininfo/1,
	 encode_pbuserloginfashioninfo/1,
	 decode_pbuserloginfashioninfo/1,
	 delimited_decode_pbuserloginfashioninfo/1,
	 encode_pbskill/1, decode_pbskill/1,
	 delimited_decode_pbskill/1, encode_pbserverstatus/1,
	 decode_pbserverstatus/1,
	 delimited_decode_pbserverstatus/1,
	 encode_pbrewarditem/1, decode_pbrewarditem/1,
	 delimited_decode_pbrewarditem/1, encode_pbresult/1,
	 decode_pbresult/1, delimited_decode_pbresult/1,
	 encode_pbrc4/1, decode_pbrc4/1,
	 delimited_decode_pbrc4/1, encode_pbidstring/1,
	 decode_pbidstring/1, delimited_decode_pbidstring/1,
	 encode_pbid64r/1, decode_pbid64r/1,
	 delimited_decode_pbid64r/1, encode_pbid64/1,
	 decode_pbid64/1, delimited_decode_pbid64/1,
	 encode_pbid32r/1, decode_pbid32r/1,
	 delimited_decode_pbid32r/1, encode_pbid32/1,
	 decode_pbid32/1, delimited_decode_pbid32/1,
	 encode_pbgoodsinfo/1, decode_pbgoodsinfo/1,
	 delimited_decode_pbgoodsinfo/1, encode_pbgoods/1,
	 decode_pbgoods/1, delimited_decode_pbgoods/1,
	 encode_pbfriend/1, decode_pbfriend/1,
	 delimited_decode_pbfriend/1, encode_pbcreatearole/1,
	 decode_pbcreatearole/1,
	 delimited_decode_pbcreatearole/1,
	 encode_pbcombatreward/1, decode_pbcombatreward/1,
	 delimited_decode_pbcombatreward/1, encode_pbattribute/1,
	 decode_pbattribute/1, delimited_decode_pbattribute/1,
	 encode_pbaccountlogin/1, decode_pbaccountlogin/1,
	 delimited_decode_pbaccountlogin/1, encode_pbaccount/1,
	 decode_pbaccount/1, delimited_decode_pbaccount/1]).

-export([has_extension/2, extension_size/1,
	 get_extension/2, set_extension/3]).

-export([decode_extensions/1]).

-export([encode/1, decode/2, delimited_decode/2]).

-export([int_to_enum/2, enum_to_int/2]).

-record(pbuserresult, {result, user_id}).

-record(pbuserlogininfo,
	{user_id, nickname, level, camp, career, sex, server_id,
	 status, acc_id, acc_name, list}).

-record(pbuserloginfashioninfo,
	{fashion_base_id, sub_type}).

-record(pbskill,
	{id, skill_id, player_id, lv, str_lv, sigil, type}).

-record(pbserverstatus, {index, ip, port, state, num}).

-record(pbrewarditem, {id, num, goods_id}).

-record(pbresult, {result}).

-record(pbrc4, {p, g, pub}).

-record(pbidstring, {id}).

-record(pbid64r, {ids}).

-record(pbid64, {id}).

-record(pbid32r, {id}).

-record(pbid32, {id}).

-record(pbgoodsinfo, {id, num}).

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

-record(pbfriend,
	{id, nickname, level, career, core, off_time, fashion,
	 mugen_pass_times, mugen_score, skill_list, talent,
	 battle_ability, rela, league_name, league_title,
	 put_on_skill, attri, type}).

-record(pbcreatearole, {server_id, acc_id}).

-record(pbcombatreward,
	{exp, mon_drop_list, dungeon_reward_list, unique_id,
	 seal, evaluate, point, partners}).

-record(pbattribute,
	{hp_lim, hp_cur, mana_lim, mana_cur, hp_rec, mana_rec,
	 attack, def, hit, dodge, crit, anti_crit, stiff,
	 anti_stiff, attack_speed, move_speed, attack_effect,
	 def_effect}).

-record(pbaccountlogin,
	{result, total_online, user_info, acc_id, session}).

-record(pbaccount,
	{acc_id, acc_name, timestamp, server_id, login_ticket,
	 suid, platform, device_id}).

encode([]) -> [];
encode(Records) when is_list(Records) ->
    delimited_encode(Records);
encode(Record) -> encode(element(1, Record), Record).

encode_pbuserresult(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbuserresult(Record)
    when is_record(Record, pbuserresult) ->
    encode(pbuserresult, Record).

encode_pbuserlogininfo(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbuserlogininfo(Record)
    when is_record(Record, pbuserlogininfo) ->
    encode(pbuserlogininfo, Record).

encode_pbuserloginfashioninfo(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_pbuserloginfashioninfo(Record)
    when is_record(Record, pbuserloginfashioninfo) ->
    encode(pbuserloginfashioninfo, Record).

encode_pbskill(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbskill(Record)
    when is_record(Record, pbskill) ->
    encode(pbskill, Record).

encode_pbserverstatus(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbserverstatus(Record)
    when is_record(Record, pbserverstatus) ->
    encode(pbserverstatus, Record).

encode_pbrewarditem(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbrewarditem(Record)
    when is_record(Record, pbrewarditem) ->
    encode(pbrewarditem, Record).

encode_pbresult(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbresult(Record)
    when is_record(Record, pbresult) ->
    encode(pbresult, Record).

encode_pbrc4(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbrc4(Record) when is_record(Record, pbrc4) ->
    encode(pbrc4, Record).

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

encode_pbgoodsinfo(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbgoodsinfo(Record)
    when is_record(Record, pbgoodsinfo) ->
    encode(pbgoodsinfo, Record).

encode_pbgoods(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbgoods(Record)
    when is_record(Record, pbgoods) ->
    encode(pbgoods, Record).

encode_pbfriend(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbfriend(Record)
    when is_record(Record, pbfriend) ->
    encode(pbfriend, Record).

encode_pbcreatearole(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbcreatearole(Record)
    when is_record(Record, pbcreatearole) ->
    encode(pbcreatearole, Record).

encode_pbcombatreward(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbcombatreward(Record)
    when is_record(Record, pbcombatreward) ->
    encode(pbcombatreward, Record).

encode_pbattribute(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbattribute(Record)
    when is_record(Record, pbattribute) ->
    encode(pbattribute, Record).

encode_pbaccountlogin(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbaccountlogin(Record)
    when is_record(Record, pbaccountlogin) ->
    encode(pbaccountlogin, Record).

encode_pbaccount(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbaccount(Record)
    when is_record(Record, pbaccount) ->
    encode(pbaccount, Record).

encode(pbaccount, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbaccount, Record) ->
    [iolist(pbaccount, Record) | encode_extensions(Record)];
encode(pbaccountlogin, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbaccountlogin, Record) ->
    [iolist(pbaccountlogin, Record)
     | encode_extensions(Record)];
encode(pbattribute, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbattribute, Record) ->
    [iolist(pbattribute, Record)
     | encode_extensions(Record)];
encode(pbcombatreward, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbcombatreward, Record) ->
    [iolist(pbcombatreward, Record)
     | encode_extensions(Record)];
encode(pbcreatearole, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbcreatearole, Record) ->
    [iolist(pbcreatearole, Record)
     | encode_extensions(Record)];
encode(pbfriend, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbfriend, Record) ->
    [iolist(pbfriend, Record) | encode_extensions(Record)];
encode(pbgoods, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbgoods, Record) ->
    [iolist(pbgoods, Record) | encode_extensions(Record)];
encode(pbgoodsinfo, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbgoodsinfo, Record) ->
    [iolist(pbgoodsinfo, Record)
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
encode(pbrc4, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbrc4, Record) ->
    [iolist(pbrc4, Record) | encode_extensions(Record)];
encode(pbresult, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbresult, Record) ->
    [iolist(pbresult, Record) | encode_extensions(Record)];
encode(pbrewarditem, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbrewarditem, Record) ->
    [iolist(pbrewarditem, Record)
     | encode_extensions(Record)];
encode(pbserverstatus, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbserverstatus, Record) ->
    [iolist(pbserverstatus, Record)
     | encode_extensions(Record)];
encode(pbskill, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbskill, Record) ->
    [iolist(pbskill, Record) | encode_extensions(Record)];
encode(pbuserloginfashioninfo, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbuserloginfashioninfo, Record) ->
    [iolist(pbuserloginfashioninfo, Record)
     | encode_extensions(Record)];
encode(pbuserlogininfo, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbuserlogininfo, Record) ->
    [iolist(pbuserlogininfo, Record)
     | encode_extensions(Record)];
encode(pbuserresult, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbuserresult, Record) ->
    [iolist(pbuserresult, Record)
     | encode_extensions(Record)].

encode_extensions(_) -> [].

delimited_encode(Records) ->
    lists:map(fun (Record) ->
		      IoRec = encode(Record),
		      Size = iolist_size(IoRec),
		      [protobuffs:encode_varint(Size), IoRec]
	      end,
	      Records).

iolist(pbaccount, Record) ->
    [pack(1, optional,
	  with_default(Record#pbaccount.acc_id, none), int64, []),
     pack(2, optional,
	  with_default(Record#pbaccount.acc_name, none), string,
	  []),
     pack(3, optional,
	  with_default(Record#pbaccount.timestamp, none), int32,
	  []),
     pack(4, optional,
	  with_default(Record#pbaccount.server_id, none), int32,
	  []),
     pack(5, optional,
	  with_default(Record#pbaccount.login_ticket, none),
	  string, []),
     pack(6, optional,
	  with_default(Record#pbaccount.suid, none), string, []),
     pack(7, optional,
	  with_default(Record#pbaccount.platform, none), string,
	  []),
     pack(8, optional,
	  with_default(Record#pbaccount.device_id, none), string,
	  [])];
iolist(pbaccountlogin, Record) ->
    [pack(1, optional,
	  with_default(Record#pbaccountlogin.result, none), int32,
	  []),
     pack(2, optional,
	  with_default(Record#pbaccountlogin.total_online, none),
	  int32, []),
     pack(3, repeated,
	  with_default(Record#pbaccountlogin.user_info, none),
	  pbuserlogininfo, []),
     pack(4, optional,
	  with_default(Record#pbaccountlogin.acc_id, none),
	  string, []),
     pack(5, optional,
	  with_default(Record#pbaccountlogin.session, none),
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
iolist(pbcreatearole, Record) ->
    [pack(1, optional,
	  with_default(Record#pbcreatearole.server_id, none),
	  int32, []),
     pack(2, optional,
	  with_default(Record#pbcreatearole.acc_id, none), int64,
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
iolist(pbgoodsinfo, Record) ->
    [pack(1, optional,
	  with_default(Record#pbgoodsinfo.id, none), int32, []),
     pack(2, optional,
	  with_default(Record#pbgoodsinfo.num, none), int32, [])];
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
iolist(pbrc4, Record) ->
    [pack(1, optional, with_default(Record#pbrc4.p, none),
	  bytes, []),
     pack(2, optional, with_default(Record#pbrc4.g, none),
	  bytes, []),
     pack(3, optional, with_default(Record#pbrc4.pub, none),
	  bytes, [])];
iolist(pbresult, Record) ->
    [pack(1, optional,
	  with_default(Record#pbresult.result, none), int32, [])];
iolist(pbrewarditem, Record) ->
    [pack(1, optional,
	  with_default(Record#pbrewarditem.id, none), int32, []),
     pack(3, optional,
	  with_default(Record#pbrewarditem.num, none), int32, []),
     pack(4, optional,
	  with_default(Record#pbrewarditem.goods_id, none), int32,
	  [])];
iolist(pbserverstatus, Record) ->
    [pack(1, optional,
	  with_default(Record#pbserverstatus.index, none), int32,
	  []),
     pack(2, optional,
	  with_default(Record#pbserverstatus.ip, none), string,
	  []),
     pack(3, optional,
	  with_default(Record#pbserverstatus.port, none), int32,
	  []),
     pack(4, optional,
	  with_default(Record#pbserverstatus.state, none), int32,
	  []),
     pack(5, optional,
	  with_default(Record#pbserverstatus.num, none), int32,
	  [])];
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
iolist(pbuserloginfashioninfo, Record) ->
    [pack(1, optional,
	  with_default(Record#pbuserloginfashioninfo.fashion_base_id,
		       none),
	  int32, []),
     pack(2, optional,
	  with_default(Record#pbuserloginfashioninfo.sub_type,
		       none),
	  int32, [])];
iolist(pbuserlogininfo, Record) ->
    [pack(1, optional,
	  with_default(Record#pbuserlogininfo.user_id, none),
	  int64, []),
     pack(2, optional,
	  with_default(Record#pbuserlogininfo.nickname, none),
	  string, []),
     pack(3, optional,
	  with_default(Record#pbuserlogininfo.level, none), int32,
	  []),
     pack(4, optional,
	  with_default(Record#pbuserlogininfo.camp, none), int32,
	  []),
     pack(5, optional,
	  with_default(Record#pbuserlogininfo.career, none),
	  int32, []),
     pack(6, optional,
	  with_default(Record#pbuserlogininfo.sex, none), int32,
	  []),
     pack(7, optional,
	  with_default(Record#pbuserlogininfo.server_id, none),
	  int32, []),
     pack(8, optional,
	  with_default(Record#pbuserlogininfo.status, none),
	  int32, []),
     pack(9, optional,
	  with_default(Record#pbuserlogininfo.acc_id, none),
	  string, []),
     pack(10, optional,
	  with_default(Record#pbuserlogininfo.acc_name, none),
	  string, []),
     pack(11, repeated,
	  with_default(Record#pbuserlogininfo.list, none),
	  pbuserloginfashioninfo, [])];
iolist(pbuserresult, Record) ->
    [pack(1, optional,
	  with_default(Record#pbuserresult.result, none), int32,
	  []),
     pack(2, optional,
	  with_default(Record#pbuserresult.user_id, none), int64,
	  [])].

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

decode_pbuserresult(Bytes) when is_binary(Bytes) ->
    decode(pbuserresult, Bytes).

decode_pbuserlogininfo(Bytes) when is_binary(Bytes) ->
    decode(pbuserlogininfo, Bytes).

decode_pbuserloginfashioninfo(Bytes)
    when is_binary(Bytes) ->
    decode(pbuserloginfashioninfo, Bytes).

decode_pbskill(Bytes) when is_binary(Bytes) ->
    decode(pbskill, Bytes).

decode_pbserverstatus(Bytes) when is_binary(Bytes) ->
    decode(pbserverstatus, Bytes).

decode_pbrewarditem(Bytes) when is_binary(Bytes) ->
    decode(pbrewarditem, Bytes).

decode_pbresult(Bytes) when is_binary(Bytes) ->
    decode(pbresult, Bytes).

decode_pbrc4(Bytes) when is_binary(Bytes) ->
    decode(pbrc4, Bytes).

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

decode_pbgoodsinfo(Bytes) when is_binary(Bytes) ->
    decode(pbgoodsinfo, Bytes).

decode_pbgoods(Bytes) when is_binary(Bytes) ->
    decode(pbgoods, Bytes).

decode_pbfriend(Bytes) when is_binary(Bytes) ->
    decode(pbfriend, Bytes).

decode_pbcreatearole(Bytes) when is_binary(Bytes) ->
    decode(pbcreatearole, Bytes).

decode_pbcombatreward(Bytes) when is_binary(Bytes) ->
    decode(pbcombatreward, Bytes).

decode_pbattribute(Bytes) when is_binary(Bytes) ->
    decode(pbattribute, Bytes).

decode_pbaccountlogin(Bytes) when is_binary(Bytes) ->
    decode(pbaccountlogin, Bytes).

decode_pbaccount(Bytes) when is_binary(Bytes) ->
    decode(pbaccount, Bytes).

delimited_decode_pbaccount(Bytes) ->
    delimited_decode(pbaccount, Bytes).

delimited_decode_pbaccountlogin(Bytes) ->
    delimited_decode(pbaccountlogin, Bytes).

delimited_decode_pbattribute(Bytes) ->
    delimited_decode(pbattribute, Bytes).

delimited_decode_pbcombatreward(Bytes) ->
    delimited_decode(pbcombatreward, Bytes).

delimited_decode_pbcreatearole(Bytes) ->
    delimited_decode(pbcreatearole, Bytes).

delimited_decode_pbfriend(Bytes) ->
    delimited_decode(pbfriend, Bytes).

delimited_decode_pbgoods(Bytes) ->
    delimited_decode(pbgoods, Bytes).

delimited_decode_pbgoodsinfo(Bytes) ->
    delimited_decode(pbgoodsinfo, Bytes).

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

delimited_decode_pbrc4(Bytes) ->
    delimited_decode(pbrc4, Bytes).

delimited_decode_pbresult(Bytes) ->
    delimited_decode(pbresult, Bytes).

delimited_decode_pbrewarditem(Bytes) ->
    delimited_decode(pbrewarditem, Bytes).

delimited_decode_pbserverstatus(Bytes) ->
    delimited_decode(pbserverstatus, Bytes).

delimited_decode_pbskill(Bytes) ->
    delimited_decode(pbskill, Bytes).

delimited_decode_pbuserloginfashioninfo(Bytes) ->
    delimited_decode(pbuserloginfashioninfo, Bytes).

delimited_decode_pbuserlogininfo(Bytes) ->
    delimited_decode(pbuserlogininfo, Bytes).

delimited_decode_pbuserresult(Bytes) ->
    delimited_decode(pbuserresult, Bytes).

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
decode(pbaccount, Bytes) when is_binary(Bytes) ->
    Types = [{8, device_id, string, []},
	     {7, platform, string, []}, {6, suid, string, []},
	     {5, login_ticket, string, []},
	     {4, server_id, int32, []}, {3, timestamp, int32, []},
	     {2, acc_name, string, []}, {1, acc_id, int64, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbaccount, Decoded);
decode(pbaccountlogin, Bytes) when is_binary(Bytes) ->
    Types = [{5, session, int32, []},
	     {4, acc_id, string, []},
	     {3, user_info, pbuserlogininfo, [is_record, repeated]},
	     {2, total_online, int32, []}, {1, result, int32, []}],
    Defaults = [{3, user_info, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbaccountlogin, Decoded);
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
decode(pbcreatearole, Bytes) when is_binary(Bytes) ->
    Types = [{2, acc_id, int64, []},
	     {1, server_id, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbcreatearole, Decoded);
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
decode(pbgoodsinfo, Bytes) when is_binary(Bytes) ->
    Types = [{2, num, int32, []}, {1, id, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbgoodsinfo, Decoded);
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
decode(pbrc4, Bytes) when is_binary(Bytes) ->
    Types = [{3, pub, bytes, []}, {2, g, bytes, []},
	     {1, p, bytes, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbrc4, Decoded);
decode(pbresult, Bytes) when is_binary(Bytes) ->
    Types = [{1, result, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbresult, Decoded);
decode(pbrewarditem, Bytes) when is_binary(Bytes) ->
    Types = [{4, goods_id, int32, []}, {3, num, int32, []},
	     {1, id, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbrewarditem, Decoded);
decode(pbserverstatus, Bytes) when is_binary(Bytes) ->
    Types = [{5, num, int32, []}, {4, state, int32, []},
	     {3, port, int32, []}, {2, ip, string, []},
	     {1, index, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbserverstatus, Decoded);
decode(pbskill, Bytes) when is_binary(Bytes) ->
    Types = [{7, type, int32, []},
	     {6, sigil, int32, [repeated]}, {5, str_lv, int32, []},
	     {4, lv, int32, []}, {3, player_id, int32, []},
	     {2, skill_id, int32, []}, {1, id, int32, []}],
    Defaults = [{6, sigil, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbskill, Decoded);
decode(pbuserloginfashioninfo, Bytes)
    when is_binary(Bytes) ->
    Types = [{2, sub_type, int32, []},
	     {1, fashion_base_id, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbuserloginfashioninfo, Decoded);
decode(pbuserlogininfo, Bytes) when is_binary(Bytes) ->
    Types = [{11, list, pbuserloginfashioninfo,
	      [is_record, repeated]},
	     {10, acc_name, string, []}, {9, acc_id, string, []},
	     {8, status, int32, []}, {7, server_id, int32, []},
	     {6, sex, int32, []}, {5, career, int32, []},
	     {4, camp, int32, []}, {3, level, int32, []},
	     {2, nickname, string, []}, {1, user_id, int64, []}],
    Defaults = [{11, list, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbuserlogininfo, Decoded);
decode(pbuserresult, Bytes) when is_binary(Bytes) ->
    Types = [{2, user_id, int64, []},
	     {1, result, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbuserresult, Decoded).

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

to_record(pbaccount, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbaccount),
						   Record, Name, Val)
			  end,
			  #pbaccount{}, DecodedTuples),
    Record1;
to_record(pbaccountlogin, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbaccountlogin),
						   Record, Name, Val)
			  end,
			  #pbaccountlogin{}, DecodedTuples),
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
to_record(pbcombatreward, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbcombatreward),
						   Record, Name, Val)
			  end,
			  #pbcombatreward{}, DecodedTuples),
    Record1;
to_record(pbcreatearole, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbcreatearole),
						   Record, Name, Val)
			  end,
			  #pbcreatearole{}, DecodedTuples),
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
to_record(pbgoods, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields, pbgoods),
						   Record, Name, Val)
			  end,
			  #pbgoods{}, DecodedTuples),
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
to_record(pbrc4, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields, pbrc4),
						   Record, Name, Val)
			  end,
			  #pbrc4{}, DecodedTuples),
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
to_record(pbrewarditem, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbrewarditem),
						   Record, Name, Val)
			  end,
			  #pbrewarditem{}, DecodedTuples),
    Record1;
to_record(pbserverstatus, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbserverstatus),
						   Record, Name, Val)
			  end,
			  #pbserverstatus{}, DecodedTuples),
    Record1;
to_record(pbskill, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields, pbskill),
						   Record, Name, Val)
			  end,
			  #pbskill{}, DecodedTuples),
    Record1;
to_record(pbuserloginfashioninfo, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbuserloginfashioninfo),
						   Record, Name, Val)
			  end,
			  #pbuserloginfashioninfo{}, DecodedTuples),
    Record1;
to_record(pbuserlogininfo, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbuserlogininfo),
						   Record, Name, Val)
			  end,
			  #pbuserlogininfo{}, DecodedTuples),
    Record1;
to_record(pbuserresult, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbuserresult),
						   Record, Name, Val)
			  end,
			  #pbuserresult{}, DecodedTuples),
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

