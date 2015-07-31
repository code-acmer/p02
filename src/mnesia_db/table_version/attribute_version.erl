-module(attribute_version).
-behaviour(db_version).
-export([current_version/0, version/1]).
current_version() ->
    2.

version(1) ->
    [{hp_lim,0},{version,1},{hp_cur,0},{mana_lim,0},{mana_cur,0},{hp_rec,0},{mana_rec,0},{attack,0},{def,0},{hit,0},{dodge,0},{crit,0},{anti_crit,0},{stiff,0},{anti_stiff,0},{attack_speed,0},{move_speed,0},{attack_effect,0},{def_effect,0}];
version(2) ->
    [{hp_lim,0},{version,2},{hp_cur,0},{mana_lim,0},{mana_cur,0},{hp_rec,0},{mana_rec,0},{attack,0},{def,0},{hit,0},{dodge,0},{crit,0},{anti_crit,0},{stiff,0},{anti_stiff,0},{attack_speed,0},{move_speed,0},{attack_effect,0},{def_effect,0},{hp_lim_percent,0},{attack_percent,0},{def_percent,0},{hit_percent,0},{dodge_percent,0},{crit_percent,0},{anti_crit_percent,0}];

version(Version) ->
    throw({version_error, Version}).
