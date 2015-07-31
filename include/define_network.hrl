-ifndef(DEFINE_NETWORK_HRL).
-define(DEFINE_NETWORK_HRL, true).

%%tcp_server监听参数
-define(TCP_OPTIONS, 
        [binary,
         {packet, 0},
         {reuseaddr, true},
         {keepalive, true},
         {backlog,   64},
         {active, false}]
       ).

-define(UDP_OPTIONS,
        [binary,
         {packet, 0},
         {reuseaddr, true},
         {active, false}]).

%% [binary, 
%%  {packet, 0}, 
%%  {active, false}, 
%%  {reuseaddr, true}, 
%%  {nodelay, false}, 
%%  {delay_send, true},
%%  {send_timeout, 5000},
%%  {keepalive, false},
%%  {backlog, 64},
%%  {exit_on_close, true}
%% ]).

-define(RECV_TIMEOUT, 5000).

-define(CLIENT_SUP_TCP, tcp_client_sup).
-define(CLIENT_SUP_UDP, udp_client_sup).
-define(MAX_RESTART,    5).
-define(MAX_TIME,      60).

%% 心跳包时间间隔
%% seconds
-define(HEARTBEAT_TICKET_TIME, 24 * 1000).
%% 最大心跳包检测失败次数
-define(HEARTBEAT_MAX_FAIL_TIME, 3).

-endif.

