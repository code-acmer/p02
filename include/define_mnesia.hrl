-ifndef(DEFINE_MNESIA).
-define(DEFINE_MNESIA, true).

-define(RAM,      {ram_copies,  [node()]}).
-define(DISC,     {disc_copies, [node()]}).

%% -define(RAM,      {copy_type, ram}).
%% -define(DISC,     {copy_type, disc}).

%% table宏定义
-define(
   TABLE_DEF(Name, Type, Copies, Fields),
   {Name, [Copies, {type, Type}, {attributes, Fields}]}).
-define(
   TABLE_DEF(Name, Type, Copies, RecordName, Fields),
   {Name, 
    [Copies, {type, Type}, {record_name, RecordName}, {attributes, Fields}]}).

-record(player_count, {type, counter}).

-record(counter, {
          type,
          counter}).

-record(node_status, {node,
                      ip,
                      port,
                      is_close = 0,
                      num      = 0
                     }).

-record(server_config, {k,
                        version = server_config_version:current_version(),
                        v
                        }).

-define(STARTER_PLAYER,       100000000).
-define(STARTER_SOUL,         100000000).
-define(STARTER_GOODS,        1).

-define(WORLD_BOSS_LV, world_boss_lv).
-define(WORLD_BOSS_STATE_NORMAL, 0).
-define(WORLD_BOSS_STATE_WIN, 1).
-define(WORLD_BOSS_STATE_FAIL, 2).

%%定义一些server_config的key，防止冲突
-define(CROSS_PVP_TIME_STATUS, cross_pvp_time_status).
-define(CROSS_PVP_ROUND, cross_pvp_round).
-define(CROSS_PVP_TEAM_COUNT, cross_pvp_team_count).
-define(CROSS_PVP_MIN_TEAM_NUM, cross_pvp_min_team_num). %%队伍的号码范围
-define(CROSS_PVP_MAX_TEAM_NUM, cross_pvp_max_team_num).

-define(N_FRAGMENTS, 2).

-define(N_FRAGMENTS_16, 2).
-define(N_FRAGMENTS_32, 2).
-define(N_FRAGMENTS_64, 2).

-endif.

