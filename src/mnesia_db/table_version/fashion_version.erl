-module(fashion_version).
-behaviour(db_version).
-export([current_version/0, version/1]).
current_version() ->
    1.

version(1) ->
    [{id,0},{version,1},{player_id,0},{fashion_id,0},{container,0},{property,0},{nid,0},{name,<<>>},{fashion_desc,<<>>},{price,0}];
version(Version) ->
    throw({version_error, Version}).