-module(ct_robot_pt_15).

-export([send/2, recv/3]).
-export([send/3]).
-include("define_robot.hrl").

send(15000, Robot) ->
    Data = <<>>,
    {ok, Data, Robot};

send(15010, #ct_robot{
               goods_list = GoodsList
              }=Robot) ->
    [EquipId | _T] = [Id || #pbgoods{
                                   container = ?CONTAINER_BAG, 
                                   id = Id, 
                                   type = ?TYPE_GOODS_EQUIPMENT} <- GoodsList],
    Data = #pbid32{id = EquipId},
    {ok, Data, Robot};

send(15020, #ct_robot{
               goods_list = GoodsList
              }=Robot) ->
    MasterEquipList = [Equip || #pbgoods{type = ?TYPE_GOODS_EQUIPMENT} = Equip <- GoodsList],
    [MasterEquip1, MasterEquip2] = hmisc:rand_n(2,MasterEquipList),
    #base_goods{lv=Lv1} = data_base_goods:get(MasterEquip1#pbgoods.goods_id),
    #base_goods{lv=Lv2} = data_base_goods:get(MasterEquip2#pbgoods.goods_id),
    if 
        Lv1 < Lv2 ->
            {NewMasterEquip1, NewMasterEquip2} = {MasterEquip1, MasterEquip2};
        true ->
            {NewMasterEquip1, NewMasterEquip2} = {MasterEquip2, MasterEquip1}
    end,
    EquipId = NewMasterEquip1#pbgoods.id,
    EquipTid = NewMasterEquip2#pbgoods.id,
    Data = #pbsmriti{id = EquipId, tid = EquipTid},
    {ok, Data, Robot};


send(15022, Robot)->
    Data = <<>>,
    {ok, Data, Robot};

send(15100, #ct_robot{
               goods_list = GoodsList
              } = Robot) ->
    [EquipId | _T] = [Id || #pbgoods{
                                   container = ?CONTAINER_BAG, 
                                   id = Id, 
                                   type = ?TYPE_GOODS_EQUIPMENT} <- GoodsList],
    Data = #pbequipmove{id = EquipId},
    {ok, Data, Robot};

send(15101, #ct_robot{
               goods_list = GoodsList
              } = Robot) ->
    [EquipId | _T] = [Id || #pbgoods{
                                   container = ?CONTAINER_EQUIP,
                                   id = Id, 
                                   type = ?TYPE_GOODS_EQUIPMENT} <- GoodsList],
    Data = #pbequipmove{id = EquipId},
    {ok, Data, Robot};

