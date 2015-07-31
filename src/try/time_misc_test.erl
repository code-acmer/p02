-module(time_misc_test).
-export([start/0]).

-include("define_logger.hrl").
-include("define_time.hrl").

-define(DAY_START_HOURS,  5).

start() ->
    Now = time_misc:unixtime(),
    io:format(" unixtime : ~p ~n", [Now]),
    io:format(" longunixtime: ~p ~n", [time_misc:longunixtime()]),
    io:format(" YYYYMMDD : ~p ~n", [time_misc:yyyymmdd()]),

    DateTime = time_misc:timestamp_to_datetime(Now),    
    io:format(" timestamp_to_datetime : ~p ~n", [DateTime]),
    Timestamp = time_misc:datetime_to_timestamp(DateTime),
    io:format(" datetime_to_timestamp : ~p ~n", [Timestamp]),
    
    TodayPassSec5 = time_misc:get_today_second_passed(),
    io:format(" get_today_second_passed_5 : ~p ~n", [TodayPassSec5]),
    WeekPassSec = time_misc:get_week_second_passed(),
    io:format(" WeekPassSec : ~p ~n", [WeekPassSec]),
    MonthPassSec = time_misc:get_month_second_passed(),
    io:format(" MonthPassSec : ~p ~n", [MonthPassSec]),
    
    SecToTomorrow5 = time_misc:get_seconds_to_tomorrow(),
    io:format(" SecToTomorrow5 : ~p ~n", [SecToTomorrow5]),
    SecToNextWeek = time_misc:get_seconds_to_next_week(),
    io:format(" SecToNextWeek : ~p ~n", [SecToNextWeek]),
    SecToNextMonth = time_misc:get_seconds_to_next_month(),
    io:format(" SecToNextMonth : ~p ~n", [SecToNextMonth]),
    
    TodayStartTimeStamp5 = time_misc:get_timestamp_of_today_start(),
    io:format(" TodayStartTimeStamp : ~p ~n",[TodayStartTimeStamp5]),
    
    WeekStartTimeStamp = time_misc:get_timestamp_of_week_start(),
    MonthStartTimeStamp = time_misc:get_timestamp_of_month_start(),
    io:format(" WeekStartTimeStamp : ~p datetime : ~p~n", [WeekStartTimeStamp, time_misc:timestamp_to_datetime(WeekStartTimeStamp)]),
    io:format(" MonthStartTimeStamp : ~p datetime : ~p~n", [MonthStartTimeStamp, time_misc:timestamp_to_datetime(MonthStartTimeStamp)]),

    %% WeekDay = time_misc:get_week_day(),
    %% io:format(" Day : ~p ~n", [WeekDay]),
    %% WeekDayTest = time_misc:get_week_day(MonthStartTimeStamp),
    %% io:format(" DayTest : ~p ~n",[WeekDayTest]),
    {{2014,11,1},{5,0,0}} = test_get_calendar_to_month_start({{2014,11,22},{10,10,10}}),
    {{2014,10,1},{5,0,0}} = test_get_calendar_to_month_start({{2014,11,1},{4,59,59}}),
    {{2014,2,1},{5,0,0}}  = test_get_calendar_to_month_start({{2014,3,1},{4,59,59}}),
    {{2013,12,1},{5,0,0}} = test_get_calendar_to_month_start({{2014,1,1},{4,59,59}}),
    {{2014,1,1},{5,0,0}}  = test_get_calendar_to_month_start({{2014,1,1},{5,0,0}}),

    1 = test_get_week_day({{2014,11,24},{12,5,0}}),
    7 = test_get_week_day({{2014,11,24},{4,5,0}}),
    7 = test_get_week_day({{2014,11,23},{12,5,0}}),
    6 = test_get_week_day({{2014,11,23},{4,59,59}}),
    6 = test_get_week_day({{2014,11,22},{5,0,0}}),
    5 = test_get_week_day({{2014,11,22},{4,59,59}}),
    5 = test_get_week_day({{2014,11,21},{5,0,0}}),
    4 = test_get_week_day({{2014,11,21},{4,59,59}}),
    4 = test_get_week_day({{2014,11,20},{5,0,0}}),
    3 = test_get_week_day({{2014,11,20},{4,59,59}}),
    3 = test_get_week_day({{2014,11,19},{5,0,0}}),
    2 = test_get_week_day({{2014,11,19},{4,59,59}}),
    2 = test_get_week_day({{2014,11,18},{5,0,0}}),
    1 = test_get_week_day({{2014,11,18},{4,59,59}}),

    {{2014,11,17},{5,0,0}} = test_week_start({{2014,11,22},{11,3,10}}),
    {{2014,11,10},{5,0,0}} = test_week_start({{2014,11,17},{4,59,59}}),
    {{2014,11,17},{5,0,0}} = test_week_start({{2014,11,17},{5,0,0}}),
    {{2013,12,30},{5,0,0}} = test_week_start({{2014,1,1},{5,0,0}}),
    {{2013,12,30},{5,0,0}} = test_week_start({{2014,1,6},{4,59,59}}),
    {{2014,2,24},{5,0,0}}  = test_week_start({{2014,3,1},{4,59,59}}),
    
    false = test_is_same_day({{2014,11,22},{11,3,10}},  {{2014,11,22},{4,0,0}}),
    true =  test_is_same_day({{2014,11,22},{23,59,59}}, {{2014,11,22},{5,0,0}}),
    false = test_is_same_day({{2014,11,23},{5,0,0}},    {{2014,11,22},{5,0,0}}),
    false = test_is_same_day({{2014,11,24},{4,59,59}},  {{2014,11,25},{4,59,59}}),
    true =  test_is_same_day({{2013,12,31},{5,0,0}},    {{2014,1,1},{4,59,59}}),
    false = test_is_same_day({{2013,12,31},{5,0,0}},    {{2014,1,1},{5,0,0}}),
    
    false = test_is_same_week({{2014,11,17},{4,59,59}}, {{2014,11,17},{5,0,0}}),
    false = test_is_same_week({{2014,11,17},{5,0,0}},   {{2014,11,24},{5,0,0}}),
    true =  test_is_same_week({{2014,11,17},{5,0,0}},   {{2014,11,22},{5,0,0}}),
    false = test_is_same_week({{2014,11,17},{4,59,59}}, {{2014,11,24},{4,59,59}}),
    true  = test_is_same_week({{2014,11,17},{5,0,0}},   {{2014,11,24},{4,59,59}}),
    true =  test_is_same_week({{2013,12,30},{5,0,0}},   {{2014,1,6},{4,59,59}}),
    false = test_is_same_week({{2013,12,30},{5,0,0}},   {{2014,1,6},{5,0,0}}),
    false = test_is_same_week({{2013,12,30},{4,49,49}}, {{2014,1,1},{4,59,59}}),
    %% 同月份
    true  = test_is_same_month({{2014,11,1},{4,59,59}}, {{2014,11,1},{4,59,0}}), %% true
    false = test_is_same_month({{2014,11,1},{4,59,59}}, {{2014,11,1},{5,0,0}}),  %% false
    true =  test_is_same_month({{2014,11,1},{5,0,0}},   {{2014,11,1},{5,1,1}}),  %% true
    false = test_is_same_month({{2014,11,1},{4,59,59}}, {{2014,11,2},{4,59,0}}), %% false
    true =  test_is_same_month({{2014,11,2},{4,59,59}}, {{2014,11,2},{5,59,0}}), %% true
    %% 不同月份
    true =  test_is_same_month({{2014,10,1},{5,0,0}},   {{2014,11,1},{4,59,0}}), %% true
    false = test_is_same_month({{2014,10,1},{4,59,59}}, {{2014,11,1},{4,59,0}}), %% false
    false = test_is_same_month({{2014,10,1},{5,59,59}}, {{2014,11,1},{5,0,0}}),  %% false
    true =  test_is_same_month({{2014,10,2},{4,59,59}}, {{2014,11,1},{4,59,0}}), %% true
    false = test_is_same_month({{2014,10,2},{4,59,59}}, {{2014,11,1},{5,0,0}}),  %% false
    false = test_is_same_month({{2014,10,3},{4,59,59}}, {{2014,11,2},{4,59,0}}), %% false
    %% 不同年
    true =  test_is_same_month({{2013,12,31},{5,0,0}},  {{2014,1,1},{4,0,0}}),   %% true
    false = test_is_same_month({{2013,12,31},{4,59,59}},{{2014,1,1},{5,0,0}}),   %% false
    false = test_is_same_month({{2013,12,31},{4,59,59}},{{2014,1,2},{4,59,0}}),  %% false
    false = test_is_same_month({{2013,12,1},{4,59,59}}, {{2014,1,1},{4,59,0}}),  %% false
    true =  test_is_same_month({{2013,12,1},{5,0,0}},   {{2014,1,1},{4,59,0}}),  %% true
    false = test_is_same_month({{2013,12,1},{5,0,0}},   {{2014,1,1},{5,0,0}}),   %% false
    
    ServerTime = time_misc:get_server_start_time(),
    ServerTime = hmisctime:get_server_start_time(),
    
    TodayPassSec = time_misc:get_today_second_passed(),
    TodayPassSec = hmisctime:get_today_second_passed_new(),
    
    StartTimeStamp = time_misc:get_timestamp_of_today_start(),
    StartTimeStamp = hmisctime:get_timestamp_of_today_start_new(),
    %% io:format("Timestamp  Start1 : ~p, Start2 : ~p ~n", [StartTimeStamp1, StartTimeStamp2]),
    
    TomorrowTimeStamp = time_misc:get_timestamp_of_tomorrow_start(),
    TomorrowTimeStamp = hmisctime:get_timestamp_of_tomorrow_start_new(),
    %io:format("Timestamp  Start1 : ~p, Start2 : ~p ~n", [TomorrowTimeStamp1, TomorrowTimeStamp2]).
    WeekTimeStamp = hmisctime:get_timestamp_of_week_start_new(),
    WeekTimeStamp = time_misc:get_timestamp_of_week_start(),

    MonthTimeStamp = hmisctime:get_timestamp_of_month_start_new(),
    MonthTimeStamp = time_misc:get_timestamp_of_month_start(),
    
    ToTomorrowSec = hmisctime:get_seconds_to_tomorrow_5(),
    ToTomorrowSec = time_misc:get_seconds_to_tomorrow(),
    
    ToNextWeekSec = hmisctime:get_seconds_to_next_week(),
    ToNextWeekSec = time_misc:get_seconds_to_next_week(),
    ok.    

