-module(league_fight_point_version).
-behaviour(db_version).
-export([current_version/0, version/1]).
current_version() ->
    4.

version(1) ->
    [{id,0},{version,1},{league_id,0},{status,0},{pos,0},{protect_info,[]}];

version(2) ->
    [{id,0},{version,2},{league_id,0},{status,0},{pos,0},{protect_info,[]},{occurpy_info,[]}];

version(3) ->
    [{id,0},{version,3},{league_id,0},{status,0},{pos,0},{protect_info,[]},{occurpy_info,[]},{record_list,[]}];

version(4) ->
    [{id,0},{version,4},{league_id,0},{status,0},{pos,0},{protect_info,[]},{occurpy_info,[]},{record_list,[]},{attack_info,[]}];

version(Version) ->
    throw({version_error, Version}).
