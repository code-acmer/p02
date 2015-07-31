-module(cross_pvp_enemy_version).
-behaviour(db_version).
-export([current_version/0, version/1]).
current_version() ->
    1.

version(1) ->
    [{key, 0},{version,1},{atk_id,0},{def_id, 0},{atk_wins, 0}, {def_wins, 0}, {status, 0}];
version(Version) ->
    throw({version_error, Version}).
