
-ifndef(DEFINE_MAIL_HRL).
-define(DEFINE_MAIL_HRL, true).

-include("db_log_mail.hrl").
-include("db_base_mail.hrl").
-include("define_mail_text.hrl").
-include("define_time.hrl").

%% @doc 邮件系统相关宏定义
%% @spec
%% @end
-define(MAIL_TYPE_NORMAL, 1). %% 普通邮件，由游戏各种系统发送
-define(MAIL_TYPE_OPERATORS_DYNAMIC, 2). %% 运营邮件，动态生成

-define(MAIL_STATE_UNREAD,              0). %%邮件未读
-define(MAIL_STATE_READ,                1). %%邮件已读

-define(MAIL_TYPE_SYS,                  1). %%系统邮件
-define(MAIL_TYPE_PLAYER,               2). %%玩家发送邮件

-define(READ_EFFECTIVE_TIME,            (3  * 86400)). %%已读邮件仅保存3天
-define(UNREAD_INVALID_TIME,            (30 * 86400)). %%未读邮件仅保存30天

-define(MAIL_MAX_CAPACITY,              60).  %%发送邮件最大的长度

-define(MAIL_ATTACHMENTS_STATE_UNRECV, 0). %%邮件没领取附件
-define(MAIL_ATTACHMENTS_STATE_RECV, 1). %%邮件领取附件

-define(MAIL_SAVE_TIME_READ, 3*?ONE_DAY_SECONDS). %% 
-define(MAIL_SAVE_TIME_UNREAD, 10*?ONE_DAY_SECONDS). %% 

-record(mails, 
        {	
          id          = 0,                          %% 	邮件ID
          version = mails_version:current_version(),
          player_id   = 0,                          %%  玩家ID
          type        = 0,                          %% 	邮件类型，1普通邮件。2运营邮件
          state       = ?MAIL_STATE_UNREAD,         %% 	0未读，1已读
          timestamp   = 0,                          %% 	发送邮件的时间
          sname       = 0,                          %% 	发送者昵称
          splayer_id  = 0,                          %%  发送者ID
          title       = "",                         %% 	邮件标题
          content     = "",                         %% 	邮件内容
          base_id,                                  %%  邮件base_id
          args = [],                                %%  邮件参数信息
          attachment  = []                          %%  附件
        }).	

%% 运营邮件模板，由运营动态插入
-record(base_operators_mail, {
          id = 0,                                 %%  
          version = base_operators_mail_version:current_version(),
          send_timestamp = 0,                     %%  发送邮件的时间
          begin_timestamp = 0,                    %%  有效期的开始时间
          end_timestamp = 0,                      %%  有效期的结束时间
          min_lv = 0,                             %%  最小等级
          max_lv = 0,                             %%  最大等级
          send_name = 0,                          %%  发送者昵称
          title = <<>>,                           %%  邮件标题
          content = <<>>,                         %%  邮件内容
          attachments = []                        %%  附件 [{base_id, num}] 不使用record，避免结构变更的污染
         }). 

-record(operators_mail, {
          id,
          version = operators_mail_version:current_version(),
          dirty = 1,
          player_id,
          base_id,
          state = ?MAIL_STATE_UNREAD,
          recv_attachments_state = ?MAIL_ATTACHMENTS_STATE_UNRECV
         }).

-define(SYSTEM_ID, 0).
-define(SYSTEM_NAME, <<"管理员"/utf8>>).

-endif.

