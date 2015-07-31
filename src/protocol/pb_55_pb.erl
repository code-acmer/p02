-file("src/pb_55_pb.erl", 1).

-module(pb_55_pb).

-export([encode_pbstartcombat/1, decode_pbstartcombat/1,
	 delimited_decode_pbstartcombat/1, encode_pbskill/1,
	 decode_pbskill/1, delimited_decode_pbskill/1,
	 encode_pbrewarditem/1, decode_pbrewarditem/1,
	 delimited_decode_pbrewarditem/1, encode_pbresult/1,
	 decode_pbresult/1, delimited_decode_pbresult/1,
	 encode_pbidstring/1, decode_pbidstring/1,
	 delimited_decode_pbidstring/1, encode_pbid64r/1,
	 decode_pbid64r/1, delimited_decode_pbid64r/1,
	 encode_pbid64/1, decode_pbid64/1,
	 delimited_decode_pbid64/1, encode_pbid32r/1,
	 decode_pbid32r/1, delimited_decode_pbid32r/1,
	 encode_pbid32/1, decode_pbid32/1,
	 delimited_decode_pbid32/1, encode_pbgoodsinfo/1,
	 decode_pbgoodsinfo/1, delimited_decode_pbgoodsinfo/1,
	 encode_pbgoods/1, decode_pbgoods/1,
	 delimited_decode_pbgoods/1, encode_pbfriend/1,
	 decode_pbfriend/1, delimited_decode_pbfriend/1,
	 encode_pbcombattarget/1, decode_pbcombattarget/1,
	 delimited_decode_pbcombattarget/1,
	 encode_pbcombatround/1, decode_pbcombatround/1,
	 delimited_decode_pbcombatround/1,
	 encode_pbcombatreward/1, decode_pbcombatreward/1,
	 delimited_decode_pbcombatreward/1,
	 encode_pbcombatreportlist/1,
	 decode_pbcombatreportlist/1,
	 delimited_decode_pbcombatreportlist/1,
	 encode_pbcombatreport/1, decode_pbcombatreport/1,
	 delimited_decode_pbcombatreport/1,
	 encode_pbcombathurtattri/1, decode_pbcombathurtattri/1,
	 delimited_decode_pbcombathurtattri/1,
	 encode_pbcombatfighter/1, decode_pbcombatfighter/1,
	 delimited_decode_pbcombatfighter/1,
	 encode_pbcombateffect/1, decode_pbcombateffect/1,
	 delimited_decode_pbcombateffect/1,
	 encode_pbcombatbuff/1, decode_pbcombatbuff/1,
	 delimited_decode_pbcombatbuff/1, encode_pbattribute/1,
	 decode_pbattribute/1, delimited_decode_pbattribute/1]).

-export([has_extension/2, extension_size/1,
	 get_extension/2, set_extension/3]).

-export([decode_extensions/1]).

-export([encode/1, decode/2, delimited_decode/2]).

-export([int_to_enum/2, enum_to_int/2]).

-record(pbstartcombat,
	{id, type, value1, value2, value3}).

-record(pbskill,
	{id, skill_id, player_id, lv, str_lv, sigil, type}).

-record(pbrewarditem, {id, num, goods_id}).

-record(pbresult, {result}).

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

-record(pbcombattarget, {id, pos, target_type}).

-record(pbcombatround,
	{unique_id, id, pos, atk_type, export_type, attacker_id,
	 attack_skill, master_targets, round_begin, before_atk,
	 before_def, hurt, at_atking, at_defing, after_def,
	 after_atk, ext_hurt, round_end, slave_targets,
	 all_buffs}).

-record(pbcombatreward,
	{exp, mon_drop_list, dungeon_reward_list, unique_id,
	 seal, evaluate, point, partners}).

-record(pbcombatreportlist, {combat_report_list}).

-record(pbcombatreport,
	{report_id, result, final, result_lv, copy_id, version,
	 can_skip, attacker_id, attacker_unique_id,
	 attacker_camp_id, attacker_list, attacker_beast,
	 defender_id, defender_unique_id, defender_camp_id,
	 defender_list, defender_beast, report_list,
	 active_skill_list, passive_skill_list, prepare_effect,
	 attacker_dead, defender_dead}).

-record(pbcombathurtattri,
	{hp, mp, buffs, flag_death, flag_frozen, flag_sleep,
	 flag_swim, flag_coma, flag_silence, flag_chaos,
	 flag_fatal, flag_meta, flag_meta_rate, flag_miss,
	 flag_beheaded, flag_wreck, flag_crit, flag_parry,
	 flag_back_to_bite, flag_unyiedlding, flag_rebound,
	 flag_shift, flag_absorb_sub, flag_absorb, flag_vampire,
	 flag_hit_cnt, hit_cnt, flag_strengthen, flag_weaken,
	 flag_firm, flag_hide, hp_lim}).

