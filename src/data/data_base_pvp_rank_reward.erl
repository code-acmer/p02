%% coding: utf-8
%% Warning:本文件由data_generate自动生成，请不要手动修改
-module(data_base_pvp_rank_reward).
-export([get/1]).
-export([get_reward_by_rank/1]).
-include("common.hrl").
-include("db_base_pvp_rank_reward.hrl").
get(RankRange) when RankRange >= 1 andalso RankRange =< 1 ->
#base_pvp_rank_reward{id = 1,rank_range = [1,1],reward = [{11,1000},{1,400}],disposable_rank_range = [1,1],disposable_rank_reward = [{1,1000}]};
get(RankRange) when RankRange >= 2 andalso RankRange =< 2 ->
#base_pvp_rank_reward{id = 2,rank_range = [2,2],reward = [{11,900},{1,360}],disposable_rank_range = [2,2],disposable_rank_reward = [{1,700}]};
get(RankRange) when RankRange >= 3 andalso RankRange =< 3 ->
#base_pvp_rank_reward{id = 3,rank_range = [3,3],reward = [{11,850},{1,340}],disposable_rank_range = [3,3],disposable_rank_reward = [{1,460}]};
get(RankRange) when RankRange >= 4 andalso RankRange =< 4 ->
#base_pvp_rank_reward{id = 4,rank_range = [4,4],reward = [{11,820},{1,328}],disposable_rank_range = [4,10],disposable_rank_reward = [{1,300}]};
get(RankRange) when RankRange >= 5 andalso RankRange =< 5 ->
#base_pvp_rank_reward{id = 5,rank_range = [5,5],reward = [{11,790},{1,316}],disposable_rank_range = [11,20],disposable_rank_reward = [{1,200}]};
get(RankRange) when RankRange >= 6 andalso RankRange =< 6 ->
#base_pvp_rank_reward{id = 6,rank_range = [6,6],reward = [{11,760},{1,304}],disposable_rank_range = [21,35],disposable_rank_reward = [{1,160}]};
get(RankRange) when RankRange >= 7 andalso RankRange =< 7 ->
#base_pvp_rank_reward{id = 7,rank_range = [7,7],reward = [{11,730},{1,292}],disposable_rank_range = [36,60],disposable_rank_reward = [{1,140}]};
get(RankRange) when RankRange >= 8 andalso RankRange =< 8 ->
#base_pvp_rank_reward{id = 8,rank_range = [8,8],reward = [{11,700},{1,280}],disposable_rank_range = [61,100],disposable_rank_reward = [{1,120}]};
get(RankRange) when RankRange >= 9 andalso RankRange =< 9 ->
#base_pvp_rank_reward{id = 9,rank_range = [9,9],reward = [{11,670},{1,268}],disposable_rank_range = [101,250],disposable_rank_reward = [{1,80}]};
get(RankRange) when RankRange >= 10 andalso RankRange =< 10 ->
#base_pvp_rank_reward{id = 10,rank_range = [10,10],reward = [{11,640},{1,256}],disposable_rank_range = [251,500],disposable_rank_reward = [{1,60}]};
get(RankRange) when RankRange >= 11 andalso RankRange =< 50 ->
#base_pvp_rank_reward{id = 11,rank_range = [11,50],reward = [{11,590},{1,236}],disposable_rank_range = [501,1000],disposable_rank_reward = [{1,40}]};
get(RankRange) when RankRange >= 51 andalso RankRange =< 100 ->
#base_pvp_rank_reward{id = 12,rank_range = [51,100],reward = [{11,520},{1,208}],disposable_rank_range = [1001,2500],disposable_rank_reward = [{1,30}]};
get(RankRange) when RankRange >= 101 andalso RankRange =< 200 ->
#base_pvp_rank_reward{id = 13,rank_range = [101,200],reward = [{11,450},{1,180}],disposable_rank_range = [2501,5000],disposable_rank_reward = [{1,20}]};
get(RankRange) when RankRange >= 201 andalso RankRange =< 500 ->
#base_pvp_rank_reward{id = 14,rank_range = [201,500],reward = [{11,380},{1,160}],disposable_rank_range = [0,0],disposable_rank_reward = [0,0]};
get(RankRange) when RankRange >= 501 andalso RankRange =< 1000 ->
#base_pvp_rank_reward{id = 15,rank_range = [501,1000],reward = [{11,310},{1,140}],disposable_rank_range = [0,0],disposable_rank_reward = [0,0]};
get(RankRange) when RankRange >= 1001 andalso RankRange =< 2000 ->
#base_pvp_rank_reward{id = 16,rank_range = [1001,2000],reward = [{11,240},{1,120}],disposable_rank_range = [0,0],disposable_rank_reward = [0,0]};
get(RankRange) when RankRange >= 2001 andalso RankRange =< 5000 ->
#base_pvp_rank_reward{id = 17,rank_range = [2001,5000],reward = [{11,170},{1,100}],disposable_rank_range = [0,0],disposable_rank_reward = [0,0]};
get(RankRange) when RankRange >= 5001 andalso RankRange =< 10000 ->
#base_pvp_rank_reward{id = 18,rank_range = [5001,10000],reward = [{11,100},{1,80}],disposable_rank_range = [0,0],disposable_rank_reward = [0,0]};
get(RankRange) when RankRange >= 10001 andalso RankRange =< 9999999 ->
#base_pvp_rank_reward{id = 19,rank_range = [10001,9999999],reward = [{11,50},{1,60}],disposable_rank_range = [0,0],disposable_rank_reward = [0,0]};
get(Var1) -> ?WARNING_MSG("get not find ~p", [{Var1}]),
[].

