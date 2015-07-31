%%%-------------------------------------------------------------------
%%% @author Zhangr <zhangr011@gmail.com>
%%% @copyright (C) 2013, Zhangr
%%% @doc
%%%
%%% @end
%%% Created : 24 Oct 2013 by Zhangr <zhangr011@gmail.com>
%%%-------------------------------------------------------------------
-module(hdb).

-include_lib("stdlib/include/qlc.hrl").
-include("define_mquery.hrl").

%% API
%% -export([
%%          read/1,
%%          read/2,
%%          read_list/2,
%%          index_read/3,
%%          write/1,
%%          write/2,
%%          write_list/2,
%%          delete/1,
%%          delete/2,
%%          delete_list/2,
%%          delete_object/1
%%         ]
-export([
         dirty_read/2, dirty_read_list/2,
         dirty_index_read/3,
         
         %% for auto transform
         dirty_read/3, dirty_read_list/3,
         dirty_index_read/4, 


         dirty_write/1,
         dirty_write/2,

         dirty_delete/2,
         dirty_delete_list/2,
         add_table_index/2,
         del_table_index/2,
         del_table/1,
         get_field_index/2,
         count/2,
         select/4
        ]).

-export([transaction/1, async_dirty/1]).
-export([transform/3]).

-export([read/2, read/3, write/2]).

-export([size/1, table_info/2]).

-export([
         dirty_first/1,
         dirty_last/1,
         dirty_prev/2,
         dirty_next/2]).

-export([save/2,
         clear_table/1,
         dirty/2]).

-export([sync_write/1,
         sync_write/2]).

-export([dirty_write_sn/3,
         dirty_read_sn/3,
         dirty_foldl/3,
         table_name/2,
         all_sn_tables/0,
         sn_table/2]).

-export([read_table/1,
         dirty_all_keys/1,
         fix_table/1]).

dirty_write(Record) ->
    %%counting(element(1, Record), dirty_write),
    Fun = fun() ->
                  mnesia:write(Record)
          end,
    mnesia:activity(async_dirty, Fun, [], mnesia_frag).

dirty_write(Table, Record) when is_tuple(Record)->
    %%counting(Table, dirty_write),
    Fun = fun() ->
                  mnesia:write(Table, Record, write)
          end,
    mnesia:activity(async_dirty, Fun, [], mnesia_frag);
dirty_write(Table, RecordList) when is_list(RecordList) ->
    %%counting(Table, dirty_write_list),
    Fun = fun() ->
                  [mnesia:write(Table, Record, write) || Record <- RecordList]
          end,
    mnesia:activity(async_dirty, Fun, [], mnesia_frag).

%%加入一个同步操作的接口
sync_write(Record) ->
    Fun = fun() ->
                  mnesia:write(Record)
          end,
    transaction(Fun).

sync_write(Table, Record) ->
    Fun = fun() ->
                  mnesia:write(Table, Record, write)
          end,
    transaction(Fun).

dirty_read_list(Table, KeyList) ->
    dirty_read_list(Table, KeyList, false).

dirty_read_list(Table, KeyList, TransformFlag) when is_list(KeyList) ->
    %counting(Table, dirty_read_list),
    Fun = fun() ->
                  lists:append([mnesia:read(Table, Key) || Key <- KeyList])
          end,
    Result = mnesia:activity(async_dirty, Fun, [], mnesia_frag),
    maybe_dirty_transform(TransformFlag, Table, Result).
    

dirty_read(Table, Key) ->
    dirty_read(Table, Key, false).

dirty_read(Table, Key, TransformFlag) ->  
    %counting(Table, dirty_read),
    Fun = fun() -> 
                  mnesia:read(Table, Key)
          end,
    Result = mnesia:activity(async_dirty, Fun, [], mnesia_frag),
    reply_read(maybe_dirty_transform(TransformFlag, Table, Result)).

dirty_index_read(Table, Key, KeyPos) ->
    dirty_index_read(Table, Key, KeyPos, false).

dirty_index_read(Table, Key, KeyPos, TransformFlag) ->
    %counting(Table, dirty_index_read),
    Fun = fun() -> 
                  mnesia:index_read(Table, Key, KeyPos)
          end,
    Result = mnesia:activity(async_dirty, Fun, [], mnesia_frag),
    maybe_dirty_transform(TransformFlag, Table, Result).

reply_read([Result]) ->
    Result;
reply_read(Other) ->
    Other.

maybe_dirty_transform(false, _Table, Result) ->
    Result;
maybe_dirty_transform(true, Table, Result) ->
    case table_version:maybe_transform(Result) of
        Result ->
            Result;
        NewResult ->
            dirty_write(Table, NewResult),
            NewResult
    end.


dirty_delete_list(Table, KeyList) 
  when is_list(KeyList) ->
    %counting(Table, dirty_delete_list),
    Fun = fun() ->
                  [mnesia:delete({Table, Key}) || Key <- KeyList]
          end,
    mnesia:activity(async_dirty, Fun, [], mnesia_frag).

dirty_delete(Table, Key) ->
    %counting(Table, dirty_delete),
    Fun = fun() -> 
                  mnesia:delete({Table, Key})
          end,
    mnesia:activity(async_dirty, Fun, [], mnesia_frag).

size(Table) ->
    Fun = fun() -> 
                  mnesia:table_info(Table, size)
          end,
    mnesia:activity(async_dirty, Fun, [], mnesia_frag).

dirty_next(Table, Key) ->
    %counting(Table, dirty_delete),
    Fun = fun() -> 
                  mnesia:next(Table, Key)
          end,
    mnesia:activity(async_dirty, Fun, [], mnesia_frag).

dirty_prev(Table, Key) ->
    %counting(Table, dirty_delete),
    Fun = fun() -> 
                  mnesia:prev(Table, Key)
          end,
    mnesia:activity(async_dirty, Fun, [], mnesia_frag).

dirty_first(Table) ->
    %counting(Table, dirty_delete),
    Fun = fun() -> 
                  mnesia:first(Table)
          end,
    mnesia:activity(async_dirty, Fun, [], mnesia_frag).
dirty_last(Table) ->
    %counting(Table, dirty_delete),
    Fun = fun() -> 
                  mnesia:last(Table)
          end,
    mnesia:activity(async_dirty, Fun, [], mnesia_frag).

transaction(Fun) ->
    mnesia:activity(transaction, Fun, [], mnesia_frag).

table_info(Tab, Item) ->
    async_dirty(fun() ->
                        mnesia:table_info(Tab, Item)
                end).

get_field_index(Table, Field) ->
    Fields = all_record:get_fields(Table),
    get_field_index(Fields, Field, 2).

get_field_index([], _Field, _N) ->
    0;
get_field_index([H|T], Field, N) ->
    case H of
        Field ->
            N;
        _ ->
            get_field_index(T, Field, N+1)
    end.    

async_dirty(Fun) -> 
    mnesia:activity(async_dirty, Fun, [], mnesia_frag).

transform(TableName, FieldList, RecordName) 
  when is_atom(TableName)->
    transform(mnesia_frag:frag_names(TableName), FieldList,  RecordName);
transform(TableNameList, FieldList, RecordName) 
  when is_list(TableNameList)->
    %% 处理了分片的情况
    mnesia_table:wait(TableNameList),
    [{atomic, ok} = mnesia:transform_table(TableName, ignore, FieldList,
                                            RecordName) || TableName <- TableNameList],
    ok.

add_table_index(Table, Index) 
  when is_atom(Table)->
    add_table_index(mnesia_frag:frag_names(Table), Index);
add_table_index(TableList, Index) ->
    [{atomic, ok} = mnesia:add_table_index(Table, Index) || Table <- TableList],
    ok.

del_table(Table) ->
    TabList = mnesia_frag:frag_names(Table),
    lists:foreach(fun(Tab) ->
                          case mnesia:delete_table(Tab) of
                              {atomic, ok} ->
                                  ok;
                              {aborted, Reason} ->
                                  throw({error, {table_del_failed,
                                                 Tab, Reason}})
                          end 
                  end, TabList).
del_table_index(Table, Index) 
  when is_atom(Table)->
    del_table_index(mnesia_frag:frag_names(Table), Index);
del_table_index(TableList, Index) ->
    [{atomic, ok} = mnesia:del_table_index(Table, Index) || Table <- TableList],
    ok.

save(Record, Pos) ->
    %io:format("Record ~p, Pos ~p~n", [Record, Pos]),
    case element(Pos, Record) of
        1 ->
            NewRecord = setelement(Pos, Record, 0),
            dirty_write(NewRecord),
            NewRecord;
        _ ->
            Record
    end.

dirty(Record, Pos) ->
    setelement(Pos, Record, 1).

read(Table, Key) ->
    read(Table, Key, false).

read(Table, Key, TransformFlag) ->
    reply_read(maybe_transform(TransformFlag, Table, mnesia:read(Table, Key))).

maybe_transform(false, _Table, Result) ->
    Result;
maybe_transform(true, Table, Result) ->
    case table_version:maybe_transform(Result) of
        Result ->
            Result;
        NewResult ->
            write(Table, NewResult),
            NewResult
    end.

write(_Table, []) ->
    ok;
write(Table, Record) when is_tuple(Record)->
    mnesia:write(Table, Record, write);
write(Table, RecordList) when is_list(RecordList) ->
    [mnesia:write(Table, Record, write) || Record <- RecordList],
    ok.

clear_table(Table) ->
    [mnesia:clear_table(Tab) || Tab <- mnesia_frag:frag_names(Table)].

%% counting(Table, Op) ->
%%     mod_mnesia_statistics:counting(Table, Op).

dirty_foldl(Fun, Acc0, Table) ->
    async_dirty(fun() ->
                        mnesia:foldl(fun(Record0, Acc) ->                                             
                                             Fun(maybe_transform(true, Table, Record0), Acc)
                                     end, Acc0, Table)
                end).

%%处理多服的表
dirty_write_sn(Table, Record, Sn) ->
    WriteTable = sn_table(Table, Sn),
    dirty_write(WriteTable, Record).

dirty_read_sn(Table, Key, Sn) ->
    WriteTable = sn_table(Table, Sn),
    dirty_read(WriteTable, Key).

%%约好需要区分的表都是 表名_Sn 的形式（sn是写入数据库的编号)
table_name(Table, DbSn) ->
    list_to_atom(lists:concat([Table, "_", DbSn])).  
