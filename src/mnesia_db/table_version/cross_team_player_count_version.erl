-module(cross_team_player_count_version).
-behaviour(db_version).
-export([current_version/0, version/1]).
current_version() ->
    1.

version(1) ->
    [{team_id,0},{version,1},{num,0},{team_type,1},{avg_ability,0}];
version(Version) ->
    throw({version_error, Version}).
