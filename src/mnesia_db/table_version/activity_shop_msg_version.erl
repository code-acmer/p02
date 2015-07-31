-module(activity_shop_msg_version).
-behaviour(db_version).
-export([current_version/0, version/1]).
current_version() ->
    4.

version(1) ->
    [{base_id,undefined},{version,1},{buy_num,0},{is_dirty,0}];
version(2) ->
    [{base_id,undefined},{version,2},{goods_id,undefined},{buy_num,0},{is_dirty,0}];
version(3) ->
    [{base_id,undefined},{version,3},{goods_id,undefined},{buy_num,0},{num_limit,0},{is_dirty,0}];
version(4) ->
    [{base_id,undefined},{version,4},{goods_id,undefined},{buy_num,0},{num_limit,0},{is_dirty,0},{activity_id,undefined}];
version(Version) ->
    throw({version_error, Version}).
