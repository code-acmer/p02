-module(g17_guild_apply_version).
-behaviour(db_version).
-export([current_version/0, version/1]).
current_version() ->
    1.

version(1) ->
    [{key,undefined},{version,1},{guild_id,0},{user_id,[]},{apply_guild_id,0},{status,0},{delete_time,0}];
version(Version) ->
    throw({version_error, Version}).
