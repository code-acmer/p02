-module(data_test).

-export([
         test/0,
         test_bin/2
        ]).

%% 经度、 纬度
%test(Longitude, Latitude) ->

%% longitude_coding(Longitude) ->
%%     coding1(Longitude, -180, 180, 25, []).

%% latitude_coding(Latitude) ->
%%     coding1(Latitude, -90, 90, 25, []).

%% coding1(_Longitude, _L, _R, 0, BinaryList) ->
%%     %lists:reverse(BinaryList);
%%     BinaryList;

%% coding1(Longitude, L, R, Count, BinaryList) ->
%%     M = (L + R) / 2,
%%     if
%%         Longitude >= M ->
%%             coding1(Longitude, M, R, Count-1, [1 | BinaryList]);
%%         true ->
%%             coding1(Longitude, L, M, Count-1, [0 | BinaryList])
%%     end.

%% merge_longitude_latitude(Longitude, Latitude) ->
%%     LongitudeList = longitude_coding(Longitude),
%%     LatitudeList = latitude_coding(Latitude),
%%     BinaryList = merge_longitude_latitude1(LongitudeList, LatitudeList, [], 0),
%%     %io:format("BinaryList: ~p ~n", [lists:reverse(BinaryList)]),
%%     BinaryList.

%% merge_longitude_latitude1([H|T], L, BinaryList, 1) ->
%%     merge_longitude_latitude1(T, L, [H | BinaryList], 0);
%% merge_longitude_latitude1(L, [H|T], BinaryList, 0) ->
%%     merge_longitude_latitude1(L, T, [H | BinaryList], 1);
%% merge_longitude_latitude1([], [], BinaryList, _) ->
%%     BinaryList.

%% big_data(BinaryList) ->
%%     Result =
%%         lists:foldl(fun(Num, Result) ->
%%                             Result*10 + Num
%%                     end, 0, BinaryList),
%%     Result.

%% %% ------------------------------------------------------

%% rand_n(N, List) ->
%%     Len = length(List),
%%     if 
%%         N div Len > 0.65 ->
%%             rand_n1(N, 1, Len, List);
%%         true ->
%%             NewNs = rand_n2(N, 1, Len),
%%             traversal_list(NewNs, 1, List, [])
%%     end.

%% rand1(N, List) ->
%%     Len = length(List),
%%     rand_n1(N, 1, Len, List).

%% rand2(N, List) ->
%%     Len = length(List),
%%     NewNs = rand_n2(N, 1, Len),
%%     traversal_list(NewNs, 1, List, []).
    
%% %% 从[min , max] 中取出 N个数，不重复
%% rand_n1(Count, Min, Max, List) 
%%   when (Max - Min)+1 > Count->
%%     {Tree, _, []} = make_tree(Min, Max, List),
%%     rand_n1(Count, Min, Max, Tree, []).
	
%% rand_n1(0, _Min, _Max, _Tree, List) ->
%%     List;
%% rand_n1(Count, Min, Max, Tree, List) ->
%%     Num = hmisc:rand(Min, Max),
%%     {NTree, Val} = queue_tree(Num, Tree),
%%     rand_n1(Count - 1, Min, Max-1, NTree, [Val | List]). %% Max - 1
%% % {sum, left_chail, right_chail} 线段树
%% make_tree(Left, Right, [H|T]) 
%%   when Left =:= Right ->
%%     {{1, none, none, H}, 1, T};
%% make_tree(Left, Right, List) ->
%%     Mid = (Left + Right) bsr 1,
%%     {LeftChail, LSum, NList} = make_tree(Left, Mid, List),
%%     {RightChail, RSum, NewList} = make_tree(Mid+1, Right, NList),
%%     Sum = LSum + RSum,
%%     {{Sum, LeftChail, RightChail}, Sum, NewList}.

%% queue_tree(Key, {Sum, none, none, Index})
%%   when Key =:= Sum ->
%%     {{0, none, none, Index}, Index};

%% queue_tree(Key, {Sum, LeftChail, RightChail} = _Tree) ->
%%     LSum = get_sum(LeftChail),
%%     if 
%%         Key > LSum ->
%%             {NewRightTree, Val} = queue_tree(Key - LSum, RightChail),
%%             {{Sum-1, LeftChail, NewRightTree}, Val};
%%         true ->
%%             {NewLeftTree, Val} = queue_tree(Key, LeftChail),
%%             {{Sum-1, NewLeftTree, RightChail}, Val}
%%     end.

%% get_sum({Sum, _LeftChail, _RightChail}) ->
%%     Sum;
%% get_sum({Sum, none, none, _Index}) ->
%%     Sum.

