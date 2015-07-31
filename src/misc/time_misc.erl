%%%----------------------------------------------------------------------
%%% File    : misc_timer.erl
%%% Created : 2010-10-17
%%% Description: 时间生成器
%%%----------------------------------------------------------------------
-module(time_misc).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("define_logger.hrl").
-include("define_time.hrl").

%% 动态配置 一天开始的时间点
-define(DAY_START_HOURS, 0).

%% --------------------------------------------------------------------
%% External exports
-export([
         unixtime/0,
         longunixtime/0,
         yyyymmdd/0,
         time_format/1,
         local_hms/0,
         timestamp_to_datetime/1,
         datetime_to_timestamp/1,
         datetime_to_timestamp/6,

         get_today_second_passed/0,
         get_week_second_passed/0,
         get_month_second_passed/0,

         get_seconds_to_tomorrow/0,
         get_seconds_to_next_week/0,
         get_seconds_to_next_month/0,

         get_timestamp_of_today_start/0,
         get_timestamp_of_today_start/1,
         get_timestamp_of_tomorrow_start/0,
         get_timestamp_of_week_start/0,
         get_timestamp_of_week_start/1,
         get_timestamp_of_month_start/0,
         get_timestamp_of_next_month_start/0,
         date/0,         
         get_week_day/0,
         get_week_day/1,
         
         %% 此处的timestamp 是从0年1月1日0时0分0秒开始计算
         %% 慎用
         get_calendar_by_timestamp/1,
         get_timestamp_by_calendar/1,

         is_same_day/2,
         is_same_week/2,
         is_same_month/2,
         
         cpu_time/0,
         get_server_start_time/0,
         
         cal_begin_end/3,
         cal_begin_end_advance/4,
         cal_week_cycle/3,
         cal_week_cycle/1,
         cal_week_cycle_advance/4,
         cal_week_cycle_advance/2,
         cal_month_cycle/1,
         cal_month_cycle/3,
         cal_month_cycle_advance/2,
         cal_month_cycle_advance/4,
         cal_day_cycle/1,
         cal_day_cycle/3,
         cal_day_cycle_advance/2,
         cal_day_cycle_advance/4,
         cal_day_cycle_new/1,
         cal_week_cycle_new/1,
         cal_month_cycle_new/1,
         cal_begin_end_new/2,
         cal_begin_end_stamp/2
        ]).

-export([test/0]).

%% -------------------------------------------------------------
%% 几个细节问题
%% 1. os:timestamp()世界时间戳
%% 2. {{1970,1,1}, {0,0,0}} 是礼拜四
%% 3. 中国时间 比 世界时间 快 28800s   
%% -------------------------------------------------------------
test() ->
    ?DAY_START_HOURS.

%% 取得当前的unix时间戳，秒级
unixtime() ->
    {M, S, _} = current(),
    M * 1000000 + S.
%% 取得当前的unix时间戳，毫秒级
longunixtime() ->
    {M, S, Ms} = current(),
    (M * 1000000000000 + S * 1000000 + Ms) div 1000.
%% 获取当前日期
yyyymmdd() ->
    {{Y,M,D},{_H,_MM,_S}} = calendar:now_to_local_time(current()),    
    Y*10000 + M * 100 + D.

local_hms() ->
    {_, Time} = calendar:now_to_local_time(current()),
    Time.
%% @doc get the time's seconds for integer type
%% @spec get_seconds(Time) -> integer() 
time_format(Now) -> 
    {{Y,M,D},{H,MM,S}} = calendar:now_to_local_time(Now),
    lists:concat([Y, "-", one_to_two(M), "-", one_to_two(D), " ", 
                  one_to_two(H) , ":", one_to_two(MM), ":", one_to_two(S)]).

%% -------------------------------------------------------------

%% 传入时间戳，返回本地日期时间
timestamp_to_datetime(Timestamp) ->
    seconds_to_localtime(Timestamp).
