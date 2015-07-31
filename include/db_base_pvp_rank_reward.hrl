%% Warning:本文件由make_record自动生成，请不要手动修改
-ifndef(DB_BASE_PVP_RANK_REWARD_HRL).
-define(DB_BASE_PVP_RANK_REWARD_HRL, true).
%% base_pvp_rank_reward => base_pvp_rank_reward
-record(base_pvp_rank_reward, {
          id = 0,                               %% 唯一值
          rank_range = [],                      %% 排名范围
          reward = [],                          %% 排名奖励
          disposable_rank_range = [],           %% pvp排名区间段
          disposable_rank_reward = []           %% pvp区间段位奖励
         }).
-endif.
