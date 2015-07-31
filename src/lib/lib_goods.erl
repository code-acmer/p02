-module(lib_goods).

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
-include("define_money_cost.hrl").
-include("define_task.hrl").
-include("define_log.hrl").

-include("db_base_xunzhang.hrl").

-export([save_bag/1,
         add_log/3,
         find_goods/2,
         dirty_goods/1,
         get_goods_count/2,
         get_other_player_goods/2,
         consume_goods/3,
         get_next_goods_id/0,

         delete_goods/2,
         delete_goods_by_id/2,
         db_delete_goods/1,
         del_goods/2,

         update_goods_info/2,
         update_goods/2,

         add_goods_list/3,
         base_goods_to_goods/4
        ]).

-export([create_role/1,
         role_login/1
        ]).

-export([inlaid_jewel/4,
         jewel_compose/3,
         jewel_remove/3,
         jewel_remove_all/2]).

-export([upgrade_skill_card/3,
         swear_skill_card/2
        ]).

-export([upgrade_xunzhang/2,
         get_xunzhang/1
        ]).

-export([buy_fashion/2,
         take_off_fashion_record/2,
         wear_fashion_record/2,
         get_player_fashion_info/1
        ]).

%% -------公用的函数--------------

save_bag(GoodsList) ->
    lists:map(fun(Goods) ->
                      hdb:save(Goods, #goods.is_dirty)
              end, GoodsList).

add_log(Args1, Args2, EventId) ->
    lib_log_player:add_log(EventId, Args1, Args2).

find_goods(GoodsId, GoodsList) ->
    case lists:keyfind(GoodsId, #goods.id, GoodsList) of
        false ->
            false;
        #goods{base_id = BaseId} = Goods ->
            case data_base_goods:get(BaseId) of
                [] ->
                    false;
                BaseGoods ->
                    {BaseGoods, Goods}
            end
    end.

dirty_goods(Goods) 
  when is_record(Goods, goods) ->
    Goods#goods{
      is_dirty = 1
     }.

get_goods_count(GoodsList, BaseId) ->
    case data_base_goods:get(BaseId) of
        [] ->
            0;
        BaseGoods ->
            get_goods_count2(GoodsList, BaseGoods)
    end.

get_goods_count2(GoodsList, #base_goods{
                               id = BaseId,
                               type = ?TYPE_GOODS_JEWEL}) ->
    lists:foldl(fun
                    (#goods{base_id = GoodsId,
                            sum = Sum}, AccCount) when GoodsId =:= BaseId ->
                        Sum + AccCount;
                    (#goods{type = ?TYPE_GOODS_EQUIPMENT,
                            jewels = Jewels}, AccCount) ->
                        get_jewel_num(Jewels, BaseId) + AccCount;
                    (_, AccCount) ->
                        AccCount
                end, 0, GoodsList);
get_goods_count2(GoodsList, #base_goods{id = BaseId}) ->
    lists:foldl(fun
                    (#goods{base_id = GoodsId,
                            sum = Sum}, AccCount) when GoodsId =:= BaseId ->
                       Sum + AccCount;
                    (_, AccCount) ->
                       AccCount
               end, 0, GoodsList).

get_jewel_num({}, _BaseId) ->
    0;
get_jewel_num(Jewels, BaseId) ->
    Size = erlang:tuple_size(Jewels),
    get_jewel_num2(Jewels, BaseId, Size, 0).

get_jewel_num2(_Jewels, _BaseId, 0, AccNum) ->
    AccNum;
get_jewel_num2(Jewels, BaseId, Size, AccNum) ->
    case erlang:element(Size, Jewels) of
        BaseId ->
            get_jewel_num2(Jewels, BaseId, Size - 1, AccNum + 1);
        _ ->
            get_jewel_num2(Jewels, BaseId, Size - 1, AccNum)
    end.

get_other_player_goods(PlayerId, GoodsId) ->
    case hmisc:whereis_player_pid(PlayerId) of
        [] ->
            case hdb:dirty_read(goods, GoodsId, true) of
                [] ->
                    {fail, ?INFO_GOODS_ITEM_NOT_FOUND};
                Goods ->
                    Goods
            end;
        Pid ->
            case mod_player:get_player_goods(Pid, GoodsId) of
                [] ->
                    {fail, ?INFO_GOODS_ITEM_NOT_FOUND};
                {ok, Goods} ->
                    Goods
            end
    end.

%%物品的消耗，包括金钱
consume_goods(Player, Consume, GoodsList) when is_list(Consume)->
    {Money, Meterial} = 
        lists:partition(fun
                            ({Id, _})
                        when Id =< 80 ->
                               true;
                            (_) ->
                               false
                       end, Consume),
    ?DEBUG("Money ~p, Meterial ~p~n", [Money, Meterial]),
    case lib_player:cost_money(Player, Money, ?COST_COMPOSE_JEWELS) of
        {ok, NewPlayer} ->
            case delete_goods(GoodsList, Meterial) of
                {fail, Reason} ->
                    {fail, Reason};
                {ok, NewGoodsList, Update, Del} ->
                    {ok, NewPlayer, NewGoodsList, Update, Del}
            end;
        {fail, Reason} ->
            {fail, Reason}
    end.
%------------
%%API 提供删除单个和多个的物品{id, Num} update是{oldgoods, newgoods}列表 del是[goods...]
delete_goods(GoodsList, {GoodsId, Num}) ->
    delete_goods2(GoodsList, {GoodsId, Num}, [], [], []);
delete_goods(GoodsList, CostGoodsList)
  when is_list(CostGoodsList) ->
    %?PRINT("GoodsList ~p CostGoodsList ~p~n", [GoodsList, CostGoodsList]),
    case delete_goods_list(GoodsList, CostGoodsList, [], []) of
        {fail, Reason} ->
            {fail, Reason};
        {ok, NewGoodsList, Update, Del} ->
            {ok, NewGoodsList, Update, Del}
    end.

delete_goods_list(GoodsList, [], Update, Del) ->
    {ok, GoodsList, Update, Del};
delete_goods_list(GoodsList, [{_, 0}], Update, Del) ->
    {ok, GoodsList, Update, Del};
delete_goods_list([], _CostGoodsList, _Update, _Del) ->
    {fail, ?INFO_GOODS_NOT_ENOUGH_COST};
delete_goods_list(GoodsList, [{Id, Num}|Tail], AccUpdate, AccDel) ->
    case delete_goods2(GoodsList, {Id, Num}, [], [], []) of
        {fail, Reason} ->
            {fail, Reason};
        {ok, NewGoodsList, Update, Del} ->
            delete_goods_list(NewGoodsList, Tail, Update ++ AccUpdate, Del ++ AccDel)
    end.

delete_goods2(_GoodsList, {_GoodsId, 0}, NewGoodsList, Update, Del) ->
    {ok, NewGoodsList, Update, Del};
delete_goods2([], {_GoodsId, _}, _NewGoodsList, _Update, _Del) ->
    {fail, ?INFO_GOODS_NOT_ENOUGH_COST};
