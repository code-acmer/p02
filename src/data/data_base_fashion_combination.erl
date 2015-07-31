%% coding: utf-8
%% Warning:本文件由data_generate自动生成，请不要手动修改
-module(data_base_fashion_combination).
-export([get/1]).
-export([all/0]).
-include("common.hrl").
-include("db_base_fashion_combination.hrl").
get(41000001) ->
#base_fashion_combination{id = 41000001,name = <<"恶魔套装"/utf8>>,desc = <<"恶魔套装"/utf8>>,weapon_id = 40000001,clothes_id = 40000002,wing_id = 40000003,ornament_id = 40000004,wish_id = 40000005};
get(Var1) -> ?WARNING_MSG("get not find ~p", [{Var1}]),
[].

all() ->
[41000001].
