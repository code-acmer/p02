%% Warning:本文件由make_record自动生成，请不要手动修改
-ifndef(DB_LOG_MAIL_HRL).
-define(DB_LOG_MAIL_HRL, true).
%% log_mail => ets_log_mail
-record(ets_log_mail, {
          id,                                   %% 自增id
          player_id = 0,                        %% 玩家ID
          mail_id,                              %% 邮件ID
          type = 0,                             %% 操作类型1发送邮件，2领取附件
          time = 0,                             %% 玩家id
          attachment                            %% 
         }).
-endif.
