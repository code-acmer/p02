%% Warning:本文件由make_record自动生成，请不要手动修改
-ifndef(DB_BASE_DUNGEON_MATCH_HRL).
-define(DB_BASE_DUNGEON_MATCH_HRL, true).
%% base_dungeon_match => base_dungeon_match
-record(base_dungeon_match, {
          id = [],                              %% 等级段
          num = 0,                              %% 乱入数量
          float_lv = 0,                         %% 可以浮动的等级(必须在段内)
          float_battle_ability = 0,             %% 可以浮动的战斗力百分比
          min_win_rate = 0,                     %% 组队的最低胜率(百分比)
          high_win_rate = 0                     %% 高胜率(百分比，匹配高战力的条件)
         }).
-endif.
