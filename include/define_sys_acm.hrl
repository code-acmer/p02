%%
%% 系统公告相关定义
%%
-ifndef(DEFINE_SYS_ACM_HRL).
-define(DEFINE_SYS_ACM_HRL, true).

-include("db_base_sys_acm.hrl").

%% 系统公告
-define(ETS_SYS_ACM,            rec_sys_acm).
-define(ETS_BASE_SYS_ACM,       rec_base_sys_acm).

-define(SYS_ACM_TYPE_RANK,                    1).     %% 军衔等级达到以上
-define(SYS_ACM_TYPE_REFRESH_PASSIVE,         2).     %% 玩家刷出高级被动技能
-define(SYS_ACM_TYPE_RECRUIT,                 3).     %% 获得品级以上的武将
-define(SYS_ACM_TYPE_STRENGTHEN,              4).     %% 装备强化到xx级
-define(SYS_ACM_TYPE_EQUIP_UPGRADE,           5).     %% 装备进阶到xx以上
-define(SYS_ACM_TYPE_EXPLORE,                 6).     %% 寻宝获得xx品级以上的宝物
-define(SYS_ACM_TYPE_ARENA,                   7).     %% 竞技场XX战胜XX排名达到1以内
-define(SYS_ACM_TYPE_KILO_RIDE,               8).     %% 通关层数达到xx层
-define(SYS_ACM_TYPE_FIGHT_SOUL,              9).     %% 获得武魂
-define(SYS_ACM_TYPE_ARENA_RANK,             10).     %% 第一名上线
-define(SYS_ACM_TYPE_KILO_RIDE_RANK,         11).     %% 第一名上线
-define(SYS_ACM_TYPE_ARTIFACT,               12).     %% 炼化等级达到x级
-define(SYS_ACM_TYPE_UPGRADE_SOUL,           13).     %% 将魂升阶

-record(sys_acm_checker, {type      = 0,               %% 检测类型
                          trigger_1 = 0,               %% 触发1
                          trigger_2 = 0,
                          trigger_3 = 0,
                          trigger_4 = 0,
                          trigger_5 = 0,
                          player    = undefined,
                          goods1 = undefined,
                          goods2 = undefined,
                          treasure = undefined,
                          partner    = undefined,
                          args      = []               %% 参数列表 binary | string
                         }).
-endif.
