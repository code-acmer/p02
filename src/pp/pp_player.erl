%%%--------------------------------------
%%% @Module  : pp_player
%%% @Created : 2011.05.12
%%% @Description:  角色功能管理
%%%--------------------------------------
-module(pp_player).

-export([
         handle/3
        ]).

-include("define_logger.hrl").
-include("define_relationship.hrl").
-include("define_cache.hrl").
-include("pb_13_pb.hrl").
-include("pb_common_pb.hrl").
-include("define_info_13.hrl").
-include("define_info_14.hrl").
-include("define_info_15.hrl").
-include("define_info_45.hrl").
-include("define_sys_acm.hrl").
-include("define_operate.hrl").
-include("define_player.hrl").
-include("define_server.hrl").
-include("define_goods_type.hrl").
-include("define_money_cost.hrl").
-include("define_team.hrl").
-include("define_goods.hrl").
-include("pb_12_pb.hrl").
-include("define_task.hrl").
-include("define_dungeon.hrl").

%% @doc 查询当前玩家信息
handle(13001, #mod_player_state{player = Player,
                                league_info = LeagueInfo} = ModPlayerState, _) ->
    %% 打包角色信息并发送
    {ok, BinData} = pt_13:write(13001, {Player, LeagueInfo}),
    packet_misc:put_packet(BinData),
    %mod_player:send(ModPlayerSate, BinData),
    pp_base:handle(9003, ModPlayerState, null),
    ok;

handle(13002, _ModPlayerSate, _) ->
    gen_server:cast(self(), {stop, ?STOP_REASON_NORMAL}),
    ok;

%%领取七天登陆奖励
handle(13007, ModPlayerState, _) ->
    case lib_player:login_reward_week(ModPlayerState) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {ok, NewModPlayerState} ->
            
            {ok, NewModPlayerState}
    end;

%%领取月签到登陆奖励
handle(13009, ModPlayerState, _) ->
    case lib_player:login_reward_month(ModPlayerState) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {ok, NewModPlayerState} ->
            {ok, NewModPlayerState}
    end;

%% 玩家上线 ，提示助战获取的友情值
handle(13005, #mod_player_state{
                 player = Player
                } = ModPlayerSate, _) ->
    SendNull = fun() ->
                       {ok, BinData} = pt:pack(13005, <<>>),
                       packet_misc:put_packet(BinData)
               end,
    case hdb:dirty_read(help_battle, ModPlayerSate?PLAYER_ID) of
        [] ->
            SendNull();
        #help_battle{value = 0} ->
            SendNull();
        #help_battle{value = Value,
                     friend_count = FCount,
                     strangers_count = SCount} = HelpBattle ->               
            Fpt = lib_player:add_fpt(Player#player.fpt, Value),
            NewPlayer = Player#player{fpt = Fpt},
            hdb:dirty_write(help_battle, 
                            HelpBattle#help_battle{value = 0,
                                                   friend_count = 0,
                                                   strangers_count = 0}),
            {ok, BinData} = pt_13:write(13005, {FCount, SCount, Fpt, Value}),
            packet_misc:put_packet(BinData),
            {ok, ModPlayerSate#mod_player_state{player = NewPlayer}}
    end;

%%新手引导
handle(13006, ModPlayerState, #pbid32r{id = Step}) ->
    {ok, ModPlayerState#mod_player_state{player = ModPlayerState?PLAYER#player{
                                                                   beginner_step = Step
                                                                  }
                                        }};

%%购买体力
handle(13010, #mod_player_state{
                 player = Player
                } = ModPlayerState, _) ->
    case lib_player:buy_vigor(Player) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {ok, NewPlayer} ->
            NewModPlayerState = lib_task:task_event(ModPlayerState, {?TASK_FUNTION, ?TASK_FUNTION_BUY_VIGOR, 1}),
            {ok, NewModPlayerState#mod_player_state{player = NewPlayer}}
    end;

handle(13011, ModPlayerState, _) ->
    case lib_player:cost_money(ModPlayerState?PLAYER, ?BUY_FRIEND_EXT_GOLD, ?GOODS_TYPE_GOLD, ?COST_BUY_FRIEND_EXT) of
        {ok, Player} ->
            packet_misc:put_info(?INFO_BUY_FPT_SUCCESS),
            {ok, ModPlayerState#mod_player_state{
                   player = Player#player{
                              friends_ext = Player#player.friends_ext + 5
                             }
                  }};
        {fail, Reason} ->
            packet_misc:put_info(Reason)
    end;

