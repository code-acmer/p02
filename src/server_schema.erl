-module(server_schema).

%% -export([
%%          mnesia_init/0,
%%          rebuild_schema/0,
%%          rebuild_core/0,
%%          struct_upgrade/0,
%%          get_record_field/1,
%%          extra_db_nodes/1,
%%          connect_nodes/0,
%%          sync_master_node/0,
%%          reset_slave_node_copy_type/0
%%         ]).
%% -compile([{parse_transform, record_info}]).

%% -include("define_mnesia.hrl").
%% -include("define_player.hrl").
%% -include("define_goods.hrl").
%% -include("define_relationship.hrl").
%% -include("define_logger.hrl").
%% -include("define_camp.hrl").
%% -include("define_fashion.hrl").
%% -include("define_mail.hrl").
%% -include("define_chat.hrl").
%% -include("define_task.hrl").
%% -include("define_dungeon.hrl").
%% -include_lib("leshu_db/include/leshu_db.hrl").

%% %% mnesia初始化
%% mnesia_init() ->
%%     ok = ensure_mnesia_running(),
%%     connect_nodes(),
%%     mnesia:wait_for_tables(get_all_tables(), 180000),
%%     case catch sync_master_node() of
%%         ok ->
%%             ok;
%%         SyncError ->
%%             ?WARNING_MSG("sync_master_node failed. E:~p~n",[SyncError])
%%     end,
%%     case mnesia:system_info(tables) of
%%         [schema] ->
%%             %% Debug -> 
%%             error_logger:info_msg("========================================~n"),
%%             error_logger:info_msg("mnesia REBUILD CORE ...~n"),
%%             %% rebuild_schema(),
%%             %% rebuild_core(),
%%             error_logger:info_msg("mnesia REBUILD CORE SUCCESSFUL~n"),
%%             error_logger:info_msg("========================================~n");
%%         Other ->
%%             %% schema:struct_upgrade(),
%%             error_logger:info_msg("mnesia start other: ~p~n", [Other]),
%%             ok
%%     end.

%% %% 初始化数据库
%% %% db_agent:init_db(),

%% extra_db_nodes(Nodes) ->
%%     mnesia:change_config(extra_db_nodes, Nodes).


%% sync_master_node() ->
%%     case is_mnesia_disc() of
%%         true ->
%%             lists:map(fun({Type, TableName}) ->
%%                               case Type of
%%                                   disc ->
%%                                       Nodes =  mnesia:table_info(TableName, disc_copies),
%%                                       case lists:member(node(), Nodes) of
%%                                           true ->
%%                                               ignore;
%%                                           false ->
%%                                               RamNodes = mnesia:table_info(TableName, ram_copies),
%%                                               case lists:member(node(), RamNodes) of
%%                                                   true ->
%%                                                       ?PRINT("changing Node:~w Table:~w to disc_copies~n",[node(), TableName]),
%%                                                       mnesia:change_table_copy_type(TableName, node(), disc_copies);
%%                                                   false ->
%%                                                       mnesia:add_table_copy(TableName, node(), disc_copies)
%%                                               end
%%                                       end;
%%                                   ram ->
%%                                       RamNodes = mnesia:table_info(TableName, ram_copies),
%%                                       case lists:member(node(), RamNodes) of
%%                                           true ->
%%                                               ignore;
%%                                           false ->
%%                                               mnesia:add_table_copy(TableName, node(), ram_copies)
%%                                       end
%%                               end
%%                       end, get_all_tables_def()),
%%             ok = server_sup:start_child(mod_mnesia_backup, []),
%%             ok;
%%         _ ->
%%             lists:map(fun({_, TableName}) ->
%%                               RamNodes = mnesia:table_info(TableName, ram_copies),
%%                               case lists:member(node(), RamNodes) of
%%                                   true ->
%%                                       ignore;
%%                                   false ->
%%                                       mnesia:add_table_copy(TableName, node(), ram_copies)
%%                               end
%%                       end, get_all_tables_def()),
%%             ok
%%     end.



