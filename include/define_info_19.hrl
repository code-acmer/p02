-ifndef(DEFINE_INFO_19_HRL).
-define(DEFINE_INFO_19_HRL, true).

-include("define_info_0.hrl").


-define(INFO_MAIL_SEND_SUCCESS,                 19000).   %% 邮件发送成功
-define(INFO_MAIL_SEND_FAILED,                  19001).   %% 邮件发送失败
-define(INFO_MAIL_WRONG_TITLE,                  19002).   %% 标题不合法（非法字符/长度超限），发送失败
-define(INFO_MAIL_WRONG_CONTENT,                19003).   %% 内容不合法（非法字符/长度超限），发送失败
-define(INFO_MAIL_WRONG_RECEIVER,               19004).   %% 无法找到收件人，发送失败
-define(INFO_MAIL_FULL_OF_RECEIVER,             19005).   %% 对方邮箱已满，发送失败
-define(INFO_MAIL_WRONG_ATTATCH_FOR_MULTI_SEND, 19006).   %% 群发邮件不可发送附件
-define(INFO_MAIL_WRONG_ATTATCH,                19007).   %% 错误的附件信息
-define(INFO_MAIL_WRONG_GOODS_TYPE,             19008).   %% 错误的物品信息，获取失败
-define(INFO_MAIL_TOO_FREQUENTLY,               19009).   %% 邮件发送过于频繁，请稍后再试
-define(INFO_MAIL_RECEIVE_SUCCESS,              19010).   %% 邮件获取成功
-define(INFO_MAIL_RECEIVE_FAILED,               19011).   %% 邮件获取失败
-define(INFO_MAIL_DELETE_SUCCESS,               19020).   %% 邮件删除成功
-define(INFO_MAIL_DELETE_FAILED,                19021).   %% 邮件删除失败
-define(INFO_MAIL_ATTATCH_GET_SUCCESS,          19030).   %% 邮件附件获取成功
-define(INFO_MAIL_ATTATCH_GET_FAILED,           19031).   %% 邮件附件获取失败
-define(INFO_MAIL_NOT_FOUND,                    19040).   %% 没有该邮件


-endif.

