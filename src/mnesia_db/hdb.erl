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
-include("define_logger.hrl").

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
         select/4,
         tab2list/1,
         try_upgrade_record/1,
         get_table_fields/1
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

-export([%% dirty_write_sn/3,
         %% dirty_read_sn/3,
         dirty_foldl/3,
         table_name/2,
         all_sn_tables/0,
         key_table/0,
         sn_table/2]).

-export([read_table/1,
         dirty_all_keys/1%% ,
         %% fix_table/1
        ]).

-export([r/2, r/1, w/1, i/1]).

%% 动态解析全服表名 得到原子 Table
r(Table, Key) ->
    %% io:format("Table: ~p, Key: ~p ~n", [Table, Key]),
    server_misc:get_table_by_key(Table, Key).

%% 动态解析本地表名 得到单服表名列表[Table1, Table2 ... ]
r(Table) ->
    server_misc:get_local_table(Table).

%% 动态解析全服表名 得到原子 Table
w(Record) 
  when is_tuple(Record) ->
    Table = element(1, Record),
    server_misc:get_table_by_record(Table, Record).

%% 动态解析全服表名 得到全服表名列表[Table1, Table2 ... ]
i(Table) ->
    server_misc:index_all_sn_tables(Table).

dirty_write(Record) ->
    %%counting(element(1, Record), dirty_write),
    %% Fun = fun() ->
    %%               mnesia:write(Record)
    %%       end,
    %% mnesia:activity(async_dirty, Fun, [], mnesia_frag).
    Table = element(1, Record),
    dirty_write(Table, Record).

dirty_write(_Table, Record) when is_tuple(Record)->
    %%counting(Table, dirty_write),
    ?DEBUG("Table: ~p", [w(Record)]),
    Fun = fun() ->
                  mnesia:write(w(Record), Record, write)
          end,
    mnesia:activity(async_dirty, Fun, [], mnesia_frag);
dirty_write(_Table, RecordList) when is_list(RecordList) ->
    %%counting(Table, dirty_write_list),
    Fun = fun() ->
                  [mnesia:write(w(Record), Record, write) || Record <- RecordList]
          end,
    mnesia:activity(async_dirty, Fun, [], mnesia_frag).

%%加入一个同步操作的接口
sync_write(Record) ->
    %% Fun = fun() ->
    %%               mnesia:write(Record)
    %%       end,
    %% transaction(Fun).
    Table = element(1, Record),
    sync_write(Table, Record).        

sync_write(_Table, Record) ->
    Fun = fun() ->
                  mnesia:write(w(Record), Record, write)
          end,
    transaction(Fun).

dirty_read_list(Table, KeyList) ->
%% 这里需要改
    case is_version_table(Table) of
        true ->
            dirty_read_list(Table, KeyList, true);
        _ ->
            dirty_read_list(Table, KeyList, false)
    end.

dirty_read_list(Table, KeyList, TransformFlag) when is_list(KeyList) ->
    %counting(Table, dirty_read_list),
    Fun = fun() ->
                  %lists:append([mnesia:read(Table, Key) || Key <- KeyList])
                  lists:map(fun(Key) ->
                                    mnesia:read(r(Table, Key), Key)
                            end, KeyList)
          end,
    Result = mnesia:activity(async_dirty, Fun, [], mnesia_frag),
    maybe_dirty_transform(TransformFlag, Table, Result).
    

dirty_read(Table, Key) ->
    case is_version_table(Table) of
        true ->
            dirty_read(Table, Key, true);
        _ -> 
            dirty_read(Table, Key, false)
    end.

is_version_table(Table) ->
    Index = get_field_index(Table, version),
    if
        Index > 0 ->
            true;
        true -> 
            false
    end.

get_table_fields(Table) ->
    mnesia:table_info(Table, attributes).

dirty_read(Table, Key, TransformFlag) ->  
    %counting(Table, dirty_read),
    Fun = fun() -> 
                  mnesia:read(r(Table, Key), Key)
          end,
    Result = mnesia:activity(async_dirty, Fun, [], mnesia_frag),
    reply_read(maybe_dirty_transform(TransformFlag, Table, Result)).

dirty_index_read(Table, Key, KeyPos) ->
    dirty_index_read(Table, Key, KeyPos, false).

