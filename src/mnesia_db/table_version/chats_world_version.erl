-module(chats_world_version).
-behaviour(db_version).
-export([current_version/0, version/1]).
current_version() ->
    2.

version(1) ->
    [{id,0},{version,1},{player_id,0},{nickname,[]},{lv,0},{career,0},{msg,[]}];
version(2) ->
    [{id,0},{version,2},{player_id,0},{nickname,[]},{lv,0},{career,0},{msg,[]},{timestamp,0}];
version(Version) ->
    throw({version_error, Version}).
