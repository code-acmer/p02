%% coding: utf-8
%% Warning:本文件由data_generate自动生成，请不要手动修改
-module(data_base_month_reward).
-export([get/1]).
-include("common.hrl").
-include("db_base_month_reward.hrl").
get(1) ->
#base_month_reward{id = 1,reward = [{3,3800}],vip = 0};
get(2) ->
#base_month_reward{id = 2,reward = [{270101,3}],vip = 1};
get(3) ->
#base_month_reward{id = 3,reward = [{6,2300}],vip = 0};
get(4) ->
#base_month_reward{id = 4,reward = [{90114000,1},{90214000,1}],vip = 1};
get(5) ->
#base_month_reward{id = 5,reward = [{240100101,45}],vip = 0};
get(6) ->
#base_month_reward{id = 6,reward = [{280113,8}],vip = 1};
get(7) ->
#base_month_reward{id = 7,reward = [{3,5700}],vip = 0};
get(8) ->
#base_month_reward{id = 8,reward = [{270101,5}],vip = 2};
get(9) ->
#base_month_reward{id = 9,reward = [{6,3400}],vip = 0};
get(10) ->
#base_month_reward{id = 10,reward = [{90114000,2},{90214000,2}],vip = 3};
get(11) ->
#base_month_reward{id = 11,reward = [{240100101,68}],vip = 0};
get(12) ->
#base_month_reward{id = 12,reward = [{280113,11}],vip = 2};
get(13) ->
#base_month_reward{id = 13,reward = [{3,8500}],vip = 0};
get(14) ->
#base_month_reward{id = 14,reward = [{270102,2}],vip = 3};
get(15) ->
#base_month_reward{id = 15,reward = [{6,5100}],vip = 0};
get(16) ->
#base_month_reward{id = 16,reward = [{90114000,2},{90214000,2}],vip = 5};
get(17) ->
#base_month_reward{id = 17,reward = [{240100101,102}],vip = 0};
get(18) ->
#base_month_reward{id = 18,reward = [{280113,17}],vip = 3};
get(19) ->
#base_month_reward{id = 19,reward = [{3,12800}],vip = 0};
get(20) ->
#base_month_reward{id = 20,reward = [{270103,1}],vip = 4};
get(21) ->
#base_month_reward{id = 21,reward = [{6,7700}],vip = 0};
get(22) ->
#base_month_reward{id = 22,reward = [{90114000,2},{90214000,2}],vip = 7};
get(23) ->
#base_month_reward{id = 23,reward = [{240100101,154}],vip = 0};
get(24) ->
#base_month_reward{id = 24,reward = [{280113,26}],vip = 4};
get(25) ->
#base_month_reward{id = 25,reward = [{3,19200}],vip = 0};
get(26) ->
#base_month_reward{id = 26,reward = [{270103,2}],vip = 5};
get(27) ->
#base_month_reward{id = 27,reward = [{6,11500}],vip = 0};
get(28) ->
#base_month_reward{id = 28,reward = [{90114000,3},{90214000,3}],vip = 9};
get(29) ->
#base_month_reward{id = 29,reward = [{240100101,230}],vip = 0};
get(30) ->
#base_month_reward{id = 30,reward = [{280113,38}],vip = 5};
get(31) ->
#base_month_reward{id = 31,reward = [{3,25000}],vip = 0};
get(Var1) -> ?WARNING_MSG("get not find ~p", [{Var1}]),
[].
