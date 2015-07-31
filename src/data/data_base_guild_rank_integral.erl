%% coding: utf-8
%% Warning:本文件由data_generate自动生成，请不要手动修改
-module(data_base_guild_rank_integral).
-export([get/1]).
-export([all/0]).
-include("common.hrl").
-include("db_base_guild_rank_integral.hrl").
get(1) ->
#base_guild_rank_integral{id = 1,rank_wage = 100,rank_score = 0,name = <<"青铜组"/utf8>>};
get(2) ->
#base_guild_rank_integral{id = 2,rank_wage = 120,rank_score = 10,name = <<"黑铁组"/utf8>>};
get(3) ->
#base_guild_rank_integral{id = 3,rank_wage = 150,rank_score = 20,name = <<"赤钢组"/utf8>>};
get(4) ->
#base_guild_rank_integral{id = 4,rank_wage = 180,rank_score = 30,name = <<"白银组"/utf8>>};
get(5) ->
#base_guild_rank_integral{id = 5,rank_wage = 210,rank_score = 45,name = <<"黄金组"/utf8>>};
get(6) ->
#base_guild_rank_integral{id = 6,rank_wage = 250,rank_score = 65,name = <<"白金组"/utf8>>};
get(7) ->
#base_guild_rank_integral{id = 7,rank_wage = 300,rank_score = 100,name = <<"钻石组"/utf8>>};
get(8) ->
#base_guild_rank_integral{id = 8,rank_wage = 350,rank_score = 140,name = <<"大师组"/utf8>>};
get(9) ->
#base_guild_rank_integral{id = 9,rank_wage = 400,rank_score = 200,name = <<"至尊组"/utf8>>};
get(Var1) -> ?WARNING_MSG("get not find ~p", [{Var1}]),
[].

all() ->
[1,2,3,4,5,6,7,8,9].
