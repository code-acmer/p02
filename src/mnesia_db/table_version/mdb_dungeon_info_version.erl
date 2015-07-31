-module(mdb_dungeon_info_version).
-behaviour(db_version).
-export([current_version/0, version/1]).
current_version() ->
    1.

version(1) ->
    [{base_id,0},{version,1},{condition,[]},{dungeon_level,0},{left_times,0},{buy_times,0}];
version(Version) ->
    throw({version_error, Version}).
