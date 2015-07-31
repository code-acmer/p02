%% Warning:本文件由make_record自动生成，请不要手动修改
-ifndef(DB_BASE_SKILL_EXP_HRL).
-define(DB_BASE_SKILL_EXP_HRL, true).
%% base_skill_exp => base_skill_exp
-record(base_skill_exp, {
          id = 0,                               %% id
          lv = 0,                               %% 等级
          exp_curr = 0,                         %% 升到下一级经验
          exp_all = 0                           %% 等级对应的最大经验
         }).
-endif.
