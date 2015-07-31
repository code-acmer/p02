%% coding: utf-8
%% Warning:本文件由data_generate自动生成，请不要手动修改
-module(data_base_dungeon_match).
-export([get/1]).
-include("common.hrl").
-include("db_base_dungeon_match.hrl").
get(Lv) when Lv >= 1 andalso Lv =< 1 ->
#base_dungeon_match{id = [1,1],num = 1,float_lv = 0,float_battle_ability = 0,min_win_rate = 0,high_win_rate = 0};
get(Lv) when Lv >= 2 andalso Lv =< 20 ->
#base_dungeon_match{id = [2,20],num = 2,float_lv = 20,float_battle_ability = 10000,min_win_rate = 110,high_win_rate = 0};
get(Lv) when Lv >= 21 andalso Lv =< 30 ->
#base_dungeon_match{id = [21,30],num = 2,float_lv = 10,float_battle_ability = 10000,min_win_rate = 40,high_win_rate = 0};
get(Lv) when Lv >= 31 andalso Lv =< 50 ->
#base_dungeon_match{id = [31,50],num = 2,float_lv = 20,float_battle_ability = 10070,min_win_rate = 30,high_win_rate = 0};
get(Lv) when Lv >= 51 andalso Lv =< 60 ->
#base_dungeon_match{id = [51,60],num = 2,float_lv = 10,float_battle_ability = 10090,min_win_rate = 20,high_win_rate = 0};
get(Lv) when Lv >= 61 andalso Lv =< 100 ->
#base_dungeon_match{id = [61,100],num = 2,float_lv = 20,float_battle_ability = 10000,min_win_rate = 10,high_win_rate = 0};
get(Var1) -> ?WARNING_MSG("get not find ~p", [{Var1}]),
[].
