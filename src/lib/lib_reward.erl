
%% @doc 奖励领取模块
%% @spec
%% @end

-module(lib_reward).

-export([
         to_reward_item_list/1,
         take_reward/3,
         take_reward/4,
         take_reward_direct/3,
         convert_common_reward/1,
         generate_reward_list/1,
         common_reward_to_mail_reward/1,
         merge_same_goods/1,
         get_online_gift_timestamp/1,
         is_today_check_in/1,
         %% get_pvp_win_rewards/0,
         %% get_pvp_loss_rewards/0,
         get_pvp_rewards/2
        ]).

-include("define_logger.hrl").
-include("define_money_cost.hrl").
-include("pb_15_pb.hrl").
-include("define_info_15.hrl").
-include("define_info_13.hrl").
-include("define_reward.hrl").
-include("define_goods_type.hrl").
-include("define_player.hrl").
-include("define_mail.hrl").

%% 将策划配表转换为指定结构
convert_common_reward(RewardList) ->
    lists:map(fun inner_reward_normalize/1, RewardList).

%% @doc 根据概率生成串
%% @spec
%% @end
generate_reward_list([]) ->
    [];
generate_reward_list([{_, _}|_] = RewardList) ->
    RewardGetList = hmisc:rand(RewardList),
    %%?DEBUG("RewardGetList ~p~n", [RewardGetList]),
    generate_reward_list2(RewardGetList);
generate_reward_list([List|_] = RewardList) when is_list(List) ->
    generate_reward_list2(RewardList).

generate_reward_list2([]) ->
    [];
generate_reward_list2([#common_reward{}|_] = RewardList) ->
    [inner_generate_reward(RewardList)]; 
generate_reward_list2([List|_] = RewardList) 
  when is_list(List) ->  %%奖励结构是[[reward1, reward2],[],[]].....这种 每个内的list根据概率随机出一个，最后是[reward1,reward2...]这样
    Generated = lists:map(fun inner_generate_reward/1, RewardList), %%掉落的物品list
    %%?DEBUG("~p~n", [Generated]),
    generate_reward_list3(Generated).

generate_reward_list3(Generated) ->
    lists:filter(fun(Reward) 
                       when is_record(Reward, common_reward) ->
                         true;
                    (_) ->
                         false
                 end, Generated).

%% 将#common_reward计算为reward_item
to_reward_item_list([]) ->
    [];
to_reward_item_list(CommonRewardList)
  when is_list(CommonRewardList) ->
    {PowerRewards, NormalRewards} = 
        lists:partition(fun(#common_reward{type = RewardType}) ->
                                if
                                    RewardType =/= 
                                    ?COMMON_REWARD_TYPE_POWER_RATE ->
                                        %% 非权值奖励与其它奖励分离
                                        false;
                                    true -> 
                                        true
                                end
                        end, CommonRewardList),
    %%[{Reward1, Reward2}] 权值取一个， common_reward中type =:= 2的
    PowerRand = lists:map(fun(#common_reward{
                                 rate      = Rate,
                                 goods_id  = GoodsId,
                                 goods_sum = GoodsSum
                                }) ->
                                  {#reward_item{id       = 1,
                                                num      = GoodsSum,
                                                goods_id = GoodsId
                                               }, Rate}
                          end, PowerRewards),
    NewPowerReward = case hmisc:rand(PowerRand) of
                         [] -> 
                             [];
                         #reward_item{} = Item ->
                             [Item]
                     end,
    ?DEBUG("NewPowerReward : ~w~n",[NewPowerReward]),
    {_, NewNormalRewards} = 
        lists:foldl(
          fun(#common_reward{type        = RewardType,
                             rate        = Rate,
                             goods_id    = GoodsId,
                             goods_sum   = GoodsSum
                            } = CommonReward, {N, RewardList}) ->
                  case RewardType of
                      %% 固定奖励
                      ?COMMON_REWARD_TYPE_FIX ->
                          Reward = #reward_item{
                                      id       = N,
                                      num      = GoodsSum,
                                      goods_id = GoodsId
                                     },
                          {N+1, RewardList ++ [Reward]};
                      %% 概率奖励
                      ?COMMON_REWARD_TYPE_RATE ->
                          RandNum	= hmisc:rand(1, 10000),
                          if
                              RandNum < Rate -> 
                                  Reward = #reward_item{
                                              id       = N,
                                              goods_id = GoodsId,
                                              num      = GoodsSum},
                                  {N+1, RewardList ++ [Reward]};
                              true -> 
                                  {N,RewardList}
                          end;
                      _ ->
                          ?WARNING_MSG("Unknown CommonReward:~w~n",[CommonReward]),
                          {N,RewardList}
                  end
          end, {2, []}, NormalRewards),
    ?DEBUG("CommonRewardList : ~p, NewPowerReward : ~w , NormalRewards : ~w ~n",[CommonRewardList, NewPowerReward, NewNormalRewards]),
    NewPowerReward ++ NewNormalRewards;
