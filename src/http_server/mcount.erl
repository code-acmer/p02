-module(mcount).

-include("common.hrl").

-export([excute/1]).

excute(Args) when is_list(Args) ->
    ?DEBUG("Args:~p~n",[Args]),
    Table = mutil:get_table_name(Args),
    Wheres = mutil:get_where(Args),
    ?DEBUG("Table : ~w Where:~w ~n", [Table, Wheres]),
    Size = hdb:count(Table, Wheres),
    {ok, rfc4627:encode(Size)};
excute(Args) ->
    ?DEBUG("Args:~p~n",[Args]),
    %% http_misc:reply_ok(Req, Return)    
    [].
