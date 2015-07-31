-module(server_config_version).
-behaviour(db_version).
-export([current_version/0, version/1]).
current_version() ->
    1.

version(1) ->
    [{k,undefined}, {version,1}, {v,0}];
version(Version) ->
    throw({version_error, Version}).
