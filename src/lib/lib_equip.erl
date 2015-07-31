-module(lib_equip).

-include("define_player.hrl").
-include("pb_15_pb.hrl").
-include("define_limit.hrl").
-include("define_goods.hrl").
-include("define_logger.hrl").
-include("define_goods_type.hrl").
-include("define_money_cost.hrl").
-include("define_info_13.hrl").
-include("define_info_15.hrl").
-include("db_base_combat_skill.hrl").
-include("define_reward.hrl").
-include("db_base_vip.hrl").
-include("define_task.hrl").
-include("define_log.hrl").

-export([decomposition_equip/2,
         upgrade_equipment/4,
         swear_equip/2,
         take_off_equip/2,
         equip_smriti/3,
         transform_attri/3,
         get_all_decomposition/2
        ]).

%%--------装备相关业务-------------

%%%%%%%%%%%%%%%%%%%%%%分解装备设定为15010
decomposition_equip(#mod_player_state{bag = GoodsList,
                                      player = #player{lv = PlayerLv, bag_cnt = BagCnt} = Player} = ModPlayerState, GoodsId) ->
    case lists:keytake(GoodsId, #goods.id, GoodsList) of
        {value, #goods{base_id = BaseId,
                       sum = Sum} = DelGoods, NewGoodsList} ->
            case data_base_goods:get(BaseId) of
                #base_goods{
                   type = Type,
                   sub_type = SubType,
                   lv = Lv, 
                   decomposition = Decomposition} ->
                    case check_goods_lv(Type, SubType, Lv, PlayerLv) of
                        false ->
                            {fail, ?INFO_NOT_ENOUGH_LEVEL};
                        true ->
                            ?WARNING_MSG("PlayerId: ~p,try decomposition ~p,~p,~p~n",[Player#player.id, GoodsId, BaseId, Type]),
                            ?DEBUG("Decomposition ~p~n", [Decomposition]),
                            pt_15:pack_goods([], [], [DelGoods]),
                            lib_goods:db_delete_goods(DelGoods),
                            RewardList = get_all_decomposition(Decomposition, Sum),
                            ?DEBUG("decomposition get RewardList ~p~n", [RewardList]),
                            Flag = get_reward_flag(Type),
                            NModPlayerState = 
                                case lib_goods:jewel_remove_all(ModPlayerState, GoodsId) of
                                    {fail, _} ->
                                        ModPlayerState;
                                    {ok, NNModPlayerState} ->
                                        NNModPlayerState
                                end,
                            case lib_reward:take_reward(NModPlayerState#mod_player_state{bag = NewGoodsList,
                                                                                         player = Player#player{bag_cnt = BagCnt - 1}},
                                                        RewardList, ?INCOME_DECOMPOSE_GOODS, Flag) of
                                {fail, Reason} ->
                                    {fail, Reason};
                                {ok, NewModPlayerState} ->
                                    {ok, NewModPlayerState}
                            end
                    end;
                [] ->
                    {fail, ?INFO_CONF_ERR}
            end;
        false ->
            {fail, ?INFO_GOODS_ITEM_NOT_FOUND}
    end.

check_goods_lv(Type, SubType, Lv, PlayerLv) ->
    case {Type, SubType} of
        {?TYPE_GOODS_PACKET, 2502}->
            Lv =< PlayerLv;
        _ ->
            true
    end.



get_reward_flag(?TYPE_GOODS_PACKET) ->
    ?REWARD_TYPE_USE_GIFT;
get_reward_flag(_) ->
    false.

get_all_decomposition(Decomposition, Sum) ->
    get_all_decomposition2(Decomposition, Sum, []).

get_all_decomposition2(_Decomposition, 0, Acc) ->
    Acc;
get_all_decomposition2(Decomposition, Count, Acc) ->
    case lib_reward:generate_reward_list(Decomposition) of
        [] ->
            get_all_decomposition2(Decomposition, Count-1, Acc);
        RewardList ->
            NewAcc = 
                lists:foldl(fun(Reward, AccReward) ->
                                    decomposition_add(Reward, AccReward)     
                            end, Acc, RewardList),
            get_all_decomposition2(Decomposition, Count-1, NewAcc)
    end.    

decomposition_add(#common_reward{ 
                     goods_id = GoodsId,
                     goods_sum = GoodsSum}, List) ->
    case lists:keytake(GoodsId, 1, List) of
        false ->
            [{GoodsId, GoodsSum}|List];
        {value, {_, OSum}, Rest} ->
            [{GoodsId, OSum + GoodsSum}|Rest]
    end.

%%穿装备
swear_equip(#mod_player_state{bag = GoodsList,
                              player = Player} = ModPlayerState, GoodsId) ->
    case check_equip_swear(GoodsId, GoodsList, Player) of
        {fail, Reason} ->
            {fail, Reason};
        {ok, Goods, [], UpdateInfo} ->  %%穿上新的
            NewGoodsList = lib_goods:update_goods(Goods, GoodsList),
            pt_15:pack_goods([], UpdateInfo, []),
            {ok, ModPlayerState#mod_player_state{bag = NewGoodsList}};
        {ok, Goods, OldEquip, UpdateInfo} -> %%更换装备
            NewGoodsList = lib_goods:update_goods([Goods, OldEquip], GoodsList),
            pt_15:pack_goods([], UpdateInfo, []),
            {ok, ModPlayerState#mod_player_state{bag = NewGoodsList}}
    end.

check_equip_swear(GoodsId, GoodsList, Player) ->
    case lists:keyfind(GoodsId, #goods.id, GoodsList) of
        false ->
            {fail, ?INFO_GOODS_ITEM_NOT_FOUND};
        #goods{
           base_id = BaseId,
           type = Type
          } = Goods ->
            case data_base_goods:get(BaseId) of
                [] ->
                    {fail, ?INFO_GOODS_ITEM_NOT_FOUND};
                BaseGoods ->
                    if
                        Type =:= ?TYPE_GOODS_FAHSION ->
                            cheak_fashion_swear(Goods, GoodsList, Player, BaseGoods);
                        true ->
                            check_equip_swear(Goods, GoodsList, Player, BaseGoods)
                    end
            end
    end.

check_equip_swear(Goods, GoodsList, #player{
                                       career = Career, 
                                       lv = Lv}, #base_goods{career = RequireCareer,
                                                             type = BaseType,
                                                             sub_type = SubType,
                                                             lv = RequireLv}) ->
    NewGoods = Goods#goods{position = SubType, container = ?CONTAINER_EQUIP},
    if 
        BaseType =/= ?TYPE_GOODS_EQUIPMENT ->
            {fail, ?INFO_GOODS_NOT_EQUIPMENT};
        RequireCareer =/= ?EQUIP_NO_LIMIT andalso RequireCareer =/= Career ->
            {fail, ?INFO_GOODS_WRONG_CAREER};
        RequireLv > Lv ->
            {fail, ?INFO_GOODS_LEVEL_NOT_SATISFIED};
        true ->
            ?WARNING_MSG("SubType: ~p, position: ~p", [SubType, Goods#goods.position]),
            case lists:keyfind(SubType, #goods.subtype, get_container_equip(GoodsList)) of
                false ->
                    {ok, NewGoods, [], [{Goods, NewGoods}]};
                Goods ->
                    {fail, ?INFO_GOODS_HAVE_EQUIPED};
                OldEquip ->
                    NOldEquip = OldEquip#goods{position = 0, container = ?CONTAINER_BAG},
                    {ok, NewGoods, NOldEquip, [{Goods, NewGoods}, {OldEquip, NOldEquip}]}
            end
    end.

get_container_equip(GoodsList) ->
    lists:foldl(fun(#goods{container = Container} = Goods, Acc) ->
                        if
                            Container =:= ?CONTAINER_EQUIP ->
                                [Goods | Acc];
                            true ->
                                Acc
                        end
                end, [], GoodsList).

cheak_fashion_swear(Goods, GoodsList, #player{
                                         id = PlayerId,
                                         career = Career, 
                                         lv = Lv}, #base_goods{career = RequireCareer,
                                                               type = BaseType,
                                                               sub_type = SubType,
                                                               lv = RequireLv}) ->
    NewGoods = Goods#goods{position = SubType, container = ?CONTAINER_EQUIP},
    if 
        BaseType =/= ?TYPE_GOODS_FAHSION ->
            {fail, ?INFO_GOODS_NOT_FASHION};
        RequireCareer =/= ?FASHION_NO_LIMIT andalso RequireCareer =/= Career ->
            {fail, ?INFO_GOODS_WRONG_CAREER};
        %% RequireLv > Lv ->
        %%     {fail, ?INFO_GOODS_LEVEL_NOT_SATISFIED};
        true ->
            case lists:keyfind(SubType, #goods.position, GoodsList) of
                false ->
                    {ok, NewGoods, [], [{Goods, NewGoods}]};
                Goods ->
                    {fail, ?INFO_GOODS_FASHION_ALREADY_WEAR};
                OldFasion ->
                    NOldFasion = OldFasion#goods{position = 0, container = ?CONTAINER_BAG},
                    %?WARNING_MSG("NOldFasion: ~p", [NOldFasion]),
                    lib_goods:take_off_fashion_record(PlayerId, {time_misc:unixtime(), OldFasion#goods.id}),
                    lib_goods:wear_fashion_record(PlayerId, {time_misc:unixtime(), Goods#goods.id}),
                    {ok, NewGoods, NOldFasion, [{Goods, NewGoods}, {OldFasion, NOldFasion}]}
            end
    end.

take_off_equip(#mod_player_state{
                  bag = GoodsList,
                  player = Player
                 } = ModPlayerState, GoodsId) ->
    case check_take_off_equip(GoodsId, GoodsList, Player) of
        {fail, Reason} ->
            {fail, Reason};
        {ok, Equip, UpdateInfo} ->
            NewGoodsList = lib_goods:update_goods(Equip, GoodsList),
            pt_15:pack_goods([], UpdateInfo, []),
            {ok, ModPlayerState#mod_player_state{bag = NewGoodsList}}
    end.

check_take_off_equip(GoodsId, GoodsList, Player) ->
    case lists:keyfind(GoodsId, #goods.id, GoodsList) of
        false ->
            {fail, ?INFO_GOODS_ITEM_NOT_FOUND};
        #goods{type = GoodsType} = Goods ->
            if
                GoodsType =:= ?TYPE_GOODS_FAHSION ->
                    check_take_off_fasion(Goods, Player);
                true ->
                    check_take_off_equip(Goods)
            end            
    end.

check_take_off_equip(#goods{container = Container,
                            type = GoodsType} = Goods) ->
    if
        GoodsType =/= ?TYPE_GOODS_EQUIPMENT andalso GoodsType =/= ?TYPE_GOODS_SKILL_CARD ->
            {fail, ?INFO_GOODS_NOT_EQUIPMENT};
        Container =/= ?CONTAINER_EQUIP ->
            {fail, ?INFO_GOODS_NOT_IN_EQUIP};
        true ->
            NewGoods = Goods#goods{position = 0, container = ?CONTAINER_BAG},
            {ok, NewGoods, [{Goods, NewGoods}]}
    end.

check_take_off_fasion(#goods{container = Container,
                             type = GoodsType} = Goods, #player{id = PlayerId}) ->
    if
        GoodsType =/= ?TYPE_GOODS_FAHSION ->
            {fail, ?INFO_GOODS_NOT_FASHION};
        Container =/= ?CONTAINER_EQUIP ->
            {fail, ?INFO_GOODS_FASHION_NOT_WEAR};
        true ->
            NewGoods = Goods#goods{position = 0, container = ?CONTAINER_BAG},
            lib_goods:take_off_fashion_record(PlayerId, {time_misc:unixtime(), Goods#goods.id}),
            {ok, NewGoods, [{Goods, NewGoods}]}
    end.

%%传承       
equip_smriti(#mod_player_state{bag = GoodsList} = ModPlayerState, Id, Tid) -> 
    case check_smriti(GoodsList, Id, Tid) of
        {fail, Reason} ->
            {fail, Reason};
        {NewGoods, NewTarGoods, UpdateInfo} ->
            NewGoodsList = lib_goods:update_goods([NewGoods, NewTarGoods], GoodsList),
            pt_15:pack_goods([], UpdateInfo, []),
            lib_goods:add_log(NewGoods#goods.base_id, NewTarGoods#goods.base_id, ?LOG_EVENT_GOODS_SMRITI),
            NModPlayerState = 
                ModPlayerState#mod_player_state{
                  bag = NewGoodsList
                 },
            case lib_goods:jewel_remove_all(NModPlayerState, NewGoods#goods.id) of
                {fail, _Reason} ->
                    {ok, NModPlayerState};
                Other ->
                    Other
            end
    end.

check_smriti(GoodsList, Id, Tid) ->
    case lists:keyfind(Id, #goods.id, GoodsList) of
        false ->
            {fail, ?INFO_GOODS_ITEM_NOT_FOUND};
        Goods ->
            case lists:keyfind(Tid, #goods.id, GoodsList) of
                false ->
                    {fail, ?INFO_GOODS_ITEM_NOT_FOUND};
                TarGoods ->
                    case check_smriti2(Goods, TarGoods) of
                        {fail, Reason} ->
                            {fail, Reason};
                        {NewGoods, NewTarGoods} ->
                            {NewGoods, NewTarGoods, [{Goods, NewGoods}, {TarGoods, NewTarGoods}]}
                    end
            end
    end.
                        
check_smriti2(#goods{base_id = BaseId, str_lv = Str, 
                     star_lv = Star, subtype = SubType} = Goods, 
              #goods{base_id = TarBaseId, str_lv = TarStr,
                     star_lv = TarStar, subtype = TarSubType} = TarGoods) ->
    if
        SubType =/= TarSubType ->
            {fail, ?INFO_GOODS_NOT_SAME_SUB_TYPE};
        TarStr > 1 orelse TarStar > 1 ->
            {fail, ?INFO_GOODS_HAVE_UPGRADE};
        true ->
            case data_base_goods:get(BaseId) of
                [] ->
                    {fail, ?INFO_GOODS_ITEM_NOT_FOUND};
                #base_goods{
                   lv = Lv,
                   color = Color
                  } ->
                    case data_base_goods:get(TarBaseId) of
                        [] ->
                            {fail, ?INFO_GOODS_ITEM_NOT_FOUND};
                        #base_goods{
                           lv = TarLv,
                           color = TarColor
                          } ->
                            if
                                TarLv < Lv ->
                                    {fail, ?INFO_GOODS_TARGET_LV_LOWER};
                                true ->
                                    if
                                        TarColor < Color ->
                                            {fail, ?INFO_GOODS_COLOR_LV_LOWER};
                                        true -> 
                                            {Goods#goods{str_lv = TarStr, star_lv = TarStar}, 
                                             TarGoods#goods{str_lv = Str, star_lv = Star}}
                                    end
                            end
                    end
            end
    end.

%%装备强化及装备升星
%%强化升星统一都走这里
upgrade_equipment(ModPlayerState, GoodsId, UpgradeType, 1) ->
    upgrade_equipment2(ModPlayerState, GoodsId, UpgradeType, 1);
upgrade_equipment(#mod_player_state{player = Player} = ModPlayerState, GoodsId, UpgradeType, 10) ->
    case data_base_vip:get(Player#player.vip) of
        #base_vip{one_key_strength = 1} ->
            upgrade_equipment2(ModPlayerState, GoodsId, UpgradeType, 10);
        _ ->
            {fail, ?INFO_VIP_LEVEL_TOO_LOW}
    end.

upgrade_equipment2(#mod_player_state{player = Player,
                                     bag = GoodsList} = ModPlayerState, GoodsId, UpgradeType, Times) ->  %%要传强化的次数
    case find_goods(GoodsId, GoodsList)  of
        {fail, Reason} ->
            {fail, Reason};
        {ok, Goods, BaseGoods} ->
            case Goods#goods.type of
                ?TYPE_GOODS_EQUIPMENT ->
                    MaxUpgradeLv = max_upgrade_lv(Player#player.vip, UpgradeType, BaseGoods),
                    case get_to_upgrade(MaxUpgradeLv, Player, GoodsList, Goods, UpgradeType, Times, [], [], []) of
                        {fail, Reason} ->  %%config error
                            {fail, Reason};
                        {NewGoods, NewMyGoodsList, NewPlayer, Detail, UpdateInfoList, DelList} ->  
                            ?DEBUG("Detail: ~p", [Detail]),
                            UpgradeTimes = get_upgrade_times(Detail),
                            EnsureTimes = 
                                if
                                    UpgradeTimes < 10 ->
                                        0;
                                    true ->
                                        get_upgrade_rate(Goods, UpgradeType) div 10
                                end,
                            {NGoods, NMyGoodsList, NDetail} = 
                                ensure_upgrade_rate(NewGoods, NewMyGoodsList, UpgradeType, Detail, EnsureTimes, MaxUpgradeLv, Times),
                            {LogEvent, NowUpgradeLv} = 
                                if
                                    UpgradeType =:= ?TYPE_GOODS_STRENGTH  ->
                                        {?LOG_EVENT_GOODS_STRENGTH, NGoods#goods.str_lv};
                                    true ->
                                        {?LOG_EVENT_GOODS_ADD_STAR, NGoods#goods.star_lv}
                                end,
                            lib_goods:db_delete_goods(DelList),
                            DelNum = length(DelList),
                            OldBagCnt = NewPlayer#player.bag_cnt,
                            pt_15:pack_goods([], [{Goods, NGoods}|UpdateInfoList], DelList),
                            lib_goods:add_log(NGoods#goods.base_id, NowUpgradeLv, LogEvent),
                            NewModPlayerState = ModPlayerState#mod_player_state{bag = NMyGoodsList,
                                                                                player = NewPlayer#player{bag_cnt = OldBagCnt - DelNum}},
                            NModPlayerState = try_to_do_task(NewModPlayerState, UpgradeTimes, UpgradeType),
                            {ok, NModPlayerState, NDetail}
                    end;
                _ ->
                    {fail, ?INFO_GOODS_NOT_EQUIPMENT}
            end
    end.

try_to_do_task(ModPlayerState, Times, ?TYPE_GOODS_STRENGTH) ->
    lib_task:task_event(ModPlayerState, {?TASK_FUNTION, ?TASK_FUNTION_GOODS_STRENGTH, Times});
try_to_do_task(ModPlayerState, Times, ?TYPE_GOODS_ADD_STAR) ->
    lib_task:task_event(ModPlayerState, {?TASK_FUNTION, ?TASK_FUNTION_GOODS_ADD_STAR, Times}).

ensure_upgrade_rate(Goods, MyGoodsList, UpgradeType, Detail, _EnsureTimes, MaxUpgradeLv, 10) ->
    STimes = get_success_times(Detail),
    if
        %STimes >= EnsureTimes ->
        STimes >= ?ENSURE_UPGRADE_TIMES orelse length(Detail) =< 10 ->
            {Goods, lib_goods:update_goods(Goods, MyGoodsList), lists:reverse(Detail)};
        true ->
            {NewGoods, NewDetail} = add_upgrade_strength(Goods, Detail, ?ENSURE_UPGRADE_TIMES - STimes, UpgradeType, MaxUpgradeLv),
            {NewGoods, lib_goods:update_goods(NewGoods, MyGoodsList), NewDetail}
    end;
ensure_upgrade_rate(Goods, MyGoodsList, UpgradeType, Detail, EnsureTimes, MaxUpgradeLv, 1) ->
    STimes = get_success_times(Detail),
    if
        STimes >= EnsureTimes ->
        %STimes >= ?ENSURE_UPGRADE_TIMES ->
            {Goods, lib_goods:update_goods(Goods, MyGoodsList), lists:reverse(Detail)};
        true ->
            {NewGoods, NewDetail} = add_upgrade_strength(Goods, Detail, EnsureTimes - STimes, UpgradeType, MaxUpgradeLv),
            {NewGoods, lib_goods:update_goods(NewGoods, MyGoodsList), NewDetail}
    end.

%% ensure_upgrade_rate(Goods, MyGoodsList, ?TYPE_GOODS_STRENGTH, Detail, EnsureTimes, MaxUpgradeLv) ->
%%     STimes = get_success_times(Detail),
%%     if
%%         STimes >= EnsureTimes ->
%%             {Goods, lib_goods:update_goods(Goods, MyGoodsList), lists:reverse(Detail)};
%%         true ->
%%             {NewGoods, NewDetail} = add_upgrade_strength(Goods, Detail, EnsureTimes - STimes),
%%             {NewGoods, lib_goods:update_goods(NewGoods, MyGoodsList), NewDetail}
%%     end;
%% ensure_upgrade_rate(Goods, MyGoodsList, ?TYPE_GOODS_ADD_STAR, Detail, EnsureTimes, MaxUpgradeLv) ->
%%     STimes = get_success_times(Detail),
%%     if
%%         STimes >= EnsureTimes ->
%%             {Goods, lib_goods:update_goods(Goods, MyGoodsList), lists:reverse(Detail)};
%%         true ->
%%             {NewGoods, NewDetail} = add_upgrade_star(Goods, Detail, EnsureTimes - STimes),
%%             {NewGoods, lib_goods:update_goods(NewGoods, MyGoodsList), NewDetail}
%%     end.

get_upgrade_times([H|_] = Detail) ->
    if H > 1 ->
            length(Detail) - 1;
       true ->
            length(Detail)
    end.

get_success_times(Detail) ->
    lists:foldl(fun(Num, Count) ->
                        case Num of
                            1 ->
                                Count + 1;
                            _ ->
                                Count
                        end
                end, 0, Detail). 

add_upgrade_strength(#goods{str_lv = StrLv, star_lv = StarLv} = Goods, 
                     Detail, Times, UpgradeType, MaxUpgradeLv) ->   %%强化成功没达到保证值，给他加回来
    NewGoods = 
        if
            UpgradeType =:= ?TYPE_GOODS_STRENGTH andalso StrLv + Times >= MaxUpgradeLv ->
                Goods#goods{str_lv = MaxUpgradeLv};
            UpgradeType =:= ?TYPE_GOODS_STRENGTH ->
                Goods#goods{str_lv = StrLv + Times};
            UpgradeType =:= ?TYPE_GOODS_ADD_STAR andalso StarLv + Times >= MaxUpgradeLv ->
                Goods#goods{star_lv = MaxUpgradeLv};
            UpgradeType =:= ?TYPE_GOODS_ADD_STAR ->
                Goods#goods{star_lv = StarLv + Times}
        end,
    NewDetail = Detail -- lists:duplicate(Times, 0),
    {NewGoods, lists:reverse(lists:duplicate(Times, 1) ++ NewDetail)}.

%% add_upgrade_strength(Goods, Detail, Times) ->   %%强化成功没达到保证值，给他加回来
%%     #base_goods{max_strengthen = Max} = data_base_goods:get(Goods#goods.base_id),
%%     HopeLv = Goods#goods.str_lv + Times,
%%     StrLv = 
%%         if HopeLv >= Max ->
%%                 Max;
%%            true ->
%%                 HopeLv
%%         end,
%%     NewGoods = Goods#goods{str_lv = StrLv},
%%     NewDetail = Detail -- lists:duplicate(Times, 0),
%%     {NewGoods, lists:reverse(lists:duplicate(Times, 1) ++ NewDetail)}.

%% add_upgrade_star(Goods, Detail, Times) ->   %%强化成功没达到保证值，给他加回来
%%     #base_goods{max_star = Max} = data_base_goods:get(Goods#goods.base_id),
%%     HopeLv = Goods#goods.star_lv + Times,
%%     StarLv = 
%%         if HopeLv >= Max ->
%%                 Max;
%%            true ->
%%                 HopeLv
%%         end,
%%     NewGoods = Goods#goods{star_lv = StarLv},
%%     NewDetail = Detail -- lists:duplicate(Times, 0),
%%     {NewGoods, lists:reverse(lists:duplicate(Times, 1) ++ NewDetail)}.

get_upgrade_rate(#goods{base_id = BaseId} = Goods, UpgradeType) ->   %%获取强化成功几率
    #base_goods{strengthen_id = StrId,
                star_id = StarId} = data_base_goods:get(BaseId),
    case UpgradeType of
        ?TYPE_GOODS_STRENGTH ->
            Lv = Goods#goods.str_lv,
            ?DEBUG("StrId: ~p, Lv: ~p", [StrId, Lv]),
            #base_goods_strengthen{rate = Rate} = data_base_goods_strengthen:get(StrId * 1000 + Lv + 1),
            Rate;
        ?TYPE_GOODS_ADD_STAR ->
            Lv = Goods#goods.star_lv,
            #base_goods_strengthen{rate = Rate} = data_base_goods_strengthen:get(StarId * 1000 + Lv + 1 ),
            Rate
    end.

get_to_upgrade(_MaxUpgradeLv, Player, GoodsList, Goods, _UpgradeType, 0, Detail, AccUpdate, AccDel) ->
    {Goods, GoodsList, Player, Detail, AccUpdate, AccDel};
get_to_upgrade(MaxUpgradeLv, Player, GoodsList, Goods, UpgradeType, Times, Detail, AccUpdate, AccDel) 
  when Times > 0 ->
    case get_to_upgrade2(Player, GoodsList, Goods, UpgradeType, MaxUpgradeLv) of
        {error, Reason} ->
            {fail, Reason};
        {fail, Reason} ->
            {Goods, GoodsList, Player, [Reason|Detail], AccUpdate, AccDel};
        {ok, Goods, NewGoodsList, NewPlayer, Update, Del} ->       %%强化失败  
            get_to_upgrade(MaxUpgradeLv, NewPlayer, NewGoodsList, Goods, UpgradeType, Times - 1, [0|Detail], Update ++ AccUpdate, Del ++ AccDel);
        {ok, NewGoods, NewGoodsList, NewPlayer, Update, Del} ->
            get_to_upgrade(MaxUpgradeLv, NewPlayer, NewGoodsList, NewGoods, UpgradeType, Times - 1, [1|Detail], Update ++ AccUpdate, Del ++ AccDel) 
    end.

get_to_upgrade2(Player, GoodsList, Goods, UpgradeType, MaxUpgradeLv) ->
    case check_upgrade(MaxUpgradeLv, Goods, UpgradeType) of   %%检查升级是否合法，成功就返回消耗
        {error, Reason} ->   %%配置
            {error, Reason};
        {fail, Reason}  ->   %%满级
            {fail, Reason};
        {Consume, CostGoodsList} ->
            case lib_player:cost_money(Player, Consume, ?COST_STRENGTHEN_EQUIP) of
                {fail, Reason} ->
                    {fail, Reason};
                {ok, NPlayer} ->
                    case lib_goods:delete_goods(GoodsList, CostGoodsList) of
                        {fail, Reason} ->
                            {fail, Reason};
                        {ok, NewGoodsList, Update, Del} ->
                            %% lib_goods:put_update_goods(Update),
                            %% lib_goods:put_del_goods(Del),
                            %% lib_goods:db_delete_goods(Del),
                            NewGoods= add_att(Goods, UpgradeType),                            
                            NGoodsList = lib_goods:update_goods_info(Update, NewGoodsList),
                            {ok, NewGoods, NGoodsList, NPlayer, Update, Del}
                    end
            end
    end.

add_att(#goods{str_lv = StrLv} = Goods, ?TYPE_GOODS_STRENGTH) ->
    Rate = get_upgrade_rate(Goods, ?TYPE_GOODS_STRENGTH),
    NewGoods = 
        case hmisc:rand([{true, Rate}, {false, ?BASE_RATE - Rate}]) of
            true ->
                ?DEBUG("true.. Rate:~p", [Rate]),
                Goods#goods{str_lv = StrLv + 1};
            false ->
                ?WARNING_MSG("false.."),
                Goods
        end,
   NewGoods;

add_att(#goods{star_lv = StarLv} = Goods, ?TYPE_GOODS_ADD_STAR) ->
    Rate = get_upgrade_rate(Goods, ?TYPE_GOODS_ADD_STAR),
    NewGoods = 
        case hmisc:rand([{true, Rate}, {false, ?BASE_RATE - Rate}]) of
            true ->
                Goods#goods{star_lv = StarLv + 1};
            false ->
                Goods
        end,
    NewGoods.

check_upgrade(MaxUpgradeLv, Goods, Type) ->
    case data_base_goods:get(Goods#goods.base_id) of
        [] ->
            {error, ?INFO_GOODS_ITEM_NOT_FOUND};
        #base_goods{strengthen_id = StrengthId,
                    star_id = StarId} ->
            case Type of
                ?TYPE_GOODS_STRENGTH ->
                    StrLv = Goods#goods.str_lv,
                    if 
                        StrLv < MaxUpgradeLv ->
                            get_upgrade_cost(StrengthId, StrLv);
                        true ->
                            {fail, ?INFO_GOODS_STRENGTHEN_LV_FULL}
                    end;      
                ?TYPE_GOODS_ADD_STAR ->
                    StarLv = Goods#goods.star_lv,
                    if 
                        StarLv < MaxUpgradeLv ->
                            get_upgrade_cost(StarId, StarLv);
                        true ->
                            {fail, ?INFO_GOODS_STAR_FULL}
                    end
            end
    end.

max_upgrade_lv(Vip, UpgradeType, #base_goods{max_strengthen = BaseMaxStr,
                                             max_star = BaseMaxStar}) ->
    IsLimit = 
        case data_base_vip:get(Vip) of
            #base_vip{equip_strength_limit = 1} ->
                true;
            _ ->
                false
        end,
    if
        UpgradeType =:= ?TYPE_GOODS_STRENGTH andalso IsLimit =:= true ->
            BaseMaxStr;
        UpgradeType =:= ?TYPE_GOODS_ADD_STAR andalso IsLimit =:= true ->
            BaseMaxStar;
        UpgradeType =:= ?TYPE_GOODS_STRENGTH ->
            max(BaseMaxStr -10, 0);
        UpgradeType =:= ?TYPE_GOODS_ADD_STAR ->
            max(BaseMaxStar -10, 0);
        true ->
            0
    end.

find_goods(GoodsId, GoodsList) ->
    case lists:keyfind(GoodsId, #goods.id, GoodsList) of
        false ->
            {fail, ?INFO_GOODS_ITEM_NOT_FOUND};
        #goods{base_id = BaseId} = Goods ->
            case data_base_goods:get(BaseId) of
                [] ->
                    {fail, ?INFO_CONF_ERR};
                BaseGoods ->
                    {ok, Goods, BaseGoods}
            end
    end.

get_upgrade_cost(IndexId, Lv) ->
    ?DEBUG("IndexId ~p~n", [IndexId]),
    UpgradeId = IndexId * 1000 + Lv + 1,
    case data_base_goods_strengthen:get(UpgradeId) of
        [] ->
            {error, ?INFO_GOODS_UPGRADE_INFO_NOT_FOUND};
        #base_goods_strengthen{consume = Consume,
                               material = GoodsList} ->    %%[{id, num}....]
            {Consume, GoodsList}
    end.

transform_attri(#mod_player_state{
                   bag = OldGoodsList,
                   player = Player
                  } = ModPlayerState, Id, TId) ->
    case get_equip_by_color(Id, OldGoodsList, ?PURPLE_EQUIP) of
        {fail, Reason} ->
            {fail, Reason};
        {PulperBaseGoods, PulperGoods, GoodsList} ->
            case get_equip_by_color(TId, GoodsList, ?ORANGE_EQUIP) of
                {fail, Reason} ->
                    {fail, Reason};
                {OrangeBaseGoods, OrangeGoods, NGoodsList} ->
                    case transform_attri(PulperBaseGoods, PulperGoods, OrangeBaseGoods, OrangeGoods, Player#player.id) of
                        {fail, Reason} ->
                            {fail, Reason};
                        {NewPulperGoods, NewOrangeGoods, Consume} ->
                            ?WARNING_MSG("Consume: ~p, NGoodsList: ~p", [Consume, NGoodsList]),
                            ?DEBUG("PulperGoods: ~p, NewPulperGoods: ~p", [PulperGoods, NewPulperGoods]),
                            ?DEBUG("OrangeGoods: ~p, NewOrangeGoods: ~p", [OrangeGoods, NewOrangeGoods]),
                            case lib_goods:consume_goods(Player, Consume, NGoodsList) of
                                {fail, Reason} ->
                                    {fail, Reason};
                                {ok, NewPlayer, NewGoodsList, Update, Del} ->
                                    pt_15:pack_goods([], [{PulperGoods, NewPulperGoods}, {OrangeGoods, NewOrangeGoods}] ++ Update, Del),
                                    {ok, ModPlayerState#mod_player_state{
                                           player = NewPlayer,
                                           bag = [NewPulperGoods, NewOrangeGoods | NewGoodsList]
                                          }}
                            end
                    end
            end
    end.

transform_attri(#base_goods{
                   id      = PulperBaseId, 
                   lv      = PulperLv,
                   color   = Pulper,
                   quality = PulperQuality
                  }, 
                #goods{
                   id      = PulperGoodsId,
                   str_lv  = PulperStrLv,
                   star_lv = PulperStarLv,
                   jewels  = PulperJewels,
                   container = PulperContainer
                  }, 
                #base_goods{
                   id      = OrangeBaseId, 
                   lv      = OrangeLv,
                   color   = Orange,
                   quality = OrangeQuality
                  },
                #goods{
                   id      = OrangeGoodsId,
                   str_lv  = OrangeStrLv,
                   star_lv = OrangeStarLv,
                   jewels  = OrangeJewels,
                   container = OrangeContainer
                  }, PlayerId) ->
    TOrangeLv     = get_new_equip_lv(max(PulperLv, OrangeLv)),
    TOrangeStrLv  = max(PulperStrLv, OrangeStrLv),
    TOrangeStarLv = max(PulperStarLv, OrangeStarLv),
    TOrangeBaseId = count_equip_base_id(OrangeBaseId, TOrangeLv, Orange, OrangeQuality),
    NOrangeGoods  = get_equip_goods_by_ids(TOrangeBaseId, PlayerId),
    %% 重新生成紫色装备
    TPulperBaseId = count_equip_base_id(PulperBaseId, 0, Pulper, PulperQuality),
    NPulperGoods  = get_equip_goods_by_ids(TPulperBaseId, PlayerId),
    
    Consume = count_consume(PulperBaseId, OrangeBaseId, TPulperBaseId, TOrangeBaseId),

    case NOrangeGoods of
        {fail, Reason} ->
            {fail, Reason};
        _ ->
            case NPulperGoods of
                {fail, Reason} ->
                    {fail, Reason};
                _ ->
                    NewOrangeGoods = NOrangeGoods#goods{
                                       id      = OrangeGoodsId,
                                       str_lv  = TOrangeStrLv,
                                       star_lv = TOrangeStarLv,
                                       jewels  = OrangeJewels,
                                       container = ?CONTAINER_EQUIP
                                      },
                    NewPulperGoods = NPulperGoods#goods{
                                       id      = PulperGoodsId,
                                       str_lv  = 0,
                                       star_lv = 0,
                                       jewels  = PulperJewels,
                                       container = ?CONTAINER_BAG
                                      },
                    {NewPulperGoods, NewOrangeGoods, Consume}
            end
    end.

count_consume(PulperBaseId, OrangeBaseId, _TPulperBaseId, TOrangeBaseId) ->
    PulperConsume  = get_consume_by_base_id(PulperBaseId),
    OrangeConsume  = get_consume_by_base_id(OrangeBaseId),
    %TPulperConsume = get_consume_by_base_id(TPulperBaseId),
    TOrangeConsume = get_consume_by_base_id(TOrangeBaseId),
    OldConsume = lists:sort(PulperConsume ++ OrangeConsume),
    NewConsume = lists:sort(TOrangeConsume),
    NOldConsume = merge_consume(OldConsume),
    NNewConsume = merge_consume(NewConsume),
    FinalConsum = count_consume(lists:sort(NOldConsume), lists:sort(NNewConsume)),
    FinalConsum.    

count_consume(Consume1, Consume2) ->
    count_consume(Consume1, Consume2, []).

%% 支持当前需求
count_consume([], Rest, Acc) ->
    Rest ++ Acc;
count_consume([{Id, Num1}], [{Id, Num2}], []) ->
    [{Id, max(Num2 - Num1, 0)}];
count_consume([{Id, Num1} | T1], [{Id, Num2} | T2], Acc) ->
    count_consume(T1, T2, [{Id, max(Num2 - Num1, 0)} | Acc]);
count_consume([_ | T1], Consume, Acc) ->
    count_consume(T1, Consume, Acc).

merge_consume(Consume) ->
    merge_consume(Consume, []).

merge_consume([], Acc) ->
    Acc;
merge_consume([Value], []) ->
    [Value];
merge_consume([{Id, Num1}, {Id, Num2}], []) ->
    [{Id, Num1 + Num2}];
merge_consume([{Id, Num1} | T1], [{Id, Num2} | T2]) ->
    merge_consume(T1, [{Id, Num1 + Num2} | T2]);
merge_consume([H | T], Acc) ->
    merge_consume(T, [H | Acc]).

get_consume_by_base_id(PulperBaseId) ->    
    case data_base_goods:get(PulperBaseId) of
        [] ->
            [];
        #base_goods{value_meteorite = Consume} ->
            Consume
    end.            

get_equip_goods_by_ids(BaseId, PlayerId) ->
    case data_base_goods:get(BaseId) of
        [] ->
            {fail, ?INFO_CONF_ERR};
        #base_goods{bind = Bind} = BaseGoods ->
            lib_goods:base_goods_to_goods(PlayerId, BaseGoods, Bind, 1)
    end.

count_equip_base_id(BaseId, Lv, Color, Quality) ->
    BaseId div 10000 * 10000 + Lv * 100  + Color * 10 + Quality.

get_new_equip_lv(Lv) ->    
    if
        Lv < 10 ->
            0;
        true ->
            Lv div 10
    end.
    
get_equip_by_color(Id, GoodsList, Color) ->
    case lists:keytake(Id, #goods.id, GoodsList) of
        false ->
            {fail, ?INFO_GOODS_NOT_EQUIPMENT};
        {value, #goods{base_id = BaseId} = Goods, Rest} ->
            case data_base_goods:get(BaseId) of
                #base_goods{color = Color} = BaseGoods ->
                    {BaseGoods, Goods, Rest};
                _ ->
                    {fail, ?INFO_CONF_ERR}
            end
    end.  
%----------装备相关业务（结束）--------------  
