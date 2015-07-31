-module(table_version).

-export([maybe_transform/1, check_record_version/2]).
-export([recorded/0, matches/2, desired/0, record_desired/0,
         need_upgrades/0]).

-include("common.hrl").
-define(VERSION_FILENAME, "schema_version").


recorded() -> 
    case file:consult(schema_filename()) of
        {ok, [Version]} -> 
            {ok, Version};            
        {error, _} = Err -> 
            Err
    end.

matches(VerA, VerB) ->
    VerA =:= VerB.

data() ->
    [{Tab, lists:keydelete(frag_properties, 1, lists:keydelete([node()], 2, TabDef))} || {Tab, TabDef} <- mnesia_table:definitions2()].

desired() -> 
    Data = data(),
    %% error_logger:warning_msg("TableDef Data ~p~n", [Data]),
    lists:sublist(crypto_misc:md5(Data), 6).

record_desired() -> 
    file_misc:write_term_file(schema_filename(), [desired()]).

need_upgrades() ->
    case recorded() of
        {error, enoent} ->
            {error, starting_from_scratch};
        {ok, CurrentVersion} ->
            {ok, CurrentVersion =:= desired()}
    end.

dir() -> 
    mnesia_misc:dir().

schema_filename() -> 
    filename:join(dir(), ?VERSION_FILENAME).


maybe_transform(RecordOrList) ->
    root_maybe_transform(RecordOrList).

root_maybe_transform(List) 
  when is_list(List)->
    [root_maybe_transform(Record) || Record <- List];
root_maybe_transform(Record) 
  when is_tuple(Record) ->
    do_transform(Record).


do_transform(Record) ->
    RecordName = element(1, Record),
    RecordVersion = element(3, Record),
    VersionMod = list_to_atom(atom_to_list(RecordName) ++ "_version"),
    CurrentVersion = VersionMod:current_version(),
    if
        %% RecordVersion > CurrentVersion ->
        %%     throw({record_version_old, "Please Updata Your Code"});
        RecordVersion < CurrentVersion ->
            CurrentVersionInfo = get_version_info(VersionMod:version(CurrentVersion)),
            RecordVersionInfo = get_version_info(VersionMod:version(RecordVersion)),
            ChangeNames = get_change_name(RecordVersion, CurrentVersion, VersionMod),
            DataList = transform_to_list(Record, tuple_size(Record), []),
            %% ?DEBUG("RecordVersion ~p, CurrentVersion : ~p~n", [RecordVersion,CurrentVersion]),
            %% ?DEBUG("CurrentVersionInfo : ~p~n", [CurrentVersionInfo]),
            %% ?DEBUG("RecordVersionInfo : ~p~n", [RecordVersionInfo]),
            %% ?DEBUG("ChangeNames : ~p~n", [ChangeNames]),
            %% ?DEBUG("DataList : ~p~n", [DataList]),
            %% ValList = ds_misc:rec_to_pl([ Field || {Field, _} <- RecordVersionInfo], DataList),
            ValList = lists:zip([ Field || {Field, _} <- RecordVersionInfo], DataList),
            %% io:format("ValList ~w~n", [ValList]),
            %% io:format("ChangeNames ~w~n", [ChangeNames]),
            GetVal = fun (version, Default) ->
                             Default;
                         (Field, Default) ->
                             case lists:keyfind(Field, 1, ValList) of
                                 false ->
                                     case lists:keyfind(Field, 2, ChangeNames) of
                                         {OldField, _} ->
                                             {_, Val} = lists:keyfind(OldField, 1, ValList),
                                             Val;
                                         false ->
                                             Default
                                     end;
                                 {_, Val} ->
                                     Val
                             end
                     end,
            Fun1 = fun() ->
                           list_to_tuple([RecordName |
                                          [GetVal(Field, Default) || 
                                              {Field, Default} <- CurrentVersionInfo]])
                   end,
            
            NewGetVal = fun(Info) ->
                                {D, NInfo, NValList} = traversal_list(ValList, Info),
                                Fun = fun({Field, Default}) -> 
                                              case lists:keyfind(Field, 1, NValList) of
                                                  false ->
                                                      case lists:keyfind(Field, 2, ChangeNames) of
                                                          {OldField, _} ->
                                                              {_, Val} = lists:keyfind(OldField, 1, NValList),
                                                              Val;
                                                          false ->
                                                              Default
                                                      end;
                                                  {_, Val} ->
                                                      Val
                                              end
                                      end,
                                D2 = 
                                    lists:foldl(fun({Field, Default}, Acc) ->
                                                        [Fun({Field, Default}) | Acc]
                                                end, D, NInfo),
                                lists:reverse(D2)
                        end,
            Fun2 = fun() ->
                           list_to_tuple([RecordName |
                                          NewGetVal(CurrentVersionInfo)])
                   end,
            {_T1, R} = timer:tc(Fun1),
            {_T2, R} = timer:tc(Fun2),
            %% io:format("~nT1: ~p, T2: ~p ~n", [T1, T2]),
            %% io:format("RecordName: ~p~n", [RecordName]),
            R;
        true ->
            Record
    end.