%% 传入日期时间，返回时间戳(参数是local_time)
datetime_to_timestamp({Year, Month, Day, Hour, Min, Sec}) ->
    datetime_to_timestamp(Year, Month, Day, Hour, Min, Sec);
datetime_to_timestamp({{Year, Month, Day}, {Hour, Min, Sec}}) ->
    datetime_to_timestamp(Year, Month, Day, Hour, Min, Sec);
datetime_to_timestamp({Hour, Min}) ->
    {{Y ,M, D}, _} = calendar:now_to_local_time(current()),
    datetime_to_timestamp(Y, M, D, Hour, Min, 0).

datetime_to_timestamp(Year, Month, Day, Hour, Min, Sec) ->
    OrealTime =  calendar:datetime_to_gregorian_seconds({{1970,1,1}, {0,0,0}}),
    ZeroSecs = calendar:datetime_to_gregorian_seconds({{Year, Month, Day}, {Hour, Min, Sec}}),
    ZeroSecs - OrealTime- ?TIME_ZONE_SECONDS.

%% -------------------------------------------------------------

%% 获取今天已经流逝的秒数
get_today_second_passed() ->
    ((unixtime() + ?TIME_ZONE_SECONDS - ?ONE_HOUR_SECONDS * ?DAY_START_HOURS) rem ?ONE_DAY_SECONDS).
%% 获取本周已经流逝的秒数
get_week_second_passed() ->
    get_week_second_passed1(unixtime()).
get_week_second_passed1(Timestamp) ->
    (Timestamp + ?TIME_ZONE_SECONDS - ?ONE_DAY_SECONDS * 4 - ?ONE_HOUR_SECONDS * ?DAY_START_HOURS) rem ?ONE_WEEK_SECONDS.
%% 获取本月已经流逝的秒数
get_month_second_passed()->
    unixtime() - get_timestamp_of_month_start().

%% ----------------------------------------------------------------

%% 获取距离明天开始的秒数
get_seconds_to_tomorrow() ->
    ?ONE_DAY_SECONDS - get_today_second_passed().
%% 获取距离下周开始的秒数
get_seconds_to_next_week() ->
    WeekStart = get_timestamp_of_week_start(),
    Now = unixtime(),
    ?ONE_WEEK_SECONDS - (Now - WeekStart).
%% 获取距离下月开始的秒数
get_seconds_to_next_month() ->
    {{Y, M, _D}, {_Hours, _Min, _Sec}} = calendar:gregorian_seconds_to_datetime(get_timestamp_of_month_start()),
    Timestamp = 
        case M =:= 12 of
            true ->
                calendar:datetime_to_gregorian_seconds({{Y+1, M, 1}, {0, 0, 0}}) - ?DIFF_SECONDS_0000_1900 - (?TIME_ZONE_SECONDS - ?ONE_HOUR_SECONDS * ?DAY_START_HOURS);
            false ->
                calendar:datetime_to_gregorian_seconds({{Y, M+1, 1}, {0, 0, 0}}) - ?DIFF_SECONDS_0000_1900 - (?TIME_ZONE_SECONDS - ?ONE_HOUR_SECONDS * ?DAY_START_HOURS)
        end,
    Timestamp - unixtime().



%% -------------------------------------------------------------------

%% 获取一天开始的时间戳
get_timestamp_of_today_start()->
    unixtime() - get_today_second_passed().
get_timestamp_of_today_start(Now)->
    Now - get_today_second_passed().
%% 获取明天的开始时间戳
get_timestamp_of_tomorrow_start() ->
    get_timestamp_of_today_start() + ?ONE_DAY_SECONDS.
%% 获取本周开始的时间戳 
%% 注意： 1970.1.1 为星期四 
get_timestamp_of_week_start() ->
    unixtime() - get_week_second_passed().
get_timestamp_of_week_start(Seconds) ->
    Seconds - get_week_second_passed1(Seconds).
