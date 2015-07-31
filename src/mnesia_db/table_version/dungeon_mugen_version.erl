-module(dungeon_mugen_version).
-behaviour(db_version).
-export([current_version/0, version/1]).
current_version() ->
    6.

version(1) ->
    [{player_id,undefined},{version,1},{last_dungeon,0},{next_dungeon,0},{score,0},{pass_time,0},{state,0},{rest,0},{have_pass_times,0},{dirty,0}];
version(2) ->
    [{player_id,undefined},{version,2},{last_dungeon,0},{next_dungeon,0},{score,0},{pass_time,0},{state,0},{rest,0},{have_pass_times,0},{max_pass_rec,0},{dirty,0}];
version(3) ->
    [{player_id,undefined},{version,3},{last_dungeon,0},{next_dungeon,0},{score,0},{pass_time,0},{state,1},{rest,0},{have_pass_times,0},{max_pass_rec,0},{challenge_list,[]},{challenge_times,1},{dirty,0}];
version(4) ->
    [{player_id,undefined},{version,4},{last_dungeon,0},{next_dungeon,0},{score,0},{pass_time,0},{state,1},{rest,0},{have_pass_times,0},{max_pass_rec,0},{challenge_list,[]},{challenge_times,1},{send_lucky_coin,0},{use_lucky_coin,0},{dirty,0}];
version(5) ->
    [{player_id,undefined},{version,5},{last_dungeon,0},{next_dungeon,0},{score,0},{pass_time,0},{state,1},{rest,0},{have_pass_times,0},{old_key,undefined},{max_pass_rec,0},{challenge_list,[]},{challenge_times,1},{send_lucky_coin,0},{use_lucky_coin,0},{dirty,0}];
version(6) ->
    [{player_id,undefined},{version,6},{last_dungeon,0},{next_dungeon,0},{score,0},{pass_time,0},{state,1},{rest,0},{have_pass_times,0},{old_key,undefined},{max_pass_rec,0},{challenge_list,[]},{challenge_times,1},{send_lucky_coin,0},{use_lucky_coin,0},{skip_flag,1},{dirty,0}];
version(Version) ->
    throw({version_error, Version}).
