%% coding: utf-8
%% Warning:本文件由data_generate自动生成，请不要手动修改
-module(data_base_kuafupvp_rank_reward).
-export([get/1]).
-include("common.hrl").
-include("db_base_kuafupvp_rank_reward.hrl").
get(1) ->
#base_kuafupvp_rank_reward{id = 1,reward = [{10,10}]};
get(2) ->
#base_kuafupvp_rank_reward{id = 2,reward = [{10,9}]};
get(3) ->
#base_kuafupvp_rank_reward{id = 3,reward = [{10,8}]};
get(4) ->
#base_kuafupvp_rank_reward{id = 4,reward = [{10,7}]};
get(5) ->
#base_kuafupvp_rank_reward{id = 5,reward = [{10,6}]};
get(6) ->
#base_kuafupvp_rank_reward{id = 6,reward = [{10,5}]};
get(7) ->
#base_kuafupvp_rank_reward{id = 7,reward = [{10,4}]};
get(8) ->
#base_kuafupvp_rank_reward{id = 8,reward = [{10,3}]};
get(9) ->
#base_kuafupvp_rank_reward{id = 9,reward = [{10,2}]};
get(10) ->
#base_kuafupvp_rank_reward{id = 10,reward = [{10,1}]};
get(Var1) -> ?WARNING_MSG("get not find ~p", [{Var1}]),
[].
