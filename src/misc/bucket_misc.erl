-module(bucket_misc).
-author('liuzhigang@moyou.me').
-export([new/0,
         new/1,
         size/1,
         insert/3,
         delete/2,
         get_data_bigger/3,
         get_data_smaller/3
        ]).

-define(DEFAULT_PAGE_SIZE, 50).

-record(bucket, {size = 0,
                 p_size = ?DEFAULT_PAGE_SIZE, %%默认每页的数据数量
                 dict = dict:new(),
                 max_p = 0 %%还是要记录最大页数，然后就要求数据的key是连续的，其实就要求桶是连续的
                }).

%% -record(data, {b_key = 0,
%%                data_list = []}).

new() ->
    #bucket{}.

new(Size) when is_integer(Size) ->
    #bucket{p_size = Size}.

size(Bucket) when is_record(Bucket, bucket) ->
    Bucket#bucket.size.

insert(Key, Value, #bucket{size = Size,
                           p_size = PageSize,
                           dict = Dict,
                           max_p = MaxP} = Bucket) ->
    Bkey = key_to_bkey(Key, PageSize),
    NewDict = 
        case dict:find(Bkey, Dict) of
            error ->
                dict:store(Bkey, [{Key, Value}], Dict);
            {ok, List} ->
                NewList = 
                    orddict:store(Key, Value, List),
                dict:store(Bkey, NewList, Dict)
        end,
    Bucket#bucket{size = Size + 1,
                  dict = NewDict,
                  max_p = max(MaxP, Bkey)}.

delete(Key, #bucket{size = Size,
                    p_size = PageSize,
                    dict = Dict} = Bucket) ->
    Bkey = key_to_bkey(Key, PageSize),
    case dict:find(Bkey, Dict) of
        error ->
            error_logger:info_msg("delete key not found Key ~p~n", [Key]),
            Bucket;
        {ok, List} ->
            case lists:keytake(Key, 1, List) of
                false ->
                    error_logger:info_msg("delete key not found Key ~p~n", [Key]),
                    Bucket;
                {value, _, Rest} ->
                    Bucket#bucket{size = Size - 1,
                                  dict = dict:store(Bkey, Rest, Dict)}
            end
    end.
            
get_data_bigger(Key, Count, #bucket{p_size = PageSize,
                                    dict = Dict,
                                    max_p = MaxBKey}) ->
    Bkey = key_to_bkey(Key, PageSize),
    lists:reverse(get_bigger_data2(Key, Bkey, Count, Dict, MaxBKey, [])).

get_data_smaller(Key, Count, #bucket{p_size = PageSize,
                                     dict = Dict}) ->
    Bkey = key_to_bkey(Key, PageSize),
    get_smaller_data2(Key, Bkey, Count, Dict, []).

get_bigger_data2(_Key, _Bkey, 0, _Dict, _MaxBKey, AccList) ->
    AccList;
get_bigger_data2(_Key, Bkey, _Count, _Dict, MaxBKey, AccList) when Bkey > MaxBKey ->
    AccList;
get_bigger_data2(Key, Bkey, Count, Dict, MaxBKey, AccList) ->
    case dict:find(Bkey, Dict) of
        error ->
            get_bigger_data2(Key, Bkey + 1, Count, Dict, MaxBKey, AccList);
        {ok, OrdList} ->
            FilterFun = 
                fun
                    ({K, _}) when K > Key ->
                        true;
                    (_) ->
                        false
                end,
            {Need, _, Length} = sublist(OrdList, Count, FilterFun),
            get_bigger_data2(Key, Bkey + 1, Count - Length, Dict, MaxBKey, Need ++ AccList)
    end.

get_smaller_data2(_Key, _Bkey, 0, _Dict, AccList) ->
    AccList;
get_smaller_data2(_Key, 0, _Count, _Dict, AccList) ->
    AccList;
get_smaller_data2(Key, Bkey, Count, Dict, AccList) ->
    case dict:find(Bkey, Dict) of
        error ->
            get_smaller_data2(Key, Bkey - 1, Count, Dict, AccList);
        {ok, OrdList} ->
            FilterFun = 
                fun
                    ({K, _}) when K < Key ->
                        true;
                    (_) ->
                        false
                end,
            {Need, _, Length} = sublist(lists:reverse(OrdList), Count, FilterFun),
            get_smaller_data2(Key, Bkey - 1, Count - Length, Dict, Need ++ AccList)
    end.


key_to_bkey(Key, PageSize) ->
    (Key - 1) div PageSize + 1.



sublist(List, L, Fun) when is_integer(L), is_list(List), is_function(Fun) ->
    {AccHead, AccTail, RestL} = sublist_2(List, L, Fun, [], []),
    {AccHead, AccTail, L - RestL}.

sublist_2([], RestL, _, AccHead, AccTail) ->
    {AccHead, AccTail, RestL};
sublist_2(_List, L, _, AccHead, AccTail) when L =< 0 ->
    {AccHead, AccTail, 0};
sublist_2([{_K, V} = H|T], L, FilterFun, AccHead, _) when L > 0->
    case FilterFun(H) of
        true ->
            sublist_2(T, L - 1, FilterFun, [V|AccHead], T);
        false ->
            sublist_2(T, L, FilterFun, AccHead, T)
    end.
