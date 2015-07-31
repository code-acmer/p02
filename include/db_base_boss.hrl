%% Warning:本文件由make_record自动生成，请不要手动修改
-ifndef(DB_BASE_BOSS_HRL).
-define(DB_BASE_BOSS_HRL, true).
%% base_boss => base_boss
-record(base_boss, {
          id = 0,                               %% Id
          boss_name = <<"">>,                   %% 名称
          dungeon_id = 0,                       %% 对应副本ID
          consume = <<"">>,                     %% 召唤消耗
          open_time = <<"">>,                   %% 开启时间
          last_time = 0,                        %% 持续时间
          summon_times = 0,                     %% 每天限制召唤次数
          challengers_place = 0,                %% 最大挑战人数
          summon_reward = <<"">>,               %% 召唤者奖励
          challengers_reward = <<"">>,          %% 挑战成功奖励
          challengers_lose_reward = <<"">>,     %% 挑战失败奖励
          count_down = 0                        %% 开启倒计时
         }).
-endif.
