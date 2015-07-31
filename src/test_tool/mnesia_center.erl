-module(mnesia_center).

-export([
         init_mnesia/0,
         link_nodes/0,
         test_mnesia_write/1,
         test_mnesia_read/0,
         disc_only_write/1,
         disc_write/1,
         ram_write/1,
         disc_only_read/0,
         disc_read/0,
         ram_read/0,
         test_1000W_write/0,
         dirty_read/2,
         dirty_read_list/2,
         disc_read_list/0,
         rpc_read/0,
         init_mnesia4/0,
         init_mnesia8/0,
         split_n_frag/3
        ]).

-record(test_disc_only, {
          key,
          value
         }).

-record(test_disc, {
          key,
          value
         }).

-record(test_ram,{
          key,
          value
         }).

rand(Min, Max) 
  when Min =< Max->
    %% 如果没有种子，将从核心服务器中去获取一个种子，以保证不同进程都可取得不同的种子
    RandSeed = case get(hmisc_rand_seed) of
                   undefined ->
                       random:seed(now()),
                       {random:uniform(99999), random:uniform(999999), random:uniform(999999)};
                   TmpRandSeed ->
                       TmpRandSeed
               end,
    {F, NewRandSeed} =  random:uniform_s(Max - (Min - 1), RandSeed),
    put(hmisc_rand_seed, NewRandSeed),
    F + (Min - 1).

init_mnesia() ->
    mnesia:start(),
    lists:map(fun({Tab, TabDef}) ->
                      case mnesia:create_table(Tab, TabDef) of
                          {atomic, ok} -> 
                              ok;
                          {aborted, Reason} ->
                              throw({error, {table_creation_failed,
                                             Tab, TabDef, Reason}})
                      end
              end, table_def()),
    ok.

init_mnesia4() ->
    mnesia:start(),
    lists:map(fun({Tab, TabDef}) ->
                      case mnesia:create_table(Tab, TabDef) of
                          {atomic, ok} -> 
                              ok;
                          {aborted, Reason} ->
                              throw({error, {table_creation_failed,
                                             Tab, TabDef, Reason}})
                      end
              end, table_def4()),
    ok.

init_mnesia8() ->
    mnesia:start(),
    lists:map(fun({Tab, TabDef}) ->
                      case mnesia:create_table(Tab, TabDef) of
                          {atomic, ok} -> 
                              ok;
                          {aborted, Reason} ->
                              throw({error, {table_creation_failed,
                                             Tab, TabDef, Reason}})
                      end
              end, table_def8()),
    ok.

link_nodes() ->
    mnesia:start(),
    net_adm:ping('test_mnesia_node_173@192.168.1.173'),
    mnesia:change_config(extra_db_nodes, [node()|nodes()]),
    ok.
    

split_n_frag(Table, DiscType, N_FRAGMENTS) ->
    lists:map(fun(Node) ->
                           mnesia:change_table_copy_type(schema, Node, disc_copies)
              end, nodes()),
    LocalNode = node(),
    ANodes = [node()|nodes()],
    lists:foldl(fun(N, Nodes) ->
                        FragTableName = case N of
                                            1 ->
                                                Table;
                                            _ ->
                                                list_to_atom(atom_to_list(Table) ++ "_frag" ++ integer_to_list(N))
                                        end,
                        {NextNode,RestNodes} = case Nodes of
                                                   [] ->
                                                       [Node | Rest] = ANodes,
                                                       {Node, Rest};
                                                   [Node|Rest] ->
                                                       {Node, Rest}
                                               end,

                        case NextNode of
                            LocalNode ->
                                case mnesia:table_info(FragTableName, storage_type) of
                                    unknown ->
                                        {atomic,ok} = mnesia:add_table_copy(FragTableName, NextNode, DiscType);
                                    DiscType ->
                                        ignore;
                                    _ ->
                                        {atomic,ok} = mnesia:change_table_copy_type(FragTableName, NextNode, DiscType)
                                end;
                            NextNode ->
                                case rpc:call(NextNode, mnesia, table_info, [FragTableName, storage_type]) of
                                    unknown ->
                                        {atomic,ok} = mnesia:add_table_copy(FragTableName, NextNode, DiscType);
                                    DiscType ->
                                        ignore;
                                    {badrpc, _} = BAD ->
                                        BAD;
                                    _  ->
                                        {atomic,ok} = mnesia:change_table_copy_type(FragTableName, NextNode, DiscType)
                                end                                
                        end,
                        del_other_copies(NextNode, ANodes, FragTableName),
                        RestNodes
                end, [], lists:seq(1, N_FRAGMENTS)),
    ok.

del_other_copies(Node, ANodes, Table) ->
    lists:map(fun(N) ->
                      case N of
                          Node ->
                              ignore;
                          _ ->
                              mnesia:del_table_copy(Table, N)
                      end
              end, ANodes).

    


dirty_read(Table, Key) ->
    dirty_read(Table, Key, false).