%% rebuild_schema() ->
%%     stopped = mnesia:stop(),
%%     %% This can also be done with:
%%     %% 1. Start mnesia on new node with mnesia:start(). Thus creating a ram schema.
%%     %% 2. On the same new node do 
%%     %% mnesia:change_config(extra_db_nodes, []).
%%     %% This should return {ok, []} if successful.
%%     %% 3. Again on the new node do 
%%     %% mnesia:change_table_copy_type(schema, node(), disc_copies).
%%     %%
%%     %% this is terrible awsome
%%     ok = mnesia:delete_schema(all_nodes()),
%%     timer:sleep(500),
%%     ok = mnesia:create_schema(all_nodes()),
%%     timer:sleep(500),
%%     ok = mnesia:start().

%% rebuild_core() ->
%%     rebuild_core(all_nodes()).

%% %% Private
%% rebuild_core(Nodes) ->
%%     rebuild_core_table(Nodes).

%% all_nodes() ->
%%     nodes() ++ [node()].

%% get_all_tables() ->
%%     lists:map(fun({_, Table}) ->
%%                       Table
%%               end, get_all_tables_def()).

%% %% get_disc_tables() ->
%% %%     get_disc_tables([], get_all_tables_def()).

%% %% get_disc_tables(DiscTables, []) ->
%% %%     DiscTables;
%% %% get_disc_tables(DiscTables, [{disc, Table}|T]) ->
%% %%     get_disc_tables([Table|DiscTables], T);
%% %% get_disc_tables(DiscTables, [{ram, _}|T]) ->
%% %%     get_disc_tables(DiscTables, T).

%% get_all_tables_def() ->
%%     [
%%      {disc, schema},
%%      {disc, player},
%%      {disc, player_uid}, 
%%      {disc, goods}, 
%%      {disc, player_goods},
%%      {disc, goods_uid},
%%      {disc, mails_uid}, 
%%      {disc, relationship},
%%      {disc, relationship_tmp},
%%      {ram,  player_rec}, 
%%      {ram,  player_count},
%%      {disc, player_camp},
%%      {disc, mails},
%%      {ram,  mnesia_statistics},
%%      {disc, help_battle},
%%      {disc, fashion_uid},
%%      {disc, fashion},
%%      {ram,  node_status},
%%      {disc, chats_world},
%%      {disc, chats_world_uid},
%%      {disc, task},
%%      {disc, counter}, %%各种自增ID的维护
%%      {disc, dungeon}
%%     ].

%% get_all_index() ->
%%     [
%%      {player, [accid, accname, nickname]},
%%      {goods, [player_id]},
%%      {relationship, [sid]},
%%      {relationship_tmp, [sid]},
%%      {mails, [player_id]},
%%      {fashion, [player_id]},
%%      {chats_world, [player_id]},
%%      {dungeon, [player_id]}
%%     ].

