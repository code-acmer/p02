-module(general_store_version).
-behaviour(db_version).
-export([current_version/0, version/1]).
current_version() ->
    1.

version(1) ->
    [{id,0},{version,1},{player_id,0},{store_type,0},{shop_list,[]},{last_refresh_time,0},{refresh_num,0},{is_dirty,0}];

version(Version) ->
    throw({version_error, Version}).