%%分服表
all_sn_tables() ->
    [mugen_rank, chats_world, async_arena_rank, sync_arena_rank,
     battle_ability_rank, cost_coin_rank, cost_gold_rank, world_boss_rank, league].
%%当前服务器的目标表是哪个
sn_table(Table, Sn) ->
    case lists:member(Table, all_sn_tables()) of
        true ->
            DbSn = server_misc:get_mnesia_sn(Sn),
            table_name(Table, DbSn);
        _ ->
            Table
    end.

%% 读取表中的所有数据
read_table(Table)->
    FirstKey = mnesia:dirty_first(Table),
    read_table1(Table, FirstKey, []).

read_table1(_, '$end_of_table', AccList) ->
    AccList;
read_table1(Table, Key, AccList) ->
    Result = dirty_read(Table, Key),
    NextKey = dirty_next(Table, Key),
    read_table1(Table, NextKey, [Result | AccList]).

dirty_all_keys(Table) ->
    Fun = fun() ->
                  mnesia:all_keys(Table)
          end,
    mnesia:activity(async_dirty, Fun, [], mnesia_frag).

fix_table(Table) ->
    [begin 
         FirstKey = dirty_first(Tab),
         fix_table2(Tab, FirstKey)
     end || Tab <- mnesia_frag:frag_names(Table)],
    ok.

