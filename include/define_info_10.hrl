-ifndef(DEFINE_INFO_10_HRL).
-define(DEFINE_INFO_10_HRL, true).

-include("define_info_0.hrl").


-define(INFO_LOGIN_LOGIN_SUCCESS,               10000).   %% 登录成功
-define(INFO_LOGIN_LOGIN_FAILED,                10001).   %% 登录失败
-define(INFO_LOGIN_LOGIN_TIME_OUT,              10002).   %% 登录超时，无法进入游戏
-define(INFO_LOGIN_NOT_SERVER_TIME,             10003).   %% 服务器尚未开启
-define(INFO_LOGIN_ACCID_FAIL,                  10004).   %% 帐号认证失败
-define(INFO_LOGIN_SERVER_ON_UPDATE,            10005).   %% 服务器正在维护,请留意开服时间
-define(INFO_LOGIN_SERVER_ERROR_ID,             10006).   %% 服务器号发生错误
-define(INFO_LOGIN_ROLE_NOT_EXIST,              10007).   %% 角色不存在
-define(INFO_LOGIN_ROLE_NUM_LIMIT,              10008).   %% 帐号角色达到上限
-define(INFO_LOGIN_CREATE_ROLE_SUCCESS,         10010).   %% 创建角色成功
-define(INFO_LOGIN_CREATE_ROLE_FAILED,          10011).   %% 创建角色失败
-define(INFO_LOGIN_USED_NAME,                   10012).   %% 角色名已经被使用
-define(INFO_LOGIN_INVALID_NAME,                10013).   %% 角色名包含非法字符，无法使用
-define(INFO_LOGIN_INVALID_LENGTH,              10014).   %% 角色名长度需要为 6 - 12 个字符
-define(INFO_LOGIN_ROLE_EXIST,                  10015).   %% 已经创建过角色，无法再创建
-define(INFO_LOGIN_ROLE_MAX,                    10016).   %% 同账号角色已经达到2个，无法再创建
-define(INFO_LOGIN_BAN_WORDS,                   10017).   %% 角色名包含敏感词，无法使用
-define(INFO_LOGIN_ACCOUNT_NOT_EXIST,           10018).   %% 账号不存在


-endif.

