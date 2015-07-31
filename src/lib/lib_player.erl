%%%-------------------------------------------------------------------
%%% @author Zhangr <zhangr011@gmail.com>
%%% @copyright (C) 2013, Zhangr
%%% @doc
%%%
%%% @end
%%% Created :  5 Nov 2013 by Zhangr <zhangr011@gmail.com>
%%%-------------------------------------------------------------------
-module(lib_player).

-include("define_logger.hrl").
-include("define_goods_type.hrl").
-include("define_money_cost.hrl").
-include("define_player.hrl").
-include("define_time.hrl").
-include("define_info_13.hrl").
-include("define_info_15.hrl").
-include("define_player_skill.hrl").
-include("define_limit.hrl").
-include("db_base_function_open.hrl").
-include("db_pay_info.hrl").
-include("db_base_login_reward.hrl").
-include("db_base_combat_skill_strengthen.hrl").
-include("db_base_pvp_robot_attribute.hrl").
-include("db_base_month_reward.hrl").
-include("db_base_vip.hrl").
-include("define_task.hrl").
-include("define_cache.hrl").
-include("define_goods.hrl").
-include("define_reward.hrl").
-include("define_log.hrl").
-include("define_cross_pvp.hrl").
-include("define_mail_text.hrl").
-include("define_pay_info.hrl").
-include("db_base_notice.hrl").

%% API
-export([
         add_money/4,
         cost_money/3,
         cost_money/4,
         get_max_vigor/1,
         buy_vigor/1,
         init_player_vigor/4,
         init_login_days/3,
         new_pay_info/1,
         exp_and_lim/2,
         check_player_is_exist/1,
         reset_by_lv/1,
         vigor_limit/1,
         get_base_player_val/2,
         get_other_player_val/3,
         add_fpt/2,
         upgrade_skill/3,
         get_all_player_skill_from_db/1,
         change_sigil/3,
         get_other_player_equip/1,
         init_login_reward/2,
         login_reward_week/1,
         login_reward_month/1,
         to_player_skill/2,
         login_skill/1,
         login_skill_record/1,
         save_skill/1,
         save_skill_record/1,
         update_skill_record/2,
         update_skill_record/3,
         add_vigor_not_overflow/3,
         put_on_skill/2,
         battle_ability/2,
         get_players_nearby/1,
         daily_reset_cost/2,
         handle_cost_gold_rank/2,
         handle_cost_coin_rank/2,
         get_pvp_robot_attr/1,
         get_cross_robot_attr/1,
         daily_vip_reward/1,
         handle_pay_info/1,
         get_notice/1,
         get_player/1,
         get_player_skill_record/1,
         get_combat_attri_list/1,
         binding_qq/2
        ]).

-export([max_buy_vigors/1,
         login_vip_reward/1,
         save_vip_reward/1,
         recv_vip_reward/2]).

-export([get_other_player/1,
         get_other_player/2,
         get_other_player_list/3,
         get_other_player_mugen/1,
         get_other_player_skill/1,
         get_other_player_detail_list/2,
         get_other_player_detail/1
        ]).
%%%===================================================================
%%% API
%%%===================================================================
%% @doc 加角色资源
%% @spec PointId消费点
%% @end
add_money(Player, AddValue, Type, PointId) ->    
    NewAddValue = abs(AddValue),
    case add_money2(Player, NewAddValue, Type) of
        {fail, Reason} ->
            {fail, Reason};
        NewPlayer ->
            add_money_log(AddValue, Type, PointId),
            NewPlayer
    end.

add_money_log(AddValue, Type, PointId) ->
    %% EventId = case Type of
    %%               ?GOODS_TYPE_GOLD ->
    %%                   ?LOG_EVENT_ADD_GOLD;
    %%               ?GOODS_TYPE_COIN ->
    %%                   ?LOG_EVENT_ADD_COIN;
    %%               ?GOODS_TYPE_EXP ->
    %%                   ?LOG_EVENT_ADD_EXP;
    %%               ?GOODS_TYPE_VIGOR ->
    %%                   ?LOG_EVENT_ADD_VIGOR;
    %%               ?GOODS_TYPE_COMBAT_POINT ->
    %%                   ?LOG_EVENT_ADD_COMBAT_POINT;
    %%               ?GOODS_TYPE_HONOR ->
    %%                   ?LOG_EVENT_ADD_HONOR;
    %%               ?GOODS_TYPE_BGOLD ->
    %%                   ?LOG_EVENT_ADD_BIND_GOLD;
    %%               ?GOODS_TYPE_SEAL ->
    %%                   ?LOG_EVENT_ADD_SEAL;
    %%               ?GOODS_TYPE_CROSS_COIN ->
    %%                   ?LOG_EVENT_ADD_CROSS_COIN;
    %%               ?GOODS_TYPE_ARENA_COIN ->
    %%                   ?LOG_EVENT_ADD_ARENA_COIN;
    %%               ?GOODS_TYPE_LEAGUE_SEAL ->
    %%                   ?LOG_EVENT_ADD_LEAGUE_SEAL;
    %%               _ ->
    %%                   undefined
    %%           end,
    %% if
    %%     EventId =:= undefined ->
    %%         ignore;
    %%     true ->
    %% lib_log_player:put_log(#log_player{
    %%                           event_id = EventId,
    %%                           arg1 = PointId,
    %%                           arg2 = AddValue
    %%                          })
    %% end.
    lib_log_player:put_log(#log_player{
                              action = ?ACTION_TYPE_INCOME,
                              type   = Type,
                              num    = AddValue,
                              point_id = PointId,
                              event_id = 0
                              %% arg1 = PointId,
                              %% arg2 = AddValue
                             }).

cost_money_log(CostValue, Type, PointId) ->
    lib_log_player:put_log(#log_player{
                              action = ?ACTION_TYPE_COST,
                              type   = Type,
                              num    = CostValue,
                              point_id = PointId,
                              event_id = 0
                             }).

%% 特殊的处理放在前面匹配，通用或者不匹配的数据放在后面
%% 通用指那些只需要更改field(一个或者多个)的值（支持有上限），不是简单的add的话，就写特殊处理
add_money2(Player, AddValue, ?GOODS_TYPE_EXP) ->
    NewPlayer = inner_add_exp(Player, AddValue, ?EXP_TYPE_GOODS),
    lv_change_event(Player, NewPlayer),
    NewPlayer;
add_money2(Player, AddValue, ?GOODS_TYPE_COIN) ->
    Player#player{
      coin = Player#player.coin + AddValue
     };
add_money2(Player, AddValue, ?GOODS_TYPE_GOLD) ->
    Player#player{
      gold = Player#player.gold + AddValue
     };
add_money2(Player, AddValue, ?GOODS_TYPE_BGOLD) ->
    Player#player{
      bind_gold = Player#player.bind_gold + AddValue
     };
add_money2(Player, AddValue, ?GOODS_TYPE_VIGOR) ->
    Player#player{
      vigor = Player#player.vigor + AddValue
     };
add_money2(Player, AddValue, ?GOODS_TYPE_COMBAT_POINT) ->
    Player#player{
      combat_point = Player#player.combat_point + AddValue
     };
add_money2(Player, AddValue, ?GOODS_TYPE_HONOR) ->
    Player#player{
      honor = Player#player.honor + AddValue
     };
