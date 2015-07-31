-module(combat_attri_version).
-behaviour(db_version).
-export([current_version/0, version/1]).
current_version() ->
    3.

version(1) ->
    [{player_id,0},{version,1},{sn,0},{career,0},{nickname,[]},{lv,0},{ability,0},{high_ability,0},{league_id,0},{league_name,[]},{league_title,0},{base_attri,0},{final_attri,0},{equips,[]},{stunts,[]}];
version(2) ->
    [{player_id,0},{version,2},{sn,0},{career,0},{nickname,[]},{lv,0},{ability,0},{high_ability,0},{league_id,0},{league_name,[]},{league_title,0},{base_attri,0},{final_attri,0},{equips,[]},{stunts,[]},{fashions,[]}];
version(3) ->
    [{player_id,0},{version,3},{sn,0},{career,0},{nickname,[]},{lv,0},{ability,0},{high_ability,0},{league_id,0},{league_name,[]},{league_title,0},{base_attri,0},{final_attri,0},{equips,[]},{stunts,[]},{fashions,[]},{type,0}];
version(Version) ->
    throw({version_error, Version}).
