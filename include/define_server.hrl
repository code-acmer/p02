-ifndef(DEFINE_SERVER_HRL).
-define(DEFINE_SERVER_HRL, true).

-define(RECV_TIMEOUT, 5000).

%% 退出原因
-define(STOP_REASON_NORMAL,            0).  %% 正常退出
-define(STOP_REASON_LOGIN_OTHER,       1).  %% 其它地方登录 
-define(STOP_REASON_KICK_OUT,          2).  %% 被GM踢下线
-define(STOP_ACCOUNT_BAND,             3).  %% 帐号被封 
-define(STOP_ID_CTRL,                  5).  %% 防沉迷强制退出
-define(STOP_REASON_HEART_BREAK,       7).  %% 心跳包异常
-define(STOP_UNKNOW_ERROR,             8).  %% 服务器异常
-define(STOP_SERVER_STOPPING,          9).  %% 服务器关闭 
-define(STOP_SESSION_TIMEOUT,         10).  %% 超过时效

%% 服务器状态
-define(SERVER_STATE_NORMAL, 0).
-define(SERVER_STATE_OUT_OF_SERVICE, 1).
-define(SERVER_STATE_NOT_DUE, 2).

-define(ETS_SERVER,       ets_server).
-define(ETS_SERVER_GET,   ets_server_get).
-define(ETS_SYSTEM_INFO,  ets_system_info).   %% 系统配置信息
-define(ETS_MONITOR_PID,  ets_monitor_pid).   %% 记录监控的PID
-define(ETS_STAT_SOCKET,  ets_stat_socket).    %% Socket送出数据统计(协议号，次数)
-define(ETS_STAT_DB,      ets_stat_db).            %% 数据库访问统计(表名，操作，次数)

-define(ETS_PLAYER_PID,   ets_player_pid).   %% 在线玩家进程

-record(player_pid,       {player_id    = 0,
                           pid          = undefined
                          }).

-define(CROSS_PVP_WORKER_NUM,        20).
-define(COMBAT_ATTRI_WORKER_NUM,        20).

-endif.

