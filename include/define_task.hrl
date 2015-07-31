-ifndef(DEFINE_TASK_HRL).
-define(DEFINE_TASK_HRL,true).

-include("db_base_task.hrl").

-define(CIRCLE_TYPE_NORMAL,         1).
-define(CIRCLE_TYPE_DAY,            2).
-define(CIRCLE_TYPE_WEEK,           3).
-define(CIRCLE_TYPE_MONTH,          4).
-define(CIRCLE_TYPE_BEGIN_END,      5).

%%任务类型
-define(TASK_TYPE_MAIN,        1).  %%主线
-define(TASK_TYPE_DAILY,       2).  %%日常
-define(TASK_TYPE_ACTIVITY,    3).  %%活动
-define(TASK_TYPE_ACHIEVE,     4).  %%成就

%%任务条件
-define(TASK_DUNGEON,               1). %%副本任务
-define(TASK_MONSTER,               2). %%杀怪
-define(TASK_FUNTION,               3). %%功能性
-define(TASK_LV,                    4). %%等级
-define(TASK_GOODS,                 5). %%获得物品
-define(TASK_DUNGEON_AREA,          6). %%通关副本区域
-define(TASK_MUGEN,                 7). %%爬塔到N层
-define(TASK_FRIEND,                8). %%加好友
-define(TASK_HAS_GOODS,             9). %%拥有N个XX的物品  这类不会抛事件，只能等客户端算
-define(TASK_SKILL,                10). %%XX技能的XX等级到达XXX
-define(TASK_BATTLE,               11). %%战斗技巧
-define(TASK_ARENA,                12). %%竞技场挑战 {12, type, num}
-define(TASK_SUPER_BATTLE,         13). %%公平竞技到N层
-define(TASK_TEAM_DUNGEON,         14). %%组队副本通关N次 
%%任务功能id
-define(TASK_FUNTION_GOODS_STRENGTH, 1).
-define(TASK_FUNTION_GOODS_ADD_STAR, 2).
-define(TASK_FUNTION_SKILL_UPGRADE,  3).
-define(TASK_FUNTION_SKILL_STRENGTH, 4).
-define(TASK_FUNTION_COMPOSE_JEWEL,  5).  %%宝石合成
-define(TASK_FUNTION_BUY_VIGOR,      6).  %%购买体力
-define(TASK_FUNTION_COST_GOLD,      7).  %%消耗钻石
-define(TASK_FUNTION_COIN_LOTTERY,   8).  %%金币抽奖
-define(TASK_FUNTION_GOLD_LOTTERY,   9).  %%钻石抽奖
-define(TASK_FUNTION_SKILL_CARD_UP,  10). %%技能卡升级

-define(TASK_HAS_GOODS_TYPE_NORMAL, 0). %%NONE
-define(TASK_HAS_GOODS_TYPE_STR,    1). %%强化等级
-define(TASK_HAS_GOODS_TYPE_STAR,   2). %%星级

-define(TASK_SKILL_TYPE_STR,            2). %%强化
-define(TASK_SKILL_TYPE_LUP,            1). %%升级

-define(TASK_ARENA_NORMAL, 1).   %%竞技场
-define(TASK_ARENA_CROSS, 2).   %%跨服竞技场

-define(TASK_CAN_GIVE_UP,    1).

-define(TASK_DONE,           1).  %%任务完成
-define(TASK_NOT_DONE,       0).  %%任务未完成
-define(TASK_RECEIVE_REWARD, 2).  %%已领奖

%% -define(MONTH_CARD_TASK_ID,  2222222).

-record(task, {id = 0,
               version = task_version:current_version(),
               task_id = 0,
               player_id = 0,
               type = 0,
               subtype = 0,
               schedule = 0, %%完成进度
               state = ?TASK_NOT_DONE,    %%1是完成
               last_op = 0,
               is_dirty = 0 
              }).
%%任务链要在这里开始
-define(ALL_LINK_TASK_BEGIN_ID, [1000001, 1010001, 1020001, 4000001, 4000101, 4000201, 4000301, 4000401,
                                 4000901, 4001001, 4001101, 4001201, 4001301, 4001501, 4000501, 4000601,
                                 6030105]).
%% -define(SKILL_LINK_YAGAMI, 4000701).
%% -define(SKILL_LINK_MAI,    4000801).
-endif.
