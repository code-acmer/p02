% 普通商城，兑换商城，神秘商店，抢购商城
-module(lib_shop).

-include("define_player.hrl").
-include("define_goods.hrl").
-include("define_logger.hrl").
-include("define_time.hrl").
-include("define_league.hrl").
-include("define_info_15.hrl").
-include("db_base_mysterious_shop.hrl").
-include("db_base_shop_activity.hrl").
-include("define_goods_type.hrl").
-include("define_money_cost.hrl").
-include("db_base_competitive_vice_shop.hrl").
-include("db_base_competitive_main_shop.hrl").
-include("db_base_general_store.hrl").
-include("db_base_vip.hrl").
-include("db_base_vip_cost.hrl").
-include("db_base_shop_content.hrl").
-include("define_info_40.hrl").


-export([save_sterious_shop/1,
         save_vice_shop/1,
         save_ordinary_shop/1,
         save_main_shop/1,
         save_activity_shop/1,
         save_general_store_list/1,
         reset_sterious_shop/1,
         reset_vice_shop/1,
         reset_ordinary_shop/1,
         reset_main_shop/1,
         reset_general_store_list/1,
         login_sterious_shop/1,
         login_vice_shop/1,
         login_ordinary_shop/1,
         login_main_shop/1,
         login_activity_record/1,
         login_general_store_list/1
        ]).

-export([get_main_selling_list/1,
         buy_main_shop/3,
         
         get_ordinary_selling_list/0,
         buy_ordinary_shop/3,
         exchange_goods/4,

         get_vice_shop/1,
         refresh_vice_shop/1,
         buy_vice_shop/2,

         get_mysterious/1,
         refresh_mysterious/1,
         buy_mysterious/2,

         get_activity_shop/1,
         buy_activity_shop/3,
         
         get_general_store_info/2,
         refresh_general_store/2,
         general_store_buy/3
        ]).
%%save 、reset 、login -----------------------------------------------------------
save_sterious_shop(SteriousShop)
  when is_record(SteriousShop, sterious_shop) ->
    hdb:save(SteriousShop, #sterious_shop.is_dirty).

save_vice_shop(ViceShop)
  when is_record(ViceShop, vice_shop) ->
    hdb:save(ViceShop, #vice_shop.is_dirty).

save_ordinary_shop(OrdinaryShopMsg) 
  when is_record(OrdinaryShopMsg, ordinary_shop_msg)->
    hdb:save(OrdinaryShopMsg, #ordinary_shop_msg.is_dirty);
save_ordinary_shop(OrdinaryShop) 
  when is_record(OrdinaryShop, ordinary_shop)->
    hdb:save(OrdinaryShop, #ordinary_shop.is_dirty).

save_main_shop(MainShopMsg) 
  when is_record(MainShopMsg, main_shop_msg)->
    hdb:save(MainShopMsg, #main_shop_msg.is_dirty);
save_main_shop(MainShop) 
  when is_record(MainShop, main_shop)->
    hdb:save(MainShop, #main_shop.is_dirty).

save_activity_shop(ActivityRecord) 
  when is_record(ActivityRecord, activity_shop_record) ->
    hdb:save(ActivityRecord, #activity_shop_record.is_dirty).

save_general_store_list(GeneralStoreList) ->
    lists:map(fun(GeneralStore) 
                 when is_record(GeneralStore, general_store) -> 
                      hdb:save(GeneralStore, #general_store.is_dirty);
                 (_) ->
                      ?WARNING_MSG("save_general_store...Error Data !!")
              end, GeneralStoreList).

reset_sterious_shop(SteriousShop)
  when is_record(SteriousShop, sterious_shop) ->
    dirty_sterious_shop(SteriousShop#sterious_shop{
                          shop_refresh_num = 0
                         }).

reset_vice_shop(ViceShop)
  when is_record(ViceShop, vice_shop) ->
    dirty_vice_shop(ViceShop#vice_shop{
                      shop_refresh_num = 0
                     }).

reset_ordinary_shop(OrdinaryShop)
  when is_record(OrdinaryShop, ordinary_shop) ->
    dirty_ordinary_shop(OrdinaryShop#ordinary_shop{
                          shop_list = []
                         }).

reset_general_store_list(GeneralStoreList) ->
    lists:map(fun(#general_store{id = Id}) ->
                      hdb:dirty_delete(general_store, Id)
              end, GeneralStoreList),
    [].

reset_main_shop(MainShop)
  when is_record(MainShop, main_shop) ->
    dirty_main_shop(MainShop#main_shop{
                      shop_list = []
                     }).
    
login_sterious_shop(PlayerId)->
    case hdb:dirty_read(sterious_shop, PlayerId, true) of
        #sterious_shop{} = SteriousShop ->
            SteriousShop;
        _ ->
            dirty_sterious_shop(#sterious_shop{
                                   player_id = PlayerId
                                  })
    end.

login_vice_shop(PlayerId)->
    case hdb:dirty_read(vice_shop, PlayerId, true) of
        #vice_shop{} = ViceShop ->
            ViceShop;
        _ ->
            dirty_vice_shop(#vice_shop{
                               player_id = PlayerId
                              })
    end.

login_ordinary_shop(PlayerId)->
    case hdb:dirty_read(ordinary_shop, PlayerId, true) of
        #ordinary_shop{} = OrdinaryShop ->
            OrdinaryShop;
        _ ->
            dirty_ordinary_shop(#ordinary_shop{
                                   player_id = PlayerId
                                  })
    end.

login_main_shop(PlayerId)->
    case hdb:dirty_read(main_shop, PlayerId, true) of
        #main_shop{} = MainShop ->
            MainShop;
        _ ->
            dirty_main_shop(#main_shop{
                               player_id = PlayerId
                              })
    end.

login_activity_record(PlayerId) ->
    case hdb:dirty_read(activity_shop_record, PlayerId, true) of
        #activity_shop_record{} = ActivityRecord ->
            ActivityRecord;
        _ ->
            dirty_activity_shop_record(#activity_shop_record{
                                          player_id = PlayerId
                                         })
    end.

