-module(ai_lib_boss).
-include("define_robot.hrl").
-include("define_logger.hrl").
-export([boss_event/1]).

boss_event(AccountInfo) ->
    ct_robot:ai_handle_cmd(AccountInfo, 17000),
    Robot = ct_robot:get_robot(AccountInfo),
    BossList = Robot#ct_robot.boss_list,
    MoneyConf = ai_lib_player:ensure_money(AccountInfo, Robot),
    CurBoss = Robot#ct_robot.cur_boss,
    SendBeforeFun = fun(Robot1) ->
                            NewRobot = 
                                case MoneyConf of
                                    coin_less ->
                                        lib_robot:ensuer_player_attri(coin, Robot1, 1000000);
                                    gold_less ->
                                        lib_robot:ensuer_player_attri(gold, Robot1, 100000);
                                    both_less ->
                                        Robot2 = lib_robot:ensuer_player_attri(coin, Robot1, 1000000),
                                        lib_robot:ensuer_player_attri(gold, Robot2, 100000);
                                    _ ->
                                        Robot1
                                end,
                            {ok, NewRobot}
                    end,
    ?DEBUG("BossList ~p~n", [BossList]),
    ?DEBUG("CurBoss ~p~n", [CurBoss]),
    if
        BossList =:= [] ->
            skip;
        %% BossList =:= [] ->
        %%     ?PRINT("17010 ~n", []),
        %%     ct_robot:ai_handle_cmd(AccountInfo, 17010, [{send_before_hook, SendBeforeFun},
        %%                                                 {cmd_with_args, 10}]);
        CurBoss =:= undefined ->
            #pbworldboss{boss_id = Id} = hmisc:rand(BossList),
            ct_robot:ai_handle_cmd(AccountInfo, 17011, [{cmd_with_args, Id}]);
        true ->
            ct_robot:ai_handle_cmd(AccountInfo, 17012, [{cmd_with_args, CurBoss}])
    end.
