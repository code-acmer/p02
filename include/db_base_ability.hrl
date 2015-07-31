%% Warning:本文件由make_record自动生成，请不要手动修改
-ifndef(DB_BASE_ABILITY_HRL).
-define(DB_BASE_ABILITY_HRL, true).
%% base_ability => base_ability
-record(base_ability, {
          id = 0,                               %% 唯一id
          ability = []                          %% 战斗力区间
         }).
-endif.
