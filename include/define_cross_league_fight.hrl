-ifndef(DEFINE_CROSS_LEAGUE_FIGHT).
-define(DEFINE_CROSS_LEAGUE_FIGHT, true).

-define(FIGHT_STATUS_NOTJOIN,      0).   %% 未报名
-define(FIGHT_STATUS_APPLYED,      1).   %% 已报名
-define(FIGHT_STATUS_READY,        2).   %% 等待开始
-define(FIGHT_STATUS_EMPTY,        3).   %% 轮空
-define(FIGHT_STATUS_RUINNG,       4).   %% 正在进行中
-define(FIGHT_STATUS_ENDING,       5).   %% 正在结算中
-define(FIGHT_STATUS_CLOSED,       6).   %% 已关闭

%% -define(APPLY_STATUS, 1). %% 报名等待
%% -define(NOT_ENEMY_STATUS, 2). %% 轮空等待
%% -define(IN_FIGHT_STATUS, 3). %% 处于战斗中
%% -define(WRITH_FIGHT_STATUS, 4). %% 处于战斗等待中
%% -define(NO_FIGHT_STATUS, 5). %% 不在战斗期间内
%% -define(NO_APPLY_STATUS, 6). %% 没有报名

-record(league_fight_state, {worker_id = 0,
                             status    = 0
                            }).

-define(GROUP_MAX,       9). %% 最大值
-define(GROUP_EXTREME,   9). %% 至尊组
-define(GROUP_MASTER,    8). %% 大师组
-define(GROUP_GOLD,      7). %% 钻石组
-define(GROUP_PLATINUM,  6). %% 白金组
-define(GROUP_AURUM,     5). %% 黄金组
-define(GROUP_SILVER,    4). %% 白银组
-define(GROUP_STEEL,     3). %% 赤钢组
-define(GROUP_FERRUM,    2). %% 黑铁组
-define(GROUP_BRONZE,    1). %% 青铜组


-record(fight_league, {league_id, 
                       version         = fight_league_version:current_version(),
                       group           = ?GROUP_BRONZE, %% 我方所在段位
                       league_name     = "",                       
                       sn              = 0, %% 我方所在服
                       score           = 0, %% 我方公会积分
                       ability_sum     = 0,  %% 我方总战斗力
                       lv              = 0, %% 我方公会等级
                       cur_num         = 0,   %% 我方当前人数
                       max_num         = 0,   %% 我方公会人数上限
                       win_cnt         = 0,
                       loss_cnt        = 0,
                       rank            = 0, %% 我方在青铜段排名,或其它
                       things          = 0, %% 我方公会物资
                       defend_points   = [], %% 据点情况
                       occupy_points   = 0, %% 占领据点数量
                       atk_times       = 0, %% 总挑战次数
                       enemy_league_id = 0, %% 敌方公会Id
                       enemy_league_name = "",
                       enemy_league_sn = 0, %% 敌方所在服
                       apply_time = 0 %% 报名时间
                      }).

-record(fight_league_copy, 
                      {league_id, 
                       version         = 0,
                       group           = 0, %% 我方所在段位
                       league_name     = "",                       
                       sn              = 0, %% 我方所在服
                       score           = 0, %% 我方公会积分
                       ability_sum     = 0,  %% 我方总战斗力
                       lv              = 0, %% 我方公会等级
                       cur_num         = 0,   %% 我方当前人数
                       max_num         = 0,   %% 我方公会人数上限
                       win_cnt         = 0,
                       loss_cnt        = 0,
                       rank            = 0, %% 我方在青铜段排名,或其它
                       things          = 0, %% 我方公会物资
                       defend_points   = [], %% 据点情况
                       occupy_points   = 0, %% 占领据点数量
                       atk_times       = 0, %% 总挑战次数
                       enemy_league_id = 0, %% 敌方公会Id
                       enemy_league_name = "",
                       enemy_league_sn = 0, %% 敌方所在服
                       apply_time = 0 %% 报名时间
                      }).


-define(DEAFAULT_FIGHT_TIMES,       8).   %% 默认挑战次数
-define(MAX_ATKED_TIMES,            10).

-record(fight_member, {player_id       = 0,    %% 玩家id
                       version         = fight_member_version:current_version(),
                       player_name     = 0,    %% 玩家名
                       player_lv       = 0,
                       player_career   = 0,
                       player_title    = 0,
                       contribute      = 0,
                       contribute_lv   = 0,
                       league_id       = 0,    %% 军团id
                       league_name     = "",   %% 军团名称
                       ability         = 0,    %% 最高战力
                       fight_times     = ?DEAFAULT_FIGHT_TIMES,  %% 挑战次数
                       atk_point_times = 0,    %% 挑战据点次数
                       things          = 0,    %% 抢夺的物资
                       def_records     = [],   %% 被攻击记录
                       atk_records     = []    %% 攻击记录
                      }).

-record(fight_record, {atk_id     = 0,    %% 进攻方
                       atk_name   = "",   %% 
                       def_id     = 0,    %% 防守方
                       def_name   = "",   
                       timestamp  = 0,    %% 时间
                       result     = 0,    %% 结果
                       things     = 0     %% 获取的物资
                      }).

-define(DEFEND_POINT_STATUS_NORMAL,    0).
-define(DEFEND_POINT_STATUS_ATKING,    1).
-define(DEFEND_POINT_STATUS_OCCUPY,    2).
%% 据点结构
-record(defend_point, {id        = 0,
                       pos       = 0,
                       league_id = 0,
                       defenders = [],  %% 防守方信息
                       occupyers = [],  %% 占领者信息
                       records   = [],  %% 攻击记录
                       attacker  = 0,   %% 正在挑战者的id,
                       atk_timestamp = 0, %% 开始挑战的时间
                       status    = ?DEFEND_POINT_STATUS_NORMAL       %% 0 - 正常状态  1 - 正被挑战中 2 - 已经被占据
                      }).

-define(LEAGUE_FIGHT_LAST_DAY,     28).

-record(count_record, {player_id        = 0,
                       player_name      = "",
                       win_times     = 0,
                       loss_times    = 0,
                       points        = 0,
                       things        = 0
                      }).

-endif.
