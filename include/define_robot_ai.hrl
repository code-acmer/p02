-define(SEND_DELAY, 5000).
-ifndef(DEFINE_ROBOT_HRL).
-define(DEFINE_ROBOT_HRL, true).
-endif.
-define(INFO(Info, Args), ?PRINT(Info, Args)).
%-define(INFO(Info, Args), ok).

-define(THINKING_TIME, 10000).

-define(THINK_WEIGHT, 3000).
-define(WORK_WEIGHT, 7000).

-define(HIGH_BAG_CNT, 30).
