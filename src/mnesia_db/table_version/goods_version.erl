-module(goods_version).
-behaviour(db_version).
-export([current_version/0, version/1]).
current_version() ->
    11.

version(1) ->
    [{id,0},{version,1},{base_id,0},{player_id,0},{type,0},{subtype,0},{sum,0},{bind,0},{str_lv,0},{star_lv,0},{max_overlap,0},{container,10},{position,0},{extra_att,[]},{hp,0},{attack,0},{def,0},{hit,0},{dodge,0},{crit,0},{anti_crit,0},{stiff,0},{anti_stiff,0},{attack_speed,0},{move_speed,0},{opear_type,0},{is_dirty,0}];
version(2) ->
    [{id,0},{version,2},{base_id,0},{player_id,0},{type,0},{subtype,0},{sum,0},{bind,0},{quality,0},{str_lv,0},{star_lv,0},{max_overlap,0},{container,10},{position,0},{extra_att,[]},{hp,0},{attack,0},{def,0},{hit,0},{dodge,0},{crit,0},{anti_crit,0},{stiff,0},{anti_stiff,0},{attack_speed,0},{move_speed,0},{opear_type,0},{power,0},{jewels,[]},{belong_to,0},{is_dirty,0}];
version(3) ->
    [{id,0},{version,3},{base_id,0},{player_id,0},{type,0},{subtype,0},{sum,0},{bind,0},{quality,0},{str_lv,0},{star_lv,0},{max_overlap,0},{container,10},{position,0},{extra_att,[]},{hp,0},{attack,0},{def,0},{hit,0},{dodge,0},{crit,0},{anti_crit,0},{stiff,0},{anti_stiff,0},{attack_speed,0},{move_speed,0},{ice,0},{fire,0},{honly,0},{dark,0},{anti_ice,0},{anti_fire,0},{anti_honly,0},{anti_dark,0},{opear_type,0},{power,0},{jewels,[]},{belong_to,0},{is_dirty,0}];
version(4) ->
    [{id,0},{version,4},{base_id,0},{player_id,0},{type,0},{subtype,0},{sum,0},{bind,0},{quality,0},{str_lv,0},{star_lv,0},{max_overlap,0},{container,10},{position,0},{hp,0},{hp_ext,0},{attack,0},{attack_ext,0},{def,0},{def_ext,0},{hit,0},{hit_ext,0},{dodge,0},{dodge_ext,0},{crit,0},{crit_ext,0},{anti_crit,0},{anti_crit_ext,0},{stiff,0},{anti_stiff,0},{attack_speed,0},{move_speed,0},{ice,0},{fire,0},{honly,0},{dark,0},{anti_ice,0},{anti_fire,0},{anti_honly,0},{anti_dark,0},{opear_type,0},{power,0},{jewels,[]},{belong_to,0},{is_dirty,0}];
version(5) ->
    [{id,0},{version,5},{base_id,0},{player_id,0},{type,0},{subtype,0},{sum,0},{bind,0},{quality,0},{str_lv,0},{star_lv,0},{max_overlap,0},{container,10},{position,0},{hp,0},{mana_lim,0},{mana_rec,0},{hp_ext,0},{attack,0},{attack_ext,0},{def,0},{def_ext,0},{hit,0},{hit_ext,0},{dodge,0},{dodge_ext,0},{crit,0},{crit_ext,0},{anti_crit,0},{anti_crit_ext,0},{stiff,0},{anti_stiff,0},{attack_speed,0},{move_speed,0},{ice,0},{fire,0},{honly,0},{dark,0},{anti_ice,0},{anti_fire,0},{anti_honly,0},{anti_dark,0},{opear_type,0},{power,0},{jewels,[]},{belong_to,0},{is_dirty,0}];
version(6) ->
    [{id,0},{version,6},{base_id,0},{player_id,0},{type,0},{subtype,0},{sum,0},{bind,0},{quality,0},{str_lv,0},{star_lv,0},{max_overlap,0},{container,10},{position,0},{hp,0},{mana_lim,0},{mana_lim_ext,0},{mana_rec,0},{mana_rec_ext,0},{hp_ext,0},{attack,0},{attack_ext,0},{def,0},{def_ext,0},{hit,0},{hit_ext,0},{dodge,0},{dodge_ext,0},{crit,0},{crit_ext,0},{anti_crit,0},{anti_crit_ext,0},{stiff,0},{anti_stiff,0},{attack_speed,0},{move_speed,0},{ice,0},{fire,0},{honly,0},{dark,0},{anti_ice,0},{anti_fire,0},{anti_honly,0},{anti_dark,0},{opear_type,0},{power,0},{jewels,[]},{belong_to,0},{is_dirty,0}];