add_money2(Player, AddValue, ?GOODS_TYPE_SEAL) ->
    Player#player{
      seal = Player#player.seal + AddValue
     };
add_money2(Player, AddValue, ?GOODS_TYPE_VGOLD) ->
    NewPlayer = add_vip_exp(Player, AddValue),
    NewPlayer#player{
      gold = Player#player.gold + AddValue
     };
add_money2(Player, AddValue, ?GOODS_TYPE_CROSS_COIN) ->
    Player#player{
      cross_coin = Player#player.cross_coin + AddValue
     };
add_money2(Player, AddValue, ?GOODS_TYPE_ARENA_COIN) ->
    Player#player{
      arena_coin = Player#player.arena_coin + AddValue
     };
add_money2(Player, AddValue, ?GOODS_TYPE_LEAGUE_SEAL) ->
    Player#player{
      league_seal = Player#player.league_seal + AddValue
     };
add_money2(Player, AddValue, ?GOODS_TYPE_Q_COIN) ->
    Player#player{
      q_coin = Player#player.q_coin + AddValue
     };
add_money2(_, _, Type) ->
    ?WARNING_MSG("add money unknow type ~p~n", [Type]),
    {fail, ?INFO_ADD_MONEY_TYPE_ERR}.

%% @doc 直接花钱
%% @spec 返回{ok, NewPlayer}表示成功，
%%       否则{fail, Reason}

%%消耗传过来是一个列表
cost_money(Player, [], _PointId)  ->
    {ok, Player};
cost_money(Player, [{Id, Num}|Tail], PointId) ->
    case cost_money(Player, Num, Id, PointId) of
        {fail, Reason} ->
            {fail, Reason};
        {ok, NewPlayer} ->
            cost_money(NewPlayer, Tail, PointId)
    end.
%%消耗单个
cost_money(_, Cost, _, _)
  when Cost < 0 ->
    {fail, ?INFO_COST_MONEY_ERR};
cost_money(Player, 0, _Type, _PointId) ->
    {ok, Player};
cost_money(Player, Cost, Type, PointId) ->
    case cost_money2(Player, Cost, Type) of
        {fail, Reason} ->
            {fail, Reason};
        {ok, NewPlayer} ->
            cost_money_log(Cost, Type, PointId),
            {ok, NewPlayer}
    end.

