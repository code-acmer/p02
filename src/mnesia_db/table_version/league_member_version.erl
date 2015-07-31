-module(league_member_version).
-behaviour(db_version).
-export([current_version/0, version/1]).
current_version() ->
    5.

version(1) ->
    [{player_id,undefined},{version,1},{league_id,0},{title,3},{contribute,0}];
version(2) ->
    [{player_id,undefined},{version,2},{league_id,0},{title,3},{contribute,0},{send_gold,0},{recv_gold,0}];
version(3) ->
    [{player_id,undefined},{version,3},{league_id,0},{title,3},{contribute,0},{send_gold,0},{recv_gold,0},{player_name,[]}];
version(4) ->
    [{player_id,undefined},{version,4},{league_id,0},{title,3},{contribute,0},{contribute_lv,0},{send_gold,0},{recv_gold,0},{player_name,[]}];
version(5) ->
    [{player_id,undefined},{version,5},{league_id,0},{title,3},{contribute,0},{contribute_lv,0},{send_gold,0},{recv_gold,0},{player_name,[]},{g17_join_timestamp,0}];
version(Version) ->
    throw({version_error, Version}).
