-module(list_misc).
-export([list_match_one/2,
         list_match/2,
         sublist/2,
         keyfind_nth/3,
         keyignore/3
        ]).

list_match_one(_, []) ->
    [];
list_match_one([], [H|_]) when is_tuple(H) ->
    H;
list_match_one(Condition, [Tuple|Tail]) when is_tuple(Tuple) ->
    case is_match(Condition, Tuple) of
        true ->
            Tuple;
        false ->
            list_match_one(Condition, Tail)
    end.

list_match(Condition, List) ->
    list_match2(Condition, List, []).

list_match2(_, [], AccList) ->
    AccList;
list_match2([], List, AccList) ->
    List ++ AccList;
list_match2(Condition, [Tuple|Tail], AccList) ->
    case is_match(Condition, Tuple) of
        true ->
            list_match2(Condition, Tail, [Tuple|AccList]);
        false ->
            list_match2(Condition, Tail, AccList)
    end.


is_match([], _Tuple) ->
    true;
is_match([Condition|Tail], Tuple) ->
    case is_match2(Condition, Tuple) of
        true ->
            is_match(Tail, Tuple);
        false ->
            false
    end.

is_match2({}, _Tuple) ->
    true;
is_match2({Pos, Value}, Tuple) ->
    is_match2({Pos, "=:=", Value}, Tuple);
is_match2({Pos, "=", Value}, Tuple) ->
    is_match2({Pos, "=:=", Value}, Tuple);
is_match2({Pos, "=:=", Value}, Tuple) ->
    element(Pos, Tuple) =:= Value;
is_match2({Pos, ">", Value}, Tuple) ->
    element(Pos, Tuple) > Value;
is_match2({Pos, "<", Value}, Tuple) ->
    element(Pos, Tuple) < Value;
is_match2({Pos, ">=", Value}, Tuple) ->
    element(Pos, Tuple) >= Value;
is_match2({Pos, "=<", Value}, Tuple) ->
    element(Pos, Tuple) =< Value;
is_match2({Pos, "=/=", Value}, Tuple) ->
    element(Pos, Tuple) =/= Value;
is_match2({Pos, between, [Min, Max]}, Tuple) ->
    Value = element(Pos, Tuple),
    Value >= Min andalso Value =< Max;
is_match2(Fun, Tuple) when is_function(Fun, 1) ->
    Fun(Tuple);
is_match2(Else, _Tuple) ->
    error_logger:info_msg("not support expr ~p~n", [Else]),
    false.

sublist(List, L) when is_integer(L), is_list(List) ->
    sublist_2(List, L, []).

sublist_2([], _, AccHead) ->
    {AccHead, []};
sublist_2(List, L, AccHead) when L =< 0 ->
    {AccHead, List};
sublist_2([H|T], L, AccHead) when L > 0->
    sublist_2(T, L - 1, [H|AccHead]).

%% if the key is not found return 0
keyfind_nth(Key, List, KeyPos) ->
    keyfind_nth(Key, List, KeyPos, 1).
keyfind_nth(_Key, [], _KeyPos, _N) ->
    0;
keyfind_nth(Key, [Value|List], KeyPos, N) ->
    case element(KeyPos, Value) of
        Key ->
            N;
        _->
            keyfind_nth(Key, List, KeyPos, N+1)
    end.

keyignore(List, KeyPos, Keys) ->
    lists:filter(fun(Item) ->
                         not lists:member(element(KeyPos, Item), Keys)
                 end, List).
                             
