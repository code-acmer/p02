%% coding: utf-8
%% Warning:本文件由data_generate自动生成，请不要手动修改
-module(data_base_params).
-export([get/1]).
-export([get_value_by_id/1]).
-export([get_value_by_name/1]).
-export([get_all_list/0]).
-include("common.hrl").
-include("db_base_params.hrl").
get(Var1) -> ?WARNING_MSG("get not find ~p", [{Var1}]),
[].

get_value_by_id(Var1) -> ?WARNING_MSG("get_value_by_id not find ~p", [{Var1}]),
[].

get_value_by_name(Var1) -> ?WARNING_MSG("get_value_by_name not find ~p", [{Var1}]),
[].

get_all_list() ->
[].
