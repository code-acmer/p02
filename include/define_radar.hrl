-ifndef(DEFINE_RADAR_HRL).
-define(DEFINE_RADAR_HRL,true).

-define(ACCURACY_ONE,     0.00001). %% 纬度精确1米, 经度精确1.1米
-define(ACCURACY_TEN,      0.0001). %% 纬度精确10米, 经度精确11米
-define(ACCURACY_HUNDRED,   0.001). %% 纬度精确100米, 经度精确111米
-define(ACCURACY_THOUSAND,   0.01). %% 纬度精确1000米, 经度精确1113米
-define(ACCURACY_MILLION,     0.1). %% 纬度精确10000米, 经度精确11132米

-define(ACCURACY_TWO_HUNDRED,  0.002). %% 纬度精确200米, 经度精确222米
-define(ACCURACY_FIVE_HUNDRED, 0.005). %% 纬度精确500米, 经度精确556米

-define(ACCURACY_LIST, [
                        %?ACCURACY_MILLION,
                        ?ACCURACY_THOUSAND,
                        ?ACCURACY_FIVE_HUNDRED,
                        ?ACCURACY_TWO_HUNDRED
                        %?ACCURACY_TEN,
                        %?ACCURACY_ONE
                       ]).

-record(radar_msg, {
          player_id,
          version = radar_msg_version:current_version(),
          accuracy_thousand,
          accuracy_five_hundred,
          accuracy_two_hundred,
          longitude, %% 经度
          latitude,  %% 纬度
          player_state = 0 %% 玩家状态,是否在线或下线
         }).

-define(DISTANCE_TWO_HUNDRED,  200). %% 距离200米范围
-define(DISTANCE_FIVE_HUNDRED, 500). %% 距离500米范围
-define(DISTANCE_THOUSAND,    1000). %% 距离1000米范围

%% 纬度精确200米, 经度精确222米
-define(TWO_HUNDRED_LAT_DIS,  200).
-define(TWO_HUNDRED_LONG_DIS, 222).
%% 纬度精确500米, 经度精确556米
-define(FIVE_HUNDRED_LAT_DIS,  500).
-define(FIVE_HUNDRED_LONG_DIS, 556).
%% 纬度精确10000米, 经度精确11132米
-define(THOUSAND_LAT_DIS,  1000).
-define(THOUSAND_LONG_DIS, 1113).

-endif.
