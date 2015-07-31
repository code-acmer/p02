%% common_test suite for pp_handle

-module(pp_handle_SUITE).
-include_lib("common_test/include/ct.hrl").
-include("define_robot.hrl").

-compile(export_all).

%%--------------------------------------------------------------------
%% Function: suite() -> Info
%%
%% Info = [tuple()]
%%   List of key/value pairs.
%%
%% Description: Returns list of tuples to set default properties
%%              for the suite.
%%
%% Note: The suite/0 function is only meant to be used to return
%% default data values, not perform any other operations.
%%--------------------------------------------------------------------
suite() -> [{timetrap, {minutes, 4}}].

%%--------------------------------------------------------------------
%% Function: groups() -> [Group]
%%
%% Group = {GroupName,Properties,GroupsAndTestCases}
%% GroupName = atom()
%%   The name of the group.
%% Properties = [parallel | sequence | Shuffle | {RepeatType,N}]
%%   Group properties that may be combined.
%% GroupsAndTestCases = [Group | {group,GroupName} | TestCase]
%% TestCase = atom()
%%   The name of a test case.
%% Shuffle = shuffle | {shuffle,Seed}
%%   To get cases executed in random order.
%% Seed = {integer(),integer(),integer()}
%% RepeatType = repeat | repeat_until_all_ok | repeat_until_all_fail |
%%              repeat_until_any_ok | repeat_until_any_fail
%%   To get execution of cases repeated.
%% N = integer() | forever
%%
%% Description: Returns a list of test case group definitions.
%%--------------------------------------------------------------------
groups() -> [].

%%--------------------------------------------------------------------
%% Function: all() -> GroupsAndTestCases
%%
%% GroupsAndTestCases = [{group,GroupName} | TestCase]
%% GroupName = atom()
%%   Name of a test case group.
%% TestCase = atom()
%%   Name of a test case.
%%
%% Description: Returns the list of groups and test cases that
%%              are to be executed.
%%
%%      NB: By default, we export all 1-arity user defined functions
%%--------------------------------------------------------------------
-define(INIT_FUN, [test_pp_handle_10000, test_pp_handle_10003, test_pp_handle_13001]).
all() ->
    [ {exports, Functions} | _ ] = ?MODULE:module_info(),
    FilterFunctions = [ FName || {FName, _} <- lists:filter(
                                                 fun ({module_info,_}) -> false;
                                                     ({all,_}) -> false;
                                                     ({init_per_suite,1}) -> false;
                                                     ({end_per_suite,1}) -> false;
                                                     ({Fun, 1}) -> 
                                                         not lists:member(Fun, ?INIT_FUN);
                                                     ({_,_}) -> false
                                                 end, Functions)],
                                                %?INIT_FUN ++ FilterFunctions.
    ?INIT_FUN ++ [test_pp_handle_13007,
                  test_pp_handle_13010,
                  %% test_pp_handle_13150,
                  %% test_pp_handle_13151,
                  %% test_pp_handle_13155,
                  %% test_pp_handle_13200,
                  %% test_pp_handle_13201,
                  %% test_pp_handle_13202,
                  %% test_pp_handle_13203,
                  %% test_pp_handle_13204,
                  %% test_pp_handle_13205,
                  %% test_pp_handle_13206,
                  %% test_pp_handle_13207,
                  %% test_pp_handle_13208,
                  %% test_pp_handle_13154, %% 删除好友放在最后来测试
                  test_pp_handle_13333,
                  test_pp_handle_13301, 
                  test_pp_handle_13300,
                  test_pp_handle_13400,
                  test_pp_handle_13310,
                  test_pp_handle_13500,
                  test_pp_handle_13305
                 ].

