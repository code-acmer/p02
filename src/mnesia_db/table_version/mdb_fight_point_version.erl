-module(mdb_fight_point_version).
-behaviour(db_version).
-export([current_version/0, version/1]).
current_version() ->
    1.

version(1) ->
    [{id,0},{version,1},{status,0},{pos,0},{protect_info,[]}];

version(Version) ->
    throw({version_error, Version}).
