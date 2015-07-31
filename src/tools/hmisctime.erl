%%%----------------------------------------------------------------------
%%% File    : misc_timer.erl
%%% Created : 2010-10-17
%%% Description: 时间生成器
%%%----------------------------------------------------------------------
-module(hmisctime).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("define_logger.hrl").
-include("define_time.hrl").

%% --------------------------------------------------------------------
%% External exports

-export([
         unixtime/0,
         longunixtime/0,
         seconds_to_localtime/1,
         get_day_second_passed/1,
         get_seconds_to_tomorrow/0,
         get_seconds_to_tomorrow_4/0,
         get_seconds_to_tomorrow_5/0,
         get_seconds_to_next_week/0,
         get_today_second_passed/0,
         get_today_second_passed_new/0,
         get_timestamp_of_today_start/0,
         get_timestamp_of_today_start_new/0,
         get_timestamp_of_today_start/1,
         get_timestamp_of_today_start_new/1,
         get_timestamp_of_tomorrow_start/0,
         get_timestamp_of_tomorrow_start_new/0,
         get_timestamp_of_week_start/0,
         get_timestamp_of_week_start/1,
         get_timestamp_of_week_start_new/0,
         get_timestamp_of_week_start_new/1,
         get_timestamp_of_month_start/0,
         get_timestamp_of_month_start/1,
         get_timestamp_of_month_start_new/0,
         get_timestamp_of_month_start_new/1,
         is_same_date/2,
         is_same_date_of_5/2,
         is_same_month/2,
         is_same_month_of_5/2,
         is_same_week/2,
         is_same_week_new/2,
         datetime_to_timestamp/1,
         datetime_to_timestamp/6,
         timestamp_to_datetime/1,
         time_format/1,
         get_server_start_time/0,
         get_today_current_second/0,
         get_week_day/0,
         get_week_day/1,
         get_week_day_new/0,
         get_week_day_new/1,
         get_midnight_seconds/1,
         get_days_passed/2,
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
         yyyymmdd/0,
         cpu_time/0,
         cal_day_cycle_new/1,
         cal_week_cycle_new/1,
         cal_month_cycle_new/1,
         cal_begin_end_new/2,
         cal_begin_end_stamp/2
        ]).

%% ====================================================================
%% External functions
%% ====================================================================
%% 时间函数
%% -----------------------------------------------------------------
%% 根据1970年以来的秒数获得日期
%% -----------------------------------------------------------------

%% @doc get the time's seconds for integer type
%% @spec get_seconds(Time) -> integer() 
time_format(Now) -> 
    {{Y,M,D},{H,MM,S}} = calendar:now_to_local_time(Now),
    lists:concat([Y, "-", one_to_two(M), "-", one_to_two(D), " ", 
                  one_to_two(H) , ":", one_to_two(MM), ":", one_to_two(S)]).

yyyymmdd() ->
    {{Y,M,D},{_H,_MM,_S}} = calendar:now_to_local_time(current()),    
    Y*10000 + M * 100 + D.
    

%% 取得当前的unix时间戳，秒级
unixtime() ->
    {M, S, _} = current(),
    M * 1000000 + S.

%% 取得当前的unix时间戳，毫秒级
longunixtime() ->
    {M, S, Ms} = current(),
    (M * 1000000000000 + S * 1000000 + Ms) div 1000.

%% seconds to localtime
seconds_to_localtime(Seconds) ->
    DateTime = calendar:gregorian_seconds_to_datetime(
                 Seconds + ?DIFF_SECONDS_0000_1900),
    calendar:universal_time_to_local_time(DateTime).

%% -----------------------------------------------------------------
%% 判断是否同一天
%% -----------------------------------------------------------------
is_same_date(Seconds1, Seconds2) ->
    %% 需要考虑时区问题
    NDay = (Seconds1 + ?TIME_ZONE_SECONDS) div ?ONE_DAY_SECONDS,
    ODay = (Seconds2 + ?TIME_ZONE_SECONDS) div ?ONE_DAY_SECONDS,
    NDay =:= ODay.

