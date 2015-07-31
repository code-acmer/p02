-module(g17_guild_version).
-behaviour(db_version).
-export([current_version/0, version/1]).
current_version() ->
    2.

version(1) ->
    [{guild_id,0},{version,1},{guild_name,[]},{guild_logo,[]},{owner_user_id,[]}];
version(2) ->
    [{guild_id,0},{version,2},{guild_name,[]},{guild_logo,[]},{owner_user_id,[]},{status,0}];
version(Version) ->
    throw({version_error, Version}).
