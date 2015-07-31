%% Warning:本文件由make_record自动生成，请不要手动修改
-ifndef(DB_BASE_DUNGEON_WORLD_BOSS_HRL).
-define(DB_BASE_DUNGEON_WORLD_BOSS_HRL, true).
%% base_dungeon_world_boss => base_dungeon_world_boss
-record(base_dungeon_world_boss, {
          id = 0,                               %% Id
          boss_desc = <<""/utf8>>,              %% 名称
          dungeon_id = 0,                       %% 对应副本ID
          consume = <<""/utf8>>,                %% 召唤消耗
          type = 1,                             %% boss类型
          open_time = <<""/utf8>>,              %% 开启时间
          last_time = 0,                        %% 持续时间
          place_day = 0,                        %% 每天限制次数
          place_hour = 0,                       %% 每小时限制次数
          challengers_place = 0,                %% 最大挑战人数
          summon_reward = <<""/utf8>>,          %% 召唤者奖励
          challengers_reward = <<""/utf8>>,     %% 挑战成功奖励
          open_date = <<""/utf8>>,              %% 开始时间
          close_date = <<""/utf8>>              %% 关闭时间
         }).
-endif.
