-module(league_gifts_version).
-behaviour(db_version).
-export([current_version/0, version/1]).
current_version() ->
    3.

version(1) ->
    [{id,0},{version,1},{league_id,0},{player_id,0},{player_name,[]},{rest_num,0},{sum,0},{per_gold,0},{gold_type,0},{over_time,0},{recv_list,[]}];

version(2) ->
    [{id,0},{version,2},{league_id,0},{player_id,0},{player_name,[]},{rest_num,0},{sum,0},{per_gold,0},{gold_type,0},{over_time,0},{recv_list,[]},{is_league,0}];

version(3) ->
    [{id,0},{version,3},{league_id,0},{player_id,0},{player_name,[]},{rest_num,0},{sum,0},{per_gold,0},{gold_type,0},{over_time,0},{recv_list,[]},{is_league,0},{one_days_value_list,[]}];

version(Version) ->
    throw({version_error, Version}).
