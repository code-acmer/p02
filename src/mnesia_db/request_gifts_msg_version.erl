-module(request_gifts_msg_version).
-behaviour(db_version).
-export([current_version/0, version/1]).
current_version() ->
    5.

version(2) ->
    [{id,0},{version,2},{player_id,0},{request_player_id,0}];

version(3) ->
    [{id,0},{version,3},{player_id,0},{request_player_id,0},{request_num,0}];

version(4) ->
    [{id,0},{version,4},{player_id,0},{request_player_id,0},{request_num,0},{request_name,[]}];

version(5) ->
    [{id,0},{version,5},{player_id,0},{request_player_id,0},{request_num,0},{request_name,[]},{is_read,0}];

version(Version) ->
    throw({version_error, Version}).
