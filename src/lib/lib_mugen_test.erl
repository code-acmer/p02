-module(lib_mugen_test).
-compile(export_all).
-include("define_logger.hrl").

init_table() ->
    {atomic, ok} = mnesia:create_table(mugen_rank, [{type, ordered_set}, {disc_copies, [node()]},
                                     {attributes, [key, value]}]),
    {atomic, ok} = mnesia:create_table(mugen_cask, [{type, set}, {disc_copies, [node()]},
                                                    {attributes, [key, value]}]),
    lists:foreach(fun(Num) ->
                          ok = mnesia:dirty_write(mugen_cask, {mugen_cask, Num, 0})
                  end, lists:seq(1, 100)),
    ets:new(ets_mugen, [named_table, set, public]).  %%{PlayerId, Score}

%%---------------测试开始接口---------------%%
%%开N个进程
start(Number) ->
    [spawn(fun() -> start2(E) end)|| E <- lists:seq(1, Number)].

%%每个进程插入100个数据
start2(E) ->
    Min = E * 10000,
    lists:foreach(fun(Num) ->
                          PlayerId = Min + Num,
                          Score = hmisc:rand(1, 100),
                          insert_mugen(Score, PlayerId)
                  end, lists:seq(1, 10000)),
    io:format("run ok ~n", []).
    


%%----------------------------------------%%

insert_mugen(Score, PlayerId) ->
    Size = mnesia:table_info(mugen_rank, size),
    LowKey = mnesia:dirty_first(mugen_rank),
    case ets:lookup(ets_mugen, PlayerId) of
        [] ->
            insert_to_rank(Size, LowKey, Score, PlayerId),
            mnesia:dirty_update_counter(mugen_cask, Score, 1),
            ets:insert(ets_mugen, {PlayerId, Score});
        [{PlayerId, OldScore}] ->
            if
                OldScore =:= Score ->
                    skip;
                true ->                        
                    mnesia:dirty_update_counter(mugen_cask, OldScore, -1),
                    mnesia:dirty_update_counter(mugen_cask, Score, 1),
                    ets:insert(ets_mugen, {PlayerId, Score}),                            
                    case mnesia:dirty_read(mugen_rank, {OldScore, PlayerId}) of
                        [] ->
                            insert_to_rank(Size, LowKey, Score, PlayerId);
                        _ ->
                            if
                                {Score, PlayerId} > LowKey ->
                                    mnesia:dirty_write(mugen_rank, {mugen_rank, {Score, PlayerId}, 0});
                                true ->
                                    skip
                            end,
                            mnesia:dirty_delete(mugen_rank, {OldScore, PlayerId})
                    end
            end
    end.

insert_to_rank(Size, LowKey, Score, PlayerId) ->
    if
        Size < 100 ->
            mnesia:dirty_write(mugen_rank, {mugen_rank, {Score, PlayerId}, 0});
        true ->
            if
                {Score, PlayerId} > LowKey ->
                    mnesia:dirty_write(mugen_rank, {mugen_rank, {Score, PlayerId}, 0}),
                    delete_over_flow(Size - 100 + 1);
                true ->
                    skip
            end
    end.

delete_over_flow(Num) ->
    MinKey = mnesia:dirty_first(mugen_rank),
    delete2(Num, MinKey).

delete2(Num, _) when Num =< 0 ->
    skip;
delete2(Num, Key) ->
    mnesia:dirty_delete(mugen_rank, Key),
    delete2(Num - 1, mnesia:dirty_next(mugen_rank, Key)).
    

%%打印排行榜的数据
print_rank() ->
    AllKeys = mnesia:dirty_all_keys(mugen_rank),
    io:format("AllKeys ~w~n", [AllKeys]),
    Length = length(AllKeys),
    ?PRINT("rank length is ~p~n", [Length]).

get_player_rank(PlayerId) ->
    case ets:lookup(ets_mugen, PlayerId) of
        [] ->
            ?PRINT("player data not found in ets  ~p~n", [PlayerId]);
        [{PlayerId, Score}] ->
            AllKeys = mnesia:dirty_all_keys(mugen_rank),
            case find_rank({Score, PlayerId}, lists:reverse(AllKeys), 0) of
                false ->
                    ?PRINT("player are out of 100 rank  ~p~n", [PlayerId]);
                {true, Rank} ->
                    ?PRINT("player's rank is ~p~n", [Rank])
            end
    end.

get_player_cask_rank(PlayerId) ->
    case ets:lookup(ets_mugen, PlayerId) of
        [] ->
            ?PRINT("player data not found in ets ~p~n", [PlayerId]);
        [{_, Score}] ->
            count_cask_rank(Score)
    end.

find_rank(_, [], _) ->
    false;
find_rank(Value, [Value|_Tail], Num) ->
    {true, Num + 1};
find_rank(Value, [_|Tail], Num) ->
    find_rank(Value, Tail, Num + 1).

count_cask_rank(Score) ->
    if
        Score < 100 ->
            Before = 
                lists:foldl(fun(NScore, AccCount) ->
                                    [{_, _, Num}] = mnesia:dirty_read(mugen_cask, NScore),
                                    AccCount + Num
                            end, 0, lists:seq(Score + 1, 100)),
            [{_, _, NewNum}] = mnesia:dirty_read(mugen_cask, Score),
            ?PRINT("player is between ~p and ~p rank~n", [Before, Before+NewNum]);
        true ->
            [{_, _, Num}] = mnesia:dirty_read(mugen_cask, Score),
            ?PRINT("player is before ~p rank~n", [Num])
    end.
%%检查排行榜是否和缓存数据一致
check_rank() ->
    EtsDataList = get_ets_all_data(ets:first(ets_mugen), []),
    SortFun = 
        fun({Id, Score}, {Id2, Score2}) ->
                if
                    Score2 > Score ->
                        false;
                    Score =:= Score2 andalso Id2 > Id ->
                        false;
                    true ->
                        true
                end
        end,
    NewList = lists:sort(SortFun, EtsDataList),
    io:format("NewList ~w~n", [NewList]),
    AllKeys = mnesia:dirty_all_keys(mugen_rank),
    check_rank2(lists:reverse(AllKeys), NewList).

get_ets_all_data('$end_of_table', List) ->
    List;
get_ets_all_data(Key, List) ->
    [{Key, Value}] = ets:lookup(ets_mugen, Key),
    get_ets_all_data(ets:next(ets_mugen, Key), [{Key, Value}|List]).

check_rank2([], _) ->
    {ok, all_pass};
check_rank2(_, []) ->
    {fuck, ets_error};
check_rank2([{Score, Id}|T1], [{Id, Score}|T2]) ->
    check_rank2(T1, T2);
check_rank2([{Score, Id}|_], _) ->
    ?PRINT("Score ~p, Id ~p not match ets ~n", [Score, Id]),
    {fuck, not_match}.

                
%%-------------clear-------------%%
delete_all_table() ->
    mnesia:delete_table(mugen_rank),
    mnesia:delete_table(mugen_cask),
    ets:delete(ets_mugen).
