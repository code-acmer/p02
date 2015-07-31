-module(gm).
%% -export([
%%          give_goods/2,
%%          add_money/4,
%%          modify_player/2,
%%          stop/1,
%%          fix_player_data/1,
%%          %fix_goods_data/0,
%%          print_player/1,
%%          pr_same_acc/0,
%%          send_mail/1,
%%          send_login_reward/2,
%%          fix_bag_limit/0,
%%          lvlup/2,
%%          get_bag/1,
%%          delete_all_goods/1,
%%          insert_goods/1,
%%          reset_player_lv/1
%%         ]).
-compile(export_all).
-include("define_player.hrl").
-include("define_logger.hrl").
-include("define_mnesia.hrl").
-include("define_goods.hrl").
-include("define_task.hrl").
-include("define_time.hrl").
-include("db_base_dungeon_area.hrl").
give_goods(PlayerId, GoodsInfo) ->
    case hmisc:whereis_player_pid(PlayerId) of
        []  ->
            ?WARNING_MSG("give_goods failed PLAYER IS Not online. PlayerId : ~w BaseGoodsIds : ~w ~n",[PlayerId, GoodsInfo]);
        Pid ->
            gen_server:cast(Pid, {gmcmd, {cmd_add_goodslist, GoodsInfo, 0}})
    end.

add_money(PlayerId, Sum, Type, Point) ->
    case hmisc:whereis_player_pid(PlayerId) of
        []  ->
            ?WARNING_MSG("add_money PLAYER IS Not online. PlayerId : ~w ~n",[PlayerId]);
        Pid ->
            gen_server:cast(Pid, {gmcmd, {cmd_add_money, Sum, Type, Point}})
    end.

modify_player(PlayerId, ValueList) ->
    case hmisc:whereis_player_pid(PlayerId) of
        []  ->
            ?WARNING_MSG("modify_player PLAYER IS Not online. PlayerId : ~w ~n",[PlayerId]);
        Pid ->
            gen_server:cast(Pid, {gmcmd, {modify_player, ValueList}})
    end.
stop(PlayerId) ->
    case hmisc:whereis_player_pid(PlayerId) of
        []  ->
            ?WARNING_MSG("add_money PLAYER IS Not online. PlayerId : ~w ~n",[PlayerId]);
        Pid ->
            mod_player:stop(Pid, 2)
    end.

fix_player_data(FixFun) ->
    [hdb:dirty_write(player, FixFun(Player)) || Player <- hdb:table_to_list(player)].

fix_bag_limit() ->
    fix_player_data(fun(Player) ->
                            Player#player{
                              bag_limit = 20
                             }
                    end).
fix_offline() ->
     fix_player_data(fun(Player) ->
                            Player#player{
                              online_flag = 0
                             }
                    end).
%% fix_goods_data() ->
%%     case hdb:dirty_read(player_uid, player_uid) of
%%         [] ->
%%             ignore;
%%         #player_uid{
%%            counter = MaxUid
%%           } ->
%%             transform_goods(MaxUid)
%%     end.

transform_goods(100000007) ->
    ok;
transform_goods(PlayerId) ->
    case hdb:dirty_index_read(goods, PlayerId, #goods.player_id) of
        [] ->
            ignore;
        GoodsList ->
            hdb:dirty_write(player_goods, #player_goods{player_id = PlayerId,
                                                        goods_list = GoodsList
                                                       })
    end,
    transform_goods(PlayerId - 7).

print_player(PlayerId) ->
    case hmisc:whereis_player_pid(PlayerId) of
        []  ->
            ?WARNING_MSG("modify_player PLAYER IS Not online. PlayerId : ~w ~n",[PlayerId]);
        Pid ->
            Pid ! cmd_auto_save_player
    end,
    timer:sleep(1000),
    case hdb:dirty_read(player, PlayerId) of
        [] ->
            ignore;
        Player ->
            Fields = record_info(fields, player),
            [_|ValList] = tuple_to_list(Player),
            io:format("~p~n", [lists:zip(Fields, ValList)])
    end.

