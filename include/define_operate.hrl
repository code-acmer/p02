
%% 操作数据的宏定义

-ifndef(DEFINE_OPERATE_HRL).
-define(DEFINE_OPERATE_HRL, true).

%% 微冷却操作，用于一些更细小的事件
-define(OPERATE_COOLDOWN_TINY, {operate_cooldown_tiny, 1}).
%% 小冷却操作，用于包裹整理等事件
-define(OPERATE_COOLDOWN_MINOR, {operate_cooldown_minor, 3}).
%% 大冷却操作，用于战斗等事件
-define(OPERATE_COOLDOWN_HUGE,  {operate_cooldown_huge, 15}).
%% 战斗CD冷却操作，用于战斗等事件
-define(OPERATE_COOLDOWN_COMBAT, {operate_cooldown_combat, 3}).

%% -define(OPERATE_TIME_DELTA_MINOR,  3).
%% -define(OPERATE_TIME_DELTA_HUGE,  15).

%% -define(OPERATE_TIME_DELTA_COMBAT, 3).

-endif.

