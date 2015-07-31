-module(cross_pvp_island_version).
-behaviour(db_version).
-export([current_version/0, version/1]).
current_version() ->
    2.

version(1) ->
    [{id,0},{version,1},{occupy_id,0},{occupy_name,[]},{occupy_career,1},{occupy_lv,0},{occupy_sn,1},{occupy_ability,0},{occupy_robot,0},{occupy_time,0},{calc_timestamp,0}];
version(2) ->
    [{id,0},{version,2},{occupy_id,0},{occupy_name,[]},{occupy_career,1},{occupy_lv,0},{occupy_sn,1},{occupy_ability,0},{occupy_robot,0},{occupy_time,0},{calc_timestamp,0},{is_enemy,0}];
version(Version) ->
    throw({version_error, Version}).
