-module(mnesia_table).

-export([create/0, create_local_copy/1, wait_for_replicated/0, wait/1,
         force_load/0, is_present/0, names/0, definitions/0, definitions2/0,
         check_schema_integrity/0, create_not_center_node/0, create_local_copy/2]).

-export([get_def/1,  has_copy_type/2]). %%  内部使用

-include("common.hrl").
-include("define_mnesia.hrl").
-include("define_all_table.hrl").
-include_lib("leshu_db/include/leshu_db.hrl").
-include("define_logger.hrl").

create() ->
    Tables = definitions(),
    lists:foreach(fun ({Tab, TabDef}) ->
                          ?DEBUG("Tab: ~p, TabDef: ~p", [Tab, TabDef]),
                          case mnesia:create_table(Tab, TabDef) of
                              {atomic, ok} -> 
                                  ok;
                              {aborted, Reason} ->
                                  throw({error, {table_creation_failed,
                                                 Tab, TabDef, Reason}})
                          end
                  end, Tables),
    ok.

create_not_center_node() ->
    Tables = definitions(),
    {ok, CenterNodeTables} = server_misc:get_tables_name_cache(),
    ?DEBUG("CenterNodeTables: ~p", [CenterNodeTables]),
    lists:foreach(fun ({Tab, TabDef}) ->
                          case lists:member(Tab, CenterNodeTables) of
                              true ->
                                  ok;
                              false ->
                                  case mnesia:create_table(Tab, TabDef) of
                                      {atomic, ok} -> 
                                          ok;
                                      {aborted, Reason} ->
                                          throw({error, {table_creation_failed,
                                                         Tab, TabDef, Reason}})
                                  end
                          end
                  end, Tables),
    ok.


%% The sequence in which we delete the schema and then the other
%% tables is important: if we delete the schema first when moving to
%% RAM mnesia will loudly complain since it doesn't make much sense to
%% do that. But when moving to disc, we need to move the schema first.
%% schema为disc，可以有ram和disc，但是ram只能有ram的。
%% 所以scheme改为ram的时候，必须等所有表改为ram；
%% 相反，要将所有的ram改为disc之前得将scheme改为disc，否则那些ram的表不能改为disc。
create_local_copy(remote) ->
    create_local_copies(remote),
    create_local_copy(schema, ram_copies);
create_local_copy(disc) ->
    create_local_copy(schema, disc_copies),
    create_local_copies(disc);
create_local_copy(ram)  ->
    create_local_copies(ram),
    create_local_copy(schema, ram_copies).

wait_for_replicated() ->
    wait(lists:append(
           [mnesia_frag:frag_names(Tab) || {Tab, TabDef} <- definitions(),
                                           not lists:member({local_content, true}, TabDef)])).

wait(TableNames) ->
    %% io:format("~p", [mnesia:info()]),
    case mnesia:wait_for_tables(TableNames, infinity) of
    %% case mnesia:wait_for_tables(TableNames, 1000) of
        ok ->
            ok;
        {timeout, BadTabs} ->
            %% ?WARNING_MSG("BadTabs: ~p", [BadTabs]),
            throw({error, {timeout_waiting_for_tables, BadTabs}});
        {error, Reason} ->
            throw({error, {failed_waiting_for_tables, Reason}})
    end.

force_load() ->
    [mnesia:force_load_table(T) || T <- names()], ok.

%% 表是否齐全
is_present() ->
    names() -- mnesia:system_info(tables) =:= []. 

check_schema_integrity() ->
    Tables = mnesia:system_info(tables),
    case check(fun(Tab, TabDef) ->
                       case lists:member(Tab, Tables) of
                           false -> 
                               {error, {table_missing, Tab}};
                           true  -> 
                               check_attributes(Tab, TabDef)
                       end
               end) of
        ok -> 
            %% ok = wait(names()),
            %% ?DEBUG("ok ... "),
            check2(fun table_version:check_record_version/2);
            %% ?DEBUG("ok2 ... ") ;        
            %% check(fun check_content/2);
            %% delay transform, not check_content
        Other ->
            Other
    end.


%%--------------------------------------------------------------------
%% Internal helpers
%%--------------------------------------------------------------------
create_local_copies(Type) ->
    lists:foreach(
      fun ({Tab, StorageType}) ->
              ok = create_local_copy(Tab, StorageType)
      end, definitions(Type)),
    ok.
create_local_copy(_, remote) ->
    %% remote not need copy to local.
    ok;
create_local_copy(Tab, Type) ->
    ?DEBUG("Tab: ~p, Type: ~p", [Tab, Type]),
    StorageType = mnesia:table_info(Tab, storage_type),
    ?DEBUG("Tab: ~p, Type: ~p, StorageType: ~p", [Tab, Type, StorageType]),
    {atomic, ok} =
        if
            StorageType == unknown ->
                mnesia:add_table_copy(Tab, node(), Type);
            StorageType /= Type ->
                mnesia:change_table_copy_type(Tab, node(), Type);
            true -> 
                {atomic, ok}
        end,
    ok.

