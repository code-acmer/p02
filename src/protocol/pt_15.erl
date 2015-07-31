%%%-----------------------------------
%%% @Module  : pt_15
%%% @Created : 2010.10.05
%%% @Description: 15物品信息
%%%-----------------------------------
-module(pt_15).

-include("define_logger.hrl").
-include("pb_15_pb.hrl").
-include("define_location.hrl").
-include("define_player.hrl").
-include("define_goods.hrl").
-include("define_reward.hrl").
-include("define_goods_type.hrl").
-include("db_base_mysterious_shop.hrl").

-export([write/2]).

-export([to_pbgoods/1,
         pack_goods/3]).
 
%%
%% 服务端 -> 客户端 ------------------------------------
%%

write(15000, {PlayerId, GoodsList}) ->
    Now = time_misc:unixtime(),
    mod_player:update_goods_send_timestamp(PlayerId, Now),
    PbGoodsList = #pbgoodslist{
                     update_timestamp = Now,
                     goods_list = lists:map(fun(Goods) ->
                                                    to_pbgoods(Goods)
                                            end, GoodsList)
                    },
    pt:pack(15000, PbGoodsList);

write(15001, {PlayerId, AddedGoods, DeletedGoods, UpdatedGoods}) ->
    ?DEBUG("AddedGoods : ~p~n, DeletedGoods:~p~n Updated:~p~n",[AddedGoods,
                                                                      DeletedGoods,
                                                                      UpdatedGoods
                                                                     ]),
    PbAddedGoodsList = lists:map(fun(Goods) ->
                                         to_pbgoods(Goods)
                                 end, AddedGoods),
    PbDeletedGoodsList = lists:map(fun(Goods) ->
                                           to_pbgoods(Goods)
                                   end, DeletedGoods),
    PbUpdatedGoodsList = lists:map(fun(Goods) ->
                                           to_pbgoods(Goods)
                                   end, UpdatedGoods),
    Now = time_misc:unixtime(),
    mod_player:update_goods_send_timestamp(PlayerId, Now),
    pt:pack(15001, #pbgoodschanged{
                      update_timestamp = Now,
                      added_list   = #pbgoodslist{
                                        goods_list = PbAddedGoodsList
                                       },
                      deleted_list = #pbgoodslist{
                                        goods_list = PbDeletedGoodsList
                                       },
                      updated_list = #pbgoodslist{
                                        goods_list = PbUpdatedGoodsList
                                       }
                     });

write(15008, Goods) ->
    pt:pack(15008, to_pbgoods(Goods));

write(15103, PlayerSkillRecord) ->
    pt:pack(15103, to_pbskillidlist(PlayerSkillRecord));

write(15104, _) ->
    pt:pack(15104, null);

write(15110, _) ->
    pt:pack(15110, null);

write(15200, UpgradeDetail) ->    
    pt:pack(15200, #pbid32r{id = UpgradeDetail});
write(15201, UpgradeDetail) ->
    pt:pack(15201, #pbid32r{id = UpgradeDetail
                          });

write(15301, _) ->
    pt:pack(15301, null);

write(Cmd, _) when Cmd =:= 15401 orelse Cmd =:= 15402 orelse Cmd =:= 15403 orelse Cmd =:= 15404 ->
    pt:pack(Cmd, <<>>);

%% 弹出副本奖励列表
write(15132, {_DungeonUniqueID, _RewardList}) ->
	%% ListNum = length(RewardList),
	%% F = fun(#reward_item{type = Type, num = Num, goods_id = GoodsId}) ->
	%% 			<<Type:8, Num:32, GoodsId:32>>
	%% 	end,
	%% ListBin = tool:to_binary(lists:map(F, RewardList)),
	pt:pack(15132, null);

%% 弹出客户端奖励
write(15500, {RewardList, Type}) ->
    PbRewardList = 
        #pbrewardlist{
           type = Type,
           reward_list = 
               lists:map(fun({Id, Sum, Bind}) ->
                                 #pbreward{goods_id = Id,
                                           num = Sum,
                                           bind = Bind
                                          }
                         end, RewardList)},
    pt:pack(15500, PbRewardList);

%% 神秘商店
write(15501, SteriousShop)->
    PbSteriousShop = to_pbsteriousshop(SteriousShop),
    pt:pack(15501, PbSteriousShop);
