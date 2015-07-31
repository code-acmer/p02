-module(data_module).
-compile(nowarn_unused_function).
-export([start/0, %% may be for test only, data_module_ctl always transfers options
         start/1,
         start/2,
         recompile_and_commit/0,
         tables/0,
         table_infos/0]).

-export([
         default_db_host/0,
         default_db_port/0,
         default_db_user/0,
         default_db_password/0,
         default_db_base/0,
         default_generate_dir/0,
         default_insert/0,
         default_jobs/0,
         default_excel_path/0
        ]).

-export([fprof/0]).

%% -export([
%%          get_fields/1 %% not public 内部接口 获取字段
%%         ]).
%% for apply(?MODULE, Fun, [])
-export([
         base_combat_skill_upgrade/0,
         base_combat_skill/0,
         base_combat_skill_strengthen/0,
         %base_dungeon/0,
         %base_fashion/0,
         base_function_open/0,
         base_login_reward/0,
         base_player/0,
         %%base_protocol/0, 废弃，不从数据库取，手动维护
         base_task/0,
         base_dungeon_area/0,
         base_dungeon_detail/0,
         base_dungeon_create_monster/0,
         base_dungeon_monsters_attribute/0,
         base_dungeon_create_portal/0,
         base_dungeon_object_attribute/0,
         base_dungeon_create_object/0,
         base_goods/0,
         base_error_list/0,
         base_goods_strengthen/0,
         base_dungeon_world_boss/0,
         base_daily_dungeon_lv/0,
         base_daily_dungeon_info/0,
         base_daily_dungeon_condition/0,
         base_goods_att_rand/0,
         base_goods_att_lv/0,
         base_goods_att_color/0,
         base_goods_jewel/0,
         base_goods_color_hole/0,
         base_params/0,
         base_rank_reward/0,
         base_mugen_tower/0,
         base_monster_level_attribute/0,
         base_shop/0,
         base_shop_activity/0,
         base_mail/0,
         base_pvp_robot_attribute/0,
         base_mysterious_shop/0,
         base_general_store/0,
         base_competitive_vice_shop/0,
         base_competitive_main_shop/0,
         base_xunzhang/0,
         base_dungeon_match/0,
         base_pvp_battle_reward/0,
         base_pvp_rank_reward/0,
         base_dungeon_target/0,
         base_skill_exp/0,
         base_choujiang/0,
         base_qianguizhe/0,
         base_month_reward/0,
         base_vip/0,
         base_vip_cost/0,
         base_kuafupvp_rank_reward/0,
         base_ability/0,
         base_guild_lv_exp/0,
         base_kuafupvp_robot_attribute/0,
         base_kuafupvp_battle_reward/0,
         base_guild_rank_integral/0,
         base_shop_content/0,
         base_notice/0,
         base_skill_card/0,
         base_fashion_combination/0
        ]).
-include_lib("kernel/include/file.hrl").
-include("define_data_generate.hrl").

%% data header file
-include("db_base_store_product.hrl").
-include("db_base_function_open.hrl").
-include("define_dungeon.hrl").
-include("db_base_activity_twist_egg.hrl").
-include("db_base_login_reward.hrl").
-include("db_base_combat_skill_upgrade.hrl").
-include("db_base_activity.hrl").
-include("db_base_combat_skill.hrl").
-include("db_base_combat_skill_strengthen.hrl").
-include("db_base_equipment.hrl").
-include("db_base_equipment_property.hrl").
-include("db_base_equipment_upgrade.hrl").
-include("db_base_fashion.hrl").
-include("db_base_mon.hrl").
-include("db_base_player.hrl").
-include("db_base_protocol.hrl").
-include("db_base_rate.hrl").
-include("db_base_twist_egg.hrl").
-include("db_base_params.hrl").
-include("db_base_task.hrl").
-include("db_base_dungeon_area.hrl").
-include("db_base_dungeon_detail.hrl").
-include("db_base_dungeon_create_monster.hrl").
-include("db_base_dungeon_monsters_attribute.hrl").
-include("db_base_dungeon_create_portal.hrl").
-include("db_base_dungeon_object_attribute.hrl").
-include("db_base_dungeon_create_object.hrl").
-include("db_base_error_list.hrl").
-include("db_base_goods_strengthen.hrl").
-include("define_logger.hrl").
-include("db_base_dungeon_world_boss.hrl").
-include("db_base_daily_dungeon_lv.hrl").
-include("db_base_daily_dungeon_info.hrl").
-include("db_base_daily_dungeon_condition.hrl").
-include("db_base_rank_reward.hrl").
-include("db_base_mugen_tower.hrl").
-include("define_goods.hrl").
-include("define_task.hrl").
-include("db_base_monster_level_attribute.hrl").
-include("define_boss.hrl").
-include("db_base_mail.hrl").
-include("db_base_pvp_robot_attribute.hrl").
-include("db_base_mysterious_shop.hrl").
-include("db_base_xunzhang.hrl").
-include("db_base_shop_activity.hrl").
-include("db_base_dungeon_match.hrl").
-include("db_base_pvp_battle_reward.hrl").
-include("db_base_pvp_rank_reward.hrl").
-include("db_base_skill_exp.hrl").
-include("db_base_choujiang.hrl").
-include("db_base_qianguizhe.hrl").
-include("db_base_competitive_vice_shop.hrl").
-include("db_base_competitive_main_shop.hrl").
-include("db_base_month_reward.hrl").
-include("db_base_vip.hrl").
-include("db_base_kuafupvp_rank_reward.hrl").
-include("db_base_kuafupvp_battle_reward.hrl").
-include("db_base_vip_cost.hrl").
-include("db_base_general_store.hrl").
-include("db_base_ability.hrl").
-include("db_base_guild_lv_exp.hrl").
-include("db_base_kuafupvp_robot_attribute.hrl").
-include("db_base_guild_rank_integral.hrl").
-include("db_base_shop_content.hrl").
-include("db_base_notice.hrl").
-include("db_base_skill_card.hrl").
-include("db_base_fashion_combination.hrl").

%% -define(DATA_TABLE_LIST, [base_combat_skill_upgrade, 
%%                           base_activity,                 
%%                           base_activity_twist_egg,
%%                           base_combat_skill,
%%                           base_dungeon,
%%                           base_equipment,
%%                           base_equipment_property,
%%                           base_equipment_upgrade,
%%                           base_fashion,
%%                           base_function_open,
%%                           base_login_reward,
%%                           base_mon,
%%                           base_player,
%%                           base_protocol,
%%                           base_rate,
%%                           base_store_product,
%%                           base_twist_egg,
%%                           base_params
%%                          ]).

-define(DEFAULT_OPTIONS, [
                          {db_host, default_db_host()},
                          {db_port, default_db_port()},
                          {db_user, default_db_user()}, 
                          {db_password, default_db_password()},
                          {db_base, default_db_base()},
                          {generate_dir, default_generate_dir()},
                          {jobs, default_jobs()},
                          {excel_path, default_excel_path()},
                          {insert_db, default_insert()}
                          ]).


%% -define(GET_FIELDS_FUN(TableName), get_fields(TableName) -> ?RECORD_FIELDS(TableName)).
%% %% 根据record名字获取其字段，被data_generate模块使用
%% %% 警告：出于性能考虑，业务模块不准这么用。
%% ?GET_FIELDS_FUN(base_function_open);
%% ?GET_FIELDS_FUN(base_store_product);
%% ?GET_FIELDS_FUN(data_dungeon);
%% ?GET_FIELDS_FUN(base_activity_twist_egg);
%% ?GET_FIELDS_FUN(base_login_reward);
%% ?GET_FIELDS_FUN(base_combat_skill_upgrade);
%% ?GET_FIELDS_FUN(data_base_activity);
%% ?GET_FIELDS_FUN(base_combat_skill);
%% ?GET_FIELDS_FUN(ets_base_equipment);
%% ?GET_FIELDS_FUN(ets_base_equipment_property);
%% ?GET_FIELDS_FUN(ets_base_equipment_upgrade);
%% ?GET_FIELDS_FUN(data_base_fashion);
%% ?GET_FIELDS_FUN(ets_base_mon);
%% ?GET_FIELDS_FUN(ets_base_player);
%% ?GET_FIELDS_FUN(ets_base_protocol);
%% ?GET_FIELDS_FUN(base_rate);
%% ?GET_FIELDS_FUN(base_twist_egg);
%% ?GET_FIELDS_FUN(base_params);
%% ?GET_FIELDS_FUN(base_task_test);
%% ?GET_FIELDS_FUN(base_task);
%% ?GET_FIELDS_FUN(base_dungeon_area);
%% ?GET_FIELDS_FUN(base_dungeon_detail);
%% ?GET_FIELDS_FUN(base_dungeon_create_monster);
%% ?GET_FIELDS_FUN(base_dungeon_monsters_attribute);
%% ?GET_FIELDS_FUN(base_dungeon_create_portal);
%% ?GET_FIELDS_FUN(base_dungeon_object_attribute);
%% ?GET_FIELDS_FUN(base_dungeon_create_object);
%% get_fields(RecordName) ->
%%     throw({not_fields, RecordName}).



fprof() ->
    fprof:trace(start),
    start(),
    fprof:trace(stop),
    fprof:profile(),
    fprof:analyse({dest, "data_module.txt"}).

%% 优化：多进程生成
mul_process(AllTables, Options) ->
    GenerateDir = generate_dir(Options),
    Jobs = jobs(Options),
    GenerateFun =
        fun(TableName) ->
                apply(data_generate, data_generate, [GenerateDir|?MODULE:TableName()])
        end,
    PidMRefs = [spawn_monitor(fun () -> 
                                      [GenerateFun(Table) || Table <- Tables]
                              end) ||
                   Tables <- list_split(AllTables, Jobs)],
    [receive
         {'DOWN', MRef, process, _, normal} -> 
             ok;
         {'DOWN', MRef, process, _, Reason} -> 
             exit(Reason)
     end || {_Pid, MRef} <- PidMRefs],
    ok.

start() ->
    start(tables(), ?DEFAULT_OPTIONS).
start(Tables) ->
    start(Tables, ?DEFAULT_OPTIONS).

