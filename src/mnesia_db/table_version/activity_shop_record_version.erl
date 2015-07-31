-module(activity_shop_record_version).
-behaviour(db_version).
-export([current_version/0, version/1]).
current_version() ->
    2.
version(1) ->
[{activity_id,undefined},{version,1},{shop_list,[]},{is_dirty,0}];

version(2) ->
[{player_id,undefined},{version,2},{activity_id,undefined},{shop_list,[]},{is_dirty,0}];

version(Version) ->
    throw({version_error, Version}).