write(15503, <<>>) ->
    pt:pack(15503, <<>>);

write(15504, ViceShop)->
    PbSteriousShop = to_pbsteriousshop(ViceShop),
    pt:pack(15504, PbSteriousShop);

%%商城之热卖物品列表 
write(15510, {SellingList, ShopList}) ->
    PbSellingList = to_pbsellinglist(SellingList, ShopList),
    pt:pack(15510, PbSellingList);
    
write(15511, <<>>) ->
    pt:pack(15511, <<>>);

write(15512, {SellingList, ShopList}) ->
    PbSellingList = to_pbsellinglist(SellingList, ShopList),
    pt:pack(15512, PbSellingList);

write(15513, <<>>) ->
    pt:pack(15513, <<>>);


%% 抢购商城信息
write(15555, ActivityShop) ->
    PbActivityShop = to_pbactivityshop(ActivityShop),
    pt:pack(15555, PbActivityShop);
write(15556, <<>>) ->
    pt:pack(15556, <<>>);

%% 通知客户端有新的物品
write(15516, BaseId)
  when is_integer(BaseId) ->
    pt:pack(15516, #pbid32r{id = [BaseId]});
write(15516, ItemList) ->
    pt:pack(15516, #pbid32r{
                      id = lists:map(fun(Goods)
                                           when is_record(Goods, goods) ->
                                             Goods#goods.base_id
                                     end, ItemList)});

%% 获取限时抢购剩余刷新时间
write(15514, [RemainTime]) ->
	pt:pack(15514, <<RemainTime:32>>);


%% 购买物品
%% write(15520, GoodsList) ->
%%     ItemList = lists:map(fun(GoodsInfo) ->
%%                                  #pbitem{
%%                                     id = GoodsInfo#goods.id,
%%                                     goods_id = GoodsInfo#goods.goods_id,
%%                                     player_id = GoodsInfo#goods.player_id,
%%                                     container = GoodsInfo#goods.container,
%%                                     position = GoodsInfo#goods.position
%%                                    }
%%                          end, GoodsList),
%%     pt:pack(15520, #pbitemcontainer{
%%                       container = ?BAG_LOCATION,
%%                       item_list = ItemList
%%                      });


%% 出售物品
%% write(15521, [_Return, SellCoin, SellGoodsList]) ->
%%     ItemList = lists:map(fun(GoodsInfo) ->
%%                                  id = GoodsInfo#goods.id,
%%                                  base_id = GoodsInfo#goods.goods_id
%%                          end, SellGoodsList),
%% 	pt:pack(15521, #pbitemcontainer{
%%                       coin = SellCoin,
%%                       item_list = ItemList
%%                      });


%%扩充背包或仓库
write(15022, [Loc, Res, Gold, NewCellNum]) ->
    pt:pack(15022, <<Loc:8, Res:8, Gold:32, NewCellNum:16>>);

%%拆分物品
write(15523, [Res]) ->
	pt:pack(15523, <<Res:8>>);

%% 获取已出售物品列表
%% write(15525, SellGoodsList) ->
%%     F = fun({Order, GoodsDetial}) ->
%%                 case GoodsDetial of
%%                     [GoodsInfo, _SuitNum, _AttributeList] ->
%%                         PBItem = get_pack_goods_info(GoodsInfo),
%%                         %% <<Num:8, GoodsBin/binary>>;
%%                         PBItem#pbitem{position = Order};                    
%%                     _ ->
%%                         #pbitem{}
%%                 end
%%         end,
%%     pt:pack(15525, #pbitemshop{item_list = lists:map(F, SellGoodsList)});

%% 回购已出售物品
write(15526, [Return, GoodsDetial]) ->
    if
        Return =:= 1 ->
            [GoodsInfo, _SuitNum, _AttributeList] = GoodsDetial,
            PbGoodItem = to_pbgoods(GoodsInfo),
            %% {ok, pt:pack(15526, <<Return:8, 1:16, GoodsBin/binary>>)};
            pt:pack(15526, PbGoodItem);        
        true ->
            %% {ok, pt:pack(15526, <<Return:8, 0:16>>)}
            pt:pack(0, null)
    end;



%% 背包拖动物品
write(15540, Data) ->
    pt:pack(15540, Data);



%% 获取招财神符剩余使用次数
write(15547, Data) ->
	pt:pack(15547, Data);

%% 使用招财神符
write(15548, Data) ->
	pt:pack(15548, Data);

write(15560, GeneralStore) ->
    PbGeneralStoreInfo = 
        to_pbgeneralstoreinfo(GeneralStore),
    pt:pack(15560, PbGeneralStoreInfo);

write(15561, GeneralStore) ->
    PbGeneralStoreInfo = 
        to_pbgeneralstoreinfo(GeneralStore),
    pt:pack(15561, PbGeneralStoreInfo);

write(15562, PbGeneralStoreBuy) ->
    pt:pack(15562, PbGeneralStoreBuy);

%% 奖励领取结果信息
write(15581, null) ->
    pt:pack(15581, null);

%% 使用声望卡
write(15582, [Return, UseTimes, OldRemainTimes, GoldsCost, PrestigeGet]) ->
	if
		OldRemainTimes < 0 -> 
            RemainTimes = 0;
		true -> 
            RemainTimes = OldRemainTimes
	end,
	?DEBUG("writing 15582 [Return[~p], UseTimes[~p], 
				OldRemainTimes[~p], GoldsCost[~p], PrestigeGet[~p]]",
			   [Return, UseTimes, OldRemainTimes, GoldsCost, PrestigeGet]),
	pt:pack(15582, <<Return:8, UseTimes:16, RemainTimes:16, 
                     GoldsCost:32, PrestigeGet:32>>);

