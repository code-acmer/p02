-file("src/pb_40_pb.erl", 1).

-module(pb_40_pb).

-export([encode_pbskill/1, decode_pbskill/1,
	 delimited_decode_pbskill/1, encode_pbsendgiftsmsg/1,
	 decode_pbsendgiftsmsg/1,
	 delimited_decode_pbsendgiftsmsg/1,
	 encode_pbrewarditem/1, decode_pbrewarditem/1,
	 delimited_decode_pbrewarditem/1, encode_pbresult/1,
	 decode_pbresult/1, delimited_decode_pbresult/1,
	 encode_pbrequestplayergiftsmsglist/1,
	 decode_pbrequestplayergiftsmsglist/1,
	 delimited_decode_pbrequestplayergiftsmsglist/1,
	 encode_pbrequestplayergiftsmsg/1,
	 decode_pbrequestplayergiftsmsg/1,
	 delimited_decode_pbrequestplayergiftsmsg/1,
	 encode_pbrequestgiftsmsglist/1,
	 decode_pbrequestgiftsmsglist/1,
	 delimited_decode_pbrequestgiftsmsglist/1,
	 encode_pbrequestgiftsmsg/1, decode_pbrequestgiftsmsg/1,
	 delimited_decode_pbrequestgiftsmsg/1,
	 encode_pbprotectplayerinfo/1,
	 decode_pbprotectplayerinfo/1,
	 delimited_decode_pbprotectplayerinfo/1,
	 encode_pbprotectinfo/1, decode_pbprotectinfo/1,
	 delimited_decode_pbprotectinfo/1,
	 encode_pbpointsendmsglist/1,
	 decode_pbpointsendmsglist/1,
	 delimited_decode_pbpointsendmsglist/1,
	 encode_pbpointsendmsg/1, decode_pbpointsendmsg/1,
	 delimited_decode_pbpointsendmsg/1, encode_pbpointsend/1,
	 decode_pbpointsend/1, delimited_decode_pbpointsend/1,
	 encode_pbpointprotectlist/1,
	 decode_pbpointprotectlist/1,
	 delimited_decode_pbpointprotectlist/1,
	 encode_pbpointchallengerecordinfo/1,
	 decode_pbpointchallengerecordinfo/1,
	 delimited_decode_pbpointchallengerecordinfo/1,
	 encode_pbpointchallengerecord/1,
	 decode_pbpointchallengerecord/1,
	 delimited_decode_pbpointchallengerecord/1,
	 encode_pbplayergifts/1, decode_pbplayergifts/1,
	 delimited_decode_pbplayergifts/1, encode_pbowngifts/1,
	 decode_pbowngifts/1, delimited_decode_pbowngifts/1,
	 encode_pbowncardsinfo/1, decode_pbowncardsinfo/1,
	 delimited_decode_pbowncardsinfo/1,
	 encode_pbonekeysendmsg/1, decode_pbonekeysendmsg/1,
	 delimited_decode_pbonekeysendmsg/1,
	 encode_pbmembersendmsg/1, decode_pbmembersendmsg/1,
	 delimited_decode_pbmembersendmsg/1,
	 encode_pbmembersendlist/1, decode_pbmembersendlist/1,
	 delimited_decode_pbmembersendlist/1,
	 encode_pbmembergetlisttype/1,
	 decode_pbmembergetlisttype/1,
	 delimited_decode_pbmembergetlisttype/1,
	 encode_pbmasterinfo/1, decode_pbmasterinfo/1,
	 delimited_decode_pbmasterinfo/1, encode_pbmastercard/1,
	 decode_pbmastercard/1, delimited_decode_pbmastercard/1,
	 encode_pbmasteragreemsg/1, decode_pbmasteragreemsg/1,
	 delimited_decode_pbmasteragreemsg/1,
	 encode_pbleagueranklist/1, decode_pbleagueranklist/1,
	 delimited_decode_pbleagueranklist/1,
	 encode_pbleaguerankinfo/1, decode_pbleaguerankinfo/1,
	 delimited_decode_pbleaguerankinfo/1,
	 encode_pbleaguepointchallengeresult/1,
	 decode_pbleaguepointchallengeresult/1,
	 delimited_decode_pbleaguepointchallengeresult/1,
	 encode_pbleaguememberlist/1,
	 decode_pbleaguememberlist/1,
	 delimited_decode_pbleaguememberlist/1,
	 encode_pbleaguemember/1, decode_pbleaguemember/1,
	 delimited_decode_pbleaguemember/1,
	 encode_pbleaguelist/1, decode_pbleaguelist/1,
	 delimited_decode_pbleaguelist/1,
	 encode_pbleagueinfolist/1, decode_pbleagueinfolist/1,
	 delimited_decode_pbleagueinfolist/1,
	 encode_pbleagueinfo/1, decode_pbleagueinfo/1,
	 delimited_decode_pbleagueinfo/1,
	 encode_pbleaguehouserecord/1,
	 decode_pbleaguehouserecord/1,
	 delimited_decode_pbleaguehouserecord/1,
	 encode_pbleaguehouse/1, decode_pbleaguehouse/1,
	 delimited_decode_pbleaguehouse/1,
	 encode_pbleaguegifts/1, decode_pbleaguegifts/1,
	 delimited_decode_pbleaguegifts/1,
	 encode_pbleaguefightrankinfo/1,
	 decode_pbleaguefightrankinfo/1,
	 delimited_decode_pbleaguefightrankinfo/1,
	 encode_pbleaguefightpointlist/1,
	 decode_pbleaguefightpointlist/1,
	 delimited_decode_pbleaguefightpointlist/1,
	 encode_pbleaguefightpoint/1,
	 decode_pbleaguefightpoint/1,
	 delimited_decode_pbleaguefightpoint/1,
	 encode_pbleaguechallengeresult/1,
	 decode_pbleaguechallengeresult/1,
	 delimited_decode_pbleaguechallengeresult/1,
	 encode_pbleaguechallengelist/1,
	 decode_pbleaguechallengelist/1,
	 delimited_decode_pbleaguechallengelist/1,
	 encode_pbleaguechallengeinfo/1,
	 decode_pbleaguechallengeinfo/1,
	 delimited_decode_pbleaguechallengeinfo/1,
	 encode_pbleague/1, decode_pbleague/1,
	 delimited_decode_pbleague/1, encode_pbleagifts/1,
	 decode_pbleagifts/1, delimited_decode_pbleagifts/1,
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
	 delimited_decode_pbgoods/1, encode_pbgiftsrecordlist/1,
	 decode_pbgiftsrecordlist/1,
	 delimited_decode_pbgiftsrecordlist/1,
	 encode_pbgiftsrecord/1, decode_pbgiftsrecord/1,
	 delimited_decode_pbgiftsrecord/1, encode_pbgiftsid/1,
	 decode_pbgiftsid/1, delimited_decode_pbgiftsid/1,
	 encode_pbgetpointrecord/1, decode_pbgetpointrecord/1,
	 delimited_decode_pbgetpointrecord/1,
	 encode_pbgetleaguestatu/1, decode_pbgetleaguestatu/1,
	 delimited_decode_pbgetleaguestatu/1,
	 encode_pbgetleaguegrouprankinfo/1,
	 decode_pbgetleaguegrouprankinfo/1,
	 delimited_decode_pbgetleaguegrouprankinfo/1,
	 encode_pbgetleague/1, decode_pbgetleague/1,
	 delimited_decode_pbgetleague/1,
	 encode_pbg17guildquery/1, decode_pbg17guildquery/1,
	 delimited_decode_pbg17guildquery/1,
	 encode_pbg17guildmember/1, decode_pbg17guildmember/1,
	 delimited_decode_pbg17guildmember/1,
	 encode_pbg17guildlist/1, decode_pbg17guildlist/1,
	 delimited_decode_pbg17guildlist/1, encode_pbg17guild/1,
	 decode_pbg17guild/1, delimited_decode_pbg17guild/1,
	 encode_pbfriend/1, decode_pbfriend/1,
	 delimited_decode_pbfriend/1, encode_pbfightrecords/1,
	 decode_pbfightrecords/1,
	 delimited_decode_pbfightrecords/1,
	 encode_pbcountrecords/1, decode_pbcountrecords/1,
	 delimited_decode_pbcountrecords/1,
	 encode_pbcountrecord/1, decode_pbcountrecord/1,
	 delimited_decode_pbcountrecord/1,
	 encode_pbcombatreward/1, decode_pbcombatreward/1,
	 delimited_decode_pbcombatreward/1,
	 encode_pbchallengerecordlist/1,
	 decode_pbchallengerecordlist/1,
	 delimited_decode_pbchallengerecordlist/1,
	 encode_pbchallengerecord/1, decode_pbchallengerecord/1,
	 delimited_decode_pbchallengerecord/1,
	 encode_pbcardinfo/1, decode_pbcardinfo/1,
	 delimited_decode_pbcardinfo/1,
	 encode_pbcardrequestlist/1, decode_pbcardrequestlist/1,
	 delimited_decode_pbcardrequestlist/1,
	 encode_pbcardrequest/1, decode_pbcardrequest/1,
	 delimited_decode_pbcardrequest/1,
	 encode_pbbosssendgold/1, decode_pbbosssendgold/1,
	 delimited_decode_pbbosssendgold/1,
	 encode_pbbossinvitemsg/1, decode_pbbossinvitemsg/1,
	 delimited_decode_pbbossinvitemsg/1,
	 encode_pbattribute/1, decode_pbattribute/1,
	 delimited_decode_pbattribute/1,
	 encode_pbapprenticerequestinfo/1,
	 decode_pbapprenticerequestinfo/1,
	 delimited_decode_pbapprenticerequestinfo/1,
	 encode_pbapprenticecard/1, decode_pbapprenticecard/1,
	 delimited_decode_pbapprenticecard/1,
	 encode_pbapprenticebuycard/1,
	 decode_pbapprenticebuycard/1,
	 delimited_decode_pbapprenticebuycard/1,
	 encode_pbappointplayer/1, decode_pbappointplayer/1,
	 delimited_decode_pbappointplayer/1,
	 encode_pballmasterinfo/1, decode_pballmasterinfo/1,
	 delimited_decode_pballmasterinfo/1,
	 encode_pbaddleaguemsg/1, decode_pbaddleaguemsg/1,
	 delimited_decode_pbaddleaguemsg/1]).

-export([has_extension/2, extension_size/1,
	 get_extension/2, set_extension/3]).

-export([decode_extensions/1]).

-export([encode/1, decode/2, delimited_decode/2]).

-export([int_to_enum/2, enum_to_int/2]).

-record(pbskill,
	{id, skill_id, player_id, lv, str_lv, sigil, type}).

-record(pbsendgiftsmsg, {gifts_id, gifts_num}).

-record(pbrewarditem, {id, num, goods_id}).

-record(pbresult, {result}).

-record(pbrequestplayergiftsmsglist, {list}).

-record(pbrequestplayergiftsmsg, {name, player_id}).

-record(pbrequestgiftsmsglist, {list}).

-record(pbrequestgiftsmsg,
	{name, lv, league_lv, gifts_num, player_id,
	 is_request}).

-record(pbprotectplayerinfo,
	{player_id, name, lv, ability, contribute, title,
	 contribute_lv, career}).

-record(pbprotectinfo, {name, id}).

-record(pbpointsendmsglist, {list}).

-record(pbpointsendmsg,
	{name, lv, league_lv, player_id}).

-record(pbpointsend, {gifts_id, player_id}).

-record(pbpointprotectlist, {list}).

-record(pbpointchallengerecordinfo, {list}).

-record(pbpointchallengerecord,
	{timestamp, name, result, thing_reward}).

-record(pbplayergifts,
	{gifts_id, timestamp, all_num, remain_num,
	 recharge_gold_num, sum_value, last_send,
	 day_remain_num}).

-record(pbowngifts, {own_gifts_list}).

-record(pbowncardsinfo,
	{master_card_list, apprentice_card_list,
	 remain_master_num}).

-record(pbonekeysendmsg, {send_success_list}).

-record(pbmembersendmsg, {name, value}).

-record(pbmembersendlist, {list}).

-record(pbmembergetlisttype, {type}).

-record(pbmasterinfo,
	{id, name, lv, ability, contribute, title,
	 contribute_lv, card_list}).

-record(pbmastercard,
	{id, master_goods_id, apprentice_player_id,
	 apprentice_player_name, card_status, work_day}).

-record(pbmasteragreemsg, {id, player_id}).

-record(pbleagueranklist, {list, size}).

-record(pbleaguerankinfo,
	{league_id, rank, name, lv, cur_num, max_num,
	 ability_sum, score}).

-record(pbleaguepointchallengeresult,
	{point_id, result, energy}).

-record(pbleaguememberlist, {member_list}).

-record(pbleaguemember,
	{player_id, title, contribute, name, lv, ability,
	 g17_join_timestamp}).

-record(pbleaguelist, {league_list, size}).

-record(pbleagueinfolist, {list}).

-record(pbleagueinfo,
	{name, league_id, league_sn, ability, group_num, thing,
	 occ_point_num, remain_fight_num}).

-record(pbleaguehouserecord, {timestamp, name, value}).

-record(pbleaguehouse, {record_list, gold}).

-record(pbleaguegifts, {league_gifts_list}).

-record(pbleaguefightrankinfo, {score, rank}).

-record(pbleaguefightpointlist, {list}).

-record(pbleaguefightpoint,
	{league_id, point_id, pos, status, protect_info,
	 occurpy_info}).

-record(pbleaguechallengeresult,
	{enemy_player_id, result, energy}).

-record(pbleaguechallengelist, {list}).

-record(pbleaguechallengeinfo,
	{player_id, name, lv, title, ability_sum, thing,
	 grab_num, career, mult}).

-record(pbleague,
	{id, name, cur_num, max_num, lv, ability_sum,
	 join_ability, declaration, president, rank,
	 league_gifts_num, apply_league_fight, league_exp,
	 g17_guild_id, g17_guild_name}).

-record(pbleagifts,
	{gifts_id, timestamp, name, all_num, remain_num, value,
	 has_recv}).

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

-record(pbgiftsrecordlist, {record_list}).

-record(pbgiftsrecord,
	{timestamp, send_name, recv_name, type, value}).

-record(pbgiftsid, {gifts_id}).

-record(pbgetpointrecord, {league_id, point_id}).

-record(pbgetleaguestatu, {type, timestamp}).

-record(pbgetleaguegrouprankinfo,
	{last_key, type, league_group}).

-record(pbgetleague, {last_key, type}).

-record(pbg17guildquery, {name, guild_id}).

-record(pbg17guildmember,
	{guild_id, guild_name, title, number}).

-record(pbg17guildlist, {guilds}).

