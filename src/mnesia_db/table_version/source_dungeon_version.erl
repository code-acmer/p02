-module(source_dungeon_version).
-behaviour(db_version).
-export([current_version/0, version/1]).
current_version() ->
    1.

version(1) ->
    [{player_id,0},{version,1},{info,[]},{dirty,0}];
version(Version) ->
    throw({version_error, Version}).
