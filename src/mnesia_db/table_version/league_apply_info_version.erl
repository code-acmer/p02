-module(league_apply_info_version).
-behaviour(db_version).
-export([current_version/0, version/1]).
current_version() ->
    6.

version(1) ->
    [{league_id,undefined},{version,1},{league_sn,0}];

version(2) ->
    [{league_id,undefined},{version,2},{league_sn,0},{league_name,[]},{ability_sum,0}];

version(3) ->
    [{league_id,undefined},{version,3},{league_sn,0},{league_name,[]},{ability_sum,0},{league_lv,0},{cur_num,0}];

version(4) ->
    [{league_id,undefined},{version,4},{league_sn,0},{league_name,[]},{ability_sum,0},{league_lv,0},{cur_num,0},{max_num,0}];

version(5) ->
    [{league_id,undefined},{version,5},{league_sn,0}];

version(6) ->
    [{league_id,undefined},{version,6},{league_sn,0},{ability_sum,0}];

version(Version) ->
    throw({version_error, Version}).
