-module(mquery).

-include("common.hrl").

-export([excute/1]).

excute(Args) when is_list(Args) ->
    ?DEBUG("Args:~p~n",[Args]),
    %% Op    = mutil:get_op(Args),
    Table = mutil:get_table_name(Args),
    Wheres = mutil:get_where(Args),
    Orderby  = mutil:get_orderby(Args),
    Limit    = mutil:get_limit(Args),
     ?DEBUG("Table : ~p, Wheres:~p, Orderby:~p, Limit : ~p ~n", [Table,Wheres,Orderby, Limit]),
    RET = hdb:select(Table, Wheres, Orderby, Limit),
    %% ?DEBUG("Select RET : ~p~n",[RET]),
    Fields = hdb:get_table_fields(Table),
    JsonList= lists:map(fun(Item) ->
                                %% TableName = element(1, Item),
                                NewFields = lists:sublist(Fields, tuple_size(Item) - 1),
                                {obj, lists:zip(NewFields, http_user:transform(lists:nthtail(1,tuple_to_list(Item))))}
                        end, RET),
    {ok, rfc4627:encode(JsonList)};
excute(Args) ->
    ?DEBUG("Args:~p~n",[Args]),
    %% http_misc:reply_ok(Req, Return)    
    [].


