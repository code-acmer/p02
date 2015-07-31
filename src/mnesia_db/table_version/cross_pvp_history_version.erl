-module(cross_pvp_history_version).
-behaviour(db_version).
-export([current_version/0, version/1]).
current_version() ->
    1.

version(1) ->
    [{id,0},{version,1},{player_id,0},{rank,0},{round,0},{timestamp,0}];
version(Version) ->
    throw({version_error, Version}).