%% 获取一月开始的时间戳
get_timestamp_of_month_start()->
    Now = unixtime() + ?TIME_ZONE_SECONDS - ?ONE_HOUR_SECONDS * 5,
    Seconds = Now + ?DIFF_SECONDS_0000_1900,
    {{Y, M, _D}, _} = calendar:gregorian_seconds_to_datetime(Seconds),
    calendar:datetime_to_gregorian_seconds({{Y, M, 1}, {0, 0, 0}}) - ?DIFF_SECONDS_0000_1900 - (?TIME_ZONE_SECONDS - ?ONE_HOUR_SECONDS * ?DAY_START_HOURS).

get_timestamp_of_next_month_start() ->
    Now = unixtime(),
    {{Y, M, _D}, _}= timestamp_to_datetime(Now),
    datetime_to_timestamp({Y, (M+1 rem 12), 1, 0, 0, 0}).

date() ->
    Now = unixtime(),
    {Date, _}= timestamp_to_datetime(Now),
    Date.
%% --------------------------------------------------------------------

is_same_day(Seconds1, Seconds2) ->
    %% 需要考虑时区问题
    NDay = (Seconds1 + ?TIME_ZONE_SECONDS - ?ONE_HOUR_SECONDS * ?DAY_START_HOURS) div ?ONE_DAY_SECONDS,
    ODay = (Seconds2 + ?TIME_ZONE_SECONDS - ?ONE_HOUR_SECONDS * ?DAY_START_HOURS) div ?ONE_DAY_SECONDS,
    NDay =:= ODay.
is_same_week(Seconds1, Seconds2) ->
    Start1 = get_timestamp_of_week_start(Seconds1),
    Start2 = get_timestamp_of_week_start(Seconds2),
    Start1 =:= Start2.
is_same_month(Seconds1, Seconds2) ->
    NS1 = Seconds1 + ?TIME_ZONE_SECONDS - ?ONE_HOUR_SECONDS * ?DAY_START_HOURS,
    NS2 = Seconds2 + ?TIME_ZONE_SECONDS - ?ONE_HOUR_SECONDS * ?DAY_START_HOURS,
    {{Year1, Month1, _Day1}, _} = calendar:gregorian_seconds_to_datetime(NS1 + ?DIFF_SECONDS_0000_1900),
    {{Year2, Month2, _Day2}, _} = calendar:gregorian_seconds_to_datetime(NS2 + ?DIFF_SECONDS_0000_1900),
    if
        Year1 =:= Year2 andalso Month1 =:= Month2->
            true;
        true ->
            false
    end.

%% ----------------------------------------------------------------------

%% 判断今天星期几 
get_week_day() ->
    Now = unixtime(),
    get_date(Now - ?ONE_HOUR_SECONDS * ?DAY_START_HOURS).
get_week_day(Now) ->
    get_date(Now - ?ONE_HOUR_SECONDS * ?DAY_START_HOURS).

%% 1970.1.1 为星期四
get_date(Timestamp) ->
    {{Y, M, D}, _} = calendar:gregorian_seconds_to_datetime(Timestamp + ?TIME_ZONE_SECONDS + ?DIFF_SECONDS_0000_1900),
    calendar:day_of_the_week({Y, M, D}).

%% ----------------------------------------------------------------------
get_calendar_by_timestamp(Timestamp) ->
    calendar:gregorian_seconds_to_datetime(Timestamp).
get_timestamp_by_calendar(DateTime) ->
    calendar:datetime_to_gregorian_seconds(DateTime).    

%% ----------------------------------------------------------------------

%% 底层时间戳是从{{1970,1,1},{0,0,0}}开始的
current() -> 
    os:timestamp().
%% seconds to localtime 
seconds_to_localtime(Seconds) ->
    DateTime = calendar:gregorian_seconds_to_datetime(
                 Seconds + ?DIFF_SECONDS_0000_1900),
    %% 注意：这个函数时间戳有时域的处理, 得到的日期是中国的日期
    calendar:universal_time_to_local_time(DateTime).
