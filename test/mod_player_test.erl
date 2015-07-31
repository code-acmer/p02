%%%-------------------------------------------------------------------
%%% @author Zhangr <zhangr011@gmail.com>
%%% @copyright (C) 2013, Zhangr
%%% @doc
%%%
%%% @end
%%% Created :  6 Nov 2013 by Zhangr <zhangr011@gmail.com>
%%%-------------------------------------------------------------------
-module(mod_player_test).

-compile(export_all).

-include("define_goods_type.hrl").
-include("define_player.hrl").
-include("define_reward.hrl").
-include_lib("eunit/include/eunit.hrl").

player_exp_test() ->
    ok = application:start(hstdlib),
    hloglevel:set(6),
    Player = #player{},
    NPlayer1 = lib_player:add_money(Player, 1, ?GOODS_TYPE_GOLD, 1),
    ?assertEqual(Player#player.gold, 0),
    ?assertEqual(NPlayer1#player.gold, 1),
    NPlayer2 = lib_player:add_money(NPlayer1, 50, ?GOODS_TYPE_EXP, 1),
    NPlayer3 = lib_player:add_money(NPlayer2, 10000, ?GOODS_TYPE_EXP, 1),
    ?assertEqual(NPlayer2#player.exp, 50),
    ?assertEqual(NPlayer2#player.lv,  3),
    ?assertEqual(NPlayer3#player.exp, 10050),
    ?assertEqual(NPlayer3#player.lv,  12).

player_vigor_test() ->
    Player = #player{},
    Player1 = lib_player:add_money(Player, 10, ?GOODS_TYPE_VIGOR, 1),
    Player2 = lib_player:add_money(Player1, 10, ?GOODS_TYPE_VIGOR, 1),
    Player3 = lib_player:add_money(Player2, 10, ?GOODS_TYPE_VIGOR, 1),
    ?assertEqual(Player1#player.vigor, 10),
    ?assertEqual(Player2#player.vigor, 20),
    ?assertEqual(Player3#player.vigor, 20).

money_add_cost_test() ->
    Player = #player{},
    Player1 = lib_player:add_money(Player, 10, ?GOODS_TYPE_GOLD, 1),
    Player2 = lib_player:add_money(Player, 10, ?GOODS_TYPE_COIN, 1),
    Player3 = lib_player:add_money(Player, 10, ?GOODS_TYPE_VIGOR, 1),
    Player4 = lib_player:add_money(Player, 10, ?GOODS_TYPE_VGOLD, 1),
    Player5 = lib_player:add_money(Player, 10, ?GOODS_TYPE_FRIENDPOINT, 1),
    ?assertEqual(Player1#player.gold, 10),
    ?assertEqual(Player2#player.coin, 10),
    ?assertEqual(Player3#player.vigor, 10),
    ?assertEqual(Player4#player.gold, 10),
    ?assertEqual(Player5#player.fpt, 10),
    ?assertEqual({false, Player1},
                 lib_player:cost_money(Player1, 11, ?GOODS_TYPE_GOLD, 1)),
    ?assertEqual({false, Player2},
                 lib_player:cost_money(Player2, 11, ?GOODS_TYPE_COIN, 1)),
    ?assertEqual({false, Player3},
                 lib_player:cost_money(Player3, 11, ?GOODS_TYPE_VIGOR, 1)),
    ?assertEqual({false, Player5},
                 lib_player:cost_money(
                   Player5, 11, ?GOODS_TYPE_FRIENDPOINT, 1)),
    {true, Player11} = 
        lib_player:cost_money(Player1, 10, ?GOODS_TYPE_GOLD, 1),
    {true, Player12} =
        lib_player:cost_money(Player2, 10, ?GOODS_TYPE_COIN, 1),
    {true, Player13} =
        lib_player:cost_money(Player3, 10, ?GOODS_TYPE_VIGOR, 1),
    {true, Player15} =
        lib_player:cost_money(Player5, 10, ?GOODS_TYPE_FRIENDPOINT, 1),
    ?assertEqual(Player, Player11),
    ?assertEqual(Player, Player12),
    ?assertEqual(Player, Player13),
    ?assertEqual(Player, Player15).

lib_reward_test() ->
    Reward = #common_reward{type = 0,
                            rate = 10000,
                            goods_id = 1,
                            goods_sum = 2,
                            value1 = 0,
                            value2 = 0,
                            value3 = 0},
    Reward2 = #common_reward{type = 0,
                             rate = 10000,
                             goods_id = 1,
                             goods_sum = 1,
                             value1 = 0,
                             value2 = 0,
                             value3 = 0},
    RewardList = 
        lib_reward:convert_common_reward([[{0, 10000, 1, 2, 0, 0, 0}],
                                          [{0, 10000, 1, 1, 0, 0, 0}]]),
    ?assertEqual(RewardList, [[Reward], [Reward2]]),
    FList = lib_reward:generate_reward_list(RewardList),
    ?assertEqual(FList, [Reward, Reward2]),
    Reward3 = #common_reward{type = 0,
                             rate = 5000,
                             goods_id = 1,
                             goods_sum = 1},
    Reward4 = #common_reward{type = 0,
                             rate = 5000,
                             goods_id = 1,
                             goods_sum = 1},
    Reward5 = #common_reward{type = 0,
                             rate = 5000,
                             goods_id = 1,
                             goods_sum = 1},
    FList2 = lib_reward:generate_reward_list([[Reward3, Reward4]]),
    FList3 = lib_reward:generate_reward_list([[Reward3, Reward4, Reward5]]),
    ?assertEqual(FList2 =:= [Reward3] orelse FList2 =:= [Reward4], true),
    ?assertEqual(FList3 =:= [Reward3] orelse FList3 =:= [Reward4], true),
    application:stop(hstdlib).
    

