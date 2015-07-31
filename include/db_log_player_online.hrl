%% Warning:本文件由make_record自动生成，请不要手动修改
-ifndef(DB_LOG_PLAYER_ONLINE_HRL).
-define(DB_LOG_PLAYER_ONLINE_HRL, true).
%% log_player_online => log_player_online
-record(log_player_online, {
          id,                                   %% 
          sn,                                   %% 
          player_id,                            %% 
          accid,                                %% 
          lv = 0,                               %% 
          login_timestamp,                      %% 
          logout_timestamp,                     %% 
          time = 0                              %% 在线时长
         }).
-endif.