%% time format
one_to_two(One) ->
    io_lib:format("~2..0B", [One]).

%% ----------------------------------------------------------------------------

cpu_time() -> 
    [{timer, {_, Wallclock_Time_Since_Last_Call}}] = 
        ets:lookup(ets_timer, timer),
    Wallclock_Time_Since_Last_Call.

%% @doc get server start time
get_server_start_time() ->
    {YY, MM, DD, HH, II, SS} = app_misc:get_env(server_start_timestamp),
    datetime_to_timestamp(YY, MM, DD, HH, II, SS).

%% -----------------------------------------------------------------------------

%% {2013, 6, 14, 10, 0, 0} - {2013, 8, 1, 10, 0, 0}
cal_begin_end({_,M1,D1,_,_,_}=BeginTime, {_,M2,D2,_,_,_}=EndTime, range)
    when M1 >= 1, M1 =< 12,
         D1 >= 1, D1 =< 31,
         M2 >= 1, M2 =< 12,
         D2 >= 1, D2 =< 31 ->
    {datetime_to_timestamp(BeginTime),  
     datetime_to_timestamp(EndTime)};
%% 加法不支持配月和年，全部由策划换算成多少天
cal_begin_end({_Year, Month, Day, _Hour, _Min, _Sec}=BeginTime, {0, 0, DD, DH, DMin, DS}, plus) 
    when Month >= 1, Month =< 12,
         Day >= 1, Day =< 31 ->
    Delta = DD * ?ONE_DAY_SECONDS + DH * ?ONE_HOUR_SECONDS + DMin * ?ONE_MINITE_SECONDS + DS,
    NewBeginTime = datetime_to_timestamp(BeginTime),
    {NewBeginTime, NewBeginTime + Delta};
cal_begin_end(BeginTime, EndTime, Other) ->
    ?WARNING_MSG("maybe conf error ~p~n", [{BeginTime, EndTime, Other}]),
    {undefined, undefined}.

cal_begin_end_advance(BeginTime, EndTime, undefined, Method) ->
    cal_begin_end_advance(BeginTime, EndTime, {0, 0, 0, 0, 0, 0}, Method);
cal_begin_end_advance(BeginTime, EndTime, {0, 0, DD, DH, DMin, DS}, Method) ->
    Delta = DD * ?ONE_DAY_SECONDS + DH * ?ONE_HOUR_SECONDS + DMin * ?ONE_MINITE_SECONDS + DS,
    case cal_begin_end(BeginTime, EndTime, Method) of 
        {NewBeginTime, NewEndTime} 
          when is_integer(NewBeginTime),
               is_integer(NewEndTime) ->
            {NewBeginTime, NewEndTime, NewBeginTime-Delta};
        {NewBeginTime, NewEndTime} ->
            {NewBeginTime, NewEndTime, NewBeginTime}
    end;
cal_begin_end_advance(BeginTime, EndTime, Advance, Other) ->
    ?WARNING_MSG("maybe conf error ~p~n", [{BeginTime, EndTime, Advance, Other}]),
    {undefined, undefined, undefined}.


cal_week_cycle(WeekInfo) ->
    Now = unixtime(),
    WeekStart = get_timestamp_of_week_start(),
    cal_week_cycle(WeekInfo, Now, WeekStart).
cal_week_cycle(WeekInfo, Now, WeekStart) ->
    inner_cal_cycle(WeekInfo, Now, WeekStart).

cal_week_cycle_advance(WeekInfo, Advance) ->    
    Now = unixtime(),
    WeekStart = get_timestamp_of_week_start(),
    cal_week_cycle_advance(WeekInfo, Advance, Now, WeekStart).
cal_week_cycle_advance(WeekInfo, Advance, Now, WeekStart) ->    
    inner_cal_cycle_advance(WeekInfo, Advance, Now, WeekStart).