start(TableName, Options) 
  when is_atom(TableName) ->
    start([TableName], Options);
start(TableNameList, Options) ->
    T1 = os:timestamp(),
    print_options_info(Options),
    GenerateDir = generate_dir(Options),
    data_generate:load_version_to_ets(GenerateDir),
    AllowTableList = sets:to_list(
                       sets:intersection(
                         sets:from_list(TableNameList), 
                         sets:from_list(tables()))),
    data_generate:ensure_deps_started(),
    data_generate:ensure_pool_added(Options),
    local_info_msg("AllowTableList ~p~n", [AllowTableList]),
    case proplists:get_value(insert_db, Options) of
        true ->
            excel_data_to_db(AllowTableList, Options);   %%excel数据表插入数据库
        _ ->
            skip
    end,
    mul_process(AllowTableList, Options),  %%生成data数据
    case TableNameList -- AllowTableList of
        [] ->
            ignore;
        IllegalTableList ->
            io:format("<<warning>> these tables ~p are not generated. because these are not in ~p~n", 
                      [IllegalTableList, tables()])
    end,
    data_generate:record_version_from_ets(GenerateDir),
    T2 = os:timestamp(),
    Times = timer:now_diff(T2, T1),
    io:format("~p: ~p microseconds~n", [?MODULE, Times]),
    %data_generate:rm_coding_comment(GenerateDir),
    ok.
%% -------------------- for data_module_ctl --------------------

tables() ->
    Functions = ?MODULE:module_info(exports),
    Tables = [ FName || {FName, _} <- lists:filter(
                                        fun ({FName, 0}) -> 
                                                case atom_to_list(FName) of
                                                    "base_" ++ _ ->
                                                        true;
                                                    _ ->
                                                        false
                                                end;
                                            ({_, _}) ->
                                                false
                                        end, Functions)],
    Tables.

default_db_host() ->
    app_misc:get_env(default_mysql_host).
    %proplists:get_value(db_host, ?DEFAULT_OPTIONS).

default_db_port() ->
    app_misc:get_env(default_mysql_port).

default_db_user() ->
    app_misc:get_env(default_mysql_user).

default_db_password() ->
    app_misc:get_env(default_mysql_password).

default_db_base() ->
    app_misc:get_env(default_db_base).

default_generate_dir() ->
    app_misc:get_env(generate_dir).

default_jobs() ->
    app_misc:get_env(jobs).

default_insert() ->
    app_misc:get_env(insert_db).

default_excel_path() ->
    app_misc:get_env(excel_path).

%% -------------------- 处理选项 --------------------
   
generate_dir(Options) ->
    %% "/home/roowe/happytree/server_p02/ebin/main.beam"
    Root = server_root(),
    case proplists:get_value(generate_dir, Options) of
        "/" ++ _ = Path ->
            Path;
        RelativePath ->
            filename:join(Root, RelativePath)
    end.

server_root() ->
    MainPath = code:which(main),
    io:format("MainPath ~p~n", [MainPath]),
    remove_suffix_ebin(MainPath).

remove_suffix_ebin(MainPath) ->
    Detal = length(MainPath) - length("ebin/main.beam"),
    lists:sublist(MainPath, Detal).

jobs(Options) ->
    proplists:get_value(jobs, Options).

print_options_info(Options) ->
    io:format("--------------------选项信息--------------------~n", []),
    io:format("数据库Host ~s~n", [proplists:get_value(db_host, Options)]),
    io:format("数据库端口 ~p~n", [proplists:get_value(db_port, Options)]),
    io:format("数据库用户名 ~s~n", [proplists:get_value(db_user, Options)]),
    io:format("数据库密码 ~s~n", [proplists:get_value(db_password, Options)]),
    io:format("数据库名字 ~s~n", [proplists:get_value(db_base, Options)]),
    io:format("数据的输出目录 ~s~n", [proplists:get_value(generate_dir, Options)]),
    io:format("生成数据的并发进程数 ~p~n", [proplists:get_value(jobs, Options)]),
    io:format("------------------------------------------------~n", []).

excel_data_to_db(TableList, Options) ->
    update_excel(Options),
    ExcelPath = proplists:get_value(excel_path, Options),
    DbUser = proplists:get_value(db_user, Options),
    DbPwd = proplists:get_value(db_password, Options),
    DbHost = proplists:get_value(db_host, Options),
    FileList = 
        filelib:wildcard(lists:concat([ExcelPath, "/**/*.xlsx"])),
    lists:foreach(fun(Table) ->
                          insert_data_to_db(Table, FileList, DbUser, DbPwd, DbHost)    
                  end, TableList -- [base_error_list, base_mail]).
    %%fix_dungeon_data(TableList). %关掉副本的修复

fix_dungeon_data(TableList) ->
    TList = 
    lists:filter(fun(Table) ->
                         lists:member(Table, [base_dungeon_create_monster, base_dungeon_create_object, base_dungeon_create_portal])
                 end, TableList),
    fix_dungeon_data:start(TList).

%% insert_data_to_db(Table, Options) ->
%%     TabStr = atom_to_list(Table),
%%     ExcelPath = proplists:get_value(excel_path, Options),
%%     CsvPath = "/tmp/" ++ TabStr ++ ".csv",
%%     ToCsvCmd = "xlsx2csv -i " ++ "\$(find " ++ ExcelPath ++ " -iname \"" ++ TabStr ++ ".xlsx\") " ++  CsvPath ++ " -d tab",
%%     ?PRINT("ToCsvCmd ~p~n", [ToCsvCmd]),
%%     case os:cmd(ToCsvCmd) of
%%         [] ->
%%             emysql:execute(db_base, "delete from " ++ TabStr), 
%%             InsertSql = "load data local infile \"" ++ CsvPath ++ "\" replace into table " ++ TabStr ++ " fields optionally enclosed by \"\\\"\" ignore 1 lines" ++ fields_for_load(Table, CsvPath),
%%             InsertCmd = "mysql -h" ++ proplists:get_value(db_host, Options) ++ " -u" ++
%%                 proplists:get_value(db_user, Options) ++ " -p" ++
%%                 proplists:get_value(db_password, Options) ++ " --local-infile=1 -e" ++ " \'use p02_base;" ++ InsertSql ++ ";\'", 
%%             ?PRINT("InsertCmd ~p~n", [InsertCmd]),
%%             os:cmd(InsertCmd);
%%         _ ->
%%             ?PRINT("data not found ~p~n", [Table])
%%     end.
insert_data_to_db(Table, FileList, DbUser, DbPwd, DbHost) ->
    TabStr = atom_to_list(Table),
    CsvPath = "/tmp/" ++ TabStr ++ ".csv",
    %% FileStr = os:cmd("find " ++ ExcelPath ++ " -iname " ++ TabStr ++ ".xlsx"),
    %% FileList = string:tokens(FileStr, "\n"),
    emysql:execute(db_base, "delete from " ++ TabStr),
    TarFileList =
        lists:filter(
          fun(File) ->
                  lists:suffix(TabStr ++ ".xlsx", File)
          end, FileList),
    lists:foreach(fun(File) ->
                          %?PRINT("File ~p~n", [File]),
                          ToCsvCmd = "xlsx2csv -i " ++ File ++ " " ++  CsvPath ++ " -d tab",
                          ?PRINT("ToCsvCmd ~p~n", [ToCsvCmd]),
                          insert_to_mysql(Table, TabStr, ToCsvCmd, CsvPath, DbUser, DbPwd, DbHost)
                  end, TarFileList).

insert_to_mysql(Table, TabStr, ToCsvCmd, CsvPath, DbUser, DbPwd, DbHost) ->
    T1 = os:timestamp(),
    case os:cmd(ToCsvCmd) of
        [] ->
            InsertSql = "load data local infile \"" ++ CsvPath ++ "\" replace into table " ++ TabStr ++ " fields optionally enclosed by \"\\\"\" ignore 1 lines" ++ fields_for_load(Table, CsvPath),
            InsertCmd = "mysql -h" ++ DbHost ++ " -u" ++
                DbUser ++ " -p" ++
                DbPwd ++ " --local-infile=1 -e" ++ " \'use p02_base;" ++ InsertSql ++ ";\'", 
            ?PRINT("InsertCmd ~p~n", [InsertCmd]),
            os:cmd(InsertCmd);
        Other ->
            ?PRINT("Other ~p~n", [Other]),
            ?PRINT("data not found ~p~n", [Table])
    end,
    T2 = os:timestamp(),
    Times = timer:now_diff(T2, T1),
    if
        Times > 1000000 ->
            ?WARNING_MSG("table cost too much time ~p ~p~n", [ToCsvCmd, Times]);
        true ->
            skip
    end,
    io:format("Table ~p Times ~p~n", [Table, Times]).

fields_for_load(Table, CsvPath) ->
    RecordFields = all_record:get_fields(table_record_info:record(Table)),
    %io:format("RecordFields ~p~n", [RecordFields]),
    {ok, Fd} = file:open(CsvPath, read),
    {ok, Line} = file:read_line(Fd),
    ok = file:close(Fd),
    CsvFields = string:tokens(Line, "\t"),
    ?QPRINT(CsvFields),
    FixFields = [begin
                     RemoveNField = string:strip(Field, both, $\n),
                     case lists:member(list_to_atom(RemoveNField), RecordFields) of
                         true ->
                             "`"++ RemoveNField ++"`";
                         false ->
                             io:format("RemoveNField ~p~n", [list_to_atom(RemoveNField)]),
                             "@`"++ RemoveNField ++"`"
                     end
                 end || Field <- CsvFields],
    "(" ++ string:join(FixFields, ",") ++ ")".

update_excel(Options) ->
    ExcelDir = proplists:get_value(excel_path, Options),
    io:format("ExcelDir ~p~n", [ExcelDir]),
    os:cmd("cd " ++ ExcelDir ++ " && git pull").

%%--------------------每张表的生成函数--------------------
base_activity() ->
    Fields = record_info(fields, data_base_activity),
    NewFields = trans_to_term(Fields, [req_time, value, range, key]),
    GetGenerateConf = default_get_generate_conf(NewFields, id,  nil),
    AllGenerateConf = default_all_generate_conf(id),
    [data_base_activity, base_activity, ["db_base_activity.hrl"],
     [GetGenerateConf, AllGenerateConf]].