%% %% 玩家表
%% get_table_def(player) ->
%%     ?TABLE_DEF(player,       set, ?RAM, record_info(fields, player));
%% %% 玩家uid表
%% get_table_def(player_uid) ->
%%     ?TABLE_DEF(player_uid,   set, ?RAM, record_info(fields, player_uid));
%% %% 角色推荐表
%% get_table_def(player_rec) ->
%%     ?TABLE_DEF(player_rec,   set, ?RAM, player, record_info(fields, player));
%% get_table_def(player_count) ->
%%     ?TABLE_DEF(player_count, set, ?RAM, record_info(fields, player_count));
%% %% 物品表
%% get_table_def(goods) ->
%%     ?TABLE_DEF(goods,        set, ?RAM, record_info(fields, goods));
%% get_table_def(player_goods) ->
%%     ?TABLE_DEF(player_goods,        set, ?RAM, record_info(fields, player_goods));
%% %% 物品uid表
%% get_table_def(goods_uid) ->
%%     ?TABLE_DEF(goods_uid,    set, ?RAM, record_info(fields, goods_uid));
%% %% 邮件uid表
%% get_table_def(mails_uid) ->
%%     ?TABLE_DEF(mails_uid,    set, ?RAM, record_info(fields, mails_uid));    
%% %% 好友关系表
%% get_table_def(relationship) ->
%%     ?TABLE_DEF(relationship, set, ?RAM, record_info(fields, relationship));
%% %% 好友关系中间表
%% get_table_def(relationship_tmp) ->
%%     ?TABLE_DEF(relationship_tmp, set, ?RAM, relationship, record_info(fields, relationship));
%% %% 玩家阵法表
%% get_table_def(player_camp) ->
%%     ?TABLE_DEF(player_camp,  set, ?RAM, record_info(fields, player_camp));
%% %% mnesia统计信息表
%% get_table_def(mnesia_statistics) ->
%%     ?TABLE_DEF(mnesia_statistics,  set, ?RAM, record_info(fields, mnesia_statistics));
%% %% 邮件表
%% get_table_def(mails) ->
%%     ?TABLE_DEF(mails,        set, ?RAM, record_info(fields, mails));    
%% %% 好友助战
%% get_table_def(help_battle) ->
%%     ?TABLE_DEF(help_battle,  set, ?RAM, record_info(fields, help_battle));       
%% %% 时装自增ID表
%% get_table_def(fashion_uid) ->
%%     ?TABLE_DEF(fashion_uid,  set, ?RAM, record_info(fields, fashion_uid));
%% %% 时装
%% get_table_def(fashion) ->
%%     ?TABLE_DEF(fashion,      set, ?RAM, record_info(fields, fashion));
%% get_table_def(node_status) ->
%%     ?TABLE_DEF(node_status,  set, ?RAM, record_info(fields, node_status)); 
%% get_table_def(chats_world) ->
%%     ?TABLE_DEF(chats_world,  ordered_set, ?RAM, record_info(fields, chats_world));
%% get_table_def(chats_world_uid) ->
%%     ?TABLE_DEF(chats_world_uid,        set, ?RAM, record_info(fields, chats_world_uid));
%% get_table_def(task) ->
%%     ?TABLE_DEF(task,         set, ?RAM, record_info(fields, task));
%% get_table_def(dungeon) ->
%%     ?TABLE_DEF(dungeon,         set, ?RAM, record_info(fields, dungeon));
%% get_table_def(counter) ->
%%     ?TABLE_DEF(counter,     set, ?RAM, record_info(fields, counter)).

%% %% get_table_def(test) ->
%% %%     {test, 
%% %%      [{frag_properties, [{n_fragments, 7}, {node_pool, [node()]}]}, {attributes, record_info(fields, test)} ]}.
   

%% rebuild_core_table(_Nodes) ->
%%     %% %% 仅内存表
%%     %% RamTablesName = [player_rec],

%%     %% RamTables = lists:map(fun(TableName) -> get_table_def(TableName)
%%     %%                       end, RamTablesName),

%%     Tables = lists:map(fun(TableName) -> 
%%                                get_table_def(TableName)
%%                        end, get_all_tables() -- [schema]),
%%     %% create tables
%%     create_tables(Tables),

%%     lists:foreach(fun({TableName, IndexList}) -> 
%%                           create_indexs(TableName, IndexList)
%%                   end, get_all_index()),
%%     ok.

%% create_tables([]) ->
%%     ok;
%% create_tables([{player_uid, TabDef} | T]) ->
%%     {atomic, ok} = mnesia:create_table(player_uid, TabDef),
%%     %% init player_id
%%     hdb:write(#player_uid{type = player_uid,
%%                           counter = ?STARTER_PLAYER}),
%%     create_tables(T);
%% create_tables([{Name, TabDef} | T]) ->
%%     if
%%         Name =:= schema ->
%%             ignore;
%%         true -> 
%%             {atomic, ok} = mnesia:create_table(Name, TabDef)
%%     end,
%%     ?PRINT("create table ~w done.~n",[Name]),
%%     create_tables(T).

%% delete_tables([]) ->
%%     ok;
%% delete_tables([TableName|T]) ->
%%     {atomic, ok} = mnesia:delete_table(TableName),
%%     ?PRINT("delete table ~w done.~n",[TableName]),
%%     delete_tables(T).

%% create_indexs(_, []) ->
%%     ok;
%% create_indexs(Name, Index)
%%   when is_atom(Index) ->
%%     create_indexs(Name, [Index]);
%% create_indexs(Name, [Index|T]) ->
%%     {atomic, ok} = mnesia:add_table_index(Name, Index),
%%     ?PRINT("Table : ~w create index : ~w done.~n",[Name, Index]),
%%     create_indexs(Name, T).

