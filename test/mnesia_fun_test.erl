-module(mnesia_fun_test).

-export([table_info/0]).

table_info() ->
    L = lists:seq(1, 1000000),
    F1 = fun() ->
                 lists:foldl(fun(_, _Acc) ->
                                     mnesia:table_info(player, attributes)
                             end, [], L)
         end,
    {R1, _S1} = timer:tc(F1),
    io:format("R1 : ~p", [R1]),
    
    F2 = fun() ->
                 lists:foldl(fun(_, _Acc) ->
                                     %mnesia:table_info(player, attributes)
                                     all_record:get_fields(player)
                             end, [], L)
         end,
    {R2, _S2} = timer:tc(F2),
    io:format("R2 : ~p", [R2]).