-record(pbg17guild,
	{guild_id, guild_name, status, owner_user_id}).

-record(pbfriend,
	{id, nickname, level, career, core, off_time, fashion,
	 mugen_pass_times, mugen_score, skill_list, talent,
	 battle_ability, rela, league_name, league_title,
	 put_on_skill, attri, type}).

-record(pbfightrecords, {def_records, atk_records}).

-record(pbcountrecords, {records}).

-record(pbcountrecord,
	{player_id, player_name, win_times, loss_times, points,
	 things}).

-record(pbcombatreward,
	{exp, mon_drop_list, dungeon_reward_list, unique_id,
	 seal, evaluate, point, partners}).

-record(pbchallengerecordlist, {list}).

-record(pbchallengerecord,
	{timestamp, name, enemy_name, result, league_thing}).

-record(pbcardinfo, {id, base_id, card_status}).

-record(pbcardrequestlist, {list}).

-record(pbcardrequest, {id, list}).

-record(pbbosssendgold, {gold_num}).

-record(pbbossinvitemsg,
	{boss_name, league_name, league_id}).

-record(pbattribute,
	{hp_lim, hp_cur, mana_lim, mana_cur, hp_rec, mana_rec,
	 attack, def, hit, dodge, crit, anti_crit, stiff,
	 anti_stiff, attack_speed, move_speed, attack_effect,
	 def_effect}).

-record(pbapprenticerequestinfo, {id, name}).

-record(pbapprenticecard,
	{id, master_player_id, master_player_name,
	 apprentice_goods_id, card_status, work_day}).

-record(pbapprenticebuycard, {id, type}).

-record(pbappointplayer, {point_id, player_id}).

-record(pballmasterinfo, {list}).

-record(pbaddleaguemsg, {league_id, type}).

encode([]) -> [];
encode(Records) when is_list(Records) ->
    delimited_encode(Records);
encode(Record) -> encode(element(1, Record), Record).

