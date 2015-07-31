%% coding: utf-8
%% Warning:本文件由data_generate自动生成，请不要手动修改
-module(data_base_function_open).
-export([get/3]).
-include("common.hrl").
-include("db_base_function_open.hrl").
get(0, 1, 10) ->
#base_function_open{type = 0,req_lv = 10,career = 1,open = {[500101],[]}};
get(0, 2, 10) ->
#base_function_open{type = 0,req_lv = 10,career = 2,open = {[500101],[]}};
get(0, 1, 15) ->
#base_function_open{type = 0,req_lv = 15,career = 1,open = {[500201],[]}};
get(0, 2, 15) ->
#base_function_open{type = 0,req_lv = 15,career = 2,open = {[500201],[]}};
get(0, 1, 20) ->
#base_function_open{type = 0,req_lv = 20,career = 1,open = {[500301],[]}};
get(0, 2, 20) ->
#base_function_open{type = 0,req_lv = 20,career = 2,open = {[500301],[]}};
get(0, 1, 25) ->
#base_function_open{type = 0,req_lv = 25,career = 1,open = {[500401,500501],[]}};
get(0, 2, 25) ->
#base_function_open{type = 0,req_lv = 25,career = 2,open = {[500401,500501],[]}};
get(0, 1, 30) ->
#base_function_open{type = 0,req_lv = 30,career = 1,open = {[500601,500701,500801],[]}};
get(0, 2, 30) ->
#base_function_open{type = 0,req_lv = 30,career = 2,open = {[500601,500701,500801],[]}};
get(Var1, Var2, Var3) -> [].
