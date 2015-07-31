
-ifndef(DEFINE_VIP_HRL).
-define(DEFINE_VIP_HRL, true).

-include("db_base_vip.hrl").

-define(ETS_BASE_VIP, rec_base_vip).

%% 使用元宝进行强化材料补齐功能开放等级
-define(VIP_LEVEL_FOR_DIRECT_FORGE,        5).
%% 使用伙伴跟随功能所需的等级
-define(VIP_LEVEL_FOR_CHANGE_FOLLOWER,     3).

%% vip 最高等级
-define(VIP_MAX_LEVEL, 12).

-endif.

