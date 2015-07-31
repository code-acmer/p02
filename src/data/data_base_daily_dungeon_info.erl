%% coding: utf-8
%% Warning:本文件由data_generate自动生成，请不要手动修改
-module(data_base_daily_dungeon_info).
-export([get/1]).
-include("common.hrl").
-include("db_base_daily_dungeon_info.hrl").
get(Lv) when Lv >= 1 andalso Lv =< 10 ->
#base_daily_dungeon_info{id = 1,lv = [1,10],lv_condition = [1,3,5,7,9],pass_condition = [{10,0},{9,1},{8,2},{7,3},{6,4},{5,5},{4,6},{3,7},{2,8},{1,9}]};
get(Lv) when Lv >= 11 andalso Lv =< 20 ->
#base_daily_dungeon_info{id = 2,lv = [11,20],lv_condition = [1,3,5,7,9],pass_condition = [{10,1},{9,2},{8,3},{7,4},{6,4},{5,6},{4,7},{3,8},{2,9},{1,10}]};
get(Lv) when Lv >= 21 andalso Lv =< 30 ->
#base_daily_dungeon_info{id = 3,lv = [21,30],lv_condition = [1,3,5,7,9],pass_condition = [{10,2},{9,3},{8,4},{7,5},{6,6},{5,7},{4,8},{3,9},{2,10},{1,11}]};
get(Lv) when Lv >= 31 andalso Lv =< 40 ->
#base_daily_dungeon_info{id = 4,lv = [31,40],lv_condition = [2,4,6,8,10],pass_condition = [{10,3},{9,4},{8,5},{7,6},{6,7},{5,8},{4,9},{3,10},{2,11},{1,12}]};
get(Lv) when Lv >= 41 andalso Lv =< 50 ->
#base_daily_dungeon_info{id = 5,lv = [41,50],lv_condition = [2,4,6,8,10],pass_condition = [{10,4},{9,5},{8,6},{7,7},{6,8},{5,9},{4,10},{3,11},{2,12},{1,13}]};
get(Lv) when Lv >= 51 andalso Lv =< 60 ->
#base_daily_dungeon_info{id = 6,lv = [51,60],lv_condition = [1,5,9],pass_condition = [{10,5},{9,6},{8,7},{7,8},{6,9},{5,10},{4,11},{3,12},{2,13},{1,14}]};
get(Lv) when Lv >= 61 andalso Lv =< 70 ->
#base_daily_dungeon_info{id = 7,lv = [61,70],lv_condition = [1,5,9],pass_condition = [{10,6},{9,7},{8,8},{7,9},{6,10},{5,11},{4,12},{3,13},{2,14},{1,15}]};
get(Lv) when Lv >= 71 andalso Lv =< 80 ->
#base_daily_dungeon_info{id = 8,lv = [71,80],lv_condition = [2,6,10],pass_condition = [{10,7},{9,8},{8,9},{7,10},{6,11},{5,12},{4,13},{3,14},{2,15},{1,16}]};
get(Lv) when Lv >= 81 andalso Lv =< 90 ->
#base_daily_dungeon_info{id = 9,lv = [81,90],lv_condition = [2,6,10],pass_condition = [{10,8},{9,9},{8,10},{7,11},{6,12},{5,13},{4,14},{3,15},{2,16},{1,17}]};
get(Lv) when Lv >= 91 andalso Lv =< 100 ->
#base_daily_dungeon_info{id = 10,lv = [91,100],lv_condition = [3,6,9],pass_condition = [{10,9},{9,10},{8,11},{7,12},{6,13},{5,14},{4,15},{3,16},{2,17},{1,18}]};
get(Lv) when Lv >= 101 andalso Lv =< 110 ->
#base_daily_dungeon_info{id = 11,lv = [101,110],lv_condition = [3,6,9],pass_condition = [{10,10},{9,11},{8,12},{7,13},{6,14},{5,15},{4,16},{3,17},{2,18},{1,19}]};
get(Var1) -> ?WARNING_MSG("get not find ~p", [{Var1}]),
[].