is_same_date_of_5(Seconds1, Seconds2) ->
        %% 需要考虑时区问题
    get_timestamp_of_today_start_new(Seconds1) =:= get_timestamp_of_today_start_new(Seconds2).
%% -----------------------------------------------------------------
%% 判断是否同一月
%% -----------------------------------------------------------------
is_same_month(Seconds1, Seconds2) ->
    {{Year1, Month1, _Day1}, _Time1} = timestamp_to_datetime(Seconds1),
    {{Year2, Month2, _Day2}, _Time2} = timestamp_to_datetime(Seconds2),
    %% ?DEBUG("is_same_month Y:~p M:~p d:~p",[Year1,Month1,_Day1]),
    %% ?DEBUG("is_same_month Y:~p M:~p d:~p",[Year2,Month2,_Day2]),
    if 
        (Year1 == Year2) andalso (Month1 == Month2) -> 
            true;
        true -> 
            false
    end.

is_same_month_of_5(Seconds1, Seconds2) ->
    is_same_month(Seconds1 - ?ONE_HOUR_SECONDS * 5, Seconds2 - ?ONE_HOUR_SECONDS * 5).

%% 获取今天已经流逝的秒数
get_today_second_passed_new() ->
    ((unixtime() + ?TIME_ZONE_SECONDS - ?ONE_HOUR_SECONDS*5) rem ?ONE_DAY_SECONDS).
get_today_second_passed() ->
    ((unixtime() + ?TIME_ZONE_SECONDS) rem ?ONE_DAY_SECONDS).

%% 获取当前已经流逝的时间（秒）
get_day_second_passed(Time) ->
    Time - ((Time + ?TIME_ZONE_SECONDS) rem ?ONE_DAY_SECONDS).

%% 获取当天5点世界时间戳
get_timestamp_of_today_start_new() ->
    Now = unixtime(),
    Now - ((Now + ?TIME_ZONE_SECONDS) rem ?ONE_DAY_SECONDS) + ?ONE_HOUR_SECONDS * 5.
get_timestamp_of_today_start_new(TimeStamp) ->
    Now = TimeStamp - ?ONE_HOUR_SECONDS * 5,
    Now - ((Now + ?TIME_ZONE_SECONDS) rem ?ONE_DAY_SECONDS) + ?ONE_HOUR_SECONDS * 5.
%% 获取当天0点秒数
get_timestamp_of_today_start() ->
    Now = unixtime(),
    Now - ((Now + ?TIME_ZONE_SECONDS) rem ?ONE_DAY_SECONDS).
get_timestamp_of_today_start(Now) ->
    Now - ((Now + ?TIME_ZONE_SECONDS) rem ?ONE_DAY_SECONDS).

get_timestamp_of_tomorrow_start_new() ->
    get_timestamp_of_tomorrow_start() + ?ONE_HOUR_SECONDS * 5.
get_timestamp_of_tomorrow_start() ->
    get_timestamp_of_today_start() + ?ONE_DAY_SECONDS.

%% 获取距离明天0点的秒数
get_seconds_to_tomorrow() ->
    get_timestamp_of_today_start() + ?ONE_DAY_SECONDS - unixtime().

%% 获取距离明天4点的秒数
get_seconds_to_tomorrow_4() ->
    ?ONE_HOUR_SECONDS * 4 + get_seconds_to_tomorrow().

%% 获取距离明天5点的秒数
get_seconds_to_tomorrow_5() ->
    ?ONE_HOUR_SECONDS * 5 + get_seconds_to_tomorrow().

get_seconds_to_next_week() ->
    WeekStart = get_timestamp_of_week_start_new(),
    Now = unixtime(),
    ?ONE_WEEK_SECONDS - (Now - WeekStart).

%% 获取本周开始的秒数
get_timestamp_of_week_start_new() ->
    Now = unixtime(),
    Now - (Now + ?TIME_ZONE_SECONDS - ?ONE_DAY_SECONDS * 4 - ?ONE_HOUR_SECONDS * 5) rem ?ONE_WEEK_SECONDS.
