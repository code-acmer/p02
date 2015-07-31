-module(ds_misc).
%% 封装stdlib的数据结构操作
-export([dict_cons/3, orddict_cons/3, gb_trees_cons/3, ordd_store/2]).

-export([
         list_split/2, %% 将[]分割成N份[[]..[]]，预处理多进程的数据分块
         list_add_unique_element/2, %% 在List里面添加唯一的元素
         list_shuffle/1,
         list_dualmap/3,
         split/2,
         nth/2,
         map_n/2,
         all_ret/2,
         for/2,
         sum/2
        ]).

-export([to_hex/1, bytes2int/2, bytes2int/4]).

-export([rand_str/0, is_string/1]).

-export([short_record/1, record_modified/2, pr/1]).

-export([to_32bit_ip/1]).

-export([scout_binary_search/1]).

-export([rec_to_pl/2, rec_to_pl/3]).

-include("common.hrl").

%% data structure misc

dict_cons(Key, Value, Dict) ->
    dict:update(Key, fun (List) -> [Value | List] end, [Value], Dict).

orddict_cons(Key, Value, Dict) ->
    orddict:update(Key, fun (List) -> [Value | List] end, [Value], Dict).

gb_trees_cons(Key, Value, Tree) ->
    case gb_trees:lookup(Key, Tree) of
        {value, Values} -> 
            gb_trees:update(Key, [Value | Values], Tree);
        none -> 
            gb_trees:insert(Key, [Value], Tree)
    end.



list_split(L, N) -> 
    list_split0(L, [[] || _ <- lists:seq(1, N)]).

list_split0([], Ls) -> 
    Ls;
list_split0([I | Is], [L | Ls]) -> 
    list_split0(Is, Ls ++ [[I | L]]).

list_add_unique_element(Add, List) ->
    %% Notice: 不用lists:usort([Add|List]). 是因为若List是有序的，则[Add | List]就变乱序了，这个时候调用usort会开销大很多
    %% ordsets:to_list(ordsets:add_element(Add, ordsets:from_list(List))).
    %% 等价于ordsets:add_element(Add, ordsets:from_list(List))，ordsets:add_element是O(N)的
    %% 一般，这个调用返回会存起来，再作为List传进来（有序的），所以相对来说后者做法会比较高效
    %% 乱序的话，两者复杂度一样。
    ordsets:to_list(ordsets:add_element(Add, ordsets:from_list(List))).

list_shuffle(L) ->
    List1 = [{random:uniform(), X} || X <- L],
    List2 = lists:keysort(1, List1),
    [E || {_, E} <- List2].

list_dualmap(_F, [], []) ->
    [];
list_dualmap(F, [E1 | R1], [E2 | R2]) ->
    [F(E1, E2) | list_dualmap(F, R1, R2)].

sum(Pos, List) ->
    lists:foldl(fun(Tuple, Sum) ->
                        Sum + element(Pos, Tuple)
                end, 0, List).

split(N, List) ->
    split(N, List, []).

split(_, [], R) ->
    {R, []};
split(0, L, R) ->
    {R, L};
split(N, [H|T], R) ->
    split(N-1, T, [H|R]).

%% 不管index，只跑n次，返回list
map_n(N, F) 
  when N >=0 ->
    map_n(N, F, []).

map_n(0, _, List) ->
    List;
map_n(N, F, List) ->
    map_n(N-1, F, [F()|List]).

to_hex([]) ->
    [];
to_hex(Bin) when is_binary(Bin) ->
    to_hex(binary_to_list(Bin));
to_hex([H|T]) ->
    [to_digit(H div 16), to_digit(H rem 16) | to_hex(T)].

to_digit(N) when N < 10 -> $0 + N;
to_digit(N) -> $a + N-10.

%% 获取HEX格式的随机字串
rand_str() ->
    to_hex(crypto:rand_bytes(4)).


is_string([C | Cs]) when is_integer(C), C >= 0, C =< 16#10ffff ->
    is_string(Cs);
is_string([_ | _]) ->
    false;
is_string([]) ->
    true;
is_string(_) ->
    false.

all_ret(Pred, [Hd|Tail]) ->
    case Pred(Hd) of
        true -> 
            all_ret(Pred, Tail);
        Other -> Other
    end;
all_ret(Pred, []) 
  when is_function(Pred, 1) -> true. 

%% for循环
for(Max, F) ->
    for(0, Max, F).

for(Max, Max, _F) ->
    [];
for(I, Max, F)  when I < Max ->
    [F(I) | for(I+1, Max, F)].


bytes2int(N1, N0) when 0 =< N1, N1 =< 255,
		       0 =< N0, N0 =< 255 ->
    (N1 bsl 8) bor N0.
bytes2int(N3, N2, N1, N0) when 0 =< N3, N3 =< 255,
			       0 =< N2, N2 =< 255,
			       0 =< N1, N1 =< 255,
			       0 =< N0, N0 =< 255 ->
    (N3 bsl 24) bor (N2 bsl 16) bor (N1 bsl 8) bor N0.


pr(Record) ->    
    RecordName = element(1, Record),
    case all_record:get_fields(RecordName) of
        [] ->
            Record;
        RecordFields ->                                        
            lists:zip(RecordFields, tl(tuple_to_list(Record)))
    end.

short_record(undefined) ->
    [];
short_record([]) ->
    [];
%% for repeat field, it is a tuple list
short_record(RecordList) 
  when is_list(RecordList),
       is_tuple(hd(RecordList)) ->
    [short_record(Record) || Record <- RecordList];