fix_table2(_Tab, '$end_of_table') ->
    skip;
fix_table2(Tab, Key) ->
    Record = dirty_read(Tab, Key),
    maybe_dirty_transform(true, Tab, Record),
    fix_table2(Tab, dirty_next(Tab, Key)).
    

%%%

%% select(Table, Wheres, Orderby, Limit) ->
%%     TableQuery = qlc:q([Item || Item <- mnesia:table(Table)]),
%%     WhereQuery = lists:foldl(fun(Where, RetQuery) ->
%%                                      get_where_query(Table, Where, RetQuery)
%%                              end, TableQuery, Wheres),
%%     OrderByQuery = lists:foldl(fun(Where, RetQuery) ->
%%                                        get_order_query(Table, Where, RetQuery)
%%                                end, WhereQuery, Orderby),
%%     case Limit of
%%         {limit, MaxRow} when MaxRow < ?MAX_ROW_RET ->
%%             query_with_limit(OrderByQuery, 0, MaxRow);
%%         {limit, Start, MaxRow} when MaxRow < ?MAX_ROW_RET ->
%%             query_with_limit(OrderByQuery, Start, MaxRow);
%%         {limit, Start, _MaxRow} ->
%%             query_with_limit(OrderByQuery, Start, ?MAX_ROW_RET);
%%         {limit, _MaxRow} ->
%%             query_with_limit(OrderByQuery, 0, ?MAX_ROW_RET);
%%         _ ->
%%             query_with_limit(OrderByQuery, 0, ?MAX_ROW_RET)
%%     end.