%%--------------------------------------------------------------------
%% Function: init_per_suite(Config0) ->
%%               Config1 | {skip,Reason} | {skip_and_save,Reason,Config1}
%%
%% Config0 = Config1 = [tuple()]
%%   A list of key/value pairs, holding the test case configuration.
%% Reason = term()
%%   The reason for skipping the suite.
%%
%% Description: Initialization before the suite.
%%
%% Note: This function is free to add any key/value pairs to the Config
%% variable, but should NOT alter/remove any existing entries.
%%--------------------------------------------------------------------
init_per_suite(Config) ->
    case Started = main:server_started() of
        false ->
            ok;
            %main:server_start();
        true ->
            ingore
    end,
    application:start(hstdlib),
    lib_robot:ensure_ibrowse_started(),
    lib_robot:ensure_logger(),
    Robot1 = #account_info{
                accname = "p03_robot_1",
                password = "p03_robot_1",
                register_name = robot_1,
                ip = "127.0.0.1",
                port = 8801,
                sn = 1
               },
    Robot2 = #account_info{
                accname = "p03_robot_2",
                password = "p03_robot_2",
                register_name = robot_2,
                ip = "127.0.0.1",
                port = 8801,
                sn = 1
               },
    case ct_robot:start(Robot1) of
        {ok, _RobotPid} ->
            Config2 = 
                [{robot_1, Robot1}, {started, Started}|Config],
            case ct_robot:start(Robot2) of
                {ok, _} ->
                    [{robot_2, Robot2}|Config2];
                Error ->
                    {skip, Error}
            end;
        Error ->
            ct:log("init_per_suite: ~p ~n",[Error]),
            {skip, Error}
    end.   

%%--------------------------------------------------------------------
%% Function: end_per_suite(Config0) -> void() | {save_config,Config1}
%%
%% Config0 = Config1 = [tuple()]
%%   A list of key/value pairs, holding the test case configuration.
%%
%% Description: Cleanup after the suite.
%%--------------------------------------------------------------------
end_per_suite(Config) ->
    case ?config(started, Config) of
        true ->
            ingore;
        false ->
            ok
            %main:server_stop()
    end,
    ok.

%%--------------------------------------------------------------------
%% Function: init_per_group(GroupName, Config0) ->
%%               Config1 | {skip,Reason} | {skip_and_save,Reason,Config1}
%%
%% GroupName = atom()
%%   Name of the test case group that is about to run.
%% Config0 = Config1 = [tuple()]
%%   A list of key/value pairs, holding configuration data for the group.
%% Reason = term()
%%   The reason for skipping all test cases and subgroups in the group.
%%
%% Description: Initialization before each test case group.
%%--------------------------------------------------------------------
init_per_group(_group, Config) ->
    Config.

%%--------------------------------------------------------------------
%% Function: end_per_group(GroupName, Config0) ->
%%               void() | {save_config,Config1}
%%
%% GroupName = atom()
%%   Name of the test case group that is finished.
%% Config0 = Config1 = [tuple()]
%%   A list of key/value pairs, holding configuration data for the group.
%%
%% Description: Cleanup after each test case group.
%%--------------------------------------------------------------------
end_per_group(_group, Config) ->
    Config.

%%--------------------------------------------------------------------
%% Function: init_per_testcase(TestCase, Config0) ->
%%               Config1 | {skip,Reason} | {skip_and_save,Reason,Config1}
%%
%% TestCase = atom()
%%   Name of the test case that is about to run.
%% Config0 = Config1 = [tuple()]
%%   A list of key/value pairs, holding the test case configuration.
%% Reason = term()
%%   The reason for skipping the test case.
%%
%% Description: Initialization before each test case.
%%
%% Note: This function is free to add any key/value pairs to the Config
%% variable, but should NOT alter/remove any existing entries.
%%--------------------------------------------------------------------
init_per_testcase(_TestCase, Config) ->
    Config.

%% init_per_testcase(_TestCase, Config) ->
%%     %%?DEBUG("Config ~p~n", [Config]),
%%     {_, SaveConfig} = ?config(saved_config, Config),
%%     Robot = ?config(robot, SaveConfig),
%%     EnsureConnectRobot = robot_tcp:ensure_connect(Robot),
%%     lib_robot:origin_saved_config(Config, {robot, EnsureConnectRobot}).

%%--------------------------------------------------------------------
%% Function: end_per_testcase(TestCase, Config0) ->
%%               void() | {save_config,Config1} | {fail,Reason}
%%
%% TestCase = atom()
%%   Name of the test case that is finished.
%% Config0 = Config1 = [tuple()]
%%   A list of key/value pairs, holding the test case configuration.
%% Reason = term()
%%   The reason for failing the test case.
%%
%% Description: Cleanup after each test case.
%%--------------------------------------------------------------------
end_per_testcase(_TestCase, _Config) ->
    %%ct:log("end_per_testcase Config ~p~n", [Config]),
    %% TestCase return save_config, it is save_config now. it changes saved_config when it run into new TestCase.
    %% case lib_robot:get_save_config(Config) of
    %%     undefined ->
    %%         case lib_robot:get_saved_config(Config) of
    %%             %% save 上上次的save_config
    %%             undefined ->
    %%                 ok;
    %%             SaveConfig ->
    %%                 {save_config, SaveConfig}
    %%         end;
    %%     _ ->
    %%         %% 正在保存，不需要做什么处理
    %%         ok
    %% end.
    ok.

