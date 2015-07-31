-module(player_camp_version).
-behaviour(db_version).
-export([current_version/0, version/1]).
current_version() ->
    1.

version(1) ->
    [{player_id,0},{version,1},{using_camp,0},{camp_list,[]},{ext1,0},{ext2,0},{ext3,0}];
version(Version) ->
    throw({version_error, Version}).