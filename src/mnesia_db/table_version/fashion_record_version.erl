-module(fashion_record_version).
-behaviour(db_version).
-export([current_version/0, version/1]).
current_version() ->
    1.

version(1) ->
    [{id,0},{version,1},{fashion_base_ids,[]},{wear_history,[]},{take_off_history,[]}];

version(Version) ->
    throw({version_error, Version}).