%% 根据配置返回copy类型
%% Type为disc的或者local_content会根据配置取存储类型
%% 否则都是ram_copies
storage_type(TabDef, Type) ->
    HasDiscCopies = has_copy_type(TabDef, disc_copies),
    HasDiscOnlyCopies = has_copy_type(TabDef, disc_only_copies),
    LocalTab = proplists:get_bool(local_content, TabDef),    
    if
        Type =:= disc orelse LocalTab ->
            if
                HasDiscCopies -> 
                    disc_copies;
                HasDiscOnlyCopies -> 
                    disc_only_copies;
                true -> 
                    ram_copies
            end;
        Type =:= ram ->
            if 
                HasDiscOnlyCopies ->
                    %% 内存放不下，不给copy
                    remote;
                true ->
                    ram_copies
            end
    end.

%% test_has_copy_type(Tab, Type) ->
%%     {_, TabDef} = lists:keyfind(Tab, 1, definitions()),
%%     has_copy_type(TabDef, Type).
%% run_test_has_copy_type() ->
%%     true = test_has_copy_type(player, disc_only_copies),
%%     false = test_has_copy_type(player, disc_copies),
%%     false = test_has_copy_type(player, ram_copies), 
%%     true = test_has_copy_type(player_rec, ram_copies),
%%     false = test_has_copy_type(player_rec, disc_copies),    
%%     true = test_has_copy_type(player_camp, disc_only_copies),
%%     true = test_has_copy_type(counter, disc_copies).

has_copy_type(TabDef, Type) ->
    case proplists:get_value(Type, TabDef, []) of
        [] ->
            case proplists:get_value(frag_properties, TabDef, []) of
                [] ->
                    Type =:= ram_copies;
                _FragProps ->
                    %% 为了简单起见，暂定假设所有分片都是disc_only_copies
                    %% 不能简单的将分片是全disc或者全ram，
                    %% 现在还没有其他分片方案，不能保证以后会有ram disc混用的（这种比较复杂，不好做copy，暂时不考虑）
                    Type =:= disc_only_copies
            end;
        NodeList ->
            lists:member(node(), NodeList)
    end.

check_attributes(Tab, TabDef) ->
    {_, ExpAttrs} = proplists:lookup(attributes, TabDef),
    case mnesia:table_info(Tab, attributes) of
        ExpAttrs -> 
            ok;
        Attrs    -> 
            {error, {table_attributes_mismatch, Tab, ExpAttrs, Attrs}}
    end.

%% 检查表的数据跟实际的record是否匹配上
%% check_content(Tab, _TabDef) ->
%%     case mnesia:dirty_first(Tab) of
%%         '$end_of_table' ->
%%             ok;
%%         Key ->
%%             [ObjList] = mnesia:dirty_read(Tab, Key),
%%             case check_record(ObjList) of
%%                 ok ->
%%                     ok;
%%                 {error, Error} ->
%%                     {error, {Tab, Error}}
%%             end
%%     end.
%% check_record(RecordDataList) 
%%   when is_list(RecordDataList)->
%%     lists:foldl(fun
%%                     (_, {error,_}=Error) ->
%%                         Error;
%%                     (RecordData, ok) ->
%%                         check_record(RecordData)
%%                 end, ok, RecordDataList);
%% check_record(RecordData) 
%%   when is_tuple(RecordData), 
%%        is_atom(element(1, RecordData)), 
%%        tuple_size(RecordData) >= 2 ->
%%     [RecordName|ValueList] = tuple_to_list(RecordData),
%%     %% all_record:is_record 不能用于业务逻辑，仅适用于工具类模块
%%     case all_record:is_record(RecordName) of
%%         true ->
%%             Match = match_info(RecordName),
%%             MatchComp = ets:match_spec_compile([{Match, [], ['$_']}]),
%%             case ets:match_spec_run([RecordData], MatchComp) of
%%                 [RecordData] ->
%%                     check_record(ValueList);
%%                 _ -> 
%%                     {error, {record_invalid, Match, RecordData}}
%%             end;
%%         false ->
%%             ok
%%     end;
%% check_record(_) ->
%%     ok.

check(Fun) ->
    case [Error || {Tab, TabDef} <- definitions(),
                   case Fun(Tab, TabDef) of
                       ok -> 
                           Error = none, 
                           false;
                       {error, Error} -> 
                           true
                   end] of
        [] -> 
            ok;
        Errors -> 
            {error, Errors}
    end.

check2(Fun) ->
    case [Error || {Tab, TabDef} <- definitions2(),
                   case Fun(Tab, TabDef) of
                       ok -> 
                           Error = none, 
                           false;
                       {error, Error} -> 
                           true
                   end] of
        [] -> 
            ok;
        Errors -> 
            {error, Errors}
    end.

%%--------------------------------------------------------------------
%% Table definitions
%%--------------------------------------------------------------------

check_all_table(_) ->
    %% lists:member(Tab, sn_tables() ++ key_table()).
    true.
        
%% 处理分片
names() -> 
    lists:append([mnesia_frag:frag_names(Tab) || {Tab, _} <- definitions()]).

%% 处理了分片的情况
definitions(remote) ->
    [{counter, ram_copies}];
definitions(disc) ->
    lists:foldl(fun({Tab, TabDef}, Acc) ->
                        case check_all_table(Tab) of
                            false ->
                                Acc;
                            true ->
                                StorageType = storage_type(TabDef, disc),
                                case proplists:get_value(frag_properties, TabDef) of
                                    [] ->
                                        [{Tab, StorageType} | Acc];
                                    _FragProps ->
                                        %% disc的情况下，schema已经copy过来了，可以访问到mnesia_frag:frag_names(Tab)
                                        [{TabFrag, StorageType} || TabFrag <- mnesia_frag:frag_names(Tab)] ++ Acc
                                end
                        end
                end, [], definitions());