%% 单服查询接口, 适用于公共数据查询, 不适用查询全服玩家私有数据
dirty_index_read(Table, Key, KeyPos, TransformFlag) ->
    lists:foldl(fun(T, Acc) ->
                        index_read(Table, T, Key, KeyPos, TransformFlag) ++ Acc
                end, [], r(Table)).

index_read(Table, T, Key, KeyPos, TransformFlag) ->
    %counting(Table, dirty_index_read),
    Fun = fun() -> 
                  mnesia:index_read(T, Key, KeyPos)
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

%% 升级record 但不写入mnesia
try_upgrade_record(Records) when is_list(Records) ->
    lists:map(fun(Record) ->
                      try_upgrade_record(Record)
              end, Records);
try_upgrade_record(Record) ->
    case table_version:maybe_transform(Record) of
        Record ->
            Record;
        NewRecord ->
            NewRecord
    end.

%% 适用于全服数据删除
dirty_delete_list(Table, KeyList) 
  when is_list(KeyList) ->
    %counting(Table, dirty_delete_list),
    Fun = fun() ->
                  %% NewTable = r(Table, H),
                  [mnesia:delete({r(Table, Key), Key}) || Key <- KeyList]
          end,
    mnesia:activity(async_dirty, Fun, [], mnesia_frag).

dirty_delete(Table, Key) ->
    %counting(Table, dirty_delete),
    Fun = fun() -> 
                  mnesia:delete({r(Table, Key), Key})
          end,
    mnesia:activity(async_dirty, Fun, [], mnesia_frag).

%% 单服计算接口, 适用于公共数据计算, 不适用计算全服玩家私有数据
size(Table) ->
    lists:foldl(fun(T, Acc) ->
                        size1(T) + Acc
                end, 0, r(Table)).

size1(Table) ->
    Fun = fun() -> 
                  mnesia:table_info(Table, size)
          end,
    mnesia:activity(async_dirty, Fun, [], mnesia_frag).

%% 不适用key值非整数的表查寻
%% 单服查询接口, 适用于公共数据查询, 不适用查询全服玩家私有数据
dirty_next(Table, Key) ->
    %counting(Table, dirty_delete),
    Fun = fun() -> 
                  mnesia:next(r(Table, Key), Key)
          end,
    mnesia:activity(async_dirty, Fun, [], mnesia_frag).

%% 不适用key值非整数的表查寻
%% 单服查询接口, 适用于公共数据查询, 不适用查询全服玩家私有数据
dirty_prev(Table, Key) ->
    %counting(Table, dirty_delete),
    Fun = fun() -> 
                  mnesia:prev(r(Table, Key), Key)
          end,
    mnesia:activity(async_dirty, Fun, [], mnesia_frag).

%% 不适用key值非整数的表查寻
%% 单服查询接口, 适用于公共数据查询, 不适用查询全服玩家私有数据
dirty_first(Table) ->
    %counting(Table, dirty_delete),
    [NewTable] = r(Table),
    Fun = fun() -> 
                  mnesia:first(NewTable)
          end,
    mnesia:activity(async_dirty, Fun, [], mnesia_frag).

%% 不适用key值非整数的表查寻
%% 单服查询接口, 适用于公共数据查询, 不适用查询全服玩家私有数据
dirty_last(Table) ->
    %counting(Table, dirty_delete),
    [NewTable] = r(Table),
    Fun = fun() -> 
                  mnesia:last(NewTable)
          end,
    mnesia:activity(async_dirty, Fun, [], mnesia_frag).

transaction(Fun) ->
    mnesia:activity(transaction, Fun, [], mnesia_frag).

table_info(Tab, Item) ->
    async_dirty(fun() ->
                        mnesia:table_info(Tab, Item)
                end).

get_field_index(Table, Field) ->
    Fields = get_table_fields(Table),
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
%% --------------------------------------------------------------------------------
%% 该接口有问题,废弃不可用 历史遗留
read(Table, Key) ->
    read(Table, Key, false).

read(Table, Key, TransformFlag) ->
    reply_read(maybe_transform(TransformFlag, Table, mnesia:read(r(Table, Key), Key))).

write(_Table, []) ->
    ok;
write(_Table, Record) when is_tuple(Record)->
    mnesia:write(w(Record), Record, write);
write(_Table, [Key | _] = RecordList) when is_list(RecordList) ->
    NewTable = w(Key),
    [mnesia:write(NewTable, Record, write) || Record <- RecordList],
    ok.
