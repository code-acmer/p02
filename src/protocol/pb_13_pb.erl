-file("src/pb_13_pb.erl", 1).

-module(pb_13_pb).

-export([encode_pbvipreward/1, decode_pbvipreward/1,
	 delimited_decode_pbvipreward/1,
	 encode_pbusernotifyupdate/1,
	 decode_pbusernotifyupdate/1,
	 delimited_decode_pbusernotifyupdate/1,
	 encode_pbuserlist/1, decode_pbuserlist/1,
	 delimited_decode_pbuserlist/1, encode_pbuser/1,
	 decode_pbuser/1, delimited_decode_pbuser/1,
	 encode_pbteamchat/1, decode_pbteamchat/1,
	 delimited_decode_pbteamchat/1, encode_pbteam/1,
	 decode_pbteam/1, delimited_decode_pbteam/1,
	 encode_pbskilllist/1, decode_pbskilllist/1,
	 delimited_decode_pbskilllist/1, encode_pbskill/1,
	 decode_pbskill/1, delimited_decode_pbskill/1,
	 encode_pbsigil/1, decode_pbsigil/1,
	 delimited_decode_pbsigil/1, encode_pbrewarditem/1,
	 decode_pbrewarditem/1, delimited_decode_pbrewarditem/1,
	 encode_pbresult/1, decode_pbresult/1,
	 delimited_decode_pbresult/1, encode_pbpvprobotattr/1,
	 decode_pbpvprobotattr/1,
	 delimited_decode_pbpvprobotattr/1, encode_pbopenboss/1,
	 decode_pbopenboss/1, delimited_decode_pbopenboss/1,
	 encode_pbnoticelist/1, decode_pbnoticelist/1,
	 delimited_decode_pbnoticelist/1, encode_pbnotice/1,
	 decode_pbnotice/1, delimited_decode_pbnotice/1,
	 encode_pbmember/1, decode_pbmember/1,
	 delimited_decode_pbmember/1, encode_pbidstring/1,
	 decode_pbidstring/1, delimited_decode_pbidstring/1,
	 encode_pbid64r/1, decode_pbid64r/1,
	 delimited_decode_pbid64r/1, encode_pbid64list/1,
	 decode_pbid64list/1, delimited_decode_pbid64list/1,
	 encode_pbid64/1, decode_pbid64/1,
	 delimited_decode_pbid64/1, encode_pbid32r/1,
	 decode_pbid32r/1, delimited_decode_pbid32r/1,
	 encode_pbid32/1, decode_pbid32/1,
	 delimited_decode_pbid32/1, encode_pbgoodsinfo/1,
	 decode_pbgoodsinfo/1, delimited_decode_pbgoodsinfo/1,
	 encode_pbgoods/1, decode_pbgoods/1,
	 delimited_decode_pbgoods/1, encode_pbfriend/1,
	 decode_pbfriend/1, delimited_decode_pbfriend/1,
	 encode_pbdungeonreward/1, decode_pbdungeonreward/1,
	 delimited_decode_pbdungeonreward/1,
	 encode_pbcombatreward/1, decode_pbcombatreward/1,
	 delimited_decode_pbcombatreward/1,
	 encode_pbcombatrespon/1, decode_pbcombatrespon/1,
	 delimited_decode_pbcombatrespon/1, encode_pbattribute/1,
	 decode_pbattribute/1, delimited_decode_pbattribute/1,
	 encode_pbarenauserlist/1, decode_pbarenauserlist/1,
	 delimited_decode_pbarenauserlist/1,
	 encode_pbarenauser/1, decode_pbarenauser/1,
	 delimited_decode_pbarenauser/1]).

-export([has_extension/2, extension_size/1,
	 get_extension/2, set_extension/3]).

-export([decode_extensions/1]).

-export([encode/1, decode/2, delimited_decode/2]).

-export([int_to_enum/2, enum_to_int/2]).

-record(pbvipreward, {recv_list}).

-record(pbusernotifyupdate, {type}).

-record(pbuserlist, {user_list}).

-record(pbuser,
	{id, accid, accname, nickname, career, lv, exp, exp_lim,
	 vip_lv, vip_exp, vip_due_time, gold, cash_gold, coin,
	 vigor, vigor_lim, cost, fpt, friends_limit, bag_limit,
	 status, core_id, bind_gold, seal, cross_coin,
	 last_dungeon, is_pass_dungeon, hp, hp_lim, hp_rec, mana,
	 mana_lim, mana_rec, mana_init, fire, water, wood, holy,
	 dark, attack, def, power, timestamp_logout, reward,
	 active_skill_ids, passive_skill_ids, base_friends_limit,
	 beginner_step, login_reward_flag, week_login_days,
	 open_boss_info, combat_point, battle_ability, honor,
	 buy_vigor_times, league_name, league_title,
	 month_login_days, month_login_flag, return_gold,
	 fashion, off_time, league_id, arena_coin, league_seal,
	 first_recharge_flag, q_coin, qq}).

-record(pbteamchat, {player_id, msg}).

-record(pbteam,
	{leaderid, nickname, members, dungeon_id, team_num,
	 challenge_type}).

-record(pbskilllist, {skill_list}).

-record(pbskill,
	{id, skill_id, player_id, lv, str_lv, sigil, type}).

-record(pbsigil, {id, tid}).

-record(pbrewarditem, {id, num, goods_id}).

-record(pbresult, {result}).

-record(pbpvprobotattr,
	{id, robot_id, name, career, lv, battle_ability,
	 skill_1, skill_1_lv, skill_2, skill_2_lv, skill_3,
	 skill_3_lv, skill_4, skill_4_lv, equ_weapon,
	 equ_clothes, equ_shoes, equ_neck, equ_ring, equ_pants,
	 weapon_strengthen, weapon_star, clothes_strengthen,
	 clothes_star, shoes_strengthen, shoes_star,
	 neck_strengthen, neck_star, ring_strengthen, ring_star,
	 pants_strengthen, pants_star}).

