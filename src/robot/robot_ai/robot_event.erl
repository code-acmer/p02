-module(robot_event).
-compile(export_all).
-include("define_robot.hrl").
-include("db_base_goods.hrl").
%%12000
run_dungeon(AccountInfo) ->
    case ai_lib_dungeon:get_dungeon_available(AccountInfo) of
        [] ->
            skip;
        {no_vigor, DungeonId} ->
            ?INFO("12001 ready add vigor ~n", []),
            SendBeforeFun = fun(Robot) ->
                                    Robot2 = lib_robot:ensuer_player_attri(vigor, Robot, 200),
                                    {ok, Robot2}
                            end,
            ct_robot:ai_handle_cmd(AccountInfo, 12001, [{send_before_hook, SendBeforeFun},
                                                        {cmd_with_args, DungeonId}]);
        DungeonId ->
            ct_robot:ai_handle_cmd(AccountInfo, 12001, [{cmd_with_args, DungeonId}])
    end.

run_get_dungoen_reward(AccountInfo) ->
    case ai_lib_dungeon:get_dungeon_route(AccountInfo) of
        no_dungeon ->
            ?INFO("12002 no dungeon ~n", []),
            skip;
        NewRobot ->
            ct_robot:ai_handle_cmd(AccountInfo, 12002, [{cmd_with_args, NewRobot}])
    end.