dirty_read(Table, Key, _TransformFlag) ->  
                                                %counting(Table, dirty_read),
    Fun = fun() -> 
                  mnesia:read(Table, Key)
          end,
    Result = mnesia:activity(async_dirty, Fun, [], mnesia_frag),
    reply_read(Result).

dirty_read_list(Table, KeyList) ->
    dirty_read_list(Table, KeyList, false).

dirty_read_list(Table, KeyList, _TransformFlag) when is_list(KeyList) ->
    %counting(Table, dirty_read_list),
    Fun = fun() ->
                  lists:append([mnesia:read(Table, Key) || Key <- KeyList])
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



reply_read([Result]) ->
    Result;
reply_read(Other) ->
    Other.

table_def() ->
    [
     {test_disc_only,
      [
       {attributes, record_info(fields, test_disc_only)},
       %% {index, [#test_disc_only.key]},
       {disc_only_copies,[node()]}
      ]},
     %% 物品表
     {test_disc,
      [
       {attributes, record_info(fields, test_disc)},
       %% {index, [#test_disc.key]},
       {disc_copies,[node()]}
      ]
     },
     {test_ram,
      [
       {attributes, record_info(fields, test_ram)},
       %% {index, [#test_ram.key]},
       {ram_copies,[node()]}
      ]}     
    ].

table_def4() ->
    [
     {test_disc_only,
      [
       {attributes, record_info(fields, test_disc_only)},
       %% {index, [#test_disc_only.key]},
       {frag_properties, [{n_fragments, 4}, {n_disc_only_copies, 1}]},
       {disc_only_copies,[node()]}
      ]},
     %% 物品表
     {test_disc,
      [
       {attributes, record_info(fields, test_disc)},
       %% {index, [#test_disc.key]},
       {frag_properties, [{n_fragments, 4}, {n_disc_copies, 1}]},
       {disc_copies,[node()]}
      ]
     },
     {test_ram,
      [
       {attributes, record_info(fields, test_ram)},
       {frag_properties, [{n_fragments, 4}, {n_ram_copies, 1}]},
       %% {index, [#test_ram.key]},
       {ram_copies,[node()]}
      ]}     
    ].

table_def8() ->
    [
     {test_disc_only,
      [
       {attributes, record_info(fields, test_disc_only)},
       %% {index, [#test_disc_only.key]},
       {frag_properties, [{n_fragments, 8}, {n_disc_only_copies, 1}]},
       {disc_only_copies,[node()]}
      ]},
     %% 物品表
     {test_disc,
      [
       {attributes, record_info(fields, test_disc)},
       %% {index, [#test_disc.key]},
       {frag_properties, [{n_fragments, 8}, {n_disc_copies, 1}]},
       {disc_copies,[node()]}
      ]
     },
     {test_ram,
      [
       {attributes, record_info(fields, test_ram)},
       {frag_properties, [{n_fragments, 8}, {n_ram_copies, 1}]},
       %% {index, [#test_ram.key]},
       {ram_copies,[node()]}
      ]}     
    ].

test_1000W_write() ->
    lists:foreach(fun(I) ->
                          test_mnesia_write(I)
                  end, lists:seq(1, 10)).

test_mnesia_write(N) ->
    disc_only_write(N),
    disc_write(N),
    ram_write(N),
    ok.

disc_only_write(N) ->
    StartKey = N * (1000000),
    Before = os:timestamp(),    
    Pids = lists:map(fun(I) ->
                             erlang:spawn_monitor(fun() ->
                                                          InnerStart = StartKey + I * 1000,
                                                          Data1W = lists:map(fun(Key) ->
                                                                                     #test_disc_only{key = Key,
                                                                                                     value = lists:seq(1, rand(2, 1000))
                                                                                                    }
                                                                             end, lists:seq(InnerStart + 1, InnerStart + 1000)),
                                                          BeforeInner = os:timestamp(),
                                                          dirty_write(test_disc_only, Data1W),
                                                          AfterInner = os:timestamp(),
                                                          TimesInner = timer:now_diff(AfterInner, BeforeInner),
                                                          io:format("test_disc_only_write_1W: ~p ms~n", [TimesInner])
                                                  end)
                     end, lists:seq(0,99)),
    [receive
         {'DOWN', MRef, process, _, normal} -> 
             ok;
         {'DOWN', MRef, process, _, Reason} -> 
             exit(Reason)
     end || {_Pid, MRef} <- Pids],

    After = os:timestamp(),
    Times = timer:now_diff(After, Before),
    io:format("test_disc_only_write_100W: ~p ms~n", [Times]).

disc_write(N) ->
    StartKey = N * (1000000),
    Before2 = os:timestamp(),    
    Pids = lists:map(fun(I) ->
                             erlang:spawn_monitor(fun() ->
                                                          InnerStart = StartKey + I * 1000,
                                                          Data1W = lists:map(fun(Key) ->
                                                                                     #test_disc{key = Key,
                                                                                                value = lists:seq(1, rand(2, 1000))
                                                                                               }
                                                                             end, lists:seq(InnerStart + 1, InnerStart + 1000)),
                                                          BeforeInner = os:timestamp(),
                                                          dirty_write(test_disc, Data1W),
                                                          AfterInner = os:timestamp(),
                                                          TimesInner = timer:now_diff(AfterInner, BeforeInner),
                                                          io:format("test_disc_write_1W: ~p ms~n", [TimesInner])
                                                  end)
                     end, lists:seq(0,99)),
    [receive
         {'DOWN', MRef, process, _, normal} -> 
             ok;
         {'DOWN', MRef, process, _, Reason} -> 
             exit(Reason)
     end || {_Pid, MRef} <- Pids],
    After2 = os:timestamp(),
    Times2 = timer:now_diff(After2, Before2),
    io:format("test_disc_write_100W: ~p ms~n", [Times2]).

ram_write(N) ->
    StartKey = N * (1000000),
    Before3 = os:timestamp(),    
    lists:foreach(fun(I) ->
                          InnerStart = StartKey + I * 10000,
                          Data1W = lists:map(fun(Key) ->
                                                     #test_ram{key = Key,
                                                               value = lists:seq(1, rand(2, 1000))
                                                              }
                                             end, lists:seq(InnerStart + 1, InnerStart + 10000)),
                          BeforeInner = os:timestamp(),
                          dirty_write(test_ram, Data1W),
                          AfterInner = os:timestamp(),
                          TimesInner = timer:now_diff(AfterInner, BeforeInner),
                          io:format("test_disc_write_1W: ~p ms~n", [TimesInner])
                  end, lists:seq(0,99)),
    After3 = os:timestamp(),
    Times3 = timer:now_diff(After3, Before3),
    io:format("test_ram_write_100W: ~p ms~n", [Times3]).

test_mnesia_read() ->
    lists:foreach(fun(_I) ->
                          disc_only_read()
                  end, lists:seq(1,10)),
    lists:foreach(fun(_I) ->
                          disc_read()
                  end, lists:seq(1,10)),
    lists:foreach(fun(_I) ->
                          ram_read()
                  end, lists:seq(1,10)),
    ok.

disc_only_read() ->
    Before = os:timestamp(),    
    Pids = lists:map(fun(_I) ->
                             erlang:spawn_monitor(fun() ->
                                                          lists:foreach(fun(Key) ->
                                                                                dirty_read(test_disc_only, Key)
                                                                        end, lists:seq(1,1000))
                                                  end)
                     end, lists:seq(1, 100)),
    [receive
         {'DOWN', MRef, process, _, normal} -> 
             ok;
         {'DOWN', MRef, process, _, Reason} -> 
             exit(Reason)
     end || {_Pid, MRef} <- Pids],
    After = os:timestamp(),
    Times = timer:now_diff(After, Before),
    io:format("test_disc_only_read_1W : ~p ms~n", [Times/1000000]).

disc_read() ->
    Before2 = os:timestamp(),  
    Pids = lists:map(fun(_I) ->
                             erlang:spawn_monitor(fun() ->
                                                          lists:foreach(fun(Key) ->
                                                                                dirty_read(test_disc, Key)
                                                                        end, lists:seq(1,1000))
                                                  end)
                     end, lists:seq(1, 100)),
    [receive
         {'DOWN', MRef, process, _, normal} -> 
             ok;
         {'DOWN', MRef, process, _, Reason} -> 
             exit(Reason)
     end || {_Pid, MRef} <- Pids],
    After2 = os:timestamp(),
    Times2 = timer:now_diff(After2, Before2),
    io:format("test_disc_read_1W: ~p ms~n", [Times2/1000000]).

disc_read_list() ->
    Before2 = os:timestamp(),  
    dirty_read_list(test_disc, lists:seq(1, 1000)),
    After2 = os:timestamp(),
    Times2 = timer:now_diff(After2, Before2),
    io:format("test_disc_read_1W: ~p ms~n", [Times2/1000000]).

ram_read() ->
    Before3 = os:timestamp(),    
    lists:map(fun(Key) ->
                          dirty_read(test_ram, Key)
                  end, lists:seq(1, 1000)),
    After3 = os:timestamp(),
    Times3 = timer:now_diff(After3, Before3),
    io:format("test_ram_write_1W : ~p s~n", [ Times3/1000000]).


rpc_read() ->
    lists:sum(lists:map(fun(Key) ->
                                erlang:spawn(fun() ->
                                                     Before3 = os:timestamp(),    
                                                     rpc:call('test_mnesia_node_172@192.168.1.172', test_db_center, dirty_read, [test_disc, Key]),
                                                     After3 = os:timestamp(),
                                                     Times3 = timer:now_diff(After3, Before3),
                                                     io:format("test_ram_write_1W : ~p s~n", [ Times3/100000]),
                                                     Times3
                                             end)
                        end, lists:seq(1, 1000))).

