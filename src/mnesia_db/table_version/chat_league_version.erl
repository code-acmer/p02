-module(chat_league_version).
-behaviour(db_version).
-export([current_version/0, version/1]).
current_version() ->
    1.

version(1) ->
    [{league_id,0},{version,1},{size,0},{msg_ids,[]}];
version(Version) ->
    throw({version_error, Version}).