login_general_store_list(PlayerId) ->
    GeneralStoreList = 
        hdb:dirty_index_read(general_store, PlayerId, #general_store.player_id),
    lists:map(fun(GeneralStore) ->
                    dirty_general_store(GeneralStore)
              end, GeneralStoreList).

%%普通商城相关---------------------------------------------------------------------
%% 获取热卖列表
get_ordinary_selling_list()->
    mod_selling_shop:get_ordinary_shop_list().

%% 获取热卖列表
get_main_selling_list(#player{ career = Career }) ->
    ShopList = mod_selling_shop:get_main_shop_list(),
    lists:foldl(fun(#main_shop_msg{
                       base_id = BaseId
                      } = MainShopMsg, Acc ) ->
                        case data_base_competitive_main_shop:get(BaseId) of
                            #base_competitive_main_shop{
                               career = Career
                              } ->
                                [MainShopMsg | Acc];
                            _ ->
                                Acc                        
                        end
                end, [], ShopList).

%% 商城购买商品
buy_main_shop(#mod_player_state{
                     main_shop = MainShop
                    }=ModPlayerState, ShopId, Num) ->
    ShopList = MainShop#main_shop.shop_list,
    case lists:keytake(ShopId, 1, ShopList) of
        false ->
            buy_main_shop1(ModPlayerState, ShopId, 0, Num, ShopList);
        {value, {ShopId, OldNum}, Rest} ->
            buy_main_shop1(ModPlayerState, ShopId, OldNum, Num, Rest)
    end.

buy_main_shop1(#mod_player_state{
                  main_shop = MainShop,
                  player = Player
                 } = ModPlayerState, ShopId, OldNum, AddNum, ShopList) ->
    case check_fun(data_base_competitive_main_shop, ShopId, fun(#base_competitive_main_shop{
                                                                   day_lim = DayLimit,
                                                                   career = Career
                                                                  })->
                                                                    if
                                                                        DayLimit < OldNum + AddNum ->
                                                                            {fail, ?INFO_BUY_NUM_LIMIT};
                                                                        Player#player.career =/= Career ->
                                                                            {fail, ?INFO_CAREER_FALSE};
                                                                        true ->
                                                                            true
                                                                    end
                                                            end) of
        {fail, Reason} ->
            {fail, Reason};
        true ->
            case exchange_goods(ModPlayerState, ShopId, AddNum, data_base_competitive_main_shop) of
                {fail, Reason} ->
                    {fail, Reason};
                {ok, NewModPlayerState} ->
                    mod_selling_shop:update_main_shop(ShopId, AddNum),
                    {ok, NewModPlayerState#mod_player_state{
                           main_shop = 
                               dirty_main_shop(MainShop#main_shop{
                                                 shop_list = [{ShopId, OldNum + AddNum} | ShopList]
                                                })
                          }}
            end
    end.

%% 商城购买商品
buy_ordinary_shop(#mod_player_state{
                     ordinary_shop = OrdinaryShop
                    }=ModPlayerState, ShopId, Num) ->
    ShopList = OrdinaryShop#ordinary_shop.shop_list,
    case lists:keytake(ShopId, 1, ShopList) of
        false ->
            buy_ordinary_shop1(ModPlayerState, ShopId, 0, Num, ShopList);
        {value, {ShopId, OldNum}, Rest} ->
            buy_ordinary_shop1(ModPlayerState, ShopId, OldNum, Num, Rest)
    end.

buy_ordinary_shop1(#mod_player_state{
                      ordinary_shop = OrdinaryShop
                     } = ModPlayerState, ShopId, OldNum, AddNum, ShopList) ->
    case check_fun(data_base_shop, ShopId, fun(#base_shop{
                                                  day_lim = DayLimit
                                                 })->
                                                   DayLimit >= OldNum + AddNum
                                           end) of
        {fail, Reason} ->
            {fail, Reason};
        false ->
            {fail, ?INFO_BUY_NUM_LIMIT};
        true ->
            case exchange_goods(ModPlayerState, ShopId, AddNum, data_base_shop) of
                {fail, Reason} ->
                    {fail, Reason};
                {ok, NewModPlayerState} ->
                    mod_selling_shop:update_ordinary_shop(ShopId, AddNum),
                    {ok, NewModPlayerState#mod_player_state{
                           ordinary_shop = 
                               dirty_ordinary_shop(OrdinaryShop#ordinary_shop{
                                                     shop_list = [{ShopId, OldNum + AddNum} | ShopList]
                                                    })
                          }}
            end
    end.

dirty_ordinary_shop(OrdinaryShop)
  when is_record(OrdinaryShop, ordinary_shop)->
    OrdinaryShop#ordinary_shop{
      is_dirty = 1
     }.
dirty_main_shop(MainShop)
  when is_record(MainShop, main_shop)->
    MainShop#main_shop{
      is_dirty = 1
     }.

%%兑换商城相关--------------------------------------------------------------------
exchange_goods(ModPlayerState, ShopId, Num, BaseMod) ->
    case check_exchange_conditions(ModPlayerState, ShopId, Num, BaseMod,  fun()-> 
                                                                                  ok 
                                                                          end) of
        {fail, Reason} ->
            {fail, Reason};
        {ok, #mod_player_state{player = #player{bag_cnt = BagCnt} = Player} = NModPlayerState, {Update, Del, BaseId, AddNum}} ->
            pt_15:pack_goods([], Update, Del),
            lib_goods:db_delete_goods(Del),
            NewGoodsList = 
                lib_goods:update_goods_info(Update, NModPlayerState#mod_player_state.bag),
            case add_exchange_goods(NModPlayerState#mod_player_state{bag = NewGoodsList,
                                                                     player = Player#player{bag_cnt = BagCnt - length(Del)}},
                                    BaseId, AddNum) of
                {fail, Reason} ->
                    {fail, Reason};
                Other ->
                    Other
            end
    end.
 
%%神秘商城相关--------------------------------------------------------------------

%% 获取竞技场神秘商城
get_vice_shop(#mod_player_state{
                 player = Player,
                 vice_shop = ViceShop
                })->
    LastTime = ViceShop#vice_shop.shop_last_refresh_time,
    case is_time(LastTime) of
        false ->
            ViceShop;
        true ->
            ShopList = get_sterious_shop(Player, data_base_competitive_vice_shop),
            dirty_vice_shop(ViceShop#vice_shop{
                                  shop_list = ShopList,
                                  shop_last_refresh_time = time_misc:unixtime()
                                 })
    end.

