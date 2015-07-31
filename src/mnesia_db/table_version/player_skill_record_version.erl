-module(player_skill_record_version).
-behaviour(db_version).
-export([current_version/0, version/1]).
current_version() ->
    2.

version(2) ->
    [{player_id,0},{version,2},{skill_record_list,[]},{dirty,0}];

version(Version) ->
    throw({version_error, Version}).
