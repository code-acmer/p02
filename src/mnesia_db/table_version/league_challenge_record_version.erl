-module(league_challenge_record_version).
-behaviour(db_version).
-export([current_version/0, version/1]).
current_version() ->
    1.

version(1) ->
    [{player_id,0},{version,1},{league_id,0},{record_list,[]},{player_name,[]}];

version(Version) ->
    throw({version_error, Version}).
