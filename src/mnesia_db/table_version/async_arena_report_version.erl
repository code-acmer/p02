-module(async_arena_report_version).
-behaviour(db_version).
-export([current_version/0, version/1]).
current_version() ->
    2.

version(1) ->
    [{id,0},{version,1},{attack_id,undefined},{nickname,undefined},{deffender_id,undefined},{deffender_name,undefined},{result,undefined},{rank_change_type,undefined},{attack_rank,undefined},{defender_rank,undefined}];
version(2) ->
    [{id,0},{version,2},{attack_id,undefined},{nickname,undefined},{deffender_id,undefined},{deffender_name,undefined},{result,undefined},{rank_change_type,undefined},{attack_rank,undefined},{defender_rank,undefined},{timestamp,0}];
version(Version) ->
    throw({version_error, Version}).
