-module(super_battle_version).
-behaviour(db_version).
-export([current_version/0, version/1]).
current_version() ->
    5.

version(1) ->
    [{player_id,0},{version,1},{score,0},{rest,0},{dirty,0}];
version(2) ->
    [{player_id,0},{version,2},{last_dungeon,0},{next_dungeon,0},{score,0},{pass_time,0},{rest,0},{state,1},{have_pass_times,0},{dirty,0}];
version(3) ->
    [{player_id,0},{version,3},{last_dungeon,0},{next_dungeon,0},{score,0},{pass_time,0},{rest,0},{state,1},{have_pass_times,0},{cur_hp,100},{dirty,0}];
version(4) ->
    [{player_id,0},{version,4},{last_dungeon,0},{next_dungeon,0},{score,0},{pass_time,0},{rest,0},{state,1},{have_pass_times,0},{cur_hp,100},{buy_times,0},{dirty,0}];
version(5) ->
    [{player_id,0},{version,5},{last_dungeon,0},{next_dungeon,0},{score,0},{pass_time,0},{rest,0},{state,1},{have_pass_times,0},{cur_hp,100},{buy_times,0},{dirty,0},{ability,0}];
version(Version) ->
    throw({version_error, Version}).
