-file("src/pb_12_pb.erl", 1).

-module(pb_12_pb).

-export([encode_pbwinrate/1, decode_pbwinrate/1,
	 delimited_decode_pbwinrate/1, encode_pbwavemonster/1,
	 decode_pbwavemonster/1,
	 delimited_decode_pbwavemonster/1,
	 encode_pbwavecreature/1, decode_pbwavecreature/1,
	 delimited_decode_pbwavecreature/1,
	 encode_pbsubdungeon/1, decode_pbsubdungeon/1,
	 delimited_decode_pbsubdungeon/1,
	 encode_pbsourcedungeoninfo/1,
	 decode_pbsourcedungeoninfo/1,
	 delimited_decode_pbsourcedungeoninfo/1,
	 encode_pbsourcedungeon/1, decode_pbsourcedungeon/1,
	 delimited_decode_pbsourcedungeon/1, encode_pbskill/1,
	 decode_pbskill/1, delimited_decode_pbskill/1,
	 encode_pbrewarditem/1, decode_pbrewarditem/1,
	 delimited_decode_pbrewarditem/1, encode_pbresult/1,
	 decode_pbresult/1, delimited_decode_pbresult/1,
	 encode_pbmugenchallenge/1, decode_pbmugenchallenge/1,
	 delimited_decode_pbmugenchallenge/1,
	 encode_pbmopuplist/1, decode_pbmopuplist/1,
	 delimited_decode_pbmopuplist/1, encode_pbmopup/1,
	 decode_pbmopup/1, delimited_decode_pbmopup/1,
	 encode_pbmonsterdrop/1, decode_pbmonsterdrop/1,
	 delimited_decode_pbmonsterdrop/1, encode_pbidstring/1,
	 decode_pbidstring/1, delimited_decode_pbidstring/1,
	 encode_pbid64r/1, decode_pbid64r/1,
	 delimited_decode_pbid64r/1, encode_pbid64/1,
	 decode_pbid64/1, delimited_decode_pbid64/1,
	 encode_pbid32r/1, decode_pbid32r/1,
	 delimited_decode_pbid32r/1, encode_pbid32/1,
	 decode_pbid32/1, delimited_decode_pbid32/1,
	 encode_pbhitrewarddetail/1, decode_pbhitrewarddetail/1,
	 delimited_decode_pbhitrewarddetail/1,
	 encode_pbgoodsinfo/1, decode_pbgoodsinfo/1,
	 delimited_decode_pbgoodsinfo/1, encode_pbgoods/1,
	 decode_pbgoods/1, delimited_decode_pbgoods/1,
	 encode_pbfriend/1, decode_pbfriend/1,
	 delimited_decode_pbfriend/1, encode_pbflipcard/1,
	 decode_pbflipcard/1, delimited_decode_pbflipcard/1,
	 encode_pbdungeontarget/1, decode_pbdungeontarget/1,
	 delimited_decode_pbdungeontarget/1,
	 encode_pbdungeonschedulelist/1,
	 decode_pbdungeonschedulelist/1,
	 delimited_decode_pbdungeonschedulelist/1,
	 encode_pbdungeonschedule/1, decode_pbdungeonschedule/1,
	 delimited_decode_pbdungeonschedule/1,
	 encode_pbdungeonreward/1, decode_pbdungeonreward/1,
	 delimited_decode_pbdungeonreward/1,
	 encode_pbdungeonmonster/1, decode_pbdungeonmonster/1,
	 delimited_decode_pbdungeonmonster/1,
	 encode_pbdungeoncreature/1, decode_pbdungeoncreature/1,
	 delimited_decode_pbdungeoncreature/1,
	 encode_pbdungeoncondition/1,
	 decode_pbdungeoncondition/1,
	 delimited_decode_pbdungeoncondition/1,
	 encode_pbdungeon/1, decode_pbdungeon/1,
	 delimited_decode_pbdungeon/1, encode_pbdailydungeon/1,
	 decode_pbdailydungeon/1,
	 delimited_decode_pbdailydungeon/1,
	 encode_pbcreaturedrop/1, decode_pbcreaturedrop/1,
	 delimited_decode_pbcreaturedrop/1,
	 encode_pbcombatreward/1, decode_pbcombatreward/1,
	 delimited_decode_pbcombatreward/1,
	 encode_pbchallengedungeonrank/1,
	 decode_pbchallengedungeonrank/1,
	 delimited_decode_pbchallengedungeonrank/1,
	 encode_pbchallengedungeoninfo/1,
	 decode_pbchallengedungeoninfo/1,
	 delimited_decode_pbchallengedungeoninfo/1,
	 encode_pbchallengedungeon/1,
	 decode_pbchallengedungeon/1,
	 delimited_decode_pbchallengedungeon/1,
	 encode_pbattribute/1, decode_pbattribute/1,
	 delimited_decode_pbattribute/1]).

-export([has_extension/2, extension_size/1,
	 get_extension/2, set_extension/3]).

-export([decode_extensions/1]).

-export([encode/1, decode/2, delimited_decode/2]).

-export([int_to_enum/2, enum_to_int/2]).

-record(pbwinrate, {win_times, fail_times, win_rate}).

-record(pbwavemonster, {id, monster_info}).

-record(pbwavecreature, {id, creature_info}).

-record(pbsubdungeon,
	{id, create_portal, wave_monster, wave_creature}).

-record(pbsourcedungeoninfo, {type, left_times}).

-record(pbsourcedungeon, {info}).

-record(pbskill,
	{id, skill_id, player_id, lv, str_lv, sigil, type}).

-record(pbrewarditem, {id, num, goods_id}).

-record(pbresult, {result}).

-record(pbmugenchallenge, {player_id, level}).

-record(pbmopuplist,
	{dungeon_id, times, flip_pay_card, mop_up_info}).

-record(pbmopup,
	{normal_reward, boss_reward, free_card_reward,
	 pay_card_reward}).

-record(pbmonsterdrop, {goods_id, number}).

-record(pbidstring, {id}).

-record(pbid64r, {ids}).

-record(pbid64, {id}).

-record(pbid32r, {id}).

-record(pbid32, {id}).

-record(pbhitrewarddetail, {combo, number}).

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

-record(pbflipcard,
	{dungeon_id, card_type, reward, pos}).

-record(pbdungeontarget,
	{dungeon_id, target_list, dungeon_level, left_times,
	 buy_times, best_grade, done}).

-record(pbdungeonschedulelist, {update_list}).

-record(pbdungeonschedule,
	{dungeon_id, last_dungeon, state, target_info}).

-record(pbdungeonreward, {goods_id, number}).