%% 刷新竞技场神秘商城
refresh_vice_shop(#mod_player_state{
                     player = Player,
                     vice_shop = ViceShop
                    } = ModPlayerState) ->
    RefreshNum = ViceShop#vice_shop.shop_refresh_num,
    case refresh_mysterious(Player, RefreshNum,  [{?REFRESH_SHOP_SEAL, ?GOODS_TYPE_SEAL}],
                            data_base_competitive_vice_shop) of
        {fail, Reason} ->
            {fail, Reason};
        {ShopList, NewPlayer} ->
            {ok, ModPlayerState#mod_player_state{
                   vice_shop = ViceShop#vice_shop{
                                 shop_refresh_num = RefreshNum + 1,
                                 shop_list = ShopList,
                                 shop_last_refresh_time = time_misc:unixtime()
                                },
                   player = NewPlayer
                  }}
    end.

%% 竞技场神秘商城购买
buy_vice_shop(#mod_player_state{
                 vice_shop = ViceShop
                } = ModPlayerState, Pos) ->
    ShopList = ViceShop#vice_shop.shop_list,
    LastTime = ViceShop#vice_shop.shop_last_refresh_time,
    Fun = fun(BaseId) ->
                  case data_base_competitive_vice_shop:get(BaseId) of
                      [] ->
                          {fail, ?INFO_CONF_ERR};
                      #base_competitive_vice_shop{
                         consume = Consume,
                         goods_id = GoodsId,
                         goods_num = GoodsNum
                        } ->
                          {Consume, GoodsId, GoodsNum}
                  end 
          end,
    case buy_mysterious1(ModPlayerState, ShopList, LastTime, Pos, Fun) of
        {fail, Reason} ->
            {fail, Reason};
        {ok, NModPlayerState, NShopList} ->
            {ok, NModPlayerState#mod_player_state{
                   vice_shop = dirty_vice_shop(ViceShop#vice_shop{
                                                 shop_list = NShopList
                                                })
                  }}
    end.

%% 获取神秘商城
get_mysterious(#mod_player_state{
                  player = Player,
                  sterious_shop = SteriousShop
                 })->
    ?DEBUG("SteriousShop: ~p", [SteriousShop]),
    LastTime = SteriousShop#sterious_shop.shop_last_refresh_time,
    case is_time(LastTime) of
        false ->
            SteriousShop;
        true ->
            ShopList = get_sterious_shop(Player, data_base_mysterious_shop), 
            dirty_sterious_shop(SteriousShop#sterious_shop{
                                  shop_list = ShopList,
                                  shop_last_refresh_time = time_misc:unixtime()
                                 })
    end.

%% 刷新神秘商城
refresh_mysterious(#mod_player_state{
                            player = Player,
                            sterious_shop = SteriousShop
                           } = ModPlayerState) ->
    RefreshNum = SteriousShop#sterious_shop.shop_refresh_num,
    case lib_vip:get_vip_cost(mysterious_shop_cost, RefreshNum + 1) of
        error ->
            {fail, ?INFO_CONF_ERR};
        Cost ->
            case refresh_mysterious(Player, RefreshNum, Cost, data_base_mysterious_shop) of
                {fail, Reason} ->
                    {fail, Reason};
                {ShopList, NewPlayer} ->
                    {ok, ModPlayerState#mod_player_state{
                           sterious_shop = SteriousShop#sterious_shop{
                                             shop_refresh_num = RefreshNum + 1,
                                             shop_list = ShopList,
                                             shop_last_refresh_time = time_misc:unixtime()
                                            },
                           player = NewPlayer
                          }}
            end
    end.

refresh_mysterious(Player, RefreshNum, Cost, BaseMod) ->
    Vip = Player#player.vip,
    case is_refresh(Vip, RefreshNum) of
        false ->
            {fail, ?INFO_GOODS_MYSTERY_SHOP_TIMES_OUT};
        true ->
            case lib_player:cost_money(Player, [Cost], ?COST_MYSTERY_SHOP_RESET) of 
                {fail, Reason} ->
                    {fail, Reason};
                {ok, NewPlayer} ->
                    ShopList = get_sterious_shop(NewPlayer, BaseMod),
                    {ShopList, NewPlayer}
            end
    end.

%% 神秘商城购买
buy_mysterious(#mod_player_state{
                  sterious_shop = SteriousShop
                 } = ModPlayerState, Pos) ->
    ?DEBUG(" SteriousShop : ~p", [SteriousShop]),
    ShopList = SteriousShop#sterious_shop.shop_list,
    LastTime = SteriousShop#sterious_shop.shop_last_refresh_time,
    Fun = fun(BaseId) ->
                  case data_base_mysterious_shop:get(BaseId) of
                      [] ->
                          {fail, ?INFO_CONF_ERR};
                      #base_mysterious_shop{
                         consume = Consume,
                         goods_id = GoodsId,
                         goods_num = GoodsNum
                        } ->
                          {Consume, GoodsId, GoodsNum}
                  end 
          end,
    case buy_mysterious1(ModPlayerState, ShopList, LastTime, Pos, Fun) of
        {fail, Reason} ->
            {fail, Reason};
        {ok, NModPlayerState, NShopList} ->
            {ok, NModPlayerState#mod_player_state{
                   sterious_shop = dirty_sterious_shop(SteriousShop#sterious_shop{
                                                         shop_list = NShopList
                                                        })
                  }}
    end.

