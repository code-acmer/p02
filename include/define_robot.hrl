-ifndef(DEFINE_ROBOT_HRL).
-define(DEFINE_ROBOT_HRL, true).

-include("pb_10_pb.hrl").
-include("pb_15_pb.hrl").
-include("pb_11_pb.hrl").
-include("pb_12_pb.hrl").
-include("pb_13_pb.hrl").
-include("pb_17_pb.hrl").
-include("pb_55_pb.hrl").
-include("pb_9_pb.hrl").
-include("pb_23_pb.hrl").
-include("pb_14_pb.hrl").
-include("pb_34_pb.hrl").
-include("pb_19_pb.hrl").
-include("pb_16_pb.hrl").
-include("pb_44_pb.hrl").
-include("pb_30_pb.hrl").
-include("pb_40_pb.hrl").

%% -include("define_combat.hrl").
-include("db_base_protocol.hrl").
-include("db_base_error_list.hrl").
-include("define_info_0.hrl").
-include("define_info_45.hrl").
-include("define_info_15.hrl").
-include_lib("leshu_db/include/leshu_db.hrl").
-include("define_logger.hrl").
-include("define_dungeon.hrl").
-include("db_base_dungeon_create_portal.hrl").
-include("define_goods.hrl").
-include("define_player.hrl").
-include("db_base_combat_skill.hrl").

-include("define_ct_robot.hrl").
-include("define_robot_ai.hrl").

-define(ROBOT, new_robot).

-record(state, {orig_n,
                accname,
                acc_passwd,
                accid,  %% account id
                socket, %% socket
                pid,    %% process id
                player_id = 123456789,  %% id
                sn=1,
                session = 1766295442,
                last_msg = [],
                last_send = [],
                server_ip = "127.0.0.1",
                port = 8801,
                connect_type = 0  %连接服务器类型，1表示正常，-1表示异常，0 是初始值
               }).

-define(ETS_BASE_PROTOCOL, ets_base_protocol).                  %% 协议信息
-define(ETS_ERROR_LIST, ets_error_list).

-endif.

-ifdef(DEBUG).
-undef(DEBUG).
-define(DEBUG(Format, Args),
        logger:debug_msg(?MODULE, ?LINE, Format, Args)).
-endif.

-ifdef(INFO_MSG).
-undef(INFO_MSG ).
-define(INFO_MSG(Format, Args),
        logger:info_msg(?MODULE, ?LINE, Format, Args)).
-endif.

-ifdef(WARNING_MSG).
-undef(WARNING_MSG).
-define(WARNING_MSG(Format, Args),
        logger:warning_msg(?MODULE, ?LINE, Format, Args)).
-endif.

-ifdef(ERROR_MSG).
-undef(ERROR_MSG).
-define(ERROR_MSG(Format, Args),
        logger:error_msg(?MODULE, ?LINE, Format, Args)).
-endif.

