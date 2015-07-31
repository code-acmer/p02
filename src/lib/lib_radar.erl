-module(lib_radar).
-author('lijunqiang@moyou.me').

-include("define_player.hrl").
-include("define_goods.hrl").
-include("define_logger.hrl").
-include("define_time.hrl").
-include("define_info_15.hrl").
-include("define_money_cost.hrl").
-include("define_radar.hrl").

-export([
         test/0
        ]).

get_prep_msg(PlayerId, ?DISTANCE_TWO_HUNDRED) ->
    get_prep_msg1(PlayerId, ?ACCURACY_TWO_HUNDRED);
get_prep_msg(PlayerId, ?DISTANCE_FIVE_HUNDRED) ->
    get_prep_msg1(PlayerId, ?ACCURACY_FIVE_HUNDRED);
get_prep_msg(PlayerId, ?DISTANCE_THOUSAND) ->
    get_prep_msg1(PlayerId, ?ACCURACY_THOUSAND).

get_prep_msg1(PlayerId, Accuracy) 
  when Accuracy < 1 ->
    case hdb:dirty_read(radar_msg, PlayerId) of
        [] ->
            {fail, ?INFO_CONF_ERR};
        RadarMsg ->
            get_prep_msg2(Accuracy, RadarMsg)
    end.

get_prep_msg2(?ACCURACY_TWO_HUNDRED, #radar_msg{
                                        accuracy_two_hundred = TwoHundred
                                       } = RadarMsg) ->
    TwoHundredList = radar_misc:get_prep_group(TwoHundred),
    PrepList = 
        lists:foldl(fun({Long, Lat}, Acc) ->
                            hdb:dirty_index_read(
                              radar_msg, 
                              {Long, Lat}, 
                              #radar_msg.accuracy_two_hundred) ++ Acc
                    end, [], TwoHundredList),
    AccuracyDis = {?TWO_HUNDRED_LONG_DIS, ?TWO_HUNDRED_LAT_DIS},
    count_distance(1/?ACCURACY_TWO_HUNDRED, AccuracyDis, PrepList, RadarMsg);

get_prep_msg2(?ACCURACY_FIVE_HUNDRED, #radar_msg{
                                         accuracy_five_hundred = FiveHundred
                                        } = RadarMsg) ->
    FiveHundredList = radar_misc:get_prep_group(FiveHundred),
    PrepList = 
        lists:foldl(fun({Long, Lat}, Acc) ->
                            hdb:dirty_index_read(
                              radar_msg, 
                              {Long, Lat}, 
                              #radar_msg.accuracy_five_hundred) ++ Acc
                    end, [], FiveHundredList),
    AccuracyDis = {?FIVE_HUNDRED_LONG_DIS, ?FIVE_HUNDRED_LONG_DIS},
    count_distance(1/?ACCURACY_FIVE_HUNDRED, AccuracyDis, PrepList, RadarMsg);

get_prep_msg2(?ACCURACY_THOUSAND, #radar_msg{
                                     accuracy_thousand = Thousand
                                    } = RadarMsg) ->
    ThousandList = radar_misc:get_prep_group(Thousand),
    PrepList = 
        lists:foldl(fun({Long, Lat}, Acc) ->
                            hdb:dirty_index_read(
                              radar_msg, 
                              {Long, Lat}, 
                              #radar_msg.accuracy_thousand) ++ Acc
                    end, [], ThousandList),
    AccuracyDis = {?THOUSAND_LONG_DIS, ?THOUSAND_LAT_DIS},
    count_distance(1/?ACCURACY_THOUSAND, AccuracyDis, PrepList, RadarMsg).

count_distance(Mult, AccuracyDis, PrepMsgList, RadarMsg) ->
    count_distance(Mult, AccuracyDis, PrepMsgList, RadarMsg, []).

count_distance(_, _, [], _, Acc) ->
    Acc;
count_distance(Mult, AccuracyDis, [H | T], RadarMsg, Acc) ->
    #radar_msg{
       player_id = PrepPlayerId,
       longitude = PrepLong,
       latitude = PrepLat
      } = H,
    %io:format("player_id: ~p, PrepLong: ~p, PrepLat: ~p ~n", [PrepPlayerId, PrepLong, PrepLat]),
    #radar_msg{
       longitude = Long,
       latitude = Lat
      } = RadarMsg,
    Distance = radar_misc:count(Mult, AccuracyDis, {PrepLong, PrepLat}, {Long, Lat}),
    count_distance(Mult, AccuracyDis, T, RadarMsg, [{PrepPlayerId, Distance} | Acc]).

update_position(Long, Lat, PlayerId) ->
    [Thousand, FiveHundred, TwoHundred] = radar_misc:reference_accuracy_msg(Long, Lat),
    %io:format("ThousandStrList: ~p ~nFiveHundredStrList: ~p ~nTwoHundredStrList: ~p~n", 
     %         [Thousand, FiveHundred, TwoHundred]),
    RadarMsg = 
        #radar_msg{
           player_id = PlayerId,
           accuracy_thousand = Thousand,
           accuracy_five_hundred = FiveHundred,
           accuracy_two_hundred = TwoHundred,
           longitude = Long, %% 经度
           latitude = Lat,  %% 纬度
           player_state = 1 %% 玩家状态,是否在线或下线
          },
    hdb:dirty_write(radar_msg, RadarMsg).

test() ->
    update_position(0.0001, 0.0002, 12),
    update_position(-0.0001, -0.0002, 13),
    update_position(0.0001, -0.0002, 14),
    update_position(-0.0001, 0.0002, 15),

    update_position(0.000001, 0.000002, 16),
    update_position(-0.000001, -0.000002, 17),
    update_position(0.000001, -0.000002, 18),
    update_position(-0.000001, 0.000002, 19),

    update_position(-23.002, -23.001, 20),
    update_position(-23.002, -23.0015, 21),
    update_position(-23.0016, -23.0017, 22),
    update_position(-23.00111, -23.00112, 23),

    L1 = get_prep_msg(12, ?DISTANCE_TWO_HUNDRED),
    L2 = get_prep_msg(16, ?DISTANCE_FIVE_HUNDRED),
    L3 = get_prep_msg(20, ?DISTANCE_THOUSAND),
    io:format("L1 : ~p, ~nL2: ~p, ~nL3: ~p~n", [L1, L2, L3]).
    
