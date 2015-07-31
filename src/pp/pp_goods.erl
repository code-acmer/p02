%%%--------------------------------------
%%% @Module  : pp_goods
%%% @Created : 2010.09.23
%%% @Description:  物品操作
%%%--------------------------------------
-module(pp_goods).

-export([
         handle/3
        ]).

-include("define_logger.hrl").
-include("pb_13_pb.hrl").
-include("pb_15_pb.hrl").
-include("define_info_15.hrl").
-include("define_operate.hrl").
-include("define_money_cost.hrl").
-include("define_log.hrl").
-include("define_reward.hrl").
-include("define_player.hrl").
-include("db_base_store_product.hrl").
-include("define_goods_type.hrl").


%% 获取所有背包数据
handle(15000, #mod_player_state{
                 player = Player,
                 bag = GoodsList} = ModPlayerSate, #pbid32{id=TimeStamp}) ->    
    %% 同时修正背包物品数量
    if
        TimeStamp =/= 0 andalso Player#player.goods_update_timestamp =:= TimeStamp ->
            %% same, not send any
            %% if TimeStamp equals to 0, it always send    
            ingore;
        true ->
            Count = length(GoodsList),
            NextCnts = split_n(Count),
            ?DEBUG("NextCnts : ~w~n",[NextCnts]),
            lists:foldl(fun(NextCnt, Index) ->
                                ?DEBUG("Sending NextCnt : ~w Index :~w~n",[NextCnt, Index]),
                                NewGoodsList = lists:sublist(GoodsList, Index, NextCnt),
                                {ok, BinData}= pt_15:write(15000, {Player#player.id, NewGoodsList}),
                                packet_misc:put_packet(BinData),
                                Index ++ NextCnt
                        end, 1, NextCnts),
            {ok, ModPlayerSate#mod_player_state{bag = GoodsList}}
    end;

%% 兼容旧的，方便客户端开发的时候不会被卡住
handle(15000, #mod_player_state{player = Player,
                                bag = GoodsList,
                                client_pid = ClientPid
                               } = ModPlayerState, _) ->    

    BagCnt = length(GoodsList),
    NextCnts = split_n(BagCnt),
    ?DEBUG("NextCnts : ~w~n",[NextCnts]),
    lists:foldl(fun(NextCnt, Index) ->
                        ?DEBUG("Sending NextCnt : ~w Index :~w~n",[NextCnt, Index]),
                        NewGoodsList = lists:sublist(GoodsList, Index, NextCnt),
                        {ok, BinData}= pt_15:write(15000, {Player#player.id, NewGoodsList}),
                        %% packet_misc:put_packet(BinData),
                        packet_misc:directly_send_packet(ClientPid, 0, BinData),
                        Index + NextCnt
                end, 1, NextCnts),
    %% {ok, ModPlayerSate#mod_player_state{bag = GoodsList}}
    %% {ok, BinData}= pt_15:write(15000, {Player#player.id, GoodsList}),
    %% packet_misc:put_packet(BinData),
    %% BagCnt = length(GoodsList),  %%修正玩家的物品数量，主要是给一个大概值，不至于包过大发不动
    %% ?DEBUG("BagCnt ~p~n", [BagCnt]),
    {ok, ModPlayerState#mod_player_state{player = Player#player{bag_cnt = BagCnt}}};

handle(15008, #mod_player_state{player = Player}, #pbid64r{ids = IdList}) ->
    case IdList of
        [PlayerId, GoodsId] 
          when is_integer(PlayerId) andalso is_integer(GoodsId) 
               andalso PlayerId =/= Player#player.id ->
            case lib_goods:get_other_player_goods(PlayerId, GoodsId) of
                {fail, Reason} ->
                    packet_misc:put_info(Reason);
                Goods ->
                    {ok, Bin} = pt_15:write(15008, Goods),
                    packet_misc:put_packet(Bin)
            end;
        _ ->
            packet_misc:put_info(?INFO_NOT_LEGAL_INT)
    end;
%%穿戴装备
handle(15100, ModPlayerState, #pbequipmove{id  = Gid}) ->
    case lib_equip:swear_equip(ModPlayerState, Gid) of
        {ok, NewModPlayerState} ->
            mod_player:update_combat_attri(ModPlayerState?PLAYER_PID),
            {ok, NewModPlayerState};
        {fail, Reason}->
            packet_misc:put_info(Reason)
    end;
%% 脱下装备
handle(15101, ModPlayerState, #pbequipmove{id = Gid}) ->
    case lib_equip:take_off_equip(ModPlayerState, Gid) of
        {ok, NewModPlayerState} ->
            mod_player:update_combat_attri(ModPlayerState?PLAYER_PID),
            {ok, NewModPlayerState};
        {fail, Reason}->
            packet_misc:put_info(Reason)
    end;
%%装备技能卡
handle(15102, ModPlayerState, #pbgoodslist{goods_list = PbGoodsList}) ->
    lib_goods:swear_skill_card(ModPlayerState, PbGoodsList);

%%获取技能卡记录
handle(15103, #mod_player_state{
                 skill_record = SkillRecord
                }, _) ->
    {ok, Bin} = pt_15:write(15103, SkillRecord),
    packet_misc:put_packet(Bin);

%%紫色装备属性转移为橙色装备
handle(15104, ModPlayerState, #pbsmriti{id = Id, tid = Tid}) ->
    case lib_equip:transform_attri(ModPlayerState, Id, Tid) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {ok, NewModPlayerState} ->
            mod_player:update_combat_attri(ModPlayerState?PLAYER_PID),
            {ok, BinData} = pt_15:write(15104, null),
            packet_misc:put_packet(BinData),
            {ok, NewModPlayerState}
    end;

%% 购买时装
handle(15110, ModPlayerState, #pbid32{id = FashionShopId}) ->
    case lib_goods:buy_fashion(ModPlayerState, FashionShopId) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {ok, NewModPlayerState} ->
            mod_player:update_combat_attri(ModPlayerState?PLAYER_PID),
            {ok, BinData} = pt_15:write(15110, null),
            packet_misc:put_packet(BinData),
            {ok, NewModPlayerState}
    end;

%% 强化
handle(15200, ModPlayerState, #pbequipstrengthen{id = GoodsId, num = Num}) -> 
    case lib_equip:upgrade_equipment(ModPlayerState, GoodsId, ?TYPE_GOODS_STRENGTH, Num) of
        {ok, NewModPlayerState, Detail}  ->
            mod_player:update_combat_attri(ModPlayerState?PLAYER_PID),
            {ok, BinData} = pt_15:write(15200, Detail),
            packet_misc:put_packet(BinData),
            {ok, NewModPlayerState};
        {fail, Reason} ->
            packet_misc:put_info(Reason)
    end;
%% 升星
handle(15201, ModPlayerState, #pbequipaddstar{id = GoodsId, num = Num})->
    case lib_equip:upgrade_equipment(ModPlayerState, GoodsId, ?TYPE_GOODS_ADD_STAR, Num) of
        {ok, NewModPlayerState, Detail}  -> 
            mod_player:update_combat_attri(ModPlayerState?PLAYER_PID),
            {ok, BinData} = pt_15:write(15201, Detail),
            packet_misc:put_packet(BinData),
            {ok, NewModPlayerState};
        {fail, Reason} ->
            packet_misc:put_info(Reason)
    end;
%%技能卡升级
handle(15202, ModPlayerState, #pbupgradeskillcard{id = Id, consume_list = List}) ->
    ConsumeList = 
        lists:map(fun(#pbgoodsinfo{
                         id = GoodsId,
                         num = Num}) ->
                          {GoodsId, Num}
                  end, List),
    ?DEBUG("ConsumeList ~p~n", [ConsumeList]),
    case lib_goods:upgrade_skill_card(ModPlayerState, Id, ConsumeList) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {ok, NewModPlayerState} ->
            {ok, NewModPlayerState}
    end;

%% 勋章升级
handle(15300, ModPlayerState, #pbid32{id = Id}) ->
    case lib_goods:upgrade_xunzhang(ModPlayerState, Id) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {ok, NewModPlayerState} ->
            mod_player:update_combat_attri(ModPlayerState?PLAYER_ID),
            {ok, NewModPlayerState}
    end;
handle(15301, ModPlayerState, _) ->
    case lib_goods:get_xunzhang(ModPlayerState) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {ok, NewModPlayerState} ->
            {ok, BinData} = pt_15:write(15301, <<>>),
            packet_misc:put_packet(BinData),
            {ok, NewModPlayerState}
    end;        

%%宝石镶嵌
handle(15401, ModPlayerState, #pbinlaidjewel{id = Id, tid = Tid, pos = Pos}) ->
    case lib_goods:inlaid_jewel(ModPlayerState, Id, Tid, Pos) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {ok, NewModPlayerState} ->
            mod_player:update_combat_attri(ModPlayerState?PLAYER_PID),
            {ok, Bin} = pt_15:write(15401, null),
            packet_misc:put_packet(Bin),
            {ok, NewModPlayerState}
    end;
%%宝石合成
handle(15402, ModPlayerState, #pbinlaidjewel{id = Id, num = Num}) ->
    case lib_goods:jewel_compose(ModPlayerState, Id, Num) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {ok, NewModPlayerState} ->
            mod_player:update_combat_attri(ModPlayerState?PLAYER_ID),
            {ok, Bin} = pt_15:write(15402, null),
            packet_misc:put_packet(Bin),
            {ok, NewModPlayerState}
    end;
%%宝石摘除
handle(15403, ModPlayerState, #pbinlaidjewel{tid = Tid, pos = Pos}) ->
    case lib_goods:jewel_remove(ModPlayerState, Tid, Pos) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {ok, NewModPlayerState} ->
            mod_player:update_combat_attri(ModPlayerState?PLAYER_ID),
            {ok, Bin} = pt_15:write(15403, null),
            packet_misc:put_packet(Bin),
            {ok, NewModPlayerState}
    end;
%%卸下所有宝石
handle(15404, ModPlayerState, #pbinlaidjewel{tid = Id}) ->
    case lib_goods:jewel_remove_all(ModPlayerState, Id) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {ok, NewModPlayerState} ->
            mod_player:update_combat_attri(ModPlayerState?PLAYER_ID),
            {ok, Bin} = pt_15:write(15404, null),
            packet_misc:put_packet(Bin),
            {ok, NewModPlayerState}
    end;

%% 扩充背包
handle(15022, ModPlayerState, _) ->
   case lib_player:cost_money(ModPlayerState?PLAYER, ?BUY_BAG_EXT_GOLD, ?GOODS_TYPE_GOLD, ?COST_EXTEND_BAG) of
        {ok, Player} ->
           packet_misc:put_info(?INFO_GOODS_BAG_EXT_SUCCESS),
            {ok, ModPlayerState#mod_player_state{
                   player = Player#player{
                              bag_limit = Player#player.bag_limit + 5
                             }
                  }};
        {fail, Reason} ->
            packet_misc:put_info(Reason)
    end;

%%分解装备
handle(15010, ModPlayerState, #pbid32{id = Id}) ->
   case lib_equip:decomposition_equip(ModPlayerState, Id) of
        {ok, NewModPlayerState} ->
           {ok, Bin} = pt:pack(15010, <<>>),
           packet_misc:put_packet(Bin),
           {ok, NewModPlayerState};
        {fail, Reason} ->
            packet_misc:put_info(Reason)
    end;
%%传承
handle(15020, ModPlayerState, #pbsmriti{id = Id, tid = Tid}) ->
    case lib_equip:equip_smriti(ModPlayerState, Id, Tid) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {ok, NewModPlayerState} ->
            mod_player:update_combat_attri(ModPlayerState?PLAYER_PID),
            {ok, NewModPlayerState}
    end;
%%商店购买
handle(15030, ModPlayerState, #pbshopitem{id = ShopId, num = Num}) ->
    case lib_shop:exchange_goods(ModPlayerState, ShopId, Num, data_base_shop) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {ok, NewModPlayerState} ->
            {ok, NewModPlayerState}
    end;


%%神秘商店之请求获取
handle(15501, ModPlayerState, _) ->
    SteriousShop = lib_shop:get_mysterious(ModPlayerState),
    {ok, BinData} = pt_15:write(15501, SteriousShop),
    packet_misc:put_packet(BinData),
    {ok, ModPlayerState#mod_player_state{
           sterious_shop = SteriousShop
          }};

%%神秘商店之请求刷新
handle(15502, ModPlayerState, _)->
    case lib_shop:refresh_mysterious(ModPlayerState) of 
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {ok, #mod_player_state{
                sterious_shop = SteriousShop
               }=NewModPlayerState} ->
            {ok, BinData} = pt_15:write(15501, SteriousShop),
            packet_misc:put_packet(BinData),
            {ok, NewModPlayerState}
    end;

%%神秘商店之请求购买
handle(15503, ModPlayerState, #pbshopbuy{
                                       pos = Pos
                                      })->
    case lib_shop:buy_mysterious(ModPlayerState, Pos) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {ok,  NewModPlayerState} ->
            {ok, BinData} = pt_15:write(15503, <<>>),
            packet_misc:put_packet(BinData),
            {ok, NewModPlayerState}
    end;

%%竞技场神秘商店之请求获取
handle(15504, ModPlayerState, _) ->
    ViceShop = lib_shop:get_vice_shop(ModPlayerState),
    {ok, BinData} = pt_15:write(15504, ViceShop),
    packet_misc:put_packet(BinData),
    {ok, ModPlayerState#mod_player_state{
           vice_shop = ViceShop
          }};

%% %%竞技场神秘商店之请求刷新
%% handle(15505, ModPlayerState, _)->
%%     case lib_shop:refresh_vice_shop(ModPlayerState) of 
%%         {fail, Reason} ->
%%             packet_misc:put_info(Reason);
%%         {ok, #mod_player_state{
%%                 vice_shop = ViceShop
%%                }=NewModPlayerState} ->
%%             {ok, BinData} = pt_15:write(15504, ViceShop),
%%             packet_misc:put_packet(BinData),
%%             {ok, NewModPlayerState}
%%     end;

%% %%竞技场神秘商店之请求购买
%% handle(15506, ModPlayerState, #pbshopbuy{
%%                                        pos = Pos
%%                                       })->
%%     case lib_shop:buy_vice_shop(ModPlayerState, Pos) of
%%         {fail, Reason} ->
%%             packet_misc:put_info(Reason);
%%         {ok,  NewModPlayerState} ->
%%             {ok, BinData} = pt_15:write(15506, <<>>),
%%             packet_misc:put_packet(BinData),
%%             {ok, NewModPlayerState}
%%     end;


%% 获取热卖商品列表
%%(这块的协议逻辑估计有问题)By LIU
handle(15510, ModPlayerState, _) ->
    SellingList = lib_shop:get_ordinary_selling_list(),
    {ok, BinData} = pt_15:write(15510, 
                                {SellingList, ModPlayerState#mod_player_state.ordinary_shop#ordinary_shop.shop_list}),
    packet_misc:put_packet(BinData),
    {ok, ModPlayerState};

%% 商场之购买商品
handle(15511, ModPlayerState, #pbordinarybuy{
                                 base_id = BaseId,
                                 num = ShopNum
                                }) ->
    case lib_shop:buy_ordinary_shop(ModPlayerState, BaseId, ShopNum) of
        {fail, Reason} ->
            {fail, Reason};
        {ok, NewModPlayerState} ->
            {ok, BinData} = pt_15:write(15511, <<>>),
            packet_misc:put_packet(BinData),
            {ok, NewModPlayerState}
    end;

%% %% 获取竞技场热卖商品列表
%% handle(15512, #mod_player_state{
%%                  player = Player
%%                 } = ModPlayerState, _) ->
%%     SellingList = lib_shop:get_main_selling_list(Player),
%%     {ok, BinData} = pt_15:write(15512, 
%%                                 {SellingList, ModPlayerState#mod_player_state.main_shop#main_shop.shop_list}),
%%     packet_misc:put_packet(BinData),
%%     {ok, ModPlayerState};

%% %%　竞技场商场之购买商品
%% handle(15513, ModPlayerState, #pbordinarybuy{
%%                                  base_id = BaseId,
%%                                  num = ShopNum
%%                                 }) ->
%%     case lib_shop:buy_main_shop(ModPlayerState, BaseId, ShopNum) of
%%         {fail, Reason} ->
%%             {fail, Reason};
%%         {ok, NewModPlayerState} ->
%%             {ok, BinData} = pt_15:write(15513, <<>>),
%%             packet_misc:put_packet(BinData),
%%             {ok, NewModPlayerState}
%%     end;

%% 获取抢购商城信息
handle(15555, #mod_player_state{
                 activity_record = ActivityRecord
                }=ModPlayerState, _) -> 
    ?DEBUG("ActivityRecord : ~p", [ActivityRecord]),
    case lib_shop:get_activity_shop(ActivityRecord) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {NewRecord, Opts} ->
            ?DEBUG("NewRecord: ~p", [NewRecord]),
            {ok, BinData} = pt_15:write(15555, Opts),
            packet_misc:put_packet(BinData),
            {ok, ModPlayerState#mod_player_state{
                   activity_record = NewRecord
                  }}
    end;

%% 抢购商城购买
handle(15556, ModPlayerState, #pbshopitem{
                                 id = ShopId,
                                 num = Num
                                }) ->
    case lib_shop:buy_activity_shop(ModPlayerState, ShopId, Num) of 
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {ok, NewModPlayerState} ->
            {ok, BinData} = pt_15:write(15556, <<>>),
            packet_misc:put_packet(BinData),
            {ok, NewModPlayerState}
    end;


%% 通用商城获取
handle(15560, ModPlayerState, #pbid32{id = StoreType}) ->
    case lib_shop:get_general_store_info(ModPlayerState, StoreType) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {ok, NewModPlayerState, GeneralStore} ->
            ?DEBUG("GeneralStore: ~p", [GeneralStore]),
            {ok, BinData} = pt_15:write(15560, GeneralStore),
            packet_misc:put_packet(BinData),
            {ok, NewModPlayerState}
    end;
%% 通用商城刷新
handle(15561, ModPlayerState, #pbid32{id = StoreType}) ->
    ?DEBUG("StoreType: ~p", [StoreType]),
    case lib_shop:refresh_general_store(ModPlayerState, StoreType) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {ok, NewModPlayerState, GeneralStore} ->
            {ok, BinData} = pt_15:write(15561, GeneralStore),
            packet_misc:put_packet(BinData),
            {ok, NewModPlayerState}
    end;
%% 通用商城购买
handle(15562, ModPlayerState, #pbgeneralstorebuy{
                                 store_type = StoreType,
                                 pos = Pos} = PbGeneralStoreBuy) ->
    case lib_shop:general_store_buy(ModPlayerState, StoreType, Pos) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {ok, NewModPlayerState} ->
            {ok, BinData} = pt_15:write(15562, PbGeneralStoreBuy),
            packet_misc:put_packet(BinData),
            {ok, NewModPlayerState}
    end; 
%% 获取抽奖信息
handle(15900, #mod_player_state{
                 choujiang_info = ChoujiangInfo
                }=ModPlayerState, _) ->
    {ok, BinData} = pt_15:write(15900, ChoujiangInfo),
    packet_misc:put_packet(BinData),
    {ok, ModPlayerState};

%% 抽奖操作
handle(15901, ModPlayerState, PbChoujiang) ->
    case lib_choujiang:get_choujiang_result(ModPlayerState, PbChoujiang) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {ok, NewModPlayerState, GoodsListInfo} ->
            ?DEBUG("GoodsListInfo: ~p", [GoodsListInfo]),
            {ok, BinData} = pt_15:write(15901, GoodsListInfo),
            packet_misc:put_packet(BinData), 
            {ok, NewModPlayerState}
    end;

handle(15910, ModPlayerState, #pbid32{id = MoneyNum}) ->
    case lib_recharge:recharge(ModPlayerState, MoneyNum) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {ok, NewModPlayerState} ->
            {ok, BinData} = pt_15:write(15910, null),
            packet_misc:put_packet(BinData), 
            {ok, NewModPlayerState}
    end;

handle(15911, ModPlayerState, #pbid32{id = _MoneyNum}) ->
    case lib_recharge:get_first_recharge_reward(ModPlayerState) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {ok, NewModPlayerState} ->
            {ok, BinData} = pt_15:write(15911, null),
            packet_misc:put_packet(BinData), 
            {ok, NewModPlayerState}
    end;

handle(15912, ModPlayerState, #pbcdkreward{type = Type,
                                           cdk = Cdk
                                          }) ->
    case lib_recharge:get_cdk_rewards(ModPlayerState, Type, Cdk) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {ok, NewModPlayerState} ->
            {ok, BinData} = pt_15:write(15912, null),
            packet_misc:put_packet(BinData), 
            {ok, NewModPlayerState}
    end;

%% 不匹配的协议
handle(_Cmd, _, _Data) ->
    ?WARNING_MSG("pp_handle no match, /Cmd/Data/ = /~p/~p/~n", [_Cmd, _Data]),
    {error, "pp_handle no match"}.


-define(MAX_COUNT, 200).

split_n(N) ->
    lists:reverse(split_n(N, [])).
split_n(N, RET) when N =< ?MAX_COUNT  ->
    [N|RET];
split_n(N, RET) ->
    split_n(N-?MAX_COUNT, [?MAX_COUNT|RET]).

    
        

