-module(main_shop_msg_version).
-behaviour(db_version).
-export([current_version/0, version/1]).
current_version() ->
    1.

version(1) ->
    [{base_id,undefined},{version,1},{buy_num,0},{is_dirty,0}];

version(Version) ->
    throw({version_error, Version}).