%% 获取购买体力信息
write(15533, Data) ->
    pt:pack(15533, Data);

%% 购买体力
write(15534, Data) ->
    pt:pack(15534, Data);

%% @doc 强化成功后发送
write(15554, _) ->
    pt:pack(15554, null);

%% @doc 通知客户端有新的装备到包裹中
%% @spec
%% @end
write(15590, BaseId) ->
    pt:pack(15590, #pbid32{id = BaseId});

write(15700, _) ->
    pt:pack(15700, null);

write(15583, TimeStamp) ->
    pt:pack(15583, #pbid32{id = TimeStamp});

write(15584, IsOpen) ->
    pt:pack(15584, #pbid32{id = IsOpen});

%% write(15800, List) ->
%%     pt:pack(15800, 
%%             #pbstoreproductlist{              
%%                product_list = List});
write(15801, List) ->
    pt:pack(15801, 
            #pbstoreproductlist{              
               product_list = List});
write(15900, ChoujiangInfo) ->
    PbChoujiangInfo = to_pbchoujianginfo(ChoujiangInfo),
    pt:pack(15900, PbChoujiangInfo);

write(15901, GoodsListInfo) ->
    PbChoujiangResult = to_pbchoujiangresult(GoodsListInfo),
    pt:pack(15901, PbChoujiangResult);

write(15910, _) ->
    pt:pack(15910, null);
write(15911, _) ->
    pt:pack(15911, null);
write(15912, _) ->
    pt:pack(15912, null);


write(Cmd, R) ->
    ?ERROR_MSG("Errorcmd ~p ~p~n",[Cmd, R]),
    pt:pack(0, null).

to_pbgeneralstoreinfo(#general_store{
                         store_type = StoreType,
                         shop_list = ShopList,
                         last_refresh_time = LastTime, 
                         refresh_num = RNum
                        }) ->
    #pbgeneralstoreinfo{
       store_type = StoreType,  
       shop_info = to_pbsteriousshop(ShopList, LastTime, RNum)
      }.

to_pbchoujiangresult(GoodsListInfo)->
    #pbchoujiangresult{
       result_list = lists:map(fun(GoodsInfo)->
                                       to_pbchoujianggoods(GoodsInfo)
                               end, GoodsListInfo)
      }.

to_pbchoujianggoods({GoodsId, GoodsNum}) ->
    #pbchoujianggoods{
       goods_id = GoodsId,
       num = GoodsNum
      }.

to_pbchoujianginfo(ChoujiangInfo) 
  when is_record(ChoujiangInfo, choujiang_info) ->
    #pbchoujianginfo{
       coin_timestamp = ?COIN_FREE_TIME + ChoujiangInfo#choujiang_info.coin_timestamp,
       gold_timestamp = ?GOLD_FREE_TIME + ChoujiangInfo#choujiang_info.gold_timestamp,
       coin_free_num = ChoujiangInfo#choujiang_info.coin_free_num
      }.

