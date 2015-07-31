%% coding: utf-8
%% Warning:本文件由data_generate自动生成，请不要手动修改
-module(data_base_shop_activity).
-export([get/1]).
-export([get_all_id/0]).
-include("common.hrl").
-include("db_base_shop_activity.hrl").
get(1) ->
#base_shop_activity{id = 1,start_time = {2015,1,2,8,0,0},last_time = {0,0,7,0,0,0},shop_ids = [9000020,9000021,9000023,9000024,9000025,9000026,9000027,9000028]};
get(Var1) -> ?WARNING_MSG("get not find ~p", [{Var1}]),
[].

get_all_id() ->
[1].