%%========== pp_10 ==========

test_pp_handle_10000(Config) ->
    ct_robot:handle_cmd(?config(robot_1, Config), 10000, [{required_cmd, 10000}]),
    ct_robot:handle_cmd(?config(robot_2, Config), 10000, [{required_cmd, 10000}]).
    %% ChangeSendDataFun = fun({ok, SendPbRecord, Robot}) ->
    %%                             {ok, SendPbRecord, Robot};
    %%                        (Other) ->
    %%                             Other
    %%                     end,    
    %% ct_robot:handle_cmd(AccountInfo, 10000, [{required_cmd, 10000}, {handle_send_data, ChangeSendDataFun}]).

    
  
test_pp_handle_10003(Config) ->
    AccountInfo1 = ?config(robot_1, Config),
    AccountInfo2 = ?config(robot_2, Config),
    RegFun = fun(AccountInfo) ->
                     case ct_robot:get_robot(AccountInfo) of
                         #ct_robot{
                            player_id = PlayerId
                          } when PlayerId > 0 ->
                             ct_robot:handle_cmd(AccountInfo, 10003, [{required_cmd, 9001}]);
                         _ ->
                             ct_robot:handle_cmd(AccountInfo, 10003, [{required_cmd, 10003},
                                                                      {check_recv_pb_record_list_fun, 
                                                                       fun(_Robot, RecvPbRecordList) ->
                                                                               ?CT_MATCHES({_, #pbuserresult{
                                                                                                  result = 1
                                                                                                 }},
                                                                                           lists:keyfind(10003, 1, RecvPbRecordList))
                                                                       end}])
                     end
             end,
    RegFun(AccountInfo1),
    RegFun(AccountInfo2).

%%========== pp_13 ==========

%% 获取当前玩家的信息
test_pp_handle_13001(Config) ->
    ct_robot:handle_cmd(?config(robot_1, Config), 13001, [{required_cmd, 13001}]),
    ct_robot:handle_cmd(?config(robot_2, Config), 13001, [{required_cmd, 13001}]).

%% 领取登陆奖励
test_pp_handle_13007(Config) ->
    ct_robot:handle_cmd(?config(robot_1, Config), 13007, []).
%% 购买体力
test_pp_handle_13010(Config) ->
    SendBeforeFun = fun(Robot)->
                            %NewRobot1 = lib_robot:reset(Robot),
                            NewRobot1 = Robot,
                            NewRobot2 = lib_robot:ensuer_player_attri(coin, NewRobot1, 100000),
                            NewRobot3 = lib_robot:ensuer_player_attri(gold, NewRobot2, 100000),
                            {ok, NewRobot3}
                    end,
    ct_robot:handle_cmd(?config(robot_1, Config), 13010, [{send_before_hook, SendBeforeFun}]).
%% 获取其他玩家详细信息
test_pp_handle_13150(Config) ->
    PlayerId = lib_robot:get_player_id(Config, robot_2),
    ct_robot:handle_cmd(?config(robot_1, Config), 13150, [{required_cmd, [13150, 14000]},
                                                          {cmd_with_args, [PlayerId]}]).
%% 好友请求添加好友
test_pp_handle_13151(Config) ->
    PlayerId = lib_robot:get_player_id(Config, robot_2),
    ct_robot:handle_cmd(?config(robot_1, Config), 13151, [{required_cmd, [14000]},
                                                          {cmd_with_args, PlayerId}]).
%% 请求所有的好友信息，用于上线的时候处理
test_pp_handle_13155(Config) ->
    ct_robot:handle_cmd(?config(robot_1, Config), 13155, [{required_cmd, [14000]}]).

%% 创建队伍
test_pp_handle_13200(Config) ->
    ct_robot:handle_cmd(?config(robot_1, Config), 13200, [{required_cmd, [13205]}]).

%% 邀请好友进队， 给好友发送邀请信息
test_pp_handle_13201(Config) ->
    PlayerId = lib_robot:get_player_id(Config, robot_2),
    ct_robot:handle_cmd(?config(robot_1, Config), 13201, [{cmd_with_args, PlayerId}]).

