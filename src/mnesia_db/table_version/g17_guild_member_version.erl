-module(g17_guild_member_version).
-behaviour(db_version).
-export([current_version/0, version/1]).
current_version() ->
    1.

version(1) ->
    [{user_id,[]},{version,1},{guild_id,0},{title_id,0},{number_id,0},{live_ness,0}];
version(Version) ->
    throw({version_error, Version}).