%% %% 从[min , max] 中取出 N个数，不重复
%% rand_n2(Count, Min, Max) 
%%   when (Max - Min)+1 > Count->
%%     rand_n2(Count, Min, Max, gb_sets:empty()). %% max 不变
	
%% rand_n2(0, _Min, _Max, GbSets) ->
%%     gb_sets:to_list(GbSets);
%% rand_n2(Count, Min, Max, GbSets) ->
%%     Num = hmisc:rand(Min, Max),
%%     case gb_sets:is_member(Num, GbSets) of
%%         false->
%%             rand_n2(Count - 1, Min, Max, gb_sets:insert(Num, GbSets));
%%         true ->
%%             rand_n2(Count, Min, Max, GbSets)
%%     end.

%% traversal_list([Index1 | TNs], Index2, [H|T], AccList) 
%%   when Index1 =:= Index2 ->
%%     traversal_list(TNs, Index2+1, T, [H | AccList]);
%% traversal_list(Ns, Index2, [_H|T], AccList) ->
%%     traversal_list(Ns, Index2+1, T, AccList);
%% traversal_list([], _, _, AccList) ->
%%     AccList.

%% %% ------------------------------------------------------------------

%% rand_mini([{_, _} | _] = List, Count) ->
%%     F = fun() ->
%%                 rand_mini(List, 0, gb_trees:empty())
%%         end,
%%     {R, {PowerSum, GbTrees}} = timer:tc(F),
%%     %io:format("RR: ~p~n", [R]),
%%     rand_mini(PowerSum, GbTrees, Count, []).

%% rand_mini([{Id, Key} | T], OldKey, OldGbTrees) ->
%%     NewKey = Key + OldKey, 
%%     NewGbTrees = gb_trees:insert(NewKey, Id, OldGbTrees),
%%     rand_mini(T, NewKey, NewGbTrees);
%% rand_mini([], OldKey, OldGbTrees) ->
%%     {OldKey, OldGbTrees}.

%% rand_mini(_, _, 0, L) ->
%%     L;
%% rand_mini(PowerSum, GbTrees, Count, List) ->
%%     Key = hmisc:rand(1, PowerSum),
%%     [{_, Val}] = tree_misc:lookup_bigger_n(1, Key, GbTrees),
%%     rand_mini(PowerSum, GbTrees, Count-1, [Val|List]).

test() ->
    L = lists:foldl(fun(K, Acc) ->
                            [{K,K} | Acc]
                    end, [], lists:seq(1, 1000)),
    %io:format("L : ~p~n", [L]),
    F = fun() ->
                hmisc:rand_n(100, L)
        end,
    {R, _S} = timer:tc(F),
    io:format("R: ~p ~n", [R]),
    F1 = fun() ->
                rand_n(99, L)
        end,
    {R1, S1} = timer:tc(F1),
    io:format("R: ~p ~n", [R1]),
    F2 = fun() ->
                rand_misc:urand_n(L, 100)
        end,
    {R2, S2} = timer:tc(F2),
    io:format("R: ~p ~n", [R2]),
    F3 = fun() ->
                 hmisc:rand_n(100, L)
         end,
    {R3, S3} = timer:tc(F3),
    io:format("R: ~p ~n", [R3]).


%% List 中选取 N 个不同的对象
rand_n(N, List) when is_list(List) ->
    %% Len = length(List),
    %% Ns = rand_n(N, 1, Len),
    %% [lists:nth(Index, List) || Index <- Ns];
    rand_n(N, list_to_tuple(List));
rand_n(N, Tuple) when is_tuple(Tuple) ->
    Len = tuple_size(Tuple),
    rand_n2(N, Len, Tuple, []).

%% 从[min , max] 中取出 N个数，不重复
%% rand_n1(Count, Min, Max) ->
%%     SeedTuple = list_to_tuple(lists:seq(Min, Max)),
%%     rand_n2(Count, tuple_size(SeedTuple), SeedTuple, []).

rand_n2(_Count, _SwitchIndex, {}, List) ->
    List;
rand_n2(0, _, _SeedTuple, List) ->
    List;
rand_n2(Count, SwitchIndex, SeedTuple, List) ->
    RandValue = hmisc:rand(1, SwitchIndex),
    {NewSeedTuple, Value} =
        switch_tuple_value(RandValue, SwitchIndex, SeedTuple),
    rand_n2(Count - 1, SwitchIndex - 1, NewSeedTuple, [Value | List]).