get_reward_by_rank(Rank) when Rank >= 1 andalso Rank =< 1 ->
#base_pvp_rank_reward{id = 1,rank_range = [1,1],reward = [{11,1000},{1,400}],disposable_rank_range = [1,1],disposable_rank_reward = [{1,1000}]};
get_reward_by_rank(Rank) when Rank >= 2 andalso Rank =< 2 ->
#base_pvp_rank_reward{id = 2,rank_range = [2,2],reward = [{11,900},{1,360}],disposable_rank_range = [2,2],disposable_rank_reward = [{1,700}]};
get_reward_by_rank(Rank) when Rank >= 3 andalso Rank =< 3 ->
#base_pvp_rank_reward{id = 3,rank_range = [3,3],reward = [{11,850},{1,340}],disposable_rank_range = [3,3],disposable_rank_reward = [{1,460}]};
get_reward_by_rank(Rank) when Rank >= 4 andalso Rank =< 10 ->
#base_pvp_rank_reward{id = 4,rank_range = [4,4],reward = [{11,820},{1,328}],disposable_rank_range = [4,10],disposable_rank_reward = [{1,300}]};
get_reward_by_rank(Rank) when Rank >= 11 andalso Rank =< 20 ->
#base_pvp_rank_reward{id = 5,rank_range = [5,5],reward = [{11,790},{1,316}],disposable_rank_range = [11,20],disposable_rank_reward = [{1,200}]};
get_reward_by_rank(Rank) when Rank >= 21 andalso Rank =< 35 ->
#base_pvp_rank_reward{id = 6,rank_range = [6,6],reward = [{11,760},{1,304}],disposable_rank_range = [21,35],disposable_rank_reward = [{1,160}]};
get_reward_by_rank(Rank) when Rank >= 36 andalso Rank =< 60 ->
#base_pvp_rank_reward{id = 7,rank_range = [7,7],reward = [{11,730},{1,292}],disposable_rank_range = [36,60],disposable_rank_reward = [{1,140}]};
get_reward_by_rank(Rank) when Rank >= 61 andalso Rank =< 100 ->
#base_pvp_rank_reward{id = 8,rank_range = [8,8],reward = [{11,700},{1,280}],disposable_rank_range = [61,100],disposable_rank_reward = [{1,120}]};
get_reward_by_rank(Rank) when Rank >= 101 andalso Rank =< 250 ->
#base_pvp_rank_reward{id = 9,rank_range = [9,9],reward = [{11,670},{1,268}],disposable_rank_range = [101,250],disposable_rank_reward = [{1,80}]};
get_reward_by_rank(Rank) when Rank >= 251 andalso Rank =< 500 ->
#base_pvp_rank_reward{id = 10,rank_range = [10,10],reward = [{11,640},{1,256}],disposable_rank_range = [251,500],disposable_rank_reward = [{1,60}]};
get_reward_by_rank(Rank) when Rank >= 501 andalso Rank =< 1000 ->
#base_pvp_rank_reward{id = 11,rank_range = [11,50],reward = [{11,590},{1,236}],disposable_rank_range = [501,1000],disposable_rank_reward = [{1,40}]};
get_reward_by_rank(Rank) when Rank >= 1001 andalso Rank =< 2500 ->
#base_pvp_rank_reward{id = 12,rank_range = [51,100],reward = [{11,520},{1,208}],disposable_rank_range = [1001,2500],disposable_rank_reward = [{1,30}]};
get_reward_by_rank(Rank) when Rank >= 2501 andalso Rank =< 5000 ->
#base_pvp_rank_reward{id = 13,rank_range = [101,200],reward = [{11,450},{1,180}],disposable_rank_range = [2501,5000],disposable_rank_reward = [{1,20}]};
get_reward_by_rank(Rank) when Rank >= 0 andalso Rank =< 0 ->
#base_pvp_rank_reward{id = 14,rank_range = [201,500],reward = [{11,380},{1,160}],disposable_rank_range = [0,0],disposable_rank_reward = [0,0]};
get_reward_by_rank(Rank) when Rank >= 0 andalso Rank =< 0 ->
#base_pvp_rank_reward{id = 15,rank_range = [501,1000],reward = [{11,310},{1,140}],disposable_rank_range = [0,0],disposable_rank_reward = [0,0]};
get_reward_by_rank(Rank) when Rank >= 0 andalso Rank =< 0 ->
#base_pvp_rank_reward{id = 16,rank_range = [1001,2000],reward = [{11,240},{1,120}],disposable_rank_range = [0,0],disposable_rank_reward = [0,0]};
get_reward_by_rank(Rank) when Rank >= 0 andalso Rank =< 0 ->
#base_pvp_rank_reward{id = 17,rank_range = [2001,5000],reward = [{11,170},{1,100}],disposable_rank_range = [0,0],disposable_rank_reward = [0,0]};
get_reward_by_rank(Rank) when Rank >= 0 andalso Rank =< 0 ->
#base_pvp_rank_reward{id = 18,rank_range = [5001,10000],reward = [{11,100},{1,80}],disposable_rank_range = [0,0],disposable_rank_reward = [0,0]};
get_reward_by_rank(Rank) when Rank >= 0 andalso Rank =< 0 ->
#base_pvp_rank_reward{id = 19,rank_range = [10001,9999999],reward = [{11,50},{1,60}],disposable_rank_range = [0,0],disposable_rank_reward = [0,0]};
get_reward_by_rank(Var1) -> ?WARNING_MSG("get_reward_by_rank not find ~p", [{Var1}]),
[].
