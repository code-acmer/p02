-module(private_msg_version).
-behaviour(db_version).
-export([current_version/0, version/1]).
current_version() ->
    1.

version(1) ->
    [{id,0},{version,1},{msg,[]},{timestamp,0}];
version(Version) ->
    throw({version_error, Version}).
