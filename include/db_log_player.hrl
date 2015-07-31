%% Warning:本文件由make_record自动生成，请不要手动修改
-ifndef(DB_LOG_PLAYER_HRL).
-define(DB_LOG_PLAYER_HRL, true).
%% log_player => log_player
-record(log_player, {
          id,                                   %% 
          player_id = 0,                        %% 玩家id
          action = 0,                           %% 0 收入 1 消费
          type = 0,                             %% 货币类型
          num = 0,                              %% 数量
          point_id = 0,                         %% 消费点
          event_id,                             %% 事件
          arg1 = 0,                             %% 参数1
          arg2 = 0,                             %% 参数2
          timestamp                             %% 时间戳
         }).
-endif.