%% disc_only_copies不给ram_copies，内存放不下
definitions(ram) ->
    lists:foldl(fun({Tab, TabDef}, Acc) ->
                        %% case has_copy_type(TabDef, disc_only_copies) of
                        %%     true ->
                        %%         Acc;
                        %%     false ->
                        StorageType = storage_type(TabDef, ram),
                        [{Tab, StorageType} | Acc]
%                        end
                end, [], definitions()).


key_table() ->
    hdb:key_table().

sn_tables() ->
    hdb:all_sn_tables().
%% 这里虽然繁琐，还是不用宏，因为老是忘记定义，倒不如直接写在这里。
%% 开启dets的ram_file会使读可以快点
%% 使用{foreign_key, {player, player_id}}的目的是保证同一个玩家的数据在同个分片，这样就能为后续分片如果要在不同节点的迁移带来方便
%% 分片的copy由frag_properties决定，而不是外部copy配置

%% 会使用到的默认值
%% copy的默认值是{ram_copies, [node()]}，如果是临时的内存表，就不需要声明
%% type默认值{type, set}

%% 玩家数据表都是disc_only_copies，用gen_server做cache，大表需要frag，并且都是用{foreign_key, {player, player_id}}，
%% 临时表都是ram_copies，如player_count，mnesia_statistics
%% 需要持久化，但是数据不会随着时间推移而增长（主要是可删除老数据），就是用disc_copies，如果世界聊天，私聊
%% 需要持久化，但是数据规模本来就几条，如果couter，自增id管理，也是用disc_copies
%% definitions() ->
%%     %% ServerCount = length(server_misc:mnesia_sn_list()),
%%     SnList = server_misc:mnesia_sn_list(),
%%     %% ?WARNING_MSG("SnList: ~p", [SnList]),
%%     Sn = app_misc:get_env(local_sn_num),
%%     lists:foldl(fun({Tab, TabDef}, AccDef) ->
%%                         case lists:member(Tab, sn_tables()) of
%%                             true ->
%%                                 TabList = 
%%                                     lists:map(fun(Sn) ->
%%                                                       {list_to_atom(lists:concat([Tab, "_", Sn])), TabDef}
%%                                               end, SnList),
%%                                 TabList ++ AccDef;
%%                             false ->
%%                                 [{Tab, TabDef}|AccDef]
%%                         end
%%                 end, [], definitions2()). 

definitions() ->
    %% ServerCount = length(server_misc:mnesia_sn_list()),
    %% ?WARNING_MSG("SnList: ~p", [SnList]),
    Sn = app_misc:get_env(local_sn_num),
    KeyTableNum = app_misc:get_env(key_table_num),
    List = 
        lists:foldl(fun({Tab, TabDef}, AccDef) ->
                            %% 处理公共表
                            NewAccDef = 
                                case lists:member(Tab, sn_tables()) of
                                    true ->
                                        %% ?DEBUG("Tab: ~p", [Tab]),
                                        [{Tab, TabDef}|AccDef];
                                    false ->
                                        %% 处理key值非整数表
                                        case lists:member(Tab, key_table()) of
                                            true ->
                                                %% ?WARNING_MSG("Tab: ~p", [Tab]),
                                                TabInfoList = 
                                                    lists:map(fun(Num) ->
                                                                      {list_to_atom(lists:concat([Tab, "_", Num])), TabDef}
                                                              end, lists:seq(1, KeyTableNum)),
                                                TabInfoList ++ AccDef;
                                            %% 普通玩家表
                                            false ->
                                                TabInfo = {list_to_atom(lists:concat([Tab, "_", Sn])), TabDef},
                                                [TabInfo | AccDef]
                                        end                                
                                end,
                            %% 开一张Tab表{私有表不存数据}为方便设计hdb接口
                            [{Tab, TabDef} | NewAccDef]
                    end, [], definitions2()),
    lists:usort(List).


