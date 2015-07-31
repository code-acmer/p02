-ifndef(DEFINE_CROSS_PVP_HRL).
-define(DEFINE_CROSS_PVP_HRL, true).

-define(SIGN_END_TIME, {21, 0}). %%报名结束时间(时分)
-define(SIGN_BEGIN_TIME, {22, 0}). %%报名开始时间(算第二天的)

-define(CHALLENGE_BEGIN, {21, 30}). %%比赛开始时间
-define(CHALLENGE_END, {21, 0}). %%比赛结束时间

-define(TOP_NUM, 10).  %%前10名玩家做特殊处理
-define(MIN_SIGN_NUM, 10).  %%最少报名人数
-define(EVERY_TEAM_NUM, 10). %%每一组的人数
-define(MIN_KEEP_TEAM_NUM, ?EVERY_TEAM_NUM div 2).
-define(MIN_MERGE_TEAM_NUM, ?EVERY_TEAM_NUM div 5).

-define(CHALLENGE_PVP_WIN, 1).
-define(CHALLENGE_PVP_FAIL, 2).
-define(AUTO_CHALLENGE_TIME, 60*5). %%多久之后就会自动战斗/秒

-define(AUTO_ADD_SCORE, 3600). %%多久之后就会自动战斗/秒

-define(SIGN_UP_MIN_LV, 10).  %%报名最小等级
-define(PVP_NOT_OPEN, 0). %%PVP由于特殊原因不开
-define(PVP_OPEN, 1). %%PVP开启
-define(PVP_FRIEND_CHALLENGE_COUNT, 1).  %%需要打几次才能是基友关系

-define(WIN_REWARD, [{1,10}]).
-define(FAIL_REWARD, [{1,1}]).

-define(PVP_HISTORY_MAX_SIZE, 10).
-define(DEFAULT_LEFT_TIMES, 10).

-define(TEAM_TYPE_NORMAL, 1). %%常规组
-define(TEAM_TYPE_JUNIOR, 2). %%新手组
-define(TEAM_TYPE_OLD_PLAYER, 3). %%老玩家组

%%实力相当的战力范围
-define(ABILITY_FLOW_LOW, 0.8).
-define(ABILITY_FLOW_HIGH, 1.2).

-define(IS_PLAYER_0, 0).
-define(IS_ROBOT_1, 1).
-define(IS_NPC_2,   2).   %% NPC 类型
-define(ABILITY_LIST, [{2000,8000}, {8001,20000}, {20001,25000},
                       {25001,30000}, {30001,35000}, {35001,40000},
                       {40001,50000}, {50001,70000}, {70001,1000000}]).

%%注意： 这个可能需要手动升级
%% -record(cross_pvp_sign, {player_id   = 0,
%%                          version     = cross_pvp_sign_version:current_version(),
%%                          name        = "",
%%                          group       = 0,     %% 战斗力分组
%%                          career      = 1,
%%                          lv          = 0,
%%                          sn          = 1,
%%                          ability     = 0
%%                         }).

%% -record(cross_pvp_team, {player_id = 0,
%%                          version = cross_pvp_team_version:current_version(),
%%                          name = "",
%%                          career = 1,
%%                          lv = 0,
%%                          sn = 1,
%%                          battle_ability = 0,
%%                          team_num = 0, %%分组的编号
%%                          left_times = 0,
%%                          win_times = 0,
%%                          fail_times = 0,
%%                          enemy = [],
%%                          buy_times = 0,
%%                          rank = 0,
%%                          robot_id = 0,
%%                          is_robot = 0,
%%                          score = 0
%%                         }).


%% 每个人有各自的 Island
-record(cross_pvp_fighter, {player_id      = 0,
                            version        = cross_pvp_fighter_version:current_version(),
                            player_name    = "",
                            player_career  = 0,
                            player_lv      = 0,
                            player_sn      = 0,
                            player_ability = 0,
                            group          = 0,
                            timestamp      = 0,     %% 最后更新时间截
                            event_timestamp = 0,    %% 事件触发时间截
                            times          = 0,
                            buy_times      = 0,
                            islands        = [],
                            records        = []   %% 只保存与玩家有交互记录信息
                           }).

-record(cross_pvp_island, {id          = 0,
                           version            = cross_pvp_island_version:current_version(),
                           occupy_id          = 0,
                           occupy_name        = "",
                           occupy_career      = 1,
                           occupy_lv          = 0,
                           occupy_sn          = 1,
                           occupy_ability     = 0,
                           occupy_robot       = 0,
                           occupy_time        = 0,
                           calc_timestamp     = 0,     %% 资源结算时间截
                           is_enemy           = 0      %% 宿敌标记
                          }).
-define(MAX_RECORD_CNT,     10).
-record(cross_pvp_record,  {id          = 0,
                            version     = cross_pvp_record_version:current_version(),
                            timestamp   = 0,
                            atk_id      = 0,
                            atk_name    = 0,
                            def_id      = 0,
                            def_name    = 0,
                            result      = 0,
                            score       = 0
                           }).

-record(cross_pvp_event,  {event_type   = 0,
                           id           = 0,
                           name         = "",
                           result       = 0,
                           timestamp    = 0
                          }).

-record(cross_pvp_npc,   {id        = 0,
                          name      = "",
                          ability   = 0   %% 玩家当时战力
                         }).

%% -record(cross_team_player_count, {team_id = 0,
%%                                   version = cross_team_player_count_version:current_version(),
%%                                   num = 0, %%当前组的人数
%%                                   team_type = ?TEAM_TYPE_NORMAL,
%%                                   avg_ability = 0
%%                                  }).

%% -record(cross_pvp_history, {id = 0,
%%                             version = cross_pvp_history_version:current_version(),
%%                             player_id = 0,
%%                             rank = 0,
%%                             round = 0,
%%                             timestamp = 0}).

%% -record(cross_pvp_friend, {player_id = 0,
%%                            version = cross_pvp_friend_version:current_version(),
%%                            friend_list = []   %%既然说要做几次的限制，那结构就变成{id,次数}这样
%%                           }).

-define(PVP_ENEMY_STATUS_ACTIVE,       0).
-define(PVP_ENEMY_STATUS_DEACTIVE,     1).

%% 宿敌 结构{ 玩家id小, 玩家id大 }的在前面，组成key
-record(cross_pvp_enemy, {key       = 0,
                          version   = cross_pvp_enemy_version:current_version(),
                          atk_id    = 0,
                          def_id    = 0,
                          atk_wins  = 0,
                          def_wins  = 0,
                          status    = 0    %% 宿敌关系状态
                         }).

-define(PVP_DEFAULT_TIMES,         20).   %% 初始挑战次数
-define(PVP_DEFAULT_ISLAND_CNT,     6).   %% 玩家初始岛数量
-define(PVP_MAX_ISLANDS_CNT,       15).   %% 每个玩家的岛数量

-define(ENEMY_FLAG_TRUE,           1).
-define(ENEMY_FLAG_FALSE,          0).

-endif.