to_reward_item_list(OTHER) ->
    ?WARNING_MSG("Unkonw CommonRewardList:~w~n",[OTHER]),
    [].

%%这个主要是合并了generate_reward_list和take_reward
take_reward_direct(ModPlayerState, RewardList, LogType) ->
    ?DEBUG("take_reward_direct, RewardList : ~p~n",[RewardList]),
    RewardGet = generate_reward_list(RewardList),
    ?DEBUG("take_reward_direct, RewardGet : ~p~n",[RewardGet]),
    take_reward(ModPlayerState, RewardGet, LogType).

%%多个接口合并在这里了，包括过滤0的id，转换职业的武器
reward_part_list(Career, RewardList) ->
    lists:foldl(
      fun({GoodsId, Num, _Bind} = Item, {SpecialList, GoodsList}) ->
              if
                  GoodsId =:= 0 ->
                      {SpecialList, GoodsList};
                  Num =:= 0 ->
                      {SpecialList, GoodsList};
                  GoodsId < ?GOODS_TYPE_GOODS ->
                      {[Item|SpecialList], GoodsList};
                  true ->
                      case may_transform_goods(Career, Item) of
                          [] ->
                              {SpecialList, GoodsList};
                          CareerItem ->
                              {SpecialList, [CareerItem|GoodsList]}
                              %% {SpecialList, [may_transform_goods(Career, Item)|GoodsList]}
                      end
              end
      end, {[], []}, RewardList).

may_transform_goods(Career, {GoodsId, GoodsSum, Bind}) ->
    case data_base_goods:get(GoodsId) of
        #base_goods{type = ?TYPE_GOODS_UNUSED} ->
            [];
        #base_goods{career = OCareer} 
          when OCareer =:= 0 orelse OCareer =:= Career ->
            {GoodsId, GoodsSum, Bind};
        _ ->
            []
    end.
%% may_transform_goods(_, {GoodsId, _, _} = Item) when GoodsId < ?WEAPON_ID_COUNT ->
%%     Item;
%% may_transform_goods(Career, {GoodsId, GoodsSum, Bind}) ->
%%     case GoodsId div ?WEAPON_ID_PART of
%%         RetId 
%%           when RetId =:= ?WEAPON_MAIL orelse RetId =:= ?WEAPON_IORIS ->
%%             {transform_career_goods(GoodsId, RetId, Career), GoodsSum, Bind};
%%         _ ->
%%             {GoodsId, GoodsSum, Bind}
%%     end.

%% transform_career_goods(GoodsId, RetId, Career) ->
%%     Rem = GoodsId - RetId * ?WEAPON_ID_PART,
%%     (RetId div 10 * 10 + Career) * ?WEAPON_ID_PART + Rem.
            

take_reward(ModPlayerState, RewardList, LogType) ->
    inner_take_reward(ModPlayerState, RewardList, LogType, false).

take_reward(ModPlayerState, RewardList, LogType, Flag) ->
    inner_take_reward(ModPlayerState, RewardList, LogType, Flag).


inner_take_reward(ModPlayerState, [], _LogType, _)  ->
    {ok, ModPlayerState};
