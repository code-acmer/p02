%% Warning:本文件由make_record自动生成，请不要手动修改
-ifndef(DB_BASE_FUNCTION_OPEN_HRL).
-define(DB_BASE_FUNCTION_OPEN_HRL, true).
%% base_function_open => base_function_open
-record(base_function_open, {
          type = 0,                             %% 开放类型 0 - 角色技能
          req_lv = 0,                           %% 需求等级
          career = 0,                           %% 职业
          open = []                             %% 开放功能
         }).
-endif.