%% delete_indexs(_, []) ->
%%     ok;
%% delete_indexs(Name, Index)
%%   when is_atom(Index) ->
%%     delete_indexs(Name, [Index]);
%% delete_indexs(Name, [Index|T]) ->
%%     {atomic, ok} = mnesia:del_table_index(Name, Index),
%%     ?PRINT("Table : ~w delete index : ~w done.~n",[Name, Index]),
%%     delete_indexs(Name, T).

%% struct_upgrade() ->
%%     IsMasterNode = is_mnesia_disc(),
%%     case mnesia:system_info(tables) of
%%         %% Debug ->
%%         %%     ignore;
%%         [schema] ->
%%             ignore;
%%         TableNameList when IsMasterNode =:= true  ->
%%             %% 主节点尝试升级结构
%%             mnesia:set_master_nodes([node()]),
%%             case mod_gateway:stop_all_nodes() of
%%                 {ok, StoppedNodes} ->
%%                     mnesia:start(),
%%                     %% mnesia:wait_for_tables(get_all_tables(), 0),
%%                     ?PRINT("stopped Nodes : ~p~n",[StoppedNodes]),
%%                     %% create new tables
%%                     AddTables = lists:filter(fun(TableName) ->
%%                                                      not lists:member(TableName, TableNameList)
%%                                              end, get_all_tables()),
%%                     DelTables = lists:filter(fun(TableName) -> 
%%                                                      not lists:member(TableName, [schema|get_all_tables()])
%%                                              end, TableNameList),    
%%                     ?PRINT("AddTables : ~w ~n",[AddTables]),            
%%                     lists:foreach(fun(TableName) ->
%%                                           create_tables([get_table_def(TableName)])
%%                                   end, AddTables),
%%                     ?PRINT("DelTables : ~w ~n",[DelTables]),
%%                     delete_tables(DelTables),

%%                     %% create new index
%%                     lists:foreach(fun({TableName, NeedIndex}) ->
%%                                           case mnesia:table_info(TableName, index) of
%%                                               [] ->
%%                                                   create_indexs(TableName, NeedIndex);
%%                                               ExistIndex ->
%%                                                   ExistIndexNames = case mnesia:table_info(TableName, attributes) of
%%                                                                         {abort, _} ->
%%                                                                             [];
%%                                                                         Fields ->
%%                                                                             lists:map(fun(I) ->
%%                                                                                               lists:nth((I-1), Fields)
%%                                                                                       end, ExistIndex)
%%                                                                     end,
%%                                                   AddIndexList = lists:filter(fun(Index) ->
%%                                                                                       not lists:member(Index, ExistIndexNames)
%%                                                                               end, NeedIndex),
%%                                                   DelIndexList = lists:filter(fun(Index) ->
%%                                                                                       not lists:member(Index, NeedIndex)
%%                                                                               end, ExistIndexNames),
%%                                                   ?PRINT("Table:~w, AddIndexList : ~w ~n",[TableName, AddIndexList]),
%%                                                   create_indexs(TableName, AddIndexList),
%%                                                   ?PRINT("Table:~w, DelIndexList : ~w ~n",[TableName, DelIndexList]),
%%                                                   delete_indexs(TableName, DelIndexList)
%%                                           end
%%                                   end, get_all_index()),

%%                     %% 获取最新表并进行表结构比对
%%                     case mnesia:system_info(tables) of
%%                         [schema] ->
%%                             ignore;
%%                         Tables ->
%%                             lists:foreach(
%%                               fun(TableName) ->
%%                                       case check_table_struct_upgrade(TableName) of
%%                                           ok ->
%%                                               ?PRINT("Table : ~w nothing done.~n", [TableName]),
%%                                               ok;
%%                                           {upgraded, AttriList, NewAttriList} ->
%%                                               ?PRINT("start upgrade table ~p~n", [TableName]),
%%                                               %% RecordName = 
%%                                               %%     mnesia:table_info(TableName, record_info),
%%                                               %% Nodes = all_nodes(),
%%                                               %% TmpTableName = hmisc:to_atom(atom_to_list(TableName) ++ "_tmp"),
%%                                               %% mnesia:delete_table(TmpTableName),
%%                                               %% RamTables = [
%%                                               %%              ?TABLE_DEF(TmpTableName, set, ?DISC, NewAttriList)
%%                                               %%             ],
%%                                               %% create_tables(RamTables),
%%                                               ok = transform_table(
%%                                                      TableName,
%%                                                      AttriList,
%%                                                      NewAttriList, 
%%                                                      get_default_record(TableName)),
%%                                               ?PRINT("Table : ~w upgraded.~n",[TableName])
%%                                       end
%%                               end, Tables)
%%                     end,
%%                     mnesia:stop(),
%%                     mod_gateway:start_all_nodes();
%%                 error ->
%%                     ?PRINT("try stop nodes failed! struct_upgrade ignore.~n", [])
%%             end,            
%%             ok;
%%         _ ->
%%             ?PRINT("Slave Node:~w trying to upgrade_struct refused.!!!~n",[node()])
%%     end,
%%     ok.

