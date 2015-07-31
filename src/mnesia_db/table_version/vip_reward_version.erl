-module(vip_reward_version).
-behaviour(db_version).
-export([current_version/0, version/1]).
current_version() ->
    1.

version(1) ->
    [{player_id,0},{version,1},{recv_list,[]},{dirty,0}];

version(Version) ->
    throw({version_error, Version}).
