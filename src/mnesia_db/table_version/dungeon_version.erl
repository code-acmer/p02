-module(dungeon_version).
-behaviour(db_version).
-export([current_version/0, version/1]).
current_version() ->
    5.

version(1) ->
    [{id,0},{version,1},{base_id,0},{player_id,0},{best_score,0},{best_pass,0},{done,0},{dirty,0}];
version(2) ->
    [{id,0},{version,2},{base_id,0},{player_id,0},{best_score,0},{best_pass,0},{done,0},{boss_win_times,0},{boss_fail_times,0},{dirty,0}];
version(3) ->
    [{id,0},{version,3},{base_id,0},{player_id,0},{best_score,0},{best_pass,0},{done,0},{boss_win_times,0},{boss_fail_times,0},{best_grade,0},{dirty,0}];
version(4) ->
    [{id,0},{version,4},{base_id,0},{player_id,0},{best_score,0},{best_pass,0},{done,0},{boss_win_times,0},{boss_fail_times,0},{best_grade,0},{dungeon_level,0},{left_times,0},{buy_times,0},{target_list,[]},{dirty,0}];
version(5) ->
    [{id,0},{version,5},{base_id,0},{player_id,0},{best_score,0},{best_pass,0},{done,0},{boss_win_times,0},{boss_fail_times,0},{best_grade,0},{dungeon_level,0},{left_times,0},{buy_times,0},{target_list,[]},{dirty,0},{boss_reward_flag,0}];
version(Version) ->
    throw({version_error, Version}).
