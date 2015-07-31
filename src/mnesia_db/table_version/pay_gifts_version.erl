-module(pay_gifts_version).
-behaviour(db_version).
-export([current_version/0, version/1]).
current_version() ->
    6.

version(1) ->
    [{id,0},{version,1},{player_id,0},{sum,0},{per_gold,0},{last_send,0},{over_time,0},{dirty,0}];

version(2) ->
    [{id,0},{version,2},{player_id,0},{sum,0},{per_gold,0},{max_num,0},{recharge_gold_num,0},{last_send,0},{over_time,0},{dirty,0}];

version(3) ->
    [{id,0},{version,3},{player_id,0},{sum,0},{per_gold,0},{day_num,0},{recharge_gold_num,0},{rest_num,0},{all_num,0},{last_send,0},{over_time,0},{dirty,0}];

version(4) ->
    [{id,0},{version,4},{player_id,0},{sum,0},{per_gold,0},{day_num,0},{recharge_gold_num,0},{rest_num,0},{all_num,0},{last_send,0},{over_time,0},{dirty,0},{recv_list,[]}];
version(5) ->
    [{id,0},{version,5},{player_id,0},{sum,0},{per_gold,0},{day_num,0},{recharge_gold_num,0},{rest_num,0},{all_num,0},{last_send,0},{over_time,0},{dirty,0},{recv_list,[]},{is_league,0}];

version(6) ->
    [{id,0},{version,6},{player_id,0},{sum,0},{per_gold,0},{day_num,0},{recharge_gold_num,0},{rest_num,0},{all_num,0},{last_send,0},{over_time,0},{dirty,0},{recv_list,[]},{is_league,0},{all_days_value_list,[]},{one_days_value_list,[]}];

version(Version) ->
    throw({version_error, Version}).
