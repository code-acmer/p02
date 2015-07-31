-module(lib_choujiang).

-export([login_choujiang_info/1,
         save_choujiang_info/1,
         reset_choujiang_info/1,
         get_choujiang_result/2
        ]).

-include("define_player.hrl").
-include("define_goods.hrl").
-include("define_logger.hrl").
-include("define_goods_type.hrl").
-include("define_money_cost.hrl").
-include("db_base_choujiang.hrl").
-include("db_base_qianguizhe.hrl").
-include("pb_13_pb.hrl").
-include("pb_15_pb.hrl").
-include("define_info_15.hrl").
-include("define_time.hrl").
-include("define_task.hrl").
-include("define_log.hrl").

login_choujiang_info(PlayerId) ->
    case hdb:dirty_read(choujiang_info, PlayerId, true) of
        #choujiang_info{} = ChoujiangInfo ->
            ChoujiangInfo;
        _ ->
            dirty_choujiang_info(#choujiang_info{
                                    player_id = PlayerId
                                   })
    end.

save_choujiang_info(ChoujiangInfo) 
  when is_record(ChoujiangInfo, choujiang_info) ->
    hdb:save(ChoujiangInfo, #choujiang_info.is_dirty).

reset_choujiang_info(ChoujiangInfo) ->
    dirty_choujiang_info(ChoujiangInfo#choujiang_info{
                           coin_free_num = 0
                          }).

dirty_choujiang_info(ChoujiangInfo) 
  when is_record(ChoujiangInfo, choujiang_info) ->
    ChoujiangInfo#choujiang_info{
      is_dirty = 1
     }.

%---------------------------------------------------------------------

%%扭蛋 构造EggList [{{Id, IsValuable}, weigth}, ... ]
twist_egg(Num, Type, IdList) ->
    EggList = get_egg_list(Type, IdList),
    get_rand_list(EggList, Num).


get_egg_list([], _) ->
    [];
get_egg_list(?TWIST_EGG_COMMON_COIN, IdList) ->
    lists:foldl(fun(Id, AccList)->
                        #base_choujiang{
                           goods_id = GoodsId,
                           goods_num = GoodsNum,
                           coin_weight = Weigth,
                           is_valuable = IsValuable
                          } = data_base_choujiang:get(Id),
                        Tuple = {{{GoodsId, GoodsNum}, IsValuable}, Weigth},
                        [Tuple | AccList]
                end, [], IdList);

get_egg_list(?TWIST_EGG_COMMON_GOLD, IdList) ->
    lists:foldl(fun(Id, AccList)->
                        #base_choujiang{
                           goods_id = GoodsId,
                           goods_num = GoodsNum,
                           gold_weight = Weigth,
                           is_valuable = IsValuable
                          } = data_base_choujiang:get(Id),
                        Tuple = {{{GoodsId, GoodsNum}, IsValuable}, Weigth},
                        [Tuple | AccList]
                end, [], IdList);

get_egg_list(?TWIST_EGG_SPECIAL, IdList) ->
    lists:foldl(fun(Id, AccList)->
                        #base_qianguizhe{
                           goods_id = GoodsId,
                           goods_num = GoodsNum,
                           weight = Weigth
                          } = data_base_qianguizhe:get(Id),
                        Tuple = {{GoodsId, GoodsNum}, Weigth},
                        [Tuple | AccList]
                end, [], IdList).

get_rand_list(List, RandNum)->
    hmisc:rand_n_p_r(RandNum, List).

comman_twist_egg(#player{
                    lv = PlayerLv,
                    career = Career,
                    vip = Vip
                   }, Num, TwistEggCommonMoneyType)->
    Lv = (PlayerLv + 9) div ?CHOUJIANG_LV_OFF,
    IdList1 = data_base_choujiang:get_id_by_lv_career_vip({Lv*?CHOUJIANG_LV_OFF, 0, Vip}),
    IdList2 = data_base_choujiang:get_id_by_lv_career_vip({Lv*?CHOUJIANG_LV_OFF, Career, Vip}),
    ?DEBUG("comman_twist_egg PlayerLv: ~p, Career: ~p, Vip: ~p, IdList: ~p", [PlayerLv, Career, Vip, IdList1 ++ IdList2]),
    twist_egg(Num, TwistEggCommonMoneyType, IdList1 ++ IdList2). 

