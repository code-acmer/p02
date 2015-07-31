%% coding: utf-8
%% Warning:本文件由data_generate自动生成，请不要手动修改
-module(data_base_goods_color_hole).
-export([get/1]).
-include("common.hrl").
-include("db_base_goods_color_hole.hrl").
get(1) ->
#base_goods_color_hole{id = 1,desc = <<"蓝色"/utf8>>,hole = 1};
get(2) ->
#base_goods_color_hole{id = 2,desc = <<"紫色"/utf8>>,hole = 3};
get(3) ->
#base_goods_color_hole{id = 3,desc = <<"橙色"/utf8>>,hole = 5};
get(4) ->
#base_goods_color_hole{id = 4,desc = <<"红色"/utf8>>,hole = 7};
get(5) ->
#base_goods_color_hole{id = 5,desc = <<"流光"/utf8>>,hole = 7};
get(Var1) -> ?WARNING_MSG("get not find ~p", [{Var1}]),
[].
