-module(async_arena_rank_version).
-behaviour(db_version).
-export([current_version/0, version/1]).
current_version() ->
    5.

version(1) ->
    [{rank,undefined},{version,1},{player_id,0},{nickname,undefined},{lv,0},{battle_ability,0},{career,undefined},{win,0},{lose,0},{is_robot,1},{state,0}];
version(2) ->
    [{rank,undefined},{version,2},{player_id,0},{nickname,undefined},{lv,0},{battle_ability,0},{career,undefined},{win,0},{lose,0},{challenge_times,0},{rest_challenge_times,0},{is_robot,1},{state,0}];
version(3) ->
    [{rank,undefined},{version,3},{player_id,0},{nickname,undefined},{lv,0},{battle_ability,0},{career,undefined},{win,0},{lose,0},{challenge_times,0},{rest_challenge_times,0},{is_robot,1},{state,0}];
version(4) ->
    [{rank,undefined},{version,4},{player_id,0},{nickname,undefined},{lv,0},{battle_ability,0},{career,undefined},{win,0},{lose,0},{challenge_times,0},{rest_challenge_times,0},{is_robot,1},{robot_id,0},{state,0}];
version(5) ->
    [{rank,undefined},{version,5},{player_id,0},{nickname,undefined},{lv,0},{battle_ability,0},{career,undefined},{win,0},{lose,0},{challenge_times,0},{rest_challenge_times,0},{buy_times,0},{is_robot,1},{robot_id,0},{state,0}];
version(Version) ->
    throw({version_error, Version}).
