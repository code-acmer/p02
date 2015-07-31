-module(radar_misc).
-author('lijunqiang@moyou.me').

-define(ACCURACY_ONE,     0.00001). %% 纬度精确1米, 经度精确1.1米
-define(ACCURACY_TEN,      0.0001). %% 纬度精确10米, 经度精确11米
-define(ACCURACY_HUNDRED,   0.001). %% 纬度精确100米, 经度精确111米
-define(ACCURACY_THOUSAND,   0.01). %% 纬度精确1000米, 经度精确1113米
-define(ACCURACY_MILLION,     0.1). %% 纬度精确10000米, 经度精确11132米

-define(ACCURACY_FIFTY,       0.0005). %% 纬度精确50米, 经度精确55米
-define(ACCURACY_TWO_HUNDRED,  0.002). %% 纬度精确200米, 经度精确222米
-define(ACCURACY_FIVE_HUNDRED, 0.005). %% 纬度精确500米, 经度精确556米

%% 若添加精确度，务必由大到小顺序
-define(ACCURACY_LIST, [
                        %?ACCURACY_MILLION,
                        ?ACCURACY_THOUSAND,
                        ?ACCURACY_FIVE_HUNDRED,
                        ?ACCURACY_TWO_HUNDRED
                        %?ACCURACY_TEN,
                        %?ACCURACY_ONE
                       ]).
%% 距离200米范围
-define(DISTANCE_TWO_HUNDRED,  200). 
%% 距离500米范围
-define(DISTANCE_FIVE_HUNDRED, 500). 
%% 距离1000米范围
-define(DISTANCE_THOUSAND,    1000). 

%% 纬度精确200米, 经度精确222米
-define(TWO_HUNDRED_LAT_DIS,  200).
-define(TWO_HUNDRED_LONG_DIS, 222).
%% 纬度精确500米, 经度精确556米
-define(FIVE_HUNDRED_LAT_DIS,  500).
-define(FIVE_HUNDRED_LONG_DIS, 556).
%% 纬度精确1000米, 经度精确1113米
-define(THOUSAND_LAT_DIS,  1000).
-define(THOUSAND_LONG_DIS, 1113).

-export([
         get_prep_group/1,
         count/4,
         reference_accuracy_msg/2
        ]).

%% 经度、 纬度
longitude_coding(Longitude, AccuracyList) ->
    coding(Longitude, -180, 180, AccuracyList, 0, []).

latitude_coding(Latitude, AccuracyList) ->
    coding(Latitude, -90, 90, AccuracyList, 0, []).

coding(_, _, _, [], _, AccList) ->
    lists:reverse(AccList);

coding(K, L, R, [H | T] = _AccuracyList, Data, AccList) 
  when R - L < H ->
    coding(K, L, R, T, Data, [Data | AccList]);

coding(K, L, R, AccuracyList, Data, AccList) ->
    M = (L + R) / 2,
    if
        K > M ->
            coding(K, M, R, AccuracyList, (Data bsl 1) + 1, AccList);
        true ->
            coding(K, L, M, AccuracyList, (Data bsl 1) + 0, AccList)
    end.

traversal(A, [A|_], [H|_]) ->
    H;
traversal(A, [_|S], [_|T]) ->
    traversal(A, S, T).

%------------------------------------------------------------
%% 获取 9 个坑 {经度整数, 纬度整数}
get_prep_group({LongBit, LatBit}) ->
    tuple_to_list({{LongBit+1, LatBit+1}, {LongBit+1, LatBit},   {LongBit+1, LatBit-1}, 
                   {LongBit, LatBit+1},   {LongBit, LatBit-1},   {LongBit, LatBit}, 
                   {LongBit-1, LatBit+1}, {LongBit-1, LatBit-1}, {LongBit-1, LatBit}}).

%% 计算距离：先转化单位, 全部转化为　单位 = 1米
%% M是 1/精确度  1/0.001 = 1000
%% Lo 经度精确度 单位100米
%% La 纬度精确度 单位111米
%% {OldX, OldY} = {经度, 纬度} 查询玩家地理位置
%% {OldX1, OldY1} = {经度, 纬度} 被查询玩家地理位置
count(M, {Lo, La}, {OldX, OldY}, {OldX1, OldY1}) ->
    X = OldX * M * Lo,
    Y = OldY * M * La,
    X1 = OldX1 * M * Lo,
    Y1 = OldY1 * M * La,
    (X1 - X) * (X1 - X) + (Y1 - Y) * (Y1 - Y).

%% 经度、纬度、精确度 (88.0000, 88.88888)
%% 返回值
%% [各个精确度tuple {Long(int), Lat(int)}] 顺序和　?ACCURACY_LIST一致
reference_accuracy_msg(LongitudeNum, LatitudeNum) ->
    %% 将 float 数值转化为 BinaryList, 包含每个精确度的 BinaryList
    LongitudeList = longitude_coding(LongitudeNum, ?ACCURACY_LIST), 
    LatitudeList = latitude_coding(LatitudeNum, ?ACCURACY_LIST),
    MsgList = 
        lists:map(fun(Accuracy) ->
                          %% %% 找出精确度为 Accuracy 的 BinaryList
                          Longitude = traversal(Accuracy, ?ACCURACY_LIST, LongitudeList),
                          Latitude  = traversal(Accuracy, ?ACCURACY_LIST, LatitudeList),
                          {Longitude, Latitude}
                  end, ?ACCURACY_LIST),
    MsgList.