definitions2() ->
    [
     %% ====================玩家私有的数据====================
     %% 玩家表
     {player,
      [
       {record_name, player},
       {attributes, record_info(fields, player)},
       {index, [#player.accid, #player.accname, #player.nickname, #player.qq]},
       %% {frag_properties, [{n_fragments, ?N_FRAGMENTS}, {n_disc_only_copies, 1}]},
       %% {frag_properties, [{n_fragments, ?N_FRAGMENTS_16}, {n_disc_copies, 1}, {node_pool,[node()]}]},
       {disc_copies,[node()]}
       %% {storage_properties, [{dets, [{ram_file, true}]}]}
      ]},
     %% 物品表
     {goods,
      [
       {record_name, goods},
       {attributes, record_info(fields, goods)},
       {index, [#goods.player_id]},
       %% {frag_properties, [{n_fragments, ?N_FRAGMENTS}, {n_disc_only_copies, 1}]},
       %% {frag_properties, [{n_fragments, ?N_FRAGMENTS_64}, {n_disc_copies, 1}, {node_pool,[node()]}]},
       {disc_copies,[node()]}
       %% {storage_properties, [{dets, [{ram_file, true}]}]}
      ]},
      %% 关系
     {relationship, 
      [
       {record_name, relationship},
       {attributes, record_info(fields, relationship)},
       {index, [#relationship.sid]},
       %% {frag_properties, [{n_fragments, ?N_FRAGMENTS_16}, {n_disc_copies, 1}, {node_pool,[node()]}]},
       {disc_copies,[node()]}
       %% {frag_properties, [{n_fragments, ?N_FRAGMENTS}, {n_disc_only_copies, 1}]},
       %% {storage_properties, [{dets, [{ram_file, true}]}]}
      ]},
     %% 邮件
     {mails,
      [
       {record_name, mails},
       {attributes, record_info(fields, mails)},
       {index, [#mails.player_id]},
       %% {frag_properties, [{n_fragments, ?N_FRAGMENTS_16}, {n_disc_copies, 1}, {node_pool,[node()]}]},
       {disc_copies,[node()]}
       %% {frag_properties, [{n_fragments, ?N_FRAGMENTS}, {n_disc_only_copies, 1}]},
       %% {storage_properties, [{dets, [{ram_file, true}]}]}
      ]},
     {operators_mail,
      [
       {record_name, operators_mail},
       {attributes, record_info(fields, operators_mail)},
       {index, [#operators_mail.player_id]},
       %% {frag_properties, [{n_fragments, ?N_FRAGMENTS_16}, {n_disc_copies, 1}, {node_pool,[node()]}]},
       {disc_copies,[node()]}
       %% {frag_properties, [{n_fragments, ?N_FRAGMENTS}, {n_disc_only_copies, 1}]},
       %% {storage_properties, [{dets, [{ram_file, true}]}]}
      ]},
     %% 时装
     %% {fashion,
     %%  [
     %%   {attributes, record_info(fields, fashion)},
     %%   {index, [#fashion.player_id]},
     %%   {disc_only_copies, [node()]}
     %%  ]},
     %% 副本记录
     {dungeon,
      [
       {record_name, dungeon},
       {attributes, record_info(fields, dungeon)},
       {index, [#dungeon.player_id]},
       %% {frag_properties, [{n_fragments, ?N_FRAGMENTS_32}, {n_disc_copies, 1}, {node_pool,[node()]}]},
       {disc_copies,[node()]}
       %% {frag_properties, [{n_fragments, ?N_FRAGMENTS}, {n_disc_only_copies, 1}]},
       %% {storage_properties, [{dets, [{ram_file, true}]}]}
      ]},
     {dungeon_mugen,
      [
       {record_name, dungeon_mugen},
       {attributes, record_info(fields, dungeon_mugen)},
       %% {disc_only_copies, [node()]}
       {frag_properties, [{n_fragments, ?N_FRAGMENTS_16}, {n_disc_copies, 1}, {node_pool,[node()]}]},
       {disc_copies,[node()]}
      ]},
     {super_battle,
      [
       {record_name, super_battle},
       {attributes, record_info(fields, super_battle)},
       %% {disc_only_copies, [node()]}
       {frag_properties, [{n_fragments, ?N_FRAGMENTS_16}, {n_disc_copies, 1}, {node_pool,[node()]}]},
       {disc_copies,[node()]}
      ]},
     {daily_dungeon,
      [
       {record_name, daily_dungeon},
       {attributes, record_info(fields, daily_dungeon)},
       %% {disc_only_copies, [node()]}
       {frag_properties, [{n_fragments, ?N_FRAGMENTS_16}, {n_disc_copies, 1}, {node_pool,[node()]}]},
       {disc_copies,[node()]}
      ]},
     {source_dungeon,
      [
       {record_name, source_dungeon},
       {attributes, record_info(fields, source_dungeon)},
       %% {disc_only_copies, [node()]}
       {frag_properties, [{n_fragments, ?N_FRAGMENTS_16}, {n_disc_copies, 1}, {node_pool,[node()]}]},
       {disc_copies,[node()]}
      ]},
     {player_skill,
      [
       {record_name, player_skill},
       {attributes, record_info(fields, player_skill)},
       {index, [#player_skill.player_id]},
       %% {disc_only_copies, [node()]},
       %% {storage_properties, [{dets, [{ram_file, true}]}]}
       %% {frag_properties, [{n_fragments, ?N_FRAGMENTS_16}, {n_disc_copies, 1}, {node_pool,[node()]}]},
       {disc_copies,[node()]}
      ]},
     {task,
      [
       {record_name, task},
       {attributes, record_info(fields, task)},
       %% {frag_properties, [{n_fragments, ?N_FRAGMENTS}, {n_disc_only_copies, 1}]},
       {index, [#task.player_id]},
       %% {disc_only_copies, [node()]}
       {frag_properties, [{n_fragments, ?N_FRAGMENTS_32}, {n_disc_copies, 1}, {node_pool,[node()]}]},
       {disc_copies,[node()]}
      ]},
     {mugen_reward,
      [
       {record_name, mugen_reward},
       {attributes, record_info(fields, mugen_reward)},
       {index, [#mugen_reward.player_id]},
       %% {disc_only_copies, [node()]}
       {frag_properties, [{n_fragments, ?N_FRAGMENTS_16}, {n_disc_copies, 1}, {node_pool,[node()]}]},
       {disc_copies,[node()]}
      ]},
     %% 神秘商店信息表
     {sterious_shop,
      [
       {record_name, sterious_shop},
       {attributes, record_info(fields, sterious_shop)},
       %% {storage_properties, [{dets, [{ram_file, true}]}]},
       %% {disc_only_copies, [node()]}
       %% {frag_properties, [{n_fragments, ?N_FRAGMENTS_16}, {n_disc_copies, 1}, {node_pool,[node()]}]},
       {disc_copies,[node()]}
      ]},
     %% 竞技场神秘商店信息表
     {vice_shop,
      [
       {record_name, vice_shop},
       {attributes, record_info(fields, vice_shop)},
       %% {storage_properties, [{dets, [{ram_file, true}]}]},
       %% {disc_only_copies, [node()]}
       %% {frag_properties, [{n_fragments, ?N_FRAGMENTS_16}, {n_disc_copies, 1}, {node_pool,[node()]}]},
       {disc_copies,[node()]}
      ]},
     %% 抽奖的信息
     {choujiang_info,
      [
       {record_name, choujiang_info},
       {attributes, record_info(fields, choujiang_info)},
       %% {storage_properties, [{dets, [{ram_file, true}]}]},
       %% {disc_only_copies, [node()]}
       %% {frag_properties, [{n_fragments, ?N_FRAGMENTS_16}, {n_disc_copies, 1}, {node_pool,[node()]}]},
       {disc_copies,[node()]}
      ]},
     {activity_shop_record,
      [
       {record_name, activity_shop_record},
       {attributes, record_info(fields, activity_shop_record)},
       %% {storage_properties, [{dets, [{ram_file, true}]}]},
       %% {disc_only_copies, [node()]}
       %% {frag_properties, [{n_fragments, ?N_FRAGMENTS_16}, {n_disc_copies, 1}, {node_pool,[node()]}]},
       {disc_copies,[node()]}
      ]},
     {player_dungeon_match,
      [
       {record_name, player_dungeon_match},
       {attributes, record_info(fields, player_dungeon_match)},
       %% {storage_properties, [{dets, [{ram_file, true}]}]},
       %% {disc_only_copies, [node()]}
       %% {frag_properties, [{n_fragments, ?N_FRAGMENTS_16}, {n_disc_copies, 1}, {node_pool,[node()]}]},
       {disc_copies,[node()]}
      ]},
     {player_dungeon_match_activity,
      [
       {attributes, record_info(fields, player_dungeon_match)},
       {record_name, player_dungeon_match},
       %% {storage_properties, [{dets, [{ram_file, true}]}]},
       %% {disc_only_copies, [node()]}
       %% {frag_properties, [{n_fragments, ?N_FRAGMENTS_16}, {n_disc_copies, 1}, {node_pool,[node()]}]},
       {disc_copies,[node()]}
      ]},
     {pay_gifts,
      [
       {record_name, pay_gifts},
       {attributes, record_info(fields, pay_gifts)},
       {index, [#pay_gifts.player_id]},
       %% {storage_properties, [{dets, [{ram_file, true}]}]},
       %% {disc_only_copies, [node()]}
       %% {frag_properties, [{n_fragments, ?N_FRAGMENTS_16}, {n_disc_copies, 1}, {node_pool,[node()]}]},
       {disc_copies,[node()]}
      ]},
     {player_month_sign,
      [
       {record_name, player_month_sign},
       {attributes, record_info(fields, player_month_sign)},
       %% {storage_properties, [{dets, [{ram_file, true}]}]},
       %% {disc_only_copies, [node()]}
       %% {frag_properties, [{n_fragments, ?N_FRAGMENTS_16}, {n_disc_copies, 1}, {node_pool,[node()]}]},
       {disc_copies,[node()]}
      ]},
     {advance_reward,
      [
       {record_name, advance_reward},
       {attributes, record_info(fields, advance_reward)},
       %% {disc_only_copies, [node()]}
       {frag_properties, [{n_fragments, ?N_FRAGMENTS_16}, {n_disc_copies, 1}, {node_pool,[node()]}]},
       {disc_copies,[node()]}
      ]},
     {vip_reward,
      [
       {record_name, vip_reward},
       {attributes, record_info(fields, vip_reward)},
       %% {disc_only_copies, [node()]}
       {frag_properties, [{n_fragments, ?N_FRAGMENTS_16}, {n_disc_copies, 1}, {node_pool,[node()]}]},
       {disc_copies,[node()]}
      ]},
     {player_skill_record,
      [
       {record_name, player_skill_record},
       {attributes, record_info(fields, player_skill_record)},
       %% {disc_only_copies, [node()]}
       {frag_properties, [{n_fragments, ?N_FRAGMENTS_16}, {n_disc_copies, 1}, {node_pool,[node()]}]},
       {disc_copies,[node()]}
      ]},
     {combat_attri,
      [
       {record_name, combat_attri},
       {attributes, record_info(fields, combat_attri)},
       %% {disc_copies, [node()]}
       {frag_properties, [{n_fragments, ?N_FRAGMENTS_16}, {n_disc_copies, 1}, {node_pool,[node()]}]},
       {disc_copies,[node()]}
      ]},
     %% ====================玩家自己的数据结束====================
     %% ====================公共数据====================
     %% 好友助战
     %% {help_battle, 
     %%  [
     %%   {attributes, record_info(fields, help_battle)},
     %%   {disc_copies, [node()]}
     %%  ]},
     %%排行榜的是共用一个结构，要记得在table_version那边加上no_version
     {async_arena_rank,
      [
       {index, [#async_arena_rank.player_id, #async_arena_rank.robot_id]},
       {record_name, async_arena_rank},
       {attributes, record_info(fields, async_arena_rank)},
       %% {disc_copies, [node()]}
       {frag_properties, [{n_fragments, ?N_FRAGMENTS_16}, {n_disc_copies, 1}, {node_pool,[node()]}]},
       {disc_copies,[node()]}
      ]},
     {async_arena_report,
      [
       {index, [#async_arena_report.attack_id, #async_arena_report.deffender_id]},
       {record_name, async_arena_report},
       {attributes, record_info(fields, async_arena_report)},
       %% {disc_copies, [node()]}
       {frag_properties, [{n_fragments, ?N_FRAGMENTS_16}, {n_disc_copies, 1}, {node_pool,[node()]}]},
       {disc_copies,[node()]}
      ]},
     {sync_arena_rank,
      [
       {index, [#sync_arena_rank.player_id]},
       {record_name, sync_arena_rank},
       {attributes, record_info(fields, sync_arena_rank)},
       %% {disc_copies, [node()]}
       {frag_properties, [{n_fragments, ?N_FRAGMENTS_16}, {n_disc_copies, 1}, {node_pool,[node()]}]},
       {disc_copies,[node()]}
      ]},
     {mugen_rank,
      [
       {type, ordered_set},
       {index, [#rank.player_id]},
       {record_name, rank},
       {attributes, record_info(fields, rank)},
       {disc_copies, [node()]}
      ]},
     %% {super_battle_rank,
     %%  [
     %%   {index, [#rank.player_id]},
     %%   {type, ordered_set},
     %%   {record_name, rank},
     %%   {attributes, record_info(fields, rank)},
     %%   {disc_copies, [node()]}
     %%  ]},
     {battle_ability_rank,
      [
       {index, [#rank.player_id]},
       {type, ordered_set},
       {record_name, rank},
       {attributes, record_info(fields, rank)},
       {disc_copies, [node()]}
      ]},
     %% {level_rank,
     %%  [
     %%   {index, [#rank.player_id]},
     %%   {type, ordered_set},
     %%   {record_name, rank},
     %%   {attributes, record_info(fields, rank)},
     %%   {disc_copies, [node()]}
     %%  ]},
     %% 铜钱消费排行榜
     {cost_coin_rank,
      [
       {index, [#rank.player_id]},
       {type, ordered_set},
       {record_name, rank},
       {attributes, record_info(fields, rank)},
       {disc_copies, [node()]}
      ]},
     %% 金币消费排行榜
     {cost_gold_rank,
      [
       {index, [#rank.player_id]},
       {type, ordered_set},
       {record_name, rank},
       {attributes, record_info(fields, rank)},
       {disc_copies, [node()]}
      ]},
     %% 金币消费排行榜
     {world_boss_rank,
      [
       {index, [#rank.player_id]},
       {type, ordered_set},
       {record_name, rank},
       {attributes, record_info(fields, rank)},
       {disc_copies, [node()]}
      ]},
     %% 聊天
     {chats_world,
      [
       {type, ordered_set},
       {record_name, chats_world},
       {attributes, record_info(fields, chats_world)},
       {disc_copies, [node()]}
      ]},
      {chat_private,
      [
       {record_name, chat_private},
       {type, set},
       {attributes, record_info(fields, chat_private)},
       {index, [#chat_private.recv_id]},
       {disc_copies, [node()]}
      ]},
     {private_msg,
      [
       {record_name, private_msg},
       {type, set},
       {attributes, record_info(fields, private_msg)},
       {disc_copies, [node()]}
      ]},
     {chat_league,
      [
       {record_name, chat_league},
       {type, set},
       {attributes, record_info(fields, chat_league)},
       {disc_copies, [node()]}
      ]},
     {league_msg,
      [
       {record_name, league_msg},
       {type, set},
       {attributes, record_info(fields, league_msg)},
       {disc_copies, [node()]}
      ]},
     {lucky_coin,
      [
       {record_name, lucky_coin},
       {attributes, record_info(fields, lucky_coin)},
       {index, [#lucky_coin.recv, #lucky_coin.send]},
       {disc_copies, [node()]}
      ]},
     %% 自增ID
     {counter,
      [
       {record_name, counter},
       {attributes, record_info(fields, counter)},
       {disc_copies, [node()]}
      ]},
     %记录表clear的时间
     {server_config,
       [
        {record_name, server_config},
        {attributes, record_info(fields, server_config)},
        {disc_copies, [node()]}
       ]},
     {base_operators_mail,
      [
       {record_name, base_operators_mail},
       {attributes, record_info(fields, base_operators_mail)},
       {disc_copies, [node()]}
      ]},
     {ordinary_shop_msg,
      [
       {record_name, ordinary_shop_msg},
       {attributes, record_info(fields, ordinary_shop_msg)},
       {disc_copies, [node()]}
      ]},
     {main_shop_msg,
      [
       {record_name, main_shop_msg},
       {attributes, record_info(fields, main_shop_msg)},
       {disc_copies, [node()]}
      ]},
     {activity_shop_msg,
      [
       {record_name, activity_shop_msg},
       {attributes, record_info(fields, activity_shop_msg)},
       {disc_copies, [node()]}
      ]},
     {ordinary_shop,
      [
       {record_name, ordinary_shop},
       {attributes, record_info(fields, ordinary_shop)},
       %% {storage_properties, [{dets, [{ram_file, true}]}]},
       {disc_copies, [node()]}
      ]},
     {main_shop,
      [
       {record_name, main_shop},
       {attributes, record_info(fields, main_shop)},
       %% {storage_properties, [{dets, [{ram_file, true}]}]},
       {disc_copies, [node()]}
      ]},
     {league,
      [
       {attributes, record_info(fields, league)},
       {record_name, league},
       {index, [#league.name]},
       {disc_copies, [node()]}
      ]},
     {league_member,
      [
       {record_name, league_member},
       {attributes, record_info(fields, league_member)},
       {index, [#league_member.league_id]},
       %% {disc_copies, [node()]}
       {frag_properties, [{n_fragments, ?N_FRAGMENTS_16}, {n_disc_copies, 1}, {node_pool,[node()]}]},
       {disc_copies,[node()]}
      ]},
     %% {league_relation,
     %%  [
     %%   {attributes, record_info(fields, league_relation)},
     %%   {index, [#league_relation.league_group]},
     %%   {record_name, league_relation},
     %%   {disc_copies, [node()]}
     %%  ]},
     %% {league_apply_info,
     %%  [
     %%   {attributes, record_info(fields, league_apply_info)},
     %%   {record_name, league_apply_info},
     %%   {disc_copies, [node()]}
     %%  ]},
     %% {league_member_challenge,
     %%  [
     %%   {attributes, record_info(fields, league_member_challenge)},
     %%   {index, [#league_member_challenge.league_id]},
     %%   {record_name, league_member_challenge},
     %%   {disc_copies, [node()]}
     %%  ]},
     %% {league_challenge_record,
     %%  [
     %%   {attributes, record_info(fields, league_challenge_record)},
     %%   {index, [#league_challenge_record.league_id]},
     %%   {disc_copies, [node()]}
     %%  ]},
     %% {mdb_challenge_info,
     %%  [
     %%   {attributes, record_info(fields, mdb_challenge_info)},
     %%   {disc_copies, [node()]}
     %%  ]},     
     %% {league_fight_point,
     %%  [
     %%   {attributes, record_info(fields, league_fight_point)},
     %%   {index, [#league_fight_point.league_id]},
     %%   {disc_copies, [node()]}
     %%  ]},
     %% {league_fighter,
     %%  [
     %%   {attributes, record_info(fields, league_fighter)},
     %%   {index, [#league_fighter.vs_gid, #league_fighter.score, #league_fighter.group]},
     %%   {disc_copies, [node()]}
     %%  ]},
     {radar_msg,
      [
       {record_name, radar_msg},
       {attributes, record_info(fields, radar_msg)},
       {index, [
                #radar_msg.accuracy_thousand, 
                #radar_msg.accuracy_five_hundred,
                #radar_msg.accuracy_two_hundred
               ]},
       {disc_copies, [node()]}
      ]},
     {league_gifts,
      [
       {record_name, league_gifts},
       {attributes, record_info(fields, league_gifts)},
       {index, [#league_gifts.league_id]},
       {disc_copies, [node()]}
      ]},
     {league_gifts_record,
      [
       {record_name, league_gifts_record},
       {attributes, record_info(fields, league_gifts_record)},
       {index, [#league_gifts_record.league_id]},
       {disc_copies, [node()]}
      ]},
     {cross_pvp_fighter,
      [
       {record_name, cross_pvp_fighter},
       {attributes, record_info(fields, cross_pvp_fighter)},
       {index, [#cross_pvp_fighter.group]},
       %% {disc_copies, [node()]}
       {frag_properties, [{n_fragments, ?N_FRAGMENTS_16}, {n_disc_copies, 1}, {node_pool,[node()]}]},
       {disc_copies,[node()]}
      ]},
     %% {cross_pvp_report,
     %%  [
     %%   {index, [#async_arena_report.attack_id, #async_arena_report.deffender_id]},
     %%   {record_name, async_arena_report},
     %%   {attributes, record_info(fields, async_arena_report)},
     %%   {disc_copies, [node()]}
     %%  ]},
     %% {cross_pvp_history,
     %%  [
     %%   {index, [#cross_pvp_history.player_id]},
     %%   {attributes, record_info(fields, cross_pvp_history)},
     %%   {disc_copies, [node()]}
     %%  ]},
     {cross_pvp_enemy,
      [
       {record_name, cross_pvp_enemy},
       {attributes, record_info(fields, cross_pvp_enemy)},
       {index, [#cross_pvp_enemy.atk_id, #cross_pvp_enemy.def_id]},
       %% {disc_copies, [node()]}
       {frag_properties, [{n_fragments, ?N_FRAGMENTS_16}, {n_disc_copies, 1}, {node_pool,[node()]}]},
       {disc_copies,[node()]}
      ]},
     {league_recharge_gold_record,
      [
       {record_name, league_recharge_gold_record},
       {attributes, record_info(fields, league_recharge_gold_record)},
       {index, [#league_recharge_gold_record.league_id]},
       {disc_copies, [node()]}
      ]},
     {request_gifts_msg,
      [
       {record_name, request_gifts_msg},
       {attributes, record_info(fields, request_gifts_msg)},
       {index, [#request_gifts_msg.player_id]},
       {disc_copies, [node()]}
      ]},
     {own_gift,
      [
       {record_name, own_gift},
       {attributes, record_info(fields, own_gift)},
       {index, [#own_gift.player_id]},
       {disc_copies, [node()]}
      ]},
     {master_apprentice,
      [
       {record_name, master_apprentice},
       {attributes, record_info(fields, master_apprentice)},
       {index, [#master_apprentice.master_player_id,
                #master_apprentice.apprentice_player_id
               ]},
       {disc_copies, [node()]}
      ]},
     {fashion_record,
      [
       {record_name, fashion_record},
       {attributes, record_info(fields, fashion_record)},
       {disc_copies, [node()]}
      ]},
     %% ====================公共数据结束====================

     %% ====================临时数据====================
     %% 角色推荐表
     %% {player_rec,
     %%  [
     %%   {record_name, player},
     %%   {attributes, record_info(fields, player)}
     %%  ]},
     %% 统计信息相关表，都是ram_copies
     %% {mnesia_statistics,
     %%  [
     %%   {attributes, record_info(fields, mnesia_statistics)}
     %%  ]},
     %% {player_count, #player_count
     %%  [
     %%   {attributes, record_info(fields, player_count)}
     %%  ]},
     {node_status,
      [
       {record_name, node_status},
       {attributes, record_info(fields, node_status)}
      ]},
     {dungeon_match,
      [
       {record_name, dungeon_match},
       {index, [#dungeon_match.dungeon_type]},
       {attributes, record_info(fields, dungeon_match)}
      ]},
     {general_store,
      [
       {record_name, general_store},
       {attributes, record_info(fields, general_store)},
       {index, [
                #general_store.player_id,
                #general_store.store_type
               ]},
       {disc_copies, [node()]}
      ]},
     {fight_member,
      [
       {record_name, fight_member},
       {attributes, record_info(fields, fight_member)},
       {index, [
                #fight_member.league_id,
                #fight_member.player_lv
               ]},
       %% {disc_copies, [node()]}
       {frag_properties, [{n_fragments, ?N_FRAGMENTS_16}, {n_disc_copies, 1}, {node_pool,[node()]}]},
       {disc_copies,[node()]}
      ]},
     {fight_league,
      [
       {record_name, fight_league},
       {attributes, record_info(fields, fight_league)},
       {index, [
                #fight_league.group,
                #fight_league.sn,
                #fight_league.lv,
                #fight_league.rank,
                #fight_league.enemy_league_id
               ]},
       %% {disc_copies, [node()]}
       {frag_properties, [{n_fragments, ?N_FRAGMENTS_16}, {n_disc_copies, 1}, {node_pool,[node()]}]},
       {disc_copies,[node()]}
      ]},
     {fight_league_copy,
      [
       {record_name, fight_league_copy},
       {attributes, record_info(fields, fight_league_copy)},
       {disc_copies, [node()]}
      ]},
     {pay_info,
      [
       {record_name, pay_info},
       {attributes, record_info(fields, pay_info)},
       {index, [
                #pay_info.order_type,
                #pay_info.accid,
                #pay_info.player_id,
                #pay_info.server_id
               ]},
       {disc_copies, [node()]}
      ]},
     {g17_guild,
      [
       {record_name, g17_guild},
       {attributes, record_info(fields, g17_guild)},
       {index, [
                #g17_guild.guild_name,
                #g17_guild.owner_user_id
               ]},
       {disc_copies, [node()]}
      ]},
     {g17_guild_member,
      [
       {record_name, g17_guild_member},
       {attributes, record_info(fields, g17_guild_member)},
       {index, [
                #g17_guild_member.guild_id
               ]},
       %% {disc_copies, [node()]}
       {frag_properties, [{n_fragments, ?N_FRAGMENTS_16}, {n_disc_copies, 1}, {node_pool,[node()]}]},
       {disc_copies,[node()]}
      ]},
     {g17_guild_apply,
      [
       {record_name, g17_guild_apply},
       {attributes, record_info(fields, g17_guild_apply)},
       {index, [
                #g17_guild_apply.apply_guild_id,
                #g17_guild_apply.user_id
               ]},
       {disc_copies, [node()]}
      ]}

     %% ====================临时数据结束====================
    ].


%% 用来校验数据库数据的合法性
%% match_info(Table) ->
%%     all_record:match_info(Table).
    


get_def(Tab) ->
    {Tab, TabDef} = lists:keyfind(Tab, 1, definitions()),
    NewTabDef = "[" ++ string:join(lists:map(fun({disc_copies, _}) ->
                                                     "{disc_copies,[node()]}";
                                                ({disc_only_copies, _}) ->
                                                     "{disc_only_copies,[node()]}";
                                                (Val) ->
                                                     io_lib:format("~p", [Val])
                                             end, TabDef), ",") ++ "]",
    io:format("~p,~s~n",[Tab, NewTabDef]).