special_twist_egg(#player{
                     career = Career
                    } = Player, Num, SpecialType)->  %SpecialType 分 金币首抽、金币十连抽（保底抽）、钻石首抽、钻石十连抽（保底抽）
    IdList1 = data_base_qianguizhe:get_id_by_type_career({SpecialType, 0}),
    IdList2 = data_base_qianguizhe:get_id_by_type_career({SpecialType, Career}),
    ?DEBUG("special_twist_egg PlayerLv: ~p, Career: ~p, SpecialType: ~p, IdList: ~p", [Player#player.lv, Career, SpecialType, IdList1 ++ IdList2]),
    ?DEBUG("IdList : ~p", [IdList1 ++ IdList2]),
    twist_egg(Num, ?TWIST_EGG_SPECIAL, IdList1 ++ IdList2).

%%扭蛋业务--------------------------------------
get_choujiang_result(ModPlayerState, #pbchoujiang{
                                        money_type = MoneyType,
                                        buy_num = BuyNum
                                       } = PbChoujiang) ->
    case get_choujiang_result2(ModPlayerState, PbChoujiang) of
        {fail, Reason} ->
            {fail, Reason};
        {ok, NewModPlayerState, GoodsListInfo} ->
            NModPlayerState = do_choujiang_task(NewModPlayerState, MoneyType, BuyNum),
            {ok, NModPlayerState, GoodsListInfo}
    end.

do_choujiang_task(ModPlayerState, MoneyType, BuyNum) 
  when MoneyType =:= ?CHOUJIANG_COIN_IS_FREE orelse MoneyType =:= ?CHOUJIANG_COIN_NO_FREE ->
    lib_task:task_event(ModPlayerState, {?TASK_FUNTION, ?TASK_FUNTION_COIN_LOTTERY, BuyNum});
do_choujiang_task(ModPlayerState, MoneyType, BuyNum)
  when MoneyType =:= ?CHOUJIANG_GOLD_IS_FREE orelse MoneyType =:= ?CHOUJIANG_GOLD_NO_FREE ->
    lib_task:task_event(ModPlayerState, {?TASK_FUNTION, ?TASK_FUNTION_GOLD_LOTTERY, BuyNum});
do_choujiang_task(ModPlayerState, _, _) ->
    ModPlayerState.

get_choujiang_result2(#mod_player_state{
                         choujiang_info = #choujiang_info{
                                             is_coin_first = IsCoinFirst,
                                             is_gold_first = IsGoldFirst
                                            }
                        } = ModPlayerState, #pbchoujiang{
                                               money_type = MoneyType,
                                               buy_num = BuyNum,
                                               is_free = IsFree
                                              })->
    ?DEBUG("IsCoinFirst: ~p, IsGoldFirst: ~p, MoneyType: ~p, BuyNum: ~p, IsFree: ~p", [IsCoinFirst, IsGoldFirst, MoneyType, BuyNum, IsFree]),
    case IsFree of  %是否想免费抽
        ?CHOUJIANG_IS_FREE -> %免费
            case MoneyType of  %金币抽还是钻石抽 
                ?CHOUJIANG_COIN_IS_FREE -> %金币类型免费
                    case IsCoinFirst of
                        0 -> %金币第一次免费时走潜规则
                            ?WARNING_MSG("get_choujiang_coin_first..."),
                            get_choujiang_coin_first(ModPlayerState); % 金币免费首抽
                        _ ->
                            get_coin_free(ModPlayerState)
                    end;
                ?CHOUJIANG_GOLD_IS_FREE -> %钻石类型免费
                    case IsGoldFirst of
                        0 -> %钻石第一次免费时走潜规则
                            get_choujiang_gold_first(ModPlayerState); % 钻石免费首抽
                        _ ->
                            get_gold_free(ModPlayerState)
                    end                    
            end;
        ?CHOUJIANG_NO_FREE -> %收费
            case MoneyType of  %金币抽还是钻石抽 
                ?CHOUJIANG_COIN_NO_FREE -> %金币类型收费
                    case BuyNum of
                        ?CHOUJIANG_NUM_ONE -> %收费抽一次
                            lib_log_player:log_system({ModPlayerState?PLAYER_ID, ?LOG_GAMBLE_COIN, 1, 0, 0}),
                            get_choujiang_coin_one(ModPlayerState);
                        ?CHOUJIANG_NUM_TEN ->%十连抽
                            lib_log_player:log_system({ModPlayerState?PLAYER_ID, ?LOG_GAMBLE_COIN_TEN, 1, 0, 0}),
                            get_choujiang_coin_ten(ModPlayerState)
                    end;
                ?CHOUJIANG_GOLD_NO_FREE -> %钻石类型收费
                    case BuyNum of
                        ?CHOUJIANG_NUM_ONE -> %收费抽一次
                            %% case IsGoldFirst of
                            %%     0 -> %钻石第一次收费时走潜规则
                            %%         get_choujiang_gold_first(ModPlayerState); % 钻石付费首抽
                            %%     _ ->
                            lib_log_player:log_system({ModPlayerState?PLAYER_ID, ?LOG_GAMBLE_GOLD, 1, 0, 0}),
                            get_choujiang_gold_one(ModPlayerState);
                        %% end;
                        ?CHOUJIANG_NUM_TEN -> %十连抽
                            lib_log_player:log_system({ModPlayerState?PLAYER_ID, ?LOG_GAMBLE_GOLD_TEN, 1, 0, 0}),
                            get_choujiang_gold_ten(ModPlayerState)
                    end
            end
    end.