delete_goods2([#goods{base_id = GoodsId, sum = Sum} = Goods|Tail], {GoodsId, Num}, NewGoodsList, Update, Del) ->
    if
        Sum > Num ->
            NewGoods = Goods#goods{sum = Sum - Num},
            delete_goods2([], {GoodsId, 0}, Tail ++ [NewGoods|NewGoodsList], [{Goods, NewGoods}|Update], Del);
        Sum =:= Num ->
            delete_goods2([], {GoodsId, 0}, Tail ++ NewGoodsList, Update, [Goods|Del]);
        Sum < Num ->
            delete_goods2(Tail, {GoodsId, Num - Sum}, NewGoodsList, Update, [Goods|Del])
    end;
delete_goods2([Goods|Tail], {GoodsId, Num}, NewGoodsList, Update, Del) ->
    delete_goods2(Tail, {GoodsId, Num}, [Goods|NewGoodsList], Update, Del).
%-----------
delete_goods_by_id(GoodsList, {Id, Sum}) ->    
    case lists:keytake(Id, #goods.id, GoodsList) of
        false ->
            {fail, ?INFO_GOODS_ITEM_NOT_FOUND};
        {value, #goods{sum = OSum} = Goods, Rest} when OSum > Sum ->
            NewGoods = Goods#goods{sum = OSum - Sum},
            {ok, [NewGoods|Rest], [{Goods, NewGoods}], []};
        {value, #goods{sum = Sum} = Goods, Rest} ->
            {ok, Rest, [], [Goods]};
        _ ->
            ?DEBUG("delete error ~p~n", [Id]),
            {fail, ?INFO_CONF_ERR}
    end;
delete_goods_by_id(GoodsList, ConsumeList) 
  when is_list(ConsumeList) ->
    delete_goods_by_id2(GoodsList, ConsumeList, [], []).

delete_goods_by_id2(GoodsList, [], AccUpdate, AccDel) ->
    {ok, GoodsList, AccUpdate, AccDel};
delete_goods_by_id2(GoodsList, [{Id, Sum}|Rest], AccUpdate, AccDel) ->
    case delete_goods_by_id(GoodsList, {Id, Sum}) of
        {fail, Reason} ->
            {fail, Reason};
        {ok, NewGoodsList, Update, Del} ->
            delete_goods_by_id2(NewGoodsList, Rest, Update ++ AccUpdate, Del ++ AccDel)
    end.
%---------
db_delete_goods(#goods{id = Id, 
                       base_id = BaseId,
                       sum = Sum}) ->
    lib_log_player:add_log(BaseId, Sum, ?LOG_EVENT_SUB_GOODS),
    hdb:dirty_delete(goods, Id);

db_delete_goods(GoodsList)
  when is_list(GoodsList) ->
    lists:foreach(fun(Goods) ->
                          db_delete_goods(Goods)
                  end, GoodsList).
%----------
del_goods(GoodsList, GoodsId) when is_integer(GoodsId) ->
    case lists:keytake(GoodsId, #goods.id, GoodsList) of
        false ->
            {0, [], GoodsList};
        {value, Goods, LeftGoods} ->
            {1, Goods, LeftGoods}
    end;
del_goods(GoodsList, GoodsIdList) when is_list(GoodsIdList) ->
    lists:foldl(fun(GoodsId, {Count, AccDel, AccGoodsList}) ->
                        {Num, Del, NewGoodsList} = del_goods(AccGoodsList, GoodsId),
                        {Count+Num, [Del|AccDel], NewGoodsList}
                end, {0, [], GoodsList}, GoodsIdList).
%----------
%%针对{old, new}形式
update_goods_info(UpdateInfoList, GoodsList) 
  when is_list(UpdateInfoList) ->
    lists:foldl(fun({_Old, Goods}, AccGoodsList) ->
                        lists:keystore(Goods#goods.id, #goods.id, AccGoodsList, Goods#goods{is_dirty = 1})
                end, GoodsList, UpdateInfoList).
%----------
update_goods(UpdateGoods, GoodsList)
when is_record(UpdateGoods, goods) ->
    lists:keystore(UpdateGoods#goods.id, #goods.id, GoodsList, UpdateGoods#goods{is_dirty = 1});
update_goods({_, Goods}, GoodsList) ->
    lists:keystore(Goods#goods.id, #goods.id, GoodsList, Goods#goods{is_dirty = 1});
update_goods(UpdateGoods, GoodsList) 
  when is_list(UpdateGoods)->
    lists:foldl(fun(Goods, AccGoodsList) ->
                        update_goods(Goods, AccGoodsList)
                end, GoodsList, UpdateGoods).
%% -------公用函数结束-------

%%-------------------------------------------------------------------------------%%
%%这个接口一般是lib_reward和内部使用
add_goods_list(PlayerId, GoodsList, AddGoodsInfo) ->  %%返回update的列表和新的物品
    {FinalAdd, FinalUpdate, FinalGoodsList} = 
        lists:foldl(fun
                        (#common_reward{goods_id = Id,
                                        goods_sum = Num,     
                                        bind = Bind}, {Add, Update, AccGoodsList}) ->
                            add_log(Id, Num, ?LOG_EVENT_ADD_GOODS),
                            {AddList, UpdateList, NewGoodsList} = add_goods(PlayerId, AccGoodsList, {Id, Num, Bind}),
                            {AddList ++ Add, UpdateList ++ Update, NewGoodsList};
                        ({Id, Num, Bind}, {Add, Update, AccGoodsList}) ->
                            add_log(Id, Num, ?LOG_EVENT_ADD_GOODS),
                            {AddList, UpdateList, NewGoodsList} = add_goods(PlayerId, AccGoodsList, {Id, Num, Bind}),
                            {AddList ++ Add, UpdateList ++ Update, NewGoodsList}
                        end, {[], [], GoodsList}, AddGoodsInfo),
    %handle_task(AddGoodsInfo),  %%等客户端检测
    {FinalAdd, FinalUpdate, FinalGoodsList}.

%% handle_task(GoodsInfo) ->
%%     TaskInfo = 
%%         lists:map(fun
%%                       (#common_reward{goods_id = Id, 
%%                                       goods_sum = Sum}) ->
%%                           {?TASK_GOODS, Id, Sum};
%%                       ({Id, Sum, _}) ->
%%                           {?TASK_GOODS, Id, Sum}
%%                   end, GoodsInfo),
%%     mod_player:task_event_list(self(), TaskInfo).

add_goods(PlayerId, GoodsList, {Id, Num, Bind}) ->
    case data_base_goods:get(Id) of
        [] ->
            {[], [], GoodsList};
        BaseGoods ->
            {Add, Update} = try_add_to_goodslist(PlayerId, BaseGoods, Num, Bind, GoodsList),
            {Add, Update, update_goods(Add ++ Update, GoodsList)}
    end.

try_add_to_goodslist(PlayerId, BaseGoods, Num, Bind, GoodsList) ->
    MaxOverLap = BaseGoods#base_goods.max_overlap,
    if 
        MaxOverLap =< 1 ->
            NewGoodsList = 
                lists:map(fun(_) ->
                                  base_goods_to_goods(PlayerId, BaseGoods, Bind, 1)
                          end, lists:seq(1, Num)),
            {NewGoodsList, []};
        true ->
            {LeftNum, UpdateList} = fill_goods(BaseGoods#base_goods.id, MaxOverLap, GoodsList, Num, []),
            %?DEBUG("LeftNum ~p, UpdateList ~p~n", [LeftNum, UpdateList]),
            Add = add_goods_with_max_over_lap(PlayerId, BaseGoods, Bind, LeftNum, []),
            {Add, UpdateList}
    end.

fill_goods(_BaseId, _MaxOverLap, [], Num, Update) ->
    {Num, Update};
fill_goods(_BaseId, _MaxOverLap, _GoodsList, 0, Update) ->
    {0, Update};
fill_goods(BaseId, MaxOverLap, [#goods{base_id = BaseId,
                                       sum = Sum} = CurGoods|Tail], Num, Update) 
  when Sum < MaxOverLap ->
    Ret = MaxOverLap - Sum,
    case Ret >= Num of
        true ->
            NewGoods = CurGoods#goods{sum = Sum + Num},
            fill_goods(BaseId, MaxOverLap, Tail, 0, [{CurGoods, NewGoods}|Update]);
        false ->
            NewGoods = CurGoods#goods{sum = MaxOverLap},
            fill_goods(BaseId, MaxOverLap, Tail, Num - Ret, [{CurGoods, NewGoods}|Update])
    end;
fill_goods(BaseId, MaxOverLap, [_|Tail], Num, Update) ->
    fill_goods(BaseId, MaxOverLap, Tail, Num, Update).

add_goods_with_max_over_lap(_PlayerId, _BaseGoods, _Bind, 0, Add) ->
    Add; 
add_goods_with_max_over_lap(PlayerId, #base_goods{max_overlap = MaxOverLap} = BaseGoods, Bind, Num, Add) ->
    if
        MaxOverLap >= Num ->
            NewGoods = base_goods_to_goods(PlayerId, BaseGoods, Bind, Num),
            add_goods_with_max_over_lap(PlayerId, BaseGoods, Bind, 0, [NewGoods|Add]);
        true ->
            NewGoods = base_goods_to_goods(PlayerId, BaseGoods, Bind, MaxOverLap),
            add_goods_with_max_over_lap(PlayerId, BaseGoods, Bind, Num - MaxOverLap, [NewGoods|Add])
    end.

%--------------BaseGoods To Goods------------------------------------------------

base_goods_to_goods(PlayerId, BaseGoods, Bind, Num) 
  when is_record(BaseGoods, base_goods)->
    NewBind = 
        case Bind of
            ?GOODS_BOUND_DEFAULT ->
                BaseGoods#base_goods.bind;
            Other ->
                Other
        end,
    Hole = 
        case data_base_goods_color_hole:get(BaseGoods#base_goods.color) of
            #base_goods_color_hole{hole = JewelHole} when JewelHole > 0 ->
                JewelHole;
            _ ->
                0
        end,
    StrLv = 
        if
            BaseGoods#base_goods.type =:= ?TYPE_GOODS_SKILL_CARD ->
                skill_card_str_lv(BaseGoods#base_goods.color);
            true ->
                0
        end,
    Timestamp = case BaseGoods#base_goods.expire_time of
                    0 ->
                        0;
                    ExpireTime when is_integer(ExpireTime) andalso ExpireTime > 0 ->
                        time_misc:unixtime() + ExpireTime;
                    _ ->
                        0
                end,
    Goods = 
        #goods{id = get_next_goods_id(),
               base_id      = BaseGoods#base_goods.id,
               player_id    = PlayerId,
               type         = BaseGoods#base_goods.type,
               subtype      = BaseGoods#base_goods.sub_type,
               sum          = Num,
               bind         = NewBind,
               str_lv       = StrLv,             %%强化等级默认是0级
               star_lv      = 0,
               max_overlap  = BaseGoods#base_goods.max_overlap,
               opear_type   = BaseGoods#base_goods.opear_type,
               quality      = BaseGoods#base_goods.quality,
               jewels       = erlang:make_tuple(Hole, 0),
               timestamp    = Timestamp
              },
    get_goods_att(BaseGoods, Goods).

%%这种方式不是很推荐的，因为一旦要改就要去改代码
skill_card_str_lv(0) ->
    1;
skill_card_str_lv(1) ->
    10;
skill_card_str_lv(2) ->
    25;
skill_card_str_lv(3) ->
    45;
skill_card_str_lv(4) ->
    70;
skill_card_str_lv(_) ->
    1.

get_next_goods_id() ->
    lib_counter:update_counter(goods_uid).

get_goods_att(BaseGoods, Goods)
  when is_record(Goods, goods)->
    ?DEBUG(" BaseGoods: ~p, Goods ~p ",[BaseGoods, Goods]),
    Rate = BaseGoods#base_goods.att_rate,
    NGoods = 
        Goods#goods{hp           = get_rand_att(BaseGoods#base_goods.hp_lim, Rate),
                    attack       = get_rand_att(BaseGoods#base_goods.attack, Rate), 
                    def          = get_rand_att(BaseGoods#base_goods.def, Rate),
                    hit          = get_rand_att(BaseGoods#base_goods.hit, Rate),
                    dodge        = get_rand_att(BaseGoods#base_goods.dodge, Rate),
                    crit         = get_rand_att(BaseGoods#base_goods.crit, Rate),
                    anti_crit    = get_rand_att(BaseGoods#base_goods.anti_crit, Rate),
                    stiff        = get_rand_att(BaseGoods#base_goods.stiff, Rate),
                    anti_stiff   = get_rand_att(BaseGoods#base_goods.anti_crit, Rate),
                    attack_speed = get_rand_att(BaseGoods#base_goods.attack_speed, Rate),
                    move_speed   = get_rand_att(BaseGoods#base_goods.move_speed, Rate),
                    ice          = get_rand_att(BaseGoods#base_goods.ice, Rate),
                    fire         = get_rand_att(BaseGoods#base_goods.fire, Rate),
                    honly        = get_rand_att(BaseGoods#base_goods.honly, Rate),
                    dark         = get_rand_att(BaseGoods#base_goods.dark, Rate),
                    anti_ice     = get_rand_att(BaseGoods#base_goods.anti_ice, Rate),
                    anti_fire    = get_rand_att(BaseGoods#base_goods.anti_fire, Rate),
                    anti_honly   = get_rand_att(BaseGoods#base_goods.anti_honly, Rate),
                    anti_dark    = get_rand_att(BaseGoods#base_goods.anti_dark, Rate),
                    mana_lim     = get_rand_att(BaseGoods#base_goods.mana_lim, Rate),
                    mana_rec     = get_rand_att(BaseGoods#base_goods.mana_rec, Rate)
                   },
    dirty_goods(get_ext_att(BaseGoods, NGoods)).

get_rand_att(Att, Rate) ->
    Low = Att * (100 - Rate) / 100, 
    Hight = Att * (100 + Rate) / 100,
    hmisc:rand(round(Low), round(Hight)).

%%获取物品的额外属性(要注意rand表,att_lv表,goods表字段名字一样，否则set会报错)
get_ext_att(#base_goods{type = ?TYPE_GOODS_EQUIPMENT,
                        sub_type = SubType,
                        lv = Lv,
                        color = Color
                       }, Goods) ->
    case data_base_goods_att_color:get(Color) of
        #base_goods_att_color{att_num = Num} 
          when Num > 0 andalso Num < 100 ->  %%保护机制，防止乱填导致崩溃
            lists:foldl(fun(_, AccGoods) ->
                                get_ext_att2(SubType, Lv, AccGoods)
                        end, Goods, lists:seq(1, Num));
        _ ->
            ?DEBUG("not att_color Color ~p~n", [Color]),
            Goods
    end;
get_ext_att(_, Goods) ->
    Goods.

get_ext_att2(SubType, Lv, Goods) ->
    case data_base_goods_att_rand:get(SubType) of
        [] ->
            [];
        AttList ->
            AttName = hmisc:rand(AttList),
            Value = 
                case data_base_goods_att_lv:get(Lv) of
                    [] ->
                        0;
                    BaseGoodsAttLv ->
                        dynarec_goods_att_lv_misc:rec_get_value(AttName, BaseGoodsAttLv)
                end,
            NewValue = hmisc:rand(Value * 80 div 100, Value * 120 div 100),  %%取一个浮动值 
            ?DEBUG("AttName ~p Value ~p~n", [AttName, NewValue]),
            NewGoods = dynarec_goods_misc:rec_set_value(transform_ext(AttName), NewValue, Goods),
            NewGoods
    end.

transform_ext(attack) ->
    attack_ext;
transform_ext(def) ->
    def_ext;
transform_ext(hp) ->
    hp_ext;
transform_ext(hit) ->
    hit_ext;
transform_ext(dodge) ->
    dodge_ext;
transform_ext(crit) ->
    crit_ext;
transform_ext(anti_crit) ->
    anti_crit_ext;
transform_ext(mana_lim) ->
    mana_lim_ext;
transform_ext(mana_rec) ->
    mana_rec_ext;
transform_ext(Other) ->
    ?WARNING_MSG("att transform error ~p~n", [Other]),
    undefined.

%----------------BaseGoods To Goods--------------------------------------------

%% --- 进程字典 （公用的系统）----

%% put_update_goods(List) when is_list(List) ->
%%     lists:foreach(fun(Info) ->
%%                           put_update_goods(Info)
%%                   end, List);
%% put_update_goods({Goods, Goods}) ->
%%     skip;
%% put_update_goods({OldGoods, NewGoods}) ->
%%     case get(goods_update) of
%%         undefined ->
%%             put(goods_update, [{OldGoods, NewGoods}]);
%%         InfoList ->
%%             put(goods_update, [{OldGoods, NewGoods}|InfoList])
%%     end.

%% put_add_goods([]) ->
%%     skip;
%% put_add_goods(GoodsList) 
%%   when is_list(GoodsList)->
%%     case get(goods_add) of
%%         undefined ->
%%             put(goods_add, GoodsList);
%%         InfoList ->
%%             put(goods_add, GoodsList ++ InfoList)
%%     end.

%% put_del_goods([]) ->
%%     skip;
%% put_del_goods(GoodsList)
%%   when is_list(GoodsList) ->
%%     case get(goods_del) of
%%         undefined ->
%%             put(goods_del, GoodsList);
%%         InfoList ->
%%             put(goods_del, GoodsList ++ InfoList)
%%     end.

%% inner_write_pb_goods() ->
%%     UpdateInfo = 
%%         case erase(goods_update) of
%%             undefined ->
%%                 [];
%%             Other ->
%%                 Other
%%         end,
%%     AddList = 
%%         case erase(goods_add) of
%%             undefined ->
%%                 [];
%%             Other1 ->
%%                 Other1
%%         end,
%%     DelList = 
%%         case erase(goods_del) of
%%             undefined ->
%%                 [];
%%             Other2 ->
%%                 Other2
%%         end,
%%     PbUpdateList = lists:foldl(fun({OldGoods, NewGoods}, AccUpdate) ->
%%                                        case record_misc:record_modified(pt_15:to_pbgoods(OldGoods), pt_15:to_pbgoods(NewGoods)) of
%%                                            [] ->
%%                                                AccUpdate;
%%                                            SendGoods ->
%%                                                [SendGoods#pbgoods{id = NewGoods#goods.id}|AccUpdate] 
%%                                        end
%%                                end, [], UpdateInfo),
%%     PbAddList =
%%         lists:map(fun(Goods) ->
%%                           pt_15:to_pbgoods(Goods)
%%                   end, AddList),
%%     PbDelList = 
%%         lists:map(fun(#goods{id = Id}) ->
%%                           #pbgoods{id = Id}
%%                   end, DelList),
%%     PbUpdateAll = PbUpdateList ++ PbAddList,
%%     if
%%         PbUpdateAll =:= [] andalso PbDelList =:= [] ->
%%             skip;
%%         true ->
%%             {ok, Bin} = pt:pack(15001, #pbgoodschanged{updated_list = #pbgoodslist{goods_list = PbUpdateAll},
%%                                                        deleted_list = #pbgoodslist{goods_list = PbDelList}}),
%%             packet_misc:put_packet(Bin)
%%     end.

%% ------------- 进程字典结束 -----------------------

%--------角色相关业务----------------

create_role(#player{career = Career,
                    bag_cnt = ObagCnt,
                    id = PlayerId} = Player) ->
    EquipFun = fun
                   (BaseId) when is_integer(BaseId) ->
                       case data_base_goods:get(BaseId) of
                           #base_goods{bind = Bind,
                                       type = ?TYPE_GOODS_EQUIPMENT,
                                       sub_type = SubType} = BaseGoods ->
                               Goods = base_goods_to_goods(PlayerId, BaseGoods, Bind, 1),
                               hdb:dirty_write(goods, Goods#goods{position = SubType,
                                                                  container = ?CONTAINER_EQUIP});
                           _ ->
                               skip
                       end;
                   ({BaseId, SetValues}) when is_list(SetValues) ->
                       case data_base_goods:get(BaseId) of
                           #base_goods{bind = Bind,
                                       type = ?TYPE_GOODS_SKILL_CARD} = BaseGoods ->
                               Goods = base_goods_to_goods(PlayerId, BaseGoods, Bind, 1),
                               NewGoods = lists:foldl(fun({Pos, Value}, RetGoods) ->
                                                              erlang:setelement(Pos, RetGoods, Value)
                                                      end, Goods, SetValues),
                               hdb:dirty_write(goods, NewGoods);
                           _ ->
                               skip
                       end
               end,
    EquipIdList = 
        if
            Career =:= ?MAI ->
                [22120015, 22300015, 22400015, 22500015, 22700015];
            true ->
                [22110015, 22300015, 22400015, 22500015, 22700015]
        end,
    SkillCardList = 
        if
            Career =:= ?MAI ->
                [
                 {90201001, [{#goods.card_pos_1, 1}, 
                             {#goods.card_pos_3, 1}]}, 
                 {90202001, [{#goods.card_pos_1, 2},
                             {#goods.card_pos_3, 2}]},
                 {90203001, [{#goods.card_pos_1, 3},
                             {#goods.card_pos_3, 3}]}, 
                 {90205001, [{#goods.card_pos_1, 4}]},
                 {90209001, [{#goods.card_pos_1, 11}]},
                 {90210001, [{#goods.card_pos_1, 12}]}, 
                 {90211001, [{#goods.card_pos_1, 13}]}
                ];
            true ->
                [
                 {90101001, [{#goods.card_pos_1, 1}, 
                             {#goods.card_pos_3, 1}]}, 
                 {90102001, [{#goods.card_pos_1, 2},
                             {#goods.card_pos_3, 2}]},
                 {90103001, [{#goods.card_pos_1, 3},
                             {#goods.card_pos_3, 3}]},
                 {90105001, [{#goods.card_pos_1, 4}]},
                 {90109001, [{#goods.card_pos_1, 11}]},
                 {90110001, [{#goods.card_pos_1, 12}]}, 
                 {90111001, [{#goods.card_pos_1, 13}]}
                ]
        end,
    lib_player:update_skill_record(SkillCardList, PlayerId),
    AddNum = 
        lists:foldl(fun(Id, AccNum) ->
                            EquipFun(Id),
                            AccNum + 1
                    end, 0, EquipIdList ++ SkillCardList),
    Player#player{bag_cnt = ObagCnt + AddNum}.
    
%% 加载所有物品并检测过期物品进行删除
role_login(PlayerId) ->
    GoodsList = hdb:dirty_index_read(goods, PlayerId, #goods.player_id, true),
    Now = time_misc:unixtime(),
    {DeletedIds, PlayerGoods} = lists:foldl(fun(#goods{id = Gid, timestamp = Timestamp} = G, {Del, RET}) ->
                        if
                            Timestamp >0 andalso Timestamp < Now -> 
                                {[Gid|Del], RET};
                            true -> 
                                NG = 
                                    lib_master:sync_skill_card_status(G, PlayerId),
                                {Del, [NG|RET]}
                        end
                end, {[],[]},GoodsList),
    case DeletedIds of
        [] ->
            ignored;
        DeletedIds ->
            hdb:dirty_delete(goods, DeletedIds)
    end,
    PlayerGoods.

                        

%---------角色相关业务（结束）------------

%%-----------宝石相关业务------------

%%镶嵌宝石
inlaid_jewel(#mod_player_state{bag = GoodsList,
                               player = #player{bag_cnt = BagCnt} = Player} = ModPlayerState, JewelBaseId, TarId, Pos) ->
   case check_inlaid_jewel(JewelBaseId, TarId, GoodsList, Pos) of
       {fail, Reason} ->
           {fail, Reason};
       {ok, Jewel, {OldGoods, NewGoods}} ->
           {UpdateInfoList, DelList, NewGoodsList} = inlaid_jewel2(Jewel, update_goods(NewGoods, GoodsList)),
           pt_15:pack_goods([], [{OldGoods, NewGoods}|UpdateInfoList], DelList),
           add_log(?LOG_EVENT_INLAID_JEWEL, NewGoods#goods.base_id, JewelBaseId),
           {ok, ModPlayerState#mod_player_state{bag = NewGoodsList,
                                                player = Player#player{bag_cnt = BagCnt - length(DelList)}}}
   end.

inlaid_jewel2(#goods{sum = Count} = Jewel, GoodsList) ->
    if
        Count =< 1 ->
            db_delete_goods(Jewel),
            {[], [Jewel], lists:keydelete(Jewel#goods.id, #goods.id, GoodsList)};
        true ->
            NewJewel = Jewel#goods{sum = Count - 1},
            UpGoodsList = update_goods(NewJewel, GoodsList),
            {[{Jewel, NewJewel}], [], UpGoodsList}
    end.

check_inlaid_jewel(JewelBaseId, TarId, GoodsList, Pos) ->
    case find_goods(TarId, GoodsList) of
        false ->
            ?DEBUG("not find Tar ~n", []),
            {fail, ?INFO_CONF_ERR};
        {_BaseGoods, #goods{jewels = JewelTuple} = Goods} ->
            JewelCount = erlang:size(JewelTuple),
            case lists:keyfind(JewelBaseId, #goods.base_id, GoodsList) of
                false ->
                    ?DEBUG("not find jewel ~n", []),
                    {fail, ?INFO_CONF_ERR};
                #goods{type = ?TYPE_GOODS_JEWEL} = Jewel ->
                    if
                        Pos > JewelCount ->
                            ?DEBUG("pos > count  ~n", []),
                            {fail, ?INFO_CONF_ERR};
                        Pos =< 0 ->
                            {fail, ?INFO_NOT_LEGAL_INT};
                        JewelCount =< 0 ->
                            {fail, ?INFO_GOODS_NOT_JEWEL_HOLE};
                        true ->
                            HoleJewel = erlang:element(Pos, JewelTuple),
                            if
                                HoleJewel > 0 ->
                                    {fail, ?INFO_GOODS_HOLE_HAS_JEWEL};
                                true ->
                                    NewJewelTuple = erlang:setelement(Pos, JewelTuple, JewelBaseId),
                                    NewGoods = Goods#goods{jewels = NewJewelTuple},
                                    {ok, Jewel, {Goods, NewGoods}}
                            end
                    end;
                _ ->
                    {fail, ?INFO_GOODS_NOT_JEWEL_TYPE}
            end
    end.


%%宝石合成
jewel_compose(#mod_player_state{bag = GoodsList,
                                player = Player} = ModPlayerState, BaseId, Num) ->
    case check_jewel_compose(BaseId, Num) of
        {fail, Reason} ->
            {fail, Reason};
        {ok, Consume} ->
            case consume_goods(Player, Consume, GoodsList) of
                {fail, Reason} ->
                    {fail, Reason};
                {ok, #player{bag_cnt = BagCnt} = NewPlayer, NewGoodsList, UpdateInfo, DelList} ->
                    db_delete_goods(DelList),
                    NGoodsList = update_goods_info(UpdateInfo, NewGoodsList),
                    {Add, UpdateInfo2, FinalGoodsList} = add_goods_list(NewPlayer#player.id, NGoodsList, [{BaseId, Num, ?GOODS_NOT_BIND}]),
                    pt_15:pack_goods(Add, UpdateInfo ++ UpdateInfo2, DelList),
                    {ok, NModPlayerState} = 
                        lib_player:update_skill_record(ModPlayerState, Add, UpdateInfo ++ UpdateInfo2),
                    add_log(?LOG_EVENT_COMPOSE_JEWEL, BaseId, 0),
                    NewModPlayerState = lib_task:task_event(NModPlayerState, {?TASK_FUNTION, ?TASK_FUNTION_COMPOSE_JEWEL, Num}),
                    {ok, NewModPlayerState#mod_player_state{bag = FinalGoodsList, 
                                                            player = NewPlayer#player{bag_cnt = BagCnt - length(DelList)}}}
            end
    end.

check_jewel_compose(_, Num) when Num =< 0 ->
    {fail, ?INFO_NOT_LEGAL_INT};
check_jewel_compose(BaseId, Num) ->
    case data_base_goods:get(BaseId) of
        [] ->
            {fail, ?INFO_CONF_ERR};
        #base_goods{type = Type} 
        when Type =:= ?TYPE_GOODS_JEWEL
             orelse Type =:= ?TYPE_GOODS_SKILL_CARD ->
            case data_base_goods_jewel:get(BaseId) of
                [] ->
                    {fail, ?INFO_CONF_ERR};
                #base_goods_jewel{meterial = Meterial} ->
                    NewMerterial = 
                        lists:map(fun({CostId, CostSum}) ->
                                          {CostId, CostSum * Num}
                                  end, Meterial),
                    {ok, NewMerterial}
            end;
        _ ->
            {fail, ?INFO_GOODS_NOT_COMPOSE}
    end.

%%卸下宝石(宝石id是baseid)
jewel_remove(ModPlayerState, EquipId, Pos) ->
    case check_jewel_remove(ModPlayerState, EquipId, Pos) of
        {fail, Reason} ->
            {fail, Reason};
        {ok, NewModPlayerState} ->
            {ok, NewModPlayerState}
    end.

check_jewel_remove(#mod_player_state{bag = GoodsList,
                                     player = Player} = ModPlayerState, EquipId, Pos) ->
    case lists:keyfind(EquipId, #goods.id, GoodsList) of
        false ->
            {fail, ?INFO_CONF_ERR};
        #goods{jewels = JewelTuple} = Equip ->
            Size = erlang:size(JewelTuple),
            if
                Pos > Size orelse Pos =< 0 ->
                    {fail, ?INFO_CONF_ERR};
                true ->
                    case erlang:element(Pos, JewelTuple) of
                        JewelId when is_integer(JewelId) andalso JewelId > 0 ->
                            NewEquip = Equip#goods{jewels = erlang:setelement(Pos, JewelTuple, 0)},
                            ?DEBUG("Equip ~p, NewEquip ~p~n", [Equip, NewEquip]),
                            NewGoodsList = update_goods(NewEquip, GoodsList),
                            {FinalAdd, FinalUpdate, FinalGoodsList} = add_goods_list(Player#player.id, NewGoodsList, [{JewelId, 1, ?GOODS_NOT_BIND}]),
                            pt_15:pack_goods(FinalAdd, [{Equip, NewEquip}|FinalUpdate], []),
                            add_log(?LOG_EVENT_REMOVE_JEWEL, Equip#goods.base_id, JewelId),
                            {ok, ModPlayerState#mod_player_state{bag = FinalGoodsList}};
                        _ ->
                            {fail, ?INFO_GOODS_HOLE_NOT_JEWEL}
                    end
            end
    end.

jewel_remove_all(#mod_player_state{bag = GoodsList,
                                   player = Player} = ModPlayerState, EquipId) ->
    case lists:keyfind(EquipId, #goods.id, GoodsList) of
        false ->
            {fail, ?INFO_GOODS_ITEM_NOT_FOUND};
        #goods{jewels = JewelsTuple} = Goods ->
            JewelsList = tuple_to_list(JewelsTuple),
            {JewelsInfo, HoleSize} = 
                lists:foldl(fun
                                (0, {AccJewels, AccCount}) ->
                                    {AccJewels, AccCount + 1};
                                (JewelId, {AccJewels, AccCount}) ->
                                    {[{JewelId, 1, ?GOODS_NOT_BIND}|AccJewels], AccCount + 1}
                            end, {[], 0}, JewelsList),
            if
                JewelsInfo =:= [] ->
                    {fail, ?INFO_GOODS_NOT_JEWEL};
                true ->
                    NewGoods = Goods#goods{jewels = erlang:make_tuple(HoleSize, 0)},
                    {Add, UpdateInfo, NewGoodsList} = add_goods_list(Player#player.id, GoodsList, JewelsInfo),
                    pt_15:pack_goods(Add, [{Goods, NewGoods}|UpdateInfo], []),
                    add_log(?LOG_EVENT_REMOVE_ALL_JEWEL, Goods#goods.base_id, 0),
                    {ok, ModPlayerState#mod_player_state{bag = update_goods(NewGoods, NewGoodsList)}}
            end
    end.

%%----------宝石相关业务（结束）-----------

%------------技能卡相关业务--------------
%%技能卡的升级还是不能和装备强化兼容,要冗余一些代码了
upgrade_skill_card(#mod_player_state{bag = GoodsList,
                                    player = #player{bag_cnt = BagCnt} = Player} = ModPlayerState, GoodsId, ConsumeList) ->
    case lists:keytake(GoodsId, #goods.id, GoodsList) of
        false ->
            {fail, ?INFO_GOODS_ITEM_NOT_FOUND};
        {value, #goods{type = ?TYPE_GOODS_SKILL_CARD} = Goods, Rest} ->
            case inner_upgrade_skill_card(Goods, Rest, ConsumeList) of
                {fail, Reason} ->
                    {fail, Reason};
                {ok, NewGoodsList, UpdateList, DelList} ->
                    db_delete_goods(DelList),
                    pt_15:pack_goods([], UpdateList, DelList),
                    {ok, NModPlayerState} = 
                        lib_player:update_skill_record(ModPlayerState, [], UpdateList),
                    NewModPlayerState = lib_task:task_event(NModPlayerState, {?TASK_FUNTION, ?TASK_FUNTION_SKILL_CARD_UP, 1}),
                    {ok, NewModPlayerState#mod_player_state{bag = NewGoodsList,
                                                            player = Player#player{bag_cnt = BagCnt - length(DelList)}}}
            end;
        _ ->
            ?DEBUG("not found ~n", []),
            {fail, ?INFO_CONF_ERR}
    end.

inner_upgrade_skill_card(#goods{str_lv = Lv} = Goods, Rest, ConsumeList) ->
    case data_base_goods:get(Goods#goods.base_id) of
        [] ->
            {fail, ?INFO_GOODS_ITEM_NOT_FOUND};
        #base_goods{max_strengthen = MaxLv,
                    strengthen_id = StrIndex} when Lv < MaxLv ->
            add_card_exp(Goods, Rest, ConsumeList, MaxLv, StrIndex);
        _ ->
            {fail, ?INFO_GOODS_STRENGTHEN_LV_FULL}
    end.

add_card_exp(#goods{skill_card_exp = Exp} = Goods, Rest, ConsumeList, MaxLv, StrIndex) ->
    case cal_all_exp(ConsumeList, 0, Rest) of
        {fail, Reason} ->
            {fail, Reason};
        AddExp ->
            case add_card_exp2(Goods#goods{skill_card_exp = Exp + AddExp}, MaxLv, StrIndex) of
                {fail, Reason} ->
                    {fail, Reason};
                {ok, NewGoods} ->
                    case delete_goods_by_id(Rest, ConsumeList) of
                        {fail, Reason} ->
                            {fail, Reason};
                       {ok, NewGoodsList, AccUpdate, AccDel} ->
                            {ok, [dirty_goods(NewGoods)|NewGoodsList], [{Goods, NewGoods}|AccUpdate], AccDel}
                    end
            end
    end.

add_card_exp2(#goods{str_lv = Lv} = Goods, MaxLv, _) 
  when Lv >= MaxLv ->
    {ok, Goods#goods{skill_card_exp = 0}};
add_card_exp2(#goods{str_lv = Lv,
                     skill_card_exp = Exp} = Goods, MaxLv, StrIndex) 
  when Lv < MaxLv ->
    case data_base_skill_exp:get(StrIndex * 1000 + Lv) of
        [] ->
            {fail, ?INFO_CONF_ERR};
        #base_skill_exp{exp_curr = ExpNext} when ExpNext =< Exp ->
            add_card_exp2(Goods#goods{str_lv = Lv + 1,
                                      skill_card_exp = Exp - ExpNext}, MaxLv, StrIndex);
        _ ->
            {ok, Goods}
    end.

cal_all_exp([], AccExp, _) ->
    AccExp;
cal_all_exp([{Id, Sum}|Rest], AccExp, GoodsList) ->
    case lists:keyfind(Id, #goods.id, GoodsList) of
        false ->
            {fail, ?INFO_GOODS_ITEM_NOT_FOUND};
        #goods{base_id = BaseId} ->
            case data_base_goods:get(BaseId) of
                [] ->
                    {fail, ?INFO_CONF_ERR};
                #base_goods{exp = Exp} ->
                    cal_all_exp(Rest, AccExp + Exp*Sum, GoodsList)
            end
    end.

swear_skill_card(#mod_player_state{bag = GoodsList} = ModPlayerState, PbGoodsList) ->
    {NewGoodsList, UpdateInfo} = swear_skill_card_loop(GoodsList, PbGoodsList, []),
    pt_15:pack_goods([], UpdateInfo, []),
    {ok, ModPlayerState#mod_player_state{bag = NewGoodsList}}.

swear_skill_card_loop(GoodsList, [], AccUpdate) ->
    {GoodsList, AccUpdate};
swear_skill_card_loop(GoodsList, [#pbgoods{id = Id,
                                           card_pos_1 = Pos1,
                                           card_pos_2 = Pos2,
                                           card_pos_3 = Pos3}|Tail], AccUpdate) ->
    case lists:keytake(Id, #goods.id, GoodsList) of
        false ->
            ?WARNING_MSG("skill_card not found ~p~n", [Id]),
            swear_skill_card_loop(GoodsList, Tail, AccUpdate);
        {value, #goods{type = ?TYPE_GOODS_SKILL_CARD} = Goods, RestGoodsList} ->
            {NewGoods, NewGoodsList, UpdateInfo} = 
                put_on_skill_card(Goods, RestGoodsList, [{#goods.card_pos_1, Pos1}, {#goods.card_pos_2, Pos2}, {#goods.card_pos_3, Pos3}], []),
            UpdateInfo2 = [{Goods, NewGoods}|UpdateInfo],

            NGoodsList = [dirty_goods(NewGoods)|NewGoodsList],
            swear_skill_card_loop(NGoodsList, Tail, UpdateInfo2 ++ AccUpdate);
        _ ->
            ?WARNING_MSG("not skill_card ~p~n", [Id]),
            swear_skill_card_loop(GoodsList, Tail, AccUpdate)
    end.     

%%UpdateInfo是有可能被顶掉的技能卡
put_on_skill_card(Goods, GoodsList, [], UpdateInfo) ->
    {Goods, GoodsList, UpdateInfo};
put_on_skill_card(Goods, GoodsList, [{_Pos, undefined}|Tail], UpdateInfo) ->
    put_on_skill_card(Goods, GoodsList, Tail, UpdateInfo);
put_on_skill_card(Goods, GoodsList, [{Pos, 0}|Tail], UpdateInfo) ->
    NewGoods = erlang:setelement(Pos, Goods, 0),
    put_on_skill_card(NewGoods, GoodsList, Tail, UpdateInfo);
put_on_skill_card(Goods, GoodsList, [{Pos, Value}|Tail], UpdateInfo) 
  when is_integer(Value) andalso Value > 0 andalso Value < 20 ->
    OldValue = erlang:element(Pos, Goods),
    NewGoods = erlang:setelement(Pos, Goods, Value),
    case list_misc:list_match_one([{Pos, Value}], GoodsList) of
        [] ->
                                                %?PRINT("put on new skill ~n", []),
            put_on_skill_card(NewGoods, GoodsList, Tail, UpdateInfo);
        TarGoods ->                                                %?PRINT("exchange skill ~n", []),
            %% SUB Type 00000 第二位区别技能卡类型 0 主动， 1 被动
            case ((element(#goods.subtype, NewGoods) rem 10000) div 1000) =:= 
                ((element(#goods.subtype, TarGoods) rem 10000) div 1000) of
                true ->
                    NewTarGoods = erlang:setelement(Pos, TarGoods, OldValue),
                    NewGoodsList = lists:keystore(TarGoods#goods.id, #goods.id, GoodsList, dirty_goods(NewTarGoods)),
                    put_on_skill_card(NewGoods, NewGoodsList, Tail, [{TarGoods, NewTarGoods}|UpdateInfo]);
                false ->
                    %% NewGoodsList = lists:keystore(TarGoods#goods.id, #goods.id, GoodsList, dirty_goods(TarGoods)),
                    put_on_skill_card(NewGoods, GoodsList, Tail, UpdateInfo)
            end
    end.

%--------------技能卡相关业务（结束）-------------


%% ------勋章相关业务-------
upgrade_xunzhang(#mod_player_state{
                    bag = GoodsList
                   } = ModPlayerState, GoodsId)->
    case lists:keytake(GoodsId, #goods.id, GoodsList) of 
        false ->
            {fail, ?INFO_CONF_ERR};
        {value, #goods{
                   str_lv = StrLv,
                   base_id = BaseId
                  } = Goods, Rest} ->
            case data_base_goods:get(BaseId) of
                [] ->
                    {fail, ?INFO_CONF_ERR};
                #base_goods{type = Type,
                            max_strengthen = MaxLv} ->
                    if
                        Type =:= ?TYPE_GOODS_SKILL_CARD andalso StrLv < MaxLv ->
                            {fail, ?INFO_GOODS_NOT_ENOUGH_LV};
                        true ->
                            case data_base_xunzhang:get(BaseId) of
                                [] -> 
                                    {fail, ?INFO_CONF_ERR};
                                #base_xunzhang{} = BaseXunzhang ->
                                    upgrade_xunzhang1(ModPlayerState, BaseXunzhang, Goods, Rest)
                            end
                    end
            end
    end.
upgrade_xunzhang1(#mod_player_state{
                     player = Player
                    }=ModPlayerState, #base_xunzhang{
                                         lv = Lv,
                                         consume = Consume,
                                         next_id = NextId
                                        }, Goods, Rest) ->
    PlayerLv = Player#player.lv,
    ?DEBUG(" PlayerLv ~p, Lv ~p ",[PlayerLv, Lv]),
    if
        PlayerLv < Lv ->
            {fail, ?INFO_NOT_ENOUGH_LEVEL};
        true ->
            %case lib_player:cost_money(Player, Consume, ?COST_UPGRADE_XUNZHANG) of 
            case consume_goods(Player, Consume, Rest) of
                {fail, Reason} ->
                    {fail, Reason};
                {ok, #player{bag_cnt = BagCnt} = NewPlayer, NGoodsList, Update, Del} ->
                    case data_base_goods:get(NextId) of
                        [] ->
                            {fail, ?INFO_CONF_ERR};
                        #base_goods{} = NextBaseGoods ->
                            NewXunzhang = get_goods_att(NextBaseGoods, Goods#goods{base_id = NextId}),
                            ?DEBUG("Goods: ~p NewXunzhang: ~p",[Goods, NewXunzhang]),
                            db_delete_goods(Del),
                            pt_15:pack_goods([], [{Goods, NewXunzhang}|Update], Del),
                            NewGoodsList = update_goods_info(Update, NGoodsList),
                            {ok, NModPlayerState} = 
                                lib_player:update_skill_record(ModPlayerState, [], [{Goods, NewXunzhang}|Update]),
                            {ok,  NModPlayerState#mod_player_state{
                                    player = NewPlayer#player{bag_cnt = BagCnt - length(Del)},
                                    bag = [dirty_goods(NewXunzhang)|NewGoodsList]
                                   }}
                    end
            end
    end.

get_xunzhang(#mod_player_state{
                player = Player,
                bag = GoodsList
               } = ModPlayerState)->
    case lists:keytake(?XUNZHANG_SUBTYPE, #goods.subtype, GoodsList) of
        {value, _Goods, _Rest} ->
            {fail, ?INFO_XUNZHANG_FIND};
        false ->
            case consume_goods(Player, [{?GOODS_TYPE_COMBAT_POINT, 500}], GoodsList) of
                {fail, Reason} ->
                    {fail, Reason};
                {ok, #player{bag_cnt = BagCnt} = NewPlayer, NGoodsList, Update, Del} ->
                    case data_base_goods:get(22600032) of
                        [] ->
                            {fail, ?INFO_CONF_ERR};
                        #base_goods{bind = Bind} = Xunzhang ->
                            PlayerId = Player#player.id,
                            Goods = base_goods_to_goods(PlayerId, Xunzhang, Bind, 1),
                            NewGoods = Goods#goods{position = ?XUNZHANG_SUBTYPE,
                                                   container = ?CONTAINER_EQUIP},
                            db_delete_goods(Del),
                            pt_15:pack_goods([NewGoods], Update, Del),
                            NewGoodsList = update_goods_info(Update, NGoodsList),
                            {ok,  ModPlayerState#mod_player_state{
                                    player = NewPlayer#player{bag_cnt = BagCnt - length(Del)},
                                    bag = [dirty_goods(NewGoods)|NewGoodsList]
                                   }}
                    end
            end
    end.
%% -------勋章相关业务（结束）------
buy_fashion(#mod_player_state{
               player = Player,
               bag = Bag
              } = ModPlayerState, FashionShopId) ->
    case check_same_fashion(Bag, FashionShopId) of
        {fail, Reason} ->
            {fail, Reason};            
        #base_shop{
           goods_id = FashionBaseId,
           consume = Consume
          } ->
            case data_base_goods:get(FashionBaseId) of
                [] ->
                    {fail, ?INFO_CONF_ERR};
                #base_goods{} ->
                    ?WARNING_MSG("Consume: ~p, FashionBaseId: ~p", [Consume, FashionBaseId]),
                    case lib_player:cost_money(Player, Consume, ?COST_BUY_FASHION) of
                        {fail, Reason} ->
                            {fail, Reason};
                        {ok, NPlayer} ->
                            {ok, NModPlayerState} = 
                                lib_reward:take_reward(ModPlayerState#mod_player_state{player = NPlayer}, [{FashionBaseId, 1}], ?COST_BUY_FASHION),
                            auto_swear_fashion(NModPlayerState, FashionBaseId)
                    end
            end
    end.

check_same_fashion(GoodsList, FashionShopId) ->
    case data_base_shop:get(FashionShopId) of
        [] ->
            {fail, ?INFO_CONF_ERR};
        #base_shop{goods_id = BaseId} = BaseShop ->
            case lists:keytake(BaseId, #goods.base_id, GoodsList) of
                false ->
                    BaseShop;
                _ ->
                    {fail, ?INFO_GOODS_ALREADY_HAS_FASHION}
            end
    end.

auto_swear_fashion(#mod_player_state{
                      bag = GoodsList,
                      player = Player
                     } = ModPlayerState, FashionBaseId) ->
    ?WARNING_MSG("FashionBaseId: ~p", [FashionBaseId]),
    case lists:keytake(FashionBaseId, #goods.base_id, GoodsList) of
        false ->
            ?WARNING_MSG("false ... "),
            {fail, ?INFO_GOODS_AUTO_SWAER_FASHION_FAIL};
        {value, Goods, _Rest} ->
            update_fashion_record(Player#player.id, FashionBaseId),
            lib_equip:swear_equip(ModPlayerState, Goods#goods.id)
    end.

update_fashion_record(PlayerId, FashionBaseId) ->
    case hdb:dirty_read(fashion_record, PlayerId) of
        [] ->
            hdb:dirty_write(fashion_record, #fashion_record{
                                               id = PlayerId,
                                               fashion_base_ids = [FashionBaseId]
                                              });
        #fashion_record{
           fashion_base_ids = L
          } = Record ->
            hdb:dirty_write(fashion_record, Record#fashion_record{
                                              fashion_base_ids = [FashionBaseId | L]
                                             })
    end.

take_off_fashion_record(PlayerId, Tuple) ->
    case hdb:dirty_read(fashion_record, PlayerId) of
        [] ->
            [];
        #fashion_record{
           take_off_history = L
          } = Record ->
            hdb:dirty_write(fashion_record, Record#fashion_record{
                                              take_off_history = [Tuple | L]
                                             })
    end.
    
wear_fashion_record(PlayerId, Tuple) ->
    case hdb:dirty_read(fashion_record, PlayerId) of
        [] ->
            [];
        #fashion_record{
           wear_history = L
          } = Record ->
            hdb:dirty_write(fashion_record, Record#fashion_record{
                                              wear_history = [Tuple | L]
                                             })
    end.

get_player_fashion_info(PlayerId) ->
    case hdb:dirty_index_read(goods, PlayerId, #goods.player_id, true) of
        [] ->
            [];
        GoodsList ->
            lists:foldl(fun(#goods{
                               base_id = BaseId,
                               type = ?TYPE_GOODS_FAHSION,
                               container = ?CONTAINER_EQUIP
                              } = Goods, Acc) ->
                               %% ?WARNING_MSG("Goods: ~p", [Goods]),
                                case data_base_goods:get(BaseId) of
                                    [] ->
                                        Acc;
                                    #base_goods{sub_type = SubType} ->
                                        [{BaseId, SubType} | Acc]
                                end;
                           (_, Acc) ->
                                Acc                                    
                        end, [], GoodsList)
    end.
    