%% 这是一个坑，同样的结构用了两张表，加下type会死呀。
%% 这个不是数据生成的好例子。
base_twist_egg() ->
    base_twist_egg(base_twist_egg).
base_activity_twist_egg() ->
    base_twist_egg(base_activity_twist_egg).

base_twist_egg(TableName) ->
    BaseGenerateConf = #generate_conf{                          
                          record_conf = all, 
                          handle_args_fun = fun(_RecordData) ->
                                                    null
                                            end, 
                          handle_result_fun = fun(_RecordData) ->
                                                      {tuple, [goods_id, rate]}
                                              end                          
                         },
    FilterDataFun = fun(Type) ->
                            fun(DataList) ->
                                    lists:filter(fun(#base_twist_egg{type=MType}) ->
                                                         MType =:= Type
                                                 end, DataList)
                            end
                    end,
    FilterGetFunData = fun(DataList) ->
                               %% 先过滤下一样的goods_id，然后再按id排回去
                               lists:keysort(#base_twist_egg.id, lists:ukeysort(#base_twist_egg.goods_id, DataList))
                       end,
    [base_twist_egg, TableName, [],
     [#generate_conf{
         fun_name = get,
         record_conf = single, 
         handle_args_fun = fun(_RecordData) ->
                                   goods_id
                           end, 
         handle_result_fun = fun(_RecordData) ->
                                     {single, att_lv}
                             end,
         filter = FilterGetFunData,
         default = nil
        },
      BaseGenerateConf#generate_conf{
        fun_name = get_gold_twist,
        filter = FilterDataFun(2)
       },
      BaseGenerateConf#generate_conf{
        fun_name = get_friend_val_twist,
        filter = FilterDataFun(1)
       },
      BaseGenerateConf#generate_conf{
        fun_name = get_extra_twist_egg,                                   
        filter = FilterDataFun(3)
       }
     ]].

base_combat_skill() ->
    AfterTransTermFields = trans_to_term(record_info(fields, base_combat_skill), [condition]),
    GenerateConf = default_get_generate_conf(AfterTransTermFields, id),
    FilterFun = fun(DataList)->
                        DataList
                end,
    GenerateConf1 = 
        #generate_conf{
           fun_name = get_all_skills_ids, 
           record_conf = all, 
           handle_args_fun = fun(_RecordData) ->
                                     null
                             end, 
           handle_result_fun = fun(_RecordData) ->
                                       {single, id}
                               end,
           filter = FilterFun
          },
    [base_combat_skill, 
     [#generate_conf{
         fun_name = get_unique_skills, 
         record_conf = {more, unique_id}, 
         handle_result_fun = fun(_RecordData) ->
                                     {single, id}
                             end
        }, 
      GenerateConf,
      GenerateConf1
     ]].
    

base_combat_skill_upgrade() ->
    AfterTransTermFields = trans_to_term(record_info(fields, base_combat_skill_upgrade), [consume, add_attr]),
    [base_combat_skill_upgrade, 
     [default_get_generate_conf(AfterTransTermFields,
                                id)]].

base_combat_skill_strengthen() ->
    AfterTransTermFields = trans_to_term(record_info(fields, base_combat_skill_strengthen), [consume]),
    [base_combat_skill_strengthen, 
     [default_get_generate_conf(AfterTransTermFields,
                                id)]].
%% base_dungeon() ->
%%     Fields = record_info(fields, data_dungeon),
%%     AfterDelFields = del_fields(Fields, [session_pos, goal, extra_goal, icon]), 
%%     AfterTransTermFields = trans_to_term(AfterDelFields, [req_time,monsters]),
%%     AfterTransRecordFields = trans_to_record(AfterTransTermFields,
%%                                              [{reward, common_reward},
%%                                               {extra_reward, common_reward},
%%                                               {special_reward, common_reward}]),
%%     LastFields = AfterTransRecordFields,
%%     [data_dungeon, base_dungeon, ["define_dungeon.hrl"],
%%      [#generate_conf{
%%          fun_name = get_dungeon,
%%          record_conf = single, 
%%          handle_args_fun = fun(_RecordData) ->
%%                                    id
%%                            end, 
%%          handle_result_fun = fun(_RecordData) ->
%%                                      {record, LastFields}
%%                              end
%%         }, 
%%       #generate_conf{
%%          fun_name = get_next_dungeon,
%%          record_conf = single, 
%%          handle_args_fun = fun(_RecordData) ->
%%                                    req_pre_id
%%                            end, 
%%          handle_result_fun = fun(_RecordData) ->
%%                                      {single, [id]}
%%                              end,
%%          filter = fun(DataList) ->
%%                           lists:filter(fun(#data_dungeon{req_pre_id=ReqPreId}) ->
%%                                                ReqPreId =/= 0
%%                                        end, DataList)
%%                   end
%%         }
%%      ]].
base_equipment() ->
    Fields = record_info(fields, ets_base_equipment),
    AfterDelFields = del_fields(Fields, [nid, desc, extra_goal]), 
    AfterTransTermFields = trans_to_term(AfterDelFields, [master_skills, ext_rate]),
    LastFields = AfterTransTermFields,
    [ets_base_equipment, base_equipment, ["db_base_equipment.hrl"],
     [#generate_conf{
         fun_name = get_base_goods,
         record_conf = single, 
         handle_args_fun = fun(_RecordData) ->
                                   id
                           end, 
         handle_result_fun = fun(_RecordData) ->
                                     {record, LastFields}
                             end
        }]].

base_equipment_property() ->
    Fields = record_info(fields, ets_base_equipment_property),
    AfterDelFields = del_fields(Fields, [memo]), 
    LastFields = AfterDelFields,
    [ets_base_equipment_property, base_equipment_property, ["db_base_equipment_property.hrl"],
     [default_get_generate_conf(LastFields, id)]].

base_equipment_upgrade() ->
    Fields = record_info(fields, ets_base_equipment_upgrade),
    AfterTransTermFields = trans_to_term(Fields, [next_id]),
    LastFields = AfterTransTermFields,
    [ets_base_equipment_upgrade, base_equipment_upgrade, ["db_base_equipment_upgrade.hrl"],
     [default_get_generate_conf(LastFields, id)]].

base_fashion() ->
    Fields = record_info(fields, data_base_fashion),
    GenerateConf = default_get_generate_conf(Fields, id, nil),    
    [data_base_fashion, base_fashion, ["db_base_fashion.hrl"],
     [#generate_conf{
         fun_name = get_career_fashion, 
         record_conf = {more, career}, 
         handle_result_fun = fun(_RecordData) ->
                                     {single, id}
                             end
        }, GenerateConf]].

base_function_open() ->
    [base_function_open,
     [#generate_conf{
         fun_name = get,
         args_count = 3,
         record_conf = single, 
         handle_args_fun = fun(_RecordData) ->
                                   [type, career, req_lv]
                           end, 
         handle_result_fun = fun(_RecordData) ->
                                     {record, [type,req_lv,career,{open, to_term}]}
                             end,
         warning_not_find = false
        }]].
base_login_reward() ->
    AfterTransTermFields = trans_to_term(record_info(fields, base_login_reward), [reward]), 
    [base_login_reward, 
     [default_get_generate_conf(AfterTransTermFields, 
                                id)]].
    %% [base_login_reward,
    %%  [#generate_conf{
    %%      fun_name = get, 
    %%      record_conf = single, 
    %%      handle_args_fun = fun(#base_login_reward{
    %%                               day_info = DayInfoStr
    %%                              }) ->
    %%                                case bitstring_to_term(DayInfoStr) of
    %%                                    Day when is_integer(Day) ->
    %%                                        lists:concat(["(", Day,") ->\n"]);
    %%                                    {Begin, End} ->
    %%                                        lists:concat(["(Day) when Day >= ", Begin, 
    %%                                                      " andalso Day =< ", End, 
    %%                                                      " ->\n"])
    %%                                end
    %%                        end, 
    %%      handle_result_fun = fun(_RecordData) ->
    %%                                  {record, [id, {day_info, to_term}, {reward, to_term}, desc]}
    %%                          end
    %%     }]].

base_mon() ->
    Fields = record_info(fields, ets_base_mon),
    AfterDelFields = del_fields(Fields, [active_skill]), 
    AfterTransRecordFields = trans_to_record(AfterDelFields,
                                             [{mon_drop, common_reward}]),
    LastFields = AfterTransRecordFields,
    [ets_base_mon, base_mon, ["db_base_mon.hrl"],
     [default_get_generate_conf(LastFields, id)]].

base_player() ->
    Fields = record_info(fields, ets_base_player),
    FilterFun = fun(DataList) ->
                        [lists:foldl(fun(#ets_base_player{lv = Lv} = BasePlayer, #ets_base_player{lv = AccLv} = AccPlayer) ->
                                            if
                                                Lv > AccLv ->
                                                    BasePlayer;
                                                true ->
                                                    AccPlayer
                                            end
                                    end, #ets_base_player{lv = 0}, DataList)]
                end,
    GetGenerateConf = 
        #generate_conf{
           fun_name = get_player_max_lv, 
           record_conf = all, 
           handle_args_fun = fun(_RecordData) ->
                                     null
                             end, 
           handle_result_fun = fun([#ets_base_player{lv = Lv}]) ->
                                       integer_to_list(Lv)
                               end,
           filter = FilterFun
          },
    [ets_base_player, base_player, ["db_base_player.hrl"],
     [default_get_generate_conf(Fields, lv),
      GetGenerateConf]].

%% base_protocol() ->
%%     Fields = record_info(fields, ets_base_protocol),
%%     LastFields = trans_to_term(Fields, [c2s, s2c]),
%%     [ets_base_protocol, base_protocol, ["db_base_protocol.hrl"],
%%      [default_get_generate_conf(LastFields, id)]].

base_rate() ->
    Fields = record_info(fields, base_rate),
    _LastFields = trans_to_term(Fields, [key, value]),
    [base_rate,
     [#generate_conf{
         fun_name = get, 
         record_conf = single, 
         handle_args_fun = fun(#base_rate{
                                  key = Key
                                 }) ->
                                   lists:concat(["(", binary_to_list(Key), ") ->\n"])
                           end, 
         handle_result_fun = fun(_RecordData) ->
                                     {single, {value, to_term}}
                             end,
         default = nil
        }]].

base_store_product() ->
    GetGenerateConf = default_get_generate_conf(record_info(fields, base_store_product), id),
    GetByTypeConf = default_more_generate_conf(get_by_type, type, id),
    [base_store_product,
     [GetGenerateConf,
      GetByTypeConf
     ]].

base_params() ->
    GetGenerateConf = default_get_generate_conf(trans_to_term(?RECORD_FIELDS(base_params), [name, value]), id),

    GetValueByIdConf = #generate_conf{
                          fun_name = get_value_by_id, 
                          record_conf = single, 
                          handle_args_fun = fun(_RecordData) ->
                                                    id
                                            end, 
                          handle_result_fun = fun(_RecordData) ->
                                                      {single, {value, to_term}}
                                              end
                         },
    GetValueByNameConf = #generate_conf{
                            fun_name = get_value_by_name, 
                            record_conf = single, 
                            handle_args_fun = fun(#base_params{
                                                     name = Name
                                                    }) ->
                                                      lists:concat(["(", binary_to_list(Name), ") ->\n"])
                                              end, 
                            handle_result_fun = fun(_RecordData) ->
                                                        {single, {value, to_term}}
                                                end
                           },
    GetAllListConf = #generate_conf{
                        fun_name = get_all_list, 
                        record_conf = all, 
                        handle_args_fun = fun(_RecordData) ->
                                                  null
                                          end, 
                        handle_result_fun = fun(_RecordData) ->
                                                    {single, id}
                                            end
      },
    [base_params,
     [GetGenerateConf,
      GetValueByIdConf,
      GetValueByNameConf,
      GetAllListConf
     ]].

base_task() -> 
    Fields = record_info(fields, base_task),          %%trans_to_record 是把reward转成common_reward结构
    AfterTransTermFields = trans_to_term(Fields, [level, time, condition, reward, double_time, end_time]), 
    GetGenerateConf = default_get_generate_conf(AfterTransTermFields, id),        %%生成数据
    %% GetByTypeConf = default_more_generate_conf(get_by_type, type, id),
    GetGenerateConf2 = default_all_generate_conf(id),
    FilterFun = fun(DataList) ->
                        lists:filter(fun(#base_task{type = ?TASK_TYPE_MAIN}) ->
                                             false;
                                        (#base_task{type = ?TASK_TYPE_ACHIEVE}) ->
                                             false;
                                        (_) ->
                                             true
                                     end, DataList)
                end,                     
    GetGenerateConf3 = #generate_conf{
                          fun_name = get_task_but_main, 
                          record_conf = all, 
                          handle_args_fun = fun(_RecordData) ->
                                                    null
                                            end, 
                          handle_result_fun = fun(_RecordData) ->
                                                      {single, id}
                                              end,
                          filter = FilterFun
                         },
%% FilterKe
    [base_task,
     [GetGenerateConf,
      GetGenerateConf2,
      GetGenerateConf3
     ]].

base_dungeon_detail() ->
    AfterTransTermFields = trans_to_term(record_info(fields, base_dungeon_detail),
                                         [portal_create_id,
                                          monster_create_id,
                                          object_create_id,
                                          decoration_create_id]),
    [base_dungeon_detail, 
     [default_get_generate_conf(AfterTransTermFields, 
                                id)]].

base_dungeon_area() ->   
    Fields = record_info(fields, base_dungeon_area),
    AfterTransTermFields = trans_to_term(Fields, [score_reward, req_time, pay_card_consume,
                                                  sub_dungeon_id, relive_cost, target_reward,
                                                  hit_reward, hit_reward_detail, boss_skill_piece]), 
    TransFun = fun(Val) ->
                       ListVal = binary_to_list(Val),
                       %io:format("ListVal ~ts~n", [ListVal]),
                       re:replace(ListVal, "{([0-9])", lists:concat(["{common_reward,",  "\\1"]),
                                  [global, {return, list}])
               end,
    AddFunFields = trans_to_record_manual(AfterTransTermFields, [free_card_reward, pay_card_reward, reward, first_reward], TransFun),
    GetGenerateConf = default_get_generate_conf(AddFunFields, id),        %%生成数据
    %% GetByTypeConf = default_more_generate_conf(get_by_type, type, id),
    FilterFun = fun(DataList) ->
                        MugenList = 
                            lists:filter(fun(#base_dungeon_area{dungeon_id = 119900}) ->
                                                 true;
                                            (_) ->
                                                 false
                                         end, DataList),
                        SortList = lists:keysort(#base_dungeon_area.id, MugenList),
                        if
                            SortList =:= [] ->
                                [];
                            true ->
                                [hd(SortList), hd(lists:reverse(SortList))]
                        end
                end,
    FilterSuperBattleFun = fun(DataList) ->
                        SuperBattleList = 
                            lists:filter(fun(#base_dungeon_area{dungeon_id = 119010}) ->
                                                 true;
                                            (_) ->
                                                 false
                                         end, DataList),
                        SortList = lists:keysort(#base_dungeon_area.id, SuperBattleList),
                        if
                            SortList =:= [] ->
                                [];
                            true ->
                                [hd(SortList), hd(lists:reverse(SortList))]
                        end
                end,
    FilterFun2 = fun(DataList) ->
                         lists:filter(fun
                                          (#base_dungeon_area{type = 3,
                                                              dungeon_type = 1}) ->
                                              true;
                                          (_) ->
                                              false
                                      end, DataList)
                 end,
    FilterFun4 = fun(DataList) ->
                         lists:ukeysort(#base_dungeon_area.lv, FilterFun2(DataList))
                 end,  
    GetGenerateConf2 = #generate_conf{
                          fun_name = get_mugen_id_range, 
                          record_conf = all, 
                          handle_args_fun = fun(_RecordData) ->
                                                      null
                                              end,
                          handle_result_fun = fun(_RecordData) ->
                                                      {single, id}
                                              end,
                          filter = FilterFun
                         },
    GetGenerateConf6 = #generate_conf{
                          fun_name = get_super_battle_id_range, 
                          record_conf = all, 
                          handle_args_fun = fun(_RecordData) ->
                                                    null
                                            end,
                          handle_result_fun = fun(_RecordData) ->
                                                      {single, id}
                                              end,
                          filter = FilterSuperBattleFun
                         }, 
    GetGenerateConf3 = #generate_conf{
                          fun_name = get_dungeon_by_lv, 
                          record_conf = {more, lv}, 
                          handle_result_fun = fun(_RecordData) ->
                                                      {single, id}
                                              end,
                          filter = FilterFun2
                         }, 
    GetGenerateConf4 = 
        #generate_conf{
           fun_name = get_dungeon_all_lv, 
           record_conf = all, 
           handle_args_fun = fun(_RecordData) ->
                                     null
                             end, 
           handle_result_fun = fun(_RecordData) ->
                                       {single, lv}
                               end,
           filter = FilterFun4
          },
    GetGenerateConf5 = 
        #generate_conf{
           fun_name = get_dungeon_all_id, 
           record_conf = all, 
           handle_args_fun = fun(_RecordData) ->
                                     null
                             end, 
           handle_result_fun = fun(_RecordData) ->
                                       {single, id}
                               end,
           filter = FilterFun2
          },
    FilterFun7 = fun(DataList) ->
                         lists:filter(fun
                                          (#base_dungeon_area{type = 3,
                                                              dungeon_type = 5}) ->
                                             true;
                                          (_) ->
                                             false
                                     end, DataList)
                 end,
    GetGenerateConf7 = #generate_conf{
                          fun_name = get_daily_dungeon_by_lv, 
                          record_conf = {more, lv}, 
                          handle_result_fun = fun(_RecordData) ->
                                                      {single, id}
                                              end,
                          filter = FilterFun7
                         }, 
    FilterFun8 = fun(DataList) ->
                         lists:filter(fun (#base_dungeon_area{
                                              type = 3,
                                              dungeon_type = 1,
                                              id = Id
                                             }) ->
                                             Id rem 10 =:= 1;
                                          (_) ->
                                             false
                                     end, DataList)
                 end,
     GetGenerateConf8 = #generate_conf{
                          fun_name = get_ordinary_dungeon_by_lv, 
                          record_conf = {more, lv}, 
                          handle_result_fun = fun(_RecordData) ->
                                                      {single, id}
                                              end,
                          filter = FilterFun8
                         }, 
    GetGenerateConf9 = #generate_conf{
                          fun_name = get_series_ids, 
                          record_conf = {more, dungeon_id}, 
                          handle_result_fun = fun(_RecordData) ->
                                                      {single, id}
                                              end,
                          filter = FilterFun2
                         }, 
    [base_dungeon_area,
     [GetGenerateConf,
      GetGenerateConf2,
      GetGenerateConf6,
      GetGenerateConf3,
      GetGenerateConf4,
      GetGenerateConf5,
      GetGenerateConf7,
      GetGenerateConf8,
      GetGenerateConf9
     ]].

base_dungeon_create_monster() ->
    AfterTransTermFields = trans_to_term(record_info(fields, base_dungeon_create_monster), [create_range, create_probability]), 
    [base_dungeon_create_monster, 
     [default_get_generate_conf(AfterTransTermFields, 
                                id)]].

base_dungeon_monsters_attribute() ->
    TransFun = fun(Val) ->
                       ListVal = binary_to_list(Val),
                                                %io:format("ListVal ~ts~n", [ListVal]),
                       re:replace(ListVal, "{([0-9])", lists:concat(["{common_reward,",  "\\1"]),
                                  [global, {return, list}])
               end,
    Fileds = record_info(fields, base_dungeon_monsters_attribute),
    AddFunFields = trans_to_record_manual(Fileds, [mon_drop, mon_drop2], TransFun),
    GetGenerateConf = default_get_generate_conf(AddFunFields, id),        %%生成数据
    %% GetByTypeConf = default_more_generate_conf(get_by_type, type, id),
    [base_dungeon_monsters_attribute,
     [GetGenerateConf
     ]].


