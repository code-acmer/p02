-module(mutil).

-include("common.hrl").

-export([get_table_name/1,
         get_op/1,
         get_fields/1,
         get_where/1,
         get_limit/1,
         get_groupby/1,
         get_orderby/1,
         get_args/1
        ]).

get_table_name(Args) ->
    case lists:keyfind(<<"table">>, 1, Args) of
        false ->
            undefined;
        {_, Tab}->
            hmisc:to_atom(Tab)
    end.

get_op(Args) ->
    case lists:keyfind(<<"op">>, 1, Args) of
        false ->
            undefined;
        {_, Op}->
            hmisc:to_atom(Op)
    end.

get_fields(Args) ->
    case lists:keyfind(<<"fields">>, 1, Args) of
        false ->
            [];
        {_, Tab}->
            hmisc:to_atom(Tab)
    end.

get_where(Args) ->
    case lists:keyfind(<<"where">>, 1, Args) of
        false ->
            undefined;
        {_, BinWhere}->
            %% hmisc:to_atom(Tab)
            case catch rfc4627:decode(BinWhere) of
                {ok, [], []} ->
                    [];
                {ok,{obj,Values},[]} ->
                    lists:foldl(fun(V, Ret) ->
                                        AddWheres =  handle_where(V),
                                        Ret ++ AddWheres
                                end, [], Values);
                R ->
                    ?INFO_MSG("decode where failed Ori : ~p , R :~p~n ", [BinWhere, R]),
                    []
            end
    end.

handle_where({Field, [End, Start]}) when is_number(End) andalso 
                                         is_number(Start) ->
    AtomField = hmisc:to_atom(Field),
    [{AtomField, "<", End}, {AtomField, ">", Start}];
handle_where({Field, Value}) when is_number(Value) ->
    AtomField = hmisc:to_atom(Field),
    [{AtomField, "==", Value}];
handle_where({Field, {obj, Values}}) ->
    AtomField = hmisc:to_atom(Field),
    case Values of
        [{"$regex", StringValue}] ->
            case AtomField of
                accname ->
                    [{AtomField, "==", hmisc:to_list(StringValue)}];
                _ ->
                    [{AtomField, "==", StringValue}]
                end;
        _ ->
            []
    end;
handle_where(_) ->
    [].

get_limit(Args) ->
    case lists:keyfind(<<"limit">>, 1, Args) of
        false ->
            undefined;
        {_, BinLimit}->
            case catch rfc4627:decode(BinLimit) of
                {ok, [], []} ->
                    [];
                {ok, {obj, Values}, []}  ->
                    %% ?DEBUG("Values : ~p~n",[Values]),
                    Start = case lists:keyfind("start", 1, Values) of
                                false ->
                                    0;
                                {_, StartIndex} ->
                                    hmisc:to_integer(StartIndex)
                            end,
                    Cnt   = case lists:keyfind("limit", 1, Values) of
                                false ->
                                    20;
                                {_, Count} ->
                                    hmisc:to_integer(Count)
                            end,
                    {limit, Start, Cnt};
                R ->
                    ?INFO_MSG("decode limit failed Ori : ~p , R :~p~n ", [BinLimit, R]),
                    []
            end
    end.

get_orderby(Args) ->
    case lists:keyfind(<<"orderby">>, 1, Args) of
        false ->
            undefined;
        {_, BinOrderby}->            
            case catch rfc4627:decode(BinOrderby) of
                {ok, [], []} ->
                    [];
                {ok,{obj,Values},[]} ->
                    %% ?DEBUG("Value:~p~n", [Values]),
                    lists:foldl(fun(V, Ret) ->
                                        case V of
                                            {Field, Value} ->
                                                NewValue = case hmisc:to_integer(Value) of
                                                               -1 ->
                                                                   0;
                                                               1  ->
                                                                   1
                                                           end,
                                                Ret ++ [{hmisc:to_atom(Field),  NewValue}];
                                            _ ->
                                                Ret
                                        end
                                end, [], Values);
                R ->    
                    ?INFO_MSG("decode orderby failed Ori : ~p , R :~p stack : ~p ~n ", [BinOrderby, R, erlang:get_stacktrace()]),
                    []
            end
    end.

get_groupby(Args) ->
    case lists:keyfind(<<"groupby">>, 1, Args) of
        false ->
            undefined;
        {_, Tab}->
            hmisc:to_atom(Tab)
    end.  


get_args(Args) ->
    case lists:keyfind(<<"args">>, 1, Args) of
        false ->
            undefined;
        {_, Selected}->
            %% hmisc:to_atom(Tab)
            case catch rfc4627:decode(Selected) of
                {ok, [], []} ->
                    [];
                {ok, {obj, Values},[]} ->
                    ?DEBUG("Decoded : ~p~n", [Values]),
                    Values;
                R ->
                    ?INFO_MSG("decode where failed Ori : ~p , R :~p~n ", [Selected, R]),
                    []
            end
    end.

