-module(sterious_shop_version).
-behaviour(db_version).
-export([current_version/0, version/1]).
current_version() ->
    4.

version(1) ->
    [{player_id,0},{version,1},{shop_list,[]},{shop_last_refresh_time,0},{shop_refresh_num,0}];

version(2) ->
[{player_id,0},{version,2},{shop_list,[]},{shop_last_refresh_time,0},{shop_refresh_num,0},{is_dirty,0}];

version(3) ->
[{player_id,0},{version,3},{shop_list,[]},{shop_last_refresh_time,0},{shop_refresh_num,0},{is_dirty,0},{shop_idex,[0,0,0,0,0,0,0,0]}];

version(4) ->
[{player_id,0},{version,4},{shop_list,[]},{shop_last_refresh_time,0},{shop_refresh_num,0},{is_dirty,0}];

version(Version) ->
    throw({version_error, Version}).
