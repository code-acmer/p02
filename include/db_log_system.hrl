%% Warning:本文件由make_record自动生成，请不要手动修改
-ifndef(DB_LOG_SYSTEM_HRL).
-define(DB_LOG_SYSTEM_HRL, true).
%% log_system => log_system
-record(log_system, {
          id,                                   %% 
          type,                                 %% 
          player_id,                            %% 
          value,                                %% 
          ext_1 = 0,                            %% 
          ext_2 = 0,                            %% 
          ext_3 = 0,                            %% 
          ext_4 = 0,                            %% 
          ext_5 = 0,                            %% 
          timestamp                             %% 
         }).
-endif.
