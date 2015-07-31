-module(relationship_version).
-behaviour(db_version).
-export([current_version/0, version/1]).
current_version() ->
    1.

version(1) ->
    [{id,0},{version,1},{sid,0},{tid,0},{as_cd,0},{fp_cd,0},{sp,0},{rela,0},{time_form,0},{dirty,0}];
version(Version) ->
    throw({version_error, Version}).