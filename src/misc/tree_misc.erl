-module(tree_misc).

-export([make_empty_tree/0,
         insert/2,
         delete/2,
         lookup/2,
         update/3,
         
         lookup_smaller_key/2,
         lookup_bigger_key/2,
         lookup_smaller_n/3,
         lookup_bigger_n/3
        ]).

make_empty_tree() ->
    gb_trees:empty().

insert({Key, Value}, Tree) ->
    gb_trees:insert(Key, Value, Tree);
insert([{Key, Value} | List], Tree) ->
    NTree = gb_trees:insert(Key, Value, Tree),
    insert(List, NTree);
insert([], Tree) ->
    Tree.

delete(Key, Tree) ->
    gb_trees:delete(Key, Tree).

lookup(Key, Tree) ->
    gb_trees:lookup(Key, Tree).

update(Key, Value, Tree) ->
    gb_trees:update(Key, Value, Tree).

%--------------------------------------------

%%查找 > 或 =:= Key出现的第一个Key
lookup_bigger_key(Key, {_, T} = _Tree) ->
    lookup_bigger_key1(Key, T).

lookup_bigger_key1(Key, {Key1, _Value1, Smaller, _Bigger}) when Key < Key1 ->
    case lookup_bigger_key1(Key, Smaller) of
        none ->
            Key1;
        Other ->
            Other
    end;
lookup_bigger_key1(Key, {Key1, _Value1, _Smaller, _Bigger}) when Key =:= Key1 ->
    Key;
lookup_bigger_key1(Key, {Key1, _Value1, _Smaller, Bigger}) when Key > Key1 ->
    lookup_bigger_key1(Key, Bigger);
lookup_bigger_key1(_, nil) ->
    none.


%% 查找比Key大的Num个值，即[{K1, V1}, {K2, V2} ...Num个...]
lookup_bigger_n(Num, Key, {_, T} = _Tree) ->
    {_, ResultList} = lookup_bigger_n1(Num, Key, T),
    ResultList.

lookup_bigger_n1(Num, Key, {Key1, Value1, Smaller, Bigger}) when Key < Key1 ->
    case lookup_bigger_n1(Num, Key, Smaller) of
        none ->
            %% 左子树为空时，处理掉右子树
            traverse_tree_right(Num-1, Bigger, [{Key1, Value1}]);
        {NNum, List} ->
            if 
                NNum > 0 ->
                    traverse_tree_right(NNum-1, Bigger, [{Key1, Value1} | List]);
                true ->
                    {0, List}
            end
    end;
lookup_bigger_n1(Num, Key, {Key1, Value1, _Smaller, Bigger}) when Key =:= Key1 ->
    %%相等时把右子树处理掉
    traverse_tree_right(Num-1, Bigger, [{Key1, Value1}]);
lookup_bigger_n1(Num, Key, {Key1, _Value1, _Smaller, Bigger}) when Key > Key1 ->
    lookup_bigger_n1(Num, Key, Bigger);
lookup_bigger_n1(_, _, nil) ->
    none.
    
%% 扫描符合条件的右子树
traverse_tree_right(Num, {Key, Value, Smaller, Bigger}, List) ->
    if
        Num =< 0 ->
            {0, List};
        true ->
            {NNum, NList} = traverse_tree_right(Num, Smaller, List),
            if
                NNum =< 0 ->
                    {0, NList};
                true ->
                    traverse_tree_right(NNum-1, Bigger, [{Key, Value}|NList])
            end
    end;
traverse_tree_right(0, _, List) ->
    {0, List};
traverse_tree_right(Num, nil, List) ->
    {Num, List}.

% -----------------------------------------------------------------------------------
%%查找 < 或 =:= Key出现的第一个Key
lookup_smaller_key(Key, {_, T} = _Tree) ->
    lookup_smaller_key1(Key, T).

lookup_smaller_key1(Key, {Key1, _Value1, Smaller, _Bigger}) when Key < Key1 ->
    lookup_smaller_key1(Key, Smaller);
lookup_smaller_key1(Key, {Key1, _Value1, _Smaller, _Bigger}) when Key =:= Key1 ->
    Key;
lookup_smaller_key1(Key, {Key1, Value1, Smaller, Bigger}) when Key > Key1 ->
    case lookup_smaller_key1(Key, Bigger) of
        none ->
            {{Key1, Value1}, Smaller};
        Other ->
            Other
    end;
lookup_smaller_key1(_, nil) ->
    none.

%查找比Key小的Num个值，即[{K1, V1}, {K2, V2} ...Num个...]
lookup_smaller_n(Num, Key, {_, T}) ->
    {_, ResultList} = lookup_smaller_n1(Num, Key, T),
    ResultList.

lookup_smaller_n1(Num, Key, {Key1, _Value1, Smaller, _Bigger}) when Key < Key1 ->
    lookup_smaller_n1(Num, Key, Smaller);
lookup_smaller_n1(Num, Key, {Key1, Value1, Smaller, _Bigger}) when Key =:= Key1 -> 
    %%相等时把左子树处理掉
    traverse_tree_left(Num-1, Smaller, [{Key1, Value1}]);  
lookup_smaller_n1(Num, Key, {Key1, Value1, Smaller, Bigger}) when Key > Key1 ->
    case lookup_smaller_n1(Num, Key, Bigger) of
        none -> 
            %% 右子树为空时也处理掉左子树
            %% {{Key1, Value1}, Smaller};
            traverse_tree_left(Num-1, Smaller, [{Key1, Value1}]);
        {NNum, List} ->  
            %% 由右子树递归回溯时，则把左子树处理掉
            if 
                NNum > 0 ->
                    traverse_tree_left(NNum-1, Smaller, [{Key1, Value1} | List]);
                true ->
                    {0, List}
            end
    end;
lookup_smaller_n1(_, _, nil) ->
    none.

%% 扫描符合条件的左子树
traverse_tree_left(Num, {Key, Value, Smaller, Bigger}, List) ->
    %% 可以理解成将子树进行左右旋转，然后遍历中序即可，画图便可理解
    if
        Num =< 0 ->
            {0, List};
        true ->
            {NNum, NList} = traverse_tree_left(Num, Bigger, List),
            if
                NNum =< 0 ->
                    {0, NList};
                true ->
                    traverse_tree_left(NNum-1, Smaller, [{Key, Value}|NList])
            end
    end;
traverse_tree_left(0, _, List) ->
    {0, List};
traverse_tree_left(Num, nil, List) ->
    {Num, List}.
