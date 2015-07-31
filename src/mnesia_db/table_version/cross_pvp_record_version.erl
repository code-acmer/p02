-module(cross_pvp_record_version).
-behaviour(db_version).
-export([current_version/0, version/1]).
current_version() ->
    1.

version(1) ->
    [{id,0},{version,1},{timestamp,0},{atk_id,0},{atk_name,0},{def_id,0},{def_name,0},{result,0},{score,0}];
version(Version) ->
    throw({version_error, Version}).