%% 神秘商城购买
buy_mysterious1(ModPlayerState, ShopList, LastTime, Pos, Fun) ->
    case is_time(LastTime) of 
        true ->
            {fail, ?INFO_GOODS_WRONG_SHOP_OVERDUE};
        false ->
            case lists:keytake(Pos, #mdb_shop_msg.pos, ShopList) of
                false ->
                    {fail, ?INFO_GOODS_WRONG_POS};
                {value, MdbShopMsg, Reset} ->
                    case buy_mysterious2(MdbShopMsg, Reset, ModPlayerState, Fun) of
                        {fail, Reason} ->
                            {fail, Reason};
                        Other ->
                             Other
                    end
            end
    end.

buy_mysterious2(#mdb_shop_msg{
                        is_buy = IsBuy,
                        base_id = BaseId
                       } = MdbShopMsg, Reset, #mod_player_state{
                                                 player = Player
                                                } = ModPlayerState, Fun) ->
    if
        IsBuy =/= 0 ->
            {fail, ?INFO_GOODS_WRONG_REPEAT_BUY};
        true ->
            case Fun(BaseId) of
                {fail, Reason} ->
                    {fail, Reason};
                {Consume, GoodsId, GoodsNum} ->
                    case lib_player:cost_money(Player, Consume, ?COST_MYSTERY_SHOP_BUY) of 
                        {fail, Reason} ->
                            {fail, Reason};
                        {ok, NewPlayer} ->
                            NModPlayerState = ModPlayerState#mod_player_state{
                                                player = NewPlayer
                                               },
                            {ok, NewModPlayerState} = 
                                lib_reward:take_reward(NModPlayerState, [{GoodsId, GoodsNum}], ?COST_MYSTERY_SHOP_BUY),
                            {ok, NewModPlayerState, [MdbShopMsg#mdb_shop_msg{
                                                       is_buy = 1
                                                      } | Reset]}
                    end
            end
    end.

%% ------- 神秘商城内部函数 -----------
is_time(LastRefreshTime) ->
    %%因为是每6个小时，而且是0点开始，所以可以用下面方法
    Now = time_misc:unixtime(),
    SixHourSecs = ?ONE_HOUR_SECONDS*6,
    (LastRefreshTime div SixHourSecs) =/= (Now div SixHourSecs).

dirty_sterious_shop(SteriousShop)
  when is_record(SteriousShop, sterious_shop)->
    SteriousShop#sterious_shop{
      is_dirty = 1
     }.

dirty_vice_shop(ViceShop)
  when is_record(ViceShop, vice_shop)->
    ViceShop#vice_shop{
      is_dirty = 1
     }.

is_refresh(Vip, RefreshNum)->
    MaxFresh = lib_vip:max_mysterious_fresh(Vip),
    RefreshNum < MaxFresh.

%% 神秘商店刷新系统-------------
%% 由 ShopIdList 构造[{BaseMysteriousShop, Weigth}, ... ]
get_sterious_shop(#player{
                     lv = PlayerLv,
                     career = Career
                    }, BaseMod)->
    ShopWeigthList = get_shop_weigth(PlayerLv, Career, BaseMod),
    ?DEBUG("ShopWeigthList ~p~n", [ShopWeigthList]),
    get_rand_list(ShopWeigthList, ?STERIOUS_SHOP_RAND_NUM, 1).
%---------
get_shop_weigth(PlayerLv, Career, BaseMod)->
    LvLimit = ?LV_LIMIT,
    LvList = BaseMod:get_all_lv(),
    Min = PlayerLv - LvLimit,
    Max = PlayerLv + LvLimit,
    if 
        Min > 0 ->
            get_shop_weigth1({Min, Career}, {Max, Career}, LvList, [], BaseMod);
        true ->
            get_shop_weigth1({1, Career}, {Max, Career}, LvList, [], BaseMod)
    end.

get_shop_weigth1({_MinLv, _Career}, {_MaxLv, _Career}, [], ShopList, _BaseMod)->
    ShopList;
get_shop_weigth1({MinLv, Career}, {MaxLv, Career}, [Lv | LvList], ShopList, BaseMod)->
    if
        MinLv =< Lv andalso Lv =< MaxLv ->
            IdList1 = BaseMod:get_id_by_lv_and_career({Lv, 0}),
            IdList2 = BaseMod:get_id_by_lv_and_career({Lv, Career}),
            ShopWeigthList = get_shop_weigth2(IdList1 ++ IdList2, BaseMod),
            get_shop_weigth1({MinLv, Career}, {MaxLv, Career}, LvList, ShopWeigthList ++ ShopList, BaseMod);
        true ->
            get_shop_weigth1({MinLv, Career}, {MaxLv, Career}, LvList, ShopList, BaseMod)
    end.

