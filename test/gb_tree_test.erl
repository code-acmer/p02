-module(gb_tree_test).
-compile(export_all).

%% test() ->
%%     List = lists:foldl(fun(X, Acc) -> 
%%                                [{X, X} | Acc]
%%                        end, [], lists:seq(1,10)),
%%     Tree = gb_trees:from_orddict(List),
%%     %% NTree = lists:foldl(fun({K, V}, OldTree)->
%%     %%                     gb_trees:insert(K+10, V, OldTree)
%%     %%             end, Tree, List),
%%     io:format("Tree: ~p~n", [Tree]),
%%     NewTree = gb_trees:delete(5, Tree),
%%     io:format("NewTree: ~p", [NewTree]).


%% start() ->
%%     List = lists:foldl(fun(X, Acc) -> 
%%                                [{X, X} | Acc]
%%                        end, [], lists:seq(1,1000000)),
%%     F = fun() ->
%%                 gb_trees:from_orddict(List),
%%                 ok
%%         end,
%%     R = timer:tc(F),

%%     Tree = gb_trees:from_orddict(List),
      
%%     F1 = fun() ->
%%                  lists:foldl(fun({K, V}, OldTree)->
%%                                      gb_trees:insert(K+1000000, V, OldTree)
%%                              end, Tree, List),
%%                  ok
%%          end,    
%%     R1 = timer:tc(F1),
%%     io:format("R : ~p , R1 : ~p", [R, R1]).
%% tree_test() ->
%%     Max = 1000000,
%%     List = 
%%         lists:map(fun(N) ->
%%                           {N, N}
%%                   end, lists:seq(1, Max)),
%%     Tree = gb_trees:from_orddict(List),
%%     Num = hmisc:rand(1, Max),
%%     io:format("random num ~p~n", [Num]),
%%     F = fun()
%%     case gb_trees:lookup(Num, Tree) of
%%         none ->
%%             io:format("lookup false ~n", []);
%%         _ ->
%%             skip
%%     end,
%%     T2 = os:timestamp(),
%%     Times = timer:now_diff(T2, T1),
%%     io:format("trees: ~p microseconds~n", [Times]),
%%     T3 = os:timestamp(),
%%     case lists:keyfind(Num, 1, List) of
%%         false ->
%%             io:format("keyfind false ~n", []);
%%         _ ->
%%             ok
%%     end,
%%     T4 = os:timestamp(),
%%     Times2 = timer:now_diff(T4, T3),
%%     io:format("list: ~p microseconds~n", [Times2]),
%%     tree_insert_test(List, Tree).

%% tree_insert_test(List, Tree) ->
%%     Num = hmisc:rand(1, 100000),
%%     io:format("random num ~p~n", [Num]),
%%     T1 = os:timestamp(),
%%     gb_trees:enter(Num, Num, Tree),
%%     T2 = os:timestamp(),
%%     Times = timer:now_diff(T2, T1),
%%     io:format("trees: ~p microseconds~n", [Times]),
%%     T3 = os:timestamp(),
%%     lists:keystore(Num, 1, List, {Num, Num}),
%%     T4 = os:timestamp(),
%%     Times2 = timer:now_diff(T4, T3),
%%     io:format("list: ~p microseconds~n", [Times2]),
%%     T5 = os:timestamp(),
%%     gb_trees:balance(Tree),
%%     T6 = os:timestamp(),
%%     Times3 = timer:now_diff(T6, T5),
%%     io:format("balance: ~p microseconds~n", [Times3]).

%% init() ->
%%     Tree = tree_misc:make_empty_tree(),
%%     F1 = fun() ->
%%                  lists:foldl(fun(X, Acc) -> 
%%                                      [{X, X} | Acc]
%%                              end, [], lists:seq(1, 10000))
%%          end,
%%     {R1, List} = timer:tc(F1),
%%     io:format("R1 : ~p ~n", [R1]),
%%     F2 = fun() ->
%%                  lists:foldl(fun({K, V}, OldTree)->
%%                                      gb_trees:insert(K, V, OldTree)
%%                              end, Tree, List)
%%          end,
%%     {R2, NTree} = timer:tc(F2),
%%     io:format("R2 : ~p ~n", [R2]),
%%     RandNumList = hmisc:rand_n(1000, List),
%%     {NTree, RandNumList}.

test() ->
    Tree = tree_misc:make_empty_tree(),
    %% F1 = fun() ->
    %%              lists:foldl(fun(X, Acc) -> 
    %%                                  [{X, X} | Acc]
    %%                          end, [], lists:seq(1, 1000000))
    %%      end,
    %% {R1, List} = timer:tc(F1),
    %% io:format("R1 : ~p ~n", [R1]),
    List = [{5,5}, {4,4}, {7,7}, {4.5, 4.5}, {8,8}],
    F2 = fun() ->
                 lists:foldl(fun({K, V}, OldTree)->
                                     NewTree = gb_trees:balance(gb_trees:insert(K, V, OldTree)),
                                     io:format("NewTree: ~p~n", [NewTree]),
                                     NewTree
                             end, Tree, List)
         end,
    {_, NTree} = timer:tc(F2),
    io:format("NTree : ~p ~n", [NTree]).
    %% F4 = fun() ->
    %%              hmisc:rand_n(1000, List)
    %%      end,
    %% {R4, RandNumList} = timer:tc(F4),
    %%              %% io:format("NTree: ~p~n", [NTree]),
    
    %% io:format("R4: ~p, Start....~n", [R4]),
    %% F5 = fun() ->
    %%              lists:map(fun(_) ->
    %%                                hmisc:rand(1,1000000)
    %%                        end, lists:seq(1,1000000))
    %%      end,
    %% {R5, _} = timer:tc(F5),
    %% io:format("R5: ~p ~n", [R5]),
    %% F3 = fun() ->
    %%              lists:map(fun({Key, _Value}) ->
    %%                                tree_misc:lookup_bigger_n(20, Key + 0.5, NTree)
    %%                                %tree_misc:iterator_find_multi_with_key(Key + 0.5, 20, NTree)
    %%                        end, RandNumList)
    %%      end,
    %% {R3, [Result|_]} = timer:tc(F3),
    %% io:format("R3 : ~p, Result: ~p ~n", [R3, Result]).
    
    
