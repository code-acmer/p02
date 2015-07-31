%% Warning:本文件由make_record自动生成，请不要手动修改
-ifndef(DB_LOG_PLAYER_CHAT_HRL).
-define(DB_LOG_PLAYER_CHAT_HRL, true).
%% log_player_chat => log_player_chat
-record(log_player_chat, {
          player_id = 0,                        %% 玩家id
          player_chat_msg                       %% 玩家聊天消息
         }).
-endif.