get_shop_weigth2(ShopIdList, data_base_mysterious_shop)->
    lists:foldl(fun(ShopId, AccList)->
                        BaseShop = data_base_mysterious_shop:get(ShopId),
                        Tuple = {ShopId, BaseShop#base_mysterious_shop.weight},
                        [Tuple | AccList]
                end, [], ShopIdList);
get_shop_weigth2(ShopIdList, data_base_competitive_vice_shop)->
    lists:foldl(fun(ShopId, AccList)->
                        BaseShop = data_base_competitive_vice_shop:get(ShopId),
                        Tuple = {ShopId, BaseShop#base_competitive_vice_shop.weight},
                        [Tuple | AccList]
                end, [], ShopIdList).
%---------
get_rand_list([], _RandNum, _) ->
    [];
get_rand_list(ShopWeigthList, RandNum, PosStart)->
    ShopIdList = hmisc:rand_n_p_r(RandNum, ShopWeigthList), %% 可重复随机
    {_, L} = 
        lists:foldl(fun(Id, {Num, AccShopList}) ->
                            {Num+1, [#mdb_shop_msg{
                                        base_id = Id,
                                        pos = Num,
                                        is_buy = 0
                                       } | AccShopList]
                            }
                    end, {PosStart, []}, ShopIdList),
    L.

%% ------- 神秘商城私有函数 （结束）-----------

%% 通用性神秘商店----------------------------------------------------------------
get_shop_num(_Player, ?PVP_SHOP) ->
    ?PVP_SHOP_NUM;
get_shop_num(_Player, ?FAIR_CHALLANGE_SHOP) ->
    ?FAIR_CHALLANGE_SHOP_NUM;
get_shop_num(_Player, ?CROSS_SHOP) ->
    ?CROSS_SHOP_NUM;
get_shop_num(Player, ?LEAGUE_SHOP) ->
    case lib_league:get_my_league(Player) of
        {fail, Reason} ->
            {fail, Reason};
        #league{lv = Lv} ->
            case data_base_shop_content:get(?LEAGUE_SHOP * 100 + Lv) of
                [] ->
                    0;
                #base_shop_content{content = Content} ->
                    Content
            end
    end.    

get_pointid(?PVP_SHOP) ->
    ?COST_PVP_SHOP_RESET;
get_pointid(?FAIR_CHALLANGE_SHOP) ->
    ?COST_FAIR_CHALLANGE_SHOP_REST;
get_pointid(?CROSS_SHOP) ->
    ?COST_CROSS_SHOP_RESET;
get_pointid(?LEAGUE_SHOP) ->
    ?COST_LEAGUE_SHOP_RESET.

get_general_store_info(#mod_player_state{
                          player = Player,
                          general_store_list = GeneralStoreList
                         } = ModPlayerState, StoreType) ->
    ?DEBUG("GeneralStoreList: ~p", [GeneralStoreList]),
    case lists:keytake(StoreType, #general_store.store_type, GeneralStoreList) of
        false ->
            case get_shop_num(Player, StoreType) of 
                {fail, Reason} ->
                    {fail, Reason};
                ShopNum ->
                    ?DEBUG("ShopNum: ~p", [ShopNum]),
                    GeneralStore = 
                        new_general_store(Player, next_store_id(), StoreType, 0, ShopNum),
                    {ok, ModPlayerState#mod_player_state{
                           general_store_list = [GeneralStore | GeneralStoreList]
                          }, GeneralStore}
            end;
        {value, GeneralStore, _} ->
            ?DEBUG("value GeneralStore: ~p", [GeneralStore]),
            {ok, ModPlayerState, GeneralStore}
    end.

general_store_buy(#mod_player_state{
                     player = Player,
                     general_store_list = StoreList
                    } = ModPlayerState, StoreType, Pos) ->
    case lists:keytake(StoreType, #general_store.store_type, StoreList) of
        false ->
            {fail, ?INFO_CONF_ERR};
        {value, #general_store{
                   shop_list = ShopList
                  } = GeneralStore, RestStoreList} ->
            ?DEBUG("GeneralStore: ~p", [GeneralStore]),
            case lists:keytake(Pos, #mdb_shop_msg.pos, ShopList) of
                false ->
                    {fail, ?INFO_GOODS_WRONG_POS};
                {value, #mdb_shop_msg{
                           is_buy = IsBuy,
                           base_id = BaseId
                          } = ShopMsg, RestShopList} ->
                    if
                        IsBuy =:= 1 ->
                            {fail, ?INFO_GOODS_WRONG_REPEAT_BUY};
                        true ->
                            case data_base_general_store:get(BaseId) of
                                [] ->
                                    {fail, ?INFO_CONF_ERR};
                                #base_general_store{
                                   goods_id = GoodsId,  
                                   goods_num = GoodsNum,
                                   consume = Consume,
                                   level_limit = LevelLimit
                                  } ->
                                    case check_level_limilt(Player, StoreType, LevelLimit) of
                                        {fail, Reason} ->
                                            {fail, Reason};
                                        _ ->
                                            case lib_player:cost_money(Player, Consume, get_pointid(StoreType)) of
                                                {fail, Reason} ->
                                                    {fail, Reason};
                                                {ok, NPlayer} ->
                                                    NewGeneralStore = 
                                                        dirty_general_store(GeneralStore#general_store{
                                                                              shop_list = [ShopMsg#mdb_shop_msg{is_buy = 1} | RestShopList]
                                                                             }),
                                                    lib_reward:take_reward(ModPlayerState#mod_player_state{
                                                                             player = NPlayer,
                                                                             general_store_list = [NewGeneralStore | RestStoreList]
                                                                            }, [{GoodsId, GoodsNum}], ?INCOME_EXCHANGE_GOODS)
                                            end
                                    end
                            end
                    end
            end
    end.    

check_level_limilt(Player, ?LEAGUE_SHOP, LevelLimit) ->
    case lib_league:get_my_league(Player) of
        #league{lv = LeagueLv} -> %% when LeagueLv >= LevelLimit ->
            %?WARNING_MSG("LeagueLv: ~p, LevelLimit: ~p", [LeagueLv, LevelLimit]),
            if
                LeagueLv >= LevelLimit ->
                    ok;
                true ->
                    {fail, ?INFO_LEAGUE_LEVEL_LIMIT}
            end;
        Other ->
            ?WARNING_MSG("Other: ~p", [Other]),
            {fail, ?INFO_LEAGUE_LEVEL_LIMIT} 
    end;

check_level_limilt(_Player, _StoreType, _LevelLimit) ->
    ok.

store_info(Player, RefreshNum, Type) ->
    Vip = Player#player.vip,
    case data_base_vip:get(Vip) of
        [] ->
            {fail, ?INFO_CONF_ERR};
        BaseVip ->
            store_info_1(Player, BaseVip, RefreshNum, Type)
    end.