-record(pbopenboss,
	{boss_id, today_open_times, open_timestamp}).

-record(pbnoticelist, {notice}).

-record(pbnotice,
	{notice_id, sort_id, type, notice_name, headline, des,
	 show_time, activity_time, function_id}).

-record(pbmember,
	{player_id, nickname, lv, career, state,
	 battle_ability}).

-record(pbidstring, {id}).

-record(pbid64r, {ids}).

-record(pbid64list, {ids}).

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

-record(pbdungeonreward, {goods_id, number}).

-record(pbcombatreward,
	{exp, mon_drop_list, dungeon_reward_list, unique_id,
	 seal, evaluate, point, partners}).

-record(pbcombatrespon, {robot_attri, player_attri}).

-record(pbattribute,
	{hp_lim, hp_cur, mana_lim, mana_cur, hp_rec, mana_rec,
	 attack, def, hit, dodge, crit, anti_crit, stiff,
	 anti_stiff, attack_speed, move_speed, attack_effect,
	 def_effect}).

-record(pbarenauserlist, {list}).

-record(pbarenauser,
	{id, nickname, level, career, core, put_on_skill,
	 skill_list, battle_ability}).

encode([]) -> [];
encode(Records) when is_list(Records) ->
    delimited_encode(Records);
encode(Record) -> encode(element(1, Record), Record).

