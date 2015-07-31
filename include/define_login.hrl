-ifndef(DEFINE_LOGIN_HRL).
-define(DEFINE_LOGIN_HRL, true).

-include("define_server.hrl").
-include("define_logger.hrl").
-include("db_log_login.hrl").

-define(PORT_HTTP_DELTA,  10000).

-define(ETS_WHITE_IP, ets_white_ip).

-define(LOGIN_FAILED,         0).
-define(LOGIN_SUCCESS,        1).
-define(LOGIN_FAILED_TIMEOUT, 2).
-define(LOGIN_FAILED_DENY,    3).

-define(LoginDebug(Format, Args),
        ?DEBUG("LoginDebug : " ++ Format, Args)).

%-define(SESSION_TIMEOUT, 20).
-define(SESSION_TIMEOUT, 3600).

-define(SESSION_INVALID,   1).
-define(SESSION_NULL,      2).

%% socket接收进程状态
-record(client, 
        {player_pid  = undefined,
         player_id   = 0,
         login       = 0,
         accid       = 0,
         accname     = undefined,
         %% srv_id      = 0,
         %% srv_pid     = undefined,
         %% srv_groupid = 0,
         timeout     = 0,   %% 超时次数
         sn          = 1,   %% 服务器号
         socket      = 0,
         addr,
         session,
         session_timestamp,
         rc4         = undefined,   %% RC4 密钥
         p           = undefined,   %% 
         g           = undefined,   %%
         rc_priv     = undefined,
         rc_pub      = undefined,
         rc_s        = undefined,
         c_rc_pub    = undefined,
         device_id,                 %% 设备编号
         client_pid,
         active_timestamp = 0,
         player_list = []
        }).

-define(TYPE_ROLE_CREATE, 1).
-define(TYPE_LOGIN,       2).

-define(MAX_ROLE_NUM, 4).

-endif.

