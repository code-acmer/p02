%% Warning:本文件由make_record自动生成，请不要手动修改
-ifndef(DB_BASE_PARAMS_HRL).
-define(DB_BASE_PARAMS_HRL, true).
%% base_params => base_params
-record(base_params, {
          id,                                   %% 参数ID
          name = <<""/utf8>>,                   %% 参数名
          value,                                %% 参数值
          desc                                  %% 描述
         }).
-endif.