get_timestamp_of_week_start_new(Now) ->
    Now - (Now + ?TIME_ZONE_SECONDS - ?ONE_DAY_SECONDS * 4 - ?ONE_HOUR_SECONDS * 5) rem ?ONE_WEEK_SECONDS.

get_timestamp_of_week_start() ->
    Now = unixtime(),
    Now - ((Now + ?TIME_ZONE_SECONDS) rem ?ONE_WEEK_SECONDS) + ?ONE_DAY_SECONDS * 4.
get_timestamp_of_week_start(Now) ->
    Now - ((Now + ?TIME_ZONE_SECONDS) rem ?ONE_WEEK_SECONDS) + ?ONE_DAY_SECONDS * 4.

get_timestamp_of_month_start_new() ->
    {{Year, Month, _Day}, _} = timestamp_to_datetime(unixtime() - ?ONE_HOUR_SECONDS*5),
    datetime_to_timestamp(Year, Month, 1, 5, 0, 0).
get_timestamp_of_month_start_new(Now) ->
    {{Year, Month, _Day}, _} = timestamp_to_datetime(Now - ?ONE_HOUR_SECONDS*5),
    datetime_to_timestamp(Year, Month, 1, 5, 0, 0).

get_timestamp_of_month_start()->
    {{Year, Month, Day}, _} = timestamp_to_datetime(unixtime()),
    datetime_to_timestamp(Year, Month, 1, 0, 0, 0).
get_timestamp_of_month_start(Now)->
    {{Year, Month, Day}, _} = timestamp_to_datetime(Now),
    datetime_to_timestamp(Year, Month, 1, 0, 0, 0).
%% -----------------------------------------------------------------
%% 判断是否同一星期
%% -----------------------------------------------------------------
is_same_week_new(Seconds1, Seconds2) ->  %%5点前是前一天的
    Start1 = get_timestamp_of_week_start_new(Seconds1),
    Start2 = get_timestamp_of_week_start_new(Seconds2),
    %io:format("Seconds1 ~p, Seconds2 ~p~n", [timestamp_to_datetime(Seconds1), timestamp_to_datetime(Seconds2)]),
    %io:format("Start1 ~p, Start2 ~p~n", [Start1, Start2]),
    Start1 =:= Start2.

is_same_week(Seconds1, Seconds2) ->
    {{Year1, Month1, Day1}, Time1} = seconds_to_localtime(Seconds1),
    % 星期几
    Week1  = calendar:day_of_the_week(Year1, Month1, Day1),
    % 从午夜到现在的秒数
    Diff1  = calendar:time_to_seconds(Time1),
    Monday = Seconds1 - Diff1 - (Week1 - 1) * ?ONE_DAY_SECONDS,
    Sunday = Seconds1 + (?ONE_DAY_SECONDS - Diff1) + 
        (7 - Week1) * ?ONE_DAY_SECONDS,
    if
        ((Seconds2 >= Monday) and (Seconds2 < Sunday)) ->
            true;
        true ->
            false
    end.

%% -----------------------------------------------------------------
%% 获取当天0点和第二天0点
%% -----------------------------------------------------------------
get_midnight_seconds(Seconds) ->
    {{_Year, _Month, _Day}, Time} = seconds_to_localtime(Seconds),
    %% 从午夜到现在的秒数
    Diff   = calendar:time_to_seconds(Time),
    %% 获取当天0点
    Today  = Seconds - Diff,
    %% 获取第二天0点
    NextDay = Seconds + (?ONE_DAY_SECONDS - Diff),
    {Today, NextDay}.

%% -----------------------------------------------------------------
%% 计算相差的天数
%% -----------------------------------------------------------------
get_days_passed(Seconds1, Seconds2) ->
    {{Year1, Month1, Day1}, _} = seconds_to_localtime(Seconds1),
    {{Year2, Month2, Day2}, _} = seconds_to_localtime(Seconds2),
    Days1 = calendar:date_to_gregorian_days(Year1, Month1, Day1),
    Days2 = calendar:date_to_gregorian_days(Year2, Month2, Day2),
    abs(Days2 - Days1).

