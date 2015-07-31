-module(lib_robot).

-export([get_pb/2]).

-export([ensure_logger/0, ensure_ibrowse_started/0]).

-export([ensuer_player_attri/3,
         add_goods_list/2,
         clean_goods_list/1,
         reset/1,
         start_conut/1,
         reset_lv/2,
         get_sterious_shop/1,
         add_skill/2,
         recharge/2,
         add_sigil/2,
         goods_lvlup/3,
         get_sub_route/1,
         deny_friend/1,
         request_friend/1,
         add_mail/1,
         add_bag/2,
         handle_recv_data/2,
         get_rand_jewel_id_and_meterial/0,
         get_shop_id_by_vip_min_and_now/0,
         judge_color_hole/1,
         get_equip/2,
         traverse_base_goods/1,
         key_find_equip/2,
         get_player_id/2,
         get_player_lv/2,
         get_rand_dungeon/1,
         get_skill_id/1,
         get_skill/1,
         get_skill_by_str_lv/1,         
         get_skill_by_lv/2,
         get_skill_by_sigil/1
        ]).

-export([check_pt_module_function_exist/2,
         pt_module/1]).

-export([handle_cmd/3]).

%% 内部使用
%% -export([origin_saved_config/2, get_saved_config/1, get_save_config/1]). %% for init per, it return config

%% -export([set_robot/2, get_robot/1]).
-export([login_init/1]).

-include("define_robot.hrl").
-include_lib("common_test/include/ct.hrl").
-include("db_base_combat_skill_upgrade.hrl").


get_pb(Cmd, RecvData) ->
    case lists:keyfind(Cmd, 1, RecvData) of
        false ->
            {fail, not_recv};
        {Cmd, Rec} ->
            {ok, Rec}
    end.

ensure_ibrowse_started() ->
    ssl:start(),
    ibrowse:start().

ensure_logger() ->
    case code:which(logger) of
        non_existing ->
            hloglevel:set(6);
        _ ->
            ok
    end.

