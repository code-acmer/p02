-module(league_recharge_gold_record_version).
-behaviour(db_version).
-export([current_version/0, version/1]).
current_version() ->
    2.

version(2) ->
    [{id,undefined},{version,2},{league_id,0},{timestamp,0},{recharge_name,[]},{value,0}];

version(Version) ->
    throw({version_error, Version}).