%% ---------------------------------------------------------------------------------
%% 单服查询接口, 适用于公共数据查询, 不适用查询全服玩家私有数据
clear_table(Table) ->
    lists:map(fun(T) ->
                      [mnesia:clear_table(Tab) || Tab <- mnesia_frag:frag_names(T)]
              end, r(Table)),
    ok.
    

%% counting(Table, Op) ->
%%     mod_mnesia_statistics:counting(Table, Op).

%% 单服查询接口, 适用于公共数据查询, 不适用查询全服玩家私有数据
dirty_foldl(Fun, Acc0, Table) ->
    lists:foldl(fun(T, Acc) ->
                        dirty_foldl(Fun, Acc0, Table, T) ++ Acc
                end, [], r(Table)).    

dirty_foldl(Fun, Acc0, Table, NewTable) ->
    async_dirty(fun() ->
                        mnesia:foldl(fun(Record0, Acc) ->                                             
                                             Fun(maybe_transform(true, Table, Record0), Acc)
                                     end, Acc0, NewTable)
                end).

%% %%处理多服的表
%% dirty_write_sn(Table, Record, Sn) ->
%%     WriteTable = sn_table(Table, Sn),
%%     dirty_write(WriteTable, Record).

%% dirty_read_sn(Table, Key, Sn) ->
%%     WriteTable = sn_table(Table, Sn),
%%     dirty_read(WriteTable, Key).

%%约好需要区分的表都是 表名_Sn 的形式（sn是写入数据库的编号)
table_name(Table, DbSn) ->
    list_to_atom(lists:concat([Table, "_", DbSn])).  

%%全服表, 这些都是单个表数据
all_sn_tables() ->
    [mugen_rank, chats_world, async_arena_rank, sync_arena_rank,
     battle_ability_rank, cost_coin_rank, cost_gold_rank, world_boss_rank, 
     league, server_config].

%% key非整数表全放这里, 这些有5个表, 线上如果需要添加, 则需要先做数据迁移 
key_table() ->
    [master_apprentice].

%%当前服务器的目标表是哪个
sn_table(Table, Sn) ->
    case lists:member(Table, all_sn_tables()) of
        true ->
            DbSn = server_misc:get_mnesia_sn(Sn),
            table_name(Table, DbSn);
        _ ->
            Table
    end.

%% 单服查询接口, 适用于公共数据查询, 不适用查询全服玩家私有数据
read_table(Table)->
    lists:foldl(fun(T, Acc) ->
                        FirstKey = mnesia:dirty_first(T),
                        read_table1(Table, FirstKey, []) ++ Acc
                end, [], r(Table)).    

read_table1(_, '$end_of_table', AccList) ->
    AccList;
read_table1(Table, Key, AccList) ->
    Result = dirty_read(Table, Key),
    NextKey = dirty_next(Table, Key),
    read_table1(Table, NextKey, [Result | AccList]).

%% 单服接口 适用于公共数据查询, 不适用查询全服玩家私有数据
dirty_all_keys(Table) ->
    lists:foldl(fun(T, Acc) ->
                        all_keys(T) ++ Acc
                end, [], r(Table)).

all_keys(Table) ->
    Fun = fun() ->
                  mnesia:all_keys(Table)
          end,
    mnesia:activity(async_dirty, Fun, [], mnesia_frag).

%% fix_table(Table) ->
%%     [begin 
%%          FirstKey = dirty_first(Tab),
%%          fix_table2(Tab, FirstKey)
%%      end || Tab <- mnesia_frag:frag_names(Table)],
%%     ok.

%% fix_table2(_Tab, '$end_of_table') ->
%%     skip;
%% fix_table2(Tab, Key) ->
%%     Record = dirty_read(Tab, Key),
%%     maybe_dirty_transform(true, Tab, Record),
%%     fix_table2(Tab, dirty_next(Tab, Key)).
    

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
        {limit, MaxRow} ->
            query_with_limit(OrderByQuery, 0, MaxRow);
        {limit, Start, MaxRow} ->
            query_with_limit(OrderByQuery, Start, MaxRow);
        _ ->
            query_with_limit(OrderByQuery, 0, ?MAX_ROW_RET)
    end.



count(Table, []) ->
    hdb:size(Table);
%% WHEN COUNT BY WHERE THE MAX CNT LIMIT By MAX_ROW_RET