encode_pbskill(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbskill(Record)
    when is_record(Record, pbskill) ->
    encode(pbskill, Record).

encode_pbsendgiftsmsg(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbsendgiftsmsg(Record)
    when is_record(Record, pbsendgiftsmsg) ->
    encode(pbsendgiftsmsg, Record).

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

encode_pbrequestplayergiftsmsglist(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_pbrequestplayergiftsmsglist(Record)
    when is_record(Record, pbrequestplayergiftsmsglist) ->
    encode(pbrequestplayergiftsmsglist, Record).

encode_pbrequestplayergiftsmsg(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_pbrequestplayergiftsmsg(Record)
    when is_record(Record, pbrequestplayergiftsmsg) ->
    encode(pbrequestplayergiftsmsg, Record).

encode_pbrequestgiftsmsglist(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_pbrequestgiftsmsglist(Record)
    when is_record(Record, pbrequestgiftsmsglist) ->
    encode(pbrequestgiftsmsglist, Record).

encode_pbrequestgiftsmsg(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_pbrequestgiftsmsg(Record)
    when is_record(Record, pbrequestgiftsmsg) ->
    encode(pbrequestgiftsmsg, Record).

encode_pbprotectplayerinfo(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_pbprotectplayerinfo(Record)
    when is_record(Record, pbprotectplayerinfo) ->
    encode(pbprotectplayerinfo, Record).

encode_pbprotectinfo(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbprotectinfo(Record)
    when is_record(Record, pbprotectinfo) ->
    encode(pbprotectinfo, Record).

encode_pbpointsendmsglist(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_pbpointsendmsglist(Record)
    when is_record(Record, pbpointsendmsglist) ->
    encode(pbpointsendmsglist, Record).

encode_pbpointsendmsg(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbpointsendmsg(Record)
    when is_record(Record, pbpointsendmsg) ->
    encode(pbpointsendmsg, Record).

encode_pbpointsend(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbpointsend(Record)
    when is_record(Record, pbpointsend) ->
    encode(pbpointsend, Record).

encode_pbpointprotectlist(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_pbpointprotectlist(Record)
    when is_record(Record, pbpointprotectlist) ->
    encode(pbpointprotectlist, Record).

encode_pbpointchallengerecordinfo(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_pbpointchallengerecordinfo(Record)
    when is_record(Record, pbpointchallengerecordinfo) ->
    encode(pbpointchallengerecordinfo, Record).

encode_pbpointchallengerecord(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_pbpointchallengerecord(Record)
    when is_record(Record, pbpointchallengerecord) ->
    encode(pbpointchallengerecord, Record).

encode_pbplayergifts(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbplayergifts(Record)
    when is_record(Record, pbplayergifts) ->
    encode(pbplayergifts, Record).

encode_pbowngifts(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbowngifts(Record)
    when is_record(Record, pbowngifts) ->
    encode(pbowngifts, Record).

encode_pbowncardsinfo(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbowncardsinfo(Record)
    when is_record(Record, pbowncardsinfo) ->
    encode(pbowncardsinfo, Record).

encode_pbonekeysendmsg(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbonekeysendmsg(Record)
    when is_record(Record, pbonekeysendmsg) ->
    encode(pbonekeysendmsg, Record).

encode_pbmembersendmsg(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbmembersendmsg(Record)
    when is_record(Record, pbmembersendmsg) ->
    encode(pbmembersendmsg, Record).

encode_pbmembersendlist(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_pbmembersendlist(Record)
    when is_record(Record, pbmembersendlist) ->
    encode(pbmembersendlist, Record).

encode_pbmembergetlisttype(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_pbmembergetlisttype(Record)
    when is_record(Record, pbmembergetlisttype) ->
    encode(pbmembergetlisttype, Record).

encode_pbmasterinfo(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbmasterinfo(Record)
    when is_record(Record, pbmasterinfo) ->
    encode(pbmasterinfo, Record).

encode_pbmastercard(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbmastercard(Record)
    when is_record(Record, pbmastercard) ->
    encode(pbmastercard, Record).

encode_pbmasteragreemsg(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_pbmasteragreemsg(Record)
    when is_record(Record, pbmasteragreemsg) ->
    encode(pbmasteragreemsg, Record).

encode_pbleagueranklist(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_pbleagueranklist(Record)
    when is_record(Record, pbleagueranklist) ->
    encode(pbleagueranklist, Record).

encode_pbleaguerankinfo(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_pbleaguerankinfo(Record)
    when is_record(Record, pbleaguerankinfo) ->
    encode(pbleaguerankinfo, Record).

encode_pbleaguepointchallengeresult(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_pbleaguepointchallengeresult(Record)
    when is_record(Record, pbleaguepointchallengeresult) ->
    encode(pbleaguepointchallengeresult, Record).

encode_pbleaguememberlist(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_pbleaguememberlist(Record)
    when is_record(Record, pbleaguememberlist) ->
    encode(pbleaguememberlist, Record).

encode_pbleaguemember(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbleaguemember(Record)
    when is_record(Record, pbleaguemember) ->
    encode(pbleaguemember, Record).

encode_pbleaguelist(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbleaguelist(Record)
    when is_record(Record, pbleaguelist) ->
    encode(pbleaguelist, Record).

encode_pbleagueinfolist(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_pbleagueinfolist(Record)
    when is_record(Record, pbleagueinfolist) ->
    encode(pbleagueinfolist, Record).

encode_pbleagueinfo(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbleagueinfo(Record)
    when is_record(Record, pbleagueinfo) ->
    encode(pbleagueinfo, Record).

encode_pbleaguehouserecord(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_pbleaguehouserecord(Record)
    when is_record(Record, pbleaguehouserecord) ->
    encode(pbleaguehouserecord, Record).

encode_pbleaguehouse(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbleaguehouse(Record)
    when is_record(Record, pbleaguehouse) ->
    encode(pbleaguehouse, Record).

encode_pbleaguegifts(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbleaguegifts(Record)
    when is_record(Record, pbleaguegifts) ->
    encode(pbleaguegifts, Record).

encode_pbleaguefightrankinfo(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_pbleaguefightrankinfo(Record)
    when is_record(Record, pbleaguefightrankinfo) ->
    encode(pbleaguefightrankinfo, Record).

encode_pbleaguefightpointlist(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_pbleaguefightpointlist(Record)
    when is_record(Record, pbleaguefightpointlist) ->
    encode(pbleaguefightpointlist, Record).

encode_pbleaguefightpoint(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_pbleaguefightpoint(Record)
    when is_record(Record, pbleaguefightpoint) ->
    encode(pbleaguefightpoint, Record).

encode_pbleaguechallengeresult(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_pbleaguechallengeresult(Record)
    when is_record(Record, pbleaguechallengeresult) ->
    encode(pbleaguechallengeresult, Record).

encode_pbleaguechallengelist(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_pbleaguechallengelist(Record)
    when is_record(Record, pbleaguechallengelist) ->
    encode(pbleaguechallengelist, Record).

encode_pbleaguechallengeinfo(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_pbleaguechallengeinfo(Record)
    when is_record(Record, pbleaguechallengeinfo) ->
    encode(pbleaguechallengeinfo, Record).

encode_pbleague(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbleague(Record)
    when is_record(Record, pbleague) ->
    encode(pbleague, Record).

encode_pbleagifts(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbleagifts(Record)
    when is_record(Record, pbleagifts) ->
    encode(pbleagifts, Record).

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

encode_pbgiftsrecordlist(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_pbgiftsrecordlist(Record)
    when is_record(Record, pbgiftsrecordlist) ->
    encode(pbgiftsrecordlist, Record).

encode_pbgiftsrecord(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbgiftsrecord(Record)
    when is_record(Record, pbgiftsrecord) ->
    encode(pbgiftsrecord, Record).

encode_pbgiftsid(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbgiftsid(Record)
    when is_record(Record, pbgiftsid) ->
    encode(pbgiftsid, Record).

encode_pbgetpointrecord(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_pbgetpointrecord(Record)
    when is_record(Record, pbgetpointrecord) ->
    encode(pbgetpointrecord, Record).

encode_pbgetleaguestatu(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_pbgetleaguestatu(Record)
    when is_record(Record, pbgetleaguestatu) ->
    encode(pbgetleaguestatu, Record).

encode_pbgetleaguegrouprankinfo(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_pbgetleaguegrouprankinfo(Record)
    when is_record(Record, pbgetleaguegrouprankinfo) ->
    encode(pbgetleaguegrouprankinfo, Record).

encode_pbgetleague(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbgetleague(Record)
    when is_record(Record, pbgetleague) ->
    encode(pbgetleague, Record).

encode_pbg17guildquery(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbg17guildquery(Record)
    when is_record(Record, pbg17guildquery) ->
    encode(pbg17guildquery, Record).

encode_pbg17guildmember(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_pbg17guildmember(Record)
    when is_record(Record, pbg17guildmember) ->
    encode(pbg17guildmember, Record).

encode_pbg17guildlist(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbg17guildlist(Record)
    when is_record(Record, pbg17guildlist) ->
    encode(pbg17guildlist, Record).

encode_pbg17guild(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbg17guild(Record)
    when is_record(Record, pbg17guild) ->
    encode(pbg17guild, Record).

encode_pbfriend(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbfriend(Record)
    when is_record(Record, pbfriend) ->
    encode(pbfriend, Record).

encode_pbfightrecords(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbfightrecords(Record)
    when is_record(Record, pbfightrecords) ->
    encode(pbfightrecords, Record).

encode_pbcountrecords(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbcountrecords(Record)
    when is_record(Record, pbcountrecords) ->
    encode(pbcountrecords, Record).

encode_pbcountrecord(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbcountrecord(Record)
    when is_record(Record, pbcountrecord) ->
    encode(pbcountrecord, Record).

encode_pbcombatreward(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbcombatreward(Record)
    when is_record(Record, pbcombatreward) ->
    encode(pbcombatreward, Record).

encode_pbchallengerecordlist(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_pbchallengerecordlist(Record)
    when is_record(Record, pbchallengerecordlist) ->
    encode(pbchallengerecordlist, Record).

encode_pbchallengerecord(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_pbchallengerecord(Record)
    when is_record(Record, pbchallengerecord) ->
    encode(pbchallengerecord, Record).

encode_pbcardinfo(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbcardinfo(Record)
    when is_record(Record, pbcardinfo) ->
    encode(pbcardinfo, Record).

encode_pbcardrequestlist(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_pbcardrequestlist(Record)
    when is_record(Record, pbcardrequestlist) ->
    encode(pbcardrequestlist, Record).

encode_pbcardrequest(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbcardrequest(Record)
    when is_record(Record, pbcardrequest) ->
    encode(pbcardrequest, Record).

encode_pbbosssendgold(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbbosssendgold(Record)
    when is_record(Record, pbbosssendgold) ->
    encode(pbbosssendgold, Record).

encode_pbbossinvitemsg(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbbossinvitemsg(Record)
    when is_record(Record, pbbossinvitemsg) ->
    encode(pbbossinvitemsg, Record).

encode_pbattribute(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbattribute(Record)
    when is_record(Record, pbattribute) ->
    encode(pbattribute, Record).

encode_pbapprenticerequestinfo(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_pbapprenticerequestinfo(Record)
    when is_record(Record, pbapprenticerequestinfo) ->
    encode(pbapprenticerequestinfo, Record).

encode_pbapprenticecard(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_pbapprenticecard(Record)
    when is_record(Record, pbapprenticecard) ->
    encode(pbapprenticecard, Record).

encode_pbapprenticebuycard(Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode_pbapprenticebuycard(Record)
    when is_record(Record, pbapprenticebuycard) ->
    encode(pbapprenticebuycard, Record).

encode_pbappointplayer(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbappointplayer(Record)
    when is_record(Record, pbappointplayer) ->
    encode(pbappointplayer, Record).

encode_pballmasterinfo(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pballmasterinfo(Record)
    when is_record(Record, pballmasterinfo) ->
    encode(pballmasterinfo, Record).

encode_pbaddleaguemsg(Records) when is_list(Records) ->
    delimited_encode(Records);
encode_pbaddleaguemsg(Record)
    when is_record(Record, pbaddleaguemsg) ->
    encode(pbaddleaguemsg, Record).

encode(pbaddleaguemsg, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbaddleaguemsg, Record) ->
    [iolist(pbaddleaguemsg, Record)
     | encode_extensions(Record)];
encode(pballmasterinfo, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pballmasterinfo, Record) ->
    [iolist(pballmasterinfo, Record)
     | encode_extensions(Record)];
encode(pbappointplayer, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbappointplayer, Record) ->
    [iolist(pbappointplayer, Record)
     | encode_extensions(Record)];
encode(pbapprenticebuycard, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbapprenticebuycard, Record) ->
    [iolist(pbapprenticebuycard, Record)
     | encode_extensions(Record)];
encode(pbapprenticecard, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbapprenticecard, Record) ->
    [iolist(pbapprenticecard, Record)
     | encode_extensions(Record)];
encode(pbapprenticerequestinfo, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbapprenticerequestinfo, Record) ->
    [iolist(pbapprenticerequestinfo, Record)
     | encode_extensions(Record)];
encode(pbattribute, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbattribute, Record) ->
    [iolist(pbattribute, Record)
     | encode_extensions(Record)];
encode(pbbossinvitemsg, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbbossinvitemsg, Record) ->
    [iolist(pbbossinvitemsg, Record)
     | encode_extensions(Record)];
encode(pbbosssendgold, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbbosssendgold, Record) ->
    [iolist(pbbosssendgold, Record)
     | encode_extensions(Record)];
encode(pbcardrequest, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbcardrequest, Record) ->
    [iolist(pbcardrequest, Record)
     | encode_extensions(Record)];
encode(pbcardrequestlist, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbcardrequestlist, Record) ->
    [iolist(pbcardrequestlist, Record)
     | encode_extensions(Record)];
encode(pbcardinfo, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbcardinfo, Record) ->
    [iolist(pbcardinfo, Record)
     | encode_extensions(Record)];
encode(pbchallengerecord, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbchallengerecord, Record) ->
    [iolist(pbchallengerecord, Record)
     | encode_extensions(Record)];
encode(pbchallengerecordlist, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbchallengerecordlist, Record) ->
    [iolist(pbchallengerecordlist, Record)
     | encode_extensions(Record)];
encode(pbcombatreward, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbcombatreward, Record) ->
    [iolist(pbcombatreward, Record)
     | encode_extensions(Record)];
encode(pbcountrecord, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbcountrecord, Record) ->
    [iolist(pbcountrecord, Record)
     | encode_extensions(Record)];
encode(pbcountrecords, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbcountrecords, Record) ->
    [iolist(pbcountrecords, Record)
     | encode_extensions(Record)];
encode(pbfightrecords, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbfightrecords, Record) ->
    [iolist(pbfightrecords, Record)
     | encode_extensions(Record)];
encode(pbfriend, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbfriend, Record) ->
    [iolist(pbfriend, Record) | encode_extensions(Record)];
encode(pbg17guild, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbg17guild, Record) ->
    [iolist(pbg17guild, Record)
     | encode_extensions(Record)];
encode(pbg17guildlist, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbg17guildlist, Record) ->
    [iolist(pbg17guildlist, Record)
     | encode_extensions(Record)];
encode(pbg17guildmember, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbg17guildmember, Record) ->
    [iolist(pbg17guildmember, Record)
     | encode_extensions(Record)];
encode(pbg17guildquery, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbg17guildquery, Record) ->
    [iolist(pbg17guildquery, Record)
     | encode_extensions(Record)];
encode(pbgetleague, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbgetleague, Record) ->
    [iolist(pbgetleague, Record)
     | encode_extensions(Record)];
encode(pbgetleaguegrouprankinfo, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbgetleaguegrouprankinfo, Record) ->
    [iolist(pbgetleaguegrouprankinfo, Record)
     | encode_extensions(Record)];
encode(pbgetleaguestatu, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbgetleaguestatu, Record) ->
    [iolist(pbgetleaguestatu, Record)
     | encode_extensions(Record)];
encode(pbgetpointrecord, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbgetpointrecord, Record) ->
    [iolist(pbgetpointrecord, Record)
     | encode_extensions(Record)];
encode(pbgiftsid, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbgiftsid, Record) ->
    [iolist(pbgiftsid, Record) | encode_extensions(Record)];
encode(pbgiftsrecord, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbgiftsrecord, Record) ->
    [iolist(pbgiftsrecord, Record)
     | encode_extensions(Record)];
encode(pbgiftsrecordlist, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbgiftsrecordlist, Record) ->
    [iolist(pbgiftsrecordlist, Record)
     | encode_extensions(Record)];
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
encode(pbleagifts, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbleagifts, Record) ->
    [iolist(pbleagifts, Record)
     | encode_extensions(Record)];
encode(pbleague, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbleague, Record) ->
    [iolist(pbleague, Record) | encode_extensions(Record)];
encode(pbleaguechallengeinfo, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbleaguechallengeinfo, Record) ->
    [iolist(pbleaguechallengeinfo, Record)
     | encode_extensions(Record)];
encode(pbleaguechallengelist, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbleaguechallengelist, Record) ->
    [iolist(pbleaguechallengelist, Record)
     | encode_extensions(Record)];
encode(pbleaguechallengeresult, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbleaguechallengeresult, Record) ->
    [iolist(pbleaguechallengeresult, Record)
     | encode_extensions(Record)];
encode(pbleaguefightpoint, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbleaguefightpoint, Record) ->
    [iolist(pbleaguefightpoint, Record)
     | encode_extensions(Record)];
encode(pbleaguefightpointlist, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbleaguefightpointlist, Record) ->
    [iolist(pbleaguefightpointlist, Record)
     | encode_extensions(Record)];
encode(pbleaguefightrankinfo, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbleaguefightrankinfo, Record) ->
    [iolist(pbleaguefightrankinfo, Record)
     | encode_extensions(Record)];
encode(pbleaguegifts, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbleaguegifts, Record) ->
    [iolist(pbleaguegifts, Record)
     | encode_extensions(Record)];
encode(pbleaguehouse, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbleaguehouse, Record) ->
    [iolist(pbleaguehouse, Record)
     | encode_extensions(Record)];
encode(pbleaguehouserecord, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbleaguehouserecord, Record) ->
    [iolist(pbleaguehouserecord, Record)
     | encode_extensions(Record)];
encode(pbleagueinfo, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbleagueinfo, Record) ->
    [iolist(pbleagueinfo, Record)
     | encode_extensions(Record)];
encode(pbleagueinfolist, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbleagueinfolist, Record) ->
    [iolist(pbleagueinfolist, Record)
     | encode_extensions(Record)];
encode(pbleaguelist, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbleaguelist, Record) ->
    [iolist(pbleaguelist, Record)
     | encode_extensions(Record)];
encode(pbleaguemember, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbleaguemember, Record) ->
    [iolist(pbleaguemember, Record)
     | encode_extensions(Record)];
encode(pbleaguememberlist, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbleaguememberlist, Record) ->
    [iolist(pbleaguememberlist, Record)
     | encode_extensions(Record)];
encode(pbleaguepointchallengeresult, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbleaguepointchallengeresult, Record) ->
    [iolist(pbleaguepointchallengeresult, Record)
     | encode_extensions(Record)];
encode(pbleaguerankinfo, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbleaguerankinfo, Record) ->
    [iolist(pbleaguerankinfo, Record)
     | encode_extensions(Record)];
encode(pbleagueranklist, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbleagueranklist, Record) ->
    [iolist(pbleagueranklist, Record)
     | encode_extensions(Record)];
encode(pbmasteragreemsg, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbmasteragreemsg, Record) ->
    [iolist(pbmasteragreemsg, Record)
     | encode_extensions(Record)];
encode(pbmastercard, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbmastercard, Record) ->
    [iolist(pbmastercard, Record)
     | encode_extensions(Record)];
encode(pbmasterinfo, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbmasterinfo, Record) ->
    [iolist(pbmasterinfo, Record)
     | encode_extensions(Record)];
encode(pbmembergetlisttype, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbmembergetlisttype, Record) ->
    [iolist(pbmembergetlisttype, Record)
     | encode_extensions(Record)];
encode(pbmembersendlist, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbmembersendlist, Record) ->
    [iolist(pbmembersendlist, Record)
     | encode_extensions(Record)];
encode(pbmembersendmsg, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbmembersendmsg, Record) ->
    [iolist(pbmembersendmsg, Record)
     | encode_extensions(Record)];
encode(pbonekeysendmsg, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbonekeysendmsg, Record) ->
    [iolist(pbonekeysendmsg, Record)
     | encode_extensions(Record)];
encode(pbowncardsinfo, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbowncardsinfo, Record) ->
    [iolist(pbowncardsinfo, Record)
     | encode_extensions(Record)];
encode(pbowngifts, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbowngifts, Record) ->
    [iolist(pbowngifts, Record)
     | encode_extensions(Record)];
encode(pbplayergifts, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbplayergifts, Record) ->
    [iolist(pbplayergifts, Record)
     | encode_extensions(Record)];
encode(pbpointchallengerecord, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbpointchallengerecord, Record) ->
    [iolist(pbpointchallengerecord, Record)
     | encode_extensions(Record)];
encode(pbpointchallengerecordinfo, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbpointchallengerecordinfo, Record) ->
    [iolist(pbpointchallengerecordinfo, Record)
     | encode_extensions(Record)];
encode(pbpointprotectlist, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbpointprotectlist, Record) ->
    [iolist(pbpointprotectlist, Record)
     | encode_extensions(Record)];
encode(pbpointsend, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbpointsend, Record) ->
    [iolist(pbpointsend, Record)
     | encode_extensions(Record)];
encode(pbpointsendmsg, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbpointsendmsg, Record) ->
    [iolist(pbpointsendmsg, Record)
     | encode_extensions(Record)];
encode(pbpointsendmsglist, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbpointsendmsglist, Record) ->
    [iolist(pbpointsendmsglist, Record)
     | encode_extensions(Record)];
encode(pbprotectinfo, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbprotectinfo, Record) ->
    [iolist(pbprotectinfo, Record)
     | encode_extensions(Record)];
encode(pbprotectplayerinfo, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbprotectplayerinfo, Record) ->
    [iolist(pbprotectplayerinfo, Record)
     | encode_extensions(Record)];
encode(pbrequestgiftsmsg, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbrequestgiftsmsg, Record) ->
    [iolist(pbrequestgiftsmsg, Record)
     | encode_extensions(Record)];
encode(pbrequestgiftsmsglist, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbrequestgiftsmsglist, Record) ->
    [iolist(pbrequestgiftsmsglist, Record)
     | encode_extensions(Record)];
encode(pbrequestplayergiftsmsg, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbrequestplayergiftsmsg, Record) ->
    [iolist(pbrequestplayergiftsmsg, Record)
     | encode_extensions(Record)];
encode(pbrequestplayergiftsmsglist, Records)
    when is_list(Records) ->
    delimited_encode(Records);
encode(pbrequestplayergiftsmsglist, Record) ->
    [iolist(pbrequestplayergiftsmsglist, Record)
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
encode(pbsendgiftsmsg, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbsendgiftsmsg, Record) ->
    [iolist(pbsendgiftsmsg, Record)
     | encode_extensions(Record)];
encode(pbskill, Records) when is_list(Records) ->
    delimited_encode(Records);
encode(pbskill, Record) ->
    [iolist(pbskill, Record) | encode_extensions(Record)].

encode_extensions(_) -> [].

delimited_encode(Records) ->
    lists:map(fun (Record) ->
		      IoRec = encode(Record),
		      Size = iolist_size(IoRec),
		      [protobuffs:encode_varint(Size), IoRec]
	      end,
	      Records).

iolist(pbaddleaguemsg, Record) ->
    [pack(1, optional,
	  with_default(Record#pbaddleaguemsg.league_id, none),
	  int32, []),
     pack(2, optional,
	  with_default(Record#pbaddleaguemsg.type, none), int32,
	  [])];
iolist(pballmasterinfo, Record) ->
    [pack(1, repeated,
	  with_default(Record#pballmasterinfo.list, none),
	  pbmasterinfo, [])];
iolist(pbappointplayer, Record) ->
    [pack(1, optional,
	  with_default(Record#pbappointplayer.point_id, none),
	  int32, []),
     pack(2, optional,
	  with_default(Record#pbappointplayer.player_id, none),
	  int32, [])];
iolist(pbapprenticebuycard, Record) ->
    [pack(1, optional,
	  with_default(Record#pbapprenticebuycard.id, none),
	  string, []),
     pack(2, optional,
	  with_default(Record#pbapprenticebuycard.type, none),
	  int32, [])];
iolist(pbapprenticecard, Record) ->
    [pack(1, optional,
	  with_default(Record#pbapprenticecard.id, none), string,
	  []),
     pack(2, optional,
	  with_default(Record#pbapprenticecard.master_player_id,
		       none),
	  int32, []),
     pack(3, optional,
	  with_default(Record#pbapprenticecard.master_player_name,
		       none),
	  string, []),
     pack(4, optional,
	  with_default(Record#pbapprenticecard.apprentice_goods_id,
		       none),
	  int32, []),
     pack(5, optional,
	  with_default(Record#pbapprenticecard.card_status, none),
	  int32, []),
     pack(6, optional,
	  with_default(Record#pbapprenticecard.work_day, none),
	  int32, [])];
iolist(pbapprenticerequestinfo, Record) ->
    [pack(1, optional,
	  with_default(Record#pbapprenticerequestinfo.id, none),
	  int32, []),
     pack(2, optional,
	  with_default(Record#pbapprenticerequestinfo.name, none),
	  string, [])];
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
iolist(pbbossinvitemsg, Record) ->
    [pack(1, optional,
	  with_default(Record#pbbossinvitemsg.boss_name, none),
	  string, []),
     pack(2, optional,
	  with_default(Record#pbbossinvitemsg.league_name, none),
	  string, []),
     pack(3, optional,
	  with_default(Record#pbbossinvitemsg.league_id, none),
	  int32, [])];
iolist(pbbosssendgold, Record) ->
    [pack(1, optional,
	  with_default(Record#pbbosssendgold.gold_num, none),
	  int32, [])];
iolist(pbcardrequest, Record) ->
    [pack(1, optional,
	  with_default(Record#pbcardrequest.id, none), string,
	  []),
     pack(2, repeated,
	  with_default(Record#pbcardrequest.list, none),
	  pbapprenticerequestinfo, [])];
iolist(pbcardrequestlist, Record) ->
    [pack(1, repeated,
	  with_default(Record#pbcardrequestlist.list, none),
	  pbcardrequest, [])];
iolist(pbcardinfo, Record) ->
    [pack(1, optional,
	  with_default(Record#pbcardinfo.id, none), string, []),
     pack(2, optional,
	  with_default(Record#pbcardinfo.base_id, none), int32,
	  []),
     pack(3, optional,
	  with_default(Record#pbcardinfo.card_status, none),
	  int32, [])];
iolist(pbchallengerecord, Record) ->
    [pack(1, optional,
	  with_default(Record#pbchallengerecord.timestamp, none),
	  int32, []),
     pack(2, optional,
	  with_default(Record#pbchallengerecord.name, none),
	  string, []),
     pack(3, optional,
	  with_default(Record#pbchallengerecord.enemy_name, none),
	  string, []),
     pack(4, optional,
	  with_default(Record#pbchallengerecord.result, none),
	  int32, []),
     pack(5, optional,
	  with_default(Record#pbchallengerecord.league_thing,
		       none),
	  int32, [])];
iolist(pbchallengerecordlist, Record) ->
    [pack(1, repeated,
	  with_default(Record#pbchallengerecordlist.list, none),
	  pbchallengerecord, [])];
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
iolist(pbcountrecord, Record) ->
    [pack(1, optional,
	  with_default(Record#pbcountrecord.player_id, none),
	  int64, []),
     pack(2, optional,
	  with_default(Record#pbcountrecord.player_name, none),
	  string, []),
     pack(3, optional,
	  with_default(Record#pbcountrecord.win_times, none),
	  int32, []),
     pack(4, optional,
	  with_default(Record#pbcountrecord.loss_times, none),
	  int32, []),
     pack(5, optional,
	  with_default(Record#pbcountrecord.points, none), int32,
	  []),
     pack(6, optional,
	  with_default(Record#pbcountrecord.things, none), int32,
	  [])];
iolist(pbcountrecords, Record) ->
    [pack(1, repeated,
	  with_default(Record#pbcountrecords.records, none),
	  pbcountrecord, [])];
iolist(pbfightrecords, Record) ->
    [pack(1, repeated,
	  with_default(Record#pbfightrecords.def_records, none),
	  pbchallengerecord, []),
     pack(2, repeated,
	  with_default(Record#pbfightrecords.atk_records, none),
	  pbchallengerecord, [])];
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
iolist(pbg17guild, Record) ->
    [pack(1, optional,
	  with_default(Record#pbg17guild.guild_id, none), int32,
	  []),
     pack(2, optional,
	  with_default(Record#pbg17guild.guild_name, none),
	  string, []),
     pack(3, optional,
	  with_default(Record#pbg17guild.status, none), int32,
	  []),
     pack(4, optional,
	  with_default(Record#pbg17guild.owner_user_id, none),
	  string, [])];
iolist(pbg17guildlist, Record) ->
    [pack(1, repeated,
	  with_default(Record#pbg17guildlist.guilds, none),
	  pbg17guild, [])];
iolist(pbg17guildmember, Record) ->
    [pack(1, optional,
	  with_default(Record#pbg17guildmember.guild_id, none),
	  int32, []),
     pack(2, optional,
	  with_default(Record#pbg17guildmember.guild_name, none),
	  string, []),
     pack(4, optional,
	  with_default(Record#pbg17guildmember.title, none),
	  int32, []),
     pack(5, optional,
	  with_default(Record#pbg17guildmember.number, none),
	  int32, [])];
iolist(pbg17guildquery, Record) ->
    [pack(1, optional,
	  with_default(Record#pbg17guildquery.name, none), string,
	  []),
     pack(2, optional,
	  with_default(Record#pbg17guildquery.guild_id, none),
	  int32, [])];
iolist(pbgetleague, Record) ->
    [pack(1, optional,
	  with_default(Record#pbgetleague.last_key, none), int32,
	  []),
     pack(2, optional,
	  with_default(Record#pbgetleague.type, none), int32,
	  [])];
iolist(pbgetleaguegrouprankinfo, Record) ->
    [pack(1, optional,
	  with_default(Record#pbgetleaguegrouprankinfo.last_key,
		       none),
	  int32, []),
     pack(2, optional,
	  with_default(Record#pbgetleaguegrouprankinfo.type,
		       none),
	  int32, []),
     pack(3, optional,
	  with_default(Record#pbgetleaguegrouprankinfo.league_group,
		       none),
	  int32, [])];
iolist(pbgetleaguestatu, Record) ->
    [pack(1, optional,
	  with_default(Record#pbgetleaguestatu.type, none), int32,
	  []),
     pack(2, optional,
	  with_default(Record#pbgetleaguestatu.timestamp, none),
	  int32, [])];
iolist(pbgetpointrecord, Record) ->
    [pack(1, optional,
	  with_default(Record#pbgetpointrecord.league_id, none),
	  int32, []),
     pack(2, optional,
	  with_default(Record#pbgetpointrecord.point_id, none),
	  int32, [])];
iolist(pbgiftsid, Record) ->
    [pack(1, optional,
	  with_default(Record#pbgiftsid.gifts_id, none), int32,
	  [])];
iolist(pbgiftsrecord, Record) ->
    [pack(1, optional,
	  with_default(Record#pbgiftsrecord.timestamp, none),
	  int32, []),
     pack(2, optional,
	  with_default(Record#pbgiftsrecord.send_name, none),
	  string, []),
     pack(3, optional,
	  with_default(Record#pbgiftsrecord.recv_name, none),
	  string, []),
     pack(4, optional,
	  with_default(Record#pbgiftsrecord.type, none), int32,
	  []),
     pack(5, optional,
	  with_default(Record#pbgiftsrecord.value, none), int32,
	  [])];
iolist(pbgiftsrecordlist, Record) ->
    [pack(1, repeated,
	  with_default(Record#pbgiftsrecordlist.record_list,
		       none),
	  pbgiftsrecord, [])];
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
iolist(pbleagifts, Record) ->
    [pack(1, optional,
	  with_default(Record#pbleagifts.gifts_id, none), int32,
	  []),
     pack(2, optional,
	  with_default(Record#pbleagifts.timestamp, none), int32,
	  []),
     pack(3, optional,
	  with_default(Record#pbleagifts.name, none), string, []),
     pack(4, optional,
	  with_default(Record#pbleagifts.all_num, none), int32,
	  []),
     pack(5, optional,
	  with_default(Record#pbleagifts.remain_num, none), int32,
	  []),
     pack(6, optional,
	  with_default(Record#pbleagifts.value, none), int32, []),
     pack(7, optional,
	  with_default(Record#pbleagifts.has_recv, none), int32,
	  [])];
iolist(pbleague, Record) ->
    [pack(1, optional,
	  with_default(Record#pbleague.id, none), int32, []),
     pack(2, optional,
	  with_default(Record#pbleague.name, none), string, []),
     pack(3, optional,
	  with_default(Record#pbleague.cur_num, none), int32, []),
     pack(4, optional,
	  with_default(Record#pbleague.max_num, none), int32, []),
     pack(5, optional,
	  with_default(Record#pbleague.lv, none), int32, []),
     pack(6, optional,
	  with_default(Record#pbleague.ability_sum, none), int32,
	  []),
     pack(7, optional,
	  with_default(Record#pbleague.join_ability, none), int32,
	  []),
     pack(8, optional,
	  with_default(Record#pbleague.declaration, none), string,
	  []),
     pack(9, optional,
	  with_default(Record#pbleague.president, none), string,
	  []),
     pack(10, optional,
	  with_default(Record#pbleague.rank, none), int32, []),
     pack(11, optional,
	  with_default(Record#pbleague.league_gifts_num, none),
	  int32, []),
     pack(12, optional,
	  with_default(Record#pbleague.apply_league_fight, none),
	  int32, []),
     pack(13, optional,
	  with_default(Record#pbleague.league_exp, none), int32,
	  []),
     pack(14, optional,
	  with_default(Record#pbleague.g17_guild_id, none), int32,
	  []),
     pack(15, optional,
	  with_default(Record#pbleague.g17_guild_name, none),
	  string, [])];
iolist(pbleaguechallengeinfo, Record) ->
    [pack(1, optional,
	  with_default(Record#pbleaguechallengeinfo.player_id,
		       none),
	  int32, []),
     pack(2, optional,
	  with_default(Record#pbleaguechallengeinfo.name, none),
	  string, []),
     pack(3, optional,
	  with_default(Record#pbleaguechallengeinfo.lv, none),
	  int32, []),
     pack(4, optional,
	  with_default(Record#pbleaguechallengeinfo.title, none),
	  int32, []),
     pack(5, optional,
	  with_default(Record#pbleaguechallengeinfo.ability_sum,
		       none),
	  int32, []),
     pack(6, optional,
	  with_default(Record#pbleaguechallengeinfo.thing, none),
	  int32, []),
     pack(7, optional,
	  with_default(Record#pbleaguechallengeinfo.grab_num,
		       none),
	  int32, []),
     pack(8, optional,
	  with_default(Record#pbleaguechallengeinfo.career, none),
	  int32, []),
     pack(9, optional,
	  with_default(Record#pbleaguechallengeinfo.mult, none),
	  int32, [])];
iolist(pbleaguechallengelist, Record) ->
    [pack(1, repeated,
	  with_default(Record#pbleaguechallengelist.list, none),
	  pbleaguechallengeinfo, [])];
iolist(pbleaguechallengeresult, Record) ->
    [pack(1, optional,
	  with_default(Record#pbleaguechallengeresult.enemy_player_id,
		       none),
	  int32, []),
     pack(2, optional,
	  with_default(Record#pbleaguechallengeresult.result,
		       none),
	  int32, []),
     pack(3, optional,
	  with_default(Record#pbleaguechallengeresult.energy,
		       none),
	  int32, [])];
iolist(pbleaguefightpoint, Record) ->
    [pack(1, optional,
	  with_default(Record#pbleaguefightpoint.league_id, none),
	  int32, []),
     pack(2, optional,
	  with_default(Record#pbleaguefightpoint.point_id, none),
	  int32, []),
     pack(3, optional,
	  with_default(Record#pbleaguefightpoint.pos, none),
	  int32, []),
     pack(4, optional,
	  with_default(Record#pbleaguefightpoint.status, none),
	  int32, []),
     pack(5, repeated,
	  with_default(Record#pbleaguefightpoint.protect_info,
		       none),
	  pbprotectinfo, []),
     pack(6, repeated,
	  with_default(Record#pbleaguefightpoint.occurpy_info,
		       none),
	  pbprotectinfo, [])];
iolist(pbleaguefightpointlist, Record) ->
    [pack(1, repeated,
	  with_default(Record#pbleaguefightpointlist.list, none),
	  pbleaguefightpoint, [])];
iolist(pbleaguefightrankinfo, Record) ->
    [pack(1, optional,
	  with_default(Record#pbleaguefightrankinfo.score, none),
	  int32, []),
     pack(2, optional,
	  with_default(Record#pbleaguefightrankinfo.rank, none),
	  int32, [])];
iolist(pbleaguegifts, Record) ->
    [pack(1, repeated,
	  with_default(Record#pbleaguegifts.league_gifts_list,
		       none),
	  pbleagifts, [])];
iolist(pbleaguehouse, Record) ->
    [pack(1, repeated,
	  with_default(Record#pbleaguehouse.record_list, none),
	  pbleaguehouserecord, []),
     pack(2, optional,
	  with_default(Record#pbleaguehouse.gold, none), int32,
	  [])];
iolist(pbleaguehouserecord, Record) ->
    [pack(1, optional,
	  with_default(Record#pbleaguehouserecord.timestamp,
		       none),
	  int32, []),
     pack(2, optional,
	  with_default(Record#pbleaguehouserecord.name, none),
	  string, []),
     pack(3, optional,
	  with_default(Record#pbleaguehouserecord.value, none),
	  int32, [])];
iolist(pbleagueinfo, Record) ->
    [pack(1, optional,
	  with_default(Record#pbleagueinfo.name, none), string,
	  []),
     pack(2, optional,
	  with_default(Record#pbleagueinfo.league_id, none),
	  int32, []),
     pack(3, optional,
	  with_default(Record#pbleagueinfo.league_sn, none),
	  int32, []),
     pack(4, optional,
	  with_default(Record#pbleagueinfo.ability, none), int32,
	  []),
     pack(5, optional,
	  with_default(Record#pbleagueinfo.group_num, none),
	  int32, []),
     pack(6, optional,
	  with_default(Record#pbleagueinfo.thing, none), int32,
	  []),
     pack(7, optional,
	  with_default(Record#pbleagueinfo.occ_point_num, none),
	  int32, []),
     pack(8, optional,
	  with_default(Record#pbleagueinfo.remain_fight_num,
		       none),
	  int32, [])];
iolist(pbleagueinfolist, Record) ->
    [pack(1, repeated,
	  with_default(Record#pbleagueinfolist.list, none),
	  pbleagueinfo, [])];
iolist(pbleaguelist, Record) ->
    [pack(1, repeated,
	  with_default(Record#pbleaguelist.league_list, none),
	  pbleague, []),
     pack(2, optional,
	  with_default(Record#pbleaguelist.size, none), int32,
	  [])];
iolist(pbleaguemember, Record) ->
    [pack(1, optional,
	  with_default(Record#pbleaguemember.player_id, none),
	  int64, []),
     pack(2, optional,
	  with_default(Record#pbleaguemember.title, none), int32,
	  []),
     pack(3, optional,
	  with_default(Record#pbleaguemember.contribute, none),
	  int32, []),
     pack(4, optional,
	  with_default(Record#pbleaguemember.name, none), string,
	  []),
     pack(5, optional,
	  with_default(Record#pbleaguemember.lv, none), int32,
	  []),
     pack(6, optional,
	  with_default(Record#pbleaguemember.ability, none),
	  int32, []),
     pack(7, optional,
	  with_default(Record#pbleaguemember.g17_join_timestamp,
		       none),
	  int32, [])];
iolist(pbleaguememberlist, Record) ->
    [pack(1, repeated,
	  with_default(Record#pbleaguememberlist.member_list,
		       none),
	  pbleaguemember, [])];
iolist(pbleaguepointchallengeresult, Record) ->
    [pack(1, optional,
	  with_default(Record#pbleaguepointchallengeresult.point_id,
		       none),
	  int32, []),
     pack(2, optional,
	  with_default(Record#pbleaguepointchallengeresult.result,
		       none),
	  int32, []),
     pack(3, optional,
	  with_default(Record#pbleaguepointchallengeresult.energy,
		       none),
	  int32, [])];
iolist(pbleaguerankinfo, Record) ->
    [pack(1, optional,
	  with_default(Record#pbleaguerankinfo.league_id, none),
	  int32, []),
     pack(2, optional,
	  with_default(Record#pbleaguerankinfo.rank, none), int32,
	  []),
     pack(3, optional,
	  with_default(Record#pbleaguerankinfo.name, none),
	  string, []),
     pack(4, optional,
	  with_default(Record#pbleaguerankinfo.lv, none), int32,
	  []),
     pack(5, optional,
	  with_default(Record#pbleaguerankinfo.cur_num, none),
	  int32, []),
     pack(6, optional,
	  with_default(Record#pbleaguerankinfo.max_num, none),
	  int32, []),
     pack(7, optional,
	  with_default(Record#pbleaguerankinfo.ability_sum, none),
	  int32, []),
     pack(8, optional,
	  with_default(Record#pbleaguerankinfo.score, none),
	  int32, [])];
iolist(pbleagueranklist, Record) ->
    [pack(1, repeated,
	  with_default(Record#pbleagueranklist.list, none),
	  pbleaguerankinfo, []),
     pack(2, optional,
	  with_default(Record#pbleagueranklist.size, none), int32,
	  [])];
iolist(pbmasteragreemsg, Record) ->
    [pack(1, optional,
	  with_default(Record#pbmasteragreemsg.id, none), string,
	  []),
     pack(2, optional,
	  with_default(Record#pbmasteragreemsg.player_id, none),
	  int32, [])];
iolist(pbmastercard, Record) ->
    [pack(1, optional,
	  with_default(Record#pbmastercard.id, none), string, []),
     pack(2, optional,
	  with_default(Record#pbmastercard.master_goods_id, none),
	  int32, []),
     pack(3, optional,
	  with_default(Record#pbmastercard.apprentice_player_id,
		       none),
	  int32, []),
     pack(4, optional,
	  with_default(Record#pbmastercard.apprentice_player_name,
		       none),
	  string, []),
     pack(5, optional,
	  with_default(Record#pbmastercard.card_status, none),
	  int32, []),
     pack(6, optional,
	  with_default(Record#pbmastercard.work_day, none), int32,
	  [])];
iolist(pbmasterinfo, Record) ->
    [pack(1, optional,
	  with_default(Record#pbmasterinfo.id, none), int32, []),
     pack(2, optional,
	  with_default(Record#pbmasterinfo.name, none), string,
	  []),
     pack(3, optional,
	  with_default(Record#pbmasterinfo.lv, none), int32, []),
     pack(4, optional,
	  with_default(Record#pbmasterinfo.ability, none), int32,
	  []),
     pack(5, optional,
	  with_default(Record#pbmasterinfo.contribute, none),
	  int32, []),
     pack(6, optional,
	  with_default(Record#pbmasterinfo.title, none), int32,
	  []),
     pack(7, optional,
	  with_default(Record#pbmasterinfo.contribute_lv, none),
	  int32, []),
     pack(8, repeated,
	  with_default(Record#pbmasterinfo.card_list, none),
	  pbcardinfo, [])];
iolist(pbmembergetlisttype, Record) ->
    [pack(1, optional,
	  with_default(Record#pbmembergetlisttype.type, none),
	  int32, [])];
iolist(pbmembersendlist, Record) ->
    [pack(1, repeated,
	  with_default(Record#pbmembersendlist.list, none),
	  pbmembersendmsg, [])];
iolist(pbmembersendmsg, Record) ->
    [pack(1, optional,
	  with_default(Record#pbmembersendmsg.name, none), string,
	  []),
     pack(2, optional,
	  with_default(Record#pbmembersendmsg.value, none), int32,
	  [])];
iolist(pbonekeysendmsg, Record) ->
    [pack(1, repeated,
	  with_default(Record#pbonekeysendmsg.send_success_list,
		       none),
	  pbgiftsid, [])];
iolist(pbowncardsinfo, Record) ->
    [pack(1, repeated,
	  with_default(Record#pbowncardsinfo.master_card_list,
		       none),
	  pbmastercard, []),
     pack(2, repeated,
	  with_default(Record#pbowncardsinfo.apprentice_card_list,
		       none),
	  pbapprenticecard, []),
     pack(3, optional,
	  with_default(Record#pbowncardsinfo.remain_master_num,
		       none),
	  int32, [])];
iolist(pbowngifts, Record) ->
    [pack(1, repeated,
	  with_default(Record#pbowngifts.own_gifts_list, none),
	  pbplayergifts, [])];
iolist(pbplayergifts, Record) ->
    [pack(1, optional,
	  with_default(Record#pbplayergifts.gifts_id, none),
	  int32, []),
     pack(2, optional,
	  with_default(Record#pbplayergifts.timestamp, none),
	  int32, []),
     pack(3, optional,
	  with_default(Record#pbplayergifts.all_num, none), int32,
	  []),
     pack(4, optional,
	  with_default(Record#pbplayergifts.remain_num, none),
	  int32, []),
     pack(5, optional,
	  with_default(Record#pbplayergifts.recharge_gold_num,
		       none),
	  int32, []),
     pack(6, optional,
	  with_default(Record#pbplayergifts.sum_value, none),
	  int32, []),
     pack(7, optional,
	  with_default(Record#pbplayergifts.last_send, none),
	  int32, []),
     pack(8, optional,
	  with_default(Record#pbplayergifts.day_remain_num, none),
	  int32, [])];
iolist(pbpointchallengerecord, Record) ->
    [pack(1, optional,
	  with_default(Record#pbpointchallengerecord.timestamp,
		       none),
	  int32, []),
     pack(2, optional,
	  with_default(Record#pbpointchallengerecord.name, none),
	  string, []),
     pack(3, optional,
	  with_default(Record#pbpointchallengerecord.result,
		       none),
	  int32, []),
     pack(4, optional,
	  with_default(Record#pbpointchallengerecord.thing_reward,
		       none),
	  int32, [])];
iolist(pbpointchallengerecordinfo, Record) ->
    [pack(1, repeated,
	  with_default(Record#pbpointchallengerecordinfo.list,
		       none),
	  pbpointchallengerecord, [])];
iolist(pbpointprotectlist, Record) ->
    [pack(1, repeated,
	  with_default(Record#pbpointprotectlist.list, none),
	  pbprotectplayerinfo, [])];
iolist(pbpointsend, Record) ->
    [pack(1, optional,
	  with_default(Record#pbpointsend.gifts_id, none), int32,
	  []),
     pack(2, optional,
	  with_default(Record#pbpointsend.player_id, none), int32,
	  [])];
iolist(pbpointsendmsg, Record) ->
    [pack(1, optional,
	  with_default(Record#pbpointsendmsg.name, none), string,
	  []),
     pack(2, optional,
	  with_default(Record#pbpointsendmsg.lv, none), int32,
	  []),
     pack(3, optional,
	  with_default(Record#pbpointsendmsg.league_lv, none),
	  int32, []),
     pack(4, optional,
	  with_default(Record#pbpointsendmsg.player_id, none),
	  int32, [])];
iolist(pbpointsendmsglist, Record) ->
    [pack(1, repeated,
	  with_default(Record#pbpointsendmsglist.list, none),
	  pbpointsendmsg, [])];
iolist(pbprotectinfo, Record) ->
    [pack(1, optional,
	  with_default(Record#pbprotectinfo.name, none), string,
	  []),
     pack(2, optional,
	  with_default(Record#pbprotectinfo.id, none), int32,
	  [])];
iolist(pbprotectplayerinfo, Record) ->
    [pack(1, optional,
	  with_default(Record#pbprotectplayerinfo.player_id,
		       none),
	  int32, []),
     pack(2, optional,
	  with_default(Record#pbprotectplayerinfo.name, none),
	  string, []),
     pack(3, optional,
	  with_default(Record#pbprotectplayerinfo.lv, none),
	  int32, []),
     pack(4, optional,
	  with_default(Record#pbprotectplayerinfo.ability, none),
	  int32, []),
     pack(5, optional,
	  with_default(Record#pbprotectplayerinfo.contribute,
		       none),
	  int32, []),
     pack(6, optional,
	  with_default(Record#pbprotectplayerinfo.title, none),
	  int32, []),
     pack(7, optional,
	  with_default(Record#pbprotectplayerinfo.contribute_lv,
		       none),
	  int32, []),
     pack(8, optional,
	  with_default(Record#pbprotectplayerinfo.career, none),
	  int32, [])];
iolist(pbrequestgiftsmsg, Record) ->
    [pack(1, optional,
	  with_default(Record#pbrequestgiftsmsg.name, none),
	  string, []),
     pack(2, optional,
	  with_default(Record#pbrequestgiftsmsg.lv, none), int32,
	  []),
     pack(3, optional,
	  with_default(Record#pbrequestgiftsmsg.league_lv, none),
	  int32, []),
     pack(4, optional,
	  with_default(Record#pbrequestgiftsmsg.gifts_num, none),
	  int32, []),
     pack(5, optional,
	  with_default(Record#pbrequestgiftsmsg.player_id, none),
	  int32, []),
     pack(6, optional,
	  with_default(Record#pbrequestgiftsmsg.is_request, none),
	  int32, [])];
iolist(pbrequestgiftsmsglist, Record) ->
    [pack(1, repeated,
	  with_default(Record#pbrequestgiftsmsglist.list, none),
	  pbrequestgiftsmsg, [])];
iolist(pbrequestplayergiftsmsg, Record) ->
    [pack(1, optional,
	  with_default(Record#pbrequestplayergiftsmsg.name, none),
	  string, []),
     pack(2, optional,
	  with_default(Record#pbrequestplayergiftsmsg.player_id,
		       none),
	  int32, [])];
iolist(pbrequestplayergiftsmsglist, Record) ->
    [pack(1, repeated,
	  with_default(Record#pbrequestplayergiftsmsglist.list,
		       none),
	  pbrequestplayergiftsmsg, [])];
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
iolist(pbsendgiftsmsg, Record) ->
    [pack(1, optional,
	  with_default(Record#pbsendgiftsmsg.gifts_id, none),
	  int32, []),
     pack(2, optional,
	  with_default(Record#pbsendgiftsmsg.gifts_num, none),
	  int32, [])];
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
	  with_default(Record#pbskill.type, none), int32, [])].

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

decode_pbskill(Bytes) when is_binary(Bytes) ->
    decode(pbskill, Bytes).

decode_pbsendgiftsmsg(Bytes) when is_binary(Bytes) ->
    decode(pbsendgiftsmsg, Bytes).

decode_pbrewarditem(Bytes) when is_binary(Bytes) ->
    decode(pbrewarditem, Bytes).

decode_pbresult(Bytes) when is_binary(Bytes) ->
    decode(pbresult, Bytes).

decode_pbrequestplayergiftsmsglist(Bytes)
    when is_binary(Bytes) ->
    decode(pbrequestplayergiftsmsglist, Bytes).

decode_pbrequestplayergiftsmsg(Bytes)
    when is_binary(Bytes) ->
    decode(pbrequestplayergiftsmsg, Bytes).

decode_pbrequestgiftsmsglist(Bytes)
    when is_binary(Bytes) ->
    decode(pbrequestgiftsmsglist, Bytes).

decode_pbrequestgiftsmsg(Bytes) when is_binary(Bytes) ->
    decode(pbrequestgiftsmsg, Bytes).

decode_pbprotectplayerinfo(Bytes)
    when is_binary(Bytes) ->
    decode(pbprotectplayerinfo, Bytes).

decode_pbprotectinfo(Bytes) when is_binary(Bytes) ->
    decode(pbprotectinfo, Bytes).

decode_pbpointsendmsglist(Bytes)
    when is_binary(Bytes) ->
    decode(pbpointsendmsglist, Bytes).

decode_pbpointsendmsg(Bytes) when is_binary(Bytes) ->
    decode(pbpointsendmsg, Bytes).

decode_pbpointsend(Bytes) when is_binary(Bytes) ->
    decode(pbpointsend, Bytes).

decode_pbpointprotectlist(Bytes)
    when is_binary(Bytes) ->
    decode(pbpointprotectlist, Bytes).

decode_pbpointchallengerecordinfo(Bytes)
    when is_binary(Bytes) ->
    decode(pbpointchallengerecordinfo, Bytes).

decode_pbpointchallengerecord(Bytes)
    when is_binary(Bytes) ->
    decode(pbpointchallengerecord, Bytes).

decode_pbplayergifts(Bytes) when is_binary(Bytes) ->
    decode(pbplayergifts, Bytes).

decode_pbowngifts(Bytes) when is_binary(Bytes) ->
    decode(pbowngifts, Bytes).

decode_pbowncardsinfo(Bytes) when is_binary(Bytes) ->
    decode(pbowncardsinfo, Bytes).

decode_pbonekeysendmsg(Bytes) when is_binary(Bytes) ->
    decode(pbonekeysendmsg, Bytes).

decode_pbmembersendmsg(Bytes) when is_binary(Bytes) ->
    decode(pbmembersendmsg, Bytes).

decode_pbmembersendlist(Bytes) when is_binary(Bytes) ->
    decode(pbmembersendlist, Bytes).

decode_pbmembergetlisttype(Bytes)
    when is_binary(Bytes) ->
    decode(pbmembergetlisttype, Bytes).

decode_pbmasterinfo(Bytes) when is_binary(Bytes) ->
    decode(pbmasterinfo, Bytes).

decode_pbmastercard(Bytes) when is_binary(Bytes) ->
    decode(pbmastercard, Bytes).

decode_pbmasteragreemsg(Bytes) when is_binary(Bytes) ->
    decode(pbmasteragreemsg, Bytes).

decode_pbleagueranklist(Bytes) when is_binary(Bytes) ->
    decode(pbleagueranklist, Bytes).

decode_pbleaguerankinfo(Bytes) when is_binary(Bytes) ->
    decode(pbleaguerankinfo, Bytes).

decode_pbleaguepointchallengeresult(Bytes)
    when is_binary(Bytes) ->
    decode(pbleaguepointchallengeresult, Bytes).

decode_pbleaguememberlist(Bytes)
    when is_binary(Bytes) ->
    decode(pbleaguememberlist, Bytes).

decode_pbleaguemember(Bytes) when is_binary(Bytes) ->
    decode(pbleaguemember, Bytes).

decode_pbleaguelist(Bytes) when is_binary(Bytes) ->
    decode(pbleaguelist, Bytes).

decode_pbleagueinfolist(Bytes) when is_binary(Bytes) ->
    decode(pbleagueinfolist, Bytes).

decode_pbleagueinfo(Bytes) when is_binary(Bytes) ->
    decode(pbleagueinfo, Bytes).

decode_pbleaguehouserecord(Bytes)
    when is_binary(Bytes) ->
    decode(pbleaguehouserecord, Bytes).

decode_pbleaguehouse(Bytes) when is_binary(Bytes) ->
    decode(pbleaguehouse, Bytes).

decode_pbleaguegifts(Bytes) when is_binary(Bytes) ->
    decode(pbleaguegifts, Bytes).

decode_pbleaguefightrankinfo(Bytes)
    when is_binary(Bytes) ->
    decode(pbleaguefightrankinfo, Bytes).

decode_pbleaguefightpointlist(Bytes)
    when is_binary(Bytes) ->
    decode(pbleaguefightpointlist, Bytes).

decode_pbleaguefightpoint(Bytes)
    when is_binary(Bytes) ->
    decode(pbleaguefightpoint, Bytes).

decode_pbleaguechallengeresult(Bytes)
    when is_binary(Bytes) ->
    decode(pbleaguechallengeresult, Bytes).

decode_pbleaguechallengelist(Bytes)
    when is_binary(Bytes) ->
    decode(pbleaguechallengelist, Bytes).

decode_pbleaguechallengeinfo(Bytes)
    when is_binary(Bytes) ->
    decode(pbleaguechallengeinfo, Bytes).

decode_pbleague(Bytes) when is_binary(Bytes) ->
    decode(pbleague, Bytes).

decode_pbleagifts(Bytes) when is_binary(Bytes) ->
    decode(pbleagifts, Bytes).

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

decode_pbgiftsrecordlist(Bytes) when is_binary(Bytes) ->
    decode(pbgiftsrecordlist, Bytes).

decode_pbgiftsrecord(Bytes) when is_binary(Bytes) ->
    decode(pbgiftsrecord, Bytes).

decode_pbgiftsid(Bytes) when is_binary(Bytes) ->
    decode(pbgiftsid, Bytes).

decode_pbgetpointrecord(Bytes) when is_binary(Bytes) ->
    decode(pbgetpointrecord, Bytes).

decode_pbgetleaguestatu(Bytes) when is_binary(Bytes) ->
    decode(pbgetleaguestatu, Bytes).

decode_pbgetleaguegrouprankinfo(Bytes)
    when is_binary(Bytes) ->
    decode(pbgetleaguegrouprankinfo, Bytes).

decode_pbgetleague(Bytes) when is_binary(Bytes) ->
    decode(pbgetleague, Bytes).

decode_pbg17guildquery(Bytes) when is_binary(Bytes) ->
    decode(pbg17guildquery, Bytes).

decode_pbg17guildmember(Bytes) when is_binary(Bytes) ->
    decode(pbg17guildmember, Bytes).

decode_pbg17guildlist(Bytes) when is_binary(Bytes) ->
    decode(pbg17guildlist, Bytes).

decode_pbg17guild(Bytes) when is_binary(Bytes) ->
    decode(pbg17guild, Bytes).

decode_pbfriend(Bytes) when is_binary(Bytes) ->
    decode(pbfriend, Bytes).

decode_pbfightrecords(Bytes) when is_binary(Bytes) ->
    decode(pbfightrecords, Bytes).

decode_pbcountrecords(Bytes) when is_binary(Bytes) ->
    decode(pbcountrecords, Bytes).

decode_pbcountrecord(Bytes) when is_binary(Bytes) ->
    decode(pbcountrecord, Bytes).

decode_pbcombatreward(Bytes) when is_binary(Bytes) ->
    decode(pbcombatreward, Bytes).

decode_pbchallengerecordlist(Bytes)
    when is_binary(Bytes) ->
    decode(pbchallengerecordlist, Bytes).

decode_pbchallengerecord(Bytes) when is_binary(Bytes) ->
    decode(pbchallengerecord, Bytes).

decode_pbcardinfo(Bytes) when is_binary(Bytes) ->
    decode(pbcardinfo, Bytes).

decode_pbcardrequestlist(Bytes) when is_binary(Bytes) ->
    decode(pbcardrequestlist, Bytes).

decode_pbcardrequest(Bytes) when is_binary(Bytes) ->
    decode(pbcardrequest, Bytes).

decode_pbbosssendgold(Bytes) when is_binary(Bytes) ->
    decode(pbbosssendgold, Bytes).

decode_pbbossinvitemsg(Bytes) when is_binary(Bytes) ->
    decode(pbbossinvitemsg, Bytes).

decode_pbattribute(Bytes) when is_binary(Bytes) ->
    decode(pbattribute, Bytes).

decode_pbapprenticerequestinfo(Bytes)
    when is_binary(Bytes) ->
    decode(pbapprenticerequestinfo, Bytes).

decode_pbapprenticecard(Bytes) when is_binary(Bytes) ->
    decode(pbapprenticecard, Bytes).

decode_pbapprenticebuycard(Bytes)
    when is_binary(Bytes) ->
    decode(pbapprenticebuycard, Bytes).

decode_pbappointplayer(Bytes) when is_binary(Bytes) ->
    decode(pbappointplayer, Bytes).

decode_pballmasterinfo(Bytes) when is_binary(Bytes) ->
    decode(pballmasterinfo, Bytes).

decode_pbaddleaguemsg(Bytes) when is_binary(Bytes) ->
    decode(pbaddleaguemsg, Bytes).

delimited_decode_pbaddleaguemsg(Bytes) ->
    delimited_decode(pbaddleaguemsg, Bytes).

delimited_decode_pballmasterinfo(Bytes) ->
    delimited_decode(pballmasterinfo, Bytes).

delimited_decode_pbappointplayer(Bytes) ->
    delimited_decode(pbappointplayer, Bytes).

delimited_decode_pbapprenticebuycard(Bytes) ->
    delimited_decode(pbapprenticebuycard, Bytes).

delimited_decode_pbapprenticecard(Bytes) ->
    delimited_decode(pbapprenticecard, Bytes).

delimited_decode_pbapprenticerequestinfo(Bytes) ->
    delimited_decode(pbapprenticerequestinfo, Bytes).

delimited_decode_pbattribute(Bytes) ->
    delimited_decode(pbattribute, Bytes).

delimited_decode_pbbossinvitemsg(Bytes) ->
    delimited_decode(pbbossinvitemsg, Bytes).

delimited_decode_pbbosssendgold(Bytes) ->
    delimited_decode(pbbosssendgold, Bytes).

delimited_decode_pbcardrequest(Bytes) ->
    delimited_decode(pbcardrequest, Bytes).

delimited_decode_pbcardrequestlist(Bytes) ->
    delimited_decode(pbcardrequestlist, Bytes).

delimited_decode_pbcardinfo(Bytes) ->
    delimited_decode(pbcardinfo, Bytes).

delimited_decode_pbchallengerecord(Bytes) ->
    delimited_decode(pbchallengerecord, Bytes).

delimited_decode_pbchallengerecordlist(Bytes) ->
    delimited_decode(pbchallengerecordlist, Bytes).

delimited_decode_pbcombatreward(Bytes) ->
    delimited_decode(pbcombatreward, Bytes).

delimited_decode_pbcountrecord(Bytes) ->
    delimited_decode(pbcountrecord, Bytes).

delimited_decode_pbcountrecords(Bytes) ->
    delimited_decode(pbcountrecords, Bytes).

delimited_decode_pbfightrecords(Bytes) ->
    delimited_decode(pbfightrecords, Bytes).

delimited_decode_pbfriend(Bytes) ->
    delimited_decode(pbfriend, Bytes).

delimited_decode_pbg17guild(Bytes) ->
    delimited_decode(pbg17guild, Bytes).

delimited_decode_pbg17guildlist(Bytes) ->
    delimited_decode(pbg17guildlist, Bytes).

delimited_decode_pbg17guildmember(Bytes) ->
    delimited_decode(pbg17guildmember, Bytes).

delimited_decode_pbg17guildquery(Bytes) ->
    delimited_decode(pbg17guildquery, Bytes).

delimited_decode_pbgetleague(Bytes) ->
    delimited_decode(pbgetleague, Bytes).

delimited_decode_pbgetleaguegrouprankinfo(Bytes) ->
    delimited_decode(pbgetleaguegrouprankinfo, Bytes).

delimited_decode_pbgetleaguestatu(Bytes) ->
    delimited_decode(pbgetleaguestatu, Bytes).

delimited_decode_pbgetpointrecord(Bytes) ->
    delimited_decode(pbgetpointrecord, Bytes).

delimited_decode_pbgiftsid(Bytes) ->
    delimited_decode(pbgiftsid, Bytes).

delimited_decode_pbgiftsrecord(Bytes) ->
    delimited_decode(pbgiftsrecord, Bytes).

delimited_decode_pbgiftsrecordlist(Bytes) ->
    delimited_decode(pbgiftsrecordlist, Bytes).

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

delimited_decode_pbleagifts(Bytes) ->
    delimited_decode(pbleagifts, Bytes).

delimited_decode_pbleague(Bytes) ->
    delimited_decode(pbleague, Bytes).

delimited_decode_pbleaguechallengeinfo(Bytes) ->
    delimited_decode(pbleaguechallengeinfo, Bytes).

delimited_decode_pbleaguechallengelist(Bytes) ->
    delimited_decode(pbleaguechallengelist, Bytes).

delimited_decode_pbleaguechallengeresult(Bytes) ->
    delimited_decode(pbleaguechallengeresult, Bytes).

delimited_decode_pbleaguefightpoint(Bytes) ->
    delimited_decode(pbleaguefightpoint, Bytes).

delimited_decode_pbleaguefightpointlist(Bytes) ->
    delimited_decode(pbleaguefightpointlist, Bytes).

delimited_decode_pbleaguefightrankinfo(Bytes) ->
    delimited_decode(pbleaguefightrankinfo, Bytes).

delimited_decode_pbleaguegifts(Bytes) ->
    delimited_decode(pbleaguegifts, Bytes).

delimited_decode_pbleaguehouse(Bytes) ->
    delimited_decode(pbleaguehouse, Bytes).

delimited_decode_pbleaguehouserecord(Bytes) ->
    delimited_decode(pbleaguehouserecord, Bytes).

delimited_decode_pbleagueinfo(Bytes) ->
    delimited_decode(pbleagueinfo, Bytes).

delimited_decode_pbleagueinfolist(Bytes) ->
    delimited_decode(pbleagueinfolist, Bytes).

delimited_decode_pbleaguelist(Bytes) ->
    delimited_decode(pbleaguelist, Bytes).

delimited_decode_pbleaguemember(Bytes) ->
    delimited_decode(pbleaguemember, Bytes).

delimited_decode_pbleaguememberlist(Bytes) ->
    delimited_decode(pbleaguememberlist, Bytes).

delimited_decode_pbleaguepointchallengeresult(Bytes) ->
    delimited_decode(pbleaguepointchallengeresult, Bytes).

delimited_decode_pbleaguerankinfo(Bytes) ->
    delimited_decode(pbleaguerankinfo, Bytes).

delimited_decode_pbleagueranklist(Bytes) ->
    delimited_decode(pbleagueranklist, Bytes).

delimited_decode_pbmasteragreemsg(Bytes) ->
    delimited_decode(pbmasteragreemsg, Bytes).

delimited_decode_pbmastercard(Bytes) ->
    delimited_decode(pbmastercard, Bytes).

delimited_decode_pbmasterinfo(Bytes) ->
    delimited_decode(pbmasterinfo, Bytes).

delimited_decode_pbmembergetlisttype(Bytes) ->
    delimited_decode(pbmembergetlisttype, Bytes).

delimited_decode_pbmembersendlist(Bytes) ->
    delimited_decode(pbmembersendlist, Bytes).

delimited_decode_pbmembersendmsg(Bytes) ->
    delimited_decode(pbmembersendmsg, Bytes).

delimited_decode_pbonekeysendmsg(Bytes) ->
    delimited_decode(pbonekeysendmsg, Bytes).

delimited_decode_pbowncardsinfo(Bytes) ->
    delimited_decode(pbowncardsinfo, Bytes).

delimited_decode_pbowngifts(Bytes) ->
    delimited_decode(pbowngifts, Bytes).

delimited_decode_pbplayergifts(Bytes) ->
    delimited_decode(pbplayergifts, Bytes).

delimited_decode_pbpointchallengerecord(Bytes) ->
    delimited_decode(pbpointchallengerecord, Bytes).

delimited_decode_pbpointchallengerecordinfo(Bytes) ->
    delimited_decode(pbpointchallengerecordinfo, Bytes).

delimited_decode_pbpointprotectlist(Bytes) ->
    delimited_decode(pbpointprotectlist, Bytes).

delimited_decode_pbpointsend(Bytes) ->
    delimited_decode(pbpointsend, Bytes).

delimited_decode_pbpointsendmsg(Bytes) ->
    delimited_decode(pbpointsendmsg, Bytes).

delimited_decode_pbpointsendmsglist(Bytes) ->
    delimited_decode(pbpointsendmsglist, Bytes).

delimited_decode_pbprotectinfo(Bytes) ->
    delimited_decode(pbprotectinfo, Bytes).

delimited_decode_pbprotectplayerinfo(Bytes) ->
    delimited_decode(pbprotectplayerinfo, Bytes).

delimited_decode_pbrequestgiftsmsg(Bytes) ->
    delimited_decode(pbrequestgiftsmsg, Bytes).

delimited_decode_pbrequestgiftsmsglist(Bytes) ->
    delimited_decode(pbrequestgiftsmsglist, Bytes).

delimited_decode_pbrequestplayergiftsmsg(Bytes) ->
    delimited_decode(pbrequestplayergiftsmsg, Bytes).

delimited_decode_pbrequestplayergiftsmsglist(Bytes) ->
    delimited_decode(pbrequestplayergiftsmsglist, Bytes).

delimited_decode_pbresult(Bytes) ->
    delimited_decode(pbresult, Bytes).

delimited_decode_pbrewarditem(Bytes) ->
    delimited_decode(pbrewarditem, Bytes).

delimited_decode_pbsendgiftsmsg(Bytes) ->
    delimited_decode(pbsendgiftsmsg, Bytes).

delimited_decode_pbskill(Bytes) ->
    delimited_decode(pbskill, Bytes).

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
decode(pbaddleaguemsg, Bytes) when is_binary(Bytes) ->
    Types = [{2, type, int32, []},
	     {1, league_id, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbaddleaguemsg, Decoded);
decode(pballmasterinfo, Bytes) when is_binary(Bytes) ->
    Types = [{1, list, pbmasterinfo,
	      [is_record, repeated]}],
    Defaults = [{1, list, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pballmasterinfo, Decoded);
decode(pbappointplayer, Bytes) when is_binary(Bytes) ->
    Types = [{2, player_id, int32, []},
	     {1, point_id, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbappointplayer, Decoded);
decode(pbapprenticebuycard, Bytes)
    when is_binary(Bytes) ->
    Types = [{2, type, int32, []}, {1, id, string, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbapprenticebuycard, Decoded);
decode(pbapprenticecard, Bytes) when is_binary(Bytes) ->
    Types = [{6, work_day, int32, []},
	     {5, card_status, int32, []},
	     {4, apprentice_goods_id, int32, []},
	     {3, master_player_name, string, []},
	     {2, master_player_id, int32, []}, {1, id, string, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbapprenticecard, Decoded);
decode(pbapprenticerequestinfo, Bytes)
    when is_binary(Bytes) ->
    Types = [{2, name, string, []}, {1, id, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbapprenticerequestinfo, Decoded);
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
decode(pbbossinvitemsg, Bytes) when is_binary(Bytes) ->
    Types = [{3, league_id, int32, []},
	     {2, league_name, string, []},
	     {1, boss_name, string, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbbossinvitemsg, Decoded);
decode(pbbosssendgold, Bytes) when is_binary(Bytes) ->
    Types = [{1, gold_num, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbbosssendgold, Decoded);
decode(pbcardrequest, Bytes) when is_binary(Bytes) ->
    Types = [{2, list, pbapprenticerequestinfo,
	      [is_record, repeated]},
	     {1, id, string, []}],
    Defaults = [{2, list, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbcardrequest, Decoded);
decode(pbcardrequestlist, Bytes)
    when is_binary(Bytes) ->
    Types = [{1, list, pbcardrequest,
	      [is_record, repeated]}],
    Defaults = [{1, list, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbcardrequestlist, Decoded);
decode(pbcardinfo, Bytes) when is_binary(Bytes) ->
    Types = [{3, card_status, int32, []},
	     {2, base_id, int32, []}, {1, id, string, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbcardinfo, Decoded);
decode(pbchallengerecord, Bytes)
    when is_binary(Bytes) ->
    Types = [{5, league_thing, int32, []},
	     {4, result, int32, []}, {3, enemy_name, string, []},
	     {2, name, string, []}, {1, timestamp, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbchallengerecord, Decoded);
decode(pbchallengerecordlist, Bytes)
    when is_binary(Bytes) ->
    Types = [{1, list, pbchallengerecord,
	      [is_record, repeated]}],
    Defaults = [{1, list, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbchallengerecordlist, Decoded);
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
decode(pbcountrecord, Bytes) when is_binary(Bytes) ->
    Types = [{6, things, int32, []}, {5, points, int32, []},
	     {4, loss_times, int32, []}, {3, win_times, int32, []},
	     {2, player_name, string, []},
	     {1, player_id, int64, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbcountrecord, Decoded);
decode(pbcountrecords, Bytes) when is_binary(Bytes) ->
    Types = [{1, records, pbcountrecord,
	      [is_record, repeated]}],
    Defaults = [{1, records, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbcountrecords, Decoded);
decode(pbfightrecords, Bytes) when is_binary(Bytes) ->
    Types = [{2, atk_records, pbchallengerecord,
	      [is_record, repeated]},
	     {1, def_records, pbchallengerecord,
	      [is_record, repeated]}],
    Defaults = [{1, def_records, []}, {2, atk_records, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbfightrecords, Decoded);
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
decode(pbg17guild, Bytes) when is_binary(Bytes) ->
    Types = [{4, owner_user_id, string, []},
	     {3, status, int32, []}, {2, guild_name, string, []},
	     {1, guild_id, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbg17guild, Decoded);
decode(pbg17guildlist, Bytes) when is_binary(Bytes) ->
    Types = [{1, guilds, pbg17guild,
	      [is_record, repeated]}],
    Defaults = [{1, guilds, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbg17guildlist, Decoded);
decode(pbg17guildmember, Bytes) when is_binary(Bytes) ->
    Types = [{5, number, int32, []}, {4, title, int32, []},
	     {2, guild_name, string, []}, {1, guild_id, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbg17guildmember, Decoded);
decode(pbg17guildquery, Bytes) when is_binary(Bytes) ->
    Types = [{2, guild_id, int32, []},
	     {1, name, string, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbg17guildquery, Decoded);
decode(pbgetleague, Bytes) when is_binary(Bytes) ->
    Types = [{2, type, int32, []},
	     {1, last_key, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbgetleague, Decoded);
decode(pbgetleaguegrouprankinfo, Bytes)
    when is_binary(Bytes) ->
    Types = [{3, league_group, int32, []},
	     {2, type, int32, []}, {1, last_key, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbgetleaguegrouprankinfo, Decoded);
decode(pbgetleaguestatu, Bytes) when is_binary(Bytes) ->
    Types = [{2, timestamp, int32, []},
	     {1, type, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbgetleaguestatu, Decoded);
decode(pbgetpointrecord, Bytes) when is_binary(Bytes) ->
    Types = [{2, point_id, int32, []},
	     {1, league_id, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbgetpointrecord, Decoded);
decode(pbgiftsid, Bytes) when is_binary(Bytes) ->
    Types = [{1, gifts_id, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbgiftsid, Decoded);
decode(pbgiftsrecord, Bytes) when is_binary(Bytes) ->
    Types = [{5, value, int32, []}, {4, type, int32, []},
	     {3, recv_name, string, []}, {2, send_name, string, []},
	     {1, timestamp, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbgiftsrecord, Decoded);
decode(pbgiftsrecordlist, Bytes)
    when is_binary(Bytes) ->
    Types = [{1, record_list, pbgiftsrecord,
	      [is_record, repeated]}],
    Defaults = [{1, record_list, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbgiftsrecordlist, Decoded);
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
decode(pbleagifts, Bytes) when is_binary(Bytes) ->
    Types = [{7, has_recv, int32, []},
	     {6, value, int32, []}, {5, remain_num, int32, []},
	     {4, all_num, int32, []}, {3, name, string, []},
	     {2, timestamp, int32, []}, {1, gifts_id, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbleagifts, Decoded);
decode(pbleague, Bytes) when is_binary(Bytes) ->
    Types = [{15, g17_guild_name, string, []},
	     {14, g17_guild_id, int32, []},
	     {13, league_exp, int32, []},
	     {12, apply_league_fight, int32, []},
	     {11, league_gifts_num, int32, []},
	     {10, rank, int32, []}, {9, president, string, []},
	     {8, declaration, string, []},
	     {7, join_ability, int32, []},
	     {6, ability_sum, int32, []}, {5, lv, int32, []},
	     {4, max_num, int32, []}, {3, cur_num, int32, []},
	     {2, name, string, []}, {1, id, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbleague, Decoded);
decode(pbleaguechallengeinfo, Bytes)
    when is_binary(Bytes) ->
    Types = [{9, mult, int32, []}, {8, career, int32, []},
	     {7, grab_num, int32, []}, {6, thing, int32, []},
	     {5, ability_sum, int32, []}, {4, title, int32, []},
	     {3, lv, int32, []}, {2, name, string, []},
	     {1, player_id, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbleaguechallengeinfo, Decoded);
decode(pbleaguechallengelist, Bytes)
    when is_binary(Bytes) ->
    Types = [{1, list, pbleaguechallengeinfo,
	      [is_record, repeated]}],
    Defaults = [{1, list, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbleaguechallengelist, Decoded);
decode(pbleaguechallengeresult, Bytes)
    when is_binary(Bytes) ->
    Types = [{3, energy, int32, []}, {2, result, int32, []},
	     {1, enemy_player_id, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbleaguechallengeresult, Decoded);
decode(pbleaguefightpoint, Bytes)
    when is_binary(Bytes) ->
    Types = [{6, occurpy_info, pbprotectinfo,
	      [is_record, repeated]},
	     {5, protect_info, pbprotectinfo, [is_record, repeated]},
	     {4, status, int32, []}, {3, pos, int32, []},
	     {2, point_id, int32, []}, {1, league_id, int32, []}],
    Defaults = [{5, protect_info, []},
		{6, occurpy_info, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbleaguefightpoint, Decoded);
decode(pbleaguefightpointlist, Bytes)
    when is_binary(Bytes) ->
    Types = [{1, list, pbleaguefightpoint,
	      [is_record, repeated]}],
    Defaults = [{1, list, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbleaguefightpointlist, Decoded);
decode(pbleaguefightrankinfo, Bytes)
    when is_binary(Bytes) ->
    Types = [{2, rank, int32, []}, {1, score, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbleaguefightrankinfo, Decoded);
decode(pbleaguegifts, Bytes) when is_binary(Bytes) ->
    Types = [{1, league_gifts_list, pbleagifts,
	      [is_record, repeated]}],
    Defaults = [{1, league_gifts_list, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbleaguegifts, Decoded);
decode(pbleaguehouse, Bytes) when is_binary(Bytes) ->
    Types = [{2, gold, int32, []},
	     {1, record_list, pbleaguehouserecord,
	      [is_record, repeated]}],
    Defaults = [{1, record_list, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbleaguehouse, Decoded);
decode(pbleaguehouserecord, Bytes)
    when is_binary(Bytes) ->
    Types = [{3, value, int32, []}, {2, name, string, []},
	     {1, timestamp, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbleaguehouserecord, Decoded);
decode(pbleagueinfo, Bytes) when is_binary(Bytes) ->
    Types = [{8, remain_fight_num, int32, []},
	     {7, occ_point_num, int32, []}, {6, thing, int32, []},
	     {5, group_num, int32, []}, {4, ability, int32, []},
	     {3, league_sn, int32, []}, {2, league_id, int32, []},
	     {1, name, string, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbleagueinfo, Decoded);
decode(pbleagueinfolist, Bytes) when is_binary(Bytes) ->
    Types = [{1, list, pbleagueinfo,
	      [is_record, repeated]}],
    Defaults = [{1, list, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbleagueinfolist, Decoded);
decode(pbleaguelist, Bytes) when is_binary(Bytes) ->
    Types = [{2, size, int32, []},
	     {1, league_list, pbleague, [is_record, repeated]}],
    Defaults = [{1, league_list, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbleaguelist, Decoded);
decode(pbleaguemember, Bytes) when is_binary(Bytes) ->
    Types = [{7, g17_join_timestamp, int32, []},
	     {6, ability, int32, []}, {5, lv, int32, []},
	     {4, name, string, []}, {3, contribute, int32, []},
	     {2, title, int32, []}, {1, player_id, int64, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbleaguemember, Decoded);
decode(pbleaguememberlist, Bytes)
    when is_binary(Bytes) ->
    Types = [{1, member_list, pbleaguemember,
	      [is_record, repeated]}],
    Defaults = [{1, member_list, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbleaguememberlist, Decoded);
decode(pbleaguepointchallengeresult, Bytes)
    when is_binary(Bytes) ->
    Types = [{3, energy, int32, []}, {2, result, int32, []},
	     {1, point_id, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbleaguepointchallengeresult, Decoded);
decode(pbleaguerankinfo, Bytes) when is_binary(Bytes) ->
    Types = [{8, score, int32, []},
	     {7, ability_sum, int32, []}, {6, max_num, int32, []},
	     {5, cur_num, int32, []}, {4, lv, int32, []},
	     {3, name, string, []}, {2, rank, int32, []},
	     {1, league_id, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbleaguerankinfo, Decoded);
decode(pbleagueranklist, Bytes) when is_binary(Bytes) ->
    Types = [{2, size, int32, []},
	     {1, list, pbleaguerankinfo, [is_record, repeated]}],
    Defaults = [{1, list, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbleagueranklist, Decoded);
decode(pbmasteragreemsg, Bytes) when is_binary(Bytes) ->
    Types = [{2, player_id, int32, []},
	     {1, id, string, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbmasteragreemsg, Decoded);
decode(pbmastercard, Bytes) when is_binary(Bytes) ->
    Types = [{6, work_day, int32, []},
	     {5, card_status, int32, []},
	     {4, apprentice_player_name, string, []},
	     {3, apprentice_player_id, int32, []},
	     {2, master_goods_id, int32, []}, {1, id, string, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbmastercard, Decoded);
decode(pbmasterinfo, Bytes) when is_binary(Bytes) ->
    Types = [{8, card_list, pbcardinfo,
	      [is_record, repeated]},
	     {7, contribute_lv, int32, []}, {6, title, int32, []},
	     {5, contribute, int32, []}, {4, ability, int32, []},
	     {3, lv, int32, []}, {2, name, string, []},
	     {1, id, int32, []}],
    Defaults = [{8, card_list, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbmasterinfo, Decoded);
decode(pbmembergetlisttype, Bytes)
    when is_binary(Bytes) ->
    Types = [{1, type, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbmembergetlisttype, Decoded);
decode(pbmembersendlist, Bytes) when is_binary(Bytes) ->
    Types = [{1, list, pbmembersendmsg,
	      [is_record, repeated]}],
    Defaults = [{1, list, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbmembersendlist, Decoded);
decode(pbmembersendmsg, Bytes) when is_binary(Bytes) ->
    Types = [{2, value, int32, []}, {1, name, string, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbmembersendmsg, Decoded);
decode(pbonekeysendmsg, Bytes) when is_binary(Bytes) ->
    Types = [{1, send_success_list, pbgiftsid,
	      [is_record, repeated]}],
    Defaults = [{1, send_success_list, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbonekeysendmsg, Decoded);
decode(pbowncardsinfo, Bytes) when is_binary(Bytes) ->
    Types = [{3, remain_master_num, int32, []},
	     {2, apprentice_card_list, pbapprenticecard,
	      [is_record, repeated]},
	     {1, master_card_list, pbmastercard,
	      [is_record, repeated]}],
    Defaults = [{1, master_card_list, []},
		{2, apprentice_card_list, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbowncardsinfo, Decoded);
decode(pbowngifts, Bytes) when is_binary(Bytes) ->
    Types = [{1, own_gifts_list, pbplayergifts,
	      [is_record, repeated]}],
    Defaults = [{1, own_gifts_list, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbowngifts, Decoded);
decode(pbplayergifts, Bytes) when is_binary(Bytes) ->
    Types = [{8, day_remain_num, int32, []},
	     {7, last_send, int32, []}, {6, sum_value, int32, []},
	     {5, recharge_gold_num, int32, []},
	     {4, remain_num, int32, []}, {3, all_num, int32, []},
	     {2, timestamp, int32, []}, {1, gifts_id, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbplayergifts, Decoded);
decode(pbpointchallengerecord, Bytes)
    when is_binary(Bytes) ->
    Types = [{4, thing_reward, int32, []},
	     {3, result, int32, []}, {2, name, string, []},
	     {1, timestamp, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbpointchallengerecord, Decoded);
decode(pbpointchallengerecordinfo, Bytes)
    when is_binary(Bytes) ->
    Types = [{1, list, pbpointchallengerecord,
	      [is_record, repeated]}],
    Defaults = [{1, list, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbpointchallengerecordinfo, Decoded);
decode(pbpointprotectlist, Bytes)
    when is_binary(Bytes) ->
    Types = [{1, list, pbprotectplayerinfo,
	      [is_record, repeated]}],
    Defaults = [{1, list, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbpointprotectlist, Decoded);
decode(pbpointsend, Bytes) when is_binary(Bytes) ->
    Types = [{2, player_id, int32, []},
	     {1, gifts_id, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbpointsend, Decoded);
decode(pbpointsendmsg, Bytes) when is_binary(Bytes) ->
    Types = [{4, player_id, int32, []},
	     {3, league_lv, int32, []}, {2, lv, int32, []},
	     {1, name, string, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbpointsendmsg, Decoded);
decode(pbpointsendmsglist, Bytes)
    when is_binary(Bytes) ->
    Types = [{1, list, pbpointsendmsg,
	      [is_record, repeated]}],
    Defaults = [{1, list, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbpointsendmsglist, Decoded);
decode(pbprotectinfo, Bytes) when is_binary(Bytes) ->
    Types = [{2, id, int32, []}, {1, name, string, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbprotectinfo, Decoded);
decode(pbprotectplayerinfo, Bytes)
    when is_binary(Bytes) ->
    Types = [{8, career, int32, []},
	     {7, contribute_lv, int32, []}, {6, title, int32, []},
	     {5, contribute, int32, []}, {4, ability, int32, []},
	     {3, lv, int32, []}, {2, name, string, []},
	     {1, player_id, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbprotectplayerinfo, Decoded);
decode(pbrequestgiftsmsg, Bytes)
    when is_binary(Bytes) ->
    Types = [{6, is_request, int32, []},
	     {5, player_id, int32, []}, {4, gifts_num, int32, []},
	     {3, league_lv, int32, []}, {2, lv, int32, []},
	     {1, name, string, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbrequestgiftsmsg, Decoded);
decode(pbrequestgiftsmsglist, Bytes)
    when is_binary(Bytes) ->
    Types = [{1, list, pbrequestgiftsmsg,
	      [is_record, repeated]}],
    Defaults = [{1, list, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbrequestgiftsmsglist, Decoded);
decode(pbrequestplayergiftsmsg, Bytes)
    when is_binary(Bytes) ->
    Types = [{2, player_id, int32, []},
	     {1, name, string, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbrequestplayergiftsmsg, Decoded);
decode(pbrequestplayergiftsmsglist, Bytes)
    when is_binary(Bytes) ->
    Types = [{1, list, pbrequestplayergiftsmsg,
	      [is_record, repeated]}],
    Defaults = [{1, list, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbrequestplayergiftsmsglist, Decoded);
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
decode(pbsendgiftsmsg, Bytes) when is_binary(Bytes) ->
    Types = [{2, gifts_num, int32, []},
	     {1, gifts_id, int32, []}],
    Defaults = [],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbsendgiftsmsg, Decoded);
decode(pbskill, Bytes) when is_binary(Bytes) ->
    Types = [{7, type, int32, []},
	     {6, sigil, int32, [repeated]}, {5, str_lv, int32, []},
	     {4, lv, int32, []}, {3, player_id, int32, []},
	     {2, skill_id, int32, []}, {1, id, int32, []}],
    Defaults = [{6, sigil, []}],
    Decoded = decode(Bytes, Types, Defaults),
    to_record(pbskill, Decoded).

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

to_record(pbaddleaguemsg, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbaddleaguemsg),
						   Record, Name, Val)
			  end,
			  #pbaddleaguemsg{}, DecodedTuples),
    Record1;
to_record(pballmasterinfo, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pballmasterinfo),
						   Record, Name, Val)
			  end,
			  #pballmasterinfo{}, DecodedTuples),
    Record1;
to_record(pbappointplayer, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbappointplayer),
						   Record, Name, Val)
			  end,
			  #pbappointplayer{}, DecodedTuples),
    Record1;
to_record(pbapprenticebuycard, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbapprenticebuycard),
						   Record, Name, Val)
			  end,
			  #pbapprenticebuycard{}, DecodedTuples),
    Record1;
to_record(pbapprenticecard, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbapprenticecard),
						   Record, Name, Val)
			  end,
			  #pbapprenticecard{}, DecodedTuples),
    Record1;
to_record(pbapprenticerequestinfo, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbapprenticerequestinfo),
						   Record, Name, Val)
			  end,
			  #pbapprenticerequestinfo{}, DecodedTuples),
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
to_record(pbbossinvitemsg, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbbossinvitemsg),
						   Record, Name, Val)
			  end,
			  #pbbossinvitemsg{}, DecodedTuples),
    Record1;
to_record(pbbosssendgold, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbbosssendgold),
						   Record, Name, Val)
			  end,
			  #pbbosssendgold{}, DecodedTuples),
    Record1;
to_record(pbcardrequest, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbcardrequest),
						   Record, Name, Val)
			  end,
			  #pbcardrequest{}, DecodedTuples),
    Record1;
to_record(pbcardrequestlist, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbcardrequestlist),
						   Record, Name, Val)
			  end,
			  #pbcardrequestlist{}, DecodedTuples),
    Record1;
to_record(pbcardinfo, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbcardinfo),
						   Record, Name, Val)
			  end,
			  #pbcardinfo{}, DecodedTuples),
    Record1;
to_record(pbchallengerecord, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbchallengerecord),
						   Record, Name, Val)
			  end,
			  #pbchallengerecord{}, DecodedTuples),
    Record1;
to_record(pbchallengerecordlist, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbchallengerecordlist),
						   Record, Name, Val)
			  end,
			  #pbchallengerecordlist{}, DecodedTuples),
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
to_record(pbcountrecord, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbcountrecord),
						   Record, Name, Val)
			  end,
			  #pbcountrecord{}, DecodedTuples),
    Record1;
to_record(pbcountrecords, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbcountrecords),
						   Record, Name, Val)
			  end,
			  #pbcountrecords{}, DecodedTuples),
    Record1;
to_record(pbfightrecords, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbfightrecords),
						   Record, Name, Val)
			  end,
			  #pbfightrecords{}, DecodedTuples),
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
to_record(pbg17guild, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbg17guild),
						   Record, Name, Val)
			  end,
			  #pbg17guild{}, DecodedTuples),
    Record1;
to_record(pbg17guildlist, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbg17guildlist),
						   Record, Name, Val)
			  end,
			  #pbg17guildlist{}, DecodedTuples),
    Record1;
to_record(pbg17guildmember, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbg17guildmember),
						   Record, Name, Val)
			  end,
			  #pbg17guildmember{}, DecodedTuples),
    Record1;
to_record(pbg17guildquery, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbg17guildquery),
						   Record, Name, Val)
			  end,
			  #pbg17guildquery{}, DecodedTuples),
    Record1;
to_record(pbgetleague, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbgetleague),
						   Record, Name, Val)
			  end,
			  #pbgetleague{}, DecodedTuples),
    Record1;
to_record(pbgetleaguegrouprankinfo, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbgetleaguegrouprankinfo),
						   Record, Name, Val)
			  end,
			  #pbgetleaguegrouprankinfo{}, DecodedTuples),
    Record1;
to_record(pbgetleaguestatu, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbgetleaguestatu),
						   Record, Name, Val)
			  end,
			  #pbgetleaguestatu{}, DecodedTuples),
    Record1;
to_record(pbgetpointrecord, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbgetpointrecord),
						   Record, Name, Val)
			  end,
			  #pbgetpointrecord{}, DecodedTuples),
    Record1;
to_record(pbgiftsid, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbgiftsid),
						   Record, Name, Val)
			  end,
			  #pbgiftsid{}, DecodedTuples),
    Record1;
to_record(pbgiftsrecord, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbgiftsrecord),
						   Record, Name, Val)
			  end,
			  #pbgiftsrecord{}, DecodedTuples),
    Record1;
to_record(pbgiftsrecordlist, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbgiftsrecordlist),
						   Record, Name, Val)
			  end,
			  #pbgiftsrecordlist{}, DecodedTuples),
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
to_record(pbleagifts, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbleagifts),
						   Record, Name, Val)
			  end,
			  #pbleagifts{}, DecodedTuples),
    Record1;
to_record(pbleague, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbleague),
						   Record, Name, Val)
			  end,
			  #pbleague{}, DecodedTuples),
    Record1;
to_record(pbleaguechallengeinfo, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbleaguechallengeinfo),
						   Record, Name, Val)
			  end,
			  #pbleaguechallengeinfo{}, DecodedTuples),
    Record1;
to_record(pbleaguechallengelist, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbleaguechallengelist),
						   Record, Name, Val)
			  end,
			  #pbleaguechallengelist{}, DecodedTuples),
    Record1;
to_record(pbleaguechallengeresult, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbleaguechallengeresult),
						   Record, Name, Val)
			  end,
			  #pbleaguechallengeresult{}, DecodedTuples),
    Record1;
to_record(pbleaguefightpoint, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbleaguefightpoint),
						   Record, Name, Val)
			  end,
			  #pbleaguefightpoint{}, DecodedTuples),
    Record1;
to_record(pbleaguefightpointlist, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbleaguefightpointlist),
						   Record, Name, Val)
			  end,
			  #pbleaguefightpointlist{}, DecodedTuples),
    Record1;
to_record(pbleaguefightrankinfo, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbleaguefightrankinfo),
						   Record, Name, Val)
			  end,
			  #pbleaguefightrankinfo{}, DecodedTuples),
    Record1;
to_record(pbleaguegifts, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbleaguegifts),
						   Record, Name, Val)
			  end,
			  #pbleaguegifts{}, DecodedTuples),
    Record1;
to_record(pbleaguehouse, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbleaguehouse),
						   Record, Name, Val)
			  end,
			  #pbleaguehouse{}, DecodedTuples),
    Record1;
to_record(pbleaguehouserecord, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbleaguehouserecord),
						   Record, Name, Val)
			  end,
			  #pbleaguehouserecord{}, DecodedTuples),
    Record1;
to_record(pbleagueinfo, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbleagueinfo),
						   Record, Name, Val)
			  end,
			  #pbleagueinfo{}, DecodedTuples),
    Record1;
to_record(pbleagueinfolist, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbleagueinfolist),
						   Record, Name, Val)
			  end,
			  #pbleagueinfolist{}, DecodedTuples),
    Record1;
to_record(pbleaguelist, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbleaguelist),
						   Record, Name, Val)
			  end,
			  #pbleaguelist{}, DecodedTuples),
    Record1;
to_record(pbleaguemember, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbleaguemember),
						   Record, Name, Val)
			  end,
			  #pbleaguemember{}, DecodedTuples),
    Record1;
to_record(pbleaguememberlist, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbleaguememberlist),
						   Record, Name, Val)
			  end,
			  #pbleaguememberlist{}, DecodedTuples),
    Record1;
to_record(pbleaguepointchallengeresult,
	  DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbleaguepointchallengeresult),
						   Record, Name, Val)
			  end,
			  #pbleaguepointchallengeresult{}, DecodedTuples),
    Record1;
to_record(pbleaguerankinfo, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbleaguerankinfo),
						   Record, Name, Val)
			  end,
			  #pbleaguerankinfo{}, DecodedTuples),
    Record1;
to_record(pbleagueranklist, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbleagueranklist),
						   Record, Name, Val)
			  end,
			  #pbleagueranklist{}, DecodedTuples),
    Record1;
to_record(pbmasteragreemsg, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbmasteragreemsg),
						   Record, Name, Val)
			  end,
			  #pbmasteragreemsg{}, DecodedTuples),
    Record1;
to_record(pbmastercard, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbmastercard),
						   Record, Name, Val)
			  end,
			  #pbmastercard{}, DecodedTuples),
    Record1;
to_record(pbmasterinfo, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbmasterinfo),
						   Record, Name, Val)
			  end,
			  #pbmasterinfo{}, DecodedTuples),
    Record1;
to_record(pbmembergetlisttype, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbmembergetlisttype),
						   Record, Name, Val)
			  end,
			  #pbmembergetlisttype{}, DecodedTuples),
    Record1;
to_record(pbmembersendlist, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbmembersendlist),
						   Record, Name, Val)
			  end,
			  #pbmembersendlist{}, DecodedTuples),
    Record1;
to_record(pbmembersendmsg, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbmembersendmsg),
						   Record, Name, Val)
			  end,
			  #pbmembersendmsg{}, DecodedTuples),
    Record1;
to_record(pbonekeysendmsg, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbonekeysendmsg),
						   Record, Name, Val)
			  end,
			  #pbonekeysendmsg{}, DecodedTuples),
    Record1;
to_record(pbowncardsinfo, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbowncardsinfo),
						   Record, Name, Val)
			  end,
			  #pbowncardsinfo{}, DecodedTuples),
    Record1;
to_record(pbowngifts, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbowngifts),
						   Record, Name, Val)
			  end,
			  #pbowngifts{}, DecodedTuples),
    Record1;
to_record(pbplayergifts, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbplayergifts),
						   Record, Name, Val)
			  end,
			  #pbplayergifts{}, DecodedTuples),
    Record1;
to_record(pbpointchallengerecord, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbpointchallengerecord),
						   Record, Name, Val)
			  end,
			  #pbpointchallengerecord{}, DecodedTuples),
    Record1;
to_record(pbpointchallengerecordinfo, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbpointchallengerecordinfo),
						   Record, Name, Val)
			  end,
			  #pbpointchallengerecordinfo{}, DecodedTuples),
    Record1;
to_record(pbpointprotectlist, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbpointprotectlist),
						   Record, Name, Val)
			  end,
			  #pbpointprotectlist{}, DecodedTuples),
    Record1;
to_record(pbpointsend, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbpointsend),
						   Record, Name, Val)
			  end,
			  #pbpointsend{}, DecodedTuples),
    Record1;
to_record(pbpointsendmsg, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbpointsendmsg),
						   Record, Name, Val)
			  end,
			  #pbpointsendmsg{}, DecodedTuples),
    Record1;
to_record(pbpointsendmsglist, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbpointsendmsglist),
						   Record, Name, Val)
			  end,
			  #pbpointsendmsglist{}, DecodedTuples),
    Record1;
to_record(pbprotectinfo, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbprotectinfo),
						   Record, Name, Val)
			  end,
			  #pbprotectinfo{}, DecodedTuples),
    Record1;
to_record(pbprotectplayerinfo, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbprotectplayerinfo),
						   Record, Name, Val)
			  end,
			  #pbprotectplayerinfo{}, DecodedTuples),
    Record1;
to_record(pbrequestgiftsmsg, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbrequestgiftsmsg),
						   Record, Name, Val)
			  end,
			  #pbrequestgiftsmsg{}, DecodedTuples),
    Record1;
to_record(pbrequestgiftsmsglist, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbrequestgiftsmsglist),
						   Record, Name, Val)
			  end,
			  #pbrequestgiftsmsglist{}, DecodedTuples),
    Record1;
to_record(pbrequestplayergiftsmsg, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbrequestplayergiftsmsg),
						   Record, Name, Val)
			  end,
			  #pbrequestplayergiftsmsg{}, DecodedTuples),
    Record1;
to_record(pbrequestplayergiftsmsglist, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbrequestplayergiftsmsglist),
						   Record, Name, Val)
			  end,
			  #pbrequestplayergiftsmsglist{}, DecodedTuples),
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
to_record(pbsendgiftsmsg, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields,
							       pbsendgiftsmsg),
						   Record, Name, Val)
			  end,
			  #pbsendgiftsmsg{}, DecodedTuples),
    Record1;
to_record(pbskill, DecodedTuples) ->
    Record1 = lists:foldr(fun ({_FNum, Name, Val},
			       Record) ->
				  set_record_field(record_info(fields, pbskill),
						   Record, Name, Val)
			  end,
			  #pbskill{}, DecodedTuples),
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

