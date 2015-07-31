-module(cross_pvp_sign_version).
-behaviour(db_version).
-export([current_version/0, version/1]).
current_version() ->
    1.

version(1) ->
    [{player_id,0},{version,1},{name,[]},{group,0},{career,1},{lv,0},{sn,1},{ability,0}];
version(Version) ->
    throw({version_error, Version}).
