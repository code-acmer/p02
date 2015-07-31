-module(ets_misc).
-export([all_value/1]).

all_value(Table) ->
    ets:safe_fixtable(Table,true),
    FirstKey = ets:first(Table),
    List = get_all_value(FirstKey, Table, []),
    ets:safe_fixtable(Table,false),
    List.
    
get_all_value('$end_of_table', _Table, AccValue) ->
    AccValue;
get_all_value(Key, Table, AccValue) ->
    [Object] = ets:lookup(Table, Key),
    Next = ets:next(Table, Key),
    get_all_value(Next, Table, [Object|AccValue]).