test_get_calendar_to_month_start(Date) ->
    {{Year, Month, Day}, {Hours, _Min, _Sec}} = time_misc:timestamp_to_datetime(
                                                  time_misc:datetime_to_timestamp(Date)
                                                 ),
    case Day =:= 1 of 
        false ->
            {{Year, Month, 1}, {?DAY_START_HOURS, 0, 0}};
        true ->
            case Hours >= ?DAY_START_HOURS of
                true ->
                    {{Year, Month, 1}, {?DAY_START_HOURS, 0, 0}};
                false ->
                    case Month =:= 1 of
                        false ->
                            {{Year, Month-1, 1}, {?DAY_START_HOURS, 0, 0}};
                        true ->
                            {{Year-1, 12, 1}, {?DAY_START_HOURS, 0, 0}}
                    end
            end
    end.

test_get_week_day(Date)->
    Timestamp = time_misc:datetime_to_timestamp(Date),
    time_misc:get_week_day(Timestamp).
    
test_week_start(Date)->
    Datestamp = time_misc:datetime_to_timestamp(Date),
    Timestamp = time_misc:get_timestamp_of_week_start(Datestamp),
    time_misc:timestamp_to_datetime(Timestamp).

test_is_same_day(Date1, Date2) ->
    test_is_same_day1(time_misc:datetime_to_timestamp(Date1),
                      time_misc:datetime_to_timestamp(Date2)).