cal_month_cycle(MonthInfo) ->
    Now = unixtime(),
    MonthStart = get_timestamp_of_month_start(),
    cal_month_cycle(MonthInfo, Now, MonthStart).
cal_month_cycle(MonthInfo, Now, MonthStart) ->
    inner_cal_cycle(MonthInfo, Now, MonthStart).

cal_month_cycle_advance(MonthInfo, Advance) ->
    Now = unixtime(),
    MonthStart = get_timestamp_of_month_start(),
    cal_month_cycle_advance(MonthInfo, Advance, Now, MonthStart).
cal_month_cycle_advance(MonthInfo, Advance, Now, MonthStart) ->
    inner_cal_cycle_advance(MonthInfo, Advance, Now, MonthStart).


cal_day_cycle(DayInfo) ->
    Now = unixtime(),
    DayStart = get_timestamp_of_today_start(),
    cal_day_cycle(DayInfo, Now, DayStart).
cal_day_cycle(DayInfo, Now, DayStart) ->
    inner_cal_cycle(DayInfo, Now, DayStart).

cal_day_cycle_advance(DayInfo, Advance) ->
    Now = unixtime(),
    DayStart = get_timestamp_of_today_start(),
    cal_day_cycle_advance(DayInfo, Advance, Now, DayStart).
cal_day_cycle_advance(DayInfo, Advance, Now, DayStart) ->
    inner_cal_cycle_advance(DayInfo, Advance, Now, DayStart).


inner_cal_cycle(Info, Now, Start) ->
    {Begin, End, _} = inner_cal_cycle_advance(Info, {0, 0, 0, 0, 0, 0}, Now, Start),
    {Begin, End}.

%% 如果是多次循环，建议将时间传进来，减少查询ETS
inner_cal_cycle_advance([], _, _, _) ->
    {undefined, undefined, undefined};
inner_cal_cycle_advance(Info, undefined, Now, Start) ->
    inner_cal_cycle_advance(Info, {0, 0, 0, 0, 0, 0}, Now, Start);
inner_cal_cycle_advance({{BeginHour, BeginMin}, {ContiHour, ContiMin}}, Advance, Now, Start) ->
    inner_cal_cycle_advance({1, {BeginHour, BeginMin}, {ContiHour, ContiMin}}, Advance, Now, Start);
inner_cal_cycle_advance({Day, {BeginHour, BeginMin}, {ContiHour, ContiMin}}, {0, 0, DD, DH, DMin, DS}, Now, Start) ->    
    Delta = DD * ?ONE_DAY_SECONDS + DH * ?ONE_HOUR_SECONDS + DMin * ?ONE_MINITE_SECONDS + DS,
    StartTimeStamp = Start + (Day - 1)*?ONE_DAY_SECONDS,
    BeginSeconds = BeginHour * ?ONE_HOUR_SECONDS + BeginMin * ?ONE_MINITE_SECONDS,
    EndSeconds = (BeginHour + ContiHour) * ?ONE_HOUR_SECONDS + (BeginMin + ContiMin) * ?ONE_MINITE_SECONDS,
    Begin = StartTimeStamp + BeginSeconds,
    End = StartTimeStamp + EndSeconds,
    Show = Begin - Delta,
    %?DEBUG("Info ~p, ~p~n", [{Info, Start}, {Begin, End, Now}]),
    if 
        Show =< Now andalso
        Now =< End -> 
            {Begin, End, Show};
        true ->
            {undefined, undefined, undefined}
    end;
inner_cal_cycle_advance([Info|Acc], Advance, Now, Start) ->
    case inner_cal_cycle_advance(Info, Advance, Now, Start) of
        {undefined, undefined, undefined} ->
            inner_cal_cycle_advance(Acc, Advance, Now, Start);
        Other ->
            Other
    end;