%%VIP礼包状况
handle(13020, ModPlayerState, _) ->
    {ok, Bin} = pt_13:write(13020, ModPlayerState#mod_player_state.vip_reward),
    packet_misc:put_packet(Bin),
    ok;
handle(13021, ModPlayerState, #pbid32{id = Vip}) ->
    case lib_player:recv_vip_reward(ModPlayerState, Vip) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {ok, NewModPlayerState} ->
            {ok, Bin} = pt_13:write(13020, NewModPlayerState#mod_player_state.vip_reward),
            packet_misc:put_packet(Bin),
            {ok, NewModPlayerState}
    end;
%% @doc 查询活动副本信息（活动副本需要单独记录），主线记录最后通关id
%% @spec
%% @end 
handle(13101, _Status, _) ->
    ok;


%% @doc 验证app store receipts
%% handle(13200, Player, #pbidstring{id = ReceiptData}) ->
%%     mod_verifying_store_receipts:send_receipt_data(Player, ReceiptData);

handle(13140, ModPlayerState, #pbid64{id = RobotId}) ->
    case lib_player:get_pvp_robot_attr(RobotId) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {ok, PvpRobotAttr} ->
            {ok, Bin} = pt_13:write(13140, PvpRobotAttr),
            packet_misc:put_packet(Bin),
            {ok, ModPlayerState}
    end;

handle(13141, ModPlayerState, #pbid64{id = RobotId}) ->
    case lib_player:get_cross_robot_attr(RobotId) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {ok, PvpRobotAttr} ->
            {ok, Bin} = pt_13:write(13141, PvpRobotAttr),
            packet_misc:put_packet(Bin),
            {ok, ModPlayerState}
    end;

%%获取其他玩家详细信息
handle(13150, _ModPlayerState, #pbid64r{ids = IdList}) ->
    CombatAttriList = lib_player:get_combat_attri_list(IdList),
    {ok, Bin2} = pt_13:write(13150, null),
    packet_misc:put_packet(Bin2),
    {ok, Bin} = pt_14:write(14000, {combat_attri_list, CombatAttriList}),
    packet_misc:put_packet(Bin);

%% @doc 好友请求
%% @spec
%% @end
handle(13151, ModPlayerState, #pbid64{id = TID}) ->
    case lib_relationship:request_friend(ModPlayerState, TID) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {TarPlayer, NewModPlayerState} ->
            {ok, BinData} = pt_14:write(14000, {[TarPlayer], []}),
            %packet_misc:put_info(?INFO_FRIEND_ADD_SUCCESS),
            packet_misc:put_packet(BinData),
            {ok, NewModPlayerState}
    end;

%% @doc 删除好友
%% @spec
%% @end
handle(13154, ModPlayerSate, #pbid64{id = TID}) ->
    case lib_relationship:delete_friend(TID, ModPlayerSate?PLAYER_RELA) of
        {ok, NewRelaList} ->
            {ok, BinData} = pt_14:write(14000, {[], TID}),
            packet_misc:put_packet(BinData),
            {ok, ModPlayerSate#mod_player_state{
                   relationship = NewRelaList,
                   player = ModPlayerSate?PLAYER#player{
                                            friends_cnt = ModPlayerSate?PLAYER_FRIENDS_CNT - 1
                                           }
                  }};
        {fail, Reason} ->
            packet_misc:put_info(Reason)
    end;

%% @doc 请求所有的好友信息，用于上线的时候处理
%% @spec
%% @end
handle(13155, #mod_player_state{player = _Player,
                                relationship = Rela
                               }, _) ->
    {ok, Bin} = pt_14:write(14000, {Rela, []}),
    packet_misc:put_packet(Bin);

%% @doc 查看其他好友信息(13150是比较详细的信息，这个信息很少)
%% @spec
%% @end
handle(13004, ModPlayerState, #pbid64r{ids = IdList}) ->
    PlayerList = lib_player:get_other_player_list(ModPlayerState?PLAYER_ID, ModPlayerState?PLAYER_SN, IdList),
    {ok, Bin} = pt_13:write(13004, PlayerList),
    packet_misc:put_packet(Bin);

%% 竞技场获取玩家信息
handle(13008, ModPlayerState, #pbid64r{ids = IdList}) ->
    PlayerInfoList = lib_player:get_other_player_detail_list(ModPlayerState, IdList),
    {ok, Bin} = pt_13:write(13008, PlayerInfoList),
    packet_misc:put_packet(Bin);

%%组队相关操作
%%创建队伍
handle(13200, ModPlayerState, #pbid32{id = DungeonId}) ->
    case lib_team:create_team(ModPlayerState, DungeonId) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {ok, NewModPlayerState, Team} ->
            {ok, Bin} = pt_13:write(13205, Team),
            packet_misc:put_packet(Bin),
            {ok, NewModPlayerState}
    end;
%%邀请好友进队
handle(13201, ModPlayerState, #pbid32r{id = IdList}) ->
    case lib_team:invite_in_team(ModPlayerState?PLAYER_ID, IdList) of
        ok ->
            ok;
        {fail, Reason} ->
            packet_misc:put_info(Reason)
    end;
%%接受邀请加入队伍
handle(13202, ModPlayerState, #pbteam{team_num = TeamNum, dungeon_id = DungeonId}) ->
    case lib_team:join_in_team(ModPlayerState, TeamNum, DungeonId) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        ok ->
            {ok, Bin} = pt_13:write(13202, null),
            packet_misc:put_packet(Bin)
    end;
%%踢出队伍
handle(13203, ModPlayerState, #pbid32{id = Tid}) ->
    case lib_team:kick(ModPlayerState?PLAYER_ID, Tid) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        ok ->
            ok
    end;
%%离开队伍
handle(13204, ModPlayerState, _) ->
    lib_team:leave_team(ModPlayerState?PLAYER_ID),
    {ok, Bin} = pt_13:write(13204, null),
    packet_misc:put_packet(Bin);
%%查看当前队伍信息
handle(13205, _, _) ->
    case lib_team:get_team() of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {ok, Team} ->
            {ok, Bin} = pt_13:write(13205, Team),
            packet_misc:put_packet(Bin);
        [] ->
            {ok, Bin} = pt_13:write(13205, []),
            packet_misc:put_packet(Bin)
    end;
%%准备
handle(13206, ModPlayerState, _) ->
    case lib_team:get_ready(ModPlayerState?PLAYER_ID) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        ok ->
            {ok, Bin} = pt_13:write(13206, null),
            packet_misc:put_packet(Bin)
    end;
%%队长开始
handle(13207, ModPlayerState, _) ->
    case lib_team:start_dungeon(ModPlayerState) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        ok ->
            skip;
        {single_dungeon, DungeonId, DungeonType} ->
            pp_dungeon:handle(12001, ModPlayerState, #pbdungeon{id = DungeonId,
                                                                type = DungeonType})
    end;
%%组队聊天
handle(13208, ModPlayerState, #pbteamchat{msg = Msg}) ->
    case lib_team:chat(ModPlayerState, Msg) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        ok ->
            skip
    end;

%%约战模式
handle(13209, ModPlayerState, #pbid32{id = Id}) ->
    case lib_team:challenge_type(ModPlayerState?PLAYER_ID, Id) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        ok ->
            skip
    end;

%%技能升级
handle(13300, ModPlayerState, #pbid32{id = UpgradeSkillId}) ->
    case lib_player:upgrade_skill(ModPlayerState, UpgradeSkillId, ?SKILL_UPGRADE) of
        {fail, Reason} ->
            %?ERROR_MSG("Reason ~p~n",[Reason]),
            packet_misc:put_info(Reason);
        {ok, NewModPlayerState, NewSkill} ->
            %?ERROR_MSG("NewSkill ~p~n",[NewSkill]),
            mod_player:update_combat_attri(ModPlayerState?PLAYER_PID),
            {ok, BinData} = pt_13:write(13333, [NewSkill]),
            packet_misc:put_packet(BinData),
            {ok, NewModPlayerState}
    end;

%%技能强化
handle(13301, ModPlayerState, #pbid32{id = StrengthId}) ->
    case lib_player:upgrade_skill(ModPlayerState, StrengthId, ?SKILL_STRENGTHEN) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {ok, NewModPlayerState, NewSkill} ->
            %?ERROR_MSG("NewSkill ~p~n",[NewSkill]),
            mod_player:update_combat_attri(ModPlayerState?PLAYER_ID),
            {ok, BinData} = pt_13:write(13333, [NewSkill]),
            packet_misc:put_packet(BinData),
            {ok, NewModPlayerState}
    end;
%%切换符印
handle(13305, ModPlayerState, #pbsigil{id = Id, tid = Tid}) ->
    case lib_player:change_sigil(ModPlayerState, Id, Tid) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {ok, NewModPlayerState, Skill} ->
            {ok, BinData} = pt_13:write(13333, [Skill]),
            packet_misc:put_packet(BinData),
            {ok, NewModPlayerState}
    end;
%%绑定几个主动技能
handle(13310, ModPlayerState, #pbid32r{id = SkillIds}) ->
    case lib_player:put_on_skill(ModPlayerState, SkillIds) of
        {ok, NewModPlayerState} ->
            {ok, NewModPlayerState};
        {fail, Reason} ->
            packet_misc:put_info(Reason)
    end;
%%获取技能列表
handle(13333, #mod_player_state{skill_list = SkillList}, _) ->
    %?ERROR_MSG("SkillList ~p~n",[SkillList]),
    {ok, BinData} = pt_13:write(13333, SkillList),
    packet_misc:put_packet(BinData),
    ok;

%%客户端传送战斗力上来
handle(13400, #mod_player_state{player = Player} = ModPlayerState,
       #pbid32{id = Ability}) 
  when is_integer(Ability) ->
    ?WARNING_MSG("13400: ~p", [Ability]),
    lib_player:battle_ability(Player, Ability),
    NewPlayer = Player#player{battle_ability = Ability,
                              high_ability = max(Ability, Player#player.high_ability)},
    {ok, BinData} = pt_13:write(13400, null),
    packet_misc:put_packet(BinData),
    
    %% 最高战力变更通知
    if
        NewPlayer#player.high_ability > Player#player.high_ability ->
            mod_cross_pvp:update_player(Player);
        true -> 
            ignored
    end,
    if
        NewPlayer#player.battle_ability > Player#player.battle_ability ->
            mod_player_rec:update_ability(Player#player.id, Player#player.sn, Player#player.battle_ability, NewPlayer#player.battle_ability);
        true -> 
            ignored
    end,
    {ok, ModPlayerState#mod_player_state{player = NewPlayer}};

handle(13401, _ModPlayerState, #pbid64r{ids = PlayerIds}) when is_list(PlayerIds) ->
    CombatAttriList  = lists:foldl(fun(Id, Rets) ->
                                           case lib_combat_attri:get_combat_attri(Id) of
                                               [] ->
                                                   Rets;
                                               CombatAttri ->
                                                   [CombatAttri|Rets]
                                           end
                                   end, [], PlayerIds),
    case CombatAttriList of
        [] ->
            packet_misc:put_info(?INFO_CONF_ERR);
        CombatAttriList ->
            {ok, Binary} = pt_13:write(13401, CombatAttriList),
            packet_misc:put_packet(Binary)
    end;
%%附近的人推荐
handle(13500, #mod_player_state{player = Player}, _) ->
    PlayerRecList = lib_player:get_players_nearby(Player),
    {ok, Bin} = pt_13:write(13500, PlayerRecList),
    packet_misc:put_packet(Bin);

%%公平竞技推荐
handle(13501, #mod_player_state{player = Player,
                                super_battle = #super_battle{have_pass_times = Pass, ability = Ability}}, _) ->
    NewAbility = Ability*(0.6+(Pass*0.04)),
    ?DEBUG("NewAbility ~p~n", [NewAbility]),
    PlayerInfo = 
        case mod_player_rec:recommend(Player#player{battle_ability = NewAbility}, 1) of
            [] ->
                lib_robot_api:get_robot_by_ability(NewAbility);
            [PlayerId] ->
                ?DEBUG("PlayerId ~p~n", [PlayerId]),
                %% case lib_player:get_other_player_detail(PlayerId) of
                %%     [] ->
                %%         [];
                %%     Other ->
                %%         ?DEBUG("Find Player ~p~n", [Other]),
                %%         {OPlayer, _, _, _, _} = Other,
                %%         ?DEBUG("Find Player.ability ~p~n", [OPlayer#player.battle_ability]),
                %%         Other
                %% end
                case mod_combat_attri:get_combat_attri(PlayerId) of
                    [] ->
                        lib_robot_api:get_robot_by_ability(NewAbility);
                    CombatAttri->
                        CombatAttri
                end
        end,
    {ok, Bin} = pt_13:write(13501, PlayerInfo),
    packet_misc:put_packet(Bin);
%%公告
handle(13600, ModPlayerState, _) ->
    Sn = ModPlayerState?PLAYER_SN,
    NewNotice = lib_player:get_notice(Sn),
    {ok, Bin} = pt_13:write(13600, NewNotice),
    packet_misc:put_packet(Bin);
handle(13601, ModPlayerState, _) ->                     
    %% Sn = ModPlayerState?PLAYER_SN,
    case mod_q_coin_srv:show_q_coin(1) of
        Num when is_integer(Num) ->
            {ok, Binary} = pt_13:write(13601, Num),
            packet_misc:put_packet(Binary);
        _ ->
            packet_misc:put_info(?INFO_CONF_ERR)
    end;
handle(13602, ModPlayerState, #pbidstring{id = QQ}) ->
    case lib_player:binding_qq(ModPlayerState?PLAYER, QQ) of
        {ok, NewPlayer} ->
            {ok, Binary} = pt_13:write(13602, null),
            packet_misc:put_packet(Binary),
            {ok, ModPlayerState#mod_player_state{player = NewPlayer
                  }};
        {fail, Info}->
            packet_misc:put_info(Info)
    end;

%% 不匹配的协议
handle(_Cmd, _, _Data) ->
    ?WARNING_MSG("pp_handle no match, /Cmd/Data/ = /~p/~p/~n",
                 [_Cmd, _Data]),
    {error, "pp_handle no match"}.


