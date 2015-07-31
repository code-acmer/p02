-module(ai_lib_goods).
-compile(export_all).
-include("define_robot.hrl").
-include("db_base_goods.hrl").

find_equip_on_bag(AccountInfo) ->
    Robot = ct_robot:get_robot(AccountInfo),
    GoodsList = Robot#ct_robot.goods_list,
    case list_misc:list_match_one([{#pbgoods.type, ?TYPE_GOODS_EQUIPMENT}, 
                           {#pbgoods.container, ?CONTAINER_BAG}], GoodsList) of
        [] ->
            Lv = Robot?ROBOT_LV,
            GoodsId = get_equip_with_lv(Lv),
            {no_equip_in_bag, GoodsId};
        Pbgoods ->
            Pbgoods
    end.
get_equip_with_lv(Lv) ->
    case data_base_goods:get_equip_all_lv() of
        [] ->
            0;
        LvList ->
            case ai_lib_player:get_available_lv(Lv, LvList) of
                [] ->
                    0;
                Other ->
                    hmisc:rand(data_base_goods:get_equip_by_lv(Other))
            end
    end.
find_equip_on_body(AccountInfo) ->
    Robot = ct_robot:get_robot(AccountInfo),
    GoodsList = Robot#ct_robot.goods_list,
    case list_misc:list_match_one([{#pbgoods.type, ?TYPE_GOODS_EQUIPMENT},
                               {#pbgoods.container, ?CONTAINER_EQUIP}], GoodsList) of
        [] ->
            no_equip_on_body;
        Pbgoods ->
            Pbgoods#pbgoods.id
    end.
get_upgrade_equip(AccountInfo, Type) ->
    Robot = ct_robot:get_robot(AccountInfo),
    GoodsList = Robot#ct_robot.goods_list,
    case get_upgrade_equip2(GoodsList, Type) of
        [] ->
            GoodsId = get_equip_with_lv(Robot?ROBOT_LV),
            {no_equip_to_upgrade, GoodsId};
        Goods ->
            MoneyConf = ai_lib_player:ensure_money(AccountInfo, Robot),
            {MoneyConf, Goods#pbgoods.id}
    end.

get_upgrade_equip2([], _) ->
    [];
get_upgrade_equip2([Goods|Tail], Type) ->
    case data_base_goods:get(Goods#pbgoods.goods_id) of
        #base_goods{max_strengthen = MaxStr,
                    max_star = MaxStar} ->
            if
                Type =:= strength andalso Goods#pbgoods.str_lv < MaxStr ->
                    Goods;
                Type =:= addstar andalso Goods#pbgoods.star_lv < MaxStar ->
                    Goods;
                true ->
                    get_upgrade_equip2(Tail, Type)
            end
    end.
clear_bag(AccountInfo) ->
    Robot = ct_robot:get_robot(AccountInfo),
    GoodsList = Robot#ct_robot.goods_list,
    case length(GoodsList) > ?HIGH_BAG_CNT of
        true ->
            EquipOn = list_misc:list_match([{#pbgoods.container, ?CONTAINER_EQUIP}], GoodsList),
            DelGoods = GoodsList -- EquipOn,
            lists:map(fun(#pbgoods{id = Id}) ->
                              Id
                      end, DelGoods);
        false ->
            skip
    end.
get_smriti_equip(_AccountInfo) ->
    skip.

