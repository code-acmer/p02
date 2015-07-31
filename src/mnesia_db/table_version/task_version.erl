-module(task_version).
-behaviour(db_version).
-export([current_version/0, version/1]).
current_version() ->
    4.

version(1) ->
    [{id,0},{version,1},{task_id,0},{player_id,0},{type,0},{time,[]},{schedule,[]},{is_dirty,0}];
version(2) ->
    [{id,0},{version,2},{task_id,0},{player_id,0},{type,0},{time,[]},{schedule,0},{state,0},{is_dirty,0}];
version(3) ->
    [{id,0},{version,3},{task_id,0},{player_id,0},{type,0},{schedule,0},{state,0},{last_op,0},{is_dirty,0}];
version(4) ->
    [{id,0},{version,4},{task_id,0},{player_id,0},{type,0},{subtype,0},{schedule,0},{state,0},{last_op,0},{is_dirty,0}];
version(Version) ->
    throw({version_error, Version}).