traversal_list(ValList, Info) ->
    traversal_list(ValList, Info, []).

traversal_list([{version, _Val} | T1], [{version, Def} | T2], Acc) ->
    traversal_list(T1, T2, [Def | Acc]);

traversal_list([{Key, Val} | T1], [{Key, _Def} | T2], Acc) ->
    traversal_list(T1, T2, [Val | Acc]);

traversal_list(ValList, Info, Acc) ->
    {Acc, Info, ValList}.

transform_to_list(_Record, 1, Acc) ->
    Acc;
transform_to_list(Record, Index, Acc) ->    
    transform_to_list(Record, Index - 1, [child_maybe_transform(element(Index, Record))|Acc]).

child_maybe_transform(List) 
  when is_list(List) ->
    [child_maybe_transform(Record) || Record <- List];
child_maybe_transform(Record) 
  when is_tuple(Record) 
       andalso tuple_size(Record) >= 3  ->
    RecordName = element(1, Record),
    case check_inner_record_name(RecordName) of
        false ->
            Record;
        true ->
            do_transform(Record)
    end;
child_maybe_transform(Other) ->
    Other.

%% 历史原因，兼容老的
check_inner_record_name(soccer_player_equip) ->
    true;
check_inner_record_name(RecordName) 
  when is_atom(RecordName) ->
    case atom_to_list(RecordName) of
        "mdb_" ++ _ ->
            true;
        _ ->
            false
    end;
check_inner_record_name(_) ->
    false.
%% maybe_transform(List) 
%%   when is_list(List) ->
%%     [maybe_transform(Record) || Record <- List];
%% maybe_transform(Record) 
%%   when is_tuple(Record),
%%        is_atom(element(1, Record)), 
%%        tuple_size(Record) >= 2 ->
%%     RecordName = element(1, Record),
%%     RecordVersion = element(3, Record),
%%     VersionMod = list_to_atom(atom_to_list(RecordName) ++ "_version"),
%%     case catch VersionMod:current_version() of
%%         CurrentVersion when is_integer(CurrentVersion) ->
%%             if         
%%                 RecordVersion > CurrentVersion ->
%%                     throw({record_version_old, RecordName, "Please Updata Your Code"});
%%                 RecordVersion < CurrentVersion ->
%%                     transform(RecordVersion, CurrentVersion, VersionMod,  Record);
%%                 true ->
%%                     Record
%%             end;
%%         Other ->
%%             ?DEBUG("Other ~p~n", [Other]),
%%             Record
%%     end;
%% maybe_transform(Other) ->
%%     Other.

get_version_info(List) 
  when is_list(List) ->
    List;
get_version_info({List, _}) ->
    List.


