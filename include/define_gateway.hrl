-ifndef(DEFINE_GATEWAY_HRL).
-define(DEFINE_GATEWAY_HRL, true).

-define(ETS_GATEWAY_SERVER, ets_gateway_server).


-define(UNCONNECTED,       0). %% 未连接
-define(CONNECTED,         1). %% 已连接
-define(DISCONNECTED,      2). %% 断开连接

-define(TO_ALL_SERVERS,    0). %% 广播给所有服

%% 网关服务器中的客户端进程 like mod_player
-record(gateway_client, {srv_id,
                         group_id,
                         platform,
                         pid,
                         pid_send,
                         status
                        }).

%% 网关客户端 like robot
-record(gateway_agent, {id,
                        srv_ip,
                        srv_port,
                        group_id,
                        socket,
                        n,
                        status
                       }).

-endif.

