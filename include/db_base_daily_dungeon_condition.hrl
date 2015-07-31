%% Warning:本文件由make_record自动生成，请不要手动修改
-ifndef(DB_BASE_DAILY_DUNGEON_CONDITION_HRL).
-define(DB_BASE_DAILY_DUNGEON_CONDITION_HRL, true).
%% base_daily_dungeon_condition => base_daily_dungeon_condition
-record(base_daily_dungeon_condition, {
          id = 0,                               %% 唯一id
          time = 0,                             %% 通关时间/秒
          damage = 0,                           %% 伤害比例
          hurt = 0,                             %% 受伤次数
          combo = 0,                            %% 连击数
          aircombo = 0,                         %% 空中连击数
          skillcancel = 0,                      %% 技能取消次数
          crit = 0                              %% 暴击次数
         }).
-endif.