%% get_default_record(player) ->
%%     #player{};
%% get_default_record(goods) ->
%%     #goods{};
%% get_default_record(player_rec) ->
%%     #player{};
%% get_default_record(mails) ->
%%     #mails{};    
%% get_default_record(mnesia_statistics) ->
%%     #mnesia_statistics{};
%% get_default_record(help_battle) ->
%%     #help_battle{};    
%% get_default_record(fashion) ->
%%     #fashion{};          
%% get_default_record(node_status) ->
%%     #node_status{};
%% get_default_record(relationship_tmp) ->
%%     #relationship{};
%% get_default_record(player_goods) ->
%%     #player_goods{};
%% get_default_record(task) ->
%%     #task{};
%% get_default_record(dungeon) ->
%%     #dungeon{};
%% get_default_record(_) ->
%%     undefined.

%% transform_table(TableName, AttriList, NewAttriList, DefaultRecord) ->
%%     %% mnesia:info(),
%%     %% Nodes = all_nodes(),
%%     DefaultValue = tuple_to_list(DefaultRecord),
%%     OldLen = length(AttriList) + 1,
%%     %% NewLen = length(NewAttriList) + 1,
%%     %% 检测结构已经变更，强制加载表
%%     mnesia:force_load_table(TableName),
%%     %% OldRecordName = hmisc:to_atom(atom_to_list(TableName) ++ "_old"),
%%     %% ?PRINT("OldRecordName : ~w~n",[OldRecordName]),
%%     %% ?PRINT("TABLE_INFO : ~w~n",[mnesia:table_info(TableName, all)]),
%%     Transformer = 
%%         fun(R) ->
%%                 RList = tuple_to_list(R),
%%                 %% ?PRINT("PList : ~w~n",[RList]),
%%                 NewRecordList = RList ++ lists:nthtail(OldLen, DefaultValue),
%%                 list_to_tuple(NewRecordList)
%%         end,
%%     RecordName = mnesia:table_info(TableName, record_name),
%%     {atomic, ok} =
%%         mnesia:transform_table(
%%           TableName, Transformer, NewAttriList, RecordName),
%%     ok.
%%     %% mnesia:info(),
%%     %% mnesia:delete_table(TableName),
%%     %% DiscTables =  [
%%     %%                ?TABLE_DEF(TableName,      set, ?DISC, NewAttriList)
%%     %%               ],    
%%     %% create_tables(DiscTables),
%%     %% mnesia:info(),

%%     %% BackTransformer = fun(R) ->
%%     %%                           [TmpTableName|ValueList] = tuple_to_list(R),
%%     %%                           list_to_tuple([TableName|ValueList])
%%     %%                   end,
%%     %% {atomic, ok} = 
%%     %%     mnesia:transform_table(
%%     %%         TmpTableName, BackTransformer, NewAttriList, TableName),
%%     %% mnesia:delete_table(TmpTableName),
%%     %% mnesia:info(),
%%     %% ok.

%% check_table_struct_upgrade(TableName) ->
%%     case mnesia:table_info(TableName, attributes) of
%%         {aborted, _} ->
%%             ?PRINT("Table : ~w get attributes faild", [TableName]);
%%         AttriList ->
%%             RecordName = mnesia:table_info(TableName, record_name),
%%             NewAttriList = get_record_field(RecordName),
%%             if
%%                 AttriList =:= NewAttriList orelse
%%                 NewAttriList =:= [] -> 
%%                     ok;
%%                 true -> 
%%                     ?PRINT("Table : ~w Need upgrade. ~n", [TableName]),
%%                     {upgraded, AttriList, NewAttriList}
%%             end
%%     end.

