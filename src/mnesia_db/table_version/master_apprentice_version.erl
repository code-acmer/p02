-module(master_apprentice_version).
-behaviour(db_version).
-export([current_version/0, version/1]).
current_version() ->
    9.

version(1) ->
    [{id,0},{version,1},{master_player_id,0},{master_player_name,[]},{master_login_time,0},{master_teach_num,0},{apprentice_player_id,0},{apprentice_player_name,[]},{apprentice_login_time,0},{apprentice_learn_num,0},{skill_card_base_id,0},{skill_card_status,0}];

version(2) ->
    [{id,0},{version,2},{master_player_id,0},{master_player_name,[]},{master_login_time,0},{apprentice_player_id,0},{apprentice_player_name,[]},{apprentice_login_time,0},{skill_card_base_id,0},{skill_card_status,0}];

version(3) ->
    [{id,0},{version,3},{master_player_id,0},{master_player_name,[]},{master_login_time,0},{master_lv,0},{master_ability,0},{master_contribute,0},{master_contribute_lv,0},{master_title,0},{apprentice_player_id,0},{apprentice_player_name,[]},{apprentice_login_time,0},{skill_card_base_id,0},{skill_card_status,0}];

version(4) ->
    [{id,0},{version,4},{master_player_id,0},{master_player_name,[]},{master_login_time,0},{master_lv,0},{master_ability,0},{master_contribute,0},{master_contribute_lv,0},{master_title,0},{apprentice_player_id,0},{apprentice_player_name,[]},{apprentice_login_time,0},{skill_card_base_id,0},{skill_card_status,0},{skill_card_work_day,30}];

version(5) ->
    [{id,0},{version,5},{master_player_id,0},{master_accid,[]},{master_player_name,[]},{master_login_time,0},{master_lv,0},{master_ability,0},{master_contribute,0},{master_contribute_lv,0},{master_title,0},{apprentice_player_id,0},{apprentice_player_name,[]},{apprentice_login_time,0},{skill_card_base_id,0},{skill_card_status,0},{skill_card_work_day,30}];

version(6) ->
    [{id,0},{version,6},{master_player_id,0},{master_accid,[]},{master_player_name,[]},{master_login_time,0},{master_lv,0},{master_ability,0},{master_contribute,0},{master_contribute_lv,0},{master_title,0},{master_goods_id,0},{apprentice_player_id,0},{apprentice_player_name,[]},{apprentice_login_time,0},{apprentice_goods_id,0},{skill_card_base_id,0},{skill_card_status,0},{skill_card_work_day,30}];

version(7) ->
    [{id,0},{version,7},{master_player_id,0},{master_accid,[]},{master_player_name,[]},{master_login_time,0},{master_lv,0},{master_ability,0},{master_contribute,0},{master_contribute_lv,0},{master_title,0},{master_goods_id,0},{master_skill_base_id,0},{apprentice_player_id,0},{apprentice_player_name,[]},{apprentice_login_time,0},{apprentice_goods_id,0},{apprentice_skill_base_id,0},{skill_card_status,0},{skill_card_work_day,30}];

version(8) ->
    [{id,0},{version,8},{master_player_id,0},{master_accid,[]},{master_player_name,[]},{master_login_time,0},{master_lv,0},{master_ability,0},{master_contribute,0},{master_contribute_lv,0},{master_title,0},{master_goods_id,0},{master_skill_base_id,0},{master_vip,0},{apprentice_player_id,0},{apprentice_player_name,[]},{apprentice_login_time,0},{apprentice_goods_id,0},{apprentice_skill_base_id,0},{skill_card_status,0},{skill_card_work_day,0}];

version(9) -> 
    [{id,0},{version,9},{master_player_id,0},{master_accid,[]},{master_player_name,[]},{master_login_time,0},{master_lv,0},{master_ability,0},{master_contribute,0},{master_contribute_lv,0},{master_title,0},{master_goods_id,0},{master_skill_base_id,0},{master_vip,0},{apprentice_player_id,0},{apprentice_player_name,[]},{apprentice_login_time,0},{apprentice_goods_id,0},{apprentice_skill_base_id,0},{skill_card_status,0},{skill_card_work_day,0},{request_card_msg,[]}];

version(Version) ->
    throw({version_error, Version}).