%%15000
%%分解
decomposition_goods(AccountInfo) ->
    case ai_lib_goods:find_equip_on_bag(AccountInfo) of
        {no_equip_in_bag, GoodsId} ->
            ?INFO("15010 going to add equip ~p~n", [GoodsId]),
            SendBeforeFun = fun(Robot) ->
                                    Robot2 = lib_robot:add_goods_list(Robot, GoodsId, 1),
                                    {ok, Robot2}
                            end,
            ct_robot:ai_handle_cmd(AccountInfo, 15010, [{send_before_hook, SendBeforeFun},
                                                        {cmd_with_args, GoodsId}]);
        Goods ->
            ct_robot:ai_handle_cmd(AccountInfo, 15010, [{cmd_with_args, Goods#pbgoods.id}])
    end.

%%传承(功能先不做)
smriti_goods(_AccountInfo) ->
    skip.

%%穿装备
put_on_equip(AccountInfo) ->
    case ai_lib_goods:find_equip_on_bag(AccountInfo) of
        {no_equip_in_bag, GoodsId} ->
            ?INFO("15100 going to add equip ~p~n", [GoodsId]),
            SendBeforeFun = fun(Robot) ->
                                    Robot2 = lib_robot:add_goods_list(Robot, GoodsId, 1),
                                    {ok, Robot2}
                            end,
            ct_robot:ai_handle_cmd(AccountInfo, 15100, [{cmd_with_args, GoodsId},
                                                        {send_before_hook, SendBeforeFun}]);
        Goods ->
            %?INFO("Goods ~p~n", [Goods]),
            ct_robot:ai_handle_cmd(AccountInfo, 15100, [{cmd_with_args, Goods#pbgoods.id}])
    end.
%%脱装备
take_off_equip(AccountInfo) ->
    case ai_lib_goods:find_equip_on_body(AccountInfo) of
        no_equip_on_body ->
            ?INFO("15101 no equip to take off ~n", []),
            skip;
        GoodsId ->
            ct_robot:ai_handle_cmd(AccountInfo, 15101, [{cmd_with_args, GoodsId}])
    end.
%%强化
goods_strength(AccountInfo) ->
    case ai_lib_goods:get_upgrade_equip(AccountInfo, strength) of
        {no_equip_to_upgrade, GoodsId} ->
            ?INFO("15200 going to add equip ~p~n", [GoodsId]),
            SendBeforeFun = fun(Robot) ->
                                    Robot2 = lib_robot:add_goods_list(Robot, GoodsId, 1),
                                    {ok, Robot2}
                            end,
            ct_robot:ai_handle_cmd(AccountInfo, 15200, [{cmd_with_args, GoodsId},
                                                        {send_before_hook, SendBeforeFun}]);
        {MoneyConf, GoodsId} ->
            ?INFO("15200 ready add money ~n", []),
            SendBeforeFun = fun(Robot) ->
                                    NewRobot = 
                                        case MoneyConf of
                                            coin_less ->
                                                lib_robot:ensuer_player_attri(coin, Robot, 1000000);
                                            gold_less ->
                                                lib_robot:ensuer_player_attri(coin, Robot, 100000);
                                            both_less ->
                                                Robot2 = lib_robot:ensuer_player_attri(coin, Robot, 1000000),
                                                lib_robot:ensuer_player_attri(coin, Robot2, 100000);
                                            _ ->
                                                Robot
                                        end,
                                    {ok, NewRobot}
                            end,
            ct_robot:ai_handle_cmd(AccountInfo, 15200, [{send_before_hook, SendBeforeFun},
                                                        {cmd_with_args, GoodsId}])
    end.
%%升星
goods_add_star(AccountInfo, 15201) ->
    case ai_lib_goods:get_upgrade_equip(AccountInfo, addstar) of
        {no_equip_to_upgrade, GoodsId} ->
            ?INFO("15201 going to add equip ~p~n", [GoodsId]),
            SendBeforeFun = fun(Robot) ->
                                    Robot2 = lib_robot:add_goods_list(Robot, GoodsId, 1),
                                    {ok, Robot2}
                            end,
            ct_robot:ai_handle_cmd(AccountInfo, 15201, [{cmd_with_args, GoodsId},
                                                        {send_before_hook, SendBeforeFun}]);
        {MoneyConf, GoodsId} ->
            ?INFO("15201 ready add money ~n", []),
            SendBeforeFun = fun(Robot) ->
                                    NewRobot = 
                                        case MoneyConf of
                                            coin_less ->
                                                lib_robot:ensuer_player_attri(coin, Robot, 1000000);
                                            gold_less ->
                                                lib_robot:ensuer_player_attri(coin, Robot, 100000);
                                            both_less ->
                                                Robot2 = lib_robot:ensuer_player_attri(coin, Robot, 1000000),
                                                lib_robot:ensuer_player_attri(coin, Robot2, 100000);
                                            _ ->
                                                Robot
                                        end,
                                    {ok, NewRobot}
                            end,
            ct_robot:ai_handle_cmd(AccountInfo, 15201, [{send_before_hook, SendBeforeFun},
                                                        {cmd_with_args, GoodsId}])
    end.
%%清理背包
clear_bag(AccountInfo, 15999) ->  %%虚构协议用来清理过多的背包
    case ai_lib_goods:clear_bag(AccountInfo) of
        skip ->
            ?INFO("not need to clear bag~n", []),
            skip;
        GoodsIdList ->
            ?INFO("clear bag ~n", []),
            ct_robot:ai_handle_cmd(AccountInfo, 9009, [{cmd_with_args, "-delgoods," ++ hmisc:list_to_string(GoodsIdList)}])
    end.

%%13000
%%查看好友信息13150
%% get_friend_info(_AccountInfo) ->
%%     skip.

%%加好友13151
%% add_new_friend(_AccountInfo, 13151) ->
%%     %% case ai_lib_player:get_random_robot(AccountInfo) of
%%     %%     [] ->
%%     %%         skip;
%%     %%     Tid ->
%%     %%         %%?WARNING_MSG("Tid ~p~n", [Tid]),
%%     %%         robot_ai:handle_cmd(AccountInfo, 13151, [{cmd_with_args, Tid}])
%%     %% end;
%%     skip.
%%拒绝申请13152
%% deny_friend(_AccountInfo) ->
%%     skip.
%% %%同意好友申请13153
%% accept_friend(_AccountInfo) ->
%%     skip.
%% %%删除好友13154
%% del_friend(_AccountInfo) ->
%%     skip.
%%请求所有的好友155
get_all_freind_info(AccountInfo) ->
    ct_robot:ai_handle_cmd(AccountInfo, 13155).

%%重新加载自己的玩家列表
reload_friends_info(AccountInfo) ->
    ct_robot:ai_handle_cmd(AccountInfo, 13156).

%%登陆奖励
login_reward(AccountInfo) ->
    case ai_lib_player:check_login_reward(AccountInfo) of
        true ->
            ct_robot:ai_handle_cmd(AccountInfo, 13007);
        false ->
            skip
    end.


%%获取技能列表
get_skill(AccountInfo) ->
    ct_robot:ai_handle_cmd(AccountInfo, 13333).

%%技能升级
skill_upgrade(AccountInfo) ->
    case ai_lib_player:get_upgrade_skill(AccountInfo) of
        [] ->
            %% 人物等级不够不去GM升级，因为robot会通过打副本慢慢升级
            skip;
        {_, []} ->
            skip;
        {MoneyConf, Skill} ->
            ?INFO("13300 ready add money ~n", []),
            SendBeforeFun = fun(Robot) ->
                                    NewRobot = 
                                        case MoneyConf of
                                            coin_less ->
                                                lib_robot:ensuer_player_attri(coin, Robot, 1000000);
                                            gold_less ->
                                                lib_robot:ensuer_player_attri(coin, Robot, 100000);
                                            both_less ->
                                                Robot2 = lib_robot:ensuer_player_attri(coin, Robot, 1000000),
                                                lib_robot:ensuer_player_attri(coin, Robot2, 100000);
                                            _ ->
                                                Robot
                                        end,
                                    {ok, NewRobot}
                            end,
            ct_robot:ai_handle_cmd(AccountInfo, 13300, [{cmd_with_args, Skill#pbskill.id},
                                                        {send_before_hook, SendBeforeFun}])
    end.

%%技能强化
skill_strength(AccountInfo, 13301) ->
    case ai_lib_player:get_str_skill(AccountInfo) of
        [] ->
            skip;
        {_, []} ->
            skip;
        {MoneyConf, Skill} ->
            ?INFO("13301 ready add money ~n", []),
            SendBeforeFun = fun(Robot) ->
                                    NewRobot = 
                                        case MoneyConf of
                                            coin_less ->
                                                lib_robot:ensuer_player_attri(coin, Robot, 1000000);
                                            gold_less ->
                                                lib_robot:ensuer_player_attri(coin, Robot, 100000);
                                            both_less ->
                                                Robot2 = lib_robot:ensuer_player_attri(coin, Robot, 1000000),
                                                lib_robot:ensuer_player_attri(coin, Robot2, 100000);
                                            _ ->
                                                Robot
                                        end,
                                    {ok, NewRobot}
                            end,
            ct_robot:ai_handle_cmd(AccountInfo, 13301, [{cmd_with_args, Skill#pbskill.id},
                                                        {send_before_hook, SendBeforeFun}])
    end.

%%切换符印
skill_change_sigil(AccountInfo, 13305) ->
    case ai_lib_player:get_sigil_change(AccountInfo) of
        [] ->
            ok;
        {Oid, Tid} ->
            ct_robot:ai_handle_cmd(AccountInfo, 13305, [{cmd_with_args, {Oid, Tid}}])
    end.

boss_event(AccountInfo) ->
    ai_lib_boss:boss_event(AccountInfo).
