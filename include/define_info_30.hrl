-ifndef(DEFINE_INFO_30_HRL).
-define(DEFINE_INFO_30_HRL, true).

-include("define_info_0.hrl").


-define(INFO_TASK_FULL,                         30000).   %% 任务已满
-define(INFO_TASK_UNKNOWN_TASK,                 30001).   %% 未找到该任务数据
-define(ERROR_TASK_SYSTEM_ERROR,                30002).   %% 系统错误，无法进行此操作
-define(ERROR_TASK_NOT_EXIST,                   30003).   %% 任务数据不存在，无法进行此操作
-define(ERROR_TASK_ALREADY_ACCEPTED,            30004).   %% 任务已经领取
-define(ERROR_TASK_PLAYER_LV_TOO_LOW,           30005).   %% 等级不足，无法领取
-define(ERROR_TASK_PLAYER_LV_TOO_HIGH,          30006).   %% 等级过高，无法领取
-define(ERROR_TASK_NOT_OPEN_TIME,              30007).   %% 任务还没开放
-define(ERROR_TASK_INVALID_PLAYER_CAREER,       30008).   %% 玩家职业不符，无法领取
-define(ERROR_TASK_PREV_NOT_DELIVERED,          30009).   %% 前置任务还未完成，无法领取
-define(ERROR_TASK_ALREADY_DELIVERED,           30010).   %% 任务已经完成
-define(ERROR_TASK_DAILY_TIMES_OVER,            30011).   %% 日常任务次数已经使用完毕
-define(ERROR_TASK_NO_ENOUGH_CELLS,             30012).   %% 背包空间不足，无法进行此操作
-define(ERROR_TASK_NOT_IN_GUILD,                30013).   %% 未在帮派中，无法进行此操作
-define(ERROR_TASK_NOT_ACCEPTED,                30014).   %% 任务还未领取，无法进行此操作
-define(ERROR_TASK_CONTENT_NOT_DONE,            30015).   %% 任务还未完成，无法进行此操作
-define(ERROR_TASK_NOT_GOODS_TRIGGER_TASK,      30016).   %% 非道具触发类任务，无法进行此操作
-define(ERROR_TASK_CANNOT_ACCEPTED,             30017).   %% 任务领取失败
-define(INFO_TASK_CAN_NOT_GIVE_UP,              30018).   %% 任务不能放弃


-endif.