send(15200, #ct_robot{goods_list = GoodsList} = Robot) ->
    MasterEquip = lib_robot:key_find_equip(?TYPE_GOODS_EQUIPMENT, GoodsList),
    Data = #pbequipstrengthen{id = MasterEquip#pbgoods.id, num = 1},
    {ok, Data, Robot};

send(15201, #ct_robot{goods_list = GoodsList} = Robot) ->
    MasterEquip = lib_robot:key_find_equip(?TYPE_GOODS_EQUIPMENT, GoodsList),
    Data = #pbequipaddstar{id = MasterEquip#pbgoods.id, num = 1},
    {ok, Data, Robot};

send(15401, #ct_robot{goods_list = GoodsList} = Robot) ->
    MasterEquip = lib_robot:key_find_equip(?TYPE_GOODS_EQUIPMENT, GoodsList),
    MasterJewel = lib_robot:key_find_equip(?TYPE_GOODS_JEWEL, GoodsList),
    Data = #pbinlaidjewel{
              id = MasterJewel#pbgoods.goods_id, 
              tid = MasterEquip#pbgoods.id,
              pos = 1
             },
    {ok, Data, Robot};

send(15403, #ct_robot{goods_list = GoodsList} = Robot) ->
    MasterEquip = lib_robot:key_find_equip(?TYPE_GOODS_EQUIPMENT, GoodsList),
    Data = #pbinlaidjewel{ 
              tid = MasterEquip#pbgoods.id,
              pos = 1
             },
    {ok, Data, Robot};

send(15404, #ct_robot{goods_list = GoodsList} = Robot) ->
    MasterEquip = lib_robot:key_find_equip(?TYPE_GOODS_EQUIPMENT, GoodsList),
    Data = #pbinlaidjewel{ 
              tid = MasterEquip#pbgoods.id
             },
    {ok, Data, Robot};

send(Cmd, _) ->
    {send_fail, {send_cmd_not_match, Cmd}}.

send(15010, Robot, GoodsId) ->
    Data = #pbid32{id = GoodsId},
    {ok, Data, Robot};

send(15020, Robot, {GoodsId, Tid}) ->
    Data = #pbsmriti{id = GoodsId, tid = Tid},
    {ok, Data, Robot};

send(15100, Robot, GoodsId) ->
    Data = #pbequipmove{id = GoodsId},
    {ok, Data, Robot};
send(15101, Robot, GoodsId) ->
    Data = #pbequipmove{id = GoodsId},
    {ok, Data, Robot};

send(15200, Robot, GoodsId) ->
    Data = #pbequipstrengthen{id = GoodsId, num = 1},
    {ok, Data, Robot};
send(15201, Robot, GoodsId) ->
    Data = #pbequipaddstar{id = GoodsId, num = 1},
    {ok, Data, Robot};

send(15030, Robot, ShopId)->
    Data = #pbshopitem{id = ShopId, num = 1},
    {ok, Data, Robot};

send(15402, Robot, JewelId) ->
    Data = #pbinlaidjewel{
              id = JewelId, 
              num = 1
             },
    {ok, Data, Robot};


send(Cmd, _ ,Args) ->
    {send_fail, {send_cmd_not_match, Cmd, Args}}.

recv(15000, Robot, #pbgoodslist{goods_list = GoodsList}) ->
    {ok, Robot#ct_robot{goods_list = GoodsList}};
recv(15001, Robot, #pbgoodschanged{deleted_list = Del,
                                   updated_list = Update}) ->
    RunF = fun(undefined, GoodsList, Fun) ->
                   GoodsList;
              (PbGoodsList, GoodsList, Fun) ->
                   Fun(PbGoodsList#pbgoodslist.goods_list, GoodsList)
           end,
    UpdateFun = fun(List, GoodsList) ->
                        lists:foldl(fun(#pbgoods{id = Id} = Goods, ChangeGoodsList) ->
                                            case lists:keyfind(Id, #pbgoods.id, ChangeGoodsList) of
                                                false ->
                                                    [Goods|ChangeGoodsList];
                                                OwnGoods ->
                                                    NewGoods = hmisc:record_merge(OwnGoods, Goods),
                                                    lists:keystore(Id, #pbgoods.id, ChangeGoodsList, NewGoods)
                                            end
                                    end, GoodsList, List)
                end,

    UpdatedGoodsList = RunF(Update, Robot#ct_robot.goods_list, UpdateFun),

    DeleteFun = fun(List, GoodsList) -> 
                        lists:foldl(fun(DelGoods, AccGoodsList) ->
                                            lists:keydelete(DelGoods#pbgoods.id, #pbgoods.id, AccGoodsList)
                                    end, GoodsList, List)
                end, 
    DeletedGoodsList = RunF(Del, UpdatedGoodsList, DeleteFun),

    {ok, Robot#ct_robot{goods_list = DeletedGoodsList}};
recv(15010, Robot, _) ->
    {ok, Robot};
recv(15020, Robot, _) ->
    {ok, Robot};
recv(15022, Robot, _) ->
    {ok, Robot};
recv(15200, Robot, _Data) ->
    {ok, Robot};
recv(15201, Robot, _Data) ->
    {ok, Robot};
recv(15401, Robot, _Data) ->
    {ok, Robot};
recv(15402, Robot, _Data) ->
    {ok, Robot};
recv(15403, Robot, _Data) ->
    {ok, Robot};
recv(15404, Robot, _Data) ->
    {ok, Robot};
%% recv(15301, Robot, _) ->
%%     {ok, Robot};
recv(15501, Robot, PbSteriousShop)->
    ?DEBUG("PbSteriousShop ~p",[PbSteriousShop]),
    {ok, Robot#ct_robot{
           sterious_shop = PbSteriousShop
          }};
recv(15503, Robot, _Data)->
    {ok, Robot};

recv(15510, Robot, PbSellingList)->
    {ok, Robot#ct_robot{
           selling_shop_list = PbSellingList
          }};
recv(15511, Robot, _)->
    {ok, Robot};

recv(Cmd, _, _) ->
    {recv_fail, {recv_cmd_not_match, Cmd}}.