%% get_record_field(RecordName) ->
%%     record_info:get_record_field(RecordName, ?MODULE).


%% get_running_node(Ret, []) ->
%%     Ret;
%% get_running_node(Ret, [Node|T]) ->
%%     if
%%         Node =/= node() ->
%%             case net_adm:ping(Node) of
%%                 pang ->
%%                     %% node down
%%                     get_running_node(Ret, T);
%%                 pong ->
%%                     %% success
%%                     get_running_node([Node|Ret], T)
%%             end;
%%         true ->
%%             get_running_node([Node|Ret], T)
%%     end.

%% connect_nodes() ->
%%     case mod_gateway:get_node_list() of
%%         [] ->
%%             extra_db_nodes([node()]);
%%         NodeList ->
%%             Node = node(),
%%             NewNodeList = case lists:member(Node, NodeList) of
%%                               false ->
%%                                   [Node|NodeList];
%%                               _ ->
%%                                   NodeList
%%                           end,
%%             extra_db_nodes(NewNodeList)
%%     end.

%%     %% case get_running_node([], data_server:get_node_list()) of
%%     %%     [] ->
%%     %%         ignore;
%%     %%     Nodes ->
%%     %%         extra_db_nodes(Nodes)
%%     %% end.

%% %% get_running_master_nodes(ConnectedNodes) ->
%% %%     case data_server:get_server_list() of
%% %%         [] ->
%% %%             [];
%% %%         ServerList ->
%% %%             MasterServer = lists:filter(fun({NodeType, _}) ->
%% %%                                                 NodeType =:= master
%% %%                                         end, ServerList),
%% %%             lists:foldl(fun(Node, ConnectedMasterNodes) ->
%% %%                                 case lists:keyfind(Node, 2, MasterServer) of
%% %%                                     false ->
%% %%                                         ConnectedMasterNodes;
%% %%                                     {_, Node} ->
%% %%                                         [Node|ConnectedMasterNodes]
%% %%                                 end
%% %%                         end, [], ConnectedNodes)
%% %%     end.

%% is_mnesia_disc() ->
%%     case lists:keyfind(node(), 2, mod_gateway:get_mnesia_node()) of
%%         {master, _} ->
%%             true;
%%         _Other ->
%%             ?PRINT("is_mnesia_disc Other : ~w~n",[ _Other]),
%%             false
%%     end.

%% reset_slave_node_copy_type() ->
%%     lists:map(fun({Type, Node}) ->
%%                       case Type of
%%                           slave ->
%%                               lists:map(fun({TableType, TableName}) ->
%%                                                 case TableType of
%%                                                     disc ->
%%                                                         Nodes =  mnesia:table_info(TableName, disc_copies),
%%                                                         case lists:member(Node, Nodes) of
%%                                                             true ->
%%                                                                 ?PRINT("changing Node:~w Table:~w to ram_copies~n",[Node, TableName]),
%%                                                                 mnesia:change_table_copy_type(TableName, Node, ram_copies);
%%                                                             false ->
%%                                                                 ignore
%%                                                         end;
%%                                                     ram ->
%%                                                         ignore
%%                                                 end
%%                                         end, get_all_tables_def());
%%                           _ ->
%%                               ignore
%%                       end
%%               end, mod_gateway:get_mnesia_node()).


%% ensure_mnesia_running() ->
%%     case mnesia:system_info(is_running) of
%%         yes ->
%%             ok;
%%         starting ->
%%             ?INFO_MSG("mnesia_is_starting...~n",[]),
%%             wait_for(mnesia_running),
%%             ensure_mnesia_running();
%%         Reason when Reason =:= no; Reason =:= stopping ->
%%             throw({error, mnesia_not_running})
%%     end.

%% wait_for(Condition) ->
%%     ?WARNING_MSG("Waiting for ~p...~n", [Condition]),
%%     timer:sleep(1000).
