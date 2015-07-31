-module(fight_member_version).
-behaviour(db_version).
-export([current_version/0, version/1]).
current_version() ->
    1.

version(1) ->
    [{player_id,0},{version,1},{player_name,0},{player_lv,0},{player_career,0},{player_title,0},{contribute,0},{contribute_lv,0},{league_id,0},{league_name,[]},{ability,0},{fight_times,4},{atk_point_times,0},{things,0},{def_records,[]},{atk_records,[]}];

version(Version) ->
    throw({version_error, Version}).
