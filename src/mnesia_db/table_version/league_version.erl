-module(league_version).
-behaviour(db_version).
-export([current_version/0, version/1]).
current_version() ->
    8.

version(1) ->
    [{id,undefined},{version,1},{name,[]},{cur_num,0},{max_num,0},{lv,0},{ability_sum,0},{join_ability,0},{declaration,[]},{president,[]}];
version(2) ->
    [{id,undefined},{version,2},{name,[]},{cur_num,0},{max_num,0},{lv,0},{ability_sum,0},{join_ability,0},{declaration,[]},{president,[]},{rank,0}];

version(3) ->
[{id,undefined},{version,3},{name,[]},{cur_num,0},{max_num,0},{lv,0},{ability_sum,0},{join_ability,0},{declaration,[]},{president,[]},{rank,0},{bind_gold,0}];

version(4) ->
    [{id,undefined},{version,4},{name,[]},{cur_num,0},{max_num,0},{lv,0},{ability_sum,0},{join_ability,0},{declaration,[]},{president,[]},{rank,0},{bind_gold,0},{league_gifts_num,0}];

version(5) ->
    [{id,undefined},{version,5},{name,[]},{cur_num,0},{max_num,0},{lv,0},{ability_sum,0},{join_ability,0},{declaration,[]},{president,[]},{rank,0},{bind_gold,0},{league_gifts_num,0},{apply_league_fight,0}];

version(6) ->
    [{id,undefined},{version,6},{name,[]},{cur_num,0},{max_num,0},{lv,0},{ability_sum,0},{join_ability,0},{declaration,[]},{president,[]},{rank,0},{bind_gold,0},{league_gifts_num,0},{apply_league_fight,0},{league_group,0}];

version(7) ->
    [{id,undefined},{version,7},{name,[]},{cur_num,0},{max_num,0},{lv,1},{ability_sum,0},{join_ability,0},{declaration,[]},{president,[]},{rank,0},{bind_gold,0},{league_gifts_num,0},{apply_league_fight,0},{league_group,0},{league_exp,0}];

version(8) ->
    [{id,undefined},{version,8},{name,[]},{cur_num,0},{max_num,0},{lv,1},{ability_sum,0},{join_ability,0},{declaration,[]},{president,[]},{rank,0},{bind_gold,0},{league_gifts_num,0},{apply_league_fight,0},{league_group,0},{league_exp,0},{g17_guild_id,0},{g17_guild_name,[]}];

version(Version) ->
    throw({version_error, Version}).
