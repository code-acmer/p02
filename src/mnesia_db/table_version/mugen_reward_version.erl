-module(mugen_reward_version).
-behaviour(db_version).
-export([current_version/0, version/1]).
current_version() ->
    1.

version(1) ->
    [{id,undefined},{version,1},{player_id,0},{level,0},{reward1,0},{reward2,0},{reward3,0},{reward4,0},{dirty,0}];
version(Version) ->
    throw({version_error, Version}).
