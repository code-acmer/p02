%% 排行榜引擎是从小到大排序
%% 清理要从first开始，然后next
%% top要从last开始取，然后prev
%% rank值计算，获取当前的key之后，next到last，计算有多少个位置
%% 排行榜引擎是从小到大排序
%% 清理要从first开始，然后next
%% top要从last开始取，然后prev
%% rank值计算，获取当前的key之后，next到last，计算有多少个位置
-module(lib_rank).

-include("define_rank.hrl").
-include("define_logger.hrl").

-export([insert/5, clean_over_flow/2, top/2, rank/2]).
-export([get_rank_info/3]).

%%new_insert
insert(Table, MaxSize, PlayerId, Value, Ext) ->
    ?DEBUG("Table ~p, PlayerId ~p, Value ~p~n", [Table, PlayerId, Value]),
    case check_insert(Table, MaxSize, Value) of
        false ->
            ignore;
        _ ->                
            case hdb:dirty_index_read(Table, PlayerId, #rank.player_id) of
                [#rank{value = OldValue}] ->
                    if
                        OldValue >= Value ->
                            skip;
                        true ->
                            hdb:dirty_delete(Table, OldValue),
                            hdb:sync_write(Table, #rank{
                                                      value = Value,
                                                      player_id = PlayerId,
                                                      ext = Ext
                                                     })
                    end;
                [] ->
                    hdb:sync_write(Table, #rank{
                                              value = Value,
                                              player_id = PlayerId,
                                              ext = Ext
                                             });
                Error ->
                    ?WARNING_MSG("Error ~p~n", [Error]),
                    skip
            end
    end.

check_insert(Table, MaxSize, Value) ->
    Size = hdb:size(Table),
    LowValue = hdb:dirty_first(Table),
    Size =< MaxSize orelse
        Value > LowValue.  

clean_over_flow(Table, MaxSize) ->
    Size = hdb:size(Table),
    Num = Size - MaxSize,
    if
        Num > 0 ->
            clean_over_flow2(Table, hdb:dirty_first(Table), Num);
        true ->
            ignore
    end.

clean_over_flow2(_, '$end_of_table', _) ->
    ok;
clean_over_flow2(Table, Key, Num) 
  when Num > 0 ->
    hdb:dirty_delete(Table, Key),
    clean_over_flow2(Table, hdb:dirty_next(Table, Key), Num - 1);
clean_over_flow2(_, _, _) ->
    ok.

top(Table, all) ->
    Size = hdb:size(Table),
    top(Table, Size);
top(Table, Len) ->
    top2(Table, hdb:dirty_last(Table), Len).
        
top2(_, '$end_of_table', _) ->
    [];
top2(_, _, 0) ->
    [];
top2(Table, Key, Num) ->
    [hdb:dirty_read(Table, Key)|top2(Table, hdb:dirty_prev(Table, Key), Num - 1)].

rank(Table, PlayerId) ->
    case hdb:dirty_index_read(Table, PlayerId, #rank.player_id) of
        [] ->
            {0, undefined};
        [#rank{value = Value}] ->
            {rank2(Table, hdb:dirty_next(Table, Value), 0) + 1, Value}
    end.

%%算出前面还有几个人
rank2(_, '$end_of_table', Num) ->
    Num;
rank2(Table, Key, Num) ->
    rank2(Table, hdb:dirty_next(Table, Key), Num + 1).            

%%-----------------------------------------------------------------------%%
get_rank_info(ReadTable, Len, PlayerId) ->
    RankList = lib_rank:top(ReadTable, Len),
    SelfRank = lib_rank:rank(ReadTable, PlayerId), %%is an interge
    {SelfRank, RankList}.

%%-----------------------test-----------------------%%
%%插入2000条，时间20ms左右
test() ->
    List = lists:seq(1, 2000),
    T1 = os:timestamp(),
    PidMRefs = [spawn_monitor(fun() -> test2(level_rank_1, Id, {Id, 0, Id}, {list_to_binary("abc"), 1, 999}) end ) || Id <- List],
    [receive
         {'DOWN', MRef, process, _, normal} -> 
             ok;
         {'DOWN', MRef, process, _, Reason} -> 
             exit(Reason)
     end || {_Pid, MRef} <- PidMRefs],
    T2 = os:timestamp(),
    Times = timer:now_diff(T2, T1),
    io:format("~p: ~p microseconds~n", [?MODULE, Times]).

test2(Table, PlayerId, Value, Ext) ->
    mod_rank:insert(Table, PlayerId, Value, Ext).

%%2000个并发，大概是500ms，这个速度可以忍受么
get_test() ->
    List = lists:seq(1, 2000),
    T1 = os:timestamp(),
    PidMRefs = [spawn_monitor(fun() -> get_rank_info(level_rank_1, 10, Id) end )|| Id <- List],
    [receive
         {'DOWN', MRef, process, _, normal} -> 
             ok;
         {'DOWN', MRef, process, _, Reason} -> 
             exit(Reason)
     end || {_Pid, MRef} <- PidMRefs],
    T2 = os:timestamp(),
    Times = timer:now_diff(T2, T1),
    io:format("~p: ~p microseconds~n", [?MODULE, Times]).
