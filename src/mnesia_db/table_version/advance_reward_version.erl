-module(advance_reward_version).
-behaviour(db_version).
-export([current_version/0, version/1]).
current_version() ->
    1.

version(1) ->
    [{player_id,0},{version,1},{target_id,0},{finish,0},{dirty,0}];
version(Version) ->
    throw({version_error, Version}).
