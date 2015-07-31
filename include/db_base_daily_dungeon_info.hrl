%% Warning:本文件由make_record自动生成，请不要手动修改
-ifndef(DB_BASE_DAILY_DUNGEON_INFO_HRL).
-define(DB_BASE_DAILY_DUNGEON_INFO_HRL, true).
%% base_daily_dungeon_info => base_daily_dungeon_info
-record(base_daily_dungeon_info, {
          id = 0,                               %% 唯一id
          lv = [],                              %% 玩家等级区间
          lv_condition = [],                    %% 随机等级副本
          pass_condition = []                   %% 随机通关条件
         }).
-endif.