%% 单服接口 适用于公共数据查询, 不适用查询全服玩家私有数据
count(Table, Wheres) when is_list(Wheres) ->
    lists:foldl(fun(T, Acc) ->
                        Acc + count1(T, Wheres)
                end, 0, r(Table));    

count(Table, _) ->
    hdb:size(Table).

count1(Table, Wheres) when is_list(Wheres) ->
    TableQueryString = "[element(1,Item) || Item <- mnesia:table(" ++ hmisc:term_to_string(Table)++")",
    WhereQueryString = lists:foldl(fun(Where, RetQuery) ->
                                           RetQuery ++ get_where_query(Table, Where, RetQuery)
                                   end, TableQueryString, Wheres),
    Query = qlc:string_to_handle(WhereQueryString ++ "]."),
    CountFun = fun() ->
                        %% QC = qlc:cursor(Query),
                        %% RET= qlc:next_answers(QC),
                        %% qlc:delete_cursor(QC),
                        %% RET
                       qlc:e(Query)
                end,
    Ret = mnesia:activity(async_dirty, CountFun,  mnesia_frag),
    %% io:format("Ret : ~p~n",[Ret]),
    length(Ret).

get_where_query(Table, Where, _LastQuery) ->
    case Where of
        {Field, ">", Value} when is_number(Value) ->
            case get_field_index(Table, Field) of
                Index when Index > 0 ->
                    ", element("++ hmisc:to_string(Index) ++", Item) > "++ hmisc:to_string(Value);
                _ ->
                    ""  
            end;
        {Field, "<", Value} when is_number(Value) ->
            case get_field_index(Table, Field) of
                Index when Index > 0 ->
                    ", element(" ++ hmisc:to_string(Index) ++ ", Item) < " ++ hmisc:to_string(Value);
                _ ->
                    ""  
            end;
        {Field, ">=", Value} when is_number(Value) ->
            case get_field_index(Table, Field) of
                Index when Index > 0 ->
                    ", element(" ++ hmisc:to_string(Index) ++ ", Item) >= " ++ hmisc:to_string(Value);
                _ ->
                    ""  
            end;
        {Field, "=<", Value} when is_number(Value) ->
            case get_field_index(Table, Field) of
                Index when Index > 0 ->
                    ", element(" ++ hmisc:to_string(Index) ++ ", Item) =< " ++ hmisc:to_string(Value);
                _ ->
                    ""  
            end;
        {Field, "==", Value} when is_number(Value) ->
            case get_field_index(Table, Field) of
                Index when Index > 0 ->
                    ", element(" ++ hmisc:to_string(Index) ++ ", Item) == " ++ hmisc:to_string(Value)++"";
                _ ->
                    ""  
            end;
        {Field, "==", Value} when is_binary(Value) ->
            case get_field_index(Table, Field) of
                Index when Index > 0 ->
                    ", element(" ++ hmisc:to_string(Index) ++ ", Item) == " ++ hmisc:term_to_string(Value);
                _ ->
                    ""  
            end;
        {Field, "==", Value} when is_list(Value) ->
            case get_field_index(Table, Field) of
                Index when Index > 0 ->
                    ", element(" ++ hmisc:to_string(Index) ++ ", Item) == \"" ++ Value++"\"";
                _ ->
                    ""  
            end;
        {Field, "!=", Value} when is_number(Value) ->
            case get_field_index(Table, Field) of
                Index when Index > 0 ->
                    ", element(" ++ hmisc:to_string(Index) ++ ", Item) /= " ++ hmisc:to_string(Value);
                _ ->
                    ""  
            end;
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
                       QC = qlc:cursor(Query),
                       ResultList =
                           if
                               Start =< 0 ->
                                   qlc:next_answers(QC, Limit);
                               true ->
                                   qlc:next_answers(QC, Start),
                                   qlc:next_answers(QC, Limit)
                           end,
                       qlc:delete_cursor(QC),
                       ResultList
               end,
    mnesia:activity(async_dirty, QueryFun,  mnesia_frag).

%% 单服接口 适用于公共数据查询, 不适用查询全服玩家私有数据
tab2list(Table) ->
    lists:foldl(fun(T, Acc) ->
                        tab2list1(T) ++ Acc
                end, [], r(Table)).

tab2list1(Table) ->
    select(Table, [], [], []).
