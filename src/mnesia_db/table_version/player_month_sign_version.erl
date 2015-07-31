-module(player_month_sign_version).
-behaviour(db_version).
-export([current_version/0, version/1]).
current_version() ->
    2.

version(2) ->
    [{player_id,undefined},{version,2},{timestamp,0},{sign_num,0}];

version(Version) ->
    throw({version_error, Version}).