inner_cal_cycle_advance(Info, Advance, _, _) ->
    ?WARNING_MSG("ArgList may wrong ~p~n", [{Info, Advance}]),
    {undefined, undefined, undefined}.
%%针对p02的任务循环
cal_day_cycle_new({{BHour, BMin}, {CHour, CMin}}) ->
    Now = unixtime(),
    DayStart = get_timestamp_of_today_start(),
    Begin = BHour * ?ONE_HOUR_SECONDS + BMin * ?ONE_MINITE_SECONDS + DayStart,
    End = Begin + CHour * ?ONE_HOUR_SECONDS + CMin * ?ONE_MINITE_SECONDS,
    if
        Now >= End ->
            undefined;
        true ->
            {Begin, End}
    end;
cal_day_cycle_new(Other) ->
    ?PRINT("circle_type error ~p~n", [Other]),
    undefined.
cal_week_cycle_new(Info) ->
    WeekStart = get_timestamp_of_week_start(),
    Now = unixtime(),
    inner_cal_cycle_new(Info, Now, WeekStart).
cal_month_cycle_new(Info) ->
    MonthStart = get_timestamp_of_month_start(),
    Now = unixtime(),
    inner_cal_cycle_new(Info, Now, MonthStart).     

inner_cal_cycle_new({Day, {BeginHour, BeginMin}, {ContiHour, ContiMin}}, Now, Start) ->
    Tomorrow = get_timestamp_of_tomorrow_start(),
    StartTimeStamp = Start + (Day - 1)*?ONE_DAY_SECONDS,
    BeginSeconds = BeginHour * ?ONE_HOUR_SECONDS + BeginMin * ?ONE_MINITE_SECONDS,
    EndSeconds = (BeginHour + ContiHour) * ?ONE_HOUR_SECONDS + (BeginMin + ContiMin) * ?ONE_MINITE_SECONDS,
    Begin = StartTimeStamp + BeginSeconds,
    End = StartTimeStamp + EndSeconds,
    %?DEBUG("Info ~p, ~p~n", [{Info, Start}, {Begin, End, Now}]),
    if 
        Now =< End andalso Begin =< Tomorrow ->
            {Begin, End};
        true ->
            undefined
    end;
inner_cal_cycle_new(Info, _, _) -> 
    ?WARNING_MSG("cal circle time may error ~p~n", [Info]),
    undefined.

cal_begin_end_new({_Year, Month, Day, _Hour, _Min, _Sec}=BeginTime, {0, 0, DD, DH, DMin, DS}) 
    when Month >= 1, Month =< 12,
         Day >= 1, Day =< 31 ->
    Now = unixtime(),
    Tomorrow = get_timestamp_of_tomorrow_start(),
    Delta = DD * ?ONE_DAY_SECONDS + DH * ?ONE_HOUR_SECONDS + DMin * ?ONE_MINITE_SECONDS + DS,
    NewBeginTime = datetime_to_timestamp(BeginTime),
    EndTime = NewBeginTime + Delta,
    if 
        Now =< EndTime andalso NewBeginTime =< Tomorrow ->
            {NewBeginTime, EndTime};
        true ->
            undefined
    end;
cal_begin_end_new(BeginTime, EndTime) ->
    ?WARNING_MSG("maybe conf error ~p~n", [{BeginTime, EndTime}]),
    undefined.

cal_begin_end_stamp({_Year, _Month, _Day, _Hour, _Min, _Sec} = StartTime, {0, 0, DD, DH, DMin, DS})->
    OpenStemp = time_misc:datetime_to_timestamp(StartTime),
    EndStemp = OpenStemp + DD * ?ONE_DAY_SECONDS + DH * ?ONE_HOUR_SECONDS + DMin * ?ONE_MINITE_SECONDS + DS,
    {OpenStemp, EndStemp};
cal_begin_end_stamp(StartTime, LastTime) ->
    ?WARNING_MSG("maybe conf error ~p~n", [{StartTime, LastTime}]),
    undefined.