pr_same_acc() ->
    L = hdb:table_to_list(player),
    L1 = lists:ukeysort(#player.accid, L),
    LLen = length(L),
    L1Len = length(L1),
    {LLen, L1Len, LLen-L1Len}.
    
send_login_reward(PlayerId, Day) ->
    lib_player:send_login_reward(#player{
                                    id = PlayerId,
                                    nickname = <<"null">>,
                                    total_login_days = Day
                                   }).
lvlup(PlayerId, Lv) ->
    case hmisc:whereis_player_pid(PlayerId) of
        [] ->
            ?WARNING_MSG("modify_player PLAYER IS Not online. PlayerId : ~w ~n",[PlayerId]);
        Pid ->
            gen_server:cast(Pid, {gmcmd, {lvlup, Lv}})
    end.

get_bag(PlayerId) ->
    case hmisc:whereis_player_pid(PlayerId) of
        [] ->
            ?WARNING_MSG("modify_player PLAYER IS Not online. PlayerId : ~w ~n",[PlayerId]);
        Pid ->
            gen_server:cast(Pid, {gmcmd, cmd_bag})
    end.

get_task(PlayerId) ->
    case hmisc:whereis_player_pid(PlayerId) of
        [] ->
            ?WARNING_MSG("modify_player PLAYER IS Not online. PlayerId : ~w ~n",[PlayerId]);
        Pid ->
            gen_server:cast(Pid, {gmcmd, cmd_task})
    end.

