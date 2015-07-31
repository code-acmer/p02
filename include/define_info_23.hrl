-ifndef(DEFINE_INFO_23_HRL).
-define(DEFINE_INFO_23_HRL, true).

-include("define_info_0.hrl").


-define(INFO_ARENA_ERROR_RANK_INFO,        23000).   %% 排行榜信息错误
-define(INFO_ARENA_SERVER_ERROR,           23001).   %% 排行榜进程错误
-define(INFO_ARENA_CHALLENGE_TIMES_LIMIT,  23002).   %% 挑战次数已用光
-define(INFO_ARENA_BUY_TIMES_LIMIT,  23003).   %% 可购买的次数已用光

-define(INFO_CHALLENGE_NOT_TIME, 23500).  %%没有在挑战时间内
-define(INFO_CHALLENGE_SELF_BUSY, 23501). %%你正在战斗中，请稍后重试
-define(INFO_CHALLENGE_TAR_BUSY, 23502).  %%目标正在和别人挑战，请稍后重试
-define(INFO_CHALLENGE_NOT_FOUND,    23503).   %% 未找到挑战信息
-define(INFO_PVP_ISLAND_NOT_FOUND,    23504).   %% 攻击的海岛信息未找到
-define(INFO_CANT_ATTACK_SELF,        23505).   %% 不能攻击已经占领的海岛
-define(INFO_CANT_RESET_SELF_ISLAND,  23506).   %% 不能替换自己的海岛
-define(INFO_ISLAND_OCCUPY_TIME_NOT_ENOUGH, 23507). %% 占领时间不够长

-endif.