store_info_1(_Player, #base_vip{pvp_shop_refresh = RNum}, RefreshNum, ?PVP_SHOP)
  when RefreshNum =< RNum ->
    case lib_vip:get_vip_cost(pvp_shop_refresh_cost, RefreshNum) of
        error ->
            {fail, ?INFO_CONF_ERR};
        Consume ->
            {[Consume], ?PVP_SHOP_NUM, ?COST_PVP_SHOP_RESET}
    end;
store_info_1(_Player, #base_vip{cross_shop_refresh = RNum}, RefreshNum, ?CROSS_SHOP)
  when RefreshNum =< RNum ->
    case lib_vip:get_vip_cost(cross_shop_refresh_cost, RefreshNum) of
        error ->
            {fail, ?INFO_CONF_ERR};
        Consume ->
            {[Consume], ?CROSS_SHOP_NUM, ?COST_CROSS_SHOP_RESET}
    end;
store_info_1(_Player, #base_vip{fair_shop_refresh = RNum}, RefreshNum, ?FAIR_CHALLANGE_SHOP)
  when RefreshNum =< RNum ->
    case lib_vip:get_vip_cost(fair_shop_refresh_cost, RefreshNum) of
        error ->
            {fail, ?INFO_CONF_ERR};
        Consume ->
            {[Consume], ?FAIR_CHALLANGE_SHOP_NUM, ?COST_FAIR_CHALLANGE_SHOP_REST}
    end;

store_info_1(Player, #base_vip{guild_shop_refresh = RNum}, RefreshNum, ?LEAGUE_SHOP)
  when RefreshNum =< RNum ->
    case lib_vip:get_vip_cost(guild_shop_refresh_cost, RefreshNum) of
        error ->
            {fail, ?INFO_CONF_ERR};
        Consume ->
            case get_shop_num(Player, ?LEAGUE_SHOP) of
                {fail, Reason} ->
                    {fail, Reason};
                ShopNum ->
                    {[Consume], ShopNum, ?COST_LEAGUE_SHOP_RESET}
            end
    end;

store_info_1(_, _, _, _) ->
    {fail, ?INFO_GOODS_LEAGUE_SHOP_TIMES_OUT}.

%%业务
refresh_general_store(#mod_player_state{
                         player = Player,
                         general_store_list = StoreList
                        } = ModPlayerState, StoreType) ->
    {NStoreList, StoreId, RefreshNum} = 
        case lists:keytake(StoreType, #general_store.store_type, StoreList) of
            false ->
                {StoreList, [], 0};
            {value, #general_store{
                       id = Id,
                       refresh_num = RNum
                      }, Rest} ->
                {Rest, Id, RNum}
        end,
    case store_info(Player, RefreshNum, StoreType) of
        {fail, Reason} ->
            {fail, Reason};
        {Consume, ShopNum, PointId} ->
            case refresh_general_store1(Player, RefreshNum, StoreId, NStoreList, StoreType, Consume, ShopNum, PointId) of
                {fail, Reason} ->
                    {fail, Reason};
                {ok, NewPlayer, GeneralStore, NewStoreList} ->
                    {ok, ModPlayerState#mod_player_state{
                           player = NewPlayer,
                           general_store_list = NewStoreList
                          }, GeneralStore}
            end
    end.

refresh_general_store1(Player, RNum, StoreId, StoreList, StoreType, Consume, ShopNum, PointId) ->
    case lib_player:cost_money(Player, Consume, PointId) of
        {fail, Reason} ->
            {fail, Reason};
        {ok, NPlayer} ->
            GeneralStore = 
                if
                    StoreId =:= [] ->
                        new_general_store(NPlayer, next_store_id(), StoreType, RNum, ShopNum);
                    true ->
                        new_general_store(NPlayer, StoreId, StoreType, RNum, ShopNum)
                end,
            {ok, NPlayer, GeneralStore, [GeneralStore | StoreList]}
    end.
        
next_store_id() ->
    lib_counter:update_counter(general_store_id).

new_general_store(#player{id = PlayerId, career = Career}, Id, StoreType, RefreshNum, ShopNum) ->
    dirty_general_store(#general_store{
                           id = Id,
                           player_id = PlayerId,
                           store_type = StoreType,
                           shop_list = get_general_store(Career, StoreType, ShopNum),
                           last_refresh_time = time_misc:get_timestamp_of_tomorrow_start(),
                           refresh_num = RefreshNum + 1,
                           is_dirty = 1
                          }).

%%通用商城刷新
get_general_store(Career, StoreType, ShopNum) ->
    {MustShowList, RandShowList} = get_general_ids(Career, StoreType),
    ?DEBUG("ShopNum: ~p, MustShowList: ~p", [ShopNum, length(MustShowList)]),
    RemainNum = ShopNum - length(MustShowList),
    ?DEBUG("ShopNum: ~p, RemainNum: ~p", [ShopNum, RemainNum]),
    if
        RemainNum > 0  ->
            PosStart = ShopNum - RemainNum + 1,
            get_general_store1(MustShowList) ++ rand_general_store(RandShowList, RemainNum, PosStart);
        true ->
            {L, _} = list_misc:sublist(lists:sort(MustShowList), ShopNum),
            get_general_store1(L)
    end.

get_general_store1(IdList) ->
    NIdList = lists:sort(IdList),
    {_, ShopList} = 
        lists:foldl(fun(Id, {Pos, AccList}) ->
                            {Pos+1, [#mdb_shop_msg{
                                        base_id = Id,
                                        is_buy = 0,
                                        pos = Pos
                                       } | AccList]}
                    end, {1, []}, NIdList),
    lists:reverse(ShopList).

get_general_ids(Career, StoreType) ->
    IdList1 = 
        data_base_general_store:get_id_by_career_store_show({0, StoreType, 1}),
    IdList2 = 
        data_base_general_store:get_id_by_career_store_show({0, StoreType, 0}),
    IdList3 = 
        data_base_general_store:get_id_by_career_store_show({Career, StoreType, 1}),
    IdList4 = 
        data_base_general_store:get_id_by_career_store_show({Career, StoreType, 0}),
    {IdList1 ++ IdList3, IdList2 ++ IdList4}.

rand_general_store(RandShowList, RemainNum, PosStart) ->
    RandList = get_rand_general_list(RandShowList),
    get_rand_list(RandList, RemainNum, PosStart).

get_rand_general_list(RandShowList) ->
    lists:foldl(fun(Id, AccList) ->
                        case data_base_general_store:get(Id) of
                            [] -> 
                                ?WARNING_MSG("Error Id: ~p", [Id]),
                                AccList;
                            #base_general_store{
                               id = ShopId,
                               weight = Weigth
                              } ->
                                [{ShopId, Weigth} | AccList]
                        end
                end, [], RandShowList).
    