-record(pbdungeonmonster,
	{monster_id, monster_drop, create_id}).

-record(pbdungeoncreature,
	{create_id, creature_drop, creature_id}).

-record(pbdungeoncondition,
	{time, damage, hurt, combo, aircombo, skillcancel,
	 crit}).

-record(pbdungeon,
	{id, type, is_extra, reward, extra_reward,
	 special_reward, state, activity_dungeon_reward,
	 dungeon_info, sub_route, score, pass_time, relive_times,
	 team_num, team_type, cur_sub_dungeon, boss_flag,
	 team_flag, target_list, hit_reward, hit_reward_detail}).

-record(pbdailydungeon,
	{dungeon, condition, pass_flag, left_times}).

-record(pbcreaturedrop, {goods_id, number}).

-record(pbcombatreward,
	{exp, mon_drop_list, dungeon_reward_list, unique_id,
	 seal, evaluate, point, partners}).

-record(pbchallengedungeonrank, {rank_list, self}).

-record(pbchallengedungeoninfo,
	{id, name, lv, career, have_pass_times, score, rank,
	 battle_ability}).

-record(pbchallengedungeon,
	{dungeon_id, next_dungeon_id, type, reward, state,
	 score, left_times, have_pass_times, sub_route,
	 condition, challenge_times, challenge_list,
	 send_lucky_coin, use_lucky_coin, max_pass_times,
	 skip_mugen_flag, cur_hp, buy_times, ability}).

-record(pbattribute,
	{hp_lim, hp_cur, mana_lim, mana_cur, hp_rec, mana_rec,
	 attack, def, hit, dodge, crit, anti_crit, stiff,
	 anti_stiff, attack_speed, move_speed, attack_effect,
	 def_effect}).

encode([]) -> [];
encode(Records) when is_list(Records) ->
    delimited_encode(Records);
encode(Record) -> encode(element(1, Record), Record).

