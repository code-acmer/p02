-ifndef(REWARD_HRL).
-define(REWARD_HRL, true).

-include("define_goods.hrl").
-include("db_base_rank_reward.hrl").

-define(RANDOM_BASE,   10000).

-define(COMMON_REWARD_TYPE_FIX,             0).   %% 固定奖励
-define(COMMON_REWARD_TYPE_RATE,            1).   %% 独立随机
-define(COMMON_REWARD_TYPE_POWER_RATE,      2).   %% 权值随机

-record(common_reward,
        {type            = 0,                 %% 0-固定奖励，1-随机奖励
         rate            = 0,                 %% 概率值
         goods_id        = 0,                 %% 物品ID，数值类型ID
         goods_sum       = 0,                 %% 物品数量
         bind            = 0,                 %% 绑定
         float           = 0,                 %% 浮动值
         value3          = 0                  %% 预留字段3
        }).

%% 副本奖励的每一项
-record(reward_item,
        {
          id		= 0,	%%奖励编号
          goods_id	= 3,	%%奖励种类，1为元宝，3为铜钱，6龙魄 ... 80+为普通物品
          num           = 100,	%%奖励数目
          bind          = ?GOODS_BOUND,     %%奖励的物品id
          value1        = 0,    %%普通类型0,特殊类型1
          value2        = 0     %%第几天
         }).

%% @doc 奖励相关宏定义
%% @spec
%% @end
-define(ONLINE_REWARD_TIME_MAX, 15).
-define(LOGIN_REWARD_DAY_MAX,   7).
-define(LOGIN_REWARD_MIN_LV, 13).
-define(LOGIN_REWARD_OPEN_SER, 1).
-define(LOGIN_REWARD_NORMAL, 2).
-define(NEXT_CHECK_IN_DAYS, 6).

-define(LOGIN_GIFT_SPECIAL, 1).
-define(LOGIN_GIFT_NOT_SPECIAL, 0).
-define(LOGIN_GIFT_OPEN_SER_ALL_REC, 254). %% lists:sum([1 bsl X || X <- lists:seq(1, 7)]).

-define(DEBUG_REWARD(Format, Args),
        ?DEBUG("~nDEBUG_REWARD >> " ++ Format, Args)).

-define(GIFT_TYPE_ACTIVITY,     1).
-define(GIFT_TYPE_CODE,         2).
-define(GIFT_TYPE_NO_CODE,      3).

-define(NEW_PLAYER_GIFT_ID,     3).

%% 奖励类型(用于15500协议，弹出奖励信息)
-define(REWARD_TYPE_USE_GIFT, 1).    %% 使用礼包
-define(REWARD_TYPE_DUNGEON, 2).    %% 副本通关奖励
-define(REWARD_TYPE_DUNGEON_FIRST_PASS, 3).%% 副本首次通关奖励
-define(REWARD_TYPE_ASYNC_CHALLENGE, 4).%% 异步PVP挑战奖励
-define(REWARD_TYPE_SEND_LUCKY_COIN, 5).%% 通天塔投币奖励
-define(REWARD_TYPE_RECV_LUCKY_COIN, 6).%% 通天塔别人投币奖励
-define(REWARD_TYPE_SUPER_BATTLE, 7).%% 公平竞技奖励
-define(REWARD_TYPE_CROSS_PVP, 8).%% 跨服竞技场奖励
-define(REWARD_TYPE_CROSS_LEAGUE, 9).%% 公会战奖励
-define(REWARD_TYPE_CROSS_PVP_OCCUPY, 10).%% 跨服竞技场占领奖励

-define(REWARD_CAN_TAKE, 0).
-define(REWARD_HAVE_TAKEN, 1).

%%约定武器都是8位id的
-define(WEAPON_ID_COUNT, 10000000).
%%物品ID div 10000，用前4位判断是不是武器
-define(WEAPON_ID_PART, 10000).

-define(WEAPON_IORIS, 2211).
-define(WEAPON_MAIL, 2212).

-endif.

