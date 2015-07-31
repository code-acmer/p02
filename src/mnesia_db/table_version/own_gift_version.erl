-module(own_gift_version).
-behaviour(db_version).
-export([current_version/0, version/1]).
current_version() ->
    2.

version(2) ->
    [{id,0},{version,2},{player_id,0},{goods_id,0},{value,[]},{timestamp,0},{lv,0},{is_bind,0}];

version(Version) ->
    throw({version_error, Version}).
