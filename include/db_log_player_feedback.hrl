%% Warning:本文件由make_record自动生成，请不要手动修改
-ifndef(DB_LOG_PLAYER_FEEDBACK_HRL).
-define(DB_LOG_PLAYER_FEEDBACK_HRL, true).
%% log_player_feedback => log_player_feedback
-record(log_player_feedback, {
          id,                                   %% 
          player_id = 0,                        %% 玩家id
          title,                                %% 文本标题
          content,                              %% 文本
          timestamp                             %% 时间戳
         }).
-endif.
