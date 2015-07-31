-module(player_dungeon_match_version).
-behaviour(db_version).
-export([current_version/0, version/1]).
current_version() ->
    1.

version(1) ->
    [{player_id,0},{version,1},{lv_range,[0,0]},{win_times,0},{fail_times,0},{dirty,0}];
version(Version) ->
    throw({version_error, Version}).