encode_pbvipreward(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbvipreward(Record)
    when is_record(Record, pbvipreward) ->
    encode(pbvipreward, Record).

encode_pbusernotifyupdate(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_pbusernotifyupdate(Record)
    when is_record(Record, pbusernotifyupdate) ->
    encode(pbusernotifyupdate, Record).

encode_pbuserlist(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbuserlist(Record)
    when is_record(Record, pbuserlist) ->
    encode(pbuserlist, Record).

encode_pbuser(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbuser(Record) when is_record(Record, pbuser) ->
    encode(pbuser, Record).

encode_pbteamchat(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbteamchat(Record)
    when is_record(Record, pbteamchat) ->
    encode(pbteamchat, Record).

encode_pbteam(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbteam(Record) when is_record(Record, pbteam) ->
    encode(pbteam, Record).

encode_pbskilllist(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbskilllist(Record)
    when is_record(Record, pbskilllist) ->
    encode(pbskilllist, Record).

encode_pbskill(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbskill(Record)
    when is_record(Record, pbskill) ->
    encode(pbskill, Record).

encode_pbsigil(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbsigil(Record)
    when is_record(Record, pbsigil) ->
    encode(pbsigil, Record).

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

encode_pbpvprobotattr(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbpvprobotattr(Record)
    when is_record(Record, pbpvprobotattr) ->
    encode(pbpvprobotattr, Record).

encode_pbopenboss(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbopenboss(Record)
    when is_record(Record, pbopenboss) ->
    encode(pbopenboss, Record).

encode_pbnoticelist(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbnoticelist(Record)
    when is_record(Record, pbnoticelist) ->
    encode(pbnoticelist, Record).

encode_pbnotice(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbnotice(Record)
    when is_record(Record, pbnotice) ->
    encode(pbnotice, Record).

encode_pbmember(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbmember(Record)
    when is_record(Record, pbmember) ->
    encode(pbmember, Record).

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

encode_pbid64list(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbid64list(Record)
    when is_record(Record, pbid64list) ->
    encode(pbid64list, Record).

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

encode_pbdungeonreward(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbdungeonreward(Record)
    when is_record(Record, pbdungeonreward) ->
    encode(pbdungeonreward, Record).

encode_pbcombatreward(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbcombatreward(Record)
    when is_record(Record, pbcombatreward) ->
    encode(pbcombatreward, Record).

encode_pbcombatrespon(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbcombatrespon(Record)
    when is_record(Record, pbcombatrespon) ->
    encode(pbcombatrespon, Record).

encode_pbattribute(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbattribute(Record)
    when is_record(Record, pbattribute) ->
    encode(pbattribute, Record).

encode_pbarenauserlist(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbarenauserlist(Record)
    when is_record(Record, pbarenauserlist) ->
    encode(pbarenauserlist, Record).

encode_pbarenauser(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbarenauser(Record)
    when is_record(Record, pbarenauser) ->
    encode(pbarenauser, Record).

encode(pbarenauser, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbarenauser, Record) ->
    [iolist(pbarenauser, Record)
     | encode_extensions(Record)];
encode(pbarenauserlist, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbarenauserlist, Record) ->
    [iolist(pbarenauserlist, Record)
     | encode_extensions(Record)];
encode(pbattribute, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbattribute, Record) ->
    [iolist(pbattribute, Record)
     | encode_extensions(Record)];
encode(pbcombatrespon, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbcombatrespon, Record) ->
    [iolist(pbcombatrespon, Record)
     | encode_extensions(Record)];
encode(pbcombatreward, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbcombatreward, Record) ->
    [iolist(pbcombatreward, Record)
     | encode_extensions(Record)];
encode(pbdungeonreward, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbdungeonreward, Record) ->
    [iolist(pbdungeonreward, Record)
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
encode(pbid64list, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbid64list, Record) ->
    [iolist(pbid64list, Record)
     | encode_extensions(Record)];
encode(pbid64r, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbid64r, Record) ->
    [iolist(pbid64r, Record) | encode_extensions(Record)];
encode(pbidstring, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbidstring, Record) ->
    [iolist(pbidstring, Record)
     | encode_extensions(Record)];
encode(pbmember, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbmember, Record) ->
    [iolist(pbmember, Record) | encode_extensions(Record)];
encode(pbnotice, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbnotice, Record) ->
    [iolist(pbnotice, Record) | encode_extensions(Record)];
encode(pbnoticelist, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbnoticelist, Record) ->
    [iolist(pbnoticelist, Record)
     | encode_extensions(Record)];
encode(pbopenboss, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbopenboss, Record) ->
    [iolist(pbopenboss, Record)
     | encode_extensions(Record)];
encode(pbpvprobotattr, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbpvprobotattr, Record) ->
    [iolist(pbpvprobotattr, Record)
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
encode(pbsigil, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbsigil, Record) ->
    [iolist(pbsigil, Record) | encode_extensions(Record)];
encode(pbskill, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbskill, Record) ->
    [iolist(pbskill, Record) | encode_extensions(Record)];
encode(pbskilllist, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbskilllist, Record) ->
    [iolist(pbskilllist, Record)
     | encode_extensions(Record)];
encode(pbteam, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbteam, Record) ->
    [iolist(pbteam, Record) | encode_extensions(Record)];
encode(pbteamchat, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbteamchat, Record) ->
    [iolist(pbteamchat, Record)
     | encode_extensions(Record)];
encode(pbuser, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbuser, Record) ->
    [iolist(pbuser, Record) | encode_extensions(Record)];
encode(pbuserlist, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbuserlist, Record) ->
    [iolist(pbuserlist, Record)
     | encode_extensions(Record)];
encode(pbusernotifyupdate, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbusernotifyupdate, Record) ->
    [iolist(pbusernotifyupdate, Record)
     | encode_extensions(Record)];
encode(pbvipreward, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbvipreward, Record) ->
    [iolist(pbvipreward, Record)
     | encode_extensions(Record)].

encode_extensions(_) -> [].

delimited_encode(Records) ->
    lists:map(fun (Record) ->
		      IoRec = encode(Record),
		      Size = iolist_size(IoRec),
		      [protobuffs:encode_varint(Size), IoRec]
	      end,
	      Records).

iolist(pbarenauser, Record) ->
    [pack(1, optional,
	  with_default(Record#pbarenauser.id, none), int32, []),
     pack(2, optional,
	  with_default(Record#pbarenauser.nickname, none), string,
	  []),
     pack(3, optional,
	  with_default(Record#pbarenauser.level, none), int32,
	  []),
     pack(4, optional,
	  with_default(Record#pbarenauser.career, none), int32,
	  []),
     pack(5, repeated,
	  with_default(Record#pbarenauser.core, none), pbgoods,
	  []),
     pack(6, repeated,
	  with_default(Record#pbarenauser.put_on_skill, none),
	  int32, []),
     pack(7, repeated,
	  with_default(Record#pbarenauser.skill_list, none),
	  pbskill, []),
     pack(8, optional,
	  with_default(Record#pbarenauser.battle_ability, none),
	  int32, [])];
iolist(pbarenauserlist, Record) ->
    [pack(1, repeated,
	  with_default(Record#pbarenauserlist.list, none),
	  pbarenauser, [])];
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
iolist(pbcombatrespon, Record) ->
    [pack(1, optional,
	  with_default(Record#pbcombatrespon.robot_attri, none),
	  pbpvprobotattr, []),
     pack(2, optional,
	  with_default(Record#pbcombatrespon.player_attri, none),
	  pbfriend, [])];
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
iolist(pbdungeonreward, Record) ->
    [pack(1, optional,
	  with_default(Record#pbdungeonreward.goods_id, none),
	  int32, []),
     pack(2, optional,
	  with_default(Record#pbdungeonreward.number, none),
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
iolist(pbid64list, Record) ->
    [pack(1, repeated,
	  with_default(Record#pbid64list.ids, none), int64, [])];
iolist(pbid64r, Record) ->
    [pack(1, repeated,
	  with_default(Record#pbid64r.ids, none), int64, [])];
iolist(pbidstring, Record) ->
    [pack(1, optional,
	  with_default(Record#pbidstring.id, none), string, [])];
iolist(pbmember, Record) ->
    [pack(1, optional,
	  with_default(Record#pbmember.player_id, none), int64,
	  []),
     pack(2, optional,
	  with_default(Record#pbmember.nickname, none), string,
	  []),
     pack(3, optional,
	  with_default(Record#pbmember.lv, none), int32, []),
     pack(4, optional,
	  with_default(Record#pbmember.career, none), int32, []),
     pack(5, optional,
	  with_default(Record#pbmember.state, none), int32, []),
     pack(6, optional,
	  with_default(Record#pbmember.battle_ability, none),
	  int32, [])];
iolist(pbnotice, Record) ->
    [pack(1, optional,
	  with_default(Record#pbnotice.notice_id, none), int32,
	  []),
     pack(2, optional,
	  with_default(Record#pbnotice.sort_id, none), int32, []),
     pack(3, optional,
	  with_default(Record#pbnotice.type, none), int32, []),
     pack(4, optional,
	  with_default(Record#pbnotice.notice_name, none), string,
	  []),
     pack(5, optional,
	  with_default(Record#pbnotice.headline, none), string,
	  []),
     pack(6, optional,
	  with_default(Record#pbnotice.des, none), string, []),
     pack(7, optional,
	  with_default(Record#pbnotice.show_time, none), string,
	  []),
     pack(8, optional,
	  with_default(Record#pbnotice.activity_time, none),
	  string, []),
     pack(9, optional,
	  with_default(Record#pbnotice.function_id, none), int32,
	  [])];
iolist(pbnoticelist, Record) ->
    [pack(1, repeated,
	  with_default(Record#pbnoticelist.notice, none),
	  pbnotice, [])];
iolist(pbopenboss, Record) ->
    [pack(1, optional,
	  with_default(Record#pbopenboss.boss_id, none), int32,
	  []),
     pack(2, optional,
	  with_default(Record#pbopenboss.today_open_times, none),
	  int32, []),
     pack(3, repeated,
	  with_default(Record#pbopenboss.open_timestamp, none),
	  int32, [])];
iolist(pbpvprobotattr, Record) ->
    [pack(1, optional,
	  with_default(Record#pbpvprobotattr.id, none), int32,
	  []),
     pack(2, optional,
	  with_default(Record#pbpvprobotattr.robot_id, none),
	  int32, []),
     pack(3, optional,
	  with_default(Record#pbpvprobotattr.name, none), string,
	  []),
     pack(4, optional,
	  with_default(Record#pbpvprobotattr.career, none), int32,
	  []),
     pack(5, optional,
	  with_default(Record#pbpvprobotattr.lv, none), int32,
	  []),
     pack(6, optional,
	  with_default(Record#pbpvprobotattr.battle_ability,
		       none),
	  int32, []),
     pack(7, optional,
	  with_default(Record#pbpvprobotattr.skill_1, none),
	  int32, []),
     pack(8, optional,
	  with_default(Record#pbpvprobotattr.skill_1_lv, none),
	  int32, []),
     pack(9, optional,
	  with_default(Record#pbpvprobotattr.skill_2, none),
	  int32, []),
     pack(10, optional,
	  with_default(Record#pbpvprobotattr.skill_2_lv, none),
	  int32, []),
     pack(11, optional,
	  with_default(Record#pbpvprobotattr.skill_3, none),
	  int32, []),
     pack(12, optional,
	  with_default(Record#pbpvprobotattr.skill_3_lv, none),
	  int32, []),
     pack(13, optional,
	  with_default(Record#pbpvprobotattr.skill_4, none),
	  int32, []),
     pack(14, optional,
	  with_default(Record#pbpvprobotattr.skill_4_lv, none),
	  int32, []),
     pack(15, optional,
	  with_default(Record#pbpvprobotattr.equ_weapon, none),
	  int32, []),
     pack(16, optional,
	  with_default(Record#pbpvprobotattr.equ_clothes, none),
	  int32, []),
     pack(17, optional,
	  with_default(Record#pbpvprobotattr.equ_shoes, none),
	  int32, []),
     pack(18, optional,
	  with_default(Record#pbpvprobotattr.equ_neck, none),
	  int32, []),
     pack(19, optional,
	  with_default(Record#pbpvprobotattr.equ_ring, none),
	  int32, []),
     pack(20, optional,
	  with_default(Record#pbpvprobotattr.equ_pants, none),
	  int32, []),
     pack(21, optional,
	  with_default(Record#pbpvprobotattr.weapon_strengthen,
		       none),
	  int32, []),
     pack(22, optional,
	  with_default(Record#pbpvprobotattr.weapon_star, none),
	  int32, []),
     pack(23, optional,
	  with_default(Record#pbpvprobotattr.clothes_strengthen,
		       none),
	  int32, []),
     pack(24, optional,
	  with_default(Record#pbpvprobotattr.clothes_star, none),
	  int32, []),
     pack(25, optional,
	  with_default(Record#pbpvprobotattr.shoes_strengthen,
		       none),
	  int32, []),
     pack(26, optional,
	  with_default(Record#pbpvprobotattr.shoes_star, none),
	  int32, []),
     pack(27, optional,
	  with_default(Record#pbpvprobotattr.neck_strengthen,
		       none),
	  int32, []),
     pack(28, optional,
	  with_default(Record#pbpvprobotattr.neck_star, none),
	  int32, []),
     pack(29, optional,
	  with_default(Record#pbpvprobotattr.ring_strengthen,
		       none),
	  int32, []),
     pack(30, optional,
	  with_default(Record#pbpvprobotattr.ring_star, none),
	  int32, []),
     pack(31, optional,
	  with_default(Record#pbpvprobotattr.pants_strengthen,
		       none),
	  int32, []),
     pack(32, optional,
	  with_default(Record#pbpvprobotattr.pants_star, none),
	  int32, [])];
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
iolist(pbsigil, Record) ->
    [pack(1, optional,
	  with_default(Record#pbsigil.id, none), int32, []),
     pack(2, optional,
	  with_default(Record#pbsigil.tid, none), int32, [])];
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
iolist(pbskilllist, Record) ->
    [pack(1, repeated,
	  with_default(Record#pbskilllist.skill_list, none),
	  pbskill, [])];
iolist(pbteam, Record) ->
    [pack(1, optional,
	  with_default(Record#pbteam.leaderid, none), int64, []),
     pack(2, optional,
	  with_default(Record#pbteam.nickname, none), string, []),
     pack(3, repeated,
	  with_default(Record#pbteam.members, none), pbmember,
	  []),
     pack(4, optional,
	  with_default(Record#pbteam.dungeon_id, none), int32,
	  []),
     pack(5, optional,
	  with_default(Record#pbteam.team_num, none), int32, []),
     pack(6, optional,
	  with_default(Record#pbteam.challenge_type, none), int32,
	  [])];
iolist(pbteamchat, Record) ->
    [pack(1, optional,
	  with_default(Record#pbteamchat.player_id, none), int64,
	  []),
     pack(2, optional,
	  with_default(Record#pbteamchat.msg, none), string, [])];
iolist(pbuser, Record) ->
    [pack(1, optional, with_default(Record#pbuser.id, none),
	  int64, []),
     pack(2, optional,
	  with_default(Record#pbuser.accid, none), string, []),
     pack(3, optional,
	  with_default(Record#pbuser.accname, none), string, []),
     pack(4, optional,
	  with_default(Record#pbuser.nickname, none), string, []),
     pack(5, optional,
	  with_default(Record#pbuser.career, none), int32, []),
     pack(6, optional, with_default(Record#pbuser.lv, none),
	  int32, []),
     pack(7, optional, with_default(Record#pbuser.exp, none),
	  int32, []),
     pack(8, optional,
	  with_default(Record#pbuser.exp_lim, none), int32, []),
     pack(9, optional,
	  with_default(Record#pbuser.vip_lv, none), int32, []),
     pack(10, optional,
	  with_default(Record#pbuser.vip_exp, none), int32, []),
     pack(11, optional,
	  with_default(Record#pbuser.vip_due_time, none), int32,
	  []),
     pack(12, optional,
	  with_default(Record#pbuser.gold, none), int32, []),
     pack(13, optional,
	  with_default(Record#pbuser.cash_gold, none), int32, []),
     pack(14, optional,
	  with_default(Record#pbuser.coin, none), int32, []),
     pack(15, optional,
	  with_default(Record#pbuser.vigor, none), int32, []),
     pack(16, optional,
	  with_default(Record#pbuser.vigor_lim, none), int32, []),
     pack(17, optional,
	  with_default(Record#pbuser.cost, none), int32, []),
     pack(18, optional,
	  with_default(Record#pbuser.fpt, none), int32, []),
     pack(19, optional,
	  with_default(Record#pbuser.friends_limit, none), int32,
	  []),
     pack(20, optional,
	  with_default(Record#pbuser.bag_limit, none), int32, []),
     pack(21, optional,
	  with_default(Record#pbuser.status, none), int32, []),
     pack(22, optional,
	  with_default(Record#pbuser.core_id, none), int64, []),
     pack(23, optional,
	  with_default(Record#pbuser.bind_gold, none), int32, []),
     pack(24, optional,
	  with_default(Record#pbuser.seal, none), int32, []),
     pack(25, optional,
	  with_default(Record#pbuser.cross_coin, none), int32,
	  []),
     pack(31, optional,
	  with_default(Record#pbuser.last_dungeon, none), int64,
	  []),
     pack(32, optional,
	  with_default(Record#pbuser.is_pass_dungeon, none),
	  int32, []),
     pack(41, optional, with_default(Record#pbuser.hp, none),
	  int32, []),
     pack(42, optional,
	  with_default(Record#pbuser.hp_lim, none), int32, []),
     pack(43, optional,
	  with_default(Record#pbuser.hp_rec, none), int32, []),
     pack(44, optional,
	  with_default(Record#pbuser.mana, none), int32, []),
     pack(45, optional,
	  with_default(Record#pbuser.mana_lim, none), int32, []),
     pack(46, optional,
	  with_default(Record#pbuser.mana_rec, none), int32, []),
     pack(47, optional,
	  with_default(Record#pbuser.mana_init, none), int32, []),
     pack(48, optional,
	  with_default(Record#pbuser.fire, none), int32, []),
     pack(49, optional,
	  with_default(Record#pbuser.water, none), int32, []),
     pack(50, optional,
	  with_default(Record#pbuser.wood, none), int32, []),
     pack(51, optional,
	  with_default(Record#pbuser.holy, none), int32, []),
     pack(52, optional,
	  with_default(Record#pbuser.dark, none), int32, []),
     pack(53, optional,
	  with_default(Record#pbuser.attack, none), int32, []),
     pack(54, optional,
	  with_default(Record#pbuser.def, none), int32, []),
     pack(55, optional,
	  with_default(Record#pbuser.power, none), int32, []),
     pack(61, optional,
	  with_default(Record#pbuser.timestamp_logout, none),
	  int32, []),
     pack(62, repeated,
	  with_default(Record#pbuser.reward, none),
	  pbdungeonreward, []),
     pack(63, repeated,
	  with_default(Record#pbuser.active_skill_ids, none),
	  int32, []),
     pack(64, repeated,
	  with_default(Record#pbuser.passive_skill_ids, none),
	  int32, []),
     pack(65, optional,
	  with_default(Record#pbuser.base_friends_limit, none),
	  int32, []),
     pack(66, repeated,
	  with_default(Record#pbuser.beginner_step, none), int32,
	  []),
     pack(67, optional,
	  with_default(Record#pbuser.login_reward_flag, none),
	  int32, []),
     pack(68, optional,
	  with_default(Record#pbuser.week_login_days, none),
	  int32, []),
     pack(69, repeated,
	  with_default(Record#pbuser.open_boss_info, none),
	  pbopenboss, []),
     pack(70, optional,
	  with_default(Record#pbuser.combat_point, none), int32,
	  []),
     pack(71, optional,
	  with_default(Record#pbuser.battle_ability, none), int32,
	  []),
     pack(72, optional,
	  with_default(Record#pbuser.honor, none), int32, []),
     pack(73, optional,
	  with_default(Record#pbuser.buy_vigor_times, none),
	  int32, []),
     pack(74, optional,
	  with_default(Record#pbuser.league_name, none), string,
	  []),
     pack(75, optional,
	  with_default(Record#pbuser.league_title, none), int32,
	  []),
     pack(76, optional,
	  with_default(Record#pbuser.month_login_days, none),
	  int32, []),
     pack(77, optional,
	  with_default(Record#pbuser.month_login_flag, none),
	  int32, []),
     pack(78, optional,
	  with_default(Record#pbuser.return_gold, none), int32,
	  []),
     pack(79, optional,
	  with_default(Record#pbuser.fashion, none), int32, []),
     pack(80, optional,
	  with_default(Record#pbuser.off_time, none), int32, []),
     pack(81, optional,
	  with_default(Record#pbuser.league_id, none), int32, []),
     pack(82, optional,
	  with_default(Record#pbuser.arena_coin, none), int32,
	  []),
     pack(83, optional,
	  with_default(Record#pbuser.league_seal, none), int32,
	  []),
     pack(84, optional,
	  with_default(Record#pbuser.first_recharge_flag, none),
	  int32, []),
     pack(85, optional,
	  with_default(Record#pbuser.q_coin, none), int32, []),
     pack(86, optional, with_default(Record#pbuser.qq, none),
	  string, [])];
iolist(pbuserlist, Record) ->
    [pack(1, repeated,
	  with_default(Record#pbuserlist.user_list, none), pbuser,
	  [])];
iolist(pbusernotifyupdate, Record) ->
    [pack(1, optional,
	  with_default(Record#pbusernotifyupdate.type, none),
	  int32, [])];
iolist(pbvipreward, Record) ->
    [pack(1, repeated,
	  with_default(Record#pbvipreward.recv_list, none), int32,
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

decode_pbvipreward(Bytes) when is_binary(Bytes) ->
    decode(pbvipreward, Bytes).

decode_pbusernotifyupdate(Bytes)
    when is_binary(Bytes) ->
    decode(pbusernotifyupdate, Bytes).

decode_pbuserlist(Bytes) when is_binary(Bytes) ->
    decode(pbuserlist, Bytes).

decode_pbuser(Bytes) when is_binary(Bytes) ->
    decode(pbuser, Bytes).

decode_pbteamchat(Bytes) when is_binary(Bytes) ->
    decode(pbteamchat, Bytes).

decode_pbteam(Bytes) when is_binary(Bytes) ->
    decode(pbteam, Bytes).

decode_pbskilllist(Bytes) when is_binary(Bytes) ->
    decode(pbskilllist, Bytes).

decode_pbskill(Bytes) when is_binary(Bytes) ->
    decode(pbskill, Bytes).

decode_pbsigil(Bytes) when is_binary(Bytes) ->
    decode(pbsigil, Bytes).

decode_pbrewarditem(Bytes) when is_binary(Bytes) ->
    decode(pbrewarditem, Bytes).

decode_pbresult(Bytes) when is_binary(Bytes) ->
    decode(pbresult, Bytes).

decode_pbpvprobotattr(Bytes) when is_binary(Bytes) ->
    decode(pbpvprobotattr, Bytes).

decode_pbopenboss(Bytes) when is_binary(Bytes) ->
    decode(pbopenboss, Bytes).

decode_pbnoticelist(Bytes) when is_binary(Bytes) ->
    decode(pbnoticelist, Bytes).

decode_pbnotice(Bytes) when is_binary(Bytes) ->
    decode(pbnotice, Bytes).

decode_pbmember(Bytes) when is_binary(Bytes) ->
    decode(pbmember, Bytes).

decode_pbidstring(Bytes) when is_binary(Bytes) ->
    decode(pbidstring, Bytes).

decode_pbid64r(Bytes) when is_binary(Bytes) ->
    decode(pbid64r, Bytes).

decode_pbid64list(Bytes) when is_binary(Bytes) ->
    decode(pbid64list, Bytes).

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

decode_pbdungeonreward(Bytes) when is_binary(Bytes) ->
    decode(pbdungeonreward, Bytes).

decode_pbcombatreward(Bytes) when is_binary(Bytes) ->
    decode(pbcombatreward, Bytes).

decode_pbcombatrespon(Bytes) when is_binary(Bytes) ->
    decode(pbcombatrespon, Bytes).

decode_pbattribute(Bytes) when is_binary(Bytes) ->
    decode(pbattribute, Bytes).

decode_pbarenauserlist(Bytes) when is_binary(Bytes) ->
    decode(pbarenauserlist, Bytes).

decode_pbarenauser(Bytes) when is_binary(Bytes) ->
    decode(pbarenauser, Bytes).

delimited_decode_pbarenauser(Bytes) ->
    delimited_decode(pbarenauser, Bytes).

delimited_decode_pbarenauserlist(Bytes) ->
    delimited_decode(pbarenauserlist, Bytes).

delimited_decode_pbattribute(Bytes) ->
    delimited_decode(pbattribute, Bytes).

delimited_decode_pbcombatrespon(Bytes) ->
    delimited_decode(pbcombatrespon, Bytes).

delimited_decode_pbcombatreward(Bytes) ->
    delimited_decode(pbcombatreward, Bytes).

delimited_decode_pbdungeonreward(Bytes) ->
    delimited_decode(pbdungeonreward, Bytes).

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

delimited_decode_pbid64list(Bytes) ->
    delimited_decode(pbid64list, Bytes).

delimited_decode_pbid64r(Bytes) ->
    delimited_decode(pbid64r, Bytes).

delimited_decode_pbidstring(Bytes) ->
    delimited_decode(pbidstring, Bytes).

delimited_decode_pbmember(Bytes) ->
    delimited_decode(pbmember, Bytes).

delimited_decode_pbnotice(Bytes) ->
    delimited_decode(pbnotice, Bytes).

delimited_decode_pbnoticelist(Bytes) ->
    delimited_decode(pbnoticelist, Bytes).

delimited_decode_pbopenboss(Bytes) ->
    delimited_decode(pbopenboss, Bytes).

delimited_decode_pbpvprobotattr(Bytes) ->
    delimited_decode(pbpvprobotattr, Bytes).

delimited_decode_pbresult(Bytes) ->
    delimited_decode(pbresult, Bytes).

delimited_decode_pbrewarditem(Bytes) ->
    delimited_decode(pbrewarditem, Bytes).

delimited_decode_pbsigil(Bytes) ->
    delimited_decode(pbsigil, Bytes).

delimited_decode_pbskill(Bytes) ->
    delimited_decode(pbskill, Bytes).

delimited_decode_pbskilllist(Bytes) ->
    delimited_decode(pbskilllist, Bytes).

delimited_decode_pbteam(Bytes) ->
    delimited_decode(pbteam, Bytes).

delimited_decode_pbteamchat(Bytes) ->
    delimited_decode(pbteamchat, Bytes).

delimited_decode_pbuser(Bytes) ->
    delimited_decode(pbuser, Bytes).

delimited_decode_pbuserlist(Bytes) ->
    delimited_decode(pbuserlist, Bytes).

delimited_decode_pbusernotifyupdate(Bytes) ->
    delimited_decode(pbusernotifyupdate, Bytes).

delimited_decode_pbvipreward(Bytes) ->
    delimited_decode(pbvipreward, Bytes).

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
decode(pbarenauser, Bytes) when is_binary(Bytes) ->
    Types = [{8, battle_ability, int32, []},
	     {7, skill_list, pbskill, [is_record, repeated]},
	     {6, put_on_skill, int32, [repeated]},
	     {5, core, pbgoods, [is_record, repeated]},
	     {4, career, int32, []}, {3, level, int32, []},
	     {2, nickname, string, []}, {1, id, int32, []}],
    Defaults = [{5, core, []}, {6, put_on_skill, []},
		{7, skill_list, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbarenauser, Decoded);
decode(pbarenauserlist, Bytes) when is_binary(Bytes) ->
    Types = [{1, list, pbarenauser, [is_record, repeated]}],
    Defaults = [{1, list, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbarenauserlist, Decoded);
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
decode(pbcombatrespon, Bytes) when is_binary(Bytes) ->
    Types = [{2, player_attri, pbfriend, [is_record]},
	     {1, robot_attri, pbpvprobotattr, [is_record]}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbcombatrespon, Decoded);
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
decode(pbdungeonreward, Bytes) when is_binary(Bytes) ->
    Types = [{2, number, int32, []},
	     {1, goods_id, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbdungeonreward, Decoded);
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
decode(pbid64list, Bytes) when is_binary(Bytes) ->
    Types = [{1, ids, int64, [repeated]}],
    Defaults = [{1, ids, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbid64list, Decoded);
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
decode(pbmember, Bytes) when is_binary(Bytes) ->
    Types = [{6, battle_ability, int32, []},
	     {5, state, int32, []}, {4, career, int32, []},
	     {3, lv, int32, []}, {2, nickname, string, []},
	     {1, player_id, int64, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbmember, Decoded);
decode(pbnotice, Bytes) when is_binary(Bytes) ->
    Types = [{9, function_id, int32, []},
	     {8, activity_time, string, []},
	     {7, show_time, string, []}, {6, des, string, []},
	     {5, headline, string, []}, {4, notice_name, string, []},
	     {3, type, int32, []}, {2, sort_id, int32, []},
	     {1, notice_id, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbnotice, Decoded);
decode(pbnoticelist, Bytes) when is_binary(Bytes) ->
    Types = [{1, notice, pbnotice, [is_record, repeated]}],
    Defaults = [{1, notice, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbnoticelist, Decoded);
decode(pbopenboss, Bytes) when is_binary(Bytes) ->
    Types = [{3, open_timestamp, int32, [repeated]},
	     {2, today_open_times, int32, []},
	     {1, boss_id, int32, []}],
    Defaults = [{3, open_timestamp, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbopenboss, Decoded);
decode(pbpvprobotattr, Bytes) when is_binary(Bytes) ->
    Types = [{32, pants_star, int32, []},
	     {31, pants_strengthen, int32, []},
	     {30, ring_star, int32, []},
	     {29, ring_strengthen, int32, []},
	     {28, neck_star, int32, []},
	     {27, neck_strengthen, int32, []},
	     {26, shoes_star, int32, []},
	     {25, shoes_strengthen, int32, []},
	     {24, clothes_star, int32, []},
	     {23, clothes_strengthen, int32, []},
	     {22, weapon_star, int32, []},
	     {21, weapon_strengthen, int32, []},
	     {20, equ_pants, int32, []}, {19, equ_ring, int32, []},
	     {18, equ_neck, int32, []}, {17, equ_shoes, int32, []},
	     {16, equ_clothes, int32, []},
	     {15, equ_weapon, int32, []},
	     {14, skill_4_lv, int32, []}, {13, skill_4, int32, []},
	     {12, skill_3_lv, int32, []}, {11, skill_3, int32, []},
	     {10, skill_2_lv, int32, []}, {9, skill_2, int32, []},
	     {8, skill_1_lv, int32, []}, {7, skill_1, int32, []},
	     {6, battle_ability, int32, []}, {5, lv, int32, []},
	     {4, career, int32, []}, {3, name, string, []},
	     {2, robot_id, int32, []}, {1, id, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbpvprobotattr, Decoded);
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
decode(pbsigil, Bytes) when is_binary(Bytes) ->
    Types = [{2, tid, int32, []}, {1, id, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbsigil, Decoded);
decode(pbskill, Bytes) when is_binary(Bytes) ->
    Types = [{7, type, int32, []},
	     {6, sigil, int32, [repeated]}, {5, str_lv, int32, []},
	     {4, lv, int32, []}, {3, player_id, int32, []},
	     {2, skill_id, int32, []}, {1, id, int32, []}],
    Defaults = [{6, sigil, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbskill, Decoded);
decode(pbskilllist, Bytes) when is_binary(Bytes) ->
    Types = [{1, skill_list, pbskill,
	      [is_record, repeated]}],
    Defaults = [{1, skill_list, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbskilllist, Decoded);
decode(pbteam, Bytes) when is_binary(Bytes) ->
    Types = [{6, challenge_type, int32, []},
	     {5, team_num, int32, []}, {4, dungeon_id, int32, []},
	     {3, members, pbmember, [is_record, repeated]},
	     {2, nickname, string, []}, {1, leaderid, int64, []}],
    Defaults = [{3, members, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbteam, Decoded);
decode(pbteamchat, Bytes) when is_binary(Bytes) ->
    Types = [{2, msg, string, []},
	     {1, player_id, int64, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbteamchat, Decoded);
decode(pbuser, Bytes) when is_binary(Bytes) ->
    Types = [{86, qq, string, []}, {85, q_coin, int32, []},
	     {84, first_recharge_flag, int32, []},
	     {83, league_seal, int32, []},
	     {82, arena_coin, int32, []}, {81, league_id, int32, []},
	     {80, off_time, int32, []}, {79, fashion, int32, []},
	     {78, return_gold, int32, []},
	     {77, month_login_flag, int32, []},
	     {76, month_login_days, int32, []},
	     {75, league_title, int32, []},
	     {74, league_name, string, []},
	     {73, buy_vigor_times, int32, []},
	     {72, honor, int32, []}, {71, battle_ability, int32, []},
	     {70, combat_point, int32, []},
	     {69, open_boss_info, pbopenboss, [is_record, repeated]},
	     {68, week_login_days, int32, []},
	     {67, login_reward_flag, int32, []},
	     {66, beginner_step, int32, [repeated]},
	     {65, base_friends_limit, int32, []},
	     {64, passive_skill_ids, int32, [repeated]},
	     {63, active_skill_ids, int32, [repeated]},
	     {62, reward, pbdungeonreward, [is_record, repeated]},
	     {61, timestamp_logout, int32, []},
	     {55, power, int32, []}, {54, def, int32, []},
	     {53, attack, int32, []}, {52, dark, int32, []},
	     {51, holy, int32, []}, {50, wood, int32, []},
	     {49, water, int32, []}, {48, fire, int32, []},
	     {47, mana_init, int32, []}, {46, mana_rec, int32, []},
	     {45, mana_lim, int32, []}, {44, mana, int32, []},
	     {43, hp_rec, int32, []}, {42, hp_lim, int32, []},
	     {41, hp, int32, []}, {32, is_pass_dungeon, int32, []},
	     {31, last_dungeon, int64, []},
	     {25, cross_coin, int32, []}, {24, seal, int32, []},
	     {23, bind_gold, int32, []}, {22, core_id, int64, []},
	     {21, status, int32, []}, {20, bag_limit, int32, []},
	     {19, friends_limit, int32, []}, {18, fpt, int32, []},
	     {17, cost, int32, []}, {16, vigor_lim, int32, []},
	     {15, vigor, int32, []}, {14, coin, int32, []},
	     {13, cash_gold, int32, []}, {12, gold, int32, []},
	     {11, vip_due_time, int32, []}, {10, vip_exp, int32, []},
	     {9, vip_lv, int32, []}, {8, exp_lim, int32, []},
	     {7, exp, int32, []}, {6, lv, int32, []},
	     {5, career, int32, []}, {4, nickname, string, []},
	     {3, accname, string, []}, {2, accid, string, []},
	     {1, id, int64, []}],
    Defaults = [{62, reward, []},
		{63, active_skill_ids, []}, {64, passive_skill_ids, []},
		{66, beginner_step, []}, {69, open_boss_info, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbuser, Decoded);
decode(pbuserlist, Bytes) when is_binary(Bytes) ->
    Types = [{1, user_list, pbuser, [is_record, repeated]}],
    Defaults = [{1, user_list, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbuserlist, Decoded);
decode(pbusernotifyupdate, Bytes)
    when is_binary(Bytes) ->
    Types = [{1, type, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbusernotifyupdate, Decoded);
decode(pbvipreward, Bytes) when is_binary(Bytes) ->
    Types = [{1, recv_list, int32, [repeated]}],
    Defaults = [{1, recv_list, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbvipreward, Decoded).

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

to_record(pbarenauser, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbarenauser),
						   Record, Name, Val)
			  end,
			  #pbarenauser{}, DecodedTuples),
    Record1;
to_record(pbarenauserlist, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbarenauserlist),
						   Record, Name, Val)
			  end,
			  #pbarenauserlist{}, DecodedTuples),
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
to_record(pbcombatrespon, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbcombatrespon),
						   Record, Name, Val)
			  end,
			  #pbcombatrespon{}, DecodedTuples),
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
to_record(pbdungeonreward, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbdungeonreward),
						   Record, Name, Val)
			  end,
			  #pbdungeonreward{}, DecodedTuples),
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
to_record(pbid64list, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbid64list),
						   Record, Name, Val)
			  end,
			  #pbid64list{}, DecodedTuples),
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
to_record(pbmember, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbmember),
						   Record, Name, Val)
			  end,
			  #pbmember{}, DecodedTuples),
    Record1;
to_record(pbnotice, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbnotice),
						   Record, Name, Val)
			  end,
			  #pbnotice{}, DecodedTuples),
    Record1;
to_record(pbnoticelist, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbnoticelist),
						   Record, Name, Val)
			  end,
			  #pbnoticelist{}, DecodedTuples),
    Record1;
to_record(pbopenboss, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbopenboss),
						   Record, Name, Val)
			  end,
			  #pbopenboss{}, DecodedTuples),
    Record1;
to_record(pbpvprobotattr, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbpvprobotattr),
						   Record, Name, Val)
			  end,
			  #pbpvprobotattr{}, DecodedTuples),
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
to_record(pbsigil, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields, pbsigil),
						   Record, Name, Val)
			  end,
			  #pbsigil{}, DecodedTuples),
    Record1;
to_record(pbskill, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields, pbskill),
						   Record, Name, Val)
			  end,
			  #pbskill{}, DecodedTuples),
    Record1;
to_record(pbskilllist, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbskilllist),
						   Record, Name, Val)
			  end,
			  #pbskilllist{}, DecodedTuples),
    Record1;
to_record(pbteam, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields, pbteam),
						   Record, Name, Val)
			  end,
			  #pbteam{}, DecodedTuples),
    Record1;
to_record(pbteamchat, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbteamchat),
						   Record, Name, Val)
			  end,
			  #pbteamchat{}, DecodedTuples),
    Record1;
to_record(pbuser, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields, pbuser),
						   Record, Name, Val)
			  end,
			  #pbuser{}, DecodedTuples),
    Record1;
to_record(pbuserlist, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbuserlist),
						   Record, Name, Val)
			  end,
			  #pbuserlist{}, DecodedTuples),
    Record1;
to_record(pbusernotifyupdate, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbusernotifyupdate),
						   Record, Name, Val)
			  end,
			  #pbusernotifyupdate{}, DecodedTuples),
    Record1;
to_record(pbvipreward, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbvipreward),
						   Record, Name, Val)
			  end,
			  #pbvipreward{}, DecodedTuples),
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

