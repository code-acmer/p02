-module(pay_info_version).
-behaviour(db_version).
-export([current_version/0, version/1]).
current_version() ->
    1.

version(1) ->
    [{order_id,[]},{version,1},{order_type,0},{platform,[103,49,55]},{accid,[]},{server_id,1},{coin,0},{extra,0},{money,0.0},{time,0},{player_id,0},{status,0},{lv,0},{handle_time,0},{handle_desc,[]}];
version(Version) ->
    throw({version_error, Version}).