inner_take_reward(ModPlayerState, RewardList, LogType, Flag) when is_list(RewardList) ->
    inner_take_reward2(ModPlayerState, lists:map(fun
                                                     (#common_reward{goods_id = GoodsId,
                                                                     goods_sum = GoodsSum,
                                                                     bind = Bind}) ->
                                                        {GoodsId, GoodsSum, Bind};
                                                     ({GoodsId, GoodsSum, Bind}) ->
                                                        {GoodsId, GoodsSum, Bind};
                                                     ({GoodsId, GoodsSum}) ->
                                                        {GoodsId, GoodsSum, ?GOODS_NOT_BIND};
                                                     (#reward_item{goods_id = GoodsId,
                                                                   num = GoodsSum
                                                                  })->
                                                        {GoodsId, GoodsSum, ?GOODS_NOT_BIND}
                                                end, RewardList), LogType, Flag).

inner_take_reward2(#mod_player_state{
                      player = Player
                     } = ModPlayerState, [{_, _, _} | _] = RewardList, LogType, Flag) ->
    {SpecialList, GoodsList} = reward_part_list(Player#player.career, RewardList),   
    ?DEBUG("SpecialList ~p, GoodsList ~p~n", [SpecialList, GoodsList]),
    case inner_take_special_reward(Player, SpecialList, LogType) of
        {fail, Reason} ->
            {fail, Reason};
        NPlayer ->
            NModPlayerState = ModPlayerState#mod_player_state{player = NPlayer},
            pack_reward(SpecialList ++ GoodsList, Flag),
            %% 发放物品奖励
            {Add, UpdatedGoods, NewGoodsList} = lib_goods:add_goods_list(NModPlayerState?PLAYER_ID, NModPlayerState#mod_player_state.bag, GoodsList),
            %% NAdd = lib_goods:set_fashion_container(Add),
            {NewAdd, NewPlayer} = may_over_float(Add, NPlayer),
            pt_15:pack_goods(NewAdd, UpdatedGoods, []),
            {ok, NewModPlayerState} = lib_player:update_skill_record(NModPlayerState, NewAdd, UpdatedGoods),
            {ok, NewModPlayerState#mod_player_state{bag = NewGoodsList,
                                                    player = NewPlayer}}
    end.

pack_reward(_, false) ->
    skip;
pack_reward(RewardList, Type) ->
    {ok, Bin} = pt_15:write(15500, {RewardList, Type}),
    packet_misc:put_packet(Bin).

%% 特殊物品奖励
inner_take_special_reward(Player, [], _LogType) ->
    Player;
inner_take_special_reward(Player, [{Id, Sum, _Bind}|Tail], LogType) ->
    case lib_player:add_money(Player, Sum, Id, LogType) of
        {fail, Reason} ->
            {fail, Reason};
        NewPlayer ->
            inner_take_special_reward(NewPlayer, Tail, LogType)
    end.


get_online_gift_timestamp(_Player) ->
    ok.
    
common_reward_to_mail_reward(CommonRewardList) ->
    conver_to_mail_item(to_reward_item_list(CommonRewardList)).


conver_to_mail_item(RewardItemList) ->
    lists:map(fun(RewardItem) ->
                      {RewardItem#reward_item.goods_id, 
                       RewardItem#reward_item.num, 
                       RewardItem#reward_item.bind}
              end, RewardItemList).

%%--------------------------------------------------------------------
%% @doc
%% 合并相同的物品
%% @spec
%% @end
%%--------------------------------------------------------------------
merge_same_goods(RewardList) ->
    ?DEBUG("Origin Reward List~p~n", [RewardList]),
    lists:foldl(fun(RewardItem, ResultList) ->                       
                        inner_add_good(RewardItem, ResultList)
                end, [], RewardList).
%%--------------------------------------------------------------------
%% @doc
%% 在结果列表那里累加上物品的num，否在就添加新的这个物品
%% @spec
%% @end
%%--------------------------------------------------------------------
inner_add_good(#reward_item{
                 id = _Id_1,
                 goods_id = _GoodsId_1,
                 num = Num_1
                },
               [#reward_item{
                  id = _Id_2,
                  goods_id = _GoodsId_1,
                  num = Num_2
                 }=Item |RestResultList]) ->
    [Item#reward_item{num = Num_2 + Num_1} | RestResultList];
inner_add_good(RewardItem, [Item | RestResultList]) ->
    [Item | inner_add_good(RewardItem, RestResultList)];
inner_add_good(RewardItem, []) ->
    [RewardItem].

%%--------------------------------------------------------------------
%% @doc 今天是否签到 0表示今天没有签到，1表示今天已经签到
%% @spec
%% @end
%%--------------------------------------------------------------------
is_today_check_in(CheckInTimestamp) ->
    Now = time_misc:unixtime(),
    case time_misc:is_same_day(CheckInTimestamp, Now) of
        true ->
            1;
        false ->
            0
    end.


%% 概率配置信息标准化
inner_reward_normalize(CommonRewardList)
  when is_list(CommonRewardList) ->
    lists:map(fun inner_reward_normalize/1, CommonRewardList);
inner_reward_normalize(
  {Type, Rate, GoodsId, GoodsSum, Bind, Value2, Value3}) ->
    #common_reward{
       type        = Type,
       rate        = Rate,
       goods_id    = GoodsId,
       goods_sum   = GoodsSum,
       bind        = Bind,
       float       = Value2,
       value3      = Value3
      };
