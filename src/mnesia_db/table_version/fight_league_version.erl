-module(fight_league_version).
-behaviour(db_version).
-export([current_version/0, version/1]).
current_version() ->
    2.

version(1) ->
    [{league_id,undefined},{version,1},{group,0},{league_name,[]},{sn,0},{score,0},{ability_sum,0},{lv,0},{cur_num,0},{max_num,0},{win_cnt,0},{loss_cnt,0},{rank,0},{things,0},{defend_points,[]},{occupy_points,0},{atk_times,0},{enemy_league_id,0},{enemy_league_name,[]},{enemy_league_sn,0}];

version(2) ->
    [{league_id,undefined},{version,2},{group,1},{league_name,[]},{sn,0},{score,0},{ability_sum,0},{lv,0},{cur_num,0},{max_num,0},{win_cnt,0},{loss_cnt,0},{rank,0},{things,0},{defend_points,[]},{occupy_points,0},{atk_times,0},{enemy_league_id,0},{enemy_league_name,[]},{enemy_league_sn,0},{apply_time,0}];

version(Version) ->
    throw({version_error, Version}).
