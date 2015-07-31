%% %% 活动模块
-module(lib_activity).

%% -export([%twist_egg/3, 
%%          check_activity/1,
%%          check_activity/2,
%%          activity_list/0,
%%          check_req_time/1]).

%% -include("define_activity.hrl").
%% -include("db_base_activity.hrl").
%% -include("define_reward.hrl").
%% -include("define_player.hrl").
%% -include("define_goods_type.hrl").
%% -include("define_info_34.hrl").
%% -include("define_goods.hrl").
%% -include("define_dungeon.hrl").
%% -include("define_logger.hrl").
%% -include("db_log_twist_eggs.hrl").

%% %% 扭蛋
%% %% twist_egg(_Player, _Type, Count) when Count > 10 ->
%% %%     {fail, ?ERROR_TWIST_EGG_LIMIT};
%% %% twist_egg(ModPlayerSate, Type, Count) ->
%% %%     Player = ModPlayerSate?PLAYER,
%% %%     {Cost2, Type2} = calc_cost(Type, Count),
%% %%     case get_base_goods_list(Type) of
%% %%         [] ->
%% %%             {fail, ?ERROR_TYPE_ENPTY};
%% %%         BaseGoodList ->
%% %%             case lib_player:cost_money(Player, Cost2, Type2, 34002)of
%% %%                 {true, NewPlayer} ->
%% %%                     GoodsIds = 
%% %%                         lists:map(
%% %%                             fun(_) -> 
%% %%                                 hmisc:rand(BaseGoodList, ?RANDOM_BASE)
%% %%                             end, lists:seq(1, Count)),
%% %%                     %%给抽出来的斗魂添加附加附加属性
%% %%                     {CheckCfgRet, GoodsList, AddAttFlagList} = 
%% %%                         good_add_att(GoodsIds, NewPlayer),
%% %%                     ?WARNING_MSG("GoodsList ~p~n, AddAttFlagList~p~n", [GoodsList, AddAttFlagList]),
%% %%                     NewModPlayerSate = ModPlayerSate#mod_player_state{player = NewPlayer},
%% %%                     case lib_goods:add_goods_list(NewModPlayerSate, 
%% %%                                                   GoodsList, 
%% %%                                                   CheckCfgRet, 
%% %%                                                   34002) of
%% %%                         {fail, Reason1} ->
%% %%                             {fail, Reason1};
%% %%                         {ok, NewModPlayerSate2, UpdateGoodsList} ->
%% %%                             GoodsInfoList = 
%% %%                                 lists:map(fun(Goods) ->
%% %%                                                   {Goods#goods.id, Goods#goods.base_id, Goods#goods.str_lv}
%% %%                                           end, GoodsList),
%% %%                                 mod_h_log:log_twist_eggs(#log_twist_eggs{pid = Player#player.id, type = Type,
%% %%                                                count = Count, goodsinfo = GoodsInfoList}),
%% %%                             {ok, NewModPlayerSate2, UpdateGoodsList, AddAttFlagList}
%% %%                     end;            
%% %%                 _ ->
%% %%                     case Type of
%% %%                         ?COST_GOLD ->
%% %%                             {fail, ?ERROR_ONT_DIAMOND};
%% %%                         ?COST_FRIEND_VAL ->
%% %%                             {fail, ?ERROR_ONT_FRIENDPOINT}
%% %%                     end
%% %%             end
%% %%     end. 

%% %% 检查是否在活动期间
%% check_activity(ActivityType) ->
%%     case check_activity_date(ActivityType) of
%%         [] -> 
%%             false;
%%         [Activity] ->
%%             Activity#data_base_activity.value;
%%         Error ->
%%              ?WARNING_MSG("check_activity no match, activity = ~p~n", [Error]),
%%             false
%%     end.

