-module(lucky_coin_version).
-behaviour(db_version).
-export([current_version/0, version/1]).
current_version() ->
    1.

version(1) ->
    [{key,undefined},{version,1},{send,undefined},{recv,undefined},{state,undefined}];
version(Version) ->
    throw({version_error, Version}).