%% 获取从午夜到现在的秒数
get_today_current_second() ->
    {_, Time} = calendar:now_to_local_time(current()),
    calendar:time_to_seconds(Time).

%% 判断今天星期几 
get_week_day_new() ->
    Now = unixtime(),
    get_date(Now - ?ONE_HOUR_SECONDS * 5).
get_week_day_new(Now) ->
    get_date(Now - ?ONE_HOUR_SECONDS * 5).
get_week_day() ->
    Now = unixtime(),
    get_date(Now).
get_week_day(Now) ->
    get_date(Now).

%% 1970.1.1 为星期四
get_date(Now) ->
    %% 7.
    WeekDay = ((((Now + ?TIME_ZONE_SECONDS) rem ?ONE_WEEK_SECONDS) div ?ONE_DAY_SECONDS) + 4) rem 7,
    if
        WeekDay =:= 0 -> 
            7;
        true -> 
            WeekDay
    end.

get_hour() ->
    ((unixtime() + ?TIME_ZONE_SECONDS) rem ?ONE_DAY_SECONDS) div ?ONE_HOUR_SECONDS.

get_minute() ->
    ((unixtime() + ?TIME_ZONE_SECONDS) rem ?ONE_HOUR_SECONDS) div ?ONE_MINITE_SECONDS.

%% 获取当前天数
get_day() ->
    Now = unixtime(),
    get_day(Now).

%% 获取当前天数
get_day(Now) ->
    {{_Year, _Month, Day}, _Time} = seconds_to_localtime(Now),
    Day.

%% 获取当前月
get_month() ->
    get_month(unixtime()).

%% 获取当前月
get_month(Now) ->
    {{_Year, Month, _Day}, _Time} = seconds_to_localtime(Now),
    Month.

%%获取上一周的开始时间和结束时间
get_pre_week_duringtime() ->
    OrealTime = calendar:datetime_to_gregorian_seconds({{1970,1,1}, {0,0,0}}),
    {Year, Month, Day} = date(),
    CurrentTime = calendar:datetime_to_gregorian_seconds(
                    {{Year,Month,Day}, {0,0,0}}
                   ) - OrealTime - 8 * 60 * 60,%%从1970开始时间值
    WeekDay = calendar:day_of_the_week(Year,Month,Day),
    Day1 = 
        case WeekDay of %%上周的时间
            1 -> 7;
            2 -> 7+1;
            3 -> 7+2;
            4 -> 7+3;
            5 -> 7+4;
            6 -> 7+5;
            7 -> 7+6
        end,
    StartTime = CurrentTime - Day1*24*60*60,
    EndTime = StartTime + 7 * 24 * 60 * 60,
    {StartTime, EndTime}.
	
%%获取本周的开始时间和结束时间
get_this_week_duringtime() ->
	OrealTime =  calendar:datetime_to_gregorian_seconds({{1970,1,1}, {0,0,0}}),
	{Year,Month,Day} = date(),
	CurrentTime = calendar:datetime_to_gregorian_seconds({{Year,Month,Day}, {0,0,0}})-OrealTime-8*60*60,%%从1970开始时间值
	WeekDay = calendar:day_of_the_week(Year,Month,Day),
	Day1 = 
	case WeekDay of %%上周的时间
		1 -> 0;
		2 -> 1;
		3 -> 2;
		4 -> 3;
		5 -> 4;
		6 -> 5;
		7 -> 6
	end,
	StartTime = CurrentTime - Day1*24*60*60,
	EndTime = StartTime+7*24*60*60,
	{StartTime,EndTime}.

%% 传入日期时间，返回时间戳(参数是local_time)
datetime_to_timestamp(undefined) ->
    undefined;
datetime_to_timestamp(all) ->
    all;
