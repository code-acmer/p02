%% Warning:本文件由make_record自动生成，请不要手动修改
-ifndef(DB_LOG_PLAYER_LOGIN_HRL).
-define(DB_LOG_PLAYER_LOGIN_HRL, true).
%% log_player_login => log_player_login
-record(log_player_login, {
          id,                                   %% 
          player_id,                            %% 
          career = 0,                           %% 
          sn,                                   %% 
          accid = <<""/utf8>>,                  %% 
          device_id,                            %% 
          lv,                                   %% 
          pay_flag,                             %% 
          regist_timestamp,                     %% 
          login_timestamp                       %% 
         }).
-endif.
