-module(chat_private_version).
-behaviour(db_version).
-export([current_version/0, version/1]).
current_version() ->
    2.

version(1) ->
    [{id,undefined},{version,1},{msg_ids,[]},{recv_id,0}];
version(2) ->
    [{id,undefined},{version,2},{msg_ids,[]},{new_msg,0},{recv_id,0}];
version(Version) ->
    throw({version_error, Version}).