datetime_to_timestamp({Hour, Min}) ->
    {{Y ,M, D}, _} = calendar:now_to_local_time(current()),
    datetime_to_timestamp(Y, M, D, Hour, Min, 0);
datetime_to_timestamp({Year, Month, Day, Hour, Min, Sec}) ->
    datetime_to_timestamp(Year, Month, Day, Hour, Min, Sec).

datetime_to_timestamp(Year, Month, Day, Hour, Min, Sec) ->
    OrealTime =  calendar:datetime_to_gregorian_seconds({{1970,1,1}, {0,0,0}}),
    ZeroSecs = calendar:datetime_to_gregorian_seconds({{Year, Month, Day}, {Hour, Min, Sec}}),
    ZeroSecs - OrealTime - ?TIME_ZONE_SECONDS.

%% 传入时间戳，返回日期时间
timestamp_to_datetime(Timestamp) ->
    seconds_to_localtime(Timestamp).
    %% io_lib:format("~4..0w-~2..0w-~2..0w ~2..0w:~2..0w:~2..0w", 
    %%               [YY, MM, DD, Hour, Min, Sec]). 

%% 日期叠加
datetime_plus({Year, Month, Day, Hour, Min, Sec}, {DY, DM, DD, DH, DMin, DS}) ->
    Delta = DD * ?ONE_DAY_SECONDS + DH * ?ONE_HOUR_SECONDS + DMin * ?ONE_MINITE_SECONDS + DS,
    TempMon = Month + DM,
    RMon = (TempMon - 1) rem 12 + 1,
    CYear = (TempMon - 1) div 12,
    EndTime = datetime_to_timestamp(Year + DY + CYear, RMon, Day, Hour, Min, Sec) + Delta,
    timestamp_to_datetime(EndTime).
    
%% 以e=2.718281828459L为底的对数
%% lnx(X) ->
%%     math:log10(X) / math:log10(?E).
check_same_day(Timestamp)->
    NDay = (unixtime() + 8 * 3600) div 86400,
    ODay = (Timestamp+8*3600) div 86400,
    NDay =:= ODay.

current() -> 
    os:timestamp().

now_seconds()->
    [{timer, {Now, _}}] = ets:lookup(ets_timer, timer),
    {MegaSecs, Secs, _MicroSecs} = Now,
    lists:concat([MegaSecs, Secs]).

cpu_time() -> 
    [{timer, {_, Wallclock_Time_Since_Last_Call}}] = 
        ets:lookup(ets_timer, timer),
    Wallclock_Time_Since_Last_Call.

%% @doc get server start time
get_server_start_time() ->
    {YY, MM, DD, HH, II, SS} = app_misc:get_env(server_start_timestamp),
    datetime_to_timestamp(YY, MM, DD, HH, II, SS).

%% time format
one_to_two(One) ->
    io_lib:format("~2..0B", [One]).




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
    DayStart = get_timestamp_of_today_start_new(),
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
    WeekStart = get_timestamp_of_week_start_new(),
    Now = unixtime(),
    inner_cal_cycle_new(Info, Now, WeekStart).
cal_month_cycle_new(Info) ->
    MonthStart = get_timestamp_of_month_start_new(),
    Now = unixtime(),
    inner_cal_cycle_new(Info, Now, MonthStart).     

inner_cal_cycle_new({Day, {BeginHour, BeginMin}, {ContiHour, ContiMin}}, Now, Start) ->
    Tomorrow = get_timestamp_of_tomorrow_start_new(),
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
    Tomorrow = get_timestamp_of_tomorrow_start_new(),
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
    OpenStemp = hmisctime:datetime_to_timestamp(StartTime),
    EndStemp = OpenStemp + DD * ?ONE_DAY_SECONDS + DH * ?ONE_HOUR_SECONDS + DMin * ?ONE_MINITE_SECONDS + DS,
    {OpenStemp, EndStemp};
cal_begin_end_stamp(StartTime, LastTime) ->
    ?WARNING_MSG("maybe conf error ~p~n", [{StartTime, LastTime}]),
    undefined.