version(7) ->
    [{id,0},{version,7},{base_id,0},{player_id,0},{type,0},{subtype,0},{sum,0},{bind,0},{quality,0},{str_lv,0},{star_lv,0},{max_overlap,0},{container,10},{position,0},{hp,0},{mana_lim,0},{mana_lim_ext,0},{mana_rec,0},{mana_rec_ext,0},{hp_ext,0},{attack,0},{attack_ext,0},{def,0},{def_ext,0},{hit,0},{hit_ext,0},{dodge,0},{dodge_ext,0},{crit,0},{crit_ext,0},{anti_crit,0},{anti_crit_ext,0},{stiff,0},{anti_stiff,0},{attack_speed,0},{move_speed,0},{ice,0},{fire,0},{honly,0},{dark,0},{anti_ice,0},{anti_fire,0},{anti_honly,0},{anti_dark,0},{opear_type,0},{power,0},{jewels,[]},{skill_card_exp,0},{is_dirty,0}];
version(8) ->
    [{id,0},{version,8},{base_id,0},{player_id,0},{type,0},{subtype,0},{sum,0},{bind,0},{quality,0},{str_lv,0},{star_lv,0},{max_overlap,0},{container,10},{position,0},{hp,0},{mana_lim,0},{mana_lim_ext,0},{mana_rec,0},{mana_rec_ext,0},{hp_ext,0},{attack,0},{attack_ext,0},{def,0},{def_ext,0},{hit,0},{hit_ext,0},{dodge,0},{dodge_ext,0},{crit,0},{crit_ext,0},{anti_crit,0},{anti_crit_ext,0},{stiff,0},{anti_stiff,0},{attack_speed,0},{move_speed,0},{ice,0},{fire,0},{honly,0},{dark,0},{anti_ice,0},{anti_fire,0},{anti_honly,0},{anti_dark,0},{opear_type,0},{power,0},{jewels,[]},{skill_card_exp,0},{card_pos_1,0},{card_pos_2,0},{card_pos_3,0},{is_dirty,0}];

version(9) ->
    [{id,0},{version,9},{base_id,0},{player_id,0},{type,0},{subtype,0},{sum,0},{bind,0},{quality,0},{str_lv,0},{star_lv,0},{max_overlap,0},{container,10},{position,0},{hp,0},{mana_lim,0},{mana_lim_ext,0},{mana_rec,0},{mana_rec_ext,0},{hp_ext,0},{attack,0},{attack_ext,0},{def,0},{def_ext,0},{hit,0},{hit_ext,0},{dodge,0},{dodge_ext,0},{crit,0},{crit_ext,0},{anti_crit,0},{anti_crit_ext,0},{stiff,0},{anti_stiff,0},{attack_speed,0},{move_speed,0},{ice,0},{fire,0},{honly,0},{dark,0},{anti_ice,0},{anti_fire,0},{anti_honly,0},{anti_dark,0},{opear_type,0},{power,0},{jewels,[]},{skill_card_exp,0},{card_pos_1,0},{card_pos_2,0},{card_pos_3,0},{is_dirty,0},{own_gift_id,0},{timestamp,0},{value,[]}];

version(10) ->
    [{id,0},{version,10},{base_id,0},{player_id,0},{type,0},{subtype,0},{sum,0},{bind,0},{quality,0},{str_lv,0},{star_lv,0},{max_overlap,0},{container,10},{position,0},{hp,0},{mana_lim,0},{mana_lim_ext,0},{mana_rec,0},{mana_rec_ext,0},{hp_ext,0},{attack,0},{attack_ext,0},{def,0},{def_ext,0},{hit,0},{hit_ext,0},{dodge,0},{dodge_ext,0},{crit,0},{crit_ext,0},{anti_crit,0},{anti_crit_ext,0},{stiff,0},{anti_stiff,0},{attack_speed,0},{move_speed,0},{ice,0},{fire,0},{honly,0},{dark,0},{anti_ice,0},{anti_fire,0},{anti_honly,0},{anti_dark,0},{opear_type,0},{power,0},{jewels,[]},{skill_card_exp,0},{card_pos_1,0},{card_pos_2,0},{card_pos_3,0},{timestamp,0},{value,[]},{is_dirty,0}];

version(11) ->
    [{id,0},{version,11},{base_id,0},{player_id,0},{type,0},{subtype,0},{sum,0},{bind,0},{quality,0},{str_lv,0},{star_lv,0},{max_overlap,0},{container,10},{position,0},{hp,0},{mana_lim,0},{mana_lim_ext,0},{mana_rec,0},{mana_rec_ext,0},{hp_ext,0},{attack,0},{attack_ext,0},{def,0},{def_ext,0},{hit,0},{hit_ext,0},{dodge,0},{dodge_ext,0},{crit,0},{crit_ext,0},{anti_crit,0},{anti_crit_ext,0},{stiff,0},{anti_stiff,0},{attack_speed,0},{move_speed,0},{ice,0},{fire,0},{honly,0},{dark,0},{anti_ice,0},{anti_fire,0},{anti_honly,0},{anti_dark,0},{opear_type,0},{power,0},{jewels,[]},{skill_card_exp,0},{card_pos_1,0},{card_pos_2,0},{card_pos_3,0},{timestamp,0},{value,[]},{card_status,0},{is_dirty,0}];

version(Version) ->
    throw({version_error, Version}).
