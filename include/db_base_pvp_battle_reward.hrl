%% Warning:本文件由make_record自动生成，请不要手动修改
-ifndef(DB_BASE_PVP_BATTLE_REWARD_HRL).
-define(DB_BASE_PVP_BATTLE_REWARD_HRL, true).
%% base_pvp_battle_reward => base_pvp_battle_reward
-record(base_pvp_battle_reward, {
          id = 0,                               %% 唯一值
          rank_range = [],                      %% 排名范围
          win_reward = [],                      %% 胜利奖励
          lose_reward = []                      %% 失败奖励
         }).
-endif.