inner_reward_normalize(Other) ->
    ?WARNING_MSG("Config error : CommonReward : ~w~n", [Other]),
    #common_reward{
       type        = 0,
       rate        = 0,
       goods_id    = ?GOODS_TYPE_COIN,
       goods_sum   = 8,
       bind        = 0,
       float       = 0,
       value3      = 0
      }.

%% @doc 生成奖励信息
%% @spec
%% @end
inner_generate_reward(RewardList)
  when is_list(RewardList) ->
    Generated =
        lists:map(
          fun(#common_reward{rate = Rate} = Reward) ->
                  NewReward = inner_float_reward(Reward),
                  {NewReward, Rate}
          end, RewardList),
    %%?DEBUG("try to rand Generated ~p~n", [Generated]),
    hmisc:rand(Generated, ?RANDOM_BASE);
inner_generate_reward(Other) ->
    ?WARNING_MSG("~p not a list~n", [Other]),
    [].

%%奖励要做浮动
inner_float_reward(#common_reward{goods_sum = Sum,
                                  float = Float} = Reward) ->
    NewSum = hmisc:rand(Sum - Float, Sum + Float),
    if
        NewSum < 0 ->
            Reward#common_reward{goods_sum = 0};
        true ->
            Reward#common_reward{goods_sum = NewSum}
    end.

may_over_float(GoodsList, #player{
                             id = PlayerId,
                             bag_cnt = BagCnt,
                             bag_limit = BagLimit} = Player) ->
    AddNum = 
        if
            BagCnt >= BagLimit ->
                0;
            true ->
                BagLimit - BagCnt
        end,
    {Add, Rest} = list_misc:sublist(GoodsList, AddNum),
    send_mail(PlayerId, Rest),
    {Add, Player#player{bag_cnt = BagCnt + length(Add)}}.

send_mail(_, []) ->
    skip;
send_mail(PlayerId, GoodsList) ->
    lists:foreach(fun(#goods{base_id = BaseId,
                             sum = Sum}) ->
                          Mail = lib_mail:mail(?SYSTEM_NAME, <<"背包已满"/utf8>>, <<"">>, [{BaseId, Sum}]),
                          lib_mail:send_mail(PlayerId, Mail)
                  end, GoodsList).  

%% get_pvp_win_rewards() ->
%%     [{?GOODS_TYPE_COMBAT_POINT, 20}].
%% get_pvp_loss_rewards() ->
%%     [{?GOODS_TYPE_COMBAT_POINT, 8}].

get_pvp_rewards(league_pvp_sigle, win) ->
    [{?GOODS_TYPE_COMBAT_POINT, 50}];
get_pvp_rewards(league_pvp_sigle, loss) ->
    [];
get_pvp_rewards(league_pvp_point, win) ->
    [{?GOODS_TYPE_COMBAT_POINT, 100}];
get_pvp_rewards(league_pvp_point, loss) ->
    [];
get_pvp_rewards(_, win) ->
    [{?GOODS_TYPE_COMBAT_POINT, 20}];
get_pvp_rewards(_, loss) ->
    [].




