%% Warning:本文件由make_record自动生成，请不要手动修改
-ifndef(DB_BASE_ADVANCE_REWARD_HRL).
-define(DB_BASE_ADVANCE_REWARD_HRL, true).
%% base_advance_reward => base_advance_reward
-record(base_advance_reward, {
          id = 0,                               %% 唯一id
          battle_ability = 0,                   %% 战斗力
          reward = [],                          %% 奖励
          time = 0                              %% 有效时间(小时)
         }).
-endif.
