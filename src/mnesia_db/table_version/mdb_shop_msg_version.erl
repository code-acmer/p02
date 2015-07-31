-module(mdb_shop_msg_version).
-behaviour(db_version).
-export([current_version/0, version/1]).
current_version() ->
    3.

version(1)->
[{base_id,undefined},{version,1},{is_buy,0},{pos,0}];

version(2)->
[{base_id,undefined},{version,2},{is_buy,0},{pos,0},{buy_num,0}];

version(3)->
[{base_id,undefined},{version,2},{is_buy,0},{pos,0}];

version(Version) ->
    throw({version_error, Version}).
