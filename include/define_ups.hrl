-ifndef(DEFINE_UPS_HRL).
-define(DEFINE_UPS_HRL, true).
%% 跨服竞技定义文件

-include("db_ups_fighter.hrl").
-include("db_ups_fight_report.hrl").

-define(ETS_UPS_FIGHTER, rec_ups_fighter).
-define(ETS_UPS_FIGHT_REPORT, rec_ups_fight_report).

-define(LV_FUNCTION_UPS,    50).

-define(CYCLE_MEMBER_CNT,   32).

-define(CYCLE_MAX_LOSS_CNT,  3).

-define(PHASE_MIN_WIN_CNT,   2).

-define(PHASE_CYCLE_FIGHT,         0).     %% 淘汰赛
-define(PHASE_CYCLE_FIGHT_END,    10).     %% 淘汰赛结束
-define(PHASE_32_TO_16,            1).     %% 32进16
-define(PHASE_32_TO_16_END,       11).     %% 32进16结束
-define(PHASE_16_TO_8,             2).     %% 16进8
-define(PHASE_16_TO_8_END,        12).     %% 16进8结束
-define(PHASE_8_TO_4,              3).     %% 8进4
-define(PHASE_8_TO_4_END,         13).     %% 8进4结束
-define(PHASE_4_TO_2,              4).     %% 4进2
-define(PHASE_4_TO_2_END,         14).     %% 4进2结束
-define(PHASE_2_TO_1,              5).     %% 2进1
-define(PHASE_2_TO_1_END,         15).     %% 2进1结束
-define(PHASE_1_TO_1,              6).     %% 结果

-endif.