cost_money2(Player, Cost, ?GOODS_TYPE_COIN) ->
    OldCoin = Player#player.coin,
    if 
        OldCoin < Cost ->
            {fail, ?INFO_NOT_ENOUGH_COIN};
        true ->
            CostCoin = Player#player.cost_coin,
            {ok, Player#player{coin = OldCoin - Cost, cost_coin = CostCoin + Cost}}
    end;
cost_money2(#player{gold = OldGold,
                    bind_gold = BGold,
                    cost_gold = CostGold} = Player, Cost, ?GOODS_TYPE_GOLD) ->
    if 
        OldGold + BGold < Cost ->
            {fail, ?INFO_NOT_ENOUGH_GOLD};
        BGold >= Cost ->
            mod_player:task_event(Player#player.id, {?TASK_FUNTION, ?TASK_FUNTION_COST_GOLD, Cost}), 
            {ok, Player#player{bind_gold = BGold - Cost, cost_gold = CostGold+Cost}};   
        true ->
            NeedGold = Cost - BGold,
            mod_player:task_event(Player#player.id, {?TASK_FUNTION, ?TASK_FUNTION_COST_GOLD, Cost}), 
            {ok, Player#player{gold = OldGold - NeedGold,
                               bind_gold = 0,
                               cost_gold = CostGold+Cost}}
    end;
cost_money2(Player, Cost, ?GOODS_TYPE_VIGOR) ->
    OldVigor = Player#player.vigor,
    if 
        OldVigor < Cost ->
            {fail, ?INFO_NOT_ENOUGH_VIGOR};
        true ->
            {ok, Player#player{vigor = OldVigor - Cost}}
    end;
cost_money2(Player, Cost, ?GOODS_TYPE_COMBAT_POINT) ->
    OldCombatPoint = Player#player.combat_point,
    if 
        OldCombatPoint < Cost ->
            {fail, ?INFO_NOT_ENOUGH_COMBAT_POINT};
        true ->
            {ok, Player#player{combat_point = OldCombatPoint - Cost}}
    end;
cost_money2(Player, Cost, ?GOODS_TYPE_HONOR) ->
    OldHonor = Player#player.honor,
    if
        OldHonor < Cost ->
            {fail, ?INFO_NOT_ENOUGH_HONOR};
        true ->
            {ok, Player#player{honor = OldHonor - Cost}}
    end;
cost_money2(Player, Cost, ?GOODS_TYPE_SEAL) ->
    OldSeal = Player#player.seal,
    if
        OldSeal < Cost ->
            {fail, ?INFO_NOT_ENOUGH_SEAL};
        true ->
            {ok, Player#player{seal = OldSeal - Cost}}
    end;

cost_money2(Player, Cost, ?GOODS_TYPE_CROSS_COIN) ->
    Old = Player#player.cross_coin,
    if
        Old < Cost ->
            {fail, ?INFO_NOT_ENOUGH_CROSS_COIN};
        true ->
            {ok, Player#player{cross_coin = Old - Cost}}
    end;

cost_money2(Player, Cost, ?GOODS_TYPE_ARENA_COIN) ->
    Old = Player#player.arena_coin,
    if
        Old < Cost ->
            {fail, ?INFO_NOT_ENOUGH_ARENA_COIN};
        true ->
            {ok, Player#player{arena_coin = Old - Cost}}
    end;

cost_money2(Player, Cost, ?GOODS_TYPE_LEAGUE_SEAL) ->
    Old = Player#player.league_seal,
    if
        Old < Cost ->
            {fail, ?INFO_NOT_ENOUGH_LEAGUE_SEAL};
        true ->
            {ok, Player#player{league_seal = Old - Cost}}
    end;
cost_money2(Player, Cost, ?GOODS_TYPE_Q_COIN) ->
    Old = Player#player.q_coin,
    if
        Old < Cost ->
            {fail, ?INFO_NOT_ENOUGH_Q_COIN};
        true ->
            {ok, Player#player{q_coin = Old - Cost}}
    end;
cost_money2(_, _, Type) ->
    ?WARNING_MSG("not support cost money type ~p~n", [Type]),
    {fail, ?INFO_NOT_SUPPORT_COST_MONEY_TYPE}.

get_max_vigor(Lv) ->
    case data_base_player:get(Lv) of
        #ets_base_player{vigor = VMax} ->
            VMax;
        _ ->
            0
    end.

add_vip_exp(#player{vip = Vip,
                    vip_exp = VipExp} = Player, AddValue) ->
    NewExp = VipExp + AddValue,
    NewVip = get_new_vip(Vip, NewExp),
    Player#player{vip = NewVip,
                  vip_exp = NewExp}.
    

get_new_vip(Vip, Exp) ->
    case data_base_vip:get(Vip + 1) of
        [] ->
            Vip;
        #base_vip{vip_value = Value} ->
            if
                Exp >= Value ->
                    get_new_vip(Vip + 1, Exp);
                true ->
                    Vip
            end
    end.
%% @doc 体力初始化
%% @spec
%% @end
%%为了减少体力误差，把下一次恢复体力的时间也返回去
init_player_vigor(OldVigor, LogOut, Now, Lv) ->
    MaxVigor = get_max_vigor(Lv),
    if
        OldVigor >= MaxVigor ->
            {OldVigor, ?VIGOR_RECOVER_TIME};
        true ->
            Sum = abs(Now - LogOut) div ?VIGOR_RECOVER_TIME,
            Rem = abs(Now - LogOut) - ?VIGOR_RECOVER_TIME * Sum,
            ?DEBUG("init_player_vigor OldVigor : ~w, Sum: ~w~n", [OldVigor, Sum]),
            NewVigor = add_vigor_not_overflow(Lv, OldVigor, Sum),
            {NewVigor, ?VIGOR_RECOVER_TIME - Rem}
    end.

%% @doc 登录天数初始化
init_login_days(LastLoginDays, LastLogin, Now) ->
    case time_misc:is_same_day(LastLogin, Now) of
        true ->
            LastLoginDays;
        false ->
            LastLoginDays + 1
    end.

%% @doc 有新的充值信息
%% @spec
%% @end

%% 玩家有新的充值信息
new_pay_info(Player) ->
    case hdb:dirty_index_read(pay_info, Player#player.id, #pay_info.player_id)  of
        [] ->
            ignored;
        PayInfos ->
            ?DEBUG("handling new pay info : ~p~n",[PayInfos]),
            NewPlayer = lists:foldl(fun(#pay_info{}, AddedPlayer) ->
                                            
                                            AddedPlayer
                                    end, Player, PayInfos),
            {ok, NewPlayer}
    end.

    %% case lib_log:get_pay_info(PlayerStatus#player.accid) of
    %%     [] ->
    %%         no_new_pay_info;
    %%     PayList when is_list(PayList) ->
    %%         NewPlayerStatus = lists:foldl(
    %%                             fun(#ets_pay_info{
    %%                                    order_money = OrderMoney
    %%                                   } = PayInfo, OldPlayerStatus) ->
    %%                                     PayGold = hmisc:ceil(OrderMoney/100),
    %%                                     %% 立即更新到数据库，更新后再给元宝
    %%                                     case lib_log:charge_pay_info(PayInfo#ets_pay_info.id) > 0 of
    %%                                         true ->
    %%                                             add_money(OldPlayerStatus, PayGold, ?GOODS_TYPE_GOLD, ?INCOME_CHARGE);
    %%                                         false ->
    %%                                             ?ERROR_MSG("charge failed, ~w~n", [PayInfo]),
    %%                                             OldPlayerStatus
    %%                                     end
    %%                             end, PlayerStatus, PayList),
    %%         NNewPlayerStatus = pay_info_event(NewPlayerStatus),
    %%         {ok, NNewPlayerStatus};
    %%     UnknowError ->
    %%         UnknowError
    %% end.
    %% no_new_pay_info.

%% @doc get current lv exp
%% @spec
%% @end
exp_and_lim(_, undefined) ->
    %% exp not modified
    {undefined, undefined};
exp_and_lim(Lv, Exp) ->
    case inner_get_base(Lv, #ets_base_player.exp_next, undefined) of
        undefined ->
            {undefined, undefined};
        ExpNext ->
            ExpCurr = 
                inner_get_base(Lv, #ets_base_player.exp_curr, undefined),
            {Exp - ExpCurr, ExpNext}
    end.

%% @doc 根据等级获取体力上限
%% @spec
%% @end
vigor_limit(Lv) ->
    inner_get_base(Lv, #ets_base_player.vigor, undefined).

%% @doc check player is exist
%% @spec
%% @end
check_player_is_exist(PlayerId) ->
    case hdb:dirty_read(player, PlayerId)  of
        [] -> false;
        _  -> true
    end.    

%% ================== internal functions =====================


%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------

%%%===================================================================
%%% Internal functions
%%%===================================================================

%% @doc 增加人物经验入口
%% @spec
%% @end
inner_add_exp(#player{lv = OldLv,
                      id = PlayerId} = Status, Exp, _ExpType) ->
    NewExp = Status#player.exp + Exp,
    {NewStatus, AddSkillList} = inner_add_exp_loop(Status, NewExp, []),
    ?DEBUG("lvlup add task ~p~n", [AddSkillList]),
    mod_player:new_skill(PlayerId, AddSkillList),  %%这边没传modplayer进来，只能cast过去保存技能信息
    if
        AddSkillList =:= [] ->
            skip;
        true ->
            {ok, BinData} = pt_13:write(13333, AddSkillList),
            packet_misc:put_packet(BinData)
    end,
    if
        NewStatus#player.lv > OldLv ->
            mod_player:lvlup_may_add_task(OldLv),
            %% mod_player_rec:new_player(NewStatus),
            mod_player:update_combat_attri(NewStatus#player.id),
            reset_by_lv(NewStatus);
         true ->
            NewStatus
    end.

inner_add_exp_loop(Status, Exp, AccSkillList) ->
    case Status#player.lv < ?PLAYER_MAX_LEVEL of
        true ->
            CurrentLv = Status#player.lv,
            ReqExp = inner_get_base(CurrentLv, 
                                    #ets_base_player.exp_next, 
                                    ?MAX_INT32),
            %% ?ERROR_MSG("Exp ~p ReqExp ~p~n", [Exp, ReqExp]),
            if
                Exp < ReqExp ->
                    {Status#player{exp = Exp}, AccSkillList};
                true ->
                    NewStatus = Status#player{lv = CurrentLv + 1},
                    AddSkillList = inner_check_player_skill(NewStatus),  %%每次升级都检查有没有新技能开放
                    inner_add_exp_loop(NewStatus, Exp - ReqExp, AddSkillList ++ AccSkillList)
            end;
        false ->
            {Status, AccSkillList}
    end.

%% 每升一级回调一次 用于 技能开放 | ...
inner_check_player_skill(Status) ->
    case data_base_function_open:get(0, Status#player.career, Status#player.lv) of
        #base_function_open{
           open = {Active, Passive}
          } ->
            ?DEBUG("skill_open Open:~w~n",[{Active, Passive}]),
            AddSkillList = 
                lists:foldl(fun(SkillId, AccSkillList) ->
                                    case to_player_skill(Status#player.id, SkillId) of
                                        [] ->
                                            AccSkillList;
                                        Other ->
                                            [Other|AccSkillList]
                                    end
                            end, [], Active ++ Passive),
            dirty_skill(AddSkillList);
        [] ->
            []
    end.
            


to_player_skill(PlayerId, SkillId) ->
    case data_base_combat_skill:get(SkillId) of
        [] ->
            [];
        BaseSkill ->
            #player_skill{
               id = get_next_skill_id(),
               skill_id = BaseSkill#base_combat_skill.id,
               player_id = PlayerId,
               type = BaseSkill#base_combat_skill.type   
              }
    end.

get_next_skill_id() ->
    lib_counter:update_counter(player_skill_uid).

%% 升级后的重置工作
reset_by_lv(#player{lv = Lv} = Player) ->
    case data_base_player:get(Lv) of
        [] ->
            Player;
        BasePlayer ->
            %% 基础属性都不发了，由客户端去读表
            Player#player{%hp_lim = BasePlayer#ets_base_player.hp_lim,
                          %mana_lim = BasePlayer#ets_base_player.mana_lim, 
                          %mana_init = BasePlayer#ets_base_player.mana_init, 
                          %hp_rec = BasePlayer#ets_base_player.hp_rec,
                          %mana_rec = BasePlayer#ets_base_player.mana_rec,
                          %ice = BasePlayer#ets_base_player.ice, 
                          %fire = BasePlayer#ets_base_player.fire, 
                          %honly = BasePlayer#ets_base_player.honly, 
                          %dark = BasePlayer#ets_base_player.dark,
                          %anti_ice = BasePlayer#ets_base_player.anti_ice, 
                          %anti_fire = BasePlayer#ets_base_player.anti_fire, 
                          %anti_honly = BasePlayer#ets_base_player.anti_honly,
                          %anti_dark = BasePlayer#ets_base_player.anti_dark,
                          %attack = BasePlayer#ets_base_player.attack,
                          %def = BasePlayer#ets_base_player.def,
                          %hit = BasePlayer#ets_base_player.hit,
                          %dodge = BasePlayer#ets_base_player.dodge,
                          %crit = BasePlayer#ets_base_player.crit,
                          %anti_crit = BasePlayer#ets_base_player.anti_crit,
                          %stiff = BasePlayer#ets_base_player.stiff,
                          %anti_stiff = BasePlayer#ets_base_player.anti_stiff,
                          %attck_speed = BasePlayer#ets_base_player.attck_speed,
                          %move_speed = BasePlayer#ets_base_player.move_speed,
                          cost = BasePlayer#ets_base_player.cost,
                          %vigor = BasePlayer#ets_base_player.vigor,
                          friends_limit = BasePlayer#ets_base_player.friends
                         }
    end.


inner_get_base(Lv, Position, Default) ->
    case data_base_player:get(Lv) of
        [] ->
            Default;
        Base ->
            element(Position, Base)
    end.

get_base_player_val(Lv, Position) ->
    inner_get_base(Lv, Position, 0).

get_other_player_val(PlayerId, RecordPos, Default) ->
    case get_other_player(PlayerId) of
        [] ->
            Default;
        Player ->
            element(RecordPos, Player)
    end.

add_fpt(Fpt, AddFpt) ->
    NewFpt = Fpt + AddFpt,
    if
        NewFpt >= ?MAX_FRIEND_POINT ->
            ?MAX_FRIEND_POINT;
        true ->
            NewFpt
    end.

add_vigor_not_overflow(Lv, Vigor, AddValue) ->
    Max = get_max_vigor(Lv),
    if
        Vigor > Max ->
            Vigor;
        true ->
            min(Vigor + AddValue, Max)
    end.

%% send_login_reward(#player{
%%                      id = PlayerId,
%%                      total_login_days = Day
%%                     }) ->
%%    MailHead = hmisc:format(data_sys_msg:get(login_reward_mail), [Day]),
%%    #base_login_reward{
%%       reward = Reward,
%%       desc = Desc
%%      } = get_login_reward(Day),
%%     lib_mail:send_sys_mail(PlayerId, 
%%                            hmisc:to_binary(MailHead ++ hmisc:to_list(Desc)),
%%                            Reward).

put_on_skill(#mod_player_state{player = Player} = ModPlayerState, SkillIds) ->
    {ok, ModPlayerState#mod_player_state{player = Player#player{normal_skill_ids = SkillIds}}}.
    %% case check_skill_exist(SkillList, SkillIds) of
    %%     true ->
    %%         {ok, ModPlayerState#mod_player_state{player = Player#player{normal_skill_ids = SkillIds}}};
    %%     _ ->
    %%         {fail, ?INFO_SKILL_NOT_FOUND}
    %% end.

%% check_skill_exist(_, []) ->
%%     true;
%% check_skill_exist(SkillList, [0|Tail]) ->
%%     check_skill_exist(SkillList, Tail);
%% check_skill_exist(SkillList, [SkillId|Tail]) ->
%%     case lists:keyfind(SkillId, #player_skill.skill_id, SkillList) of
%%         false ->
%%             false;
%%         _ ->
%%             check_skill_exist(SkillList, Tail)
%%     end.

battle_ability(#player{id = PlayerId,
                       sn = Sn,
                       nickname = NickName,
                       career = Career,
                       lv = Level
                      } = Player, NewAbility) ->
    if
        Player#player.battle_ability < NewAbility ->
            WriteTable = hdb:sn_table(battle_ability_rank, Sn),
            mod_rank:insert(WriteTable, PlayerId,
                            {NewAbility, PlayerId},
                            {NickName, Career, Level});
        true ->
            skip
    end.

%% handle_level_rank(#player{battle_ability = Ability,
%%                           id = PlayerId,
%%                           sn = Sn,
%%                           nickname = NickName,
%%                           career = Career,
%%                           lv = Level
%%                          }) ->
%%     WriteTable = hdb:sn_table(level_rank, Sn),
%%     Now = time_misc:unixtime(),
%%     mod_rank:insert(WriteTable, PlayerId,
%%                     {Level, -Now, PlayerId}, {NickName, Career, Ability}).


handle_cost_coin_rank(#player{battle_ability = Ability,
                              id = PlayerId,
                              sn = Sn,
                              nickname = NickName,
                              career = Career,
                              lv = Level,
                              cost_coin = CostCoin
                             }, CostCoinLast) ->
    if
        CostCoin =/= CostCoinLast ->
            WriteTable = hdb:sn_table(cost_coin_rank, Sn),
            mod_rank:insert(WriteTable, PlayerId,
                            {CostCoin, PlayerId}, {NickName, Career, Ability, Level});%加一个level
        true -> 
            false
    end.

handle_cost_gold_rank(#player{battle_ability = Ability,
                              id = PlayerId,
                              sn = Sn,
                              nickname = NickName,
                              career = Career,
                              lv = Level,
                              cost_gold = CostGold
                             }, CostGoldLast) ->
    if 
        CostGold =/= CostGoldLast ->
            WriteTable = hdb:sn_table(cost_gold_rank, Sn),
            mod_rank:insert(WriteTable, PlayerId,
                            {CostGold, PlayerId}, {NickName, Career, Ability, Level});%加一个level
        true -> 
            false
    end.
    
%%----------重新设计技能升级-----------%%
%%强化和升级走同一个接口
upgrade_skill(#mod_player_state{player = Player,
                                skill_list = SkillList} = ModPlayerState, SkillId, UpgradeType) ->
    case lists:keytake(SkillId, #player_skill.id, SkillList) of
        false ->
            {fail, ?INFO_SKILL_NOT_FOUND};
        {value, TSkill, Rest} ->
            case get_to_upgrade(Player, TSkill, UpgradeType) of
                {fail, Reason} ->
                    {fail, Reason};
                {ok, NewPlayer, NewSkill} ->
                    NSkill = check_open_sigil(NewSkill),   %%检查是否有新的符印开放
                    {EventId, NewLv} = 
                        if
                            UpgradeType =:= ?SKILL_UPGRADE ->
                                {?LOG_EVENT_SKILL_LV_UP, NSkill#player_skill.lv};
                            true ->
                                {?LOG_EVENT_SKILL_STR, NSkill#player_skill.str_lv}
                        end,
                    add_log(EventId, NSkill#player_skill.skill_id, NewLv),
                    NewModPlayerState = ModPlayerState#mod_player_state{player = NewPlayer,
                                                                        skill_list = [NSkill|Rest]},
                    NModPlayerState = do_task(NewModPlayerState, UpgradeType),
                    {ok, NModPlayerState, NSkill}
            end                            
    end.

do_task(ModPlayerState, ?SKILL_UPGRADE) ->
    lib_task:task_event(ModPlayerState, {?TASK_FUNTION, ?TASK_FUNTION_SKILL_UPGRADE, 1});
do_task(ModPlayerState, ?SKILL_STRENGTHEN) ->
    lib_task:task_event(ModPlayerState, {?TASK_FUNTION, ?TASK_FUNTION_SKILL_STRENGTH, 1}).


get_to_upgrade(Player, #player_skill{skill_id = BaseId, lv = UgrLv} = Skill, ?SKILL_UPGRADE) ->
    case data_base_combat_skill:get(BaseId) of
        [] ->
            ?PRINT("CONFIG SKILL NOT FOUND ~p~n", [BaseId]),
            {fail, ?INFO_SKILL_NOT_FOUND}; 
        #base_combat_skill{max_upgrade_lv = MaxLv, upgrade_id = UgrIndex} ->
            if
                UgrLv >= MaxLv ->
                    {fail, ?INFO_SKILL_MAX};
                true ->
                    case get_to_upgrade2(Player, UgrIndex + UgrLv, ?SKILL_UPGRADE) of  %%强化索引过去是 索引+等级
                        {fail, Reason} ->
                            {fail, Reason};
                        {ok, NewPlayer} ->
                            {ok, NewPlayer, Skill#player_skill{lv = UgrLv + 1}}
                    end
            end
    end;
get_to_upgrade(Player, #player_skill{skill_id = BaseId, str_lv = StrLv} = Skill, ?SKILL_STRENGTHEN) ->
    case data_base_combat_skill:get(BaseId) of
        [] ->
            {fail, ?INFO_SKILL_NOT_FOUND};
        #base_combat_skill{max_strengthen_lv = MaxLv, strengthen_id = StrIndex} -> 
            if
                StrLv >= MaxLv ->
                    {fail, ?INFO_SKILL_MAX};
                true ->
                    case get_to_upgrade2(Player, StrIndex + StrLv, ?SKILL_STRENGTHEN) of  %%强化索引过去是 索引+等级
                        {fail, Reason} ->
                            {fail, Reason};
                        {ok, NewPlayer} ->
                            {ok, NewPlayer, Skill#player_skill{str_lv = StrLv + 1}}
                    end
            end
    end.
%%扣钱和检查人物等级
get_to_upgrade2(Player, UgrIndex, ?SKILL_UPGRADE) ->
    case data_base_combat_skill_upgrade:get(UgrIndex) of
        [] ->
            ?ERROR_MSG("data_base_combat_skill_upgrade error Id ~p~n", [UgrIndex]),
            {fail, ?INFO_SKILL_NOT_FOUND}; 
        #base_combat_skill_upgrade{consume = Consume, req_lv = ReqLv} ->
            if
                Player#player.lv >= ReqLv ->
                    case cost_money(Player, Consume, ?COST_UPGRADE_SKILL) of
                        {fail, Reason} ->
                            {fail, Reason};
                        {ok, NewPlayer} ->
                            {ok, NewPlayer}
                    end;
                true ->
                    {fail, ?INFO_LV_LIMIT}
            end
    end;
get_to_upgrade2(Player, StrIndex, ?SKILL_STRENGTHEN) ->
    case data_base_combat_skill_strengthen:get(StrIndex) of
        [] ->
            ?ERROR_MSG("data_base_combat_skill_strengthen error Id ~p~n", [StrIndex]),
            {fail, ?INFO_SKILL_NOT_FOUND};
        #base_combat_skill_strengthen{consume = Consume} ->
            %?ERROR_MSG("Consume ~p~n", [Consume]),
            case cost_money(Player, Consume, ?COST_STRENGTH_SKILL) of
                {fail, Reason} ->
                    {fail, Reason};
                {ok, NewPlayer} ->
                    {ok, NewPlayer}
            end
    end.

check_open_sigil(#player_skill{skill_id = SkillId,
                               lv = Lv,
                               str_lv = StrLv,
                               sigil = Sigil} = Skill) ->
    BaseSkill = data_base_combat_skill:get(SkillId),
    case data_base_combat_skill:get_unique_skills(BaseSkill#base_combat_skill.unique_id) of
        [] ->
            ?ERROR_MSG("data_base_combat_skill error Id ~p~n", [BaseSkill#base_combat_skill.unique_id]),
            Skill;
        SkillIdList ->
            NewSigil = 
                lists:foldl(fun(Id, AccSigil) ->
                                    case data_base_combat_skill:get(Id) of
                                        #base_combat_skill{
                                           id = BaseId,
                                           condition = [ReqLv, ReqStrLv]} when ReqLv =< Lv andalso ReqStrLv =< StrLv ->
                                            [BaseId|AccSigil];
                                        _ ->
                                            AccSigil
                                    end
                            end, Sigil, SkillIdList),
            %%?QPRINT(NewSigil),
            dirty_skill(Skill#player_skill{sigil = lists:usort(NewSigil)})
    end.

%%切换符印
change_sigil(#mod_player_state{skill_list = SkillList} = ModPlayerState, Id, Tid) ->
    case lists:keytake(Id, #player_skill.id, SkillList) of
        false ->
            {fail, ?INFO_SKILL_NOT_FOUND};
        {value, #player_skill{
                   skill_id = SkillId,
                   sigil = Sigil} = Skill, Rest} ->
            if
                SkillId =:= Tid ->
                    {fail, ?INFO_SIGIL_SAME};
                true ->
                    case lists:member(Tid, Sigil) of
                        true ->
                            NewSkill = dirty_skill(Skill#player_skill{skill_id = Tid,
                                                                      sigil = [SkillId|lists:delete(Tid, Sigil)]}),
                            add_log(?LOG_EVENT_SKILL_CHANGE_SIGIL, SkillId, Tid),
                            {ok, ModPlayerState#mod_player_state{skill_list = [NewSkill|Rest]}, NewSkill};
                        false ->
                            {fail, ?INFO_SIGIL_NOT_FOUND}
                    end
            end;
        _ ->
            {fail, ?INFO_SKILL_NOT_FOUND}
    end.

dirty_skill_record(SkillRecord) when is_record(SkillRecord, player_skill_record) ->
    SkillRecord#player_skill_record{
      dirty = 1
     }.

dirty_skill(SkillList) when is_list(SkillList) ->
    lists:map(fun(Skill) ->
                      dirty_skill(Skill)
              end, SkillList);
dirty_skill(Skill) when is_record(Skill, player_skill) ->
    hdb:dirty(Skill, #player_skill.dirty).

get_all_player_skill_from_db(PlayerId) ->
    hdb:dirty_index_read(player_skill, PlayerId, #player_skill.player_id, true).

login_skill(PlayerId) ->
    hdb:dirty_index_read(player_skill, PlayerId, #player_skill.player_id, true).

login_skill_record(PlayerId) ->
    case hdb:dirty_read(player_skill_record, PlayerId) of
        #player_skill_record{} = Record ->
            Record;
        _ ->
            dirty_skill_record(#player_skill_record{
                                  player_id = PlayerId
                                 })
    end.

save_skill_record(SkillRecord) when is_record(SkillRecord, player_skill_record)->
    hdb:save(SkillRecord, #player_skill_record.dirty);
save_skill_record(_) ->
    ok.

save_skill(SkillList) ->
    lists:map(fun(Skill) ->
                      hdb:save(Skill, #player_skill.dirty)
              end, SkillList).

update_skill_record(#mod_player_state{
                       skill_record = SkillRecord
                      } = ModPlayerState, AddGoodsList, UpdatedGoods) ->
    GoodsList = 
        lists:foldl(fun({_, Goods}, AccList) ->
                            [Goods | AccList]
                    end, AddGoodsList, UpdatedGoods),
    NewSkillRecord = 
        lists:foldl(fun(#goods{base_id = BaseId}, OldSkillRecord) ->
                            update_skill_record1(BaseId, OldSkillRecord)
                    end, SkillRecord, GoodsList),    
    TmpSkillRecord = NewSkillRecord#player_skill_record{dirty = SkillRecord#player_skill_record.dirty
                                                       },
    case SkillRecord  of
        TmpSkillRecord ->
            ignored;
        _ ->
            mod_player:update_combat_attri(ModPlayerState?PLAYER_ID),
            {ok, Binary} = pt_15:write(15103, NewSkillRecord),
            packet_misc:put_packet(Binary)
    end,
    {ok, ModPlayerState#mod_player_state{
           skill_record = NewSkillRecord
          }}.

update_skill_record(SkillCardList, PlayerId) when is_list(SkillCardList) ->
    NewSkillRecord = 
        lists:foldl(fun({BaseId, _SetValues}, Record)->
                            update_skill_record1(BaseId, Record)
                    end, #player_skill_record{
                            player_id = PlayerId
                           }, SkillCardList),
    hdb:save(NewSkillRecord, #player_skill_record.dirty).

update_skill_record1(BaseId, OldSkillRecord) ->
    case data_base_goods:get(BaseId) of
        #base_goods{
           id = BaseId, 
           type = ?TYPE_GOODS_SKILL_CARD,
           sub_type = SubType
          } ->
            RecordList = OldSkillRecord#player_skill_record.skill_record_list,
            NewRecordList = 
                case lists:keytake(SubType, 1, RecordList) of
                    false ->
                        [{SubType, BaseId} | RecordList];
                    {value, {SubType, Id}, Reset} ->
                        if
                            BaseId > Id ->
                                [{SubType, BaseId} | Reset];
                            true ->
                                RecordList
                        end
                end,
            dirty_skill_record(OldSkillRecord#player_skill_record{
                                 skill_record_list = NewRecordList
                                });
        _ ->
            OldSkillRecord
    end.

get_other_player_equip(PlayerId) -> 
    case cache_misc:get({?OTHER_PLAYER_EQUIP, PlayerId}) of
        [] ->
            case hdb:dirty_index_read(goods, PlayerId, #goods.player_id, true) of
                [] ->
                    [];
                GoodsList ->
                    EquipList = 
                        lists:filter(fun
                                         (#goods{container = ?CONTAINER_EQUIP}) ->
                                             true;
                                         (_) ->
                                             false
                                     end, GoodsList),
                    cache_misc:set({?OTHER_PLAYER_EQUIP, PlayerId}, EquipList),
                    EquipList
            end;
        EquipList ->
            EquipList
    end.
%%获取其他玩家的信息
%% cache 暂时不用了，因为要取到真实的数据
get_other_player(PlayerId) ->
    case hmisc:whereis_player_pid(PlayerId) of
        [] ->
            case hdb:dirty_read(player, PlayerId, true) of
                Player when is_record(Player, player) ->
                    Player;
                _ ->
                    []
            end;
        Pid ->
            ?DEBUG("PlayerId ~p~n", [PlayerId]),
            mod_player:get_player(Pid)
    end.

get_player(PlayerId) ->
    hdb:dirty_read(player, PlayerId, true).

%%maybe only for http request
get_other_player_skill(PlayerId) ->
    case hmisc:whereis_player_pid(PlayerId) of
        [] ->
            login_skill(PlayerId);
        _ ->
            {_, _, SkillList, _, _} = get_other_player_detail(PlayerId),
            SkillList
    end.
    %% case cache_misc:get({?OTHER_PLAYER_INFO, PlayerId}) of
    %%     [] ->
    %%         case hdb:dirty_read(player, PlayerId, true) of
    %%             [] ->
    %%                 ?WARNING_MSG("not exist player ~p~n", [PlayerId]),
    %%                 [];
    %%             Player ->
    %%                 cache_misc:set({?OTHER_PLAYER_INFO, PlayerId}, Player),
    %%                 Player
    %%         end;
    %%     Player ->
    %%         Player
    %% end.
%%增加一个接口时获取特定服的玩家
get_other_player(PlayerId, Sn) ->
    case get_other_player(PlayerId) of
        #player{sn = Tsn} = Player ->
            if
                Tsn =:= Sn ->
                    Player;
                true ->
                    case server_misc:get_mnesia_sn(Sn) =:= server_misc:get_mnesia_sn(Tsn) of
                        true ->
                            Player;
                        false ->
                            []
                    end
            end;
        _ ->
            []
    end.

get_other_player_list(PlayerId, Sn, PlayerIdList) ->
    lists:foldl(fun(Tid, AccList) ->
                        if
                            Tid =:= PlayerId ->
                                AccList;
                            true ->
                                case get_other_player(Tid, Sn) of
                                    [] ->
                                        AccList;
                                    Player ->
                                        [Player|AccList]
                                end
                        end
                end, [], PlayerIdList).

get_other_player_mugen(PlayerId) ->
    case cache_misc:get({?OTHER_PLAYER_MUGEN, PlayerId}) of
        [] ->
            case hdb:dirty_read(dungeon_mugen, PlayerId, true) of
                [] ->
                    [];
                Mugen ->
                    cache_misc:set({?OTHER_PLAYER_MUGEN, PlayerId}, Mugen),
                    Mugen
            end;
        Mugen ->
            Mugen
    end.

get_combat_attri_list(PlayerIds) ->
    lists:foldl(fun(PlayerId, CombatAttriList) ->
                        case mod_combat_attri:get_combat_attri(PlayerId) of
                            [] ->
                                CombatAttriList;
                            CombatAttri ->
                                [CombatAttri|CombatAttriList]
                        end
                end, [], PlayerIds).


get_other_player_detail_list(#mod_player_state{bag = GoodsList,
                                               skill_list = SkillList,
                                               player = #player{id = PlayerId,
                                                                sn = Sn} = Player,
                                               dungeon_mugen = Mugen}, PlayerIdList) ->
    lists:foldl(fun
                    (TarId, AccDetail) when TarId =:= PlayerId ->
                        Self = {Player, GoodsList, lib_league:league_name_title(PlayerId, Sn), Mugen, SkillList},
                        [Self|AccDetail];
                    (TarId, AccDetail) ->
                        case get_other_player_detail(TarId) of
                            [] ->
                                AccDetail;
                            Detail ->
                                [Detail|AccDetail]
                        end
                end, [], PlayerIdList).
    
get_other_player_detail(PlayerId) ->
    case hmisc:whereis_player_pid(PlayerId) of
        [] ->
            case hdb:dirty_read(player, PlayerId, true) of
                #player{sn = Sn} = Player ->
                    GoodsList = hdb:dirty_index_read(goods, PlayerId, #goods.player_id, true),
                    SkillList = login_skill(PlayerId),
                    LeagueInfo = 
                        lib_league:league_name_title(PlayerId, Sn),
                    Mugen = lib_dungeon:login_mugen(PlayerId),
                    {Player, GoodsList, LeagueInfo, Mugen, SkillList};
                _ ->
                    []
            end;
        Pid ->
            #mod_player_state{skill_list = SkillList,
                              bag = GoodsList,
                              dungeon_mugen = Mugen,
                              league_info = LeagueInfo,
                              player = Player} = mod_player:get_player_detail(Pid),
            %{Player, GoodsList, SkillList, Mugen}
            {Player, GoodsList, LeagueInfo, Mugen, SkillList}
    end.

init_login_reward(#player{week_login_days = WeekLoginDays,
                          timestamp_login = LastLogin,
                          login_reward_flag = Flag} = Player, Now) ->
    case time_misc:is_same_day(LastLogin, Now) of
        true ->
            Player; 
        false ->
            %% NewWeekLoginDays = 
            %%     case time_misc:is_same_day(LastLogin, Now) of
            %%         true ->
            %%             case time_misc:get_week_day() of
            %%                 1 ->
            %%                     1;
            %%                 _ ->
            %%                     if
            %%                         Flag =:= ?REWARD_CAN_TAKE ->
            %%                             WeekLoginDays;
            %%                         true ->
            %%                             WeekLoginDays + 1
            %%                     end
            %%             end;
            %%         false ->
            %%             1
            %%     end,
            {NewWeekLoginDays, NewFlag} = 
                if
                    WeekLoginDays > 7 ->
                        {WeekLoginDays, ?REWARD_HAVE_TAKEN};
                    WeekLoginDays =:= 0 ->
                        {1, ?REWARD_CAN_TAKE};
                    true ->
                        case time_misc:is_same_day(LastLogin, Now) of
                            false ->
                                {WeekLoginDays, ?REWARD_CAN_TAKE};
                            true ->
                                {WeekLoginDays, ?REWARD_HAVE_TAKEN}
                        end
                end,
            Player#player{login_reward_flag = NewFlag,
                          week_login_days = NewWeekLoginDays}
    end.

%%领取登陆奖励
login_reward_week(#mod_player_state{player = #player{week_login_days = WeekLoginDays,
                                                     login_reward_flag = Flag}} = ModPlayerState) ->
    if
        Flag =:= ?REWARD_HAVE_TAKEN ->
            {fail, ?INFO_DAILY_REWARD_RECEIVED_TODAY};
        true ->
            case data_base_login_reward:get(WeekLoginDays) of
                [] ->
                    {fail, ?INFO_DAILY_REWARD_NOT_FOUND};
                #base_login_reward{reward = Reward} ->
                    case lib_reward:take_reward(ModPlayerState, Reward, ?INCOME_DAILY_LOGIN) of
                        {fail, Reason} ->
                            {fail, Reason};
                        {ok, #mod_player_state{player = NPlayer} = NewModPlayerState} ->
                            lib_log_player:log_system({ModPlayerState?PLAYER_ID, ?LOG_SEVEN_SIGN, 1, 0, 0}),
                            NewPlayer = NPlayer#player{
                                          login_reward_flag = ?REWARD_HAVE_TAKEN,
                                          week_login_days = WeekLoginDays + 1
                                         },
                            {ok, NewModPlayerState#mod_player_state{player = NewPlayer}}
                    end
            end
    end.

%%领取月登陆奖励
login_reward_month(#mod_player_state{
                      player = Player
                     } = ModPlayerState) ->
    Flag = Player#player.month_login_flag, 
    SignNum = Player#player.month_login_days,
    if
        SignNum =:= 0 ->
            get_reward_month(ModPlayerState, 1);
        true ->
            case Flag of
                ?REWARD_HAVE_TAKEN ->
                    {fail, ?INFO_MONTH_SIGN_FALSE};
                _ ->
                    get_reward_month(ModPlayerState, SignNum+1)
            end
    end.
get_reward_month(#mod_player_state{
                    player = Player
                   } = ModPlayerState, SignNum) ->
    PlayerVip = Player#player.vip,
    case data_base_month_reward:get(SignNum) of
        [] ->
            {fail, ?INFO_CONF_ERR};
        #base_month_reward{
           reward = Reward,
           vip = Vip
          } ->
            NewReward = 
                if 
                    Vip =:= 0 ->
                        Reward;
                    PlayerVip >= Vip ->
                        lists:map(fun({Id, Num}) ->
                                          {Id, Num*2}
                                  end, Reward);
                    true ->
                        Reward
                end,
            lib_reward:take_reward(ModPlayerState#mod_player_state{
                                     player = Player#player{
                                                month_login_flag = ?REWARD_HAVE_TAKEN,
                                                month_login_days = SignNum
                                               }
                                    }, NewReward, ?INCOME_MONTH_LOGIN)
    end.

lv_change_event(#player{lv = Same}, #player{lv = Same}) ->
    skip;
lv_change_event(#player{lv = OldLv}, #player{lv = NewLv} = _NewPlayer) ->
    lib_log_player:put_log(#log_player{
                              event_id = ?LOG_EVENT_LV_UP,
                              arg1 = OldLv,
                              arg2 = NewLv
                             }).

add_log(EventId, Args1, Args2) ->
    lib_log_player:put_log(#log_player{
                              event_id = EventId,
                              arg1 = Args1,
                              arg2 = Args2
                             }).

get_players_nearby(Player) ->
    PlayerIdList = 
        case catch mod_player_rec:recommend(Player) of
            IdList when is_list(IdList) ->
                IdList;
            Other ->
                ?WARNING_MSG("error occur ~p~n", [Other]),
                []
        end,
    lists:map(fun(PlayerId) ->
                      get_other_player(PlayerId)
              end, PlayerIdList).

daily_reset_cost(LogOut, #player_cost_state{} = LastCost) ->
    Now = time_misc:unixtime(),
    case time_misc:is_same_week(LogOut, Now) of
        true ->
            LastCost;
        false ->
            #player_cost_state{}
    end.

get_pvp_robot_attr(RobotId) ->
    case data_base_pvp_robot_attribute:get_id_by_robot_id(RobotId) of
        [Id] when is_integer(Id) ->
            case data_base_pvp_robot_attribute:get(Id) of
                [] ->
                    {fail, ?INFO_CONF_ERR};
                PvpRobotAttr ->
                    {ok, PvpRobotAttr}
            end;
        _ ->
            {fail, ?INFO_CONF_ERR}
    end.

%%
get_cross_robot_attr(RobotId) ->
    case data_base_kuafupvp_robot_attribute:get_attr(RobotId) of
        [] ->
            {fail, ?INFO_CONF_ERR};
        PvpRobotAttr ->
            {ok, PvpRobotAttr}
    end.

daily_vip_reward(#player{vip = Vip,
                         id = PlayerId}) ->
    case data_base_vip:get(Vip) of
        [] ->
            skip;
        #base_vip{day_benefits = Reward} ->
            if
                Reward =:= [] ->
                    skip;
                true ->
                    BaseMail = lib_mail:base_mail(?LOGIN_VIP_REWARD, [], Reward),
                    lib_mail:send_mail(PlayerId, BaseMail)
            end
    end.

max_buy_vigors(Vip) ->
    case data_base_vip:get(Vip) of
        [] ->
            0;
        #base_vip{times_for_vigor = Times} ->
            Times
    end.

buy_vigor(Player) ->
    BuyTimes = Player#player.buy_vigor_times,
    MaxBuyVigors = lib_player:max_buy_vigors(Player#player.vip),
    if
        Player#player.buy_vigor_times >= MaxBuyVigors ->
            {fail, ?INFO_GOODS_STAMINA_TIMES_OUT};
        true ->
            MaxVigor = lib_player:get_max_vigor(Player#player.lv),
            if
                MaxVigor =< Player#player.vigor ->
                    {fail, ?INFO_GOODS_STAMINA_EXCEED};
                true ->
                    case lib_vip:get_vip_cost(day_vigor_cost, BuyTimes + 1) of
                        {CostType, CostNum} ->
                            ?DEBUG("CostType ~p, CostNum ~p~n", [CostType, CostNum]),
                            case lib_player:cost_money(Player, CostNum, CostType, ?COST_BUY_VIGOR) of 
                                {fail, Reason} ->
                                    {fail, Reason};
                                {ok, CostPlayer} ->
                                    NewPlayer = lib_player:add_money(CostPlayer, ?BUY_VIGOR_VAULE, ?GOODS_TYPE_VIGOR, ?COST_BUY_VIGOR),
                                    {ok, NewPlayer#player{buy_vigor_times = BuyTimes + 1}}
                            end; 
                        error ->
                            {fail, ?INFO_CONF_ERR}
                    end
            end
    end.

login_vip_reward(PlayerId) ->
    case hdb:dirty_read(vip_reward, PlayerId, true) of
        [] ->
            #vip_reward{player_id = PlayerId,
                        dirty = 1
                       };
        Other ->
            Other
    end.

save_vip_reward(VipReward) ->
    hdb:save(VipReward, #vip_reward.dirty).

recv_vip_reward(#mod_player_state{vip_reward = #vip_reward{recv_list = RecvList} = VipReward,
                                  player = Player} = ModPlayerState, VipLevel) ->
    case check_recv_vip_reward(VipReward, Player#player.vip, VipLevel) of
        {fail, Reason} ->
            {fail, Reason};
        {ok, Reward} ->
            lib_reward:take_reward(ModPlayerState#mod_player_state{
                                     vip_reward = VipReward#vip_reward{recv_list = [VipLevel|RecvList],
                                                                       dirty = 1}}, 
                                   Reward, ?INCOME_VIP_REWARD)
    end.

check_recv_vip_reward(_VipReward, PlayerVip, VipLevel) when PlayerVip < VipLevel ->
    {fail, ?INFO_VIP_LEVEL_TOO_LOW};
check_recv_vip_reward(#vip_reward{recv_list = RecvList}, _PlayerVip, VipLevel) ->
    case lists:member(VipLevel, RecvList) of
        true ->
            {fail, ?INFO_VIP_REWARD_RECV};
        _ ->
            case data_base_vip:get(VipLevel) of
                [] ->
                    {fail, ?INFO_CONF_ERR};
                #base_vip{vip_reward = Reward} ->
                    {ok, Reward}
            end
    end.

handle_pay_info(Player) ->
    case hdb:dirty_index_read(pay_info, Player#player.id, #pay_info.player_id) of
        [] ->
            ignore;
        _PayInfos ->
            ok
    end,
    Player.

%%公告
get_notice(Sn) ->
    NoticeIdList = data_base_notice:notice_all_id(),
    NewNoticeList = 
        lists:map(fun(NoticeId) -> 
                          data_base_notice:get(NoticeId)
                  end,NoticeIdList),
    lists:foldl(fun(#base_notice{
                       server_id = SnList,
                       show_time = ShowTime
                      } = BaseNotice, Acc) ->
                      case SnList of
                        [] ->
                            case noticetime(ShowTime) of
                                false ->
                                      Acc;
                                 true ->
                                      [BaseNotice | Acc]
                             end;

                        _ ->       
                            case lists:member(Sn, SnList) of
                                false ->
                                      Acc;
                                true ->
                                      case noticetime(ShowTime) of
                                          false -> 
                                                Acc;
                                          true ->
                                                [BaseNotice | Acc]
                                     end 
                              end                      
                        end    
                end, [], NewNoticeList).

noticetime(ShowTime) ->
    case ShowTime of
      [] ->
          true;
    ShowTime = [OpenTime,CloseTime] ->                  
          OpenTimeStamp = time_misc:datetime_to_timestamp(OpenTime),
          CloseTimeStamp = time_misc:datetime_to_timestamp(CloseTime),  
          Now = time_misc:unixtime(),                        
          Now >= OpenTimeStamp andalso Now < CloseTimeStamp
    end.

get_player_skill_record(PlayerId) ->
    hdb:dirty_read(player_skill_record, PlayerId).


binding_qq(#player{id = PlayerId,
                   accid = AccId,
                   qq = OldQQ} = Player, QQ) ->

    if
        OldQQ =/= QQ -> 
            Roles = mod_player:get_role_by_accid(AccId),
            IsAleadyBinded = lists:foldl(fun(#player{id = OPlayerId, qq = OQQ}, RET) ->
                                                 case RET of
                                                     true ->
                                                         RET;
                                                     _ ->
                                                         if
                                                             OPlayerId =/= PlayerId andalso
                                                             OQQ =/= [] ->
                                                                 true;
                                                             true -> 
                                                                 RET
                                                         end
                                                 end
                                         end, false, Roles),
            ?DEBUG("IsAleadyBinded : ~p, Roles : ~p OldQq :~p, QQ:~p~n",[IsAleadyBinded, Roles, OldQQ, QQ]),
            IsQQAleadyUsed = case get_roles_by_qq(QQ) of
                                 [] ->
                                     false;
                                 _ ->
                                     true
                             end,

            if
                IsAleadyBinded =:= true  ->
                    {fail, ?INFO_QQ_ALDEADY_BIND};
                IsQQAleadyUsed =:= true ->
                    {fail, ?INFO_QQ_ALDEADY_USED};
                true -> 
                    {ok, Player#player{qq = QQ}}
            end;
        true -> 
            {fail, ?INFO_QQ_IS_SAME}
    end.

get_roles_by_qq(QQ) when QQ =/= [] ->
    hdb:dirty_index_read(player, QQ, #player.qq, true);
get_roles_by_qq(_) ->
    [].