%% 接受邀请加入队伍
test_pp_handle_13202(Config) ->
    ct_robot:handle_cmd(?config(robot_2, Config), 13202, [{required_cmd, [13202]}]).

%% 踢出队伍
test_pp_handle_13203(Config) ->
    PlayerId = lib_robot:get_player_id(Config, robot_2),
    ct_robot:handle_cmd(?config(robot_1, Config), 13203, [{cmd_with_args, PlayerId}]).

%% 离开队伍
test_pp_handle_13204(Config) ->
    test_pp_handle_13201(Config),
    test_pp_handle_13202(Config),
    ct_robot:handle_cmd(?config(robot_2, Config), 13204, [{required_cmd, [13204]}]).

%% 查看当前队伍信息
test_pp_handle_13205(Config) ->
    ct_robot:handle_cmd(?config(robot_1, Config), 13205, [{required_cmd, [13205]}]).

%% 准备
test_pp_handle_13206(Config) ->
    ct_robot:handle_cmd(?config(robot_1, Config), 13206, [{required_cmd, []}]).

%% 队长开始
test_pp_handle_13207(Config) ->
    ct_robot:handle_cmd(?config(robot_1, Config), 13207, []).

%% 组队聊天
test_pp_handle_13208(Config) ->
    ct_robot:handle_cmd(?config(robot_1, Config), 13208, [{cmd_with_args, "hello world"}]).

%% 删除好友
test_pp_handle_13154(Config) ->
    PlayerId = lib_robot:get_player_id(Config, robot_2),
    ct_robot:handle_cmd(?config(robot_1, Config), 13154, [{required_cmd, [14000]},
                                                          {cmd_with_args, PlayerId}]).
%% 获取技能列表
test_pp_handle_13333(Config)->
    %% SkillId = lib_robot:get_skill_id(Config, robot_1),
    %% ct:log("SkillId: ~p",[SkillId]),
    SendBeforeFun = fun(#ct_robot{
                           user = #pbuser{lv = Lv}
                          } = Robot)->
                            %% NewRobot1 = lib_robot:reset_lv(Robot, 23),
                            %% NewRobot2 = lib_robot:add_skill(NewRobot1, SkillId),
                            {ok, Robot}
                    end,
    ct_robot:handle_cmd(?config(robot_1, Config), 13333, [{required_cmd, [13333]}
                                                          %{send_before_hook, SendBeforeFun}
                                                         ]).
%% 技能强化
test_pp_handle_13301(Config) ->    
    ct_robot:handle_cmd(?config(robot_1, Config), 13301, [{required_cmd, [13333]}]).

%% 技能升级
test_pp_handle_13300(Config) ->    
    ct_robot:handle_cmd(?config(robot_1, Config), 13300, [{required_cmd, [13333]}]).

%% 增加战斗力
test_pp_handle_13400(Config) ->    
    ct_robot:handle_cmd(?config(robot_1, Config), 13400, [{required_cmd, [13400]}]).

%% 切换符印
test_pp_handle_13305(Config) -> 
    ct_robot:handle_cmd(?config(robot_1, Config), 13305, [{required_cmd, [13333]}]).


%% 附近的人推荐
test_pp_handle_13500(Config) ->    
    ct_robot:handle_cmd(?config(robot_1, Config), 13500, [{required_cmd, [13500]}]).

%% 绑定几个主动技能
test_pp_handle_13310(Config) ->    
    ct_robot:handle_cmd(?config(robot_1, Config), 13310, []).



%%========== pp_12 ==========
%%进入副本
test_pp_handle_12001(Config) ->
    SendBeforeFun = fun(Robot) ->
                            NRobot1 = lib_robot:add_bag(Robot, 1000),
                            NRobot2 = lib_robot:ensuer_player_attri(coin, NRobot1, 100),
                            NewRobot = lib_robot:ensuer_player_attri(vigor, NRobot2, 100),
                            {ok, NewRobot}
                    end,
    ct_robot:handle_cmd(?config(robot_1, Config),
                        12001,[{send_before_hook, SendBeforeFun}]
                       %% [{required_cmd, [12001]}]
                       ).
