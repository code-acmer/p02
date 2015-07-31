-module(league_gifts_record_version).
-behaviour(db_version).
-export([current_version/0, version/1]).
current_version() ->
    3.

version(2) ->
    [{id,undefined},{version,2},{league_id,0},{timestamp,0},{send_name,[]},{recv_name,[]},{type,0},{value,0}];

version(3) ->
[{id,undefined},{version,3},{league_id,0},{timestamp,0},{send_name,[]},{recv_name,[]},{type,0},{value,0},{double,0}];

version(Version) ->
    throw({version_error, Version}).