delete_all_goods(PlayerId) ->
    case hmisc:whereis_player_pid(PlayerId) of
        [] ->
            skip;
        _Pid ->
            stop(PlayerId)
    end,
    GoodsList = hdb:dirty_index_read(goods, PlayerId, #goods.player_id),
    io:format("GoodsList ~p~n", [GoodsList]),
    hdb:dirty_delete_list(goods, lists:map(fun(#goods{id = Id}) ->
                                              Id
                                      end, GoodsList)).
insert_goods(PlayerId) ->
    hdb:dirty_write(goods, #goods{id = 9999,
                                  player_id = PlayerId}).
reset_player_lv(PlayerId) ->
    case hmisc:whereis_player_pid(PlayerId) of
        [] ->
            ?WARNING_MSG("modify_player PLAYER IS Not online. PlayerId : ~w ~n",[PlayerId]);
        Pid ->
            gen_server:cast(Pid, {gmcmd, reset_player_lv})
    end.
reset_player_reset_time(PlayerId) -> 
    case hmisc:whereis_player_pid(PlayerId) of
        [] ->
            ?WARNING_MSG("modify_player PLAYER IS Not online. PlayerId : ~w ~n",[PlayerId]);
        Pid ->
            gen_server:cast(Pid, {gmcmd, reset_player_reset_time})
    end.
clear_player_task(PlayerId) ->
    stop(PlayerId),
    TaskList = hdb:dirty_index_read(task, PlayerId, #task.player_id),
    lists:foreach(fun(Task) ->
                          hdb:dirty_delete(task, Task#task.id)
                  end, TaskList). 

do_task(PlayerId, TaskInfo) ->
    case hmisc:whereis_player_pid(PlayerId) of
        [] ->
            ?WARNING_MSG("modify_player PLAYER IS Not online. PlayerId : ~w ~n",[PlayerId]);
        Pid ->
            gen_server:cast(Pid, {cmd_task_event, TaskInfo})
    end.

get_player_task(PlayerId) ->
    hdb:dirty_index_read(task, PlayerId, #task.player_id).
            
save_player(PlayerId) ->
    case hmisc:whereis_player_pid(PlayerId) of
        []  ->
            ?WARNING_MSG("modify_player PLAYER IS Not online. PlayerId : ~w ~n",[PlayerId]);
        Pid ->
            Pid ! cmd_auto_save_player
    end.

get_player_skill(PlayerId) -> 
    hdb:dirty_index_read(player_skill, PlayerId, #player_skill.player_id).

reset_main_task(PlayerId) ->
    case hmisc:whereis_player_pid(PlayerId) of
        [] ->
            ?WARNING_MSG("modify_player PLAYER IS Not online. PlayerId : ~w ~n",[PlayerId]);
        Pid ->
            gen_server:cast(Pid, {gmcmd, cmd_reset_main_task})
    end.

pay_month_card(PlayerId) ->
    case hmisc:whereis_player_pid(PlayerId) of
        [] ->
            ?WARNING_MSG("modify_player PLAYER IS Not online. PlayerId : ~w ~n",[PlayerId]);
        Pid ->
            gen_server:cast(Pid, {gmcmd, pay_month_card})
    end.

add_mugen_times(PlayerId, Times) ->
    case hmisc:whereis_player_pid(PlayerId) of
        [] ->
            ?WARNING_MSG("modify_player PLAYER IS Not online. PlayerId : ~w ~n",[PlayerId]);
        Pid ->
            gen_server:cast(Pid, {gmcmd, {add_mugen_times, Times}})
    end.

get_mod_player_cache(PlayerId, Value) ->
    case hmisc:whereis_player_pid(PlayerId) of
        [] ->
            ?WARNING_MSG("modify_player PLAYER IS Not online. PlayerId : ~w ~n",[PlayerId]);
        Pid ->
            gen_server:cast(Pid, {gmcmd, {get_cache, Value}})
    end.
clear_open_boss(PlayerId) ->
    case hmisc:whereis_player_pid(PlayerId) of
        [] ->
            ?WARNING_MSG("modify_player PLAYER IS Not online. PlayerId : ~w ~n",[PlayerId]),
            Player = hdb:dirty_read(PlayerId),
            hdb:dirty_write(Player#player{open_boss_info = []});
        Pid ->
            gen_server:cast(Pid, {gmcmd, clear_open_boss})
    end.

delete_player(PlayerId) ->
    stop(PlayerId),
    timer:sleep(500),
    hdb:dirty_delete(player, PlayerId).

task_change(PlayerId, TaskId, ToBaseId) ->
    case hmisc:whereis_player_pid(PlayerId) of
        [] ->
            ?WARNING_MSG("modify_player PLAYER IS Not online. PlayerId : ~w ~n",[PlayerId]);
        Pid ->
            gen_server:cast(Pid, {gmcmd, {task_change, TaskId, ToBaseId}})
    end.


save(PlayerId) ->
    case hmisc:whereis_player_pid(PlayerId) of
        []  ->
           not_online;
        Pid ->
           Pid ! cmd_auto_save_player
    end.

update_player_lv(PlayerId, Lv) ->
    Player = hdb:dirty_read(player, PlayerId),
    hdb:dirty_delete(player, PlayerId),
    hdb:dirty_write(player, Player#player{lv = Lv}),
    NewPlayer = hdb:dirty_read(player, PlayerId),
    ?DEBUG("Result: ~p",[NewPlayer]).

get_dungeon_all_id_lv()->
    AllIdList = data_base_dungeon_area:get_dungeon_all_id(),
    ResultList = lists:foldl(fun(Id, Acc) ->
                                     DungeonInfo = data_base_dungeon_area:get(Id),
                                     [{Id, DungeonInfo#base_dungeon_area.lv} | Acc]
                             end,[],AllIdList),
    NewResultList = lists:sort(fun(A, B) ->
                                   if
                                       element(2,A) >= element(2,B) ->
                                           false;
                                       true ->
                                           true
                                   end
                           end, ResultList),
    ?DEBUG("ResultList ~p Length ~p",[NewResultList, length(NewResultList)]).
get_dungeon_by_lv_list(PlayerLv) ->
    ResultList =  lists:foldl(fun(Lv, Acc)->
                                      Acc ++ data_base_dungeon_area:get_dungeon_by_lv(Lv)
                              end, [], lists:seq(1, PlayerLv)),
    ?DEBUG("ResultList = ~p", [ResultList]).

clean_ordinary_table()->
    case whereis(mod_selling_shop) of
        []  ->
           not_online;
        Pid ->
           Pid ! clear_db_ordinary_shop
    end.

mod_timer_test()->
    case whereis(mod_timer) of
        []  ->
            failed;
        Pid ->
            Pid ! init_job
    end.

