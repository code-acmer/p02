%% coding: utf-8
%% Warning:本文件由data_generate自动生成，请不要手动修改
-module(data_base_guild_lv_exp).
-export([get/1]).
-export([get_all_lv/0]).
-export([get_all_exp/0]).
-include("common.hrl").
-include("db_base_guild_lv_exp.hrl").
get(1) ->
#base_guild_lv_exp{guild_level = 1,guild_exp = 0};
get(2) ->
#base_guild_lv_exp{guild_level = 2,guild_exp = 3000};
get(3) ->
#base_guild_lv_exp{guild_level = 3,guild_exp = 8000};
get(4) ->
#base_guild_lv_exp{guild_level = 4,guild_exp = 15000};
get(5) ->
#base_guild_lv_exp{guild_level = 5,guild_exp = 32000};
get(6) ->
#base_guild_lv_exp{guild_level = 6,guild_exp = 70000};
get(7) ->
#base_guild_lv_exp{guild_level = 7,guild_exp = 120000};
get(8) ->
#base_guild_lv_exp{guild_level = 8,guild_exp = 240000};
get(9) ->
#base_guild_lv_exp{guild_level = 9,guild_exp = 360000};
get(10) ->
#base_guild_lv_exp{guild_level = 10,guild_exp = 480000};
get(11) ->
#base_guild_lv_exp{guild_level = 11,guild_exp = 600000};
get(12) ->
#base_guild_lv_exp{guild_level = 12,guild_exp = 720000};
get(13) ->
#base_guild_lv_exp{guild_level = 13,guild_exp = 900000};
get(Var1) -> ?WARNING_MSG("get not find ~p", [{Var1}]),
[].

get_all_lv() ->
[1,2,3,4,5,6,7,8,9,10,11,12,13].

get_all_exp() ->
[0,3000,8000,15000,32000,70000,120000,240000,360000,480000,600000,720000,900000].
