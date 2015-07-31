-module(choujiang_info_version).
-behaviour(db_version).
-export([current_version/0, version/1]).
current_version() ->
    3.

version(1) ->
    [{player_id,undefined},{version,1},{coin_timestamp,0},{gold_timestamp,0},{coin_free_num,0}];

version(2) ->
    [{player_id,undefined},{version,2},{coin_timestamp,0},{gold_timestamp,0},{coin_free_num,0},{is_dirty,0}];
version(3) ->
    [{player_id,undefined},{version,3},{coin_timestamp,0},{gold_timestamp,0},{coin_free_num,0},{is_coin_first,0},{is_gold_first,0},{is_dirty,0}];

version(Version) ->
    throw({version_error, Version}).