base_dungeon_create_portal() ->
    AfterTransTermFields = trans_to_term(record_info(fields, base_dungeon_create_portal), [create_range]), 
    [base_dungeon_create_portal,
     [default_get_generate_conf(AfterTransTermFields, id)]].

base_dungeon_object_attribute() ->
    Fields = record_info(fields, base_dungeon_object_attribute),
    TransFun = fun(Val) ->
                       ListVal = binary_to_list(Val),
                       re:replace(ListVal, "{([0-9])", lists:concat(["{common_reward,",  "\\1"]),
                                  [global, {return, list}])
               end,
    AfterTransTermFields = trans_to_record_manual(Fields, [object_drop], TransFun),

    GetGenerateConf = default_get_generate_conf(AfterTransTermFields, id),        %%生成数据
    %% GetByTypeConf = default_more_generate_conf(get_by_type, type, id),
    [base_dungeon_object_attribute,
     [GetGenerateConf
     ]].

base_dungeon_create_object() ->
    AfterTransTermFields = trans_to_term(record_info(fields, base_dungeon_create_object), [create_range, create_probability]), 
    [base_dungeon_create_object, 
     [default_get_generate_conf(AfterTransTermFields, 
                                id)]].

base_goods() ->
    Fields = trans_to_term(record_info(fields, base_goods), [reward, consume, value_meteorite]),

    TransFun = fun(Val) ->
                       ListVal = binary_to_list(Val),
                       re:replace(ListVal, "{([0-9])", lists:concat(["{common_reward,",  "\\1"]),
                                  [global, {return, list}])
               end,
    AfterTransTermFields = trans_to_record_manual(Fields, [decomposition], TransFun),

    FilterFun = fun(DataList) ->
                        lists:filter(fun
                                         (#base_goods{type = ?TYPE_GOODS_EQUIPMENT}) ->                                             
                                            true;
                                         (_) ->
                                            false
                                    end, DataList)
                end,
    FilterFun2 = fun(DataList) ->
                         lists:ukeysort(#base_goods.lv, FilterFun(DataList))
                 end,
    GetGenerateConf = #generate_conf{
                         fun_name = get_equip_by_lv, 
                         record_conf = {more, lv}, 
                         handle_result_fun = fun(_RecordData) ->
                                                     {single, id}
                                             end,
                         %% filter = FilterFun(?TYPE_GOODS_EQUIPMENT)
                         filter = FilterFun
                        },
    GetGenerateConf2 = 
        #generate_conf{
           fun_name = get_equip_all_lv, 
           record_conf = all, 
           handle_args_fun = fun(_RecordData) ->
                                     null
                             end, 
           handle_result_fun = fun(_RecordData) ->
                                       {single, lv}
                               end,
           filter = FilterFun2
          },
    FilterFun3_0 = fun(DataList) ->
                           DataLists = 
                               lists:filter(fun
                                                (#base_goods{
                                                    type = ?TYPE_GOODS_JEWEL,
                                                    lv = Lv
                                                   }) ->
                                                    Lv > 1;
                                                (_) ->
                                                    false
                                            end, DataList),
                           DataLists
                               
                   end,
    GetGenerateConf3 = #generate_conf{
                          fun_name = get_jewel_all_lv_not_1, 
                          record_conf = all,
                          handle_args_fun = fun(_RecordData) ->
                                                    null
                                            end, 
                          handle_result_fun = fun(_RecordData) ->
                                                      {single, id}
                                              end,
                          filter = FilterFun3_0
                         },
    FilterFun4 = fun(DataList) ->
                         DataList                             
                 end,
    GetGenerateConf4 = #generate_conf{
                          fun_name = get_equip_all_id, 
                          record_conf = all,
                          handle_args_fun = fun(_RecordData) ->
                                                    null
                                            end, 
                          handle_result_fun = fun(_RecordData) ->
                                                      {single, id}
                                              end,
                          filter = FilterFun4
                         },
     GetGenerateConf5 = #generate_conf{
                          fun_name = get_all_id, 
                          record_conf = all,
                          handle_args_fun = fun(_RecordData) ->
                                                    null
                                            end, 
                          handle_result_fun = fun(_RecordData) ->
                                                      {single, id}
                                              end
                         },
    FilterFun6 = fun(DataList) ->
                         DataLists = 
                             lists:filter(fun(#base_goods{ sub_type = ?TYPE_GOODS_PAY_SUBTYPE }) ->
                                                  true;
                                             (_) ->
                                                  false
                                          end, DataList),
                           DataLists
                               
                   end,
    GetGenerateConf6 = #generate_conf{
                          fun_name = get_all_pay_gift_id, 
                          record_conf = all,
                          handle_args_fun = fun(_RecordData) ->
                                                    null
                                            end, 
                          handle_result_fun = fun(_RecordData) ->
                                                      {single, id}
                                              end,
                          filter = FilterFun6
                         },
    [base_goods, 
     [default_get_generate_conf(AfterTransTermFields, 
                                id),
      GetGenerateConf,
      GetGenerateConf2,
      GetGenerateConf3,
      GetGenerateConf4,
      GetGenerateConf5,
      GetGenerateConf6
     ]].
base_error_list() ->
    Fields = record_info(fields, base_error_list), 
    [base_error_list, 
     [default_get_generate_conf(Fields, error_code)]].

base_goods_strengthen() ->
    AfterTransTermFields = trans_to_term(record_info(fields, base_goods_strengthen), [consume, material]), 
    [base_goods_strengthen, 
     [default_get_generate_conf(AfterTransTermFields, 
                                id)]].

base_dungeon_world_boss() ->
    AfterTransTermFields = 
        trans_to_term(record_info(fields, base_dungeon_world_boss), 
                      [consume, open_time, open_date, close_date]),
    TransFun = fun(Val) ->
                       ListVal = binary_to_list(Val),
                                                %io:format("ListVal ~ts~n", [ListVal]),
                       re:replace(ListVal, "{([0-9])", lists:concat(["{common_reward,",  "\\1"]),
                                  [global, {return, list}])
               end,
    AddFunFields = trans_to_record_manual(AfterTransTermFields, [summon_reward, challengers_reward], TransFun),
    GenerateConf = 
        #generate_conf{
           fun_name = get_all_id, 
           record_conf = all,
           handle_args_fun = fun(_RecordData) ->
                                     null
                             end, 
           handle_result_fun = fun(_RecordData) ->
                                       {single, id}
                               end
          },
    GetGenerateConf1 = 
        #generate_conf{
           fun_name = player_boss_id, 
           record_conf = all, 
           handle_args_fun = fun(_RecordData) ->
                                     null
                             end, 
           handle_result_fun = fun(_RecordData) ->
                                       {single, id}
                               end,
           filter = fun(DataList) ->
                            lists:filter(fun(#base_dungeon_world_boss{type = ?BOSS_TYPE_PLAYER}) ->
                                                 true;
                                            (_) ->
                                                 false
                                         end, DataList)
                    end
          },
    GetGenerateConf2 = 
        #generate_conf{
           fun_name = sys_boss_id, 
           record_conf = all, 
           handle_args_fun = fun(_RecordData) ->
                                     null
                             end, 
           handle_result_fun = fun(_RecordData) ->
                                       {single, id}
                               end,
           filter = fun(DataList) ->
                            lists:filter(fun(#base_dungeon_world_boss{type = ?BOSS_TYPE_SYSTEM}) ->
                                                 true;
                                            (_) ->
                                                 false
                                         end, DataList)
                    end
          },
    [base_dungeon_world_boss, 
     [default_get_generate_conf(AddFunFields, 
                                id),
      GenerateConf,
      GetGenerateConf1,
      GetGenerateConf2]].

base_daily_dungeon_lv() ->
    AfterTransTermFields = trans_to_term(record_info(fields, base_daily_dungeon_lv), [lv]), 
    [base_daily_dungeon_lv, 
     [default_get_generate_conf(AfterTransTermFields, 
                                id)]].

base_daily_dungeon_info() ->
    AfterTransTermFields = trans_to_term(record_info(fields, base_daily_dungeon_info), [lv, lv_condition, pass_condition]),
    HandleArgsFun = fun(#base_daily_dungeon_info{lv = Lv}) ->
                            [From, To] = hmisc:bitstring_to_term(Lv),
                               "(Lv) when Lv >= " ++ integer_to_list(From) ++
                                   " andalso Lv =< " ++ integer_to_list(To) ++ " ->\n"
                       end,
    GenerateConf = #generate_conf{
                      fun_name = get, 
                      record_conf = single, 
                      handle_args_fun = HandleArgsFun,
                      handle_result_fun = fun(_RecordData) ->
                                                  {record, AfterTransTermFields}
                                          end,
                      default = []
                     },
    [base_daily_dungeon_info, 
     [GenerateConf]].

base_daily_dungeon_condition() ->
    Fields = record_info(fields, base_daily_dungeon_condition),
    [_|FieldList] = Fields,
    HandleResultFun = fun(Record) ->
                              [_, _|ValueList] = tuple_to_list(Record),
                              TupleList = lists:zip(FieldList, ValueList),
                              hmisc:term_to_string(TupleList)
                          end,
    GetGenerateConf = 
        #generate_conf{
           fun_name = get, 
           record_conf = single, 
           handle_args_fun = fun(_RecordData) ->
                                     id
                             end, 
           handle_result_fun = HandleResultFun,
           default = []
          },
    [base_daily_dungeon_condition, 
     [GetGenerateConf]].

base_goods_att_rand() ->
    Fields = record_info(fields, base_goods_att_rand),
    [_|FieldList] = Fields,
    HandleResultFun = fun(Record) ->
                              [_, _|ValueList] = tuple_to_list(Record),
                              TupleList = lists:zip(FieldList, ValueList),
                              hmisc:term_to_string(TupleList)
                      end,
    GetGenerateConf = 
        #generate_conf{
           fun_name = get, 
           record_conf = single, 
           handle_args_fun = fun(_RecordData) ->
                                     id
                             end, 
           handle_result_fun = HandleResultFun,
           default = []
          },
    [base_goods_att_rand,
     [GetGenerateConf]].

