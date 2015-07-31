-module(lib_recharge).

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
-include("define_task.hrl").
-include("define_log.hrl").

-export([recharge/2,
         get_first_recharge_reward/1,
         get_cdk_rewards/3
        ]).

recharge(#mod_player_state{
            player = Player
           } = ModPlayerState, MoneyNum) ->
    FirstRechargeFlag = Player#player.first_recharge_flag,
    PlayerId = Player#player.id,
    lib_pay_gifts:recharge(PlayerId, MoneyNum*10), 
    if
        FirstRechargeFlag =:= ?NOT_RECHARGE ->
            {ok, ModPlayerState#mod_player_state{
                   player = Player#player{first_recharge_flag = ?ALREADY_RECHARGE}
                  }};
        true ->
            {ok, ModPlayerState}
    end.

get_first_recharge_reward(#mod_player_state{
                             player = Player
                            } = ModPlayerState) ->
    FirstRechargeFlag = Player#player.first_recharge_flag,
    if
        FirstRechargeFlag =:= ?ALREADY_RECHARGE ->
            #base_goods{decomposition = Decomposition} = data_base_goods:get(?FIRST_RECHARGE_BASE_ID), 
            RewardList = lib_equip:get_all_decomposition(Decomposition, 1),
            lib_reward:take_reward(ModPlayerState#mod_player_state{
                                     player = Player#player{first_recharge_flag = ?RECHARGE_RECV_GIFT}
                                    }, RewardList, ?INCOME_FIRST_RECHARGE);
        true ->
            {fail, ?INFO_GOODS_GIFT_FAILED}
    end.

check_cdk(Flag, Type, _Cdk) ->
    case get_cdk_rewards(Type) of
        [] ->
            {fail, ?INFO_GOODS_GIFT_FAILED};
        GoodsId ->
            Mask = get_mask(Type),
            ?DEBUG("CheckFlag MASK : ~p, Flag : ~p~n", [Mask, Flag]),
            case check_flag(Flag, Mask) of
                false ->
                   
                    NewFlag = set_flag(Flag, Mask),
                    ?DEBUG("NewFlag : ~p~n",[NewFlag]),
                    #base_goods{decomposition = Decomposition} = data_base_goods:get(GoodsId), 
                    RewardList = lib_equip:get_all_decomposition(Decomposition, 1),
                    {ok, RewardList, NewFlag};
                _->
                    {fail, ?INFO_GOODS_GIFT_ALREADY_GOT}
            end
    end.

check_flag(Flag, Mask) ->
    (Flag band Mask) =:= Mask.
set_flag(Flag, Mask) ->
    Flag bor Mask.
get_mask(Type) when Type > 0 ->
    1 bsl (Type - 1).

get_cdk_rewards(#mod_player_state{
                   player = Player
                  } = ModPlayerState, Type, Cdk) when is_integer(Type) andalso Type < 11 ->
    case check_cdk(Player#player.cdk, Type, Cdk) of
        {ok, Rewards, NewFlag} ->
            lib_reward:take_reward(ModPlayerState#mod_player_state{
                                     player = Player#player{cdk = NewFlag}
                                    }, Rewards, ?INCOME_CDK_REWARD);
        {fail, Error}  ->
            {fail, Error} 
    end.

get_cdk_rewards(1) ->
    25029901; %%	CDK礼包1
get_cdk_rewards(2) ->
    25029902; %%	CDK礼包2
get_cdk_rewards(3) ->
    25029903; %%	CDK礼包3
get_cdk_rewards(4) ->
    25029904; %%	CDK礼包4
get_cdk_rewards(5) ->
    25029905; %%	CDK礼包5
get_cdk_rewards(6) ->
    25029906; %%	CDK礼包6
get_cdk_rewards(7) ->
    25029907; %%	CDK礼包7
get_cdk_rewards(8) ->
    25029908; %%	CDK礼包8
get_cdk_rewards(9) ->
    25029909; %%	CDK礼包9
get_cdk_rewards(10) ->
    25029910; %%	CDK礼包10
get_cdk_rewards(_) ->
    [].