%% %%领取奖励
test_pp_handle_12002(Config) ->    
    ct_robot:handle_cmd(?config(robot_1, Config), 12002,
                        [{required_cmd, [13018]}
                         %% [{required_cmd, [13018,9002]},
                         %% [{required_cmd, [12002]}
                        ]).

%%========== pp_11 chat  ===========
%% test_pp_handle_11013(Config) ->
%%     ct_robot:handle_cmd(?config(robot_reg, Config),
%%                         11013, []).

%% test_pp_handle_11015(Config) ->
%%     RecvFun = fun(_Robot, RecvList) ->   %%注意这里RecvList [{30000,{}},  {9002, {}}]是这样的形式
%%                       ct:log("RecvList ~p~n", [RecvList]),
%%                       {11015, #pbprivate{send_list = PbDataSend,
%%                                          recv_list = PbDataRecv
%%                                         }} = lists:keyfind(11015, 1, RecvList),
%%                       ?CT_MATCHES([#pbprivatechat{}|_], PbDataSend)
%%               end,
%%     ct_robot:handle_cmd(?config(robot_reg, Config),
%%                         11015, [{required_cmd, 11015},
%%                                 {check_recv_pb_record_list_fun, RecvFun}]).

%%========== pp_15 goods ===========
%%查看背包物品
test_pp_handle_15000(Config) ->    
    SendBeforeFun = fun(#ct_robot{
                           user = PbUser
                          } = Robot) ->                            
                            {_Jewel, Meterial} = lib_robot:get_rand_jewel_id_and_meterial(),
                            #base_goods{
                               id = EquipId
                              } = lib_robot:get_equip(PbUser#pbuser.lv, PbUser#pbuser.career),
                            NewRobot0 = lib_robot:clean_goods_list(Robot),
                            NewRobot1 = lib_robot:add_bag(NewRobot0, 5000), %%GM增加背包容量
                            NewRobot2 = lib_robot:ensuer_player_attri(coin, NewRobot1, 200000), %%GM命令给钱
                            ct:log("EnsureId ~p",[EquipId]),
                            Goods = [{EquipId, 2},%% 加装备
                                     {240100101, 500}]++       %% 给升星加原材料
                                     Meterial ++ Meterial,     %% Meterial = [{宝石，数量}] 给两倍宝石原材料，镶嵌，合成，摘除，卸下一起操作
                            ct:log(" Goods : ~p ",[Goods]),
                            NewRobot3 = lib_robot:add_goods_list(NewRobot2, Goods),
                            ct:log(" NewGoods3 : ~p ",[NewRobot3]),
                            {ok, NewRobot3}
                    end,
    ct_robot:handle_cmd(?config(robot_1, Config), 15000, [{required_cmd, 15000},
                                                          {send_before_hook, SendBeforeFun}]).
%%穿装备
test_pp_handle_15100(Config) ->
    ct_robot:handle_cmd(?config(robot_1, Config), 15100, [{required_cmd, 15001}]).
%%卸下装备
test_pp_handle_15101(Config) ->
    ct_robot:handle_cmd(?config(robot_1, Config), 15101, [{required_cmd, 15001}]).
%%强化
test_pp_handle_15200(Config) ->
    AccountInfo = ?config(robot_1, Config),    
    ct_robot:handle_cmd(AccountInfo, 15200, [{required_cmd, [15001, 15200]}]).
%%升星
test_pp_handle_15201(Config) ->
    AccountInfo = ?config(robot_1, Config),
    ct_robot:handle_cmd(AccountInfo, 15201, [{required_cmd, [15001, 15201]}]).
%%传承
test_pp_handle_15020(Config)->
    ct_robot:handle_cmd(?config(robot_1, Config), 15020, [{required_cmd, [15001]}]).

%% %%卖出物品
%% test_pp_handle_15301(Config) ->
%%     SendBeforeFun = fun(Robot) ->
%%                             GoodsList = Robot#ct_robot.goods_list,
%%                             NewRobot = 
%%                                 if
%%                                     length(GoodsList) < 3 ->
%%                                         lib_robot:add_goods_list(Robot, lists:seq(50100001, 50100004));
%%                                     true ->
%%                                         Robot
%%                                 end,
%%                             {ok, NewRobot}
%%                     end,
%%     RobotReg = ?config(robot_1, Config),    
%%     ct_robot:handle_cmd(RobotReg, 15301, [{required_cmd, [15001, 15301]},
%%                                           {send_before_hook, SendBeforeFun}]).
%%宝石镶嵌
test_pp_handle_15401(Config)->
    ct_robot:handle_cmd(?config(robot_1, Config), 15401, [{required_cmd, [15001, 15401]}]).
%%宝石合成
test_pp_handle_15402(Config)->
    {JewelId, Meterial} = lib_robot:get_rand_jewel_id_and_meterial(),
    SendBeforeFun = fun(Robot) ->                  
                            NewRobot = lib_robot:add_goods_list(Robot, Meterial), %% 给宝石
                            {ok, NewRobot}
                    end,
    ct_robot:handle_cmd(?config(robot_1, Config), 15402, [{required_cmd, [15001, 15402]},
                                                          {send_before_hook, SendBeforeFun},
                                                          {cmd_with_args, JewelId}
                                                         ]).
%%宝石摘除
test_pp_handle_15403(Config)->
    ct_robot:handle_cmd(?config(robot_1, Config), 15403, [{required_cmd, [15001, 15403]}]).
%%卸下所有宝石
test_pp_handle_15404(Config)->
    test_pp_handle_15401(Config),
    ct_robot:handle_cmd(?config(robot_1, Config), 15404, [{required_cmd, [15001, 15404]}]).
%%分解装备
test_pp_handle_15010(Config)->
    ct_robot:handle_cmd(?config(robot_1, Config), 15010, [{required_cmd, [15001, 15010]}]).
%%扩充背包
test_pp_handle_15022(Config)->
    ct_robot:handle_cmd(?config(robot_1, Config), 15022, []).
%%商店购买
test_pp_handle_15030(Config)->
    %%选用用配置表中 vip 等级最低，当前在开放时间内的 shop 测试
    Shop = lib_robot:get_shop_id_by_vip_min_and_now(),    
    ct_robot:handle_cmd(?config(robot_1, Config), 15030, [{required_cmd, [15001]},
                                                          {cmd_with_args, Shop#base_shop.id}
                                                         ]).



%% %%%%%%%%%%%%%%%邮件系统测试
%% %%发邮件
%% test_pp_handle_19001(Config) ->
%%     Robot1 = ct_robot:get_robot(?config(robot_1, Config)),
%%     ct:log("Robot2 ~p~n", [ct_robot:get_robot(?config(robot_2, Config))]),
%%     RobotId1 = Robot1#ct_robot.player_id, 
%%     ct_robot:handle_cmd(?config(robot_2, Config),   %%用robot2 给 robot1发邮件
%%                         19001,  [{required_cmd, [9001,9002]},

%%                                  {handle_send_data, 
%%                                  fun({ok, Pbmail, Robot}) ->
%%                                          {ok, Pbmail#pbmail{recv_id = RobotId1}, Robot}
%%                                  end},

%%                                  {check_recv_pb_record_list_fun, 
%%                                   fun(_Robot, RecvPbRecordList) ->
%%                                           ?CT_MATCHES({_, #pberror{
%%                                                              error_code = 19000  %%邮件发送成功
%%                                                             }},
%%                                                       lists:keyfind(9001, 1, RecvPbRecordList))
%%                                   end}]).


%% %%获取邮件列表
%% test_pp_handle_19004(Config) ->
%%      RecvFun = fun(_Robot, RecvList) ->   %%注意这里RecvList [{30000,{}},  {9002, {}}]是这样的形式
%%                       ct:log("RecvList ~p~n", [RecvList]),
%%                       {19004, #pbmaillist{update_list = PbUpdateMailList
%%                                          }} = lists:keyfind(19004, 1, RecvList),
%%                       ?CT_MATCHES([#pbmail{}|_], PbUpdateMailList)
%%               end,
%%     ct_robot:handle_cmd(?config(robot_1, Config),
%%                         19004,  [{required_cmd, 19004},
%%                                 {check_recv_pb_record_list_fun, RecvFun}]).
%% %%删除邮件
%% test_pp_handle_19003(Config) ->
%%     AccountInfo = ?config(robot_1, Config),   
%%     ct_robot:handle_cmd(AccountInfo, 19003, [required_cmd, 19004]).
%% %%提取附件
%% test_pp_handle_19002(Config) ->
%%     SendBeforeFun = fun(Robot) ->
%%                             NewRobot1 = lib_robot:add_mail(Robot), 
%%                             {ok, NewRobot1}
%%                     end,
%%     RecvFun = fun(_Robot, RecvList) ->   %%注意这里RecvList [{30000,{}},  {9002, {}}]是这样的形式
%%                       ct:log("RecvList ~p~n", [RecvList]),
%%                       {19004, #pbmaillist{update_list = PbUpdateMailList
%%                                         }} = lists:keyfind(19004, 1, RecvList),
%%                       ?CT_MATCHES([#pbmail{state = 1}|_], PbUpdateMailList)
%%               end,
%%     AccountInfo = ?config(robot_1, Config),    
%%     ct_robot:handle_cmd(AccountInfo, 
%%                         19002, [{required_cmd, 19004},
%%                                 {check_recv_pb_record_list_fun, RecvFun},
%%                                 {send_before_hook, SendBeforeFun}]).

%%%%%%%%%%%%%%好友添加
%%拒绝好友
%% test_pp_handle_13152(Config) ->
%%     SendBeforeFun = fun(Robot) ->
%%                             NewRobot1 = lib_robot:deny_friend(Robot), 
%%                             {ok, NewRobot1}
%%                     end,
%%     RecvFun = fun(_Robot, RecvList) ->   %%注意这里RecvList [{30000,{}},  {9002, {}}]是这样的形式
%%                       {14000, #pbfriendlist{
%%                                  update_list = L1,
%%                                  delete_list = DeleteId
%%                                         }} = lists:keyfind(14000, 1, RecvList),
%%                       ?CT_MATCHES([#pbfriend{}|_], DeleteId)
%%               end,
%%     AccountInfo = ?config(robot_1, Config),     
%%     ct_robot:handle_cmd(AccountInfo, 
%%                         13152, [{required_cmd, 14000},
%%                                 {check_recv_pb_record_list_fun, RecvFun},
%%                                 {send_before_hook, SendBeforeFun}]).

%% test_pp_handle_13153(Config) ->
%%     SendBeforeFun = fun(Robot) ->
%%                             NewRobot1 = lib_robot:request_friend(Robot), 
%%                             {ok, NewRobot1}
%%                     end,
%%     RecvFun = fun(_Robot, RecvList) ->   %%注意这里RecvList [{30000,{}},  {9002, {}}]是这样的形式
%%                       {14000, #pbfriendlist{
%%                                  update_list = L1,
%%                                  delete_list = DeleteId
%%                                         }} = lists:keyfind(14000, 1, RecvList),
%%                       ?CT_MATCHES([#pbfriend{}|_], DeleteId)
%%               end,
%%     AccountInfo = ?config(robot_1, Config),    
%%     ct_robot:handle_cmd(AccountInfo, 
%%                         13153, [{required_cmd, 14000},
%%                                 {check_recv_pb_record_list_fun, RecvFun},
%%                                 {send_before_hook, SendBeforeFun}]).
%%========== pp_30 ===========
%% Opts 
%% {check_recv_pb_record_list_fun, F}  返回的数据的处理 
%% {required_cmd, CmdList}   返回的命令
%% {send_before_hook, SendBeforeFun} 注意SendBeforeFun不能进行对ct_robot发起call操作
%% {handle_send_data, Data}  对发出去的数据的处理
%% test_pp_handle_30000(Config) ->
%%     RecvFun = fun(_Robot, RecvList) ->   %%注意这里RecvList [{30000,{}},  {9002, {}}]是这样的形式
%%                       ct:log("RecvList ~p~n", [RecvList]),
%%                       {30000, #pbtasklist{task_list = TaskList}} = lists:keyfind(30000, 1, RecvList),
%%                       ?CT_MATCHES([#pbtask{}, #pbtask{}, #pbtask{}], TaskList)
%%               end,
%%     ct_robot:handle_cmd(?config(robot_reg, Config),
%%                         30000, [{required_cmd, [30000, 9002]},
%%                                 {check_recv_pb_record_list_fun, RecvFun}]).

%% test_pp_handle_30005(Config) ->
%%     ct_robot:handle_cmd(?config(robot_reg, Config), 30000, [{required_cmd, 30000}]),
    
%%     ChangeSendDataFun = fun({ok, Task, Robot}) ->
%%                                 {ok, Task, Robot}
%%                         end,
%%     ct_robot:handle_cmd(?config(robot_reg, Config), 
%%                         30005, 
%%                         [{required_cmd, 30000},
%%                          {handle_send_data, ChangeSendDataFun}
%%                          ]).


