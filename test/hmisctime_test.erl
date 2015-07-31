-module(hmisctime_test).
-compile(export_all).
-include_lib("eunit/include/eunit.hrl").
%%1398891600    5月1号5点         1398960000    5月2号0点
%%1398873600    5月1号0点         1398978000    5月2号5点
%%1398916800    5月1号12点        1398956400    5月1号23点
%%1398884400    5月1号3点         1399842000    5月12号5点
%%1398895200    5月1号6点         1399824000    5月12号0点
%%1398945600    5月1号20点        1401552000    6.1  0点            1401570000  6.1 5点

start_test()->
    TodayPass = hmisctime:get_today_second_passed_new(),
    ?assertEqual(86400 - TodayPass, hmisctime:get_seconds_to_tomorrow_5()),

    ?assertEqual(1398873600, hmisctime:get_timestamp_of_today_start(1398916800)), %%5月1号12点
    ?assertEqual(1398891600, hmisctime:get_timestamp_of_today_start_new(1398916800)),
    
    ?assertEqual(1398873600, hmisctime:get_timestamp_of_today_start(1398884400)), %%5月1号3点
    ?assertEqual(1398805200, hmisctime:get_timestamp_of_today_start_new(1398884400)),
    
    ?assertEqual(1399842000, hmisctime:get_timestamp_of_week_start_new(1400148000)), %%5月15号18点
    ?assertEqual(1400428800, hmisctime:get_timestamp_of_week_start(1400148000)),

    ?assertEqual(1399237200, hmisctime:get_timestamp_of_week_start_new(1399834800)), %%5月12号3点
    ?assertEqual(1399824000, hmisctime:get_timestamp_of_week_start(1399834800)),

    ?assertEqual(1398873600, hmisctime:get_timestamp_of_month_start(1400148000)),   %%5月15号18点
    ?assertEqual(1398891600, hmisctime:get_timestamp_of_month_start_new(1400148000)),

    ?assertEqual(1396299600, hmisctime:get_timestamp_of_month_start_new(1398884400)), %%5月1号3点
    ?assertEqual(1398873600, hmisctime:get_timestamp_of_month_start(1398884400)),

    ?assertEqual(false, hmisctime:is_same_week_new(1399824000, 1399867200)), %%5月12号12点
    ?assertEqual(true, hmisctime:is_same_week_new(1399842000, 1399867200)),

    ?assertEqual(false, hmisctime:is_same_date_of_5(1398895200, 1398884400)),  %%5月1号3点
    ?assertEqual(true, hmisctime:is_same_date_of_5(1398895200, 1398938400)),

    ?assertEqual(4, hmisctime:get_week_day_new(1398938400)),
    ?assertEqual(3, hmisctime:get_week_day_new(1398884400)).
