
-ifndef(DEFINE_TAVERN_HRL).
-define(DEFINE_TAVERN_HRL, true).

-include("db_base_tavern.hrl").
-include("db_player_tavern.hrl").
-include("define_trial.hrl").

-define(ETS_BASE_TAVERN, ets_base_tavern).
-define(ETS_PLAYER_TAVERN, ets_player_tavern).

%% @spec 酒馆相关宏定义
-define(DEFAULT_DAILY_FREE_GREEN_TIMES, 3).
%% -define(MAX_DAILY_GREEN_TIMES,         10).
%% -define(MAX_DAILY_BLUE_TIMES,           5).
%% -define(MAX_DAILY_PURPLE_TIMES,         5).
-define(MAX_BLUE_POINT,                 3).
-define(MAX_PURPLE_POINT,               9).

%% @spec 酒馆进酒类型
-define(CHEERS_TYPE_GREEN,              1).
-define(CHEERS_TYPE_BLUE,               2).
-define(CHEERS_TYPE_PURPLE,             3).

%% @spec 酒馆道具id
-define(ITEM_GREEN_WINE_ID,      86000001).
-define(ITEM_BLUE_WINE_ID,       86000002).
-define(ITEM_PURPLE_WINE_ID,     86000003).

%% @spec 默认抽取到的武将，用于任何规则都不匹配的时候的处理
-define(DEFAULT_CHEER_PARTNER_ID, 14010081).

%% @spec 进酒积分值
-define(SCORE_GREEN_WINE,          0).
-define(SCORE_BLUE_WINE,          80).
-define(SCORE_PURPLE_WINE,       400).
-define(SCORE_FOR_FREE,        10000).

%% @spec 元宝进酒的价格
-define(GOLD_COST_GREEN_CHEERS,   10).
-define(GOLD_COST_BLUE_CHEERS,   100).
-define(GOLD_COST_PURPLE_CHEERS, 300).

%% @spec 进酒类型数据
-define(FILTER_TYPE_NORMAL,        0).
-define(FILTER_TYPE_FIRST,         1).
-define(FILTER_TYPE_SCORE,         2).
-define(FILTER_TYPE_VIP_SPECIAL,   3).
-define(FILTER_TYPE_FESTIVAL,      4).
-define(FILTER_TYPE_IGNORE_LV,     100).
-define(FILTER_TYPE_GOLD_COST_v8,  108).
-define(FILTER_TYPE_GOLD_COST_v9,  109).
-define(FILTER_TYPE_GOLD_COST_v10, 110).
-define(FILTER_TYPE_GOLD_COST_v11, 111).
-define(FILTER_TYPE_GOLD_COST_v12, 112).

%% @spec 元宝消耗累积规则
-define(GOLD_COST_RULES, 
        [{8,   10000, ?FILTER_TYPE_GOLD_COST_v8},
         {9,   25000, ?FILTER_TYPE_GOLD_COST_v9},
         {10,  45000, ?FILTER_TYPE_GOLD_COST_v10},
         {11,  70000, ?FILTER_TYPE_GOLD_COST_v11},
         {12, 100000, ?FILTER_TYPE_GOLD_COST_v12}]).

-endif.

