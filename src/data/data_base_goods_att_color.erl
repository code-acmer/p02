%% coding: utf-8
%% Warning:本文件由data_generate自动生成，请不要手动修改
-module(data_base_goods_att_color).
-export([get/1]).
-include("common.hrl").
-include("db_base_goods_att_color.hrl").
get(1) ->
#base_goods_att_color{id = 1,att_num = 0};
get(2) ->
#base_goods_att_color{id = 2,att_num = 2};
get(3) ->
#base_goods_att_color{id = 3,att_num = 2};
get(4) ->
#base_goods_att_color{id = 4,att_num = 3};
get(5) ->
#base_goods_att_color{id = 5,att_num = 3};
get(Var1) -> ?WARNING_MSG("get not find ~p", [{Var1}]),
[].