encode_pbwinrate(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbwinrate(Record)
    when is_record(Record, pbwinrate) ->
    encode(pbwinrate, Record).

encode_pbwavemonster(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbwavemonster(Record)
    when is_record(Record, pbwavemonster) ->
    encode(pbwavemonster, Record).

encode_pbwavecreature(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbwavecreature(Record)
    when is_record(Record, pbwavecreature) ->
    encode(pbwavecreature, Record).

encode_pbsubdungeon(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbsubdungeon(Record)
    when is_record(Record, pbsubdungeon) ->
    encode(pbsubdungeon, Record).

encode_pbsourcedungeoninfo(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_pbsourcedungeoninfo(Record)
    when is_record(Record, pbsourcedungeoninfo) ->
    encode(pbsourcedungeoninfo, Record).

encode_pbsourcedungeon(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbsourcedungeon(Record)
    when is_record(Record, pbsourcedungeon) ->
    encode(pbsourcedungeon, Record).

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

encode_pbmugenchallenge(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_pbmugenchallenge(Record)
    when is_record(Record, pbmugenchallenge) ->
    encode(pbmugenchallenge, Record).

encode_pbmopuplist(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbmopuplist(Record)
    when is_record(Record, pbmopuplist) ->
    encode(pbmopuplist, Record).

encode_pbmopup(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbmopup(Record)
    when is_record(Record, pbmopup) ->
    encode(pbmopup, Record).

encode_pbmonsterdrop(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbmonsterdrop(Record)
    when is_record(Record, pbmonsterdrop) ->
    encode(pbmonsterdrop, Record).

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

encode_pbhitrewarddetail(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_pbhitrewarddetail(Record)
    when is_record(Record, pbhitrewarddetail) ->
    encode(pbhitrewarddetail, Record).

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

encode_pbflipcard(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbflipcard(Record)
    when is_record(Record, pbflipcard) ->
    encode(pbflipcard, Record).

encode_pbdungeontarget(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbdungeontarget(Record)
    when is_record(Record, pbdungeontarget) ->
    encode(pbdungeontarget, Record).

encode_pbdungeonschedulelist(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_pbdungeonschedulelist(Record)
    when is_record(Record, pbdungeonschedulelist) ->
    encode(pbdungeonschedulelist, Record).

encode_pbdungeonschedule(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_pbdungeonschedule(Record)
    when is_record(Record, pbdungeonschedule) ->
    encode(pbdungeonschedule, Record).

encode_pbdungeonreward(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbdungeonreward(Record)
    when is_record(Record, pbdungeonreward) ->
    encode(pbdungeonreward, Record).

encode_pbdungeonmonster(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_pbdungeonmonster(Record)
    when is_record(Record, pbdungeonmonster) ->
    encode(pbdungeonmonster, Record).

encode_pbdungeoncreature(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_pbdungeoncreature(Record)
    when is_record(Record, pbdungeoncreature) ->
    encode(pbdungeoncreature, Record).

encode_pbdungeoncondition(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_pbdungeoncondition(Record)
    when is_record(Record, pbdungeoncondition) ->
    encode(pbdungeoncondition, Record).

encode_pbdungeon(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbdungeon(Record)
    when is_record(Record, pbdungeon) ->
    encode(pbdungeon, Record).

encode_pbdailydungeon(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbdailydungeon(Record)
    when is_record(Record, pbdailydungeon) ->
    encode(pbdailydungeon, Record).

encode_pbcreaturedrop(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbcreaturedrop(Record)
    when is_record(Record, pbcreaturedrop) ->
    encode(pbcreaturedrop, Record).

encode_pbcombatreward(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbcombatreward(Record)
    when is_record(Record, pbcombatreward) ->
    encode(pbcombatreward, Record).

encode_pbchallengedungeonrank(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_pbchallengedungeonrank(Record)
    when is_record(Record, pbchallengedungeonrank) ->
    encode(pbchallengedungeonrank, Record).

encode_pbchallengedungeoninfo(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_pbchallengedungeoninfo(Record)
    when is_record(Record, pbchallengedungeoninfo) ->
    encode(pbchallengedungeoninfo, Record).

encode_pbchallengedungeon(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_pbchallengedungeon(Record)
    when is_record(Record, pbchallengedungeon) ->
    encode(pbchallengedungeon, Record).

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
encode(pbchallengedungeon, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbchallengedungeon, Record) ->
    [iolist(pbchallengedungeon, Record)
     | encode_extensions(Record)];
encode(pbchallengedungeoninfo, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbchallengedungeoninfo, Record) ->
    [iolist(pbchallengedungeoninfo, Record)
     | encode_extensions(Record)];
encode(pbchallengedungeonrank, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbchallengedungeonrank, Record) ->
    [iolist(pbchallengedungeonrank, Record)
     | encode_extensions(Record)];
encode(pbcombatreward, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbcombatreward, Record) ->
    [iolist(pbcombatreward, Record)
     | encode_extensions(Record)];
encode(pbcreaturedrop, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbcreaturedrop, Record) ->
    [iolist(pbcreaturedrop, Record)
     | encode_extensions(Record)];
encode(pbdailydungeon, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbdailydungeon, Record) ->
    [iolist(pbdailydungeon, Record)
     | encode_extensions(Record)];
encode(pbdungeon, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbdungeon, Record) ->
    [iolist(pbdungeon, Record) | encode_extensions(Record)];
encode(pbdungeoncondition, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbdungeoncondition, Record) ->
    [iolist(pbdungeoncondition, Record)
     | encode_extensions(Record)];
encode(pbdungeoncreature, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbdungeoncreature, Record) ->
    [iolist(pbdungeoncreature, Record)
     | encode_extensions(Record)];
encode(pbdungeonmonster, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbdungeonmonster, Record) ->
    [iolist(pbdungeonmonster, Record)
     | encode_extensions(Record)];
encode(pbdungeonreward, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbdungeonreward, Record) ->
    [iolist(pbdungeonreward, Record)
     | encode_extensions(Record)];
encode(pbdungeonschedule, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbdungeonschedule, Record) ->
    [iolist(pbdungeonschedule, Record)
     | encode_extensions(Record)];
encode(pbdungeonschedulelist, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbdungeonschedulelist, Record) ->
    [iolist(pbdungeonschedulelist, Record)
     | encode_extensions(Record)];
encode(pbdungeontarget, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbdungeontarget, Record) ->
    [iolist(pbdungeontarget, Record)
     | encode_extensions(Record)];
encode(pbflipcard, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbflipcard, Record) ->
    [iolist(pbflipcard, Record)
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
encode(pbhitrewarddetail, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbhitrewarddetail, Record) ->
    [iolist(pbhitrewarddetail, Record)
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
encode(pbmonsterdrop, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbmonsterdrop, Record) ->
    [iolist(pbmonsterdrop, Record)
     | encode_extensions(Record)];
encode(pbmopup, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbmopup, Record) ->
    [iolist(pbmopup, Record) | encode_extensions(Record)];
encode(pbmopuplist, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbmopuplist, Record) ->
    [iolist(pbmopuplist, Record)
     | encode_extensions(Record)];
encode(pbmugenchallenge, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbmugenchallenge, Record) ->
    [iolist(pbmugenchallenge, Record)
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
encode(pbsourcedungeon, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbsourcedungeon, Record) ->
    [iolist(pbsourcedungeon, Record)
     | encode_extensions(Record)];
encode(pbsourcedungeoninfo, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbsourcedungeoninfo, Record) ->
    [iolist(pbsourcedungeoninfo, Record)
     | encode_extensions(Record)];
encode(pbsubdungeon, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbsubdungeon, Record) ->
    [iolist(pbsubdungeon, Record)
     | encode_extensions(Record)];
encode(pbwavecreature, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbwavecreature, Record) ->
    [iolist(pbwavecreature, Record)
     | encode_extensions(Record)];
encode(pbwavemonster, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbwavemonster, Record) ->
    [iolist(pbwavemonster, Record)
     | encode_extensions(Record)];
encode(pbwinrate, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbwinrate, Record) ->
    [iolist(pbwinrate, Record) | encode_extensions(Record)].

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
iolist(pbchallengedungeon, Record) ->
    [pack(1, optional,
	  with_default(Record#pbchallengedungeon.dungeon_id,
		       none),
	  int32, []),
     pack(2, optional,
	  with_default(Record#pbchallengedungeon.next_dungeon_id,
		       none),
	  int32, []),
     pack(3, optional,
	  with_default(Record#pbchallengedungeon.type, none),
	  int32, []),
     pack(4, repeated,
	  with_default(Record#pbchallengedungeon.reward, none),
	  pbdungeonreward, []),
     pack(5, optional,
	  with_default(Record#pbchallengedungeon.state, none),
	  int32, []),
     pack(6, optional,
	  with_default(Record#pbchallengedungeon.score, none),
	  int32, []),
     pack(7, optional,
	  with_default(Record#pbchallengedungeon.left_times,
		       none),
	  int32, []),
     pack(8, optional,
	  with_default(Record#pbchallengedungeon.have_pass_times,
		       none),
	  int32, []),
     pack(9, optional,
	  with_default(Record#pbchallengedungeon.sub_route, none),
	  int32, []),
     pack(10, repeated,
	  with_default(Record#pbchallengedungeon.condition, none),
	  int32, []),
     pack(11, optional,
	  with_default(Record#pbchallengedungeon.challenge_times,
		       none),
	  int32, []),
     pack(12, repeated,
	  with_default(Record#pbchallengedungeon.challenge_list,
		       none),
	  pbmugenchallenge, []),
     pack(13, optional,
	  with_default(Record#pbchallengedungeon.send_lucky_coin,
		       none),
	  int32, []),
     pack(14, optional,
	  with_default(Record#pbchallengedungeon.use_lucky_coin,
		       none),
	  int32, []),
     pack(15, optional,
	  with_default(Record#pbchallengedungeon.max_pass_times,
		       none),
	  int32, []),
     pack(16, optional,
	  with_default(Record#pbchallengedungeon.skip_mugen_flag,
		       none),
	  int32, []),
     pack(17, optional,
	  with_default(Record#pbchallengedungeon.cur_hp, none),
	  int32, []),
     pack(18, optional,
	  with_default(Record#pbchallengedungeon.buy_times, none),
	  int32, []),
     pack(19, optional,
	  with_default(Record#pbchallengedungeon.ability, none),
	  int32, [])];
iolist(pbchallengedungeoninfo, Record) ->
    [pack(1, optional,
	  with_default(Record#pbchallengedungeoninfo.id, none),
	  int64, []),
     pack(2, optional,
	  with_default(Record#pbchallengedungeoninfo.name, none),
	  string, []),
     pack(3, optional,
	  with_default(Record#pbchallengedungeoninfo.lv, none),
	  int32, []),
     pack(4, optional,
	  with_default(Record#pbchallengedungeoninfo.career,
		       none),
	  int32, []),
     pack(5, optional,
	  with_default(Record#pbchallengedungeoninfo.have_pass_times,
		       none),
	  int32, []),
     pack(6, optional,
	  with_default(Record#pbchallengedungeoninfo.score, none),
	  int32, []),
     pack(7, optional,
	  with_default(Record#pbchallengedungeoninfo.rank, none),
	  int32, []),
     pack(8, optional,
	  with_default(Record#pbchallengedungeoninfo.battle_ability,
		       none),
	  int32, [])];
iolist(pbchallengedungeonrank, Record) ->
    [pack(1, repeated,
	  with_default(Record#pbchallengedungeonrank.rank_list,
		       none),
	  pbchallengedungeoninfo, []),
     pack(2, optional,
	  with_default(Record#pbchallengedungeonrank.self, none),
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
iolist(pbcreaturedrop, Record) ->
    [pack(1, optional,
	  with_default(Record#pbcreaturedrop.goods_id, none),
	  int32, []),
     pack(2, optional,
	  with_default(Record#pbcreaturedrop.number, none), int32,
	  [])];
iolist(pbdailydungeon, Record) ->
    [pack(1, optional,
	  with_default(Record#pbdailydungeon.dungeon, none),
	  pbdungeon, []),
     pack(2, optional,
	  with_default(Record#pbdailydungeon.condition, none),
	  pbdungeoncondition, []),
     pack(3, optional,
	  with_default(Record#pbdailydungeon.pass_flag, none),
	  int32, []),
     pack(4, optional,
	  with_default(Record#pbdailydungeon.left_times, none),
	  int32, [])];
iolist(pbdungeon, Record) ->
    [pack(1, optional,
	  with_default(Record#pbdungeon.id, none), int32, []),
     pack(2, optional,
	  with_default(Record#pbdungeon.type, none), int32, []),
     pack(3, optional,
	  with_default(Record#pbdungeon.is_extra, none), int32,
	  []),
     pack(4, repeated,
	  with_default(Record#pbdungeon.reward, none),
	  pbdungeonreward, []),
     pack(5, repeated,
	  with_default(Record#pbdungeon.extra_reward, none),
	  pbdungeonreward, []),
     pack(6, repeated,
	  with_default(Record#pbdungeon.special_reward, none),
	  pbdungeonreward, []),
     pack(7, optional,
	  with_default(Record#pbdungeon.state, none), int32, []),
     pack(8, repeated,
	  with_default(Record#pbdungeon.activity_dungeon_reward,
		       none),
	  pbdungeonreward, []),
     pack(9, repeated,
	  with_default(Record#pbdungeon.dungeon_info, none),
	  pbsubdungeon, []),
     pack(10, repeated,
	  with_default(Record#pbdungeon.sub_route, none), int32,
	  []),
     pack(11, optional,
	  with_default(Record#pbdungeon.score, none), int32, []),
     pack(12, optional,
	  with_default(Record#pbdungeon.pass_time, none), int32,
	  []),
     pack(13, optional,
	  with_default(Record#pbdungeon.relive_times, none),
	  int32, []),
     pack(14, optional,
	  with_default(Record#pbdungeon.team_num, none), int32,
	  []),
     pack(15, optional,
	  with_default(Record#pbdungeon.team_type, none), int32,
	  []),
     pack(16, optional,
	  with_default(Record#pbdungeon.cur_sub_dungeon, none),
	  int32, []),
     pack(17, optional,
	  with_default(Record#pbdungeon.boss_flag, none), int32,
	  []),
     pack(18, optional,
	  with_default(Record#pbdungeon.team_flag, none), int32,
	  []),
     pack(19, repeated,
	  with_default(Record#pbdungeon.target_list, none), int32,
	  []),
     pack(20, repeated,
	  with_default(Record#pbdungeon.hit_reward, none),
	  pbdungeonreward, []),
     pack(21, repeated,
	  with_default(Record#pbdungeon.hit_reward_detail, none),
	  pbhitrewarddetail, [])];
iolist(pbdungeoncondition, Record) ->
    [pack(1, optional,
	  with_default(Record#pbdungeoncondition.time, none),
	  int32, []),
     pack(2, optional,
	  with_default(Record#pbdungeoncondition.damage, none),
	  int32, []),
     pack(3, optional,
	  with_default(Record#pbdungeoncondition.hurt, none),
	  int32, []),
     pack(4, optional,
	  with_default(Record#pbdungeoncondition.combo, none),
	  int32, []),
     pack(5, optional,
	  with_default(Record#pbdungeoncondition.aircombo, none),
	  int32, []),
     pack(6, optional,
	  with_default(Record#pbdungeoncondition.skillcancel,
		       none),
	  int32, []),
     pack(7, optional,
	  with_default(Record#pbdungeoncondition.crit, none),
	  int32, [])];
iolist(pbdungeoncreature, Record) ->
    [pack(1, optional,
	  with_default(Record#pbdungeoncreature.create_id, none),
	  int32, []),
     pack(2, repeated,
	  with_default(Record#pbdungeoncreature.creature_drop,
		       none),
	  pbcreaturedrop, []),
     pack(3, optional,
	  with_default(Record#pbdungeoncreature.creature_id,
		       none),
	  int32, [])];
iolist(pbdungeonmonster, Record) ->
    [pack(1, optional,
	  with_default(Record#pbdungeonmonster.monster_id, none),
	  int32, []),
     pack(2, repeated,
	  with_default(Record#pbdungeonmonster.monster_drop,
		       none),
	  pbmonsterdrop, []),
     pack(3, optional,
	  with_default(Record#pbdungeonmonster.create_id, none),
	  int32, [])];
iolist(pbdungeonreward, Record) ->
    [pack(1, optional,
	  with_default(Record#pbdungeonreward.goods_id, none),
	  int32, []),
     pack(2, optional,
	  with_default(Record#pbdungeonreward.number, none),
	  int32, [])];
iolist(pbdungeonschedule, Record) ->
    [pack(1, optional,
	  with_default(Record#pbdungeonschedule.dungeon_id, none),
	  int32, []),
     pack(2, optional,
	  with_default(Record#pbdungeonschedule.last_dungeon,
		       none),
	  int32, []),
     pack(3, optional,
	  with_default(Record#pbdungeonschedule.state, none),
	  int32, []),
     pack(4, repeated,
	  with_default(Record#pbdungeonschedule.target_info,
		       none),
	  pbdungeontarget, [])];
iolist(pbdungeonschedulelist, Record) ->
    [pack(1, repeated,
	  with_default(Record#pbdungeonschedulelist.update_list,
		       none),
	  pbdungeonschedule, [])];
iolist(pbdungeontarget, Record) ->
    [pack(1, optional,
	  with_default(Record#pbdungeontarget.dungeon_id, none),
	  int32, []),
     pack(2, repeated,
	  with_default(Record#pbdungeontarget.target_list, none),
	  int32, []),
     pack(3, optional,
	  with_default(Record#pbdungeontarget.dungeon_level,
		       none),
	  int32, []),
     pack(4, optional,
	  with_default(Record#pbdungeontarget.left_times, none),
	  int32, []),
     pack(5, optional,
	  with_default(Record#pbdungeontarget.buy_times, none),
	  int32, []),
     pack(6, optional,
	  with_default(Record#pbdungeontarget.best_grade, none),
	  int32, []),
     pack(7, optional,
	  with_default(Record#pbdungeontarget.done, none), int32,
	  [])];
iolist(pbflipcard, Record) ->
    [pack(1, optional,
	  with_default(Record#pbflipcard.dungeon_id, none), int32,
	  []),
     pack(2, optional,
	  with_default(Record#pbflipcard.card_type, none), int32,
	  []),
     pack(3, optional,
	  with_default(Record#pbflipcard.reward, none),
	  pbdungeonreward, []),
     pack(4, optional,
	  with_default(Record#pbflipcard.pos, none), int32, [])];
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
iolist(pbhitrewarddetail, Record) ->
    [pack(1, optional,
	  with_default(Record#pbhitrewarddetail.combo, none),
	  int32, []),
     pack(2, optional,
	  with_default(Record#pbhitrewarddetail.number, none),
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
iolist(pbmonsterdrop, Record) ->
    [pack(1, optional,
	  with_default(Record#pbmonsterdrop.goods_id, none),
	  int32, []),
     pack(2, optional,
	  with_default(Record#pbmonsterdrop.number, none), int32,
	  [])];
iolist(pbmopup, Record) ->
    [pack(1, repeated,
	  with_default(Record#pbmopup.normal_reward, none),
	  pbdungeonreward, []),
     pack(2, repeated,
	  with_default(Record#pbmopup.boss_reward, none),
	  pbdungeonreward, []),
     pack(3, repeated,
	  with_default(Record#pbmopup.free_card_reward, none),
	  pbdungeonreward, []),
     pack(4, repeated,
	  with_default(Record#pbmopup.pay_card_reward, none),
	  pbdungeonreward, [])];
iolist(pbmopuplist, Record) ->
    [pack(1, optional,
	  with_default(Record#pbmopuplist.dungeon_id, none),
	  int32, []),
     pack(2, optional,
	  with_default(Record#pbmopuplist.times, none), int32,
	  []),
     pack(3, optional,
	  with_default(Record#pbmopuplist.flip_pay_card, none),
	  int32, []),
     pack(4, repeated,
	  with_default(Record#pbmopuplist.mop_up_info, none),
	  pbmopup, [])];
iolist(pbmugenchallenge, Record) ->
    [pack(1, optional,
	  with_default(Record#pbmugenchallenge.player_id, none),
	  int64, []),
     pack(2, optional,
	  with_default(Record#pbmugenchallenge.level, none),
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
iolist(pbsourcedungeon, Record) ->
    [pack(1, repeated,
	  with_default(Record#pbsourcedungeon.info, none),
	  pbsourcedungeoninfo, [])];
iolist(pbsourcedungeoninfo, Record) ->
    [pack(1, optional,
	  with_default(Record#pbsourcedungeoninfo.type, none),
	  int32, []),
     pack(2, optional,
	  with_default(Record#pbsourcedungeoninfo.left_times,
		       none),
	  int32, [])];
iolist(pbsubdungeon, Record) ->
    [pack(1, optional,
	  with_default(Record#pbsubdungeon.id, none), int32, []),
     pack(2, repeated,
	  with_default(Record#pbsubdungeon.create_portal, none),
	  int32, []),
     pack(3, repeated,
	  with_default(Record#pbsubdungeon.wave_monster, none),
	  pbwavemonster, []),
     pack(4, repeated,
	  with_default(Record#pbsubdungeon.wave_creature, none),
	  pbwavecreature, [])];
iolist(pbwavecreature, Record) ->
    [pack(1, optional,
	  with_default(Record#pbwavecreature.id, none), int32,
	  []),
     pack(2, repeated,
	  with_default(Record#pbwavecreature.creature_info, none),
	  pbdungeoncreature, [])];
iolist(pbwavemonster, Record) ->
    [pack(1, optional,
	  with_default(Record#pbwavemonster.id, none), int32, []),
     pack(2, repeated,
	  with_default(Record#pbwavemonster.monster_info, none),
	  pbdungeonmonster, [])];
iolist(pbwinrate, Record) ->
    [pack(1, optional,
	  with_default(Record#pbwinrate.win_times, none), int32,
	  []),
     pack(2, optional,
	  with_default(Record#pbwinrate.fail_times, none), int32,
	  []),
     pack(3, optional,
	  with_default(Record#pbwinrate.win_rate, none), int32,
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

decode_pbwinrate(Bytes) when is_binary(Bytes) ->
    decode(pbwinrate, Bytes).

decode_pbwavemonster(Bytes) when is_binary(Bytes) ->
    decode(pbwavemonster, Bytes).

decode_pbwavecreature(Bytes) when is_binary(Bytes) ->
    decode(pbwavecreature, Bytes).

decode_pbsubdungeon(Bytes) when is_binary(Bytes) ->
    decode(pbsubdungeon, Bytes).

decode_pbsourcedungeoninfo(Bytes)
    when is_binary(Bytes) ->
    decode(pbsourcedungeoninfo, Bytes).

decode_pbsourcedungeon(Bytes) when is_binary(Bytes) ->
    decode(pbsourcedungeon, Bytes).

decode_pbskill(Bytes) when is_binary(Bytes) ->
    decode(pbskill, Bytes).

decode_pbrewarditem(Bytes) when is_binary(Bytes) ->
    decode(pbrewarditem, Bytes).

decode_pbresult(Bytes) when is_binary(Bytes) ->
    decode(pbresult, Bytes).

decode_pbmugenchallenge(Bytes) when is_binary(Bytes) ->
    decode(pbmugenchallenge, Bytes).

decode_pbmopuplist(Bytes) when is_binary(Bytes) ->
    decode(pbmopuplist, Bytes).

decode_pbmopup(Bytes) when is_binary(Bytes) ->
    decode(pbmopup, Bytes).

decode_pbmonsterdrop(Bytes) when is_binary(Bytes) ->
    decode(pbmonsterdrop, Bytes).

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

decode_pbhitrewarddetail(Bytes) when is_binary(Bytes) ->
    decode(pbhitrewarddetail, Bytes).

decode_pbgoodsinfo(Bytes) when is_binary(Bytes) ->
    decode(pbgoodsinfo, Bytes).

decode_pbgoods(Bytes) when is_binary(Bytes) ->
    decode(pbgoods, Bytes).

decode_pbfriend(Bytes) when is_binary(Bytes) ->
    decode(pbfriend, Bytes).

decode_pbflipcard(Bytes) when is_binary(Bytes) ->
    decode(pbflipcard, Bytes).

decode_pbdungeontarget(Bytes) when is_binary(Bytes) ->
    decode(pbdungeontarget, Bytes).

decode_pbdungeonschedulelist(Bytes)
    when is_binary(Bytes) ->
    decode(pbdungeonschedulelist, Bytes).

decode_pbdungeonschedule(Bytes) when is_binary(Bytes) ->
    decode(pbdungeonschedule, Bytes).

decode_pbdungeonreward(Bytes) when is_binary(Bytes) ->
    decode(pbdungeonreward, Bytes).

decode_pbdungeonmonster(Bytes) when is_binary(Bytes) ->
    decode(pbdungeonmonster, Bytes).

decode_pbdungeoncreature(Bytes) when is_binary(Bytes) ->
    decode(pbdungeoncreature, Bytes).

decode_pbdungeoncondition(Bytes)
    when is_binary(Bytes) ->
    decode(pbdungeoncondition, Bytes).

decode_pbdungeon(Bytes) when is_binary(Bytes) ->
    decode(pbdungeon, Bytes).

decode_pbdailydungeon(Bytes) when is_binary(Bytes) ->
    decode(pbdailydungeon, Bytes).

decode_pbcreaturedrop(Bytes) when is_binary(Bytes) ->
    decode(pbcreaturedrop, Bytes).

decode_pbcombatreward(Bytes) when is_binary(Bytes) ->
    decode(pbcombatreward, Bytes).

decode_pbchallengedungeonrank(Bytes)
    when is_binary(Bytes) ->
    decode(pbchallengedungeonrank, Bytes).

decode_pbchallengedungeoninfo(Bytes)
    when is_binary(Bytes) ->
    decode(pbchallengedungeoninfo, Bytes).

decode_pbchallengedungeon(Bytes)
    when is_binary(Bytes) ->
    decode(pbchallengedungeon, Bytes).

decode_pbattribute(Bytes) when is_binary(Bytes) ->
    decode(pbattribute, Bytes).

delimited_decode_pbattribute(Bytes) ->
    delimited_decode(pbattribute, Bytes).

delimited_decode_pbchallengedungeon(Bytes) ->
    delimited_decode(pbchallengedungeon, Bytes).

delimited_decode_pbchallengedungeoninfo(Bytes) ->
    delimited_decode(pbchallengedungeoninfo, Bytes).

delimited_decode_pbchallengedungeonrank(Bytes) ->
    delimited_decode(pbchallengedungeonrank, Bytes).

delimited_decode_pbcombatreward(Bytes) ->
    delimited_decode(pbcombatreward, Bytes).

delimited_decode_pbcreaturedrop(Bytes) ->
    delimited_decode(pbcreaturedrop, Bytes).

delimited_decode_pbdailydungeon(Bytes) ->
    delimited_decode(pbdailydungeon, Bytes).

delimited_decode_pbdungeon(Bytes) ->
    delimited_decode(pbdungeon, Bytes).

delimited_decode_pbdungeoncondition(Bytes) ->
    delimited_decode(pbdungeoncondition, Bytes).

delimited_decode_pbdungeoncreature(Bytes) ->
    delimited_decode(pbdungeoncreature, Bytes).

delimited_decode_pbdungeonmonster(Bytes) ->
    delimited_decode(pbdungeonmonster, Bytes).

delimited_decode_pbdungeonreward(Bytes) ->
    delimited_decode(pbdungeonreward, Bytes).

delimited_decode_pbdungeonschedule(Bytes) ->
    delimited_decode(pbdungeonschedule, Bytes).

delimited_decode_pbdungeonschedulelist(Bytes) ->
    delimited_decode(pbdungeonschedulelist, Bytes).

delimited_decode_pbdungeontarget(Bytes) ->
    delimited_decode(pbdungeontarget, Bytes).

delimited_decode_pbflipcard(Bytes) ->
    delimited_decode(pbflipcard, Bytes).

delimited_decode_pbfriend(Bytes) ->
    delimited_decode(pbfriend, Bytes).

delimited_decode_pbgoods(Bytes) ->
    delimited_decode(pbgoods, Bytes).

delimited_decode_pbgoodsinfo(Bytes) ->
    delimited_decode(pbgoodsinfo, Bytes).

delimited_decode_pbhitrewarddetail(Bytes) ->
    delimited_decode(pbhitrewarddetail, Bytes).

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

delimited_decode_pbmonsterdrop(Bytes) ->
    delimited_decode(pbmonsterdrop, Bytes).

delimited_decode_pbmopup(Bytes) ->
    delimited_decode(pbmopup, Bytes).

delimited_decode_pbmopuplist(Bytes) ->
    delimited_decode(pbmopuplist, Bytes).

delimited_decode_pbmugenchallenge(Bytes) ->
    delimited_decode(pbmugenchallenge, Bytes).

delimited_decode_pbresult(Bytes) ->
    delimited_decode(pbresult, Bytes).

delimited_decode_pbrewarditem(Bytes) ->
    delimited_decode(pbrewarditem, Bytes).

delimited_decode_pbskill(Bytes) ->
    delimited_decode(pbskill, Bytes).

delimited_decode_pbsourcedungeon(Bytes) ->
    delimited_decode(pbsourcedungeon, Bytes).

delimited_decode_pbsourcedungeoninfo(Bytes) ->
    delimited_decode(pbsourcedungeoninfo, Bytes).

delimited_decode_pbsubdungeon(Bytes) ->
    delimited_decode(pbsubdungeon, Bytes).

delimited_decode_pbwavecreature(Bytes) ->
    delimited_decode(pbwavecreature, Bytes).

delimited_decode_pbwavemonster(Bytes) ->
    delimited_decode(pbwavemonster, Bytes).

delimited_decode_pbwinrate(Bytes) ->
    delimited_decode(pbwinrate, Bytes).

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
decode(pbchallengedungeon, Bytes)
    when is_binary(Bytes) ->
    Types = [{19, ability, int32, []},
	     {18, buy_times, int32, []}, {17, cur_hp, int32, []},
	     {16, skip_mugen_flag, int32, []},
	     {15, max_pass_times, int32, []},
	     {14, use_lucky_coin, int32, []},
	     {13, send_lucky_coin, int32, []},
	     {12, challenge_list, pbmugenchallenge,
	      [is_record, repeated]},
	     {11, challenge_times, int32, []},
	     {10, condition, int32, [repeated]},
	     {9, sub_route, int32, []},
	     {8, have_pass_times, int32, []},
	     {7, left_times, int32, []}, {6, score, int32, []},
	     {5, state, int32, []},
	     {4, reward, pbdungeonreward, [is_record, repeated]},
	     {3, type, int32, []}, {2, next_dungeon_id, int32, []},
	     {1, dungeon_id, int32, []}],
    Defaults = [{4, reward, []}, {10, condition, []},
		{12, challenge_list, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbchallengedungeon, Decoded);
decode(pbchallengedungeoninfo, Bytes)
    when is_binary(Bytes) ->
    Types = [{8, battle_ability, int32, []},
	     {7, rank, int32, []}, {6, score, int32, []},
	     {5, have_pass_times, int32, []}, {4, career, int32, []},
	     {3, lv, int32, []}, {2, name, string, []},
	     {1, id, int64, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbchallengedungeoninfo, Decoded);
decode(pbchallengedungeonrank, Bytes)
    when is_binary(Bytes) ->
    Types = [{2, self, int32, []},
	     {1, rank_list, pbchallengedungeoninfo,
	      [is_record, repeated]}],
    Defaults = [{1, rank_list, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbchallengedungeonrank, Decoded);
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
decode(pbcreaturedrop, Bytes) when is_binary(Bytes) ->
    Types = [{2, number, int32, []},
	     {1, goods_id, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbcreaturedrop, Decoded);
decode(pbdailydungeon, Bytes) when is_binary(Bytes) ->
    Types = [{4, left_times, int32, []},
	     {3, pass_flag, int32, []},
	     {2, condition, pbdungeoncondition, [is_record]},
	     {1, dungeon, pbdungeon, [is_record]}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbdailydungeon, Decoded);
decode(pbdungeon, Bytes) when is_binary(Bytes) ->
    Types = [{21, hit_reward_detail, pbhitrewarddetail,
	      [is_record, repeated]},
	     {20, hit_reward, pbdungeonreward,
	      [is_record, repeated]},
	     {19, target_list, int32, [repeated]},
	     {18, team_flag, int32, []}, {17, boss_flag, int32, []},
	     {16, cur_sub_dungeon, int32, []},
	     {15, team_type, int32, []}, {14, team_num, int32, []},
	     {13, relive_times, int32, []},
	     {12, pass_time, int32, []}, {11, score, int32, []},
	     {10, sub_route, int32, [repeated]},
	     {9, dungeon_info, pbsubdungeon, [is_record, repeated]},
	     {8, activity_dungeon_reward, pbdungeonreward,
	      [is_record, repeated]},
	     {7, state, int32, []},
	     {6, special_reward, pbdungeonreward,
	      [is_record, repeated]},
	     {5, extra_reward, pbdungeonreward,
	      [is_record, repeated]},
	     {4, reward, pbdungeonreward, [is_record, repeated]},
	     {3, is_extra, int32, []}, {2, type, int32, []},
	     {1, id, int32, []}],
    Defaults = [{4, reward, []}, {5, extra_reward, []},
		{6, special_reward, []},
		{8, activity_dungeon_reward, []}, {9, dungeon_info, []},
		{10, sub_route, []}, {19, target_list, []},
		{20, hit_reward, []}, {21, hit_reward_detail, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbdungeon, Decoded);
decode(pbdungeoncondition, Bytes)
    when is_binary(Bytes) ->
    Types = [{7, crit, int32, []},
	     {6, skillcancel, int32, []}, {5, aircombo, int32, []},
	     {4, combo, int32, []}, {3, hurt, int32, []},
	     {2, damage, int32, []}, {1, time, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbdungeoncondition, Decoded);
decode(pbdungeoncreature, Bytes)
    when is_binary(Bytes) ->
    Types = [{3, creature_id, int32, []},
	     {2, creature_drop, pbcreaturedrop,
	      [is_record, repeated]},
	     {1, create_id, int32, []}],
    Defaults = [{2, creature_drop, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbdungeoncreature, Decoded);
decode(pbdungeonmonster, Bytes) when is_binary(Bytes) ->
    Types = [{3, create_id, int32, []},
	     {2, monster_drop, pbmonsterdrop, [is_record, repeated]},
	     {1, monster_id, int32, []}],
    Defaults = [{2, monster_drop, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbdungeonmonster, Decoded);
decode(pbdungeonreward, Bytes) when is_binary(Bytes) ->
    Types = [{2, number, int32, []},
	     {1, goods_id, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbdungeonreward, Decoded);
decode(pbdungeonschedule, Bytes)
    when is_binary(Bytes) ->
    Types = [{4, target_info, pbdungeontarget,
	      [is_record, repeated]},
	     {3, state, int32, []}, {2, last_dungeon, int32, []},
	     {1, dungeon_id, int32, []}],
    Defaults = [{4, target_info, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbdungeonschedule, Decoded);
decode(pbdungeonschedulelist, Bytes)
    when is_binary(Bytes) ->
    Types = [{1, update_list, pbdungeonschedule,
	      [is_record, repeated]}],
    Defaults = [{1, update_list, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbdungeonschedulelist, Decoded);
decode(pbdungeontarget, Bytes) when is_binary(Bytes) ->
    Types = [{7, done, int32, []},
	     {6, best_grade, int32, []}, {5, buy_times, int32, []},
	     {4, left_times, int32, []},
	     {3, dungeon_level, int32, []},
	     {2, target_list, int32, [repeated]},
	     {1, dungeon_id, int32, []}],
    Defaults = [{2, target_list, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbdungeontarget, Decoded);
decode(pbflipcard, Bytes) when is_binary(Bytes) ->
    Types = [{4, pos, int32, []},
	     {3, reward, pbdungeonreward, [is_record]},
	     {2, card_type, int32, []}, {1, dungeon_id, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbflipcard, Decoded);
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
decode(pbhitrewarddetail, Bytes)
    when is_binary(Bytes) ->
    Types = [{2, number, int32, []}, {1, combo, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbhitrewarddetail, Decoded);
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
decode(pbmonsterdrop, Bytes) when is_binary(Bytes) ->
    Types = [{2, number, int32, []},
	     {1, goods_id, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbmonsterdrop, Decoded);
decode(pbmopup, Bytes) when is_binary(Bytes) ->
    Types = [{4, pay_card_reward, pbdungeonreward,
	      [is_record, repeated]},
	     {3, free_card_reward, pbdungeonreward,
	      [is_record, repeated]},
	     {2, boss_reward, pbdungeonreward,
	      [is_record, repeated]},
	     {1, normal_reward, pbdungeonreward,
	      [is_record, repeated]}],
    Defaults = [{1, normal_reward, []},
		{2, boss_reward, []}, {3, free_card_reward, []},
		{4, pay_card_reward, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbmopup, Decoded);
decode(pbmopuplist, Bytes) when is_binary(Bytes) ->
    Types = [{4, mop_up_info, pbmopup,
	      [is_record, repeated]},
	     {3, flip_pay_card, int32, []}, {2, times, int32, []},
	     {1, dungeon_id, int32, []}],
    Defaults = [{4, mop_up_info, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbmopuplist, Decoded);
decode(pbmugenchallenge, Bytes) when is_binary(Bytes) ->
    Types = [{2, level, int32, []},
	     {1, player_id, int64, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbmugenchallenge, Decoded);
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
decode(pbsourcedungeon, Bytes) when is_binary(Bytes) ->
    Types = [{1, info, pbsourcedungeoninfo,
	      [is_record, repeated]}],
    Defaults = [{1, info, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbsourcedungeon, Decoded);
decode(pbsourcedungeoninfo, Bytes)
    when is_binary(Bytes) ->
    Types = [{2, left_times, int32, []},
	     {1, type, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbsourcedungeoninfo, Decoded);
decode(pbsubdungeon, Bytes) when is_binary(Bytes) ->
    Types = [{4, wave_creature, pbwavecreature,
	      [is_record, repeated]},
	     {3, wave_monster, pbwavemonster, [is_record, repeated]},
	     {2, create_portal, int32, [repeated]},
	     {1, id, int32, []}],
    Defaults = [{2, create_portal, []},
		{3, wave_monster, []}, {4, wave_creature, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbsubdungeon, Decoded);
decode(pbwavecreature, Bytes) when is_binary(Bytes) ->
    Types = [{2, creature_info, pbdungeoncreature,
	      [is_record, repeated]},
	     {1, id, int32, []}],
    Defaults = [{2, creature_info, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbwavecreature, Decoded);
decode(pbwavemonster, Bytes) when is_binary(Bytes) ->
    Types = [{2, monster_info, pbdungeonmonster,
	      [is_record, repeated]},
	     {1, id, int32, []}],
    Defaults = [{2, monster_info, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbwavemonster, Decoded);
decode(pbwinrate, Bytes) when is_binary(Bytes) ->
    Types = [{3, win_rate, int32, []},
	     {2, fail_times, int32, []}, {1, win_times, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbwinrate, Decoded).

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
to_record(pbchallengedungeon, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbchallengedungeon),
						   Record, Name, Val)
			  end,
			  #pbchallengedungeon{}, DecodedTuples),
    Record1;
to_record(pbchallengedungeoninfo, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbchallengedungeoninfo),
						   Record, Name, Val)
			  end,
			  #pbchallengedungeoninfo{}, DecodedTuples),
    Record1;
to_record(pbchallengedungeonrank, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbchallengedungeonrank),
						   Record, Name, Val)
			  end,
			  #pbchallengedungeonrank{}, DecodedTuples),
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
to_record(pbcreaturedrop, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbcreaturedrop),
						   Record, Name, Val)
			  end,
			  #pbcreaturedrop{}, DecodedTuples),
    Record1;
to_record(pbdailydungeon, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbdailydungeon),
						   Record, Name, Val)
			  end,
			  #pbdailydungeon{}, DecodedTuples),
    Record1;
to_record(pbdungeon, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbdungeon),
						   Record, Name, Val)
			  end,
			  #pbdungeon{}, DecodedTuples),
    Record1;
to_record(pbdungeoncondition, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbdungeoncondition),
						   Record, Name, Val)
			  end,
			  #pbdungeoncondition{}, DecodedTuples),
    Record1;
to_record(pbdungeoncreature, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbdungeoncreature),
						   Record, Name, Val)
			  end,
			  #pbdungeoncreature{}, DecodedTuples),
    Record1;
to_record(pbdungeonmonster, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbdungeonmonster),
						   Record, Name, Val)
			  end,
			  #pbdungeonmonster{}, DecodedTuples),
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
to_record(pbdungeonschedule, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbdungeonschedule),
						   Record, Name, Val)
			  end,
			  #pbdungeonschedule{}, DecodedTuples),
    Record1;
to_record(pbdungeonschedulelist, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbdungeonschedulelist),
						   Record, Name, Val)
			  end,
			  #pbdungeonschedulelist{}, DecodedTuples),
    Record1;
to_record(pbdungeontarget, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbdungeontarget),
						   Record, Name, Val)
			  end,
			  #pbdungeontarget{}, DecodedTuples),
    Record1;
to_record(pbflipcard, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbflipcard),
						   Record, Name, Val)
			  end,
			  #pbflipcard{}, DecodedTuples),
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
to_record(pbhitrewarddetail, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbhitrewarddetail),
						   Record, Name, Val)
			  end,
			  #pbhitrewarddetail{}, DecodedTuples),
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
to_record(pbmonsterdrop, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbmonsterdrop),
						   Record, Name, Val)
			  end,
			  #pbmonsterdrop{}, DecodedTuples),
    Record1;
to_record(pbmopup, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields, pbmopup),
						   Record, Name, Val)
			  end,
			  #pbmopup{}, DecodedTuples),
    Record1;
to_record(pbmopuplist, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbmopuplist),
						   Record, Name, Val)
			  end,
			  #pbmopuplist{}, DecodedTuples),
    Record1;
to_record(pbmugenchallenge, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbmugenchallenge),
						   Record, Name, Val)
			  end,
			  #pbmugenchallenge{}, DecodedTuples),
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
to_record(pbsourcedungeon, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbsourcedungeon),
						   Record, Name, Val)
			  end,
			  #pbsourcedungeon{}, DecodedTuples),
    Record1;
to_record(pbsourcedungeoninfo, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbsourcedungeoninfo),
						   Record, Name, Val)
			  end,
			  #pbsourcedungeoninfo{}, DecodedTuples),
    Record1;
to_record(pbsubdungeon, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbsubdungeon),
						   Record, Name, Val)
			  end,
			  #pbsubdungeon{}, DecodedTuples),
    Record1;
to_record(pbwavecreature, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbwavecreature),
						   Record, Name, Val)
			  end,
			  #pbwavecreature{}, DecodedTuples),
    Record1;
to_record(pbwavemonster, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbwavemonster),
						   Record, Name, Val)
			  end,
			  #pbwavemonster{}, DecodedTuples),
    Record1;
to_record(pbwinrate, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbwinrate),
						   Record, Name, Val)
			  end,
			  #pbwinrate{}, DecodedTuples),
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

