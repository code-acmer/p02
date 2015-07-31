%% Warning:本文件由make_record自动生成，请不要手动修改
-ifndef(DB_LOG_PLAYER_CREATE_HRL).
-define(DB_LOG_PLAYER_CREATE_HRL, true).
%% log_player_create => log_player_create
-record(log_player_create, {
          id,                                   %% 
          sn,                                   %% 
          player_id,                            %% 
          accid,                                %% 
          device_id,                            %% 
          create_timestamp = 0                  %% 
         }).
-endif.