%% %% 检查是否在活动期间进入副本关卡
%% check_activity(ActivityType, DungeonId) ->
%%     case check_activity_date(ActivityType) of
%%         [] ->
%%             false;
%%         [Activity] ->
%%             case lists:member(DungeonId, Activity#data_base_activity.range)of
%%                 false -> false;
%%                 true  ->
%%                     Activity#data_base_activity.value
%%             end;
%%         Error ->
%%             ?WARNING_MSG("check_activity no match, activity = ~p~n", [Error]),
%%             false
%%     end.

%% %% 登录显示活动列表
%% activity_list() ->
%%     ActivityList = data_base_activity:all(),
%%     lists:foldl(
%%         fun(Key, AccIn) ->
%%             Activity = data_base_activity:get(Key),
%%             [Head | Tail] = Activity#data_base_activity.req_time,
%%             case check_req_time([Head]) of
%%                 true ->
%%                     %% 表示全天活动
%%                     {Type, Time} = Head,
%%                     NoticeStartTime = Activity#data_base_activity.start_time + hmisctime:get_timestamp_of_today_start(),
%%                     NoticeEndTime   = Activity#data_base_activity.end_time + hmisctime:get_timestamp_of_today_start(), 
%%                     case Type of
%%                         3 ->
%%                             [StartTime, EndTime] = Time,
%%                             [{Activity#data_base_activity.id, 
%%                               Activity#data_base_activity.activity_desc,
%%                               Activity#data_base_activity.category,
%%                               StartTime, EndTime, 
%%                               hmisctime:get_today_current_second(),
%%                               Activity#data_base_activity.type,
%%                               Activity#data_base_activity.notice,
%%                               NoticeStartTime,
%%                               NoticeEndTime,
%%                               Activity#data_base_activity.interval} |  AccIn];
%%                         _ ->
%%                             case Tail of
%%                                 [] ->
%%                                     [{Activity#data_base_activity.id, 
%%                                       Activity#data_base_activity.activity_desc,
%%                                       Activity#data_base_activity.category,
%%                                       0, 86400, 
%%                                       hmisctime:get_today_current_second(),
%%                                       Activity#data_base_activity.type,
%%                                       Activity#data_base_activity.notice,
%%                                       NoticeStartTime,
%%                                       NoticeEndTime,
%%                                       Activity#data_base_activity.interval} |  AccIn];
%%                                 {_, [StartTime2, EndTime2]}  ->
%%                                      %% = Tail,
%%                                     [{Activity#data_base_activity.id, 
%%                                       Activity#data_base_activity.activity_desc,
%%                                       Activity#data_base_activity.category,
%%                                       StartTime2, EndTime2, 
%%                                       hmisctime:get_today_current_second(),
%%                                       Activity#data_base_activity.type,
%%                                       Activity#data_base_activity.notice,
%%                                       NoticeStartTime,
%%                                       NoticeEndTime,
%%                                       Activity#data_base_activity.interval} |  AccIn];
%%                                 OTHER ->
%%                                     ?WARNING_MSG("OTHER:~w~n",[OTHER]),
%%                                     AccIn
%%                             end
%%                     end;
%%                 false -> 
%%                     AccIn
%%             end

%%         end, [], ActivityList).
    

%% %% --------------------------------------------------------------------------
%% %% inner function
%% %% --------------------------------------------------------------------------

%% %% 获取扭蛋数据列表，如果在活动期间，就用活动扭蛋的配置表
%% %% 如果是正常扭蛋，那就是驾照扭蛋基础配置表
%% get_base_goods_list(Type) ->
%%     case Type of
%%         %% 元宝扭蛋
%%         ?COST_GOLD ->
%%             case check_activity(gold_twist_egg) of
%%                 false ->    
%%                     data_base_twist_egg:get_gold_twist();
%%                 _     ->
%%                     data_base_activity_twist_egg:get_gold_twist()
%%             end;
%%         %% 友情扭蛋           
%%         ?COST_FRIEND_VAL ->
%%             case check_activity(twist_egg) of
%%                 false ->    
%%                     data_base_twist_egg:get_friend_val_twist();
%%                 _     ->
%%                     data_base_activity_twist_egg:get_friend_val_twist()
%%             end;
%%         %% 特殊扭蛋           
%%         ?EXTRA_TWIST_EGG ->
%%             case check_activity(extra_twist_egg) of
%%                 false ->    
%%                     data_base_twist_egg:get_extra_twist_egg();
%%                 _     ->
%%                     data_base_activity_twist_egg:get_extra_twist_egg()
%%             end
%%     end.

%% %% 给斗魂添加属性
%% %% good_add_att(GoodsIds, NewPlayer) ->
%% %%     lists:foldl(fun(GoodsId, {EndFlag, Ret, AddAttFlagList}) ->
%% %%            case data_base_equipment:get_base_goods(GoodsId) of
%% %%                #ets_base_equipment{
%% %%                  } = BaseGoodsment when EndFlag =:= true ->
%% %%                    Goods = lib_goods:to_player_goods(BaseGoodsment, NewPlayer),
%% %%                    AddAttGoods = to_extra_att(Goods),
%% %%                    {NewGoods, _} = AddAttGoods,
%% %%                    {EndFlag, [NewGoods | Ret], [AddAttGoods | AddAttFlagList]};
%% %%                _ ->
%% %%                    {false, Ret, AddAttFlagList}
%% %%            end
%% %%     end, {true, [], []}, GoodsIds).

%% %% 计算扭蛋扣除
%% calc_cost(Type, Count) ->
%%     case Type of
%%         ?COST_GOLD ->
%%             GoldCost = case data_base_params:get_value_by_name(twist_egg_cost_gold) of
%%                            [] ->
%%                                30;
%%                            Value ->
%%                                Value
%%                        end,
%%             Cost =  
%%                 case Count =:= 10 of
%%                     true -> (Count * GoldCost) * 0.9;
%%                     false -> Count * GoldCost
%%                 end,
%%             {hmisc:ceil(Cost), ?GOODS_TYPE_GOLD};
%%         ?COST_FRIEND_VAL ->
%%             FriendCost = case data_base_params:get_value_by_name(twist_egg_cost_friend) of
%%                              [] ->
%%                                  200;
%%                              Value ->
%%                                  Value
%%                          end,
%%             Cost = Count * FriendCost,
%%             {hmisc:ceil(Cost), ?GOODS_TYPE_FRIENDPOINT}
%%     end.


%% %% 给扭出来的蛋添加附加属性
%% %% to_extra_att(Goods) ->
%% %%     %%检测扭出来的蛋是否有等级
%% %%     Lv = data_base_twist_egg:get(Goods#goods.base_id),
%% %%     NewGoods = 
%% %%         case Lv of
%% %%             0 -> Goods; 
%% %%             Value ->
%% %%                 Goods#goods{str_lv = Value}
%% %%         end,
%% %%         %% 判断是否有在活动期间，概率将发生改变
%% %%         BaseRate = 
%% %%             case check_activity(egg_add_att) of
%% %%                 false ->
%% %%                     data_base_rate:get(add_att);
%% %%                 _ ->
%% %%                     data_base_rate:get(activity_add_att)

%% %%             end,
%% %%         %% 随机 是否有+蛋， 0表示没有，1表示有
%% %%         Rate = hmisc:rand(BaseRate, ?RANDOM_BASE),
%% %%         case Rate of
%% %%             0 -> {NewGoods, 0}; 
%% %%             1 ->
%% %%                 %% 随机属性，1加成+1点血气， 2加成+1点攻击，3加成+1点防御
%% %%                 Rate2 = hmisc:rand(1,3),
%% %%                 case Rate2 of
%% %%                     1 ->
%% %%                         {NewGoods#goods{hp_extra = 1}, 1};
%% %%                     2 ->
%% %%                         {NewGoods#goods{attack_extra = 1}, 1};
%% %%                     3 ->
%% %%                         {NewGoods#goods{def_extra = 1}, 1}  
%% %%                 end
%% %%         end.

%% %% 检查是否在活动时间内     
%% check_req_time([]) -> 
%%     false;
%% check_req_time(Condition)->
%%     lists:foldl(
%%         %%星期为单位                 req_time = [{1, [1, 3, 5]}], 
%%         %%指定的开始日期和结束日期   req_time = [{2, [开始时间戳，开始时间戳]}],
%%         %%指定的开始时间和结束时间   req_time = [{3, [64800, 66600]}],
%%         %%14天周期，前7天开，后7天关 req_time = [{4, [始时间戳]}],
%%         fun({Type, Time}, AccIn)->
%%             case AccIn of
%%                 false -> false;
%%                 true ->
%%                     case Type of
%%                         ?DUNGEON_DAY -> 
%%                             NowWeekDay = hmisctime:get_week_day(),
%%                             lists:any(fun(Item) -> NowWeekDay =:= Item end, Time);
%%                         ?DUNGEON_DATE -> 
%%                             [StartedTime, EndedTime] = Time,
%%                             Now = hmisctime:unixtime(),
%%                             check_time(Now, StartedTime, EndedTime);
%%                         ?DUNGEON_TIME -> 
%%                             [StartedTime, EndedTime] = Time,
%%                             Now = hmisctime:get_today_current_second(),
%%                             check_time(Now, StartedTime, EndedTime);
%%                         ?DUNGEON_WEEK -> 
%%                             [StartedTime] = Time,
%%                             {Today, _Nextday} = hmisctime:get_midnight_seconds(hmisctime:unixtime()),
%%                             Day = hmisctime:get_days_passed(StartedTime, Today),
%%                             %% 计算公式 ((n-1)%14) /7 然后向下取整， 0表示开启，1表示关闭
%%                             State = ((Day-1) rem 14) /7,
%%                             case State of
%%                                 0 -> true;
%%                                 1 -> false
%%                             end
%%                     end 
%%             end
            
%%           end, true, Condition).     

%% check_time(Now, StartedTime, EndedTime) ->
%%     case (Now >= StartedTime) and (Now =< EndedTime) of
%%         true ->
%%             true;
%%         false ->
%%             false
%%     end.    


%% %% 检查是否在活动时间内
%% check_activity_date(Key) ->
%%     ActivityList = data_base_activity:all(),
%%     lists:foldl(
%%         fun(ActivityId, AccIn) ->
%%             Activity = data_base_activity:get(ActivityId),
%%             case (Activity#data_base_activity.key =:= Key) and
%%                  check_req_time(Activity#data_base_activity.req_time) of
%%                 true  ->
%%                     [Activity | AccIn];
%%                 false ->
%%                     AccIn
%%             end 
%%         end, [], ActivityList).