select(Table, Wheres, Orderby, Limit) ->
    TableQueryString = "[Item || Item <- mnesia:table(" ++ hmisc:term_to_string(Table)++")",
    WhereQueryString = lists:foldl(fun(Where, RetQuery) ->
                                           RetQuery ++ get_where_query(Table, Where, RetQuery)
                                   end, TableQueryString, Wheres),
    %% io:format("~p~n",[WhereQueryString]),
    Query = qlc:string_to_handle(WhereQueryString ++ "]."),
    OrderByQuery = lists:foldl(fun(Where, RetQuery) ->
                                       get_order_query(Table, Where, RetQuery)
                               end, Query, Orderby),
    case Limit of
        {limit, MaxRow} when MaxRow < ?MAX_ROW_RET ->
            query_with_limit(OrderByQuery, 0, MaxRow);
        {limit, Start, MaxRow} when MaxRow < ?MAX_ROW_RET ->
            query_with_limit(OrderByQuery, Start, MaxRow);
        {limit, Start, _MaxRow} ->
            query_with_limit(OrderByQuery, Start, ?MAX_ROW_RET);
        {limit, _MaxRow} ->
            query_with_limit(OrderByQuery, 0, ?MAX_ROW_RET);
        _ ->
            query_with_limit(OrderByQuery, 0, ?MAX_ROW_RET)
    end.



count(Table, []) ->
    hdb:size(Table);
%% WHEN COUNT BY WHERE THE MAX CNT LIMIT By MAX_ROW_RET
count(Table, Wheres) ->
    ItemsQuery = qlc:q([Item || Item <- mnesia:table(Table)]),
    WhereQuery = lists:foldl(fun(Where, RetQuery) ->
                                     get_where_query(Table, Where, RetQuery)
                             end, ItemsQuery, Wheres),
    FinalQuery = qlc:q([element(1, Item) || Item <- WhereQuery]),
    Ret = async_dirty(fun() ->
                              QC = qlc:cursor(FinalQuery),
                              RET= qlc:next_answers(QC, ?MAX_ROW_RET),
                              qlc:delete_cursor(QC),
                              RET
                      end),
    %% io:format("Ret : ~p~n",[Ret]),
    length(Ret).

get_where_query(Table, Where, _LastQuery) ->
    case Where of
        {Field, ">", Value} when is_number(Value) ->
            Index = get_field_index(Table, Field),
            ", element("++ hmisc:to_string(Index) ++", Item) > "++ hmisc:to_string(Value);
        {Field, "<", Value} when is_number(Value) ->
            Index = get_field_index(Table, Field),
            ", element(" ++ hmisc:to_string(Index) ++ ", Item) < " ++ hmisc:to_string(Value);
        {Field, ">=", Value} when is_number(Value) ->
            Index = get_field_index(Table, Field),
            ", element(" ++ hmisc:to_string(Index) ++ ", Item) >= " ++ hmisc:to_string(Value);
        {Field, "=<", Value} when is_number(Value) ->
            Index = get_field_index(Table, Field),
            ", element(" ++ hmisc:to_string(Index) ++ ", Item) =< " ++ hmisc:to_string(Value);
        {Field, "==", Value} when is_number(Value) ->
            Index = get_field_index(Table, Field),
            ", element(" ++ hmisc:to_string(Index) ++ ", Item) == " ++ hmisc:to_string(Value);
        {Field, "!=", Value} when is_number(Value) ->
            Index = get_field_index(Table, Field),
            ", element(" ++ hmisc:to_string(Index) ++ ", Item) /= " ++ hmisc:to_string(Value);
        _ ->
            ""
    end.

get_order_query(Table, Order, LastQuery) ->
    case Order of
        {Field, ?ORDER_ASC} ->
            Index = get_field_index(Table, Field),
            qlc:keysort(Index, LastQuery, [{order,ascending}]);
        {Field, ?ORDER_DESC} ->
            Index = get_field_index(Table, Field),
            qlc:keysort(Index, LastQuery, [{order,descending}]);
        _ ->
            LastQuery
    end.

query_with_limit(Query, Start, Limit) ->
    QueryFun = fun() ->
                       QC = qlc:cursor(Query,[{cache_all,ets}]),
                       ResultList =
                           if
                               Start =< 0 ->
                                   qlc:next_answers(QC, Limit);
                               true ->
                                   qlc:next_answers(QC, Start - 1),
                                   qlc:next_answers(QC, Limit)
                           end,
                       qlc:delete_cursor(QC),
                       ResultList
               end,
    mnesia:activity(async_dirty, QueryFun,  mnesia_frag).


