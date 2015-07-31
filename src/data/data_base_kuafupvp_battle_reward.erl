%% coding: utf-8
%% Warning:本文件由data_generate自动生成，请不要手动修改
-module(data_base_kuafupvp_battle_reward).
-export([get/1]).
-include("common.hrl").
-include("db_base_kuafupvp_battle_reward.hrl").
get(Ability) when Ability >= 0 andalso Ability =<10000 ->
#base_kuafupvp_battle_reward{id = 1,power_range = [0,10000],win_reward = [[{0,10000,3,1000,0,0,0}],[{0,10000,7,10,0,0,0}],[{0,10000,10,7,0,0,0}],[{1,3500,280134,1,0,0,0}],[{1,1000,280115,1,0,0,0}]]};
get(Ability) when Ability >= 10001 andalso Ability =<16000 ->
#base_kuafupvp_battle_reward{id = 2,power_range = [10001,16000],win_reward = [[{0,10000,3,1500,0,0,0}],[{0,10000,7,10,0,0,0}],[{0,10000,10,10,0,0,0}],[{1,3500,280134,1,0,0,0}],[{1,1000,280115,1,0,0,0}]]};
get(Ability) when Ability >= 16001 andalso Ability =<25000 ->
#base_kuafupvp_battle_reward{id = 3,power_range = [16001,25000],win_reward = [[{0,10000,3,2000,0,0,0}],[{0,10000,7,10,0,0,0}],[{0,10000,10,13,0,0,0}],[{1,3500,280134,1,0,0,0}],[{1,1000,280115,1,0,0,0}]]};
get(Ability) when Ability >= 25001 andalso Ability =<38000 ->
#base_kuafupvp_battle_reward{id = 4,power_range = [25001,38000],win_reward = [[{0,10000,3,2500,0,0,0}],[{0,10000,7,10,0,0,0}],[{0,10000,10,16,0,0,0}],[{1,3500,280134,1,0,0,0}],[{1,1000,280115,1,0,0,0}]]};
get(Ability) when Ability >= 38001 andalso Ability =<55000 ->
#base_kuafupvp_battle_reward{id = 5,power_range = [38001,55000],win_reward = [[{0,10000,3,3000,0,0,0}],[{0,10000,7,10,0,0,0}],[{0,10000,10,19,0,0,0}],[{1,3500,280134,1,0,0,0}],[{1,1000,280115,1,0,0,0}]]};
get(Ability) when Ability >= 55001 andalso Ability =<80000 ->
#base_kuafupvp_battle_reward{id = 6,power_range = [55001,80000],win_reward = [[{0,10000,3,3500,0,0,0}],[{0,10000,7,10,0,0,0}],[{0,10000,10,22,0,0,0}],[{1,3500,280134,1,0,0,0}],[{1,1000,280115,1,0,0,0}]]};
get(Ability) when Ability >= 80001 andalso Ability =<110000 ->
#base_kuafupvp_battle_reward{id = 7,power_range = [80001,110000],win_reward = [[{0,10000,3,4000,0,0,0}],[{0,10000,7,10,0,0,0}],[{0,10000,10,25,0,0,0}],[{1,3500,280134,1,0,0,0}],[{1,1000,280115,1,0,0,0}]]};
get(Ability) when Ability >= 110001 andalso Ability =<150000 ->
#base_kuafupvp_battle_reward{id = 8,power_range = [110001,150000],win_reward = [[{0,10000,3,4500,0,0,0}],[{0,10000,7,10,0,0,0}],[{0,10000,10,28,0,0,0}],[{1,3500,280134,1,0,0,0}],[{1,1000,280115,1,0,0,0}]]};
get(Ability) when Ability >= 150001 andalso Ability =<220000 ->
#base_kuafupvp_battle_reward{id = 9,power_range = [150001,220000],win_reward = [[{0,10000,3,5000,0,0,0}],[{0,10000,7,10,0,0,0}],[{0,10000,10,31,0,0,0}],[{1,3500,280134,1,0,0,0}],[{1,1000,280115,1,0,0,0}]]};
get(Ability) when Ability >= 220001 andalso Ability =<300000 ->
#base_kuafupvp_battle_reward{id = 10,power_range = [220001,300000],win_reward = [[{0,10000,3,5500,0,0,0}],[{0,10000,7,10,0,0,0}],[{0,10000,10,34,0,0,0}],[{1,3500,280134,1,0,0,0}],[{1,1000,280115,1,0,0,0}]]};
get(Ability) when Ability >= 300001 andalso Ability =<400000 ->
#base_kuafupvp_battle_reward{id = 11,power_range = [300001,400000],win_reward = [[{0,10000,3,6000,0,0,0}],[{0,10000,7,10,0,0,0}],[{0,10000,10,37,0,0,0}],[{1,3500,280134,1,0,0,0}],[{1,1000,280115,1,0,0,0}]]};
get(Ability) when Ability >= 400001 andalso Ability =<999999 ->
#base_kuafupvp_battle_reward{id = 12,power_range = [400001,999999],win_reward = [[{0,10000,3,6500,0,0,0}],[{0,10000,7,10,0,0,0}],[{0,10000,10,40,0,0,0}],[{1,3500,280134,1,0,0,0}],[{1,1000,280115,1,0,0,0}]]};
get(Var1) -> ?WARNING_MSG("get not find ~p", [{Var1}]),
[].