-record(pbcombatfighter,
	{unique_id, id, name, lv, pos, hp_lim, hp, mp,
	 stunt_skill_id, resource_id, career_id,
	 attacker_resource_id, deffender_resource_id, buffs,
	 gender, career, normal_skill_id, passive_skill_ids,
	 weaponbase, mountbase, equipbase, fighter_type,
	 stunt_skill_ids}).

-record(pbcombateffect,
	{atk_pos, atk_player_id, def_pos, def_player_id,
	 passive_skill_id, type, effect_point, effect_type,
	 hurt_list}).

-record(pbcombatbuff,
	{buff_id, buff_type, continue_value, op_type, id}).

-record(pbattribute,
	{hp_lim, hp_cur, mana_lim, mana_cur, hp_rec, mana_rec,
	 attack, def, hit, dodge, crit, anti_crit, stiff,
	 anti_stiff, attack_speed, move_speed, attack_effect,
	 def_effect}).

encode([]) -> [];
encode(Records) when is_list(Records) ->
    delimited_encode(Records);
encode(Record) -> encode(element(1, Record), Record).

encode_pbstartcombat(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbstartcombat(Record)
    when is_record(Record, pbstartcombat) ->
    encode(pbstartcombat, Record).

encode_pbskill(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbskill(Record)
    when is_record(Record, pbskill) ->
    encode(pbskill, Record).

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

encode_pbcombattarget(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbcombattarget(Record)
    when is_record(Record, pbcombattarget) ->
    encode(pbcombattarget, Record).

encode_pbcombatround(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbcombatround(Record)
    when is_record(Record, pbcombatround) ->
    encode(pbcombatround, Record).

encode_pbcombatreward(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbcombatreward(Record)
    when is_record(Record, pbcombatreward) ->
    encode(pbcombatreward, Record).

encode_pbcombatreportlist(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_pbcombatreportlist(Record)
    when is_record(Record, pbcombatreportlist) ->
    encode(pbcombatreportlist, Record).

encode_pbcombatreport(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbcombatreport(Record)
    when is_record(Record, pbcombatreport) ->
    encode(pbcombatreport, Record).

encode_pbcombathurtattri(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_pbcombathurtattri(Record)
    when is_record(Record, pbcombathurtattri) ->
    encode(pbcombathurtattri, Record).

encode_pbcombatfighter(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbcombatfighter(Record)
    when is_record(Record, pbcombatfighter) ->
    encode(pbcombatfighter, Record).

encode_pbcombateffect(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbcombateffect(Record)
    when is_record(Record, pbcombateffect) ->
    encode(pbcombateffect, Record).

encode_pbcombatbuff(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbcombatbuff(Record)
    when is_record(Record, pbcombatbuff) ->
    encode(pbcombatbuff, Record).

encode_pbattribute(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbattribute(Record)
    when is_record(Record, pbattribute) ->
    encode(pbattribute, Record).

encode(pbattribute, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbattribute, Record) ->
    [iolist(pbattribute, Record)
     | encode_extensions(Record)];
encode(pbcombatbuff, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbcombatbuff, Record) ->
    [iolist(pbcombatbuff, Record)
     | encode_extensions(Record)];
encode(pbcombateffect, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbcombateffect, Record) ->
    [iolist(pbcombateffect, Record)
     | encode_extensions(Record)];
encode(pbcombatfighter, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbcombatfighter, Record) ->
    [iolist(pbcombatfighter, Record)
     | encode_extensions(Record)];
encode(pbcombathurtattri, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbcombathurtattri, Record) ->
    [iolist(pbcombathurtattri, Record)
     | encode_extensions(Record)];
encode(pbcombatreport, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbcombatreport, Record) ->
    [iolist(pbcombatreport, Record)
     | encode_extensions(Record)];
encode(pbcombatreportlist, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbcombatreportlist, Record) ->
    [iolist(pbcombatreportlist, Record)
     | encode_extensions(Record)];
encode(pbcombatreward, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbcombatreward, Record) ->
    [iolist(pbcombatreward, Record)
     | encode_extensions(Record)];
encode(pbcombatround, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbcombatround, Record) ->
    [iolist(pbcombatround, Record)
     | encode_extensions(Record)];
encode(pbcombattarget, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbcombattarget, Record) ->
    [iolist(pbcombattarget, Record)
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
encode(pbresult, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbresult, Record) ->
    [iolist(pbresult, Record) | encode_extensions(Record)];
encode(pbrewarditem, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbrewarditem, Record) ->
    [iolist(pbrewarditem, Record)
     | encode_extensions(Record)];
encode(pbskill, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbskill, Record) ->
    [iolist(pbskill, Record) | encode_extensions(Record)];
encode(pbstartcombat, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbstartcombat, Record) ->
    [iolist(pbstartcombat, Record)
     | encode_extensions(Record)].

encode_extensions(_) -> [].

delimited_encode(Records) ->
    lists:map(fun (Record) ->
		      IoRec = encode(Record),
		      Size = iolist_size(IoRec),
		      [protobuffs:encode_varint(Size), IoRec]
	      end,
	      Records).

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
iolist(pbcombatbuff, Record) ->
    [pack(1, optional,
	  with_default(Record#pbcombatbuff.buff_id, none), int32,
	  []),
     pack(2, optional,
	  with_default(Record#pbcombatbuff.buff_type, none),
	  int32, []),
     pack(3, optional,
	  with_default(Record#pbcombatbuff.continue_value, none),
	  int32, []),
     pack(4, optional,
	  with_default(Record#pbcombatbuff.op_type, none), int32,
	  []),
     pack(5, optional,
	  with_default(Record#pbcombatbuff.id, none), int32, [])];
iolist(pbcombateffect, Record) ->
    [pack(1, optional,
	  with_default(Record#pbcombateffect.atk_pos, none),
	  int32, []),
     pack(2, optional,
	  with_default(Record#pbcombateffect.atk_player_id, none),
	  int32, []),
     pack(3, optional,
	  with_default(Record#pbcombateffect.def_pos, none),
	  int32, []),
     pack(4, optional,
	  with_default(Record#pbcombateffect.def_player_id, none),
	  int32, []),
     pack(5, optional,
	  with_default(Record#pbcombateffect.passive_skill_id,
		       none),
	  int32, []),
     pack(6, optional,
	  with_default(Record#pbcombateffect.type, none), int32,
	  []),
     pack(7, optional,
	  with_default(Record#pbcombateffect.effect_point, none),
	  int32, []),
     pack(8, optional,
	  with_default(Record#pbcombateffect.effect_type, none),
	  int32, []),
     pack(9, repeated,
	  with_default(Record#pbcombateffect.hurt_list, none),
	  pbcombathurtattri, [])];
iolist(pbcombatfighter, Record) ->
    [pack(1, optional,
	  with_default(Record#pbcombatfighter.unique_id, none),
	  int32, []),
     pack(2, optional,
	  with_default(Record#pbcombatfighter.id, none), int64,
	  []),
     pack(3, optional,
	  with_default(Record#pbcombatfighter.name, none), string,
	  []),
     pack(4, optional,
	  with_default(Record#pbcombatfighter.lv, none), int32,
	  []),
     pack(5, optional,
	  with_default(Record#pbcombatfighter.pos, none), int32,
	  []),
     pack(6, optional,
	  with_default(Record#pbcombatfighter.hp_lim, none),
	  int32, []),
     pack(7, optional,
	  with_default(Record#pbcombatfighter.hp, none), int32,
	  []),
     pack(8, optional,
	  with_default(Record#pbcombatfighter.mp, none), int32,
	  []),
     pack(9, optional,
	  with_default(Record#pbcombatfighter.stunt_skill_id,
		       none),
	  int32, []),
     pack(10, optional,
	  with_default(Record#pbcombatfighter.resource_id, none),
	  int32, []),
     pack(11, optional,
	  with_default(Record#pbcombatfighter.career_id, none),
	  int32, []),
     pack(12, optional,
	  with_default(Record#pbcombatfighter.attacker_resource_id,
		       none),
	  int32, []),
     pack(13, optional,
	  with_default(Record#pbcombatfighter.deffender_resource_id,
		       none),
	  int32, []),
     pack(14, repeated,
	  with_default(Record#pbcombatfighter.buffs, none),
	  pbcombatbuff, []),
     pack(15, optional,
	  with_default(Record#pbcombatfighter.gender, none),
	  int32, []),
     pack(16, optional,
	  with_default(Record#pbcombatfighter.career, none),
	  int32, []),
     pack(17, optional,
	  with_default(Record#pbcombatfighter.normal_skill_id,
		       none),
	  int32, []),
     pack(18, repeated,
	  with_default(Record#pbcombatfighter.passive_skill_ids,
		       none),
	  int32, []),
     pack(19, optional,
	  with_default(Record#pbcombatfighter.weaponbase, none),
	  int32, []),
     pack(20, optional,
	  with_default(Record#pbcombatfighter.mountbase, none),
	  int32, []),
     pack(21, optional,
	  with_default(Record#pbcombatfighter.equipbase, none),
	  int32, []),
     pack(22, optional,
	  with_default(Record#pbcombatfighter.fighter_type, none),
	  int32, []),
     pack(23, repeated,
	  with_default(Record#pbcombatfighter.stunt_skill_ids,
		       none),
	  int32, [])];
iolist(pbcombathurtattri, Record) ->
    [pack(1, optional,
	  with_default(Record#pbcombathurtattri.hp, none), int32,
	  []),
     pack(2, optional,
	  with_default(Record#pbcombathurtattri.mp, none), int32,
	  []),
     pack(3, repeated,
	  with_default(Record#pbcombathurtattri.buffs, none),
	  pbcombatbuff, []),
     pack(4, optional,
	  with_default(Record#pbcombathurtattri.flag_death, none),
	  int32, []),
     pack(5, optional,
	  with_default(Record#pbcombathurtattri.flag_frozen,
		       none),
	  int32, []),
     pack(6, optional,
	  with_default(Record#pbcombathurtattri.flag_sleep, none),
	  int32, []),
     pack(7, optional,
	  with_default(Record#pbcombathurtattri.flag_swim, none),
	  int32, []),
     pack(8, optional,
	  with_default(Record#pbcombathurtattri.flag_coma, none),
	  int32, []),
     pack(9, optional,
	  with_default(Record#pbcombathurtattri.flag_silence,
		       none),
	  int32, []),
     pack(10, optional,
	  with_default(Record#pbcombathurtattri.flag_chaos, none),
	  int32, []),
     pack(11, optional,
	  with_default(Record#pbcombathurtattri.flag_fatal, none),
	  int32, []),
     pack(12, optional,
	  with_default(Record#pbcombathurtattri.flag_meta, none),
	  int32, []),
     pack(13, optional,
	  with_default(Record#pbcombathurtattri.flag_meta_rate,
		       none),
	  int32, []),
     pack(14, optional,
	  with_default(Record#pbcombathurtattri.flag_miss, none),
	  int32, []),
     pack(15, optional,
	  with_default(Record#pbcombathurtattri.flag_beheaded,
		       none),
	  int32, []),
     pack(16, optional,
	  with_default(Record#pbcombathurtattri.flag_wreck, none),
	  int32, []),
     pack(17, optional,
	  with_default(Record#pbcombathurtattri.flag_crit, none),
	  int32, []),
     pack(18, optional,
	  with_default(Record#pbcombathurtattri.flag_parry, none),
	  int32, []),
     pack(19, optional,
	  with_default(Record#pbcombathurtattri.flag_back_to_bite,
		       none),
	  int32, []),
     pack(20, optional,
	  with_default(Record#pbcombathurtattri.flag_unyiedlding,
		       none),
	  int32, []),
     pack(21, optional,
	  with_default(Record#pbcombathurtattri.flag_rebound,
		       none),
	  int32, []),
     pack(22, optional,
	  with_default(Record#pbcombathurtattri.flag_shift, none),
	  int32, []),
     pack(23, optional,
	  with_default(Record#pbcombathurtattri.flag_absorb_sub,
		       none),
	  int32, []),
     pack(24, optional,
	  with_default(Record#pbcombathurtattri.flag_absorb,
		       none),
	  int32, []),
     pack(25, optional,
	  with_default(Record#pbcombathurtattri.flag_vampire,
		       none),
	  int32, []),
     pack(26, optional,
	  with_default(Record#pbcombathurtattri.flag_hit_cnt,
		       none),
	  int32, []),
     pack(27, optional,
	  with_default(Record#pbcombathurtattri.hit_cnt, none),
	  int32, []),
     pack(28, optional,
	  with_default(Record#pbcombathurtattri.flag_strengthen,
		       none),
	  int32, []),
     pack(29, optional,
	  with_default(Record#pbcombathurtattri.flag_weaken,
		       none),
	  int32, []),
     pack(31, optional,
	  with_default(Record#pbcombathurtattri.flag_firm, none),
	  int32, []),
     pack(32, optional,
	  with_default(Record#pbcombathurtattri.flag_hide, none),
	  int32, []),
     pack(33, optional,
	  with_default(Record#pbcombathurtattri.hp_lim, none),
	  int32, [])];
iolist(pbcombatreport, Record) ->
    [pack(1, optional,
	  with_default(Record#pbcombatreport.report_id, none),
	  string, []),
     pack(2, optional,
	  with_default(Record#pbcombatreport.result, none), int32,
	  []),
     pack(3, optional,
	  with_default(Record#pbcombatreport.final, none), int32,
	  []),
     pack(4, optional,
	  with_default(Record#pbcombatreport.result_lv, none),
	  int32, []),
     pack(5, optional,
	  with_default(Record#pbcombatreport.copy_id, none),
	  int32, []),
     pack(6, optional,
	  with_default(Record#pbcombatreport.version, none),
	  int32, []),
     pack(7, optional,
	  with_default(Record#pbcombatreport.can_skip, none),
	  int32, []),
     pack(8, optional,
	  with_default(Record#pbcombatreport.attacker_id, none),
	  int64, []),
     pack(9, optional,
	  with_default(Record#pbcombatreport.attacker_unique_id,
		       none),
	  int32, []),
     pack(10, optional,
	  with_default(Record#pbcombatreport.attacker_camp_id,
		       none),
	  int32, []),
     pack(11, repeated,
	  with_default(Record#pbcombatreport.attacker_list, none),
	  pbcombatfighter, []),
     pack(12, optional,
	  with_default(Record#pbcombatreport.attacker_beast,
		       none),
	  pbcombatfighter, []),
     pack(13, optional,
	  with_default(Record#pbcombatreport.defender_id, none),
	  int64, []),
     pack(14, optional,
	  with_default(Record#pbcombatreport.defender_unique_id,
		       none),
	  int32, []),
     pack(15, optional,
	  with_default(Record#pbcombatreport.defender_camp_id,
		       none),
	  int32, []),
     pack(16, repeated,
	  with_default(Record#pbcombatreport.defender_list, none),
	  pbcombatfighter, []),
     pack(17, optional,
	  with_default(Record#pbcombatreport.defender_beast,
		       none),
	  pbcombatfighter, []),
     pack(18, repeated,
	  with_default(Record#pbcombatreport.report_list, none),
	  pbcombatround, []),
     pack(19, repeated,
	  with_default(Record#pbcombatreport.active_skill_list,
		       none),
	  int32, []),
     pack(20, repeated,
	  with_default(Record#pbcombatreport.passive_skill_list,
		       none),
	  int32, []),
     pack(21, repeated,
	  with_default(Record#pbcombatreport.prepare_effect,
		       none),
	  pbcombateffect, []),
     pack(22, repeated,
	  with_default(Record#pbcombatreport.attacker_dead, none),
	  int32, []),
     pack(23, repeated,
	  with_default(Record#pbcombatreport.defender_dead, none),
	  int32, [])];
iolist(pbcombatreportlist, Record) ->
    [pack(1, repeated,
	  with_default(Record#pbcombatreportlist.combat_report_list,
		       none),
	  pbcombatreport, [])];
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
iolist(pbcombatround, Record) ->
    [pack(1, optional,
	  with_default(Record#pbcombatround.unique_id, none),
	  int32, []),
     pack(2, optional,
	  with_default(Record#pbcombatround.id, none), int32, []),
     pack(3, optional,
	  with_default(Record#pbcombatround.pos, none), int32,
	  []),
     pack(4, optional,
	  with_default(Record#pbcombatround.atk_type, none),
	  int32, []),
     pack(5, optional,
	  with_default(Record#pbcombatround.export_type, none),
	  int32, []),
     pack(6, optional,
	  with_default(Record#pbcombatround.attacker_id, none),
	  int64, []),
     pack(7, optional,
	  with_default(Record#pbcombatround.attack_skill, none),
	  int32, []),
     pack(8, repeated,
	  with_default(Record#pbcombatround.master_targets, none),
	  pbcombattarget, []),
     pack(9, repeated,
	  with_default(Record#pbcombatround.round_begin, none),
	  pbcombateffect, []),
     pack(10, repeated,
	  with_default(Record#pbcombatround.before_atk, none),
	  pbcombateffect, []),
     pack(11, repeated,
	  with_default(Record#pbcombatround.before_def, none),
	  pbcombateffect, []),
     pack(12, repeated,
	  with_default(Record#pbcombatround.hurt, none),
	  pbcombateffect, []),
     pack(13, repeated,
	  with_default(Record#pbcombatround.at_atking, none),
	  pbcombateffect, []),
     pack(14, repeated,
	  with_default(Record#pbcombatround.at_defing, none),
	  pbcombateffect, []),
     pack(15, repeated,
	  with_default(Record#pbcombatround.after_def, none),
	  pbcombateffect, []),
     pack(16, repeated,
	  with_default(Record#pbcombatround.after_atk, none),
	  pbcombateffect, []),
     pack(17, repeated,
	  with_default(Record#pbcombatround.ext_hurt, none),
	  pbcombateffect, []),
     pack(18, repeated,
	  with_default(Record#pbcombatround.round_end, none),
	  pbcombateffect, []),
     pack(19, repeated,
	  with_default(Record#pbcombatround.slave_targets, none),
	  pbcombattarget, []),
     pack(20, repeated,
	  with_default(Record#pbcombatround.all_buffs, none),
	  pbcombateffect, [])];
iolist(pbcombattarget, Record) ->
    [pack(1, optional,
	  with_default(Record#pbcombattarget.id, none), int32,
	  []),
     pack(2, optional,
	  with_default(Record#pbcombattarget.pos, none), int32,
	  []),
     pack(3, optional,
	  with_default(Record#pbcombattarget.target_type, none),
	  int32, [])];
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
iolist(pbstartcombat, Record) ->
    [pack(1, optional,
	  with_default(Record#pbstartcombat.id, none), int64, []),
     pack(2, optional,
	  with_default(Record#pbstartcombat.type, none), int32,
	  []),
     pack(3, optional,
	  with_default(Record#pbstartcombat.value1, none), int32,
	  []),
     pack(4, optional,
	  with_default(Record#pbstartcombat.value2, none), int32,
	  []),
     pack(5, optional,
	  with_default(Record#pbstartcombat.value3, none), int32,
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

decode_pbstartcombat(Bytes) when is_binary(Bytes) ->
    decode(pbstartcombat, Bytes).

decode_pbskill(Bytes) when is_binary(Bytes) ->
    decode(pbskill, Bytes).

decode_pbrewarditem(Bytes) when is_binary(Bytes) ->
    decode(pbrewarditem, Bytes).

decode_pbresult(Bytes) when is_binary(Bytes) ->
    decode(pbresult, Bytes).

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

decode_pbcombattarget(Bytes) when is_binary(Bytes) ->
    decode(pbcombattarget, Bytes).

decode_pbcombatround(Bytes) when is_binary(Bytes) ->
    decode(pbcombatround, Bytes).

decode_pbcombatreward(Bytes) when is_binary(Bytes) ->
    decode(pbcombatreward, Bytes).

decode_pbcombatreportlist(Bytes)
    when is_binary(Bytes) ->
    decode(pbcombatreportlist, Bytes).

decode_pbcombatreport(Bytes) when is_binary(Bytes) ->
    decode(pbcombatreport, Bytes).

decode_pbcombathurtattri(Bytes) when is_binary(Bytes) ->
    decode(pbcombathurtattri, Bytes).

decode_pbcombatfighter(Bytes) when is_binary(Bytes) ->
    decode(pbcombatfighter, Bytes).

decode_pbcombateffect(Bytes) when is_binary(Bytes) ->
    decode(pbcombateffect, Bytes).

decode_pbcombatbuff(Bytes) when is_binary(Bytes) ->
    decode(pbcombatbuff, Bytes).

decode_pbattribute(Bytes) when is_binary(Bytes) ->
    decode(pbattribute, Bytes).

delimited_decode_pbattribute(Bytes) ->
    delimited_decode(pbattribute, Bytes).

delimited_decode_pbcombatbuff(Bytes) ->
    delimited_decode(pbcombatbuff, Bytes).

delimited_decode_pbcombateffect(Bytes) ->
    delimited_decode(pbcombateffect, Bytes).

delimited_decode_pbcombatfighter(Bytes) ->
    delimited_decode(pbcombatfighter, Bytes).

delimited_decode_pbcombathurtattri(Bytes) ->
    delimited_decode(pbcombathurtattri, Bytes).

delimited_decode_pbcombatreport(Bytes) ->
    delimited_decode(pbcombatreport, Bytes).

delimited_decode_pbcombatreportlist(Bytes) ->
    delimited_decode(pbcombatreportlist, Bytes).

delimited_decode_pbcombatreward(Bytes) ->
    delimited_decode(pbcombatreward, Bytes).

delimited_decode_pbcombatround(Bytes) ->
    delimited_decode(pbcombatround, Bytes).

delimited_decode_pbcombattarget(Bytes) ->
    delimited_decode(pbcombattarget, Bytes).

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

delimited_decode_pbresult(Bytes) ->
    delimited_decode(pbresult, Bytes).

delimited_decode_pbrewarditem(Bytes) ->
    delimited_decode(pbrewarditem, Bytes).

delimited_decode_pbskill(Bytes) ->
    delimited_decode(pbskill, Bytes).

delimited_decode_pbstartcombat(Bytes) ->
    delimited_decode(pbstartcombat, Bytes).

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
decode(pbcombatbuff, Bytes) when is_binary(Bytes) ->
    Types = [{5, id, int32, []}, {4, op_type, int32, []},
	     {3, continue_value, int32, []},
	     {2, buff_type, int32, []}, {1, buff_id, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbcombatbuff, Decoded);
decode(pbcombateffect, Bytes) when is_binary(Bytes) ->
    Types = [{9, hurt_list, pbcombathurtattri,
	      [is_record, repeated]},
	     {8, effect_type, int32, []},
	     {7, effect_point, int32, []}, {6, type, int32, []},
	     {5, passive_skill_id, int32, []},
	     {4, def_player_id, int32, []}, {3, def_pos, int32, []},
	     {2, atk_player_id, int32, []}, {1, atk_pos, int32, []}],
    Defaults = [{9, hurt_list, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbcombateffect, Decoded);
decode(pbcombatfighter, Bytes) when is_binary(Bytes) ->
    Types = [{23, stunt_skill_ids, int32, [repeated]},
	     {22, fighter_type, int32, []},
	     {21, equipbase, int32, []}, {20, mountbase, int32, []},
	     {19, weaponbase, int32, []},
	     {18, passive_skill_ids, int32, [repeated]},
	     {17, normal_skill_id, int32, []},
	     {16, career, int32, []}, {15, gender, int32, []},
	     {14, buffs, pbcombatbuff, [is_record, repeated]},
	     {13, deffender_resource_id, int32, []},
	     {12, attacker_resource_id, int32, []},
	     {11, career_id, int32, []},
	     {10, resource_id, int32, []},
	     {9, stunt_skill_id, int32, []}, {8, mp, int32, []},
	     {7, hp, int32, []}, {6, hp_lim, int32, []},
	     {5, pos, int32, []}, {4, lv, int32, []},
	     {3, name, string, []}, {2, id, int64, []},
	     {1, unique_id, int32, []}],
    Defaults = [{14, buffs, []},
		{18, passive_skill_ids, []}, {23, stunt_skill_ids, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbcombatfighter, Decoded);
decode(pbcombathurtattri, Bytes)
    when is_binary(Bytes) ->
    Types = [{33, hp_lim, int32, []},
	     {32, flag_hide, int32, []}, {31, flag_firm, int32, []},
	     {29, flag_weaken, int32, []},
	     {28, flag_strengthen, int32, []},
	     {27, hit_cnt, int32, []}, {26, flag_hit_cnt, int32, []},
	     {25, flag_vampire, int32, []},
	     {24, flag_absorb, int32, []},
	     {23, flag_absorb_sub, int32, []},
	     {22, flag_shift, int32, []},
	     {21, flag_rebound, int32, []},
	     {20, flag_unyiedlding, int32, []},
	     {19, flag_back_to_bite, int32, []},
	     {18, flag_parry, int32, []}, {17, flag_crit, int32, []},
	     {16, flag_wreck, int32, []},
	     {15, flag_beheaded, int32, []},
	     {14, flag_miss, int32, []},
	     {13, flag_meta_rate, int32, []},
	     {12, flag_meta, int32, []}, {11, flag_fatal, int32, []},
	     {10, flag_chaos, int32, []},
	     {9, flag_silence, int32, []}, {8, flag_coma, int32, []},
	     {7, flag_swim, int32, []}, {6, flag_sleep, int32, []},
	     {5, flag_frozen, int32, []}, {4, flag_death, int32, []},
	     {3, buffs, pbcombatbuff, [is_record, repeated]},
	     {2, mp, int32, []}, {1, hp, int32, []}],
    Defaults = [{3, buffs, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbcombathurtattri, Decoded);
decode(pbcombatreport, Bytes) when is_binary(Bytes) ->
    Types = [{23, defender_dead, int32, [repeated]},
	     {22, attacker_dead, int32, [repeated]},
	     {21, prepare_effect, pbcombateffect,
	      [is_record, repeated]},
	     {20, passive_skill_list, int32, [repeated]},
	     {19, active_skill_list, int32, [repeated]},
	     {18, report_list, pbcombatround, [is_record, repeated]},
	     {17, defender_beast, pbcombatfighter, [is_record]},
	     {16, defender_list, pbcombatfighter,
	      [is_record, repeated]},
	     {15, defender_camp_id, int32, []},
	     {14, defender_unique_id, int32, []},
	     {13, defender_id, int64, []},
	     {12, attacker_beast, pbcombatfighter, [is_record]},
	     {11, attacker_list, pbcombatfighter,
	      [is_record, repeated]},
	     {10, attacker_camp_id, int32, []},
	     {9, attacker_unique_id, int32, []},
	     {8, attacker_id, int64, []}, {7, can_skip, int32, []},
	     {6, version, int32, []}, {5, copy_id, int32, []},
	     {4, result_lv, int32, []}, {3, final, int32, []},
	     {2, result, int32, []}, {1, report_id, string, []}],
    Defaults = [{11, attacker_list, []},
		{16, defender_list, []}, {18, report_list, []},
		{19, active_skill_list, []},
		{20, passive_skill_list, []}, {21, prepare_effect, []},
		{22, attacker_dead, []}, {23, defender_dead, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbcombatreport, Decoded);
decode(pbcombatreportlist, Bytes)
    when is_binary(Bytes) ->
    Types = [{1, combat_report_list, pbcombatreport,
	      [is_record, repeated]}],
    Defaults = [{1, combat_report_list, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbcombatreportlist, Decoded);
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
decode(pbcombatround, Bytes) when is_binary(Bytes) ->
    Types = [{20, all_buffs, pbcombateffect,
	      [is_record, repeated]},
	     {19, slave_targets, pbcombattarget,
	      [is_record, repeated]},
	     {18, round_end, pbcombateffect, [is_record, repeated]},
	     {17, ext_hurt, pbcombateffect, [is_record, repeated]},
	     {16, after_atk, pbcombateffect, [is_record, repeated]},
	     {15, after_def, pbcombateffect, [is_record, repeated]},
	     {14, at_defing, pbcombateffect, [is_record, repeated]},
	     {13, at_atking, pbcombateffect, [is_record, repeated]},
	     {12, hurt, pbcombateffect, [is_record, repeated]},
	     {11, before_def, pbcombateffect, [is_record, repeated]},
	     {10, before_atk, pbcombateffect, [is_record, repeated]},
	     {9, round_begin, pbcombateffect, [is_record, repeated]},
	     {8, master_targets, pbcombattarget,
	      [is_record, repeated]},
	     {7, attack_skill, int32, []},
	     {6, attacker_id, int64, []},
	     {5, export_type, int32, []}, {4, atk_type, int32, []},
	     {3, pos, int32, []}, {2, id, int32, []},
	     {1, unique_id, int32, []}],
    Defaults = [{8, master_targets, []},
		{9, round_begin, []}, {10, before_atk, []},
		{11, before_def, []}, {12, hurt, []},
		{13, at_atking, []}, {14, at_defing, []},
		{15, after_def, []}, {16, after_atk, []},
		{17, ext_hurt, []}, {18, round_end, []},
		{19, slave_targets, []}, {20, all_buffs, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbcombatround, Decoded);
decode(pbcombattarget, Bytes) when is_binary(Bytes) ->
    Types = [{3, target_type, int32, []},
	     {2, pos, int32, []}, {1, id, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbcombattarget, Decoded);
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
decode(pbskill, Bytes) when is_binary(Bytes) ->
    Types = [{7, type, int32, []},
	     {6, sigil, int32, [repeated]}, {5, str_lv, int32, []},
	     {4, lv, int32, []}, {3, player_id, int32, []},
	     {2, skill_id, int32, []}, {1, id, int32, []}],
    Defaults = [{6, sigil, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbskill, Decoded);
decode(pbstartcombat, Bytes) when is_binary(Bytes) ->
    Types = [{5, value3, int32, []}, {4, value2, int32, []},
	     {3, value1, int32, []}, {2, type, int32, []},
	     {1, id, int64, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbstartcombat, Decoded).

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

to_record(pbattribute, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbattribute),
						   Record, Name, Val)
			  end,
			  #pbattribute{}, DecodedTuples),
    Record1;
to_record(pbcombatbuff, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbcombatbuff),
						   Record, Name, Val)
			  end,
			  #pbcombatbuff{}, DecodedTuples),
    Record1;
to_record(pbcombateffect, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbcombateffect),
						   Record, Name, Val)
			  end,
			  #pbcombateffect{}, DecodedTuples),
    Record1;
to_record(pbcombatfighter, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbcombatfighter),
						   Record, Name, Val)
			  end,
			  #pbcombatfighter{}, DecodedTuples),
    Record1;
to_record(pbcombathurtattri, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbcombathurtattri),
						   Record, Name, Val)
			  end,
			  #pbcombathurtattri{}, DecodedTuples),
    Record1;
to_record(pbcombatreport, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbcombatreport),
						   Record, Name, Val)
			  end,
			  #pbcombatreport{}, DecodedTuples),
    Record1;
to_record(pbcombatreportlist, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbcombatreportlist),
						   Record, Name, Val)
			  end,
			  #pbcombatreportlist{}, DecodedTuples),
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
to_record(pbcombatround, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbcombatround),
						   Record, Name, Val)
			  end,
			  #pbcombatround{}, DecodedTuples),
    Record1;
to_record(pbcombattarget, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbcombattarget),
						   Record, Name, Val)
			  end,
			  #pbcombattarget{}, DecodedTuples),
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
to_record(pbskill, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields, pbskill),
						   Record, Name, Val)
			  end,
			  #pbskill{}, DecodedTuples),
    Record1;
to_record(pbstartcombat, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbstartcombat),
						   Record, Name, Val)
			  end,
			  #pbstartcombat{}, DecodedTuples),
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