%% transform(RecordVersion, CurrentVersion, VersionMod, Record) ->
%%     CurrentVersionInfo = get_version_info(VersionMod:version(CurrentVersion)),
%%     RecordVersionInfo = get_version_info(VersionMod:version(RecordVersion)),
%%     ChangeNames = get_change_name(RecordVersion, CurrentVersion, VersionMod),
%%     [RecordName|OldDataList] = tuple_to_list(Record),
%%     DataList = maybe_transform(OldDataList),
%%     ValList = lists:zip([ Field || {Field, _} <- RecordVersionInfo], DataList),
%%     %% io:format("ValList ~w~n", [ValList]),
%%     %% io:format("ChangeNames ~w~n", [ChangeNames]),

%%     GetVal = fun
%%                  (version, Default) ->
%%                      Default;
%%                  (Field, Default) ->
%%                      case lists:keyfind(Field, 1, ValList) of
%%                          false ->
%%                              case lists:keyfind(Field, 2, ChangeNames) of
%%                                  {OldField, _} ->
%%                                      {_, Val} = lists:keyfind(OldField, 1, ValList),
%%                                      Val;
%%                                  false ->
%%                                      Default
%%                              end;
%%                          {_, Val} ->
%%                              Val
%%                      end
%%              end,
%%     list_to_tuple([RecordName |
%%                    [GetVal(Field, Default) || 
%%                        {Field, Default} <- CurrentVersionInfo]]).


get_change_name(RecordVersion, CurrentVersion, VersionMod) ->
    lists:foldl(fun(Version, AccChangeNameFields) ->
                        case VersionMod:version(Version) of
                            {_, []} ->
                                AccChangeNameFields;
                            {_, ChangeNameFields} ->
                                concat_change_name_field(AccChangeNameFields, ChangeNameFields);
                            _ ->
                                AccChangeNameFields
                        end
                end, [], lists:seq(RecordVersion+1, CurrentVersion)).
    
concat_change_name_field(List, ItemList) 
  when is_list(ItemList) ->
    lists:foldl(fun(Item, Acc) ->
                        concat_change_name_field(Acc, Item)
                end, List, ItemList);
concat_change_name_field(List, Item) ->
    concat_change_name_field(List, Item, []).

concat_change_name_field([], Item, Acc) ->
    [Item|Acc];
concat_change_name_field([{From, To}|List], {To, To2}, Acc) ->
    [{From, To2}|List] ++ Acc;
concat_change_name_field([H|List], Item, Acc) ->
    concat_change_name_field(List, Item, [H|Acc]).


not_version(counter, _) ->
    true;
not_version(_, TabDef) ->
    case proplists:get_value(record_name, TabDef) of
        rank ->    %%分服的rank榜都没有version
            true;
        _ ->
            HasDiscCopies = mnesia_table:has_copy_type(TabDef, disc_copies),
            HasDiscOnlyCopies = mnesia_table:has_copy_type(TabDef, disc_only_copies),
            HasDiscCopies =:= false andalso 
                HasDiscOnlyCopies =:= false
    end.

check_record_version(Tab, TabDef) ->
    case not_version(Tab, TabDef) of
        true ->
            ok;
        false ->
            {_, ExpAttrs} = proplists:lookup(attributes, TabDef),
            RecordName = proplists:get_value(record_name, TabDef, Tab),
            VersionMod = list_to_atom(atom_to_list(RecordName) ++ "_version"),
            CurrentVersion = VersionMod:current_version(),
            VersionInfo = get_version_info(VersionMod:version(CurrentVersion)),
            case lists:unzip(VersionInfo) of
                {ExpAttrs, _} ->                    
                    case proplists:get_value(version, VersionInfo)  of
                        CurrentVersion ->
                            ok;
                        OtherVersion ->
                            {error, {current_version_error, CurrentVersion, OtherVersion}}
                    end;
                {OtherAttrs, _} ->
                    {error, {current_attrs_error, ExpAttrs, OtherAttrs}}
            end
    end.
