%% @doc 战报数据
%% @spec
%% @end
-ifndef(DEFINE_FIGHT_REPORT_HRL).
-define(DEFINE_FIGHT_REPORT_HRL, true).

-include("db_fight_report.hrl").
-include("db_fight_report_info.hrl").

-define(ETS_FIGHT_REPORT, rec_fight_report).
-define(ETS_FIGHT_REPORT_INFO, rec_fight_report_info).

-define(RECENTLY_COUNT, 3). %% 最近通关限制个数

-define(FR_BEST_PASS, 1). %% 最优通关
-define(FR_EARLIEST, 2). %% 最早通关
-define(FR_RECENTLY, 3). %% 最近通关

-define(FR_DUNGEON, 1). %% 普通副本战报
-define(FR_ELITE_DUNGEON, 2). %% 精英副本战报
-define(FR_GUARD_DUNGEON, 3).	%% 守关副本
-define(DEBUG_FR(Format, Args),
    ?DEBUG("Query FR >> " ++ Format, Args)).

-endif.