switch_tuple_value(From, To, Tuple) ->    
    %% ?WARNING_MSG("info: ~p~n", [Tuple]),
    FromValue = element(From, Tuple),    
    ToValue = element(To, Tuple),
    UpdateFrom = setelement(From, Tuple, ToValue),
    {UpdateFrom, FromValue}.


    %% F1 = fun() ->
    %%             hmisc:rand_n_p_r(5, L)
    %%     end,
    %% {R1, S1} = timer:tc(F1),
    %% io:format("R: ~p, S: ~p, ~n", [R1, S1]).
    %% L = lists:foldl(fun(K, Acc) ->
    %%                         [{K,K} | Acc]
    %%                 end, [], lists:seq(1,100)),
    %% F = fun() ->
    %%             rand_mini(L, 100000)
    %%     end,
    %% {R, _} = timer:tc(F),
    %% io:format("R: ~p ~n", [R]),
    %% L1 = lists:seq(1, 100000),
    %% F1 = fun() ->
    %%              lists:map(fun(_) ->
    %%                               hmisc:rand(L)
    %%                        end, L1)
    %%      end,
    %% {R1, _} = timer:tc(F1),
    %% io:format("R1: ~p~n", [R1]).

    %% A = merge_longitude_latitude(116.3906, 39.92324),
    %% B = merge_longitude_latitude(113.37390,23.13722),
    %%io:format("~n A: ~p~n B: ~p~n", [A, B]),
    %% L = lists:seq(1,1000000),
    %% F = fun() ->
    %%             hmisc:rand_n_new(999999, L)
    %%             %% lists:map(fun(N) ->
    %%             %%                   N / 100000
    %%             %%           end, hmisc:rand_n_new(99999, lists:seq(1,100000)))
    %%     end,
    %% {R, _} = timer:tc(F),
    %% io:format("R: ~p~n", [R]),
    %% F0 = fun() ->
    %%              RL = hmisc:shuffle(L),
    %%              lists:foldl(fun(X, Acc)->
    %%                                  [X|Acc]
    %%                          end, [], RL)
    %%      end,
    %% {R0, _} = timer:tc(F0),
    %% io:format("R0: ~p~n", [R0]).
    %% F2 = fun() ->
    %%              hmisc:rand_n(10, L)
    %%              %% lists:map(fun(N) ->
    %%              %%                   N / 100000
    %%              %%           end, hmisc:rand_n(99999, lists:seq(1,100000)))
    %%      end,
    %% {R2, _S} = timer:tc(F2),
    %% io:format("R2: ~p ~n", [R2]).
    
    
    %% RL = 
    %%     lists:foldl(fun(_, Acc) ->
    %%                         hmisc:rand_n1(5, L) ++ Acc
    %%                 end, [], lists:seq(1, 10000)),
    %% NRL = lists:sort(RL),
    %% {NN, CC} = 
    %%     lists:foldl(fun(N, {Num, Count})->
    %%                         if
    %%                             Num =:= N ->
    %%                                 {Num, Count+1};
    %%                             true ->
    %%                                 io:format("Num: ~p, Count: ~p", [Num, Count]),
    %%                                 {N, 1}
    %%                         end
    %%                 end, {1, 0}, NRL),
    %% io:format("NN: ~p, CC: ~p", [NN, CC]).
    %% F1 = fun() ->
    %%              hmisc:rand_n(99999, L)
    %%              %% lists:map(fun(N) ->
    %%              %%                   N / 100000
    %%              %%           end, hmisc:rand_n(99999, lists:seq(1,100000)))
    %%      end,
    %% {R1, _} = timer:tc(F1),
    %% io:format("hmisc:rand_n(10000, lists:seq(1,100000)): ~p~n", [R1]).
    %% F3 = fun() ->
    %%              lists:map(fun(_) ->
    %%                                %% merge_longitude_latitude(116.3906, 39.92324)
    %%                                BinaryList = merge_longitude_latitude(116.39068, 39.92324),
    %%                                big_data(BinaryList)
    %%                        end, lists:seq(1,100000)),
    %%              ok
    %%     end,
    %% {R3, _} = timer:tc(F3),
    %% io:format("R3: ~p", [R3]).


test_bin(P, G) ->
    Fun = fun() -> 
                  [P1, G1] = crypto:dh_generate_parameters(128, 5),
                  crypto:generate_key(dh, [P1, G1])
          end,
    {T, {PubServer, PrivServer}} = timer:tc(Fun),
    io:format("T: ~p", [T]).
    %% A = bin_to_int(PubServer),
    %% B = bin_to_int(PrivServer),
    %% C = bin_to_int(P1),
    %% D = bin_to_int(G1),
    %% {A, B, C, D}. %% A = D ^ B mod C

bin_to_int(Bin) ->
    List = binary_to_list(Bin),
    lists:foldl(fun(D, Acc) ->
                        Acc bsl 8 + D
                end, 0, List).    