get_choujiang_gold_first(#mod_player_state{
                            player = Player,
                            choujiang_info = ChoujiangInfo
                           } = ModPlayerState) ->
    %% case lib_player:cost_money(Player, ?COST_GOLD_CHOUJIANG_ONE, ?GOODS_TYPE_GOLD, ?CHOUJIANG_FIRST_GOLD) of 
    %%     {fail, Reason} ->
    %%           ?DEBUG("first gold choujiang fail! PlayerId: ~p, Reason: ~p", [Player#player.id, Reason]),
    %%         {fail, Reason};
    %%     {ok, NPlayer} ->
    %%case special_twist_egg(NPlayer, ?CHOUJIANG_NUM_ONE, ?GOLD_TWIST_EGG_FIRST) of
           
    case special_twist_egg(Player, ?CHOUJIANG_NUM_ONE, ?GOLD_TWIST_EGG_FIRST) of
        [] ->
            {fail, ?INFO_CONF_ERR};
        [{GoodsId, GoodsNum}] ->
            ?DEBUG("first gold choujiang success! PlayerId: ~p, GoodsId: ~p, GooodsNum: ~p", [Player#player.id, GoodsId, GoodsNum]),
            {ok, NModPlayerState} = lib_reward:take_reward(ModPlayerState#mod_player_state{
                                                %player = NPlayer, 
                                                             choujiang_info = dirty_choujiang_info(ChoujiangInfo#choujiang_info{
                                                                                                     is_gold_first = 1,
                                                                                                     gold_timestamp = time_misc:unixtime()                                  
                                                                                                    })
                                                            }, [{GoodsId, GoodsNum}], ?CHOUJIANG_FIRST_GOLD),
            {ok, NModPlayerState, [{GoodsId, GoodsNum}]}
    end.
    %% end.

get_choujiang_coin_first(#mod_player_state{
                            player = Player,
                            choujiang_info = ChoujiangInfo
                           } = ModPlayerState) ->
    case special_twist_egg(Player, ?CHOUJIANG_NUM_ONE, ?COIN_TWIST_EGG_FIRST) of
        [] ->
            ?DEBUG("first coin choujiang fail! PlayerId: ~p, Reason: ~p", [Player#player.id, ?INFO_CONF_ERR]),
            {fail, ?INFO_CONF_ERR};
        [{GoodsId, GoodsNum}] ->
            ?DEBUG("first coin choujiang success! PlayerId: ~p, GoodsId: ~p, GooodsNum: ~p", [Player#player.id, GoodsId, GoodsNum]),
            TimeStamp = time_misc:unixtime(),
            CoinFreeNum = ChoujiangInfo#choujiang_info.coin_free_num,
            {ok, NModPlayerState} = 
                lib_reward:take_reward(ModPlayerState#mod_player_state{
                                         choujiang_info = dirty_choujiang_info(ChoujiangInfo#choujiang_info{
                                                                                 coin_timestamp = TimeStamp,
                                                                                 coin_free_num = CoinFreeNum + 1,
                                                                                 is_coin_first = 1
                                                                                })
                                        }, [{GoodsId, GoodsNum}], ?CHOUJIANG_FIRST_COIN),
            {ok, NModPlayerState, [{GoodsId, GoodsNum}]}
    end.

get_coin_free(#mod_player_state{
                 player = Player,
                 choujiang_info = ChoujiangInfo
                }=ModPlayerState) ->
    case check_coin_free(ChoujiangInfo) of 
        {fail, Reason} ->
            ?DEBUG("coin free choujiang Fail! PlayerId: ~p, Reason: ~p", [Player#player.id, Reason]),
            {fail, Reason};
        {ok, TimeStamp, FreeNum} ->
            case comman_twist_egg(Player, ?CHOUJIANG_NUM_ONE, ?TWIST_EGG_COMMON_COIN) of 
                [] ->
                    {fail, ?INFO_CONF_ERR};
                [{{GoodsId, GoodsNum}, _IsValuable}] ->
                    ?DEBUG("coin free choujiang success! PlayerId: ~p, GoodsId: ~p, GooodsNum: ~p", [Player#player.id, GoodsId, GoodsNum]),
                    {ok, NModPlayerState} = lib_reward:take_reward(ModPlayerState, [{GoodsId, GoodsNum}], ?CHOUJIANG_FREE_COIN),
                    {ok, NModPlayerState#mod_player_state{
                           choujiang_info = dirty_choujiang_info(ChoujiangInfo#choujiang_info{
                                                                   coin_timestamp = TimeStamp,
                                                                   coin_free_num = FreeNum
                                                                  })
                          }, [{GoodsId, GoodsNum}]}
            end
    end.

check_coin_free(#choujiang_info{
                   coin_timestamp = CoinTimeStamp,
                   coin_free_num = CoinFreeNum
                  }) ->
    ?DEBUG("CoinFreeNum: ~p", [CoinFreeNum]),
    case CoinFreeNum < ?COIN_FREE_NUM_MAX of
        false ->
            {fail, ?INFO_CHOUJIANG_FREE_NUM_LIMIT};
        true ->
            TimeStamp = time_misc:unixtime(),
            %case TimeStamp - ?FIVE_MINITE_SECONDS >= CoinTimeStamp of
            case TimeStamp - ?COIN_FREE_TIME >= CoinTimeStamp of
                false ->
                    {fail, ?INFO_CHOUJIANG_FREE_TIME_LIMIT};
                true ->
                    {ok, TimeStamp, CoinFreeNum+1}
            end
    end.

get_gold_free(#mod_player_state{
                 player = Player,
                 choujiang_info = ChoujiangInfo
                }=ModPlayerState) ->
    case check_gold_free(ChoujiangInfo) of 
        {fail, Reason} ->
            ?DEBUG("gold free choujiang Fail! PlayerId: ~p , Reason: ~p", [Player#player.id, Reason]),
            {fail, Reason};
        {ok, TimeStamp} ->            
            case comman_twist_egg(Player, ?CHOUJIANG_NUM_ONE, ?TWIST_EGG_COMMON_GOLD) of
                [] ->
                    {fail, ?INFO_CONF_ERR};
                [{{GoodsId, GoodsNum}, _IsValuable}] ->
                    ?DEBUG("gold free choujiang success! PlayerId: ~p, GoodsId: ~p, GooodsNum: ~p", [Player#player.id, GoodsId, GoodsNum]),
                    {ok, NModPlayerState} = lib_reward:take_reward(ModPlayerState, [{GoodsId, GoodsNum}], ?CHOUJIANG_FREE_GOLD),
                    {ok, NModPlayerState#mod_player_state{
                           choujiang_info = dirty_choujiang_info(ChoujiangInfo#choujiang_info{
                                                                   gold_timestamp = TimeStamp
                                                                  })
                          }, [{GoodsId, GoodsNum}]}
            end
    end.

check_gold_free(#choujiang_info{
                   gold_timestamp = GoldTimeStamp
                  }) ->
    TimeStamp = time_misc:unixtime(),
    %case TimeStamp - ?ONE_DAY_SECONDS*3 >= GoldTimeStamp of
    case TimeStamp - ?GOLD_FREE_TIME >= GoldTimeStamp of
        false ->
            {fail, ?INFO_CHOUJIANG_FREE_TIME_LIMIT};
        true ->
            {ok, TimeStamp}
    end.

get_choujiang_coin_one(#mod_player_state{
                          player = Player
                         } = ModPlayerState)->
    case lib_player:cost_money(Player, ?COST_COIN_CHOUJIANG_ONE, ?GOODS_TYPE_COIN, ?COST_CHOUJIANG_COIN_ONE) of 
        {fail, Reason} ->
            ?DEBUG("coin one choujiang Fail! PlayerId: ~p , Reason: ~p", [Player#player.id, Reason]),
            {fail, Reason};
        {ok, NPlayer} ->
            case comman_twist_egg(NPlayer, ?CHOUJIANG_NUM_ONE, ?TWIST_EGG_COMMON_COIN) of 
                [] ->
                    {fail, ?INFO_CONF_ERR};
                [{{GoodsId, GoodsNum}, _IsValuable}] ->
                    ?DEBUG("coin one choujiang success! PlayerId: ~p, GoodsId: ~p, GooodsNum: ~p", [Player#player.id, GoodsId, GoodsNum]),
                    {ok, NModPlayerState} = 
                        lib_reward:take_reward(ModPlayerState#mod_player_state{
                                                 player = NPlayer
                                                }, [{GoodsId, GoodsNum}], ?COST_CHOUJIANG_COIN_ONE),
                    {ok, NModPlayerState, [{GoodsId, GoodsNum}]}
            end
    end.

get_choujiang_gold_one(#mod_player_state{
                          player = Player
                         } = ModPlayerState)->
    case lib_player:cost_money(Player, ?COST_GOLD_CHOUJIANG_ONE, ?GOODS_TYPE_GOLD, ?COST_CHOUJIANG_COIN_ONE) of 
        {fail, Reason} ->
            ?DEBUG("gold one choujiang Fail! PlayerId: ~p , Reason: ~p", [Player#player.id, Reason]),
            {fail, Reason};
        {ok, NPlayer} ->
            case comman_twist_egg(NPlayer, 1, ?TWIST_EGG_COMMON_GOLD) of 
                [] ->
                    {fail, ?INFO_CONF_ERR};
                [{{GoodsId, GoodsNum}, IsValuable}] ->
                    GoldChoujiangNum = NPlayer#player.gold_choujiang_num,
                    if 
                        IsValuable =:= 5 ->
                            ?WARNING_MSG("gold one choujiang success! PlayerId: ~p, GoodsId: ~p, GooodsNum: ~p", [Player#player.id, GoodsId, GoodsNum]),
                            {ok, NModPlayerState} = 
                                lib_reward:take_reward(ModPlayerState#mod_player_state{
                                                         player = NPlayer#player{ gold_choujiang_num = 0 }
                                                        }, [{GoodsId, GoodsNum}], ?COST_CHOUJIANG_COIN_ONE),
                            {ok, NModPlayerState, [{GoodsId, GoodsNum}]};
                        true ->
                            ?DEBUG("IsValuable == 1"),
                            case check_gold_choujiang_num(NPlayer, ?CHOUJIANG_NUM_ONE) of
                                false ->
                                    ?DEBUG("false"),
                                    GoldChoujiangNum = NPlayer#player.gold_choujiang_num,
                                    {ok, NModPlayerState} = 
                                        lib_reward:take_reward(ModPlayerState#mod_player_state{
                                                                 player = NPlayer#player{
                                                                            gold_choujiang_num = GoldChoujiangNum + 1
                                                                           }
                                                                }, [{GoodsId, GoodsNum}], ?COST_CHOUJIANG_COIN_ONE),
                                    {ok, NModPlayerState, [{GoodsId, GoodsNum}]};
                                true -> %% 五星卡保底抽
                                    case special_twist_egg(NPlayer, ?CHOUJIANG_NUM_ONE, ?GOLD_TWIST_EGG_GOLD_NUM) of %% 前 9 次中没有抽到贵重物品，则进入潜规则中抽奖
                                        [] ->
                                            {fail, ?INFO_CONF_ERR};
                                        [{NGoodsId, NGoodsNum}] ->
                                            ?WARNING_MSG("special choujiang gold .......... GoodsId: ~p, GoodsNum: ~p", [GoodsId, GoodsNum]),  
                                            {ok, NModPlayerState} = 
                                                lib_reward:take_reward(ModPlayerState#mod_player_state{
                                                                         player = NPlayer#player{gold_choujiang_num = 0}
                                                                        }, [{NGoodsId, NGoodsNum}], ?COST_CHOUJIANG_GOLD_ONE),
                                            {ok, NModPlayerState, [{NGoodsId, NGoodsNum}]}
                                    end
                            end
                    end
            end
    end.
    
get_choujiang_coin_ten(#mod_player_state{
                          player = Player
                         } = ModPlayerState) ->
    case lib_player:cost_money(Player, ?COST_COIN_CHOUJIANG_TEN, ?GOODS_TYPE_COIN, ?COST_CHOUJIANG_COIN_TEN) of 
        {fail, Reason} ->
            ?DEBUG("coin ten choujiang Fail! PlayerId: ~p , Reason: ~p", [Player#player.id, Reason]),
            {fail, Reason};
        {ok, NPlayer} ->
            case comman_twist_egg(NPlayer, ?CHOUJIANG_NUM_TEN, ?TWIST_EGG_COMMON_COIN) of  %% 9 + 1 模式
                [] ->
                    {fail, ?INFO_CONF_ERR};
                GoodsListInfo -> %% [{{GoodsId, GoodsNum}, IsValuable}, ... ]
                    case is_precious(GoodsListInfo) of %% 检查抽到的物品中是否有贵重的，并重组数据 [{GoodsId, GoodsNum}, {GoodsId, GoodsNum}, ... ]
                        {[], [], [_ | GoodsList]} ->
                            ?DEBUG("false ---- coin ten choujiang success! PlayerId: ~p, GoodsList: ~p", [Player#player.id, GoodsList]),
                            case special_twist_egg(NPlayer, ?CHOUJIANG_NUM_ONE, ?COIN_TWIST_EGG_TEN) of %% 没有抽到贵重物品，则进入潜规则中抽奖
                                [] ->
                                    {fail, ?INFO_CONF_ERR};
                                [{GoodsId, GoodsNum}] ->
                                    ?DEBUG("special choujiang gold ten GoodsId: ~p, GoodsNum: ~p", [GoodsId, GoodsNum]),
                                    NGoodsList = [{GoodsId, GoodsNum} | GoodsList],
                                    {ok, NModPlayerState} = lib_reward:take_reward(ModPlayerState#mod_player_state{
                                                                                     player = NPlayer
                                                                                    }, NGoodsList, ?COST_CHOUJIANG_COIN_TEN),
                                    {ok, NModPlayerState, NGoodsList}
                            end;
                        {FiveStarList, SpecialList, CommonList} ->
                            GoodsList = FiveStarList ++ SpecialList ++ CommonList, 
                            ?DEBUG("true ---- coin ten choujiang success! PlayerId: ~p, GoodsList: ~p", [Player#player.id, GoodsList]),
                            {ok, NModPlayerState} = lib_reward:take_reward(ModPlayerState#mod_player_state{
                                                                             player = NPlayer
                                                                            }, GoodsList, ?COST_CHOUJIANG_COIN_TEN),
                            {ok, NModPlayerState, GoodsList}
                    end
            end
    end.

is_precious(GoodsListInfo) ->
    lists:foldl(fun({{GoodsId, GoodsNum}, IsValuable}, {FiveStartList, PreciousList, CommonList})->
                        if
                            IsValuable =:= 0 ->
                                {FiveStartList, PreciousList, [{GoodsId, GoodsNum} | CommonList]};
                            IsValuable =:= 5 ->
                                {[{GoodsId, GoodsNum} | FiveStartList], PreciousList, CommonList};
                            true ->
                                {FiveStartList, [{GoodsId, GoodsNum} | PreciousList], CommonList}
                        end
                end, {[], [], []}, GoodsListInfo).

get_choujiang_gold_ten(#mod_player_state{
                          player = Player
                         } = ModPlayerState) ->
    case lib_player:cost_money(Player, ?COST_GOLD_CHOUJIANG_TEN, ?GOODS_TYPE_GOLD, ?COST_CHOUJIANG_GOLD_TEN) of 
        {fail, Reason} ->
            ?DEBUG("gold ten choujiang Fail! PlayerId: ~p , Reason: ~p", [Player#player.id, Reason]),
            {fail, Reason};
        {ok, NPlayer} ->
            case comman_twist_egg(NPlayer, ?CHOUJIANG_NUM_TEN, ?TWIST_EGG_COMMON_GOLD) of  %% 9 + 1 模式
                [] ->
                    {fail, ?INFO_CONF_ERR};
                GoodsListInfo -> %% [{{GoodsId, GoodsNum}, IsValuable}, ... ]
                    ?DEBUG("GoodsListInfo: ~p", [GoodsListInfo]),
                    case is_precious(GoodsListInfo) of %% 检查抽到的物品中是否有贵重的，并重组数据 [{GoodsId, GoodsNum}, {GoodsId, GoodsNum}, ... ]
                        {[], SpecialList, [_ | GoodsList] = OldGoodsList} ->
                            ?DEBUG("false ---- gold ten choujiang success! PlayerId: ~p, GoodsList: ~p", [Player#player.id, GoodsList]),
                            case check_gold_choujiang_num(NPlayer, ?CHOUJIANG_NUM_TEN) of
                                false ->
                                    if 
                                        SpecialList =:= [] ->  %% 没有抽到贵重物品，并且没达到抽五星条件，则进入潜规则中抽奖
                                            case special_twist_egg(NPlayer, ?CHOUJIANG_NUM_ONE, ?GOLD_TWIST_EGG_TEN) of %% 前 9 次中没有抽到贵重物品，则进入潜规则中抽奖
                                                [] ->
                                                    {fail, ?INFO_CONF_ERR};
                                                [{GoodsId, GoodsNum}] ->
                                                    ?DEBUG("special choujiang gold ten GoodsId: ~p, GoodsNum: ~p", [GoodsId, GoodsNum]),
                                                    NGoodsList = [{GoodsId, GoodsNum} | GoodsList],
                                                    GoldChoujiangNum = NPlayer#player.gold_choujiang_num,
                                                    {ok, NModPlayerState} = 
                                                        lib_reward:take_reward(ModPlayerState#mod_player_state{
                                                                                 player = NPlayer#player{ gold_choujiang_num = GoldChoujiangNum + ?CHOUJIANG_NUM_TEN }
                                                                                }, NGoodsList, ?COST_CHOUJIANG_GOLD_TEN),
                                                    {ok, NModPlayerState, NGoodsList}
                                            end;
                                        true -> %% 有抽到贵重物品，并且没达到抽五星条件，则进入潜规则中抽奖
                                            NGoodsList = SpecialList ++ OldGoodsList,
                                            GoldChoujiangNum = NPlayer#player.gold_choujiang_num,
                                            {ok, NModPlayerState} = 
                                                lib_reward:take_reward(ModPlayerState#mod_player_state{
                                                                         player = NPlayer#player{ gold_choujiang_num = GoldChoujiangNum + ?CHOUJIANG_NUM_TEN }
                                                                        }, NGoodsList, ?COST_CHOUJIANG_GOLD_TEN),
                                            {ok, NModPlayerState, NGoodsList}
                                    end;
                                true -> %% 达到了抽五星卡保底的条件
                                    case special_twist_egg(NPlayer, ?CHOUJIANG_NUM_ONE, ?GOLD_TWIST_EGG_GOLD_NUM) of %% 前 9 次中没有抽到贵重物品，则进入潜规则中抽奖
                                        [] ->
                                            {fail, ?INFO_CONF_ERR};
                                        [{GoodsId, GoodsNum}] ->
                                            ?WARNING_MSG("special choujiang gold .......... GoodsId: ~p, GoodsNum: ~p", [GoodsId, GoodsNum]),
                                            NGoodsList = SpecialList ++ [{GoodsId, GoodsNum} | GoodsList],
                                            {ok, NModPlayerState} = 
                                                lib_reward:take_reward(ModPlayerState#mod_player_state{
                                                                         player = NPlayer#player{gold_choujiang_num = 0}
                                                                        }, NGoodsList, ?COST_CHOUJIANG_GOLD_TEN),
                                            {ok, NModPlayerState, NGoodsList}
                                    end
                            end;
                        {FiveStarList, SpecialList, [{GoodsId, GoodsNum} | _] = GoodsList} -> %% 抽到了五星卡，但是不支持两张五星卡同时出现
                            NFiveStarList = 
                                update_special_list(FiveStarList, {GoodsId, GoodsNum}),
                            NGoodsList = NFiveStarList ++ SpecialList ++ GoodsList,
                            ?DEBUG("NGoodsList: ~p", [NGoodsList]),
                            {ok, NModPlayerState} = 
                                lib_reward:take_reward(ModPlayerState#mod_player_state{
                                                         player = NPlayer#player{gold_choujiang_num = 0}
                                                        }, NGoodsList, ?COST_CHOUJIANG_GOLD_TEN),
                            {ok, NModPlayerState, NGoodsList}
                    end
            end
    end.

update_special_list([StarGoodsInfo | FiveStarList], GoodsInfo) ->
    update_special_list1(FiveStarList, GoodsInfo, [StarGoodsInfo]).

update_special_list1([], _, GoodsList) ->
    GoodsList;

update_special_list1([_StarGoodsInfo | FiveStarList], GoodsInfo, GoodsList) ->
    update_special_list1(FiveStarList, GoodsInfo, [GoodsInfo | GoodsList]).

check_gold_choujiang_num(#player{gold_choujiang_num = Num}, ChoujiangNum) ->
    ?DEBUG("Num :~p, Choujiang :~p", [Num, ChoujiangNum]),
    Num + ChoujiangNum >= ?CHOUJIANG_GOLD_NUM.