to_pbsteriousshop(SteriousShop)
  when is_record(SteriousShop, sterious_shop) ->
    #pbsteriousshop{
       shop_list              = lists:map(fun(MdbShopMsg) -> 
                                                  to_pbshopmsg(MdbShopMsg)
                                          end, SteriousShop#sterious_shop.shop_list), 
       shop_refresh_num       = SteriousShop#sterious_shop.shop_refresh_num,
       shop_last_refresh_time = SteriousShop#sterious_shop.shop_last_refresh_time
      };
to_pbsteriousshop(ViceShop)
  when is_record(ViceShop, vice_shop) ->
    #pbsteriousshop{
       shop_list              = lists:map(fun(MdbShopMsg) -> 
                                                  to_pbshopmsg(MdbShopMsg)
                                          end, ViceShop#vice_shop.shop_list), 
       shop_refresh_num       = ViceShop#vice_shop.shop_refresh_num,
       shop_last_refresh_time = ViceShop#vice_shop.shop_last_refresh_time
      }.

to_pbsteriousshop(ShopList, LastTime, RNum) ->
    ?DEBUG("ShopList:~p, LastTime:~p, RNum:~p", [ShopList, LastTime, RNum]),
    #pbsteriousshop{
       shop_list              = lists:map(fun(MdbShopMsg) -> 
                                                  to_pbshopmsg(MdbShopMsg)
                                          end, ShopList), 
       shop_refresh_num       = RNum, 
       shop_last_refresh_time = LastTime
      }.

to_pbshopmsg(MdbShopMsg)
  when is_record(MdbShopMsg, mdb_shop_msg) ->
    #pbshopmsg{
       base_id = MdbShopMsg#mdb_shop_msg.base_id,
       is_buy = MdbShopMsg#mdb_shop_msg.is_buy,
       pos = MdbShopMsg#mdb_shop_msg.pos
      }.

to_pbsellingshop(OrdinaryShopMsg, ShopList) 
  when is_record(OrdinaryShopMsg, ordinary_shop_msg)->
    BaseId = OrdinaryShopMsg#ordinary_shop_msg.base_id,
    #pbsellingshop{
       base_id = BaseId,
       num = OrdinaryShopMsg#ordinary_shop_msg.buy_num,
       buy_times = 
           case lists:keyfind(BaseId, 1, ShopList) of
               false -> 0;
               {_, Times} ->
                   Times
           end
      };
to_pbsellingshop(MainShopMsg, ShopList) 
  when is_record(MainShopMsg, main_shop_msg)->
    BaseId = MainShopMsg#main_shop_msg.base_id,
    #pbsellingshop{
       base_id = BaseId,
       num = MainShopMsg#main_shop_msg.buy_num,
       buy_times = 
           case lists:keyfind(BaseId, 1, ShopList) of
               false -> 0;
               {_, Times} ->
                   Times
           end
      }.

to_pbsellinglist(SellingList, ShopList) ->
    #pbsellinglist{
       shop_list = lists:map(fun(OrdinaryShopMsg)->
                                     to_pbsellingshop(OrdinaryShopMsg, ShopList)
                             end, SellingList)
      }.
to_pbactivityshop({TimeStamp, ActivityId, ShopList}) ->
    #pbactivityshop{
       timestamp = TimeStamp,
       activity_id = ActivityId,
       shop_list = lists:map(fun({ActivityShopMsg, RemainNum})->
                                     to_pbactivityshopmsg({ActivityShopMsg, RemainNum})
                             end, ShopList)
      }.
to_pbactivityshopmsg({ActivityShopMsg, RemainNum})
  when is_record(ActivityShopMsg, activity_shop_msg) ->
    BaseId = ActivityShopMsg#activity_shop_msg.base_id,
    BuyNum = ActivityShopMsg#activity_shop_msg.buy_num,
    NumLimit = ActivityShopMsg#activity_shop_msg.num_limit,
    #pbactivityshopmsg{
       id = BaseId,
       activity_remain_num = NumLimit - BuyNum,
       player_remain_num = RemainNum
      }.