-define(ENSUER_PLAYER_ATTRI(Field), 
        ensuer_player_attri(Field, Robot, Num) ->
               ensuer_player_attri2(Robot, #pbuser.Field, Field, Num)).
%% 等价于 ensuer_player_attri(Robot, Field, Num)
?ENSUER_PLAYER_ATTRI(gold);
?ENSUER_PLAYER_ATTRI(coin);
?ENSUER_PLAYER_ATTRI(vigor).

ensuer_player_attri2(Robot, Pos, _, Num) when element(Pos, Robot#ct_robot.user) >= Num ->
    Robot;
ensuer_player_attri2(Robot, _Pos, Field, Num) ->
    gm(Robot, lists:concat(['-', Field, ',', Num])).
                                                   
add_goods_list(Robot, GoodsList)->
    Str = "-goods" ++ lists:foldl(fun({GoodsId, Num}, AccStr)->
                                          lists:concat([',', GoodsId, ',', Num]) ++ AccStr
                                  end,[], GoodsList),
    gm(Robot, Str).

gm(Robot, Str)->
    Data = robot_tcp:send_and_recv(Robot, 9009, #pbidstring{
                                                   id = Str
                                                  }),
    {NewRobot, _Failed} = handle_recv_data(Robot, Data),
    NewRobot.

clean_goods_list(Robot)->
    gm(Robot, lists:concat(["-delallgoods"])).

add_bag(Robot, Num) ->
    gm(Robot, lists:concat(['-bag', ',', Num])).

reset(Robot)->
    gm(Robot, lists:concat(["-yesterday"])).

start_conut(Robot)->
    gm(Robot, lists:concat(["-start_conut"])).

get_sterious_shop(Robot)->
    gm(Robot, lists:concat(["-sterious_shop"])).
reset_lv(Robot, Lv) ->
    gm(Robot, lists:concat(["-lv",',',Lv])).
add_skill(Robot, SkillId)->
    gm(Robot, lists:concat(["-add_skill",',',SkillId])).
add_sigil(Robot, SkillId)->
    gm(Robot, lists:concat(["-add_sigil",',',SkillId])).

recharge(Robot, RMB)->
    gm(Robot, lists:concat(["-rmb",',',RMB])).


get_sub_route(Robot) ->
    DungeonInfo = Robot#ct_robot.dungeon_info,
    case DungeonInfo of
        [] ->
            Robot;
        Other ->  %%确保是第一个子关卡
            [#pbsubdungeon{id = Id}|_Tail] = PbSubDungeonInfo = Other#pbdungeon.dungeon_info,
            Route = get_sub_route2(Id, PbSubDungeonInfo, []),
            ct:log("Dungeon Route ~p~n", [Route]),
            Robot#ct_robot{dungeon_info = DungeonInfo#pbdungeon{sub_route = lists:reverse(Route)}}
    end.

get_sub_route2(Id, PbSubInfo, SubIds) ->
    case lists:keyfind(Id, #pbsubdungeon.id, PbSubInfo) of
        false ->
            SubIds;
        #pbsubdungeon{create_portal = Ports} ->
            case Ports of
                [] ->
                    [Id|SubIds];
                [Port|_Tail] ->
                    #base_dungeon_create_portal{next_id = NextId} = data_base_dungeon_create_portal:get(Port),
                    get_sub_route2(NextId, PbSubInfo, [Id|SubIds])
            end
    end.
        

goods_lvlup(#ct_robot{goods_list = GoodsList} = Robot, BaseGoodsId, Exp) ->
    Goods = lists:keyfind(BaseGoodsId, #pbgoods.goods_id, GoodsList),
    Data = robot_tcp:send_and_recv(Robot, 9009, #pbidstring{
                                                   id = lists:concat(["-goodslvlup,", Goods#pbgoods.id, ",", Exp])
                                                  }),
    case get_pb(15001, Data) of
        {ok, PbData} ->
            {ok, NewRobot} = ct_robot_pt_15:recv(15001, Robot, PbData),
            NewRobot;
        _ ->
            {fail, goods_fail_lvlup}
    end.

add_mail(#ct_robot{mail = Mails} = Robot) ->
    Data = robot_tcp:send_and_recv(Robot, 9009, #pbidstring{
                                                   id = "-mail"
                                                  }),
    case get_pb(19004, Data) of
        {ok, PbData} ->
            {ok, NewRobot} = ct_robot_pt_19:recv(19004, Robot, PbData),
            NewRobot;
        _ ->
            {fail, no_find}
    end.


deny_friend(#ct_robot{friendslist = FriendList} = Robot) ->
    Data = robot_tcp:send_and_recv(Robot, 9009, #pbidstring{
                                                   id = lists:concat(["-addfriend,", 20000036,","])
                                                  }),
    case get_pb(13001, Data) of
        {ok, PbData} ->
            {ok, NewRobot} = ct_robot_pt_13:recv(13001, Robot, PbData),
            NewRobot;
        _ ->
            {fail, no_find}
    end.

request_friend(#ct_robot{friendslist = FriendList} = Robot) ->
    Data = robot_tcp:send_and_recv(Robot, 9009, #pbidstring{
                                                   id = lists:concat(["-addfriend,", 20000029,","])
                                                  }),
    case get_pb(13001, Data) of
        {ok, PbData} ->
            {ok, NewRobot} = ct_robot_pt_13:recv(13001, Robot, PbData),
            NewRobot;
        _ ->
            {fail, no_find}
    end.


%% Opts 
%% {check_recv_pb_record_list_fun, F} 
%% {required_cmd, CmdList}
%% {send_before_hook, SendBeforeFun} 注意SendBeforeFun不能进行对ct_robot发起call操作
%% {send_data, Data}
handle_cmd(Cmd, Robot, Opts) ->
    case ensure_logined(Cmd, Robot) of
        init_fail ->
            {handle_cmd, init_fail};
        LoginRobot ->
            case handle_send(Cmd, LoginRobot, Opts) of
                {ok, SendPbRecord, SendRobot} ->
                    %% 发包前，可能进行某些，所以Robot和SendRobot可能不一样                    
                    EnsureConnectRobot = robot_tcp:ensure_connect(SendRobot),
                    RecvPbRecordList = robot_tcp:send_and_recv(EnsureConnectRobot, Cmd, SendPbRecord),            

                    %% check_recv_data
                    %% 1. 通过check_recv_pb_record_list_fun传递匿名函数，检查收到的数据的正确性
                    %% 2. 检查是否收到的全部协议号
                    case check_recv_data(Opts, EnsureConnectRobot, RecvPbRecordList) of
                        ok ->
                            {ok, handle_recv_data(EnsureConnectRobot, RecvPbRecordList)};
                        Reason ->
                            {handle_cmd, Reason}
                    end;
                Reason ->
                    {handle_cmd, Reason}
            end
    end.

handle_send_before(Robot, []) ->
    {ok, Robot};
handle_send_before(Robot, [{send_before_hook, SendBeforeFun}|Rest]) ->
    case SendBeforeFun(Robot) of
        {ok, NewRobot} ->
            handle_send_before(NewRobot, Rest);
        FailReason ->
            {handle_send_before, FailReason}
    end;
handle_send_before(Robot, [_Opt|Rest]) ->
    handle_send_before(Robot, Rest).



check_recv_data([], _, _) ->
    ok;
check_recv_data([{check_recv_pb_record_list_fun, F}|Rest], Robot, RecvPbRecordList) 
  when is_function(F, 2)->
    case F(Robot, RecvPbRecordList) of
        ok ->
            check_recv_data(Rest, Robot, RecvPbRecordList);
        FailReason ->
            {check_recv_data, FailReason}
    end;
check_recv_data([{required_cmd, CmdList}|Rest], Robot, RecvPbRecordList) ->
    case check_required_cmd(CmdList, RecvPbRecordList) of
        ok ->
            check_recv_data(Rest, Robot, RecvPbRecordList);
        FailReason ->
            {check_recv_data, FailReason}
    end;
check_recv_data([_Opt|Rest], Robot, RecvPbRecordList) ->
    check_recv_data(Rest, Robot, RecvPbRecordList).

    
handle_send(Cmd, Robot, Opts) ->
    case handle_send_before(Robot, Opts) of
        {ok, SendBeforeRobot} ->
            PtModule = pt_module(Cmd),
            case check_pt_module_send_exist(PtModule) of
                ok ->
                    Return = 
                    case lists:keyfind(cmd_with_args, 1, Opts) of
                        false ->
                            PtModule:send(Cmd, SendBeforeRobot);
                        {_, Args} ->
                            PtModule:send(Cmd, SendBeforeRobot, Args)
                    end,
                    case proplists:get_value(handle_send_data, Opts) of
                        undefined ->
                            Return;
                        HandleFun ->
                            HandleFun(Return)
                    end;
                Fail ->
                    {handle_send, Fail}
            end;
        Reason ->
            {handle_send, Reason}
    end.

handle_recv(RecvCmd, Robot, Data) ->
    RecvPtModule = pt_module(RecvCmd),
    case check_pt_module_recv_exist(RecvPtModule) of
        ok ->
            RecvPtModule:recv(RecvCmd, Robot, Data);
        CheckPtModuleFail ->
            CheckPtModuleFail
    end.

handle_recv_data(Robot, RecvPbRecordList) ->
    lists:foldl(fun({RecvCmd, RecvPbRecord}, {AccRobot, AccState}) ->
                        case handle_recv(RecvCmd, AccRobot, RecvPbRecord) of
                            {ok, HandleRecvRobot} ->
                                {HandleRecvRobot, AccState};
                            HandleRecvFail ->
                                {AccRobot, [HandleRecvFail|AccState]}
                        end
                end, {Robot, []}, RecvPbRecordList).

check_pt_module_send_exist(Module) ->
    check_pt_module_function_exist(Module, {send, 2}).

check_pt_module_recv_exist(Module) ->
    check_pt_module_function_exist(Module, {recv, 3}).


check_pt_module_function_exist(Module, {Fun, Argc}) ->
    code:ensure_loaded(Module),
    case erlang:function_exported(Module, Fun, Argc) of 
        true ->
            ok;
        false ->
            {check_pt_module_function_exist, {function_not_exported, Module, Fun}}
    end.    

check_required_cmd(undefined, _) ->
    ok;
check_required_cmd(Cmd, RecvPbRecordList) when is_integer(Cmd)->
    check_required_cmd([Cmd], RecvPbRecordList);
check_required_cmd(CmdList, RecvPbRecordList) ->
    NotRecvCmdList = 
        lists:filter(fun(Cmd) ->
                             case lists:keyfind(Cmd, 1, RecvPbRecordList) of
                                 false ->
                                     true;
                                 _ ->
                                     false
                             end
                     end, CmdList),
    if
        NotRecvCmdList =:= [] ->
            ok;
        true ->
            {check_required_cmd, {required_cmd_recv_incomplete, NotRecvCmdList}}
    end.

%% for init config or change saved_config data
%% origin_saved_config(Config, {K, V}) ->
%%     case ?config(saved_config, Config) of
%%         undefined ->
%%             [{saved_config,{undefined, [{K,V}]}}|Config];
%%         {OldTestCase, SavedConfig} ->
%%             SaveConfig = {OldTestCase, lists:keystore(K, 1, SavedConfig, {K, V})},
%%             lists:keyreplace(saved_config, 1, Config, {saved_config, SaveConfig})
%%     end.

%% for TestCase save_config
%% test_case_save_config(Config, {K, V}) ->
%%     case get_saved_config(Config) of
%%         undefined ->
%%             [{K, V}];
%%         OldSaveConfig ->
%%             %% ?DEBUG("OldSaveConfig ~p~n", [OldSaveConfig]),
%%             lists:keystore(K, 1, OldSaveConfig, {K, V})
%%     end.

%% get_robot(Config) ->
%%     ?config(robot, get_saved_config(Config)).

%% set_robot(Config, Robot) ->
%%     origin_saved_config(Config, {robot, Robot}).


%% get_saved_config(Config) ->
%%     case ?config(saved_config, Config) of
%%         undefined ->
%%             undefined;
%%         {_, SaveConfig} ->
%%             SaveConfig
%%     end.

%% get_save_config(Config) ->
%%     case ?config(save_config, Config) of
%%         undefined ->
%%             undefined;
%%         SaveConfig ->
%%             SaveConfig
%%     end.

pt_module(Cmd) ->
    Prefix = Cmd div 1000,
    list_to_atom(lists:concat([ct_robot_pt, "_", Prefix])).


ensure_logined(10000, Robot) ->
    Robot;
ensure_logined(_, #ct_robot{
                     session = Session
                    }=Robot) ->    
    case (#ct_robot{})#ct_robot.session =:= Session of
        true ->
            login_init(Robot);
        false ->
            Robot
    end.

%% 避免同一个进程call自己
run_cmd_inner(Cmd, Robot) ->
    case {Cmd, Robot} of
        {10003, #ct_robot{player_id = PlayerId} = AccRobot} ->
            if
                PlayerId =:= 0 ->
                    {reply, _Reply, ReturnRobot} = ct_robot:handle_call({handle_cmd, 10003, []}, undefined, AccRobot),
                    {_Reply, ReturnRobot};
                true ->
                    {ok, AccRobot}
            end;
        {13001, #ct_robot{user = User} = AccRobot} ->
            if
                User =:= #pbuser{} ->
                    {reply, _Reply, ReturnRobot} = ct_robot:handle_call({handle_cmd, 13001, []}, undefined, AccRobot),
                    {_Reply, ReturnRobot};
                true ->
                    {ok, AccRobot}
            end;
        {13155, #ct_robot{friendslist = FriendList} = AccRobot} ->
            if
                FriendList =:= [] ->
                    {reply, _Reply, ReturnRobot} = ct_robot:handle_call({handle_cmd, 13155, []}, undefined, AccRobot),
                    {_Reply, ReturnRobot};
                true ->
                    {ok, AccRobot}
            end;
        {13333, #ct_robot{skill_list = SkillList} = AccRobot} ->
            if
                SkillList =:= [] -> 
                    {reply, _Reply, ReturnRobot} = ct_robot:handle_call({handle_cmd, 13333, []}, undefined, AccRobot),
                    {_Reply, ReturnRobot};
                true ->
                    {ok, AccRobot}
            end;
        {15000, #ct_robot{goods_list = GoodsList} = AccRobot} ->
            if
                GoodsList =:= [] ->
                    {reply, _Reply, ReturnRobot} = ct_robot:handle_call({handle_cmd, 15000, []}, undefined, AccRobot),
                    {_Reply, ReturnRobot};
                true ->
                    {ok, AccRobot}
            end;
        {Cmd, AccRobot} ->
            {reply, _Reply, ReturnRobot} = ct_robot:handle_call({handle_cmd, Cmd, []}, undefined, AccRobot),
            {_Reply, ReturnRobot}
    end.

run_cmd_list_inner([], Robot) ->
    Robot;
run_cmd_list_inner([H|T], Robot) ->
    case run_cmd_inner(H, Robot) of
        {ok, NewRobot} ->
            run_cmd_list_inner(T, NewRobot);
        _ ->
            init_fail
    end.

login_init(Robot) ->    
    run_cmd_list_inner([10000, 10003, 13001, 13155, 13333, 15000], Robot).
    %run_cmd_list_inner([10000, 10003, 13001], Robot).

%% 判断是否存在宝石孔
judge_color_hole(Color)->
    case data_base_goods_color_hole:get(Color) of
        #base_goods_color_hole{
           hole = Hole
          } ->
            Hole > 0;
        _ ->
            false
    end.
%%随机获取宝石的id 和 合成该宝石的原材料
get_rand_jewel_id_and_meterial()->   
    #base_goods{
       id=JewelId
      } = traverse_base_goods(fun(#base_goods{
                                     type = Type,
                                     lv = Lv
                                    })->
                                      Lv > 1 andalso
                                          Type =:= ?TYPE_GOODS_JEWEL
                              end),
    Meterial = 
        case data_base_goods_jewel:get(JewelId) of 
            #base_goods_jewel{
               meterial = M
              } ->
                M;
            _ ->
                []
        end,
    {JewelId, Meterial}.

%% 获取一个符合等级、职业、有宝石的装备
get_equip(PlayerLv, PlayerCareer)->
    traverse_base_goods(fun(#base_goods{
                               lv = Lv,
                               career = Career,
                               color = Color,
                               type = Type
                              })->
                                PlayerLv >= Lv andalso                                
                                PlayerCareer =:= Career andalso
                                judge_color_hole(Color) andalso
                                Type =:= ?TYPE_GOODS_EQUIPMENT
                        end). 

get_shop_id_by_vip_min_and_now()->
    [InitId|RestShopIdList] = data_base_shop:get_all_shop_id(),
    lists:foldl(fun(Id, #base_shop{vip = V} = Shop)->
                        case data_base_shop:get(Id) of 
                            #base_shop{
                               vip = Vip
                              } = BaseShop ->
                                if
                                    V > Vip ->
                                        BaseShop;
                                    true ->
                                        Shop
                                end;
                            _ ->
                                Shop
                        end
                end, data_base_shop:get(InitId), RestShopIdList).

key_find_equip(Type, GoodsList)->
    lists:keyfind(Type, #pbgoods.type, GoodsList).


get_player_id(Config, RobotNum)->
    get_player(Config, RobotNum, fun(AccountInfo)->
                                         #ct_robot{
                                            user = PbUser
                                           } = ct_robot:get_robot(AccountInfo),
                                         PbUser#pbuser.id   
                                 end).
get_player_lv(Config, RobotNum)->
    ct:log(" Confing ~p",[Config]),
    get_player(Config, RobotNum, fun(AccountInfo)->
                                         #ct_robot{
                                           user = PbUser
                                           } = ct_robot:get_robot(AccountInfo),
                                         PbUser#pbuser.lv 
                                 end).

get_player([{RobotNum, AccountInfo}|_Config], RobotNum, Fun)->
    Fun(AccountInfo);
get_player([_|Config], RobotNum, Fun)->
    get_player(Config, RobotNum, Fun);
get_player([], _RobotNum, _Fun) ->
    no_find.


get_rand_dungeon(PlayerLv) ->
    DungeonList = lists:append([data_base_dungeon_area:get_ordinary_dungeon_by_lv(Lv) || 
                                   Lv <- data_base_dungeon_area:get_dungeon_all_lv(), 
                                   Lv =< PlayerLv]),
    %% 副本配置有问题， 先暂且写死
    %% hmisc:rand(DungeonList).
    1100011.

judge_req_lv(Id, PlayerLv)->
    case data_base_combat_skill_upgrade:get(Id) of
        #base_combat_skill_upgrade{
           req_lv = ReqLv
          } ->
            ReqLv < PlayerLv;
        _->
            false
    end.

get_skill_id(Robot)->
    #base_combat_skill{
       id = SkillId
      } = get_skill(Robot),
    SkillId.
    

get_skill(#ct_robot{
             user = #pbuser{lv = PlayerLv}
            }) ->
    traverse_base_combat_skill(fun(#base_combat_skill{
                                      upgrade_id = UgrIndex,
                                      max_upgrade_lv = MaxLv
                                     })->
                                       1 < MaxLv andalso
                                           judge_req_lv(UgrIndex + 1, PlayerLv)
                               end).

traverse_base_goods(Fun)->
    traverse_base(Fun, data_base_goods:get_equip_all_id(), data_base_goods).

traverse_base_combat_skill(Fun)->
    traverse_base(Fun, data_base_combat_skill:get_all_skills_ids(), data_base_combat_skill).

traverse_base_combat_skill(Fun, SkillIdList) 
  when is_list(SkillIdList) ->
    traverse_base(Fun, SkillIdList, data_base_combat_skill);
traverse_base_combat_skill(Fun, SkillId) 
  when is_integer(SkillId)->
    traverse_base(Fun, [SkillId], data_base_combat_skill).


traverse_base(Fun, [H | T], DataMod)->
    Base = DataMod:get(H),
    case Fun(Base) of
        true -> 
            Base;
        false-> 
            traverse_base(Fun, T, DataMod)
    end;
traverse_base(_Fun, [], _DataMod) ->
    no_find.


get_skill_by_str_lv([])->
    no_find;
get_skill_by_str_lv([#pbskill{
                        str_lv = StrLv,
                        skill_id = SkillId
                       } = PbSkill | SkillList])->
    case traverse_base_combat_skill(fun(#base_combat_skill{
                                           max_strengthen_lv = MaxStrengthLv
                                          })->
                                            MaxStrengthLv > StrLv
                                    end, SkillId) of 
        no_find ->
            get_skill_by_str_lv(SkillList);
        _BaseCombatSkill ->
            PbSkill
    end.

get_skill_by_lv([], _PlayerLv)->
    no_find;
get_skill_by_lv([#pbskill{
                        lv = UgrLv,
                        skill_id = SkillId
                       } = PbSkill | SkillList], PlayerLv) ->
    case traverse_base_combat_skill(fun(#base_combat_skill{
                                           max_upgrade_lv = MaxUpgradeLv,
                                           upgrade_id = UgrIndex
                                          })->
                                            UgrLv < MaxUpgradeLv andalso
                                                judge_req_lv(UgrIndex+UgrLv, PlayerLv)
                                    end, SkillId) of 
        no_find ->
            get_skill_by_lv(SkillList, PlayerLv);
        _BaseCombatSkill ->
            PbSkill
    end.

get_skill_by_sigil([])->
    no_find;
get_skill_by_sigil([#pbskill{
                       sigil = SigilList
                      } = PbSkill | SkillList]) ->
    if 
        SigilList =:= [] ->
            get_skill_by_sigil(SkillList);
        true ->
            PbSkill
    end.
