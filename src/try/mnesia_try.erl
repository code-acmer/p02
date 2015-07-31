-module(mnesia_try).
-compile(export_all).
%% -define(EXCEPTS_MNESIA_M, [mnesia_recover]).
%% -include("common.hrl").

%% -include("define_goods.hrl").
%% -record(counter, {type, counter}).
%% dbg() ->
%%     dbg:tracer(),
%%     dbg:p(all, [call]),  %% 我们关心函数调用
%%     tpl(element(2, application:get_key(mnesia, modules))).
%%     %dbg:tpl(mnesia, write, 5, [{'_', [], [{return_trace}]}]).

%% tpl(List) ->
%%     [dbg:tpl(M, [{'_', [], [{return_trace}]}]) || M <- List].

%% %% ctpl() ->
%% %%     [dbg:ctpl(M, F, A) || {M, F, A} <- ?EXCEPTS_MNESIA_M_F_A].


%% add() ->
%%     mnesia:add_table_index(goods, player_id).
%% del() ->
%%     mnesia:del_table_index(goods, player_id).

%% create_table() ->
%%     mnesia:create_table(rec_base_equip_attribute, [{record_name,rec_base_equip_attribute},
%%                                                    {type,set},
%%                                                    {attributes,[id,init_rage,hp_lim,attack,def,mobi,hit,dodge,
%%                                                                 crit,parry]},
%%                                                    {ram_copies,['p04_master_1@192.168.1.102']}]).

%% delete_table() ->
%%     mnesia:delete_table(rec_base_equip_attribute).



%% insert_player() ->
%%     mnesia:change_table_copy_type(player, node(), ram_copies),
%%     mnesia:ets(fun()-> [mnesia:write(#player{id=Id,
%%                                                    accid = integer_to_list(Id), 
%%                                                    nickname = integer_to_list(Id)
%%                                                   }) || Id <- lists:seq(1, 4000000)] end),
%%     mnesia:change_table_copy_type(player, node(), disc_copies).


%% all() ->
%%     %connect(),
%%     create_schema(),
%%     mnesia_start(),
%%     create_frag_table().

    
%% connect() ->
%%     pong = net_adm:ping('node2@Laptop-Y400'),    
%%     pong = net_adm:ping('node3@Laptop-Y400'),
%%     pong = net_adm:ping('node4@Laptop-Y400').

%% create_schema() ->
%%     StorageNodes = [node() | nodes()],
%%     mnesia:create_schema(StorageNodes). 

%% mnesia_start() ->
%%     [rpc:call(Node, mnesia, start, []) || Node <- [node() | nodes()]].

%% mnesia_stop() ->
%%     mnesia:start(),
%%     [rpc:call(Node, mnesia, stop, []) || Node <- [node() | nodes()]].

%% create_frag_table() ->
%%     StorageNodes = [node()],
%%     FragProps = [{node_pool, StorageNodes}, {n_fragments, 4}, {n_disc_only_copies, 1}],
%%     {atomic, ok} = mnesia:create_table(player, [{frag_properties, FragProps}, {attributes, record_info(fields, player)}]),
%%     {atomic, ok} = mnesia:create_table(goods, [{frag_properties, [{foreign_key, {player, player_id}} | FragProps]}, {attributes, record_info(fields, goods)}]),
%%     %% {atomic, ok} = mnesia:create_table(rec_base_equip_attribute, 
%%     %%                                    [{attributes, record_info(fields, rec_base_equip_attribute)}, 
%%     %%                                     {disc_only_copies, [node()]},
%%     %%                                     {storage_properties, [{dets, [{ram_file, true}]}]}]),
%%     {atomic, ok} = mnesia:create_table(counter,  [{attributes, record_info(fields, counter)}, 
%%                                         {disc_copies, [node()]}
%%                                         ]).

