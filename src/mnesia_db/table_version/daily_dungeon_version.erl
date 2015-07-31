-module(daily_dungeon_version).
-behaviour(db_version).
-export([current_version/0, version/1]).
current_version() ->
    1.

version(1) ->
    [{player_id,0},{version,1},{dungeon_id,0},{time,0},{damage,0},{hurt,0},{combo,0},{aircombo,0},{skillcancel,0},{crit,0},{left_times,0},{dirty,0}];
version(Version) ->
    throw({version_error, Version}).