dirty_general_store(GeneralStore)
  when is_record(GeneralStore, general_store)->
    GeneralStore#general_store{
      is_dirty = 1
     }.
 
%% -----------------------------------------------------------------------------

%%抢购商城相关-------------------------------------------------------------------
%% 读取实时抢购商场信息
get_activity_shop(ActivityRecord)->
    ?DEBUG("ActivityRecord : ~p", [ActivityRecord]),
    case hdb:read_table(activity_shop_msg) of
        [] ->
            {fail, ?INFO_NOT_ACTIVITY_OPEN};
        [#activity_shop_msg{
            activity_id = ActivityId
           } | _] = ShopList ->
            ?DEBUG("ShopList : ~p", [ShopList]),
            case data_base_shop_activity:get(ActivityId) of
                [] ->
                    {fail, ?INFO_CONF_ERR};
                #base_shop_activity{
                   start_time = StartTime,
                   last_time = LastTime
                  } ->
                    {_, EndStemp} = time_misc:cal_begin_end_stamp(StartTime, LastTime),
                    {_, ConsumeList} = check_activity(ActivityId, ActivityRecord), %% 检查ActiviyId是否一致
                    {NShopList, _} = combination_shoplist(ConsumeList, ShopList), %% 重组数据构造 [{ActivityShopMsg, 0} or {{ActivityShopMsg, OldConsumeNum}]两种
                    NewShopList = count_remain_num(NShopList), %% 计算剩余量
                    case ConsumeList of
                        [] ->
                            {dirty_activity_shop_record(ActivityRecord#activity_shop_record{
                                                          activity_id = ActivityId,
                                                          shop_list = []
                                                         }), {EndStemp, ActivityId, NewShopList}};
                        Other ->
                            {ActivityRecord#activity_shop_record{
                                                          activity_id = ActivityId,
                                                          shop_list = Other
                                                         }, {EndStemp, ActivityId, NewShopList}}
                    end
            end
    end.

check_activity(ActivityId, #activity_shop_record{
                              activity_id = ActivityId,
                              shop_list = ShopList
                             }) ->
    {ok, ShopList};
check_activity(_, _) ->
    {fail, []}.

combination_shoplist(Consume, ShopList)->
    lists:foldl(fun(#activity_shop_msg{
                       base_id = BaseId
                      } = ActivityShopMsg, {AccList, OldConsume}) ->
                        case lists:keytake(BaseId, 1, OldConsume) of
                            false ->
                                {[{ActivityShopMsg, 0} | AccList], OldConsume};
                            {value, {_Id, Num}, Rest} ->
                                {[{ActivityShopMsg, Num} | AccList], Rest}
                        end
                end, {[], Consume}, ShopList).

count_remain_num(ShopList) ->
    lists:foldl(fun({#activity_shop_msg{
                        base_id = BaseId
                       } = ActivityShopMsg, Num}, AccList) ->
                        case data_base_shop:get(BaseId) of
                            []->
                                AccList;
                            #base_shop{
                               rang_lim = RangLimit
                              } ->
                                [{ActivityShopMsg, RangLimit - Num} | AccList]
                        end
                end, [], ShopList).
%% 商城购买
buy_activity_shop(#mod_player_state{
                     activity_record = ActivityRecord
                     } = ModPlayerState, ShopId, Num)->
    ?DEBUG("ActivityRecord : ~p", [ActivityRecord]),
    case hdb:read_table(activity_shop_msg) of
        [] ->
            {fail, ?INFO_NOT_ACTIVITY_OPEN};
        [#activity_shop_msg{
            activity_id = ActivityId
           } | _]  ->
            ?DEBUG("ActivityId: ~p , ActivityRecord : ~p", [ActivityId, ActivityRecord]),
            case check_activity(ActivityId, ActivityRecord) of
                {fail, []}->
                    {fail, ?INFO_ACTIVITY_SHOP_OVERDUE};
                {ok, ConsumeRecord} ->
                    {ConsumeNum, _} = check_activity_consume(ShopId, ConsumeRecord),
                    TallNum = ConsumeNum + Num,
                    case check_fun(data_base_shop, ShopId, fun(#base_shop{
                                                                  rang_lim = RangLimit
                                                                 })->
                                                                   TallNum =< RangLimit
                                                           end) of
                        {fail, Reason} ->
                            {fail, Reason};
                        false ->
                            {fail, ?INFO_ACTIVITY_PLAYER_BUY_LIMIT};
                        true ->
                            buy_activity_shop1(ModPlayerState, ActivityId, ShopId, Num)
                    end
            end
    end.

