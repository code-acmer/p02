-module(rand_misc).
-compile(export_all).
%%-export([]).

rand(Min, Max) 
  when Min =< Max->
    %% 如果没有种子，将从核心服务器中去获取一个种子，以保证不同进程都可取得不同的种子
    RandSeed = case get(hmisc_rand_seed) of
                   undefined ->
                       hmod_rand:get_seed();
                   TmpRandSeed ->
                       TmpRandSeed
               end,
    {F, NewRandSeed} =  random:uniform_s(Max - (Min - 1), RandSeed),
    %%?DEBUG("{F, NewRandSeed} ~p~n", [{F, NewRandSeed}]),
    put(hmisc_rand_seed, NewRandSeed),
    F + (Min - 1).

%%不重复位置
urand_n(List, N) ->
    T1 = os:timestamp(),
    {Size, DataDict} = 
        lists:foldl(fun(Value, {Num, AccDict}) ->
                            NewDict = dict:store(Num + 1, Value, AccDict),
                            {Num + 1, NewDict}
                    end, {0, dict:new()}, List),
    T2 = os:timestamp(),
    %io:format("cost ~p~n", [timer:now_diff(T2, T1)]),
    %io:format("Size ~p, DataDict ~p~n", [Size, DataDict]),
    if
        N =:= Size ->
            List;
        N > Size ->
            throw({not_enough_length, Size, N});
        true ->
            traverse_dict(DataDict, Size, N, [])
    end.
%%可以重复到同一个位置
rand_n(List, N) ->
    ok.

rand_p(L) ->
    ok.

rand_p() ->
    ok.

traverse_dict(_DataDict, _Size, 0, AccList) ->
    AccList;
traverse_dict(DataDict, Size, N, AccList) ->
    Num = rand(1, Size),
    {ok, Value} = dict:find(Num, DataDict),
    if
        Num =:= Size ->
            traverse_dict(DataDict, Size - 1, N - 1, [Value|AccList]);
        true ->
            %io:format("Size ~p~n", [Size]),
            {ok, LastValue} = dict:find(Size, DataDict),
            NewDict = dict:store(Num, LastValue, DataDict),
            traverse_dict(NewDict, Size - 1, N - 1, [Value|AccList])
    end.
            
