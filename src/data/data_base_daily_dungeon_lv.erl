%% coding: utf-8
%% Warning:本文件由data_generate自动生成，请不要手动修改
-module(data_base_daily_dungeon_lv).
-export([get/1]).
-include("common.hrl").
-include("db_base_daily_dungeon_lv.hrl").
get(1) ->
#base_daily_dungeon_lv{id = 1,lv = [-5,-1]};
get(2) ->
#base_daily_dungeon_lv{id = 2,lv = [-6,-2]};
get(3) ->
#base_daily_dungeon_lv{id = 3,lv = [-7,-3]};
get(4) ->
#base_daily_dungeon_lv{id = 4,lv = [-8,-4]};
get(5) ->
#base_daily_dungeon_lv{id = 5,lv = [-9,-5]};
get(6) ->
#base_daily_dungeon_lv{id = 6,lv = [1,5]};
get(7) ->
#base_daily_dungeon_lv{id = 7,lv = [2,6]};
get(8) ->
#base_daily_dungeon_lv{id = 8,lv = [3,7]};
get(9) ->
#base_daily_dungeon_lv{id = 9,lv = [4,8]};
get(10) ->
#base_daily_dungeon_lv{id = 10,lv = [5,9]};
get(Var1) -> ?WARNING_MSG("get not find ~p", [{Var1}]),
[].