test_is_same_day1(Time1, Time2) ->
    %% io:format(" time1 ~p time2 ~p is_same_day : ~p ~n", 
    %%           [time_misc:timestamp_to_datetime(Time1), 
    %%            time_misc:timestamp_to_datetime(Time2), 
    %%            time_misc:is_same_day(Time1, Time2)
    %%           ]).
    time_misc:is_same_day(Time1, Time2).

test_is_same_week(Date1, Date2) ->
    test_is_same_week1(time_misc:datetime_to_timestamp(Date1), 
                       time_misc:datetime_to_timestamp(Date2)).
test_is_same_week1(Time1, Time2) ->
    %% io:format(" time1 ~p time2 ~p is_same_week : ~p ~n", 
    %%           [time_misc:timestamp_to_datetime(Time1), 
    %%            time_misc:timestamp_to_datetime(Time2), 
    %%            time_misc:is_same_week(Time1, Time2)
    %%           ]).
    time_misc:is_same_week(Time1, Time2).

test_is_same_month(Date1, Date2) ->
    test_is_same_month1(time_misc:datetime_to_timestamp(Date1), 
                        time_misc:datetime_to_timestamp(Date2)).
test_is_same_month1(Time1, Time2) ->
    %% io:format(" time1 ~p time2 ~p is_same_month : ~p ~n", 
    %%           [time_misc:timestamp_to_datetime(Time1), 
    %%            time_misc:timestamp_to_datetime(Time2), 
    %%            time_misc:is_same_month(Time1, Time2)
    %%           ]).
    time_misc:is_same_month(Time1, Time2).