base_goods_att_lv() ->
    Fields = trans_to_term(record_info(fields, base_goods_att_lv), [id]),
    HandleArgsFun = fun(#base_goods_att_lv{id = Lv}) ->
                            [From, To] = hmisc:bitstring_to_term(Lv),
                            "(Lv) when Lv >= " ++ integer_to_list(From) ++
                                " andalso Lv =< " ++ integer_to_list(To) ++ " ->\n"
                    end,
    GenerateConf = #generate_conf{
                      fun_name = get, 
                      record_conf = single, 
                      handle_args_fun = HandleArgsFun,
                      handle_result_fun = fun(_RecordData) ->
                                                  {record, Fields}
                                          end,
                      default = []
                     },
    [base_goods_att_lv, 
     [GenerateConf]].

base_goods_att_color() ->
    Fields = record_info(fields, base_goods_att_color),
    [base_goods_att_color,
     [default_get_generate_conf(Fields, id)]].

base_goods_jewel() ->
    Fields = trans_to_term(record_info(fields, base_goods_jewel), [meterial, price]),
    [base_goods_jewel,
     [default_get_generate_conf(Fields, id)]].

base_goods_color_hole() ->
    Fields = record_info(fields, base_goods_color_hole),
    GenerateConf = 
        #generate_conf{
           fun_name = get, 
           record_conf = single, 
           handle_args_fun = fun(_RecordData) ->
                                     id
                             end, 
           handle_result_fun = fun(_RecordData) ->
                                       {record, Fields}
                               end,
           default = [],
           warning_not_find = false
          },
    [base_goods_color_hole,
     [GenerateConf]].

base_rank_reward() ->
    Fields = trans_to_term(record_info(fields, base_rank_reward),
                           [world_boss1, world_boss2, world_boss3, super_battle, mugen, battle_ability, golden, coins, boss_open]),
    GenerateConf = 
        #generate_conf{
           fun_name = get, 
           record_conf = single, 
           handle_args_fun = fun(_RecordData) ->
                                     id
                             end, 
           handle_result_fun = fun(_RecordData) ->
                                       {record, Fields}
                               end,
           default = [],
           warning_not_find = false
          },
    [base_rank_reward,
     [GenerateConf]].

base_mugen_tower() ->
    Fields = trans_to_term(record_info(fields, base_mugen_tower), [challenge_reward, lucky_reward, normal_reward, reward1, reward2, 
                                                                   reward3, reward4, skip_cost1, skip_cost2]),
    FilterFun = fun(DataList) ->
                        lists:foldl(fun(#base_mugen_tower{id = Id}, [#base_mugen_tower{id = Min}, #base_mugen_tower{id = Max}]) ->
                                            NewMin = 
                                                if 
                                                    Min =:= 0 ->
                                                        Id;
                                                    true ->
                                                        min(Id, Min)
                                                end,
                                            NewMax = max(Max, Id),
                                            [#base_mugen_tower{id = NewMin}, #base_mugen_tower{id = NewMax}]
                                    end, [#base_mugen_tower{}, #base_mugen_tower{}], DataList)
                end,
    GetGenerateConf2 = #generate_conf{
                          fun_name = get_mugen_id_range, 
                          record_conf = all, 
                          handle_args_fun = fun(_RecordData) ->
                                                    null
                                            end,
                          handle_result_fun = fun(_RecordData) ->
                                                      {single, id}
                                              end,
                          filter = FilterFun
                         },
    [base_mugen_tower,
     [default_get_generate_conf(Fields, id),
      GetGenerateConf2]].

base_monster_level_attribute() ->
    Fields = record_info(fields, base_monster_level_attribute), 
    [base_monster_level_attribute,
     [default_get_generate_conf(Fields, id)]].

base_shop() ->
    Fields = trans_to_term(record_info(fields, base_shop), [consume]),
    FilterFun = fun(DataList) ->
                        DataList
                end,
    GetGenerateConf = #generate_conf{
                         fun_name = get_all_shop_id, 
                         record_conf = all, 
                         handle_args_fun = fun(_RecordData) ->
                                                   null
                                           end, 
                         handle_result_fun = fun(_RecordData) ->
                                                     {single, id}
                                             end,
                         filter = FilterFun
                        },
    GetGenerateConf1 = #generate_conf{
                          fun_name = get_shop_id_by_type, 
                          record_conf = {more, type},
                          handle_result_fun = fun(_RecordData) ->
                                                      {single, id}
                                              end
                         },
    [base_shop,
     [default_get_generate_conf(Fields, id),
      GetGenerateConf,
      GetGenerateConf1
     ]].

base_shop_activity() ->
    Fields = trans_to_term(record_info(fields, base_shop_activity),[start_time, last_time,shop_ids]), 
    FilterFun = fun(DataList) ->
                        DataList
                end,
    GetGenerateConf = #generate_conf{
                         fun_name = get_all_id, 
                         record_conf = all, 
                         handle_args_fun = fun(_RecordData) ->
                                                   null
                                           end, 
                         handle_result_fun = fun(_RecordData) ->
                                                     {single, id}
                                             end,
                         filter = FilterFun
                        },
    [base_shop_activity,
     [default_get_generate_conf(Fields, id),
      GetGenerateConf
     ]].

base_mail() ->
    Fields = record_info(fields, base_mail),
    [base_mail,
     [default_get_generate_conf(Fields, id)]].

base_pvp_robot_attribute() ->
    Fields = record_info(fields, base_pvp_robot_attribute),
    GenerateConf = 
        #generate_conf{
           fun_name = get_all_id, 
           record_conf = all,
           handle_args_fun = fun(_RecordData) ->
                                     null
                             end, 
           handle_result_fun = fun(_RecordData) ->
                                       {single, id}
                               end
          },
    FilterFun = fun(DataList) ->
                        lists:ukeysort(#base_pvp_robot_attribute.robot_id, DataList)
                end,
    GenerateConf1 = 
        #generate_conf{
           fun_name = get_id_by_robot_id, 
           record_conf = {more, robot_id}, 
           handle_result_fun = fun(_RecordData) ->
                                     {single, id}
                             end,
           
           filter = FilterFun
        },
    [base_pvp_robot_attribute,
     [default_get_generate_conf(Fields, id),
      GenerateConf,
      GenerateConf1
     ]].

base_mysterious_shop()->
    Fields = trans_to_term(record_info(fields, base_mysterious_shop), [consume]),
    GenerateConf = 
        #generate_conf{
           fun_name = get_all_id, 
           record_conf = all,
           handle_args_fun = fun(_RecordData) ->
                                     null
                             end, 
           handle_result_fun = fun(_RecordData) ->
                                       {single, id}
                               end
          },
    GenerateConf1 = 
        #generate_conf{
         fun_name = get_id_by_lv, 
         record_conf = {more, lv}, 
         handle_result_fun = fun(_RecordData) ->
                                     {single, id}
                             end
        },
    FilterFun = fun(DataList)->
                        lists:ukeysort(#base_mysterious_shop.lv, DataList)
                end,
    GenerateConf2 = 
        #generate_conf{
           fun_name = get_all_lv, 
           record_conf = all,
           handle_args_fun = fun(_RecordData) ->
                                     null
                             end, 
           handle_result_fun = fun(_RecordData) ->
                                       {single, lv}
                               end,
           filter = FilterFun
          },
    GenerateConf3 = 
        #generate_conf{
           fun_name = get_id_by_career, 
           record_conf = {more, career}, 
           handle_result_fun = fun(_RecordData) ->
                                     {single, id}
                             end
          },
    FilterFun4 = fun(DataList)->
                         lists:ukeysort(#base_mysterious_shop.career, DataList)
                 end,
    GenerateConf4 = 
        #generate_conf{
           fun_name = get_all_career, 
           record_conf = all,
           handle_args_fun = fun(_RecordData) ->
                                     null
                             end, 
           handle_result_fun = fun(_RecordData) ->
                                       {single, career}
                               end,
           filter = FilterFun4
          },
    GenerateConf5 = 
        #generate_conf{
           fun_name = get_id_by_lv_and_career, 
           record_conf = {more, [lv, career]},
           handle_args_fun = fun(_RecordData) ->
                                     null
                             end, 
           handle_result_fun = fun(_RecordData) ->
                                       {single, id}
                               end,
           warning_not_find = false
          },
    
    [base_mysterious_shop, 
     [default_get_generate_conf(Fields, id),
      GenerateConf,
      GenerateConf1,
      GenerateConf2,
      GenerateConf3,
      GenerateConf4,
      GenerateConf5
     ]].

base_general_store() ->
    Fields = trans_to_term(record_info(fields, base_general_store), [consume]),
    GenerateConf = 
        #generate_conf{
           fun_name = get_id_by_career_store_show, 
           record_conf = {more, [career, store_type, show_type]},
           handle_args_fun = fun(_RecordData) ->
                                     null
                             end, 
           handle_result_fun = fun(_RecordData) ->
                                       {single, id}
                               end,
           warning_not_find = false
          },
    [base_general_store, 
     [default_get_generate_conf(Fields, id),
      GenerateConf]].

