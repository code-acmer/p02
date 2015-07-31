%% Warning:本文件由make_record自动生成，请不要手动修改
-ifndef(DB_BASE_RATE_HRL).
-define(DB_BASE_RATE_HRL, true).
%% base_rate => base_rate
-record(base_rate, {
          id,                                   %% 
          key,                                  %%  对应活动概率的key
          value                                 %% [{星级，概率}，...]
         }).
-endif.