short_record(Record) 
  when is_tuple(Record) ->
    case pr(Record) of
        Record ->
            Record;
        ValList ->
            {element(1, Record), 
             lists:reverse(lists:foldl(fun({Field, Val}, Acc) ->
                                               case short_record(Val) of
                                                   [] ->
                                                       Acc;
                                                   ShortVal ->
                                                       [{Field, ShortVal}|Acc]
                                               end
                                       end, [], ValList))}
    end;
short_record(Other) ->
    Other.


ordd_store(List, Dict) when is_list(List)->
    lists:foldl(fun({K, V}, AccDict) ->
                        orddict:store(K, V, AccDict)
                end, Dict, List);
ordd_store({K, V}, Dict) ->
    orddict:store(K, V, Dict).

record_modified(OldRecord, NewRecord) ->
    Size = tuple_size(OldRecord),
    record_modified2(OldRecord, NewRecord, false, Size, Size, []).

record_modified2(_, NewRecord, ChangeFlag, 1, _Size, Acc) ->
    if
        ChangeFlag =:= true ->
            list_to_tuple([element(1, NewRecord) | Acc]);
        true ->
            []
    end;
record_modified2(OldRecord, NewRecord, ChangeFlag, Index, Size, Acc) ->    
    Old = element(Index, OldRecord),
    New = element(Index, NewRecord),
    if
        Old =:= New ->
            record_modified2(OldRecord, NewRecord, 
                             ChangeFlag, Index-1, Size, [undefined|Acc]);
        true ->
            record_modified2(OldRecord, NewRecord, 
                             true, Index-1, Size, [New | Acc])
    end.
                
%% record_modified(R1, R2)
%%   when is_tuple(R1) andalso
%%        is_tuple(R2) ->
%%     L1 = tuple_to_list(R1),
%%     L2 = tuple_to_list(R2),
%%     record_modified({[], false}, L1, L2).
%% record_modified({[], InFlag}, [Head | Rest1], [Head | Rest2]) ->
%%     record_modified({[Head], InFlag}, Rest1, Rest2);
%% record_modified({ResultList, InFlag}, [Head | Rest1], [Head | Rest2]) ->
%%     record_modified({[undefined | ResultList], InFlag}, Rest1, Rest2);
%% record_modified({ResultList, _}, [_H1 | Rest1], [H2 | Rest2]) ->
%%     record_modified({[H2 | ResultList], true}, Rest1, Rest2);
%% record_modified({ResultList, true}, [], []) ->
%%     %% 将最终的结果反转成 record
%%     list_to_tuple(lists:reverse(ResultList));
%% record_modified({_, false}, [], []) ->
%%     %% 没有任何变更
%%     [];
%% record_modified(RList, L1, L2) ->
%%     ?DEBUG("record compare failed: ~p~n~p~n~p~n", [RList, L1, L2]),
%%     [].


nth(1, [H|_]) -> H;
nth(N, [_|T]) when N > 1 ->
    nth(N - 1, T);
nth(_, _) ->
    [].

to_32bit_ip({A, B, C, D}) ->
    bytes2int(A, B, C, D).


binary_search(Tuple, Size, Key, Begin, End) 
  when End > Begin ->
    %% io:format("Tuple, Size, Key, Begin, End ~p~n", [{Tuple, Size, Key, Begin, End}]),
    Mid = (Begin + End) div 2,
    if
        element(Mid, Tuple) < Key ->
            %% 中间小于Key，往右边找
            binary_search(Tuple, Size, Key, Mid+1, End);
        true ->
            binary_search(Tuple, Size, Key, Begin, Mid)
    end;
binary_search(Tuple, Size, Key, Begin, End) ->
    %% io:format("Tuple, Size, Key, Begin, End ~p~n", [{Tuple, Size, Key, Begin, End}]),
    Begin.

%% binary_search() ->
%%     scout_binary_search({200,400,600}, {1, 2, 3}).

scout_binary_search({PowerSumTuple, IdTuple}) ->
    %% Tuple = {1,10,10,20,20,20,30,40},     
    Size = tuple_size(PowerSumTuple),
    Key = rand_misc:rand(element(Size, PowerSumTuple)),
    Index = binary_search(PowerSumTuple, Size, Key, 1, Size),
    element(Index, IdTuple).

%% Convert record to proplist
%%
%% RecInfo is from record_info(fields, record_name)
%%     Be care record_name should be an 'atom', not a Variable
%% see http://erlang.org/pipermail/erlang-questions/2007-January/024666.html

rec_to_pl(RecInfo, Record) ->
    rec_to_pl_all(RecInfo, Record, 2, []).

rec_to_pl_all([H|T], Record, N, Acc) ->
    Acc1 = [{H, erlang:element(N, Record)}|Acc],
    rec_to_pl_all(T, Record, N+1, Acc1);
rec_to_pl_all([], _Record, _N, Acc) ->
    Acc.

rec_to_pl2([H|T], Record, NeedFields, N, Acc) ->
    case lists:member(H, NeedFields) of
        false ->
            rec_to_pl2(T, Record, NeedFields, N+1, Acc);
        true ->
            Acc1 = [{H, erlang:element(N, Record)}|Acc],
            rec_to_pl2(T, Record, NeedFields, N+1, Acc1)

    end;
rec_to_pl2([], _Record, _, _N, Acc) ->
    Acc.

rec_to_pl(RecInfo, Record, NeedFields) ->
    rec_to_pl2(RecInfo, Record, NeedFields, 2, []).


