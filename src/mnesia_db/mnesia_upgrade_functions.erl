-module(mnesia_upgrade_functions).
%% -include("define_mnesia_upgrade_functions.hrl").

%% %% If you are tempted to add include file here, don't. Using record
%% %% defs here leads to pain later.

%% -export([do_transform/2, create/2]).


%% %% It's a bad idea to use records or record_info here, even for the
%% %% destination form. Because in the future, the destination form of
%% %% your current transform may not match the record any more, and it
%% %% would be messy to have to go back and fix old transforms at that
%% %% point.
%% %% 为了使用默认值的方便，所以使用了record来表示升级信息
%% %% 但是底层实现还是保留原来最初蛋疼的那些变量，并不是一件坏事
%% %% GetOldFieldFun,
%% %% GetNewFieldFun,
%% %% GetDefaultValFun
%% %% GetFieldChangeFun,
%% %% GetNewRecordNameFun,
%% do_transform(Table, #mnesia_upgrade_conf{
%%                        get_old_field_fun = GetOldFieldFun,
%%                        get_new_field_fun = GetNewFieldFun,
%%                        get_default_val_fun = GetDefaultValFun,
%%                        get_field_change_fun = GetFieldChangeFun,
%%                        get_new_record_name_fun = GetNewRecordNameFun
%%                       }) ->
%%     do_transform(Table, {GetOldFieldFun,
%%                          GetNewFieldFun,
%%                          GetDefaultValFun,
%%                          GetFieldChangeFun,
%%                          GetNewRecordNameFun});
%% do_transform(Table, {GetOldFieldFun,
%%                      GetNewFieldFun,
%%                      GetDefaultValFun,
%%                      GetFieldChangeFun,
%%                      GetNewRecordNameFun}) ->
%%     transform(Table, fun_for_transform(GetOldFieldFun,
%%                                        GetNewFieldFun,
%%                                        GetFieldChangeFun,
%%                                        GetNewRecordNameFun,
%%                                        GetDefaultValFun), GetNewFieldFun(mnesia:table_info(Table, record_name)), GetNewRecordNameFun(Table)).

%% fun_for_transform(GetOldFieldFun,
%%                   GetNewFieldFun,
%%                   GetFieldChangeFun,
%%                   GetNewRecordNameFun,
%%                   GetDefaultValFun) ->
%%     fun(RecordData) ->
%%             handle_record(RecordData,
%%                           GetOldFieldFun,
%%                           GetNewFieldFun,
%%                           GetFieldChangeFun,
%%                           GetNewRecordNameFun,
%%                           GetDefaultValFun)
%%     end.

%% handle_record(RecordDataList, 
%%               GetOldFieldFun,
%%               GetNewFieldFun,
%%               GetFieldChangeFun,
%%               GetNewRecordNameFun,
%%               GetDefaultValFun
%%              ) when is_list(RecordDataList) ->
%%     lists:map(
%%       fun(Record) ->
%%               handle_record(Record,
%%                             GetOldFieldFun,
%%                             GetNewFieldFun,
%%                             GetFieldChangeFun,
%%                             GetNewRecordNameFun,
%%                             GetDefaultValFun)
%%       end, RecordDataList);
%% handle_record(RecordData, 
%%               GetOldFieldFun,  %% 获取旧的所有字段函数，参数是record_name，涉及多少个就传多少，也就是现在mnesia的结构
%%               GetNewFieldFun,  %% 同上，只是是升级之后的所有字段
%%               GetFieldChangeFun, %% 用于字段名变更之后，原数据保留
%%               GetNewRecordNameFun, %% 用于record名字变更用，这是最后一步的逻辑，所以在此之前上面的接口全部是提供旧的record_name
%%               GetDefaultValFun %% 新加字段的默认值
%%              ) 
%%   when is_tuple(RecordData), 
%%        is_atom(element(1, RecordData)), 
%%        tuple_size(RecordData) >= 2 ->
%%     [RecordName|Vals] = tuple_to_list(RecordData),
%%     FixVals = handle_record(Vals,
%%                             GetOldFieldFun,
%%                             GetNewFieldFun,
%%                             GetFieldChangeFun,
%%                             GetNewRecordNameFun,
%%                             GetDefaultValFun),
%%     ReturnFun = fun(NewVals) ->
%%                         list_to_tuple([GetNewRecordNameFun(RecordName)|NewVals])
%%                 end,
%%     case GetOldFieldFun(RecordName) of 
%%         same ->
%%             %% 优化，field没有变更的时候直接返回
%%             ReturnFun(FixVals);
%%         OldFields ->
%%             FixFieldVal = lists:zip(OldFields, FixVals),            
%%             NewFields = GetNewFieldFun(RecordName),
%%             %% 分离出来，避免嵌套过深，难看。
%%             ChangeOrNewValFun =
%%                 fun(Key) ->
%%                         case GetFieldChangeFun({RecordName, Key}) of
%%                             [] ->
%%                                 GetDefaultValFun({RecordName, Key});
%%                             OldKey ->
%%                                 case lists:keyfind(OldKey, 1, FixFieldVal) of
%%                                     false ->
%%                                         throw(err_can_not_find);
%%                                     {_, V} ->
%%                                         V
%%                                 end
%%                         end
%%                 end,
%%             ValsByPos= lists:map(fun(Key) ->
%%                                          case lists:keyfind(Key, 1, FixFieldVal) of
%%                                              false ->
%%                                                  ChangeOrNewValFun(Key);
%%                                              {_, V} ->
%%                                                  V
%%                                          end
%%                                  end, NewFields),
%%             ReturnFun(ValsByPos)
%%     end;
%% handle_record(Other, _, _, _, _, _) -> 
%%     Other.

%% transform(TableName, Fun, FieldList, NewRecordName) 
%%   when is_atom(TableName)->
%%     transform(mnesia_frag:frag_names(TableName), Fun, FieldList, NewRecordName);
%% transform(TableNameList, Fun, FieldList, NewRecordName) 
%%   when is_list(TableNameList)->
%%     %% 处理了分片的情况
%%     mnesia_table:wait(TableNameList),
%%     [{atomic, ok} = mnesia:transform_table(TableName, Fun, FieldList,
%%                                           NewRecordName) || TableName <- TableNameList],
%%     ok.

%% create(Tab, TabDef) ->
%%     {atomic, ok} = mnesia:create_table(Tab, TabDef),
%%     ok.