buy_activity_shop1(ModPlayerState, ActivityId, ShopId, Num)->
    case check_exchange_conditions(ModPlayerState, ShopId, Num, data_base_shop, fun()->
                                                                                       buy_activity_shop2(ActivityId, ShopId, Num)
                                                                               end) of
        {fail, Reason} ->
            {fail, Reason};
        {ok, NModPlayerState, {Update, Del, BaseId, GoodsNum}} ->
            lib_goods:db_delete_goods(Del),
            pt_15:pack_goods([], Update, Del),
            NewGoodsList = lib_goods:update_goods_info(Update, NModPlayerState#mod_player_state.bag),
            case add_exchange_goods(ModPlayerState#mod_player_state{bag = NewGoodsList}, BaseId, GoodsNum) of
                {fail, Reason} ->
                    {fail, Reason};
                {ok, #mod_player_state{
                        activity_record = ActivityRecord,
                        player = #player{bag_cnt = BagCnt} = Player
                       }=NewModPlayerState} ->
                    NewActivityRecord = update_activity_record(ActivityRecord, ShopId, Num),
                    {ok, NewModPlayerState#mod_player_state{
                           activity_record = NewActivityRecord,
                           player = Player#player{bag_cnt = BagCnt - length(Del)}
                          }}
            end
    end.

buy_activity_shop2(ActivityId, ShopId, Num) ->
    ?DEBUG("ActivityId: ~p, ShopId: ~p, Num: ~p",[ActivityId, ShopId, Num]),
    case mod_activity_shop:buy_shop(ActivityId, ShopId, Num) of
        {fail, Reason} ->
            {fail, Reason};
        ok ->
            ok
    end.

check_activity_consume(ShopId, Consume)->
    case lists:keytake(ShopId, 1, Consume) of
        false ->
            {0, Consume};
        {value, {_Id, Num}, Rest} ->
            {Num, Rest}
    end.

update_activity_record(#activity_shop_record{
                          shop_list = ShopList
                         }=ActivityRecord, ShopId, Num) ->
    ?DEBUG("update_activity_record : ShopId ~p , Num ~p", [ShopId, Num]),
    NewShopList = 
        case lists:keytake(ShopId, 1, ShopList) of
            false ->
                [{ShopId, Num} | ShopList];
            {value, {_, OldNum}, Rest} ->
                [{ShopId, Num + OldNum} | Rest]
        end,
    dirty_activity_shop_record(ActivityRecord#activity_shop_record{
                                 shop_list = NewShopList
                                }).

dirty_activity_shop_record(ActivityRecord) 
  when is_record(ActivityRecord, activity_shop_record) ->
    ActivityRecord#activity_shop_record{
      is_dirty = 1
     }.

%% 抢购商店结束------------------------------------------------------------------

%%公共函数-----------------------------------------------------------------------

check_fun(DataMod, Id, Fun)->
    case DataMod:get(Id) of
        [] ->
            {fail, ?INFO_CONF_ERR};
        Base ->
            Fun(Base)
    end.

check_exchange_conditions(ModPlayerState, ShopId, Num, BaseMod, CheckFun)
  when is_integer(Num) andalso Num > 0 ->
    case check_exchange_conditions1(ModPlayerState, ShopId, Num, BaseMod) of
        {fail, Reason} ->
            {fail, Reason};
        {ok, NModPlayerState, Opts} ->
            case CheckFun() of
                {fail, Reason} ->
                    {fail, Reason};
                ok ->
                    {ok, NModPlayerState, Opts}
            end
    end;
check_exchange_conditions(_, _,Num,_,_) ->
    ?WARNING_MSG("check_exchange_conditions error Num ~p~n", [Num]),
    {fail, ?INFO_NOT_LEGAL_INT}.

check_exchange_conditions1(#mod_player_state{
                              player = Player, 
                              bag = GoodsList
                             } = ModPlayerState, ShopId, Num, BaseMod) ->
    case BaseMod:get(ShopId) of
        [] ->
            {fail, ?INFO_CONF_ERR};
        Base ->
            case check_shop_lv(Player, Base) of
                {fail, Reason} ->
                    {fail, Reason};
                {true, BaseId, Consume, GoodsNum} ->
                    AllConsume = 
                        lists:map(fun({Id, Sum}) ->
                                          {Id, Sum * Num}  
                                  end, Consume),
                    ?DEBUG("AllConsume: ~p", [AllConsume]),
                    case lib_goods:consume_goods(Player, AllConsume, GoodsList) of
                        {fail, Reason} ->
                            {fail, Reason};
                        {ok, NewPlayer, NewGoodsList, Update, Del} ->
                            NewModPlayerState = ModPlayerState#mod_player_state{player = NewPlayer,
                                                                                bag = NewGoodsList},
                            {ok, NewModPlayerState, {Update, Del, BaseId, Num*GoodsNum}}
                    end
            end
    end.
add_exchange_goods(ModPlayerState, BaseId, GoodsNum) ->
    ?DEBUG("BaseId: ~p, GoodsNum: ~p", [BaseId, GoodsNum]),   
    case lib_reward:take_reward(ModPlayerState, [{BaseId, GoodsNum, ?GOODS_NOT_BIND}], ?INCOME_EXCHANGE_GOODS) of
        {fail, Reason} ->
            {fail, Reason};
        {ok, NModPlayerState} ->
            {ok, NModPlayerState}
    end.
check_shop_lv(#player{vip = Vip}, #base_shop{goods_id = GoodsId,
                                             consume = Consume,
                                             vip = ReqVip,
                                             goods_num = GoodsNum
                                            }) ->
    if
        Vip >= ReqVip ->
            {true, GoodsId, Consume, GoodsNum};
        true ->
            {fail, ?INFO_VIP_LEVEL_TOO_LOW}
    end;

check_shop_lv(#player{vip = Vip}, #base_competitive_main_shop{goods_id = GoodsId,
                                                              consume = Consume,
                                                              vip = ReqVip,
                                                              goods_num = GoodsNum
                                                             }) ->
    if
        Vip >= ReqVip ->
            {true, GoodsId, Consume, GoodsNum};
        true ->
            {fail, ?INFO_VIP_LEVEL_TOO_LOW}
    end.


