-module(cross_pvp_fighter_version).
-behaviour(db_version).
-export([current_version/0, version/1]).
current_version() ->
    1.

version(1) ->
    [{player_id,0},{version,1},{player_name,[]},{player_career,0},{player_lv,0},{player_sn,0},{player_ability,0},{group,0},{timestamp,0},{event_timestamp,0},{times,0},{buy_times,0},{islands,[]},{records,[]}];
version(Version) ->
    throw({version_error, Version}).
