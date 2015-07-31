-module(league_relation_version).

-behaviour(db_version).
-export([current_version/0, version/1]).
current_version() ->
    11.

version(1) -> 
    [{league_id,undefined},{version,1},{league_sn,0},{enemy_league_id,0},{enemy_league_sn,0}];

version(2) -> 
    [{league_id,undefined},{version,2},{league_sn,0},{league_integral,0},{fight_record,[]},{enemy_league_id,0},{enemy_league_sn,0}];

version(3) ->
    [{league_id,undefined},{version,3},{league_sn,0},{league_integral,0},{fight_record,[]},{league_thing,0},{league_point,0},{enemy_league_id,0},{enemy_league_sn,0}];

version(4) ->
    [{league_id,undefined},{version,4},{league_sn,0},{league_integral,0},{fight_record,[]},{league_thing,0},{league_point,0},{not_enemy,false},{enemy_league_id,0},{enemy_league_sn,0}];

version(5) ->
    [{league_id,undefined},{version,5},{league_group,0},{league_sn,0},{league_score,0},{fight_record,[]},{league_rank,0},{league_thing,0},{league_point,0},{not_enemy,false},{enemy_league_id,0},{enemy_league_sn,0}];

version(6) ->
    [{league_id,undefined},{version,6},{league_group,0},{league_sn,0},{league_score,0},{league_name,[]},{ability_sum,0},{fight_record,[]},{league_rank,0},{league_thing,0},{league_point,0},{not_enemy,false},{enemy_league_id,0},{enemy_league_sn,0}];

version(7) ->
    [{league_id,undefined},{version,7},{league_group,0},{league_sn,0},{league_score,0},{league_name,[]},{ability_sum,0},{league_lv,0},{cur_num,0},{fight_record,[]},{league_rank,0},{league_thing,0},{league_point,0},{not_enemy,false},{enemy_league_id,0},{enemy_league_sn,0}];

version(8) -> 
    [{league_id,undefined},{version,8},{league_group,0},{league_sn,0},{league_score,0},{league_name,[]},{ability_sum,0},{league_lv,0},{cur_num,0},{max_nun,0},{fight_record,[]},{league_rank,0},{league_thing,0},{league_point,0},{not_enemy,false},{enemy_league_id,0},{enemy_league_sn,0}];

version(9) ->
    [{league_id,undefined},{version,9},{league_group,0},{league_sn,0},{league_score,0},{league_name,[]},{ability_sum,0},{league_lv,0},{cur_num,0},{max_num,0},{fight_record,[]},{league_rank,0},{league_thing,0},{league_point,0},{not_enemy,false},{enemy_league_id,0},{enemy_league_sn,0}];

version(10) ->
    [{league_id,undefined},{version,10},{league_group,0},{league_sn,0},{league_score,0},{league_name,[]},{ability_sum,0},{league_lv,0},{cur_num,0},{max_num,0},{fight_record,[]},{league_rank,0},{league_thing,0},{league_point,0},{fight_point_list,[]},{not_enemy,false},{enemy_league_id,0},{enemy_league_sn,0}];

version(11) ->
    [{league_id,undefined},{version,11},{league_group,0},{league_sn,0},{league_score,0},{league_name,[]},{ability_sum,0},{league_lv,0},{cur_num,0},{max_num,0},{fight_record,[]},{league_rank,0},{league_thing,0},{league_point,0},{not_enemy,false},{enemy_league_id,0},{enemy_league_sn,0}];

version(Version) ->
    throw({version_error, Version}).
