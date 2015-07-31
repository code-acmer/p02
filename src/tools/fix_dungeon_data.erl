-module(fix_dungeon_data).
-export([start/0,
         start/1]).
-include_lib("emysql/include/emysql.hrl").
-include("define_dungeon.hrl").
-include("define_logger.hrl").
-define(ALL_TABLE, [{base_dungeon_create_monster, 10}, {base_dungeon_create_object, 100},
                    {base_dungeon_create_portal, 100}]).

init_db() ->
    application:start(crypto),
    application:start(emysql),
    emysql:add_pool(db001, 1, "mroot", "mroot", "192.168.1.149", 3306, "p02_base", utf8).

start() ->
    init_db(),
    [do_update({Table, Times}) || {Table, Times} <- ?ALL_TABLE],
    emysql:remove_pool(db001),
    ok.

start(TableList) ->
    init_db(),
    [do_update(lists:keyfind(Table, 1, ?ALL_TABLE)) || Table <- TableList],
    emysql:remove_pool(db001),
    ok.

do_update({Table, Times}) ->
    case emysql:execute(db001, "select * from " ++ atom_to_list(Table)) of
        #result_packet{rows = Rows} ->
            RecordList = to_record(Table, Rows),
            UpdateRecords = get_update_data(RecordList),
            FinalRecords = inner_handle(UpdateRecords, Times, RecordList),
            %?QPRINT(FinalRecords),
            update_to_db(Table, FinalRecords);
        Other ->
            ?QPRINT(Other),
            throw(Other)
    end.

update_to_db(Table, Records) ->
    lists:map(fun(Record) ->
                      Range = record_misc:rec_get_value(create_range, Record),
                      NewRange = hmisc:term_to_string(Range),
                      Id = element(2, Record),
                      Sql = "update " ++ atom_to_list(Table) ++ " set create_range=" ++ hmisc:term_to_string(NewRange) ++ " where id=" ++ integer_to_list(Id),
                      %io:format("Sql ~ts~n", [Sql]),
                      emysql:execute(db001, Sql) %%error
              end, Records).

%% inner_handle(UpdateRecords, Times, RecordList) ->
%%     lists:map(fun(Record) ->
%%                       Id = get_value(id, Record),
%%                       MinId = Id * Times,
%%                       MaxId = (Id + 1) * Times,
%%                       lists:foldl(fun(Info, AccRecord) ->
%%                                           Tid = get_value(id, Info),
%%                                           Range = 
%%                                               case get_value(create_range, AccRecord) of
%%                                                   [From, To] ->
%%                                                       [From, To];
%%                                                   _ ->
%%                                                       [0, 0]
%%                                               end,
%%                                           if
%%                                               Tid >= MinId andalso Tid < MaxId ->
%%                                                   NewRange = update_range(Range, Tid),
%%                                                   set_value(create_range, NewRange, AccRecord);
%%                                               true ->
%%                                                   AccRecord
%%                                           end
%%                                   end, Record, RecordList)
%%               end, UpdateRecords).
inner_handle(UpdateRecords, Times, RecordList) ->
    lists:map(fun(Record) ->
                      Id = record_misc:rec_get_value(id, Record),
                      MinId = Id * Times,
                      MaxId = (Id + 1) * Times,
                      NewRange = 
                          lists:foldl(fun(Info, AccRange) ->
                                              Tid = record_misc:rec_get_value(id, Info),
                                              if
                                                  Tid >= MinId andalso Tid < MaxId ->
                                                      [Tid|AccRange];
                                                  true ->
                                                      AccRange
                                              end
                                      end, [], RecordList),
                      record_misc:rec_set_value(create_range, lists:reverse(NewRange), Record)
              end, UpdateRecords).


%% update_range([0, 0], Tid) ->
%%     [Tid, Tid];
%% update_range([Min, Max], Tid) ->
%%     if
%%         Tid > Max ->
%%             [Min, Tid];
%%         Tid < Min ->
%%             [Tid, Max];
%%         true ->
%%             [Min, Max]
%%     end.
to_record(Table, Rows) ->
    lists:map(fun(Info) ->
                      Record = hmisc:to_record(Table, Info),
                      Value = record_misc:rec_get_value(create_range, Record),
                      NewValue = hmisc:bitstring_to_term(Value),
                      record_misc:rec_set_value(create_range, NewValue, Record)
              end, Rows).

get_update_data(RecordList) ->
    lists:filter(fun(Record) ->
                         Count = record_misc:rec_get_value(create_count, Record),
                         Bool = is_integer(Count),
                        if
                            not Bool ->
                                false;
                            Count > 0 ->
                                true;
                            true ->
                                false
                        end
                 end, RecordList).