base_competitive_vice_shop() ->
    Fields = trans_to_term(record_info(fields, base_competitive_vice_shop), [consume]),
    GenerateConf = 
        #generate_conf{
           fun_name = get_all_id, 
           record_conf = all,
           handle_args_fun = fun(_RecordData) ->
                                     null
                             end, 
           handle_result_fun = fun(_RecordData) ->
                                       {single, id}
                               end
          },
    GenerateConf1 = 
        #generate_conf{
         fun_name = get_id_by_lv, 
         record_conf = {more, lv}, 
         handle_result_fun = fun(_RecordData) ->
                                     {single, id}
                             end
        },
    FilterFun = fun(DataList)->
                        lists:ukeysort(#base_competitive_vice_shop.lv, DataList)
                end,
    GenerateConf2 = 
        #generate_conf{
           fun_name = get_all_lv, 
           record_conf = all,
           handle_args_fun = fun(_RecordData) ->
                                     null
                             end, 
           handle_result_fun = fun(_RecordData) ->
                                       {single, lv}
                               end,
           filter = FilterFun
          },
    GenerateConf3 = 
        #generate_conf{
           fun_name = get_id_by_career, 
           record_conf = {more, career}, 
           handle_result_fun = fun(_RecordData) ->
                                     {single, id}
                             end
          },
    FilterFun4 = fun(DataList)->
                         lists:ukeysort(#base_competitive_vice_shop.career, DataList)
                 end,
    GenerateConf4 = 
        #generate_conf{
           fun_name = get_all_career, 
           record_conf = all,
           handle_args_fun = fun(_RecordData) ->
                                     null
                             end, 
           handle_result_fun = fun(_RecordData) ->
                                       {single, career}
                               end,
           filter = FilterFun4
          },
    GenerateConf5 = 
        #generate_conf{
           fun_name = get_id_by_lv_and_career, 
           record_conf = {more, [lv, career]},
           handle_args_fun = fun(_RecordData) ->
                                     null
                             end, 
           handle_result_fun = fun(_RecordData) ->
                                       {single, id}
                               end,
           warning_not_find = false
          },
    
    [base_competitive_vice_shop, 
     [default_get_generate_conf(Fields, id),
      GenerateConf,
      GenerateConf1,
      GenerateConf2,
      GenerateConf3,
      GenerateConf4,
      GenerateConf5
     ]].    
base_competitive_main_shop() ->
    Fields = trans_to_term(record_info(fields, base_competitive_main_shop), [consume]),
    FilterFun = fun(DataList) ->
                        DataList
                end,
    GetGenerateConf = #generate_conf{
                         fun_name = get_all_shop_id, 
                         record_conf = all, 
                         handle_args_fun = fun(_RecordData) ->
                                                   null
                                           end, 
                         handle_result_fun = fun(_RecordData) ->
                                                     {single, id}
                                             end,
                         filter = FilterFun
                        },
    GetGenerateConf1 = #generate_conf{
                          fun_name = get_shop_id_by_type, 
                          record_conf = {more, type},
                          handle_result_fun = fun(_RecordData) ->
                                                      {single, id}
                                              end
                         },
    [base_competitive_main_shop,
     [default_get_generate_conf(Fields, id),
      GetGenerateConf,
      GetGenerateConf1
     ]].


base_xunzhang()->
    Fields = trans_to_term(record_info(fields, base_xunzhang), [consume]),
    [base_xunzhang, 
     [default_get_generate_conf(Fields, id)]].

base_dungeon_match() ->
    Fields = trans_to_term(record_info(fields, base_dungeon_match), [id]),
    HandleArgsFun = fun(#base_dungeon_match{id = Lv}) ->
                            [From, To] = hmisc:bitstring_to_term(Lv),
                            "(Lv) when Lv >= " ++ integer_to_list(From) ++
                                " andalso Lv =< " ++ integer_to_list(To) ++ " ->\n"
                    end,
    GenerateConf = #generate_conf{
                      fun_name = get, 
                      record_conf = single, 
                      handle_args_fun = HandleArgsFun,
                      handle_result_fun = fun(_RecordData) ->
                                                  {record, Fields}
                                          end,
                      default = []
                     },
    [base_dungeon_match, 
     [GenerateConf]].

base_pvp_battle_reward() ->
    Fields = trans_to_term(record_info(fields, base_pvp_battle_reward), [rank_range, win_reward, lose_reward]),
    HandleArgsFun = fun(#base_pvp_battle_reward{rank_range = Range}) ->
                            [From, To] = hmisc:bitstring_to_term(Range),
                            "(RankRange) when RankRange >= " ++ integer_to_list(From) ++
                                " andalso RankRange =< " ++ integer_to_list(To) ++ " ->\n"
                    end,
    GenerateConf = #generate_conf{
                      fun_name = get, 
                      record_conf = single, 
                      handle_args_fun = HandleArgsFun,
                      handle_result_fun = fun(_RecordData) ->
                                                  {record, Fields}
                                          end,
                      default = []
                     },
    [base_pvp_battle_reward,
     [GenerateConf]].

base_pvp_rank_reward() ->
    Fields = trans_to_term(record_info(fields, base_pvp_rank_reward), [rank_range, reward, disposable_rank_range, disposable_rank_reward]),
    HandleArgsFun = fun(#base_pvp_rank_reward{rank_range = Range}) ->
                            [From, To] = hmisc:bitstring_to_term(Range),
                            "(RankRange) when RankRange >= " ++ integer_to_list(From) ++
                                " andalso RankRange =< " ++ integer_to_list(To) ++ " ->\n"
                    end,
    HandleArgsFun1 = fun(#base_pvp_rank_reward{disposable_rank_range = Range}) ->
                             [From, To] = 
                                 if
                                     Range =:= [] ->
                                         [0, 0];
                                     true ->
                                         hmisc:bitstring_to_term(Range)
                                 end,
                             "(Rank) when Rank >= " ++ integer_to_list(From) ++
                                 " andalso Rank =< " ++ integer_to_list(To) ++ " ->\n"
                     end,
    GenerateConf = #generate_conf{
                      fun_name = get, 
                      record_conf = single, 
                      handle_args_fun = HandleArgsFun,
                      handle_result_fun = fun(_RecordData) ->
                                                  {record, Fields}
                                          end,
                      default = []
                     },
    GenerateConf1 = #generate_conf{
                       fun_name = get_reward_by_rank, 
                       record_conf = single, 
                       handle_args_fun = HandleArgsFun1,
                       handle_result_fun = fun(_RecordData) ->
                                                   {record, Fields}
                                           end,
                       default = [],
                       warning_not_find = false
                      },
    [base_pvp_rank_reward,
     [GenerateConf,
      GenerateConf1
     ]].

base_dungeon_target() ->
    Fields = trans_to_term(record_info(fields, base_dungeon_target), [condition, reward]),
    [base_dungeon_target,
     [default_get_generate_conf(Fields, id)]].

base_skill_exp() ->
    Fields = record_info(fields, base_skill_exp),
    [base_skill_exp,
     [default_get_generate_conf(Fields, id)]].

base_choujiang()->
    Fields = record_info(fields, base_choujiang),
    GenerateConf = 
        #generate_conf{
           fun_name = get_all_id, 
           record_conf = all,
           handle_args_fun = fun(_RecordData) ->
                                     null
                             end, 
           handle_result_fun = fun(_RecordData) ->
                                       {single, id}
                               end
          },
    GenerateConf1 = 
      #generate_conf{
           fun_name = get_id_by_lv_career_vip, 
           record_conf = {more, [lv, career, vip]},
           handle_args_fun = fun(_RecordData) ->
                                     null
                             end, 
           handle_result_fun = fun(_RecordData) ->
                                       {single, id}
                               end
          },
    [base_choujiang, 
     [default_get_generate_conf(Fields, id),
      GenerateConf,
      GenerateConf1
     ]].

base_qianguizhe()->
    Fields = record_info(fields, base_qianguizhe),
    GenerateConf = 
        #generate_conf{
           fun_name = get_all_id, 
           record_conf = all,
           handle_args_fun = fun(_RecordData) ->
                                     null
                             end, 
           handle_result_fun = fun(_RecordData) ->
                                       {single, id}
                               end
          },
    GenerateConf1 = 
      #generate_conf{
           fun_name = get_id_by_type_career, 
           record_conf = {more, [type, career]},
           handle_args_fun = fun(_RecordData) ->
                                     null
                             end, 
           handle_result_fun = fun(_RecordData) ->
                                       {single, id}
                               end
          },
    [base_qianguizhe, 
     [default_get_generate_conf(Fields, id),
      GenerateConf,
      GenerateConf1
     ]].

base_month_reward() ->
    Fields = trans_to_term(record_info(fields, base_month_reward), [reward]),
    [base_month_reward, 
     [default_get_generate_conf(Fields, id)]].

base_vip() ->
    Fields = trans_to_term(record_info(fields, base_vip), [vip_reward, day_benefits]),
    %%io:format("Fields: ~p", [Fields]),
    [base_vip, 
     [default_get_generate_conf(Fields, id)]].

base_vip_cost() ->
    Fields = trans_to_term(record_info(fields, base_vip_cost),
                           [day_vigor_cost,
                            day_resource_cost,        
                            mysterious_shop_cost,   
                            pvp_challange_times_cost, 
                            fair_shop_refresh_cost,   
                            cross_challange_times_cost,   
                            cross_shop_refresh_cost , 
                            king_dungeon_cost,    
                            pvp_shop_refresh_cost,  
                            fair_challange_times_cost,
                            guild_shop_refresh_cost
                           ]),
    [base_vip_cost, 
     [default_get_generate_conf(Fields, id)]].

base_kuafupvp_rank_reward() ->
    Fields = trans_to_term(record_info(fields, base_kuafupvp_rank_reward), [reward]),
    [base_kuafupvp_rank_reward, 
     [default_get_generate_conf(Fields, id)]].

base_ability() ->
    GenerateConf = 
        #generate_conf{
           fun_name = get, 
           record_conf = single,
           handle_args_fun = fun(#base_ability{ability = Range}) ->
                                     [Min, Max] = hmisc:bitstring_to_term(Range),
                                     "(Ability) when Ability >= " ++ integer_to_list(Min) ++ " andalso Ability =< "
                                       ++ integer_to_list(Max) ++ " ->\n"
                             end, 
           handle_result_fun = fun(_RecordData) ->
                                       {single, id}
                               end
          },
    [base_ability, 
     [GenerateConf]].

base_guild_lv_exp() ->
    Fields = record_info(fields, base_guild_lv_exp),
    GenerateConf = 
        #generate_conf{
           fun_name = get_all_lv, 
           record_conf = all,
           handle_args_fun = fun(_RecordData) ->
                                     null
                             end, 
           handle_result_fun = fun(_RecordData) ->
                                       {single, guild_level}
                               end
          },
    GenerateConf1 = 
        #generate_conf{
           fun_name = get_all_exp, 
           record_conf = all,
           handle_args_fun = fun(_RecordData) ->
                                     null
                             end, 
           handle_result_fun = fun(_RecordData) ->
                                       {single, guild_exp}
                               end
          },
    [base_guild_lv_exp, 
     [default_get_generate_conf(Fields, guild_level),
      GenerateConf,
      GenerateConf1
     ]].