%% %% test_foreign_key() ->
%% %%     StorageNodes = [node()],
%% %%     FragProps = [{node_pool, StorageNodes}, {n_fragments, 4}, {n_disc_only_copies, 1}],
%% %%     {atomic, ok} = mnesia:create_table(rec_base_equip_attribute, 
%% %%                                        [%{frag_properties, [{foreign_key, {player, id}} | FragProps]},
%% %%                                         {attributes, record_info(fields, rec_base_equip_attribute)}, 
%% %%                                         %{disc_only_copies, [node()]},
%% %%                                         {storage_properties, [{dets, [{ram_file, true}]}]}
%% %%                                        ]).

%% dirty_insert_player(Begin, End) ->
%%     SingleWriteFun = fun(Id) ->
%%                              mnesia:write(#player{id=Id,
%%                                                   accid = integer_to_list(Id), 
%%                                                   nickname = integer_to_list(Id)
%%                                                  }),
%%                              mnesia:write(#goods{id=Id,
%%                                                  player_id = Id,
%%                                                  base_id = Id
%%                                                 })
%%                      end,

%%     WriteFun = fun () ->
%%                        [SingleWriteFun(Id) || Id <- lists:seq(Begin, End)],
%%                        ok
%%                        %% Id = 10001,
%%                        %% SingleWriteFun(Id)
%%                end,

%%     mnesia:activity(async_dirty, WriteFun, mnesia_frag). 

%% test_insert_player() ->
%%     SingleWriteFun = fun(Id) ->
%%                              mnesia:write(#player{id=Id,
%%                                                   accid = integer_to_list(Id), 
%%                                                   nickname = integer_to_list(Id)
%%                                                  }),
%%                              mnesia:write(#goods{id=Id,
%%                                                  player_id = Id,
%%                                                  base_id = Id
%%                                                 })
%%                      end,

%%     WriteFun = fun () ->
%%                        [SingleWriteFun(Id) || Id <- lists:seq(100001, 200000)],
%%                        ok
%%                        %% Id = 10001,
%%                        %% SingleWriteFun(Id)
%%                end,

%%     mnesia:activity(transaction, WriteFun, mnesia_frag). 

%% test_dirty_update_counter() ->
%%     F = fun() ->
%%                 Ids = [mnesia:dirty_update_counter(counter, goods, 1) || _ <- lists:seq(1,500000)],
%%                 Id = mnesia:dirty_update_counter(counter, goods, 1),
%%                 mnesia:dirty_write(counter, {counter, Id, Ids}),
%%                 Id
%%         end,
%%     R = timer:tc(F),
%%     io:format("\e[1;31m ~p \e[0;38m~n", [R]).
%%     %dbg(),
%%     %mnesia:dirty_update_counter(counter, goods, 1).





%% info() ->
%%     Info = fun(Item) -> mnesia:table_info(player, Item) end,    
%%     mnesia:activity(sync_dirty, Info, [frag_dist], mnesia_frag).


%% read(Id) ->
%%     mnesia:activity(sync_dirty, fun() ->
%%                                         mnesia:read(player, Id)
%%                                 end, mnesia_frag). 

%% read_all() ->
%%     lists:all(fun([Record]) -> 
%%                       is_record(Record, player) 
%%               end, [read(Id) || Id <- lists:seq(1, 300, 7)]).

%% change_layout() ->
%%     Info = fun(Item) -> mnesia:table_info(player, Item) end,     
%%     NodeLayout = mnesia:activity(sync_dirty, Info, [frag_dist], mnesia_frag),
%%     io:format("~p~n", [NodeLayout]),
%%     mnesia:change_table_frag(player, {add_frag, [node()]}),
%%     mnesia:activity(sync_dirty, Info, [frag_dist], mnesia_frag).



    

%% count_distribution(L) ->
%%     DistributionDict = lists:foldl(fun(N, Dict) ->
%%                                            dict:update_counter(N, 1, Dict)
%%                                    end, dict:new(), L),
%%     lists:sort(dict:to_list(DistributionDict)).



%% is_leap_year(N) 
%%   when (N rem 4 =:= 0 andalso N rem 100 =/= 0) orelse 
%%        (N rem 400 =:= 0) ->
%%     leap;
%% is_leap_year(_) ->
%%     not_leap.
