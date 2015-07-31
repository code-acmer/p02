-module(record_misc).

-export([record_modified/2]).

record_modified(OldRecord, NewRecord) 
  when is_tuple(OldRecord)
       andalso is_tuple(NewRecord) ->
    Size = tuple_size(OldRecord),
    if
        Size > 0 ->
            record_modified(OldRecord, NewRecord, Size, [], false);
        true ->
            []
    end;
record_modified(_, _) ->
    [].

record_modified(_OldRecord, _NewRecord, 1, _AccList, false) ->
    [];
record_modified(OldRecord, _NewRecord, 1, AccList, true) ->
    list_to_tuple([element(1, OldRecord)|AccList]);
record_modified(OldRecord, NewRecord, Index, AccList, Flag) ->
    Old = element(Index, OldRecord),
    New = element(Index, NewRecord),
    if
        Old =:= New ->
            record_modified(OldRecord, NewRecord, Index - 1, [undefined|AccList], Flag);
        true ->
            record_modified(OldRecord, NewRecord, Index - 1, [New|AccList], true)
    end.