base_kuafupvp_robot_attribute() ->
    Fields = record_info(fields, base_kuafupvp_robot_attribute),
    GenerateConf = 
        #generate_conf{
           fun_name = get, 
           record_conf = single,
           handle_args_fun = fun(#base_kuafupvp_robot_attribute{battle_ability = Ability}) ->
                                     "(Ability) when Ability =< " ++ integer_to_list(Ability) ++ " ->\n"
                             end, 
           handle_result_fun = fun(_RecordData) ->
                                       {record, Fields}
                               end
          },
    GenerateConf2 = 
        #generate_conf{
           fun_name = get_attr, 
           record_conf = single, 
           handle_args_fun = fun(_RecordData) ->
                                     robot_id
                             end, 
           handle_result_fun = fun(_RecordData) ->
                                       {record, Fields}
                               end,
           default = []
          },
    [base_kuafupvp_robot_attribute, 
     [GenerateConf,
      GenerateConf2]].

base_kuafupvp_battle_reward() ->
    %% Fields = record_info(fields, base_kuafupvp_battle_reward),
    Fields = trans_to_term(record_info(fields, base_kuafupvp_battle_reward), [power_range, win_reward]),
    GenerateConf = 
        #generate_conf{
           fun_name = get, 
           record_conf = single,
           handle_args_fun = fun(#base_kuafupvp_battle_reward{power_range =Range}) ->
                                       [LowAbility, HighAbility] = hmisc:bitstring_to_term(Range),
                                     "(Ability) when Ability >= " ++ integer_to_list(LowAbility) ++ " andalso Ability =<"++ integer_to_list(HighAbility) ++ " ->\n"
                             end, 
           handle_result_fun = fun(_RecordData) ->
                                       {record, Fields}
                               end
          },
    %% GenerateConf2 = 
    %%     #generate_conf{
    %%        fun_name = get_by_id, 
    %%        record_conf = single, 
    %%        handle_args_fun = fun(_RecordData) ->
    %%                                  id
    %%                          end, 
    %%        handle_result_fun = fun(_RecordData) ->
    %%                                    {record, Fields}
    %%                            end,
    %%        default = []
    %%       },
    [base_kuafupvp_battle_reward, 
     [GenerateConf]].

base_guild_rank_integral() ->
    Fields = record_info(fields, base_guild_rank_integral),
    [base_guild_rank_integral, 
     [default_get_generate_conf(Fields, id),
      default_all_generate_conf(id)
     ]].

base_shop_content() ->
    Fields = record_info(fields, base_shop_content),
    [base_shop_content, 
     [default_get_generate_conf(Fields, shop_id),
      default_all_generate_conf(shop_id)
     ]].
base_notice() ->
    Fields = trans_to_term(record_info(fields, base_notice), [show_time, activity_time, server_id]),                     
    GenerateConf = 
        #generate_conf{
           fun_name = notice_all_id, 
           record_conf = all,
           handle_args_fun = fun(_RecordData) ->
                                     null
                             end, 
           handle_result_fun = fun(_RecordData) ->
                                       {single, id}
                               end
          },
    [base_notice,
     [default_get_generate_conf(Fields, id),
      GenerateConf
     ]].

base_skill_card() ->
    Fields = trans_to_term(record_info(fields, base_skill_card), [attribute, teach_skill]), 
    [base_skill_card, 
     [default_get_generate_conf(Fields, card_id),
      default_all_generate_conf(card_id)
     ]].

base_fashion_combination() ->
    Fields = record_info(fields, base_fashion_combination), 
    [base_fashion_combination, 
     [default_get_generate_conf(Fields, id),
      default_all_generate_conf(id)
     ]].

%% --------------------recompile and git commit--------------------
recompile_and_commit() ->
    %%代码就不要提交了，因为会各种冲突，既然都生成了
    Root = server_root(),
    [_Node, _IP] = string:tokens(atom_to_list(node()), "@"),
    Cmd = "cd " ++ Root ++"; rebar compile; ",
    Return = os:cmd(Cmd),
    check_compile_return(hmisc:split_and_strip(Return, "\n", $ )).

check_compile_return(List) ->
    case 
        lists:foldl(fun(Str, AccList) ->
                            case Str of
                                "==>" ++ _ ->
                                    AccList;
                                _ ->
                                    lists:concat([Str, "</br>", AccList])
                            end
                    end, [], List) of
        [] ->
            ok;
        Other ->
            Other
    end.
    
    %% if
    %%     IP =:= "192.168.1.149" ->
    %%         %% 149 git version is old. not support --no-edit.
    %%         %Cmd = "cd " ++ Root ++"; rebar compile; git add src/data/*erl src/data/*txt; git commit -m 'data_generate auto commit'; git pull ; git push origin master; ";
    %%         Cmd = "cd " ++ Root ++"; rebar compile; ",
    %%         os:cmd(Cmd);
    %%     true ->
    %%         Cmd = "cd " ++ Root ++"; rebar compile; git add src/data/*erl src/data/*txt; git commit -m 'data_generate auto commit'; git pull --no-edit ; git push origin master; ",
    %%         local_info_msg("recompile_and_commit cmd ~p~n", [Cmd]),
    %%         Result = os:cmd(Cmd),
    %%         local_info_msg("recompile_and_commit ~p~n", [Result]),
    %%         Result
    %% end.

table_infos() ->
    Root = server_root(),
    lists:foldl(fun(Table, AccTableInfo) ->
                        case file:read_file_info(lists:concat([Root, "/ebin/data_", Table, ".beam"])) of
                            {ok, #file_info{mtime = Mtime}} ->
                                [{Table, Mtime}|AccTableInfo];
                            _ ->
                                AccTableInfo
                        end
                end, [], tables()).

%%-------------------- 内部函数 --------------------

default_get_generate_conf(GetFunFields, Key) ->
    default_get_generate_conf(GetFunFields, Key, []).

default_get_generate_conf(GetFunFields, Key, Default) ->  
    #generate_conf{
       fun_name = get, 
       record_conf = single, 
       handle_args_fun = fun(_RecordData) ->
                                 Key
                         end, 
       handle_result_fun = fun(_RecordData) ->
                                   {record, GetFunFields}
                           end,
       default = Default
      }.

default_all_generate_conf(Key) ->  
    #generate_conf{
       fun_name = all, 
       record_conf = all, 
       handle_args_fun = fun(_RecordData) ->
                                 null
                         end, 
       handle_result_fun = fun(_RecordData) ->
                                   {single, Key}
                           end
      }.
%% FilterKeyInfo can one or more
default_more_generate_conf(FunName, FilterKeyInfo, Id) ->
    #generate_conf{
       fun_name = FunName, 
       record_conf = {more, FilterKeyInfo}, 
       handle_result_fun = fun(_RecordData) ->
                                   {single, Id}
                           end
      }.

%% 加上转term的标志
trans_to_term(Fields, ToTermField) 
  when is_atom(ToTermField) ->
    trans_to_term(Fields, [ToTermField]);
trans_to_term(Fields, ToTermFieldList) ->
    lists:map(fun
                  (Field) when is_atom(Field) ->
                      case lists:member(Field, ToTermFieldList) of
                          true ->
                              {Field, to_term};
                          false ->
                              Field
                      end;
                  (Field) ->
                      Field
              end, Fields).

%% 将一些字段添加上转record标志
trans_to_record(Fields, {ToRecordField, RecordName}) 
  when is_atom(ToRecordField),
       is_atom(RecordName)->
    trans_to_record(Fields, [{ToRecordField, RecordName}]);
trans_to_record(Fields, ToRecordFieldList) ->
    lists:map(fun
                  (Field) when is_atom(Field) ->
                      case lists:keyfind(Field, 1, ToRecordFieldList) of
                          {_, RecordName} ->
                              {Field, to_record, RecordName};
                          false ->
                              Field
                      end;
                  (Field) ->
                      Field
              end, Fields).
trans_to_record_manual(Fields, TFieldList, HandleFun) -> %%支持多个字段，处理函数要自己写，应对trans_to_record没法处理的结构
    lists:map(fun(Field) ->
                      case lists:member(Field, TFieldList) of
                          true ->
                              {Field, HandleFun};
                          false ->
                              Field
                      end
              end, Fields).
%% 去掉一些字段
del_fields(Fields, DelField) 
  when is_atom(DelField)->
    del_fields(Fields, [DelField]);
del_fields(Fields, DelFieldList) ->
    lists:filter(fun
                     (Field) when is_atom(Field) ->
                         not lists:member(Field, DelFieldList);                     
                     (_) ->
                         true 
                 end, Fields).

list_split(L, N) -> 
    list_split0(L, [[] || _ <- lists:seq(1, N)]).

list_split0([], Ls) -> 
    Ls;
list_split0([I | Is], [L | Ls]) -> 
    list_split0(Is, Ls ++ [[I | L]]).


bitstring_to_term(undefined) -> 
    undefined;
bitstring_to_term(BitString) ->
    string_to_term(binary_to_list(BitString)).

string_to_term(String) ->
    case erl_scan:string(String++".") of
        {ok, Tokens, _} ->
            case erl_parse:parse_term(Tokens) of
                {ok, Term} -> 
                    Term;
                Err -> 
                    throw({err_string_to_term, Err})
            end;
        Error ->
            throw({err_string_to_term, Error})
    end.


%% Execute Fun using the IO system of the local node (i.e. the node on
%% which the code is executing).
with_local_io(Fun) ->
    GL = group_leader(),
    group_leader(whereis(user), self()),
    try
        Fun()
    after
        group_leader(GL, self())
    end.

%% Log an info message on the local node using the standard logger.
%% Use this if rabbit isn't running and the call didn't originate on
%% the local node (e.g. rabbitmqctl calls).
local_info_msg(Format, Args) ->
    with_local_io(fun () -> error_logger:info_msg(Format, Args) end).
