-module(league_member_challenge_version).
-behaviour(db_version).
-export([current_version/0, version/1]).
current_version() ->
    3.

version(1) ->
    [{player_id,0},{version,1},{league_id,0},{enemy_challenge_list,[]}];

version(2) ->
    [{player_id,0},{version,2},{league_id,0},{enemy_challenge_list,[]},{already_challenge_num,0},{attack_info,[]}];

version(3) ->
    [{player_id,0},{version,3},{league_id,0},{grap_thing,0},{grap_num,0},{use_challenge_num,0},{attack_info,[]}];

version(Version) ->
    throw({version_error, Version}).