to_pbgoods(Goods)
  when is_record(Goods, goods) ->
    %?DEBUG("Goods: ~p", [Goods]),
    #pbgoods{
       id            = Goods#goods.id,
       type          = Goods#goods.type,
       sub_type      = Goods#goods.subtype,
       goods_id      = Goods#goods.base_id,
       player_id     = Goods#goods.player_id,           %% 所属
       container     = Goods#goods.container,          %% 所处容器，身上或仓库
       position      = Goods#goods.position,           %% 位置
       str_lv        = Goods#goods.str_lv,             %% 成长等级
       star_lv       = Goods#goods.star_lv,        
       hp_lim        = Goods#goods.hp,             %% 突破等级
       bind          = Goods#goods.bind,
       attack        = Goods#goods.attack,
       def           = Goods#goods.def,
       hit           = Goods#goods.hit,
       dodge         = Goods#goods.dodge,
       crit          = Goods#goods.crit,
       anti_crit     = Goods#goods.anti_crit,
       stiff         = Goods#goods.stiff,
       %%cost     
       attack_speed  = Goods#goods.attack_speed,
       move_speed    = Goods#goods.move_speed,
       ice           = Goods#goods.ice,
       fire          = Goods#goods.fire,
       honly         = Goods#goods.honly,
       dark          = Goods#goods.dark,
       anti_ice      = Goods#goods.anti_ice,
       anti_fire     = Goods#goods.anti_fire,
       anti_honly    = Goods#goods.anti_honly,
       anti_dark     = Goods#goods.anti_dark,
       quality       = Goods#goods.quality,            %% 品质星级，填1-8分别对应1-8星
       sum           = Goods#goods.sum,
       hp_lim_ext    = Goods#goods.hp_ext,
       def_ext       = Goods#goods.def_ext,
       attack_ext    = Goods#goods.attack_ext,
       dodge_ext     = Goods#goods.dodge_ext,
       hit_ext       = Goods#goods.hit_ext,
       crit_ext      = Goods#goods.crit_ext,
       anti_crit_ext = Goods#goods.anti_crit_ext,
       jewels        = tuple_to_list(Goods#goods.jewels),
       mana_lim      = Goods#goods.mana_lim,
       mana_rec      = Goods#goods.mana_rec,
       mana_lim_ext  = Goods#goods.mana_lim_ext,
       mana_rec_ext  = Goods#goods.mana_rec_ext,
       skill_card_exp = Goods#goods.skill_card_exp,
       card_pos_1     = Goods#goods.card_pos_1,
       card_pos_2     = Goods#goods.card_pos_2,
       card_pos_3     = Goods#goods.card_pos_3,
       value          = lists:map(fun(GoodsInfo) -> 
                                          to_pbgoodsinfo(GoodsInfo)
                                  end, Goods#goods.value),
       timestamp      = Goods#goods.timestamp,
       skill_card_status = Goods#goods.card_status
      };

to_pbgoods(_) ->
    ?WARNING_MSG("empty goods info ... ~n", []),
    #pbgoods{}.

pack_goods([], [], []) ->
    ok;

pack_goods(AddList, UpdateInfo, DelList) ->
    PbAddList =
        lists:map(fun(Goods) ->
                          pt_15:to_pbgoods(Goods)
                  end, AddList),
    PbUpdateList = lists:foldl(fun({OldGoods, NewGoods}, AccUpdate) ->
                                       case record_misc:record_modified(pt_15:to_pbgoods(OldGoods), pt_15:to_pbgoods(NewGoods)) of
                                           [] ->
                                               AccUpdate;
                                           SendGoods ->
                                               [SendGoods#pbgoods{id = NewGoods#goods.id}|AccUpdate] 
                                       end
                               end, [], UpdateInfo),
    PbDelList = 
        lists:map(fun(#goods{id = Id}) ->
                          #pbgoods{id = Id}
                  end, DelList),
    {ok, Bin} = pt:pack(15001, #pbgoodschanged{updated_list = #pbgoodslist{goods_list = PbAddList ++ PbUpdateList},
                                               deleted_list = #pbgoodslist{goods_list = PbDelList}}),
    packet_misc:put_packet(Bin).

to_pbgoodsinfo({GoodsId, GoodsNum}) ->
    #pbgoodsinfo{
       id = GoodsId,
       num = GoodsNum
      }.

to_pbskillidlist(#player_skill_record{
                    skill_record_list = RecordList
                   }) ->
    #pbskillidlist{
       list = to_pbskillid(RecordList)
      }.

to_pbskillid(RecordList) ->
    lists:map(fun({_SubType, Id}) -> 
                      #pbskillid{
                         id = Id
                        }
              end, RecordList).
    
