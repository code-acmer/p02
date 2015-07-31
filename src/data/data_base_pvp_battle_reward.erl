%% coding: utf-8
%% Warning:本文件由data_generate自动生成，请不要手动修改
-module(data_base_pvp_battle_reward).
-export([get/1]).
-include("common.hrl").
-include("db_base_pvp_battle_reward.hrl").
get(RankRange) when RankRange >= 1 andalso RankRange =< 1 ->
#base_pvp_battle_reward{id = 1,rank_range = [1,1],win_reward = [{7,10}],lose_reward = []};
get(RankRange) when RankRange >= 2 andalso RankRange =< 2 ->
#base_pvp_battle_reward{id = 2,rank_range = [2,2],win_reward = [{7,10}],lose_reward = []};
get(RankRange) when RankRange >= 3 andalso RankRange =< 3 ->
#base_pvp_battle_reward{id = 3,rank_range = [3,3],win_reward = [{7,10}],lose_reward = []};
get(RankRange) when RankRange >= 4 andalso RankRange =< 4 ->
#base_pvp_battle_reward{id = 4,rank_range = [4,4],win_reward = [{7,10}],lose_reward = []};
get(RankRange) when RankRange >= 5 andalso RankRange =< 5 ->
#base_pvp_battle_reward{id = 5,rank_range = [5,5],win_reward = [{7,10}],lose_reward = []};
get(RankRange) when RankRange >= 6 andalso RankRange =< 6 ->
#base_pvp_battle_reward{id = 6,rank_range = [6,6],win_reward = [{7,10}],lose_reward = []};
get(RankRange) when RankRange >= 7 andalso RankRange =< 7 ->
#base_pvp_battle_reward{id = 7,rank_range = [7,7],win_reward = [{7,10}],lose_reward = []};
get(RankRange) when RankRange >= 8 andalso RankRange =< 8 ->
#base_pvp_battle_reward{id = 8,rank_range = [8,8],win_reward = [{7,10}],lose_reward = []};
get(RankRange) when RankRange >= 9 andalso RankRange =< 9 ->
#base_pvp_battle_reward{id = 9,rank_range = [9,9],win_reward = [{7,10}],lose_reward = []};
get(RankRange) when RankRange >= 10 andalso RankRange =< 10 ->
#base_pvp_battle_reward{id = 10,rank_range = [10,10],win_reward = [{7,10}],lose_reward = []};
get(RankRange) when RankRange >= 11 andalso RankRange =< 50 ->
#base_pvp_battle_reward{id = 11,rank_range = [11,50],win_reward = [{7,10}],lose_reward = []};
get(RankRange) when RankRange >= 51 andalso RankRange =< 100 ->
#base_pvp_battle_reward{id = 12,rank_range = [51,100],win_reward = [{7,10}],lose_reward = []};
get(RankRange) when RankRange >= 101 andalso RankRange =< 200 ->
#base_pvp_battle_reward{id = 13,rank_range = [101,200],win_reward = [{7,10}],lose_reward = []};
get(RankRange) when RankRange >= 201 andalso RankRange =< 500 ->
#base_pvp_battle_reward{id = 14,rank_range = [201,500],win_reward = [{7,10}],lose_reward = []};
get(RankRange) when RankRange >= 501 andalso RankRange =< 1000 ->
#base_pvp_battle_reward{id = 15,rank_range = [501,1000],win_reward = [{7,10}],lose_reward = []};
get(RankRange) when RankRange >= 1001 andalso RankRange =< 2000 ->
#base_pvp_battle_reward{id = 16,rank_range = [1001,2000],win_reward = [{7,10}],lose_reward = []};
get(RankRange) when RankRange >= 2001 andalso RankRange =< 5000 ->
#base_pvp_battle_reward{id = 17,rank_range = [2001,5000],win_reward = [{7,10}],lose_reward = []};
get(RankRange) when RankRange >= 5001 andalso RankRange =< 10000 ->
#base_pvp_battle_reward{id = 18,rank_range = [5001,10000],win_reward = [{7,10}],lose_reward = []};
get(RankRange) when RankRange >= 10001 andalso RankRange =< 9999999 ->
#base_pvp_battle_reward{id = 19,rank_range = [10001,9999999],win_reward = [{7,10}],lose_reward = []};
get(Var1) -> ?WARNING_MSG("get not find ~p", [{Var1}]),
[].
