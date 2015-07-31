%% common_test suite for pp_handle

-module(goods_SUITE).
-include_lib("common_test/include/ct.hrl").
-include("define_goods.hrl").
-define(PLAYER_ID, 10000008).
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
-define(INIT_FUN, []).
all() ->
    [add_goods].

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
            main:server_start(),
            new_robot:test_pt(10000),
            timer:sleep(2000);
        true ->
            ingore
    end,
    Config.

%%--------------------------------------------------------------------
%% Function: end_per_suite(Config0) -> void() | {save_config,Config1}
%%
%% Config0 = Config1 = [tuple()]
%%   A list of key/value pairs, holding the test case configuration.
%%
%% Description: Cleanup after the suite.
%%--------------------------------------------------------------------
end_per_suite(_Config) ->
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
add_goods(Config) ->
    Pid = hmisc:whereis_player_pid(?PLAYER_ID),
    if
        is_pid(Pid) ->
            %%测试加单个物品
            {[#goods{base_id = 1}], 1} = 
                gen_server:call(Pid, {add_goods_test, [{1, 1, 0}], []}), 
            %%测试多个物品
            {GoodsList, 4} = 
                gen_server:call(Pid, {add_goods_test, [{1, 10, 1}], []}),  
            4 = length(GoodsList),
            %%背包有相同未满的物品
            {_GoodsList2, 3} =                                            
                gen_server:call(Pid, {add_goods_test, [{1, 10, 1}], [#goods{id = 110, 
                                                                            base_id = 1,
                                                                            sum = 1,
                                                                            max_overlap = 3
                                                                           }]}),
            %%不能叠加
            {_GoodsList3, 10} = 
                gen_server:call(Pid, {add_goods_test, [{2, 10, 1}], [#goods{id = 110, 
                                                                            base_id = 2,
                                                                            sum = 1,
                                                                            max_overlap = 1
                                                                           }]});
        true ->
            ct:fail(not_pid)
    end,
    Config.

