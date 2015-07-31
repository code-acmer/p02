%%%-----------------------------------
%%% @Module  : mod_player
%%% @Created : 2010.09.27
%%% @Description: 角色处理
%%%------------------------------------

-module(mod_player). 
-behaviour(gen_server).

-include("define_logger.hrl").
-include("pb_9_pb.hrl").
-include("pb_13_pb.hrl").
-include("define_login.hrl").
-include("define_info_14.hrl").
-include("define_relationship.hrl").
-include("define_reward.hrl").
-include("define_time.hrl").
-include("define_player.hrl").
-include("db_base_equipment.hrl").
-include("define_goods_type.hrl").
-include("define_task.hrl").
-include("db_base_task.hrl").
-include("define_money_cost.hrl").
-include("define_dungeon.hrl").
-include("define_boss.hrl").
-include("define_team.hrl").
-include("define_dungeon.hrl").

-export([init/1, 
         handle_call/3, 
         handle_cast/2, 
         handle_info/2, 
         terminate/2, 
         code_change/3]).

-export([
         get_role_by_accid/1,
         get_session/1,
         get_rc4/1,
         get_last_flag/1,
         update_client_info/2,
         new_pay_info/1,
         start_link/1,
         stop/2,
         send/2,
         send_info/2,
         send_to_client/2,
         tcp_disconnect/1,
         update_goods_send_timestamp/2,
         banrole/2,
         task_event/2,
         task_event_list/2,
         lvlup_may_add_task/1,
         boss_killed/3,
         boss_damage/2,
         invited_in_team/4,
         team_kick/1,
         team_start/2,
         new_skill/2,
         daily_reset/1,
         league_kicked/2,
         cmd_socket_event/2,
         recharge/3,
         invite_in_league/2,
         request_player_gifts/1,
         update_combat_attri/1,
         notice_master_msg/1
        ]).
-export([get_player/1,
         get_player_detail/1,
         get_player_goods/2,
         get_client_pid/1]).
-export([delete_goods_by_id/2,
         add_goods/2
        ]).

%% -record(state,
%%         {
%%           player,
%%           bag,
%%           relationship,            %% 好友数据缓存
%%           pid,
%%           socket,
%%           client_pid,              %% 客户端回调接口
%%           session,                 %% 登录验证
%%           session_timestamp        %% 登录验证时间戳信息
%%         }).

%% @doc 根据accid获取角色信息，dirty方法
%% @spec
%% @end
get_role_by_accid(AccId) ->
    hdb:dirty_index_read(player, AccId, #player.accid, true).

%% 启动角色主进程
%% start(PlayerId, AccountId, Sn, Socket, Sesssion) ->
start_link(#client{player_id = PlayerId} = Client) ->
    %% Server = {via, gproc, hmisc:player_process_name(PlayerId)},
    %% gen_server:start_link(Server, ?MODULE, [Client], [{fullsweep_after, 30}]),
    gen_server:start_link(?MODULE, [Client], [{fullsweep_after, 30}]).

%% --------------------------------------------------------------------
%% Function: init/1
%% Description: Initiates the server
%% Returns: {ok, State}          |
%%          {ok, State, Timeout} |
%%          ignore               |
%%          {stop, Reason}
%% --------------------------------------------------------------------
init([Client]) ->
    process_flag(trap_exit, true),
    gen_server:cast(self(), {init_player, Client}),
    {ok, #mod_player_state{}}.

%% --------------------------------------------------------------------
%% Function: handle_call/3
%% Description: Handling call messages
%% Returns: {reply, Reply, State}          |
%%          {reply, Reply, State, Timeout} |
%%          {noreply, State}               |
%%          {noreply, State, Timeout}      |
%%          {stop, Reason, Reply, State}   | (terminate/2 is called)
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------

%% 获取用户信息
handle_call(cmd_player, _from, #mod_player_state{player = Status} = State) ->
    {reply, Status, State};

handle_call(get_mod_player, _, State) ->
    {reply, State, State};

handle_call({get_goods, GoodsId}, _, #mod_player_state{bag = GoodsList} = State) ->
    Reply = 
        case lists:keyfind(GoodsId, #goods.id, GoodsList) of
            false ->
                [];
            Goods ->
                {ok, Goods}
        end,
    {reply, Reply, State};

%% @doc 好友被删除了
handle_call({cmd_friends_deleted, SID, TID}, 
            _From, #mod_player_state{relationship = RelaList} = State) ->
    NewRelaList = lib_relationship:friend_deleted(SID, TID, RelaList),
    {reply, ok, State#mod_player_state{relationship = NewRelaList}};

handle_call({update_client_info, #client{				    
                                    socket = Socket,
                                    client_pid = ClientPid,
                                    rc4 = RC4
                                   } = Client}, _From, State) ->
    ?DEBUG("update_client_info : ~p, ~p~n", [RC4, State#mod_player_state.rc4]),
    ?DEBUG("CurBossPid : ~p~n", [State#mod_player_state.cur_boss_pid]),
    Now = time_misc:unixtime(),
    {Session, SessionTimeStamp} = 
        if 
            Client#client.session =:= undefined ->
                %% 非10000协议过来update的，也就是从非mod_login过来的, 就是断线重连
                {State#mod_player_state.session, State#mod_player_state.session_timestamp};
            true ->
                %% 从mod_login过来的，要更新
                {Client#client.session, Client#client.session_timestamp}
        end,
    %% 关闭其他活跃的socket连接，以防多socket，一个player
    OldClientPid = State#mod_player_state.client_pid,
    if 
        OldClientPid =/= undefined andalso
        OldClientPid =/= ClientPid ->
            %% 如果是同一个socket走的登陆，就不断
            ?WARNING_MSG("player occur more socket~n", []),
            packet_misc:directly_send_info(OldClientPid, 0, ?INFO_SERVER_KICK_OUT),
            {ok, BinData} = pt_10:write(10007, null),
            packet_misc:directly_send_packet(OldClientPid, 0, BinData),
            inner_handle_disconnect(State),
            unlink(OldClientPid),
            tcp_client_handler:stop_no_notice(OldClientPid);
        true ->
            pass
    end,
    
    CRC4 = case RC4 of
               undefined ->
                   State#mod_player_state.rc4;
               RC4 ->
                   RC4
           end,    
    put(rc4_key, CRC4),
    ?DEBUG("update ClientPid ~p Oldpid ~p newSession~p~n", [ClientPid, OldClientPid, Session]),
    NPlayer = State?PLAYER#player{timestamp_login = Now,
                                  online_flag = ?PLAYER_ONLINE
                                 },
    lib_log_player:log_player_login(NPlayer),
    NState = State#mod_player_state{
               player            = NPlayer,
               socket            = Socket,
               client_pid        = ClientPid,
               session           = Session,
               session_timestamp = SessionTimeStamp,
               rc4               = CRC4
              },
    NClient = Client#client{
                player_id = State?PLAYER_ID,
                accid     = State?PLAYER_ACCID,
                accname   = State?PLAYER_ACCNAME,
                login     = ?LOGIN_SUCCESS,
                player_pid = self(),
                session   = Session,
                session_timestamp = SessionTimeStamp,
                rc4       = CRC4
               },
    {reply, NClient, NState};

handle_call(get_last_flag, _, State) ->
    Reply = 
        case get_from_dict() of
            undefined ->
                ?DEBUG("not dict ~n", []),
                0;
            {_, []} ->
                ?DEBUG("empty dict ~n", []),
                0;
            {_, [{F, _, _}|_]} ->
                ?DEBUG("F ~p ~n", [F]),
                F
        end,
    {reply, Reply, State};

handle_call(get_session, _From, #mod_player_state{
                                   session = Session,
                                   session_timestamp = SessionTimeStamp
                                  } = State) ->
    %% Current = hmisctime:unixtime(),
    %% ?DEBUG("DiffTime ~w, Timeout ~w, Session ~w~n",
    %%        [Current - SessionTimeStamp, ?SESSION_TIMEOUT, Session]),
    %% ?DEBUG("{Session, SessionTimeStamp} ~w~n", [{Session, SessionTimeStamp}]),
    {reply, {Session, SessionTimeStamp}, State};

handle_call(cmd_get_rc4, _From, #mod_player_state{
                                   rc4 = RC4
                                  } = State) ->
    {reply, {ok, RC4}, State};
handle_call(get_client_pid, _, #mod_player_state{client_pid = ClientPid} = State) ->
    {reply, ClientPid, State};

handle_call(Event, From, Status) ->
    ?WARNING_MSG("Mod_player_call: /~p/~n",[[Event, From, Status]]),
    {reply, ok, Status}.


handle_cast({init_player, #client{player_id = PlayerId, 
                                  socket    = Socket,
                                  client_pid = ClientPid,
                                  session   = Session,
                                  session_timestamp = SessionTimeStamp} = Client}, ModPlayerState) ->
    ?DEBUG("init_player ..."),
    hmisc:write_monitor_pid(self(), ?MODULE, {PlayerId}),
    {ok, #player{id = PlayerId} = Player} = load_player_info(Client),
    ?DEBUG("load_player_info ok ... "),
    ok = lib_master:update_login_time(Player),
    ?DEBUG("init lib_master ok ... "),
    Relationship = lib_relationship:role_login(PlayerId),
    ?DEBUG("init lib_relationship ok ... "),
    FriendNum = length(Relationship),
    BagCache = lib_goods:role_login(PlayerId),
     ?DEBUG("init_player ..."),
    erlang:send_after(?PLAYER_SAVE_DELAY, self(), cmd_auto_save_player),
    %mod_monitor:set_player_online_count(),
    mod_player_rec:new_player(Player),
    TaskList = lib_task:login(Player),
    DungeonList = lib_dungeon:login_dungeon(PlayerId),
    DungeonMugen = lib_dungeon:login_mugen(PlayerId),
    SuperBattle = lib_dungeon:login_super_battle(Player),
    DailyDungeon = lib_dungeon:login_daily_dungeon(Player),
    SourceDungeon = lib_dungeon:login_source_dungeon(PlayerId),
    MugenRewardList = lib_dungeon:login_mugen_reward(PlayerId),
    SkillList = lib_player:login_skill(PlayerId),  
    
    SkillRecord = lib_player:login_skill_record(PlayerId),
    CostCoinLast = Player#player.cost_coin, 
    CostGoldLast = Player#player.cost_gold,
    SteriousShop = lib_shop:login_sterious_shop(PlayerId),
    ViceShop = lib_shop:login_vice_shop(PlayerId),
    OrdinaryShop = lib_shop:login_ordinary_shop(PlayerId),
    MainShop = lib_shop:login_main_shop(PlayerId),
    ActivityRecord = lib_shop:login_activity_record(PlayerId),
    ChoujiangInfo = lib_choujiang:login_choujiang_info(PlayerId),
    LeagueInfo = lib_league:league_name_title(Player#player.id, Player#player.sn),
    PayGifts = lib_pay_gifts:login_gifts(PlayerId),
    ?DEBUG("Login SteriousShop: ~p",[SteriousShop]),
    ?DEBUG("login_activity_record: ~p", [ActivityRecord]),
    Advance = lib_advance_reward:login(PlayerId),
    GeneralStoreList = lib_shop:login_general_store_list(PlayerId), 
    NewModPlayerState = ModPlayerState#mod_player_state{
                          player = Player#player{
                                     online_flag = ?PLAYER_ONLINE,
                                     friends_cnt = FriendNum
                                    },
                          relationship = Relationship,
                          bag          = BagCache,
                          session      = Session,
                          session_timestamp = SessionTimeStamp,
                          client_pid   = ClientPid,
                          pid          = self(),
                          socket       = Socket,
                          task_list    = TaskList,
                          dungeon_list = DungeonList,
                          dungeon_mugen = DungeonMugen,
                          super_battle = SuperBattle,
                          daily_dungeon = DailyDungeon,
                          mugen_reward = MugenRewardList,
                          skill_list = SkillList,
                          skill_record = SkillRecord,
                          source_dungeon = SourceDungeon,
                          operators_mail_list = lib_mail:login(PlayerId),
                          player_cost_state = 
                              #player_cost_state{cost_coin_last = CostCoinLast,
                                                 cost_gold_last = CostGoldLast},
                          sterious_shop = SteriousShop,
                          vice_shop = ViceShop,
                          ordinary_shop = OrdinaryShop,
                          main_shop = MainShop,
                          activity_record = ActivityRecord,
                          dungeon_info = #dungeon_info{},
                          choujiang_info = ChoujiangInfo,
                          league_info = LeagueInfo,
                          pay_gifts = PayGifts,
                          advance_reward = Advance,
                          vip_reward = lib_player:login_vip_reward(PlayerId),
                          general_store_list = GeneralStoreList
                         },
    %%这里做每天重置
    %ToTomorrowSec = hmisctime:get_seconds_to_tomorrow_5(),
    %erlang:send_after(ToTomorrowSec * 1000, self(), cmd_daily_reset),
    {_, NModPlayerState} = daily_reset(NewModPlayerState, false),
    %% update_combat_attri(PlayerId),
    self() ! cmd_do_notify_update,
    ?DEBUG("mod_player start pid ~p~n", [self()]),
    {noreply, NModPlayerState};
handle_cast({new_skill, AddSkillList}, #mod_player_state{skill_list = SkillList} = State) ->
    {noreply, State#mod_player_state{skill_list = AddSkillList ++ SkillList}};
handle_cast({recharge, Gold, NewGifts}, 
            #mod_player_state{pay_gifts = PayGifts,
                              pid = Pid,
                              client_pid = ClientPid,
                              player = #player{return_gold = OldReturn} = Player} = State) ->
    lib_pay_gifts:league_recharge_gold(Player, Gold),
    ?DEBUG("Mod_player Gold: ~p", [Gold]),
    NewPlayer = lib_player:add_money(Player, Gold, ?GOODS_TYPE_VGOLD, ?INCOME_RECHARGE),
    NPlayer = NewPlayer#player{return_gold = OldReturn + lib_pay_gifts:return_gold(Gold)},
    inner_cmd_send_player_delta(Pid, inner_compare_player(Player, NPlayer)),
    packet_misc:send_packet(0, 0, ClientPid),
    if
        NewGifts =:= [] ->
            {noreply, State#mod_player_state{
                        player = NPlayer}
                       };
        true ->
            lib_pay_gifts:recharge_send_msg(Player, NewGifts),
            hdb:dirty_write(pay_gifts, NewGifts),
            {noreply, State#mod_player_state{
                        pay_gifts = [lib_pay_gifts:dirty_gifts(NewGifts)|PayGifts],
                        player = NPlayer}
                       }
    end;

handle_cast({invite_in_league, BossName, LeagueName, LeagueId}, #mod_player_state{
                                                                   client_pid = ClientPid
                                                                  } = State) ->
    ?DEBUG("BossName: ~p, LeagueName: ~p", [BossName, LeagueName]),
    {ok, Bin} = pt_40:write(40110, {BossName, LeagueName, LeagueId}),
    packet_misc:put_packet(Bin),
    packet_misc:send_packet(0, 0, ClientPid),
    {noreply, State};

handle_cast(request_player_gifts, #mod_player_state{
                                     client_pid = ClientPid,
                                     player = Player
                                    } = State) ->
    case lib_pay_gifts:get_request_msg(Player) of
        {fail, _} ->
            skip;
        MsgList ->
            {ok, Bin} = pt_40:write(40204, MsgList),
            packet_misc:put_packet(Bin),
            packet_misc:send_packet(0, 0, ClientPid)
    end,
    {noreply, State};

handle_cast(notice_master_msg, #mod_player_state{
                                  client_pid = ClientPid,
                                  player = Player
                                 } = State) ->
    case lib_master:get_cards_request_msg(Player#player.id) of
        {fail, _} ->
            skip;
        MsgList ->
            {ok, Bin} = pt_40:write(40606, MsgList),
            packet_misc:put_packet(Bin),
            packet_misc:send_packet(0, 0, ClientPid)
    end,
    {noreply, State};

handle_cast({cmd_league_kicked, Binary}, #mod_player_state{client_pid = ClientPid} = State) ->
    packet_misc:directly_send_packet(ClientPid, 0, Binary),
    {noreply, State#mod_player_state{league_info = []}};
%% 玩家进程向客户端发送消息
%% handle_cast({cmd_send, Msg}, #mod_player_state{bin_list = BinaryList} = State) ->
    
%%     %gen_server:cast(State?PLAYER_SEND_PID, {cmd_send, Msg}),
%%     {noreply, State#mod_player_state{bin_list = BinaryList ++ [Msg]}, 0};

handle_cast({boss_down, BossId, Reward}, #mod_player_state{boss_list = BossList,
                                                           pid = Pid,
                                                           player = Player} = State) ->
    NewBossList = lists:keydelete(BossId, #bossinfo.boss_id, BossList),
    NewState = 
        if
            Reward =:= [] ->
                State;
            true ->
                %GetReward = lib_reward:generate_reward_list(Reward),
                case lib_reward:take_reward(State, Reward, ?INCOME_BOSS_KILLED) of
                    {ok, NState} ->
                        inner_cmd_send_player_delta(Pid, inner_compare_player(Player, NState?PLAYER)),
                        NState;
                    _ ->
                        ?WARNING_MSG("take_reward error ~p~n", []),
                        State
                end
        end,
    packet_misc:send_packet(0, 0, NewState#mod_player_state.client_pid),
    {noreply, NewState#mod_player_state{boss_list = NewBossList}};

handle_cast({boss_damage, Damage, 
             Rec, BossState, Rank}, State) ->
    {ok, Bin} = pt_17:write(17001, {Damage, Rec, BossState, Rank}),
    packet_misc:put_packet(Bin),
    packet_misc:send_packet(0, 0, State#mod_player_state.client_pid),
    {noreply, State};

handle_cast({send_to_client, Bin}, State) ->
    packet_misc:put_packet(Bin),
    packet_misc:send_packet(0, 0, State#mod_player_state.client_pid),
    {noreply, State};
handle_cast({invited_in_team, InvitorName, DungeonId, TeamNum}, 
            #mod_player_state{client_pid = ClientPid} = State) ->
    {ok, Bin} = pt_13:write(13201, {InvitorName, DungeonId, TeamNum}),
    packet_misc:put_packet(Bin),
    packet_misc:send_packet(0, 0, ClientPid),
    {noreply, State};

handle_cast(team_kick, #mod_player_state{client_pid = ClientPid} = State) ->
    {ok, Bin} = pt_13:write(13203, null),
    packet_misc:put_packet(Bin),
    packet_misc:send_packet(0, 0, ClientPid),
    {noreply, State};

handle_cast({team_start, #base_dungeon_area{id = DungeonId,
                                            dungeon_type = Type} = Dungeon, MonsDropInfoList, AllDrops, Number, TeamFlag}, 
            #mod_player_state{client_pid = ClientPid} = State) ->
    NewDungeonInfo = 
        #dungeon_info{
           dungeon_id = DungeonId,
           monsters_rewards = MonsDropInfoList,
           free_card_times = Dungeon#base_dungeon_area.free_card_times,
           pay_card_times  = Dungeon#base_dungeon_area.pay_card_times,
           relive_times = Dungeon#base_dungeon_area.relive,
           team_type = ?TEAM_TYPE_TEAM,
           team_flag = TeamFlag,
           team_id = Number},
    NewState = State#mod_player_state{dungeon_info = NewDungeonInfo},
    {ok, Bin} = pt_12:write(12001, 
                            {DungeonId, Type, NewDungeonInfo, AllDrops}),
    packet_misc:put_packet(Bin),
    packet_misc:send_packet(0, 0, ClientPid),
    {noreply, NewState};

%% handle_cast({cmd_send_info, Info}, #mod_player_state{bin_list = BinaryList} = State) ->
%%     {ok, BinData} = pt:pack(9001, #pberror{error_code = Info}),
%%     {noreply, State#mod_player_state{bin_list = BinaryList ++ [BinData]}, 0};

%%统一处理gm命令
handle_cast({gmcmd, Info}, ModPlayerState) ->
    inner_handle_gmcmd(Info, ModPlayerState);

%% @doc 处理socket协议 (cmd：命令号; data：协议数据)
handle_cast({cmd_socket_event, ResendFlag, Cmd, Data}, 
            #mod_player_state{client_pid = ClientPid} = State) ->
    %% 游戏基础协议功能处理
    case pt:routing(Cmd) of
        {_, HandleModule} ->
            %% 根据routing表调用对应的回调函数
            %% 路由错误，无对应的routing处理回调

            %% 更新session时效
            Now = os:timestamp(), 
            put(last_cmd_timestamp, Now),

            ?DEBUG("mod_player routing: id = ~p, cmd = ~p, ResendFlag ~p data = ~p~n", 
                   [State?PLAYER_ID, Cmd, ResendFlag, Data]),
            %%?DEBUG("friends_cnt ~p~n", [State?PLAYER_FRIENDS_CNT]),
            %%statistics:proto_handle_start(Cmd),
            NewReturn = inner_handle_new(ClientPid, Cmd, HandleModule, State, Data, ResendFlag),
            lib_log_player:flush(State?PLAYER_ID),
            End = os:timestamp(),
            %%statistics:proto_handle_end(Cmd),
            statistics:proto(Cmd, timer:now_diff(End, Now)),
            NewReturn;
        _ ->
            ?ERROR_MSG("routing failed: ~p~n", [Cmd]),
            {noreply, State}
    end;

handle_cast(tcp_disconnect, Status) ->
    ?INFO_MSG("Player ~p tcp_disconnect~n", [Status?PLAYER_ID]),
    inner_handle_disconnect(Status),
    {noreply, Status#mod_player_state{player = Status#mod_player_state.player#player{online_flag = ?PLAYER_OFFLINE},
                                      socket = undefined,
                                      client_pid = undefined
                                     }};
handle_cast({update_goods_send_timestamp, Timestamp}, Status) ->
    {noreply, Status#mod_player_state{
                player = Status#mod_player_state.player#player{goods_update_timestamp = Timestamp}
                %% bag = Status#mod_player_state.bag#player_goods{
                %%                                }
               }};

handle_cast({cmd_delete_goods_by_id, GoodsId}, #mod_player_state{
                                                  bag = Bag,
                                                  client_pid = ClientPid
                                                 } = ModPlayerState) ->
    case lib_goods:delete_goods_by_id(Bag, {GoodsId, 1}) of
        {fail, _Reason} ->
            {noreply, ModPlayerState};
        {ok, NewBag, Update, Del} ->
            pt_15:pack_goods([], Update, Del),
            packet_misc:send_packet(0, 0, ClientPid),
            {noreply, ModPlayerState#mod_player_state{
                        bag = NewBag
                       }}
    end;

handle_cast({cmd_add_goods, Goods}, #mod_player_state{
                                       bag = Bag,
                                       client_pid = ClientPid
                                      } = ModPlayerState) ->
    pt_15:pack_goods([Goods], [], []),
    packet_misc:send_packet(0, 0, ClientPid),
    {noreply, ModPlayerState#mod_player_state{
                bag = [Goods | Bag]
               }};

%% @doc 停止角色进程(Reason 为停止原因)
handle_cast({stop, Reason}, #mod_player_state{client_pid = ClientPid} = State) ->
    ?INFO_MSG("mod_player stop, PlayerId:~w, Reason:~w~n",
              [State?PLAYER_ID, Reason]),
    if
        is_pid(ClientPid) ->
            case Reason of
                normal ->
                    skip;
                Other ->
                    {ok, BinData} = pt_10:write(10007, Other),
                    packet_misc:put_packet(BinData),
                    packet_misc:send_packet(0, 0, ClientPid) 
            end;
        true ->
            %%客户端都死掉了，就不用管了
            skip
    end,
    {stop, normal, State};

%% @doc 设置用户信息
handle_cast({cmd_update_player, NewPlayer}, State)
  when is_record(NewPlayer, player)->
    {noreply, State#mod_player_state{player = NewPlayer}};

%% @doc 消费金钱
%% handle_cast({cmd_cost_money, Sum, Type, PointId}, 
%%             #mod_player_state{player = Player,
%%                               pid = Pid} = State) ->
%%     case lib_player:cost_money(Player, Sum, Type, PointId) of
%%         {ok, NewPlayer} ->
%%             inner_cmd_send_player_delta(Pid, inner_compare_player(Player, NewPlayer)),
%%             {reply, {ok, NewPlayer}, State#mod_player_state{player = NewPlayer}};
%%         {fail, Reason} ->
%%             {reply, {fail, Reason}, State}
%%     end;


%% @doc 有新的充值信息
handle_cast(cmd_new_pay_info, #mod_player_state{pid = Pid,
                                                player = Status} = State) ->
    ?WARNING_MSG("cmd_new_pay_info~n", []),
    case lib_player:new_pay_info(Status) of
        {ok, NewPlayerStatus} ->
            inner_cmd_send_player_delta(Pid, inner_compare_player(Status, NewPlayerStatus)),
            {noreply, State#mod_player_state{player = NewPlayerStatus}};
        Error ->
            ?ERROR_MSG("~n Player new pay error=~p, Status=~p",
                       [Error, Status]),
            {noreply, State}
    end;
handle_cast({cmd_task_event_list, TaskInfoList},  State) ->
    NewModPlayerState = 
        lists:foldl(fun(TaskInfo, AccState) ->
                            lib_task:task_event(AccState, TaskInfo)
                    end, State, TaskInfoList),
    {noreply, NewModPlayerState};
handle_cast({cmd_task_event, TaskInfo}, State) ->
    %%?WARNING_MSG("task client pid ~p~n", [State#mod_player_state.client_pid]),
    NewModPlayerState = lib_task:task_event(State, TaskInfo),
    {noreply, NewModPlayerState};
handle_cast({cmd_take_reward, Reward}, State) ->
    case lib_reward:take_reward(State, Reward, ?INCOME_TASK_REWARD) of
        {fail, _} ->
            {noreply, State};
        {ok, NewState} ->
            {noreply, NewState}
    end;
handle_cast({cmd_lvlup_add_task, OldLv}, State) ->
    NewState = lib_task:lvlup_may_add_task(State, OldLv),
    {noreply, NewState};
handle_cast(cmd_update_combat_attri, State) ->
    case get(notify_update_combat_attri_timer_ref) of
        undefined ->
            Ref = erlang:send_after(60000, self(), cmd_do_notify_update),
            put(notify_update_combat_attri_timer_ref, Ref);
        _Ref ->
            ignored
    end,
    {noreply, State};
%% @doc 默认回调
handle_cast(Event, State) ->
    %% 监控记录接收到的最后的消息
    ?WARNING_MSG("mod player cast: ~p~n~p~n", [Event, State]),
    {noreply, State}.

%%处理发包
handle_info(timeout, State) ->
    {noreply, State};

%%如果是client断开了，就不用管
handle_info({'EXIT', From, Reason}, #mod_player_state{client_pid = From} = State) ->
    ?DEBUG("client process exit Reason ~p~n", [Reason]),
    {noreply, State#mod_player_state{client_pid = undefined,
                                     socket = undefined}};
handle_info({'EXIT', From, Reason}, State) ->
    ?DEBUG("mod_player stop Reason ~p From ~p ClientPid ~p~n", [Reason, From, State#mod_player_state.client_pid]),
    {stop, normal, State};
%% 处理handle_info回调
%% do_handle_info返回值如果是{noreply, NewState}，就直接返回
%% do_handle_info返回值如果是{ok, NewState}，
%% 这个时候就要去比对player是否发送改变发送13018
handle_info(Info, State) ->
    case catch do_handle_info(Info, State) of
        {noreply, NewState} ->
            {noreply, NewState};
        {ok, NewState} ->
            inner_handle_info(State?PLAYER, NewState);
        {stop, NewState} ->
            {stop, normal, NewState};
        EXIT ->
            ?WARNING_MSG("mod_player_info: ~p~n~p~n", [EXIT, erlang:get_stacktrace()]),
            {noreply, State}
    end.

do_handle_info(cmd_do_notify_update, State) ->
    ?DEBUG("cmd_do_notify_update",[]),
    erase(notify_update_combat_attri_timer_ref),
    mod_combat_attri:update_combat_attri(State?PLAYER_ID),
    {noreply, State};

%% @doc 每隔一段时间保存一次状态中的数据
do_handle_info(cmd_auto_save_player, State) ->
    ?DEBUG("auto save ~p~n", [State?PLAYER_ID]),
    erlang:send_after(?PLAYER_SAVE_SPAN, self(), cmd_auto_save_player),
    NewState =  inner_save_to_db(State),
    %% 检查session时效
    case get(last_cmd_timestamp) of
        undefined ->
            put(last_cmd_timestamp, 0),
            {noreply, NewState};
        LastCmdTimestmp ->
            Now = time_misc:unixtime(),
            if
                LastCmdTimestmp + ?PLAYER_STOP_TIME < Now -> %% SESSION 时效为1小时
                    ?INFO_MSG("session timeout mod_player:stop() PlayerId:~w, LastCmdTimestmp ~p~n",
                              [State#mod_player_state.player#player.id, LastCmdTimestmp]),
                    {stop, NewState};
                    %mod_player:stop(State#mod_player_state.pid, ?STOP_SESSION_TIMEOUT);
                true -> 
                    {noreply, NewState}
            end
    end;

%% @doc 每日重置回调
do_handle_info(cmd_daily_reset, State) ->
    ?WARNING_MSG("mod_player daily_reset ~n", []),
    %erlang:send_after(?ONE_DAY_SECONDS * 1000, self(), cmd_daily_reset),
    case daily_reset(State, true) of
        {false, State} ->
            %% 已经重置过了
            {noreply, State};
        {true, NewState} ->
            {noreply, NewState}
    end;

do_handle_info(cmd_vigor_recover, #mod_player_state{player = Player
                                                   } = State) ->
    erlang:send_after(?VIGOR_RECOVER_TIME * 1000, self(), cmd_vigor_recover),
    NewVigor = lib_player:add_vigor_not_overflow(Player#player.lv, Player#player.vigor, 1),
    {noreply, State#mod_player_state{player = Player#player{vigor = NewVigor}}};

%% 发送活动邮件
%% do_handle_info(refresh_activity_mail, #mod_player_state{player = Player} = State) ->
%%     Time = hmisctime:get_seconds_to_tomorrow_5(),
%%     Current = hmisctime:unixtime(),
%%     erlang:send_after(Time*1000, self(), refresh_activity_mail),
%%     case hmisctime:is_same_date_of_5(Player#player.timestamp_login,  Current) of
%%         true -> 
%%             {noreply, State};
%%         false ->
%%             NewPlayer = Player#player{mail_flag = 0},
%%             NewPlayer2 = send_activity_mail(NewPlayer),
%%             %% 发送活动列表
%%             pp_activity:handle(34001, NewPlayer2, 0)
%%     end;
    
do_handle_info(Info, State) ->
    ?WARNING_MSG("mod_player_info: ~p~n~p~n", [Info, State]),
    {noreply, State}.

%% @doc 保存内存数据到数据库
%% @spec
%% @end
inner_save_to_db(#mod_player_state{player       = Player,
                                   relationship = RelaList,
                                   bag          = BagCache,
                                   task_list    = TaskList,
                                   dungeon_mugen = DungeonMugen,
                                   super_battle = SuperBattle,
                                   daily_dungeon = DailyDungeon,
                                   dungeon_list = DungeonList,
                                   mugen_reward = MugenRewardList,
                                   skill_list = SkillList,
                                   skill_record = SkillRecord,
                                   source_dungeon = SourceDungeon,
                                   player_cost_state = PlayerCostState,
                                   operators_mail_list = OperatorsMailList,
                                   sterious_shop = SteriousShop,
                                   vice_shop = ViceShop,
                                   ordinary_shop = OrdinaryShop,
                                   main_shop = MainShop,
                                   activity_record = ActivityRecord,
                                   choujiang_info = ChoujiangInfo,
                                   pay_gifts = Gifts,
                                   advance_reward = Advance,
                                   vip_reward = VipReward,
                                   general_store_list = GeneralStoreList
                                  } = State) ->
    hdb:dirty_write(player, Player),
    lib_player:handle_cost_coin_rank(Player, PlayerCostState#player_cost_state.cost_coin_last),
    lib_player:handle_cost_gold_rank(Player, PlayerCostState#player_cost_state.cost_gold_last),

    NewRelaList = lib_relationship:save(RelaList),
    NewBagCache = lib_goods:save_bag(BagCache),
    NewTaskList = lib_task:auto_save(TaskList),
    NewDungeonList = lib_dungeon:save_dungeon(DungeonList),
    NewDungeonMugen = lib_dungeon:save_mugen(DungeonMugen),
    NewSuperBattle = lib_dungeon:save_super_battle(SuperBattle),
    NewDailyDungeon = lib_dungeon:save_daily_dungeon(DailyDungeon),
    NewMugenRewardList = lib_dungeon:save_mugen_reward(MugenRewardList),
    NewSkillList = lib_player:save_skill(SkillList),
    NewSkillRecord = lib_player:save_skill_record(SkillRecord),
    NewSourceDungeon = lib_dungeon:save_source_dungeon(SourceDungeon),
    State#mod_player_state{relationship = NewRelaList,
                           bag          = NewBagCache,
                           task_list    = NewTaskList,
                           dungeon_list = NewDungeonList,
                           dungeon_mugen = NewDungeonMugen,
                           daily_dungeon = NewDailyDungeon,
                           super_battle = NewSuperBattle,
                           mugen_reward = NewMugenRewardList,
                           skill_list = NewSkillList,
                           skill_record = NewSkillRecord,
                           source_dungeon = NewSourceDungeon,
                           operators_mail_list = lib_mail:save(OperatorsMailList),
                           player_cost_state = PlayerCostState#player_cost_state{
                                                 cost_coin_last = Player#player.cost_coin,
                                                 cost_gold_last = Player#player.cost_gold
                                                },
                           sterious_shop = lib_shop:save_sterious_shop(SteriousShop),
                           vice_shop = lib_shop:save_vice_shop(ViceShop),
                           ordinary_shop = lib_shop:save_ordinary_shop(OrdinaryShop),
                           main_shop = lib_shop:save_main_shop(MainShop),
                           activity_record = lib_shop:save_activity_shop(ActivityRecord),
                           choujiang_info = lib_choujiang:save_choujiang_info(ChoujiangInfo),
                           pay_gifts = lib_pay_gifts:save_gifts(Gifts),
                           advance_reward = lib_advance_reward:save(Advance),
                           vip_reward = lib_player:save_vip_reward(VipReward),
                           general_store_list = lib_shop:save_general_store_list(GeneralStoreList)
                          }.



%% --------------------------------------------------------------------
%% Function: terminate/2
%% Description: Shutdown the server
%% Returns: any (ignored by gen_server)
%% --------------------------------------------------------------------
terminate(Reason, #mod_player_state{player = Player,
                                    dungeon_info = DungeonInfo} = State) ->
    %% eprof:stop_profiling(),
    %% eprof:analyze(total, [{sort, calls}]),
    ?DEBUG("Oh myGod the mod_player process exit, Reason: ~n~p~n", [Reason]),
    %{DungeonId, _} = Player#player.last_dungeon,
    hmisc:delete_monitor_pid(self()),
    Current = time_misc:unixtime(),
    %% gen_server:cast(mod_monitor, {cmd_update_player_count, -1}),
    %mod_monitor:reset_player_online_count(),
    %mod_player_rec:del_player(Player),
    NewPlayer = Player#player{
                  online_flag      = ?PLAYER_OFFLINE,
                  timestamp_logout = Current},
    inner_save_to_db(State#mod_player_state{player = NewPlayer}),
    %% 卸载角色数据
    unload_player_info(NewPlayer),
    lib_team:leave_team(State?PLAYER_ID),
    %% gproc:unreg(hmisc:player_process_name(Player#player.id)),
    DungeonTeamId = DungeonInfo#dungeon_info.team_id,
    if
        is_integer(DungeonTeamId) andalso DungeonTeamId > 0 ->
            mod_dungeon_match:leave(NewPlayer#player.id, DungeonTeamId);
        true ->
            skip
    end,     
    %% %% 通知scoket进程关闭
    %% 去掉这个，由退出消息来管理
    %% if
    %%     Reason =:= change_role ->
    %%         ?DEBUG("change_role skip~n", []),
    %%         skip;
    %%     true ->
    %%         tcp_client_handler:stop(State?PLAYER_SEND_PID)
    %% end,
    ok.

%% --------------------------------------------------------------------
%% Func: code_change/3
%% Purpose: Convert process state when code is changed
%% Returns: {ok, NewState}
%% --------------------------------------------------------------------
code_change(_oldvsn, Status, _extra) ->
    {ok, Status}.

%%
%% ------------------------私有函数------------------------
%%
%% 加载角色数据
load_player_info(#client{player_id = PlayerId,
                         addr      = _SocketIp}) ->
    NowTime = time_misc:unixtime(),
    %% 获取角色基本信息
    LastLoginTime = NowTime + 5,
    case hdb:dirty_read(player, PlayerId, true) of
        #player{
           vigor            = LastVigor,
           lv               = Lv,
           total_login_days = LastLoginDays,
           timestamp_login  = LastLogin,
           timestamp_logout = LastLogout} = Player1 ->
            %% 更新登录信息并初始化玩家体力及挂机
            {NewVigor, NextRecover} = lib_player:init_player_vigor(LastVigor, LastLogout, NowTime, Lv),
            erlang:send_after(NextRecover * 1000, self(), cmd_vigor_recover),
            Player2 = 
                Player1#player{
                  vigor = NewVigor,
                  total_login_days = 
                      lib_player:init_login_days(
                        LastLoginDays,
                        LastLogin,
                        NowTime)
                 },
            %% if 
            %%     Player2#player.total_login_days =/= 
            %%     Player1#player.total_login_days ->
            %%         lib_player:send_login_reward(Player2);
            %%     true ->
            %%         ingore
            %% end,
            %% 检查充值信息
            Player3 = case lib_player:new_pay_info(Player2) of
                          {ok, PlayerStatus0} ->
                              PlayerStatus0;
                          _ ->
                              Player2
                      end,
            UnlockPlayer = Player3#player{
                             status = ?PLAYER_STATUS_NORMAL 
                            },
            Player4 = lib_player:init_login_reward(UnlockPlayer, NowTime),
            lib_log_player:log_player_login(Player4),
            %% {_, RetPlayer} = daily_reset(UnlockPlayer),
            {ok, Player4#player{timestamp_login = LastLoginTime}};
        Other ->
            ?ERROR_MSG("load player failed: ~p, reason: ~p~n", [PlayerId, Other])
    end.

%% 卸载角色数据
unload_player_info(_Player) ->
    %% 减少一个在线
    ok.

daily_reset(#mod_player_state{player = Player,
                              %% bag = BagCache,
                              task_list = TaskList,
                              %relationship = RelaList,
                              dungeon_mugen = DungeonMugen,
                              super_battle = SuperBattle,
                              source_dungeon = SourceDungeon,
                              player_cost_state = LastCost,
                              sterious_shop = SteriousShop,
                              vice_shop = ViceShop, 
                              ordinary_shop = OrdinaryShop,
                              main_shop = MainShop,
                              choujiang_info = ChoujiangInfo,
                              dungeon_list = DungeonList,
                              pay_gifts = PayGifts,
                              general_store_list = GeneralStoreList
                             } = ModPlayerState, Flag) ->
    Current = time_misc:unixtime(),
    case time_misc:is_same_day(
           Player#player.timestamp_daily_reset, Current) of
        true -> 
            %% 当天已经重置过了
            {false, ModPlayerState};
        false ->
            %% 重置时间戳
            NewModPlayerState = lib_task:daily_reset(ModPlayerState, TaskList, Flag),
            %NewRelaList = lib_relationship:daily_reset(RelaList),
            NPlayer = NewModPlayerState#mod_player_state.player,
            NPlayer1 = may_weekly_reset(NPlayer, Current),
            NPlayer2 = may_month_reset(NPlayer1, Current),
            NewPlayer = 
                NPlayer2#player{timestamp_daily_reset = Current,
                                open_boss_info = [],
                                %% 重置购买体力次数
                                buy_vigor_times = 0,
                                day_buy_num = 0,
                                live_ness = 0,
                                month_login_flag = 0,
                                login_reward_flag = 0
                               },
            %% NewBagCache = lib_pay_gifts:daily_reset_bag_gift(BagCache),
            NewDungeonMugen = lib_dungeon:reset_mugen(DungeonMugen),
            NewSuperBattle = lib_dungeon:reset_super_battle(SuperBattle, Player),
            NewSourceDungeon = lib_dungeon:reset_source_dungeon(SourceDungeon),
            lib_arena:daily_reset(Player),
            lib_cross_pvp:daily_reset(Player),
            NewLastCost = lib_player:daily_reset_cost(Player#player.timestamp_logout, LastCost),
            NPayGifts = lib_pay_gifts:daily_reset_gifts(PayGifts),
            NewPayGifts = lib_pay_gifts:daily_reset_pay_gifts(NPayGifts),
            %% lib_cross_pvp:sign_up(NPlayer),
            lib_player:daily_vip_reward(Player),
            {true, NewModPlayerState#mod_player_state{player = NewPlayer,
                                                      player_cost_state = NewLastCost,
                                                      %% bag = BagCache,
                                                      dungeon_mugen = NewDungeonMugen,
                                                      super_battle = NewSuperBattle,
                                                      source_dungeon = NewSourceDungeon,
                                                      sterious_shop = lib_shop:reset_sterious_shop(SteriousShop),
                                                      vice_shop = lib_shop:reset_vice_shop(ViceShop),
                                                      ordinary_shop = lib_shop:reset_ordinary_shop(OrdinaryShop),
                                                      main_shop = lib_shop:reset_main_shop(MainShop),
                                                      choujiang_info = lib_choujiang:reset_choujiang_info(ChoujiangInfo),
                                                      pay_gifts = NewPayGifts,
                                                      dungeon_list = lib_dungeon:daily_reset_dungeon(DungeonList),
                                                      general_store_list = lib_shop:reset_general_store_list(GeneralStoreList)
                                                     }}
    end.

%% @doc 停止本进程
stop(undefined, _) ->
    skip;
stop(PlayerId, Reason) 
  when is_integer(PlayerId)->
    case hmisc:whereis_player_pid(PlayerId) of
        [] ->
            ?WARNING_MSG("Not Player Pid, PlayerId ~w~n", [PlayerId]);
        Pid ->
            stop(Pid, Reason)
    end;
stop(Pid, Reason) when is_pid(Pid) ->
    gen_server:cast(Pid, {stop, Reason}).

%% @doc update client info
%% @spec
%% @end
update_client_info(PlayerId, Client) 
  when is_integer(PlayerId)->
    case hmisc:whereis_player_pid(PlayerId) of
        [] ->
            ?WARNING_MSG("Not Player Pid, PlayerId ~w~n", [PlayerId]);
        Pid ->
            update_client_info(Pid, Client)
    end;
update_client_info(Pid, Client) 
  when is_pid(Pid)->    
    gen_server:call(Pid, {update_client_info, Client}).

%% @doc get session, default is undefined
%% @spec
%% @end
get_session(PlayerId) 
  when is_integer(PlayerId)->
    case hmisc:whereis_player_pid(PlayerId) of
        [] ->
            ?WARNING_MSG("Not Player Pid, PlayerId ~w~n", [PlayerId]),
            {undefined, 0};
        Pid ->
            get_session(Pid) 
    end;
get_session(Pid) 
  when is_pid(Pid)->
    gen_server:call(Pid, get_session).

get_last_flag(PlayerId) ->
    case hmisc:whereis_player_pid(PlayerId) of
        [] ->
            ?WARNING_MSG("Not Player Pid, PlayerId ~w~n", [PlayerId]),
            0;
        Pid ->
            gen_server:call(Pid, get_last_flag)
    end.

get_client_pid(PlayerId) ->
    case hmisc:whereis_player_pid(PlayerId) of
        [] ->
            undefined;
        Pid ->
            gen_server:call(Pid, get_client_pid)
    end.
%%for online request
get_player(Pid) when is_pid(Pid) ->
    gen_server:call(Pid, cmd_player);
get_player(PlayerId) ->
    case hmisc:whereis_player_pid(PlayerId) of
        [] ->
            [];
        Pid ->
            ?DEBUG("PlayerId ~p~n", [PlayerId]),
            gen_server:call(Pid, cmd_player)
    end.

get_player_detail(Pid) when is_pid(Pid) ->
    gen_server:call(Pid, get_mod_player);
get_player_detail(_) ->
    [].

get_player_goods(Pid, GoodsId) when is_pid(Pid) ->
    gen_server:call(Pid, {get_goods, GoodsId});
get_player_goods(_, _) ->
    [].

%% 增加物品BaseGoodsList
%% inner_add_goods_list(#mod_player_state{bag = Bag} = ModPlayerState, GoodsInfo) ->
%%     case lib_goods:add_goods_list(ModPlayerState?PLAYER_ID, Bag, GoodsInfo) of
%%         {AddList, UpdateList, NewGoodsList} ->
%%             pt_15:pack_goods(AddList, UpdateList, []),
%%             packet_misc:send_packet(0, ModPlayerState?PLAYER_SEND_PID),
%%             {ok, ModPlayerState#mod_player_state{bag = NewGoodsList}};
%%         {fail, _R} = Ret->
%%             Ret
%%     end.

delete_goods_by_id(Pid, GoodsId) ->
    gen_server:cast(Pid, {cmd_delete_goods_by_id, GoodsId}).

add_goods(Pid, Goods) ->
    gen_server:cast(Pid, {cmd_add_goods, Goods}).

send_info(PlayerId, Info) 
  when is_integer(PlayerId)->
    case hmisc:whereis_player_pid(PlayerId) of
        [] ->
            ?WARNING_MSG("Not Player Pid, PlayerId ~w~n", [PlayerId]),
            ingore;
        Pid ->
            send_info(Pid, Info)
    end;
send_info(#mod_player_state{
             pid = Pid
            }, Info) ->
    send_info(Pid, Info);
send_info(PlayerPid, Info)
  when is_pid(PlayerPid) andalso is_integer(Info) ->
    gen_server:cast(PlayerPid, {cmd_send_info, Info});
send_info(Mod, Msg) ->
   ?WARNING_MSG("send_info error ~w, ~w", [Mod, Msg]),
    ignore.

send(PlayerId, Msg) 
  when is_integer(PlayerId)->
    case hmisc:whereis_player_pid(PlayerId) of
        [] ->
            ?WARNING_MSG("Not Player Pid, PlayerId ~w~n", [PlayerId]),
            ingore;
        Pid ->
            send(Pid, Msg)
    end;
send(#mod_player_state{
        pid = Pid
       }, Msg) 
  when is_pid(Pid) ->
    send(Pid, Msg);
send(PlayerPid, Msg) 
  when is_pid(PlayerPid) ->
    gen_server:cast(PlayerPid, {cmd_send, Msg});
send(Mod, Msg) ->
    ?WARNING_MSG("send error ~w, ~w", [Mod, Msg]),
    ignore.

send_to_client(PlayerId, Bin) when is_integer(PlayerId) ->
    case hmisc:whereis_player_pid(PlayerId) of
        [] ->
            ?WARNING_MSG("Not Player Pid, PlayerId ~w~n", [PlayerId]),
            ingore;
        Pid ->
            send_to_client(Pid, Bin)
    end;
send_to_client(Pid, Bin) when is_pid(Pid) ->
    gen_server:cast(Pid, {send_to_client, Bin}).

new_pay_info(PlayerId) 
  when is_integer(PlayerId)->
    case hmisc:whereis_player_pid(PlayerId) of
        [] ->
            ?WARNING_MSG("Not Player Pid, PlayerId ~w~n", [PlayerId]),
            ingore;
        Pid ->
            new_pay_info(Pid) 
    end;
new_pay_info(Pid) 
  when is_pid(Pid) ->
    gen_server:cast(Pid, cmd_new_pay_info).

tcp_disconnect(PlayerId) 
  when is_integer(PlayerId)->
    case hmisc:whereis_player_pid(PlayerId) of
        [] ->
            ?WARNING_MSG("Not Player Pid, PlayerId ~w~n", [PlayerId]),
            ingore;
        Pid ->
            tcp_disconnect(Pid) 
    end;
tcp_disconnect(Pid) 
  when is_pid(Pid) ->
    gen_server:cast(Pid, tcp_disconnect).

update_goods_send_timestamp(PlayerId, Timestamp) 
  when is_integer(PlayerId)->
    case hmisc:whereis_player_pid(PlayerId) of
        [] ->
            ?WARNING_MSG("Not Player Pid, PlayerId ~w~n", [PlayerId]),
            ingore;
        Pid ->
            update_goods_send_timestamp(Pid, Timestamp)
    end;
update_goods_send_timestamp(Pid, Timestamp) 
  when is_pid(Pid)->
    gen_server:cast(Pid, {update_goods_send_timestamp, Timestamp}).

banrole(PlayerId, UnLockTimestamp) ->
    case hmisc:whereis_player_pid(PlayerId) of
        [] ->
            case hdb:dirty_read(player, PlayerId) of
                [] ->
                    ingore;
                Player ->
                    hdb:dirty_write(player, Player#player{
                                              status = if 
                                                           UnLockTimestamp > 0 -> 
                                                               ?PLAYER_STATUS_BANNED;
                                                           true ->
                                                               ?PLAYER_STATUS_NORMAL
                                                       end,
                                              unlock_role_timestamp = UnLockTimestamp
                                             })
            end;
        Pid ->
            gen_server:cast(Pid, {modify_player, [{unlock_role_timestamp, UnLockTimestamp},
                                                  {status, ?PLAYER_STATUS_BANNED}]}),
            gen_server:cast(Pid, {stop, ?STOP_REASON_KICK_OUT})
    end.

task_event_list(Pid, TaskInfo)
  when is_list(TaskInfo) ->
    gen_server:cast(Pid,  {cmd_task_event_list, TaskInfo}).
task_event(Pid, TaskInfo) 
  when is_pid(Pid)->
    gen_server:cast(Pid, {cmd_task_event, TaskInfo});
task_event(#mod_player_state{pid = Pid}, TaskInfo) ->
    gen_server:cast(Pid, {cmd_task_event, TaskInfo});
task_event(PlayerId, TaskInfo) -> 
    case hmisc:whereis_player_pid(PlayerId) of
        [] ->
            skip;
        Pid ->
            gen_server:cast(Pid, {cmd_task_event, TaskInfo})
    end.

%% take_reward(PlayerId, Reward) ->
%%     case hmisc:whereis_player_pid(PlayerId) of
%%         [] ->
%%             skip;
%%         Pid ->
%%             gen_server:cast(Pid, {cmd_take_reward, Reward})
%%     end.

lvlup_may_add_task(OldLv) ->
    gen_server:cast(self(), {cmd_lvlup_add_task, OldLv}).

boss_killed(PlayerId, BossId, Reward) ->
    case hmisc:whereis_player_pid(PlayerId) of
        [] ->
            skip;
        Pid ->
            gen_server:cast(Pid, {boss_down, BossId, Reward})
    end.

boss_damage(PlayerId, {Damage, Rec, BossState, Rank}) ->
    case hmisc:whereis_player_pid(PlayerId) of
        [] ->
            skip;
        Pid ->
            gen_server:cast(Pid, {boss_damage, Damage, 
                                  Rec, BossState, Rank})
    end.

invited_in_team(PlayerId, InvitorName, DungeonId, TeamNum) ->
    case hmisc:whereis_player_pid(PlayerId) of
        [] ->
            skip;
        Pid ->
            gen_server:cast(Pid, {invited_in_team, InvitorName, DungeonId, TeamNum})
    end.
team_kick(PlayerId) ->
    case hmisc:whereis_player_pid(PlayerId) of
        [] ->
            skip;
        Pid ->
            gen_server:cast(Pid, team_kick)
    end.
team_start(PlayerId, {Dungeon, MonsDropInfoList, AllDrops, Number, TeamFlag}) ->
    case hmisc:whereis_player_pid(PlayerId) of
        [] ->
            skip;
        Pid ->
            gen_server:cast(Pid, {team_start, Dungeon, MonsDropInfoList, AllDrops, Number, TeamFlag})
    end.
%%应对加经验对应的加技能
new_skill(_, []) ->
    skip;
new_skill(PlayerId, SkillList) ->
    case hmisc:whereis_player_pid(PlayerId) of
        [] ->
            %%这个是不希望发生的事情
            lists:foreach(fun(Skill) ->
                                  hdb:dirty_write(player_skill, Skill)
                          end, SkillList),
            skip;
        Pid ->
            gen_server:cast(Pid, {new_skill, SkillList})
    end.

daily_reset(Pid) when is_pid(Pid) ->
    Pid ! cmd_daily_reset.

cmd_socket_event(Pid, {ResendFlag, Cmd, Data}) when is_pid(Pid)->
    gen_server:cast(Pid, {cmd_socket_event, ResendFlag, Cmd, Data});
cmd_socket_event(_, _) ->
    skip.

recharge(Pid, Gold, Gifts) ->
    gen_server:cast(Pid, {recharge, Gold, Gifts}).

invite_in_league(Pid, {NickName, LeagueName, LeagueId}) ->
    gen_server:cast(Pid, {invite_in_league, NickName, LeagueName, LeagueId}).

request_player_gifts(Pid) ->
    gen_server:cast(Pid, request_player_gifts).

notice_master_msg(Pid) ->
    gen_server:cast(Pid, notice_master_msg).

league_kicked(PlayerId, Binary) ->
    case hmisc:whereis_player_pid(PlayerId) of
        [] ->
            skip;
        Pid ->
            gen_server:cast(Pid, {cmd_league_kicked, Binary})
    end.

%% notify_pay_info(PlayerId) ->
%%     case hmisc:whereis_player_pid(PlayerId) of
%%         [] ->
%%             skip;
%%         Pid ->
%%             gen_server:cast(Pid, cmd_notify_pay_info)
%%     end.


inner_handle_new(ClientPid, Cmd, HandleModule, State, Data, F) ->
    case get_from_dict() of
        undefined ->
            Return = inner_handle(Cmd, HandleModule, State, Data),
            case packet_misc:send_packet(Cmd, F, ClientPid) of
                ignore ->
                    Return;
                {ok, Bin} ->
                    put_in_dict(1, [{F, Cmd, Bin}]),
                    Return
            end;
        {Size, PacketList} ->
            case lists:keyfind(F, 1, PacketList) of
                {_, Cmd, Bin} ->
                    ?DEBUG("player get cache", []),
                    tcp_client_handler:send(ClientPid, Bin),
                    {noreply, State};
                _ ->
                    ?DEBUG("player not get cache", []),
                    Return = inner_handle(Cmd, HandleModule, State, Data),
                    case packet_misc:send_packet(Cmd, F, ClientPid) of
                        ignore ->
                            Return;
                        {ok, Bin} ->
                            may_delete_overfloat(Size, PacketList, {F, Cmd, Bin}),
                            Return
                    end
            end
    end.

get_from_dict() ->
    get(last_send_packet).
put_in_dict(Size, List) ->
    put(last_send_packet, {Size, List}).

may_delete_overfloat(Size, PacketList, {F, Cmd, Bin}) when Size > ?LAST_PACKET_NUM_HIGH ->
    {Head, _} = list_misc:sublist(PacketList, ?LAST_PACKET_NUM_LOW),
    put_in_dict(?LAST_PACKET_NUM_LOW + 1, [{F, Cmd, Bin}|Head]);
may_delete_overfloat(Size, PacketList, {F, Cmd, Bin}) ->
    put_in_dict(Size + 1, [{F, Cmd, Bin}|PacketList]).

inner_handle(Cmd, HandleModule, #mod_player_state{player = Player,
                                                  pid = Pid} = ModPlayerSate, Data) ->
    case catch HandleModule:handle(Cmd, ModPlayerSate, Data) of
        {ok, NewModPlayerState} when is_record(NewModPlayerState, mod_player_state) ->
            %% player有变更，发送信息给通讯进程
            ?DEBUG("player changed ... ~n", []),
            inner_cmd_send_player_delta(Pid, inner_compare_player(Player, NewModPlayerState?PLAYER)),
            %% 确保每个请求都能回复对应的msg_id 9002不要了
            %% {ok, Binary} = pack_reply(Cmd),
            %% send(Pid, Binary), %% will cast is self.
            {noreply, NewModPlayerState#mod_player_state{session_timestamp = time_misc:unixtime()}};
        {fail, Reason} ->
            packet_misc:put_info(Reason),
            {noreply, ModPlayerSate#mod_player_state{session_timestamp = time_misc:unixtime()}};
        {'EXIT', REASON} ->
            ?WARNING_MSG("Error ~p~n", [erlang:get_stacktrace()]),
            ?WARNING_MSG("handle cmd:~w failed! ~p~n",[Cmd, REASON]),
            ?WARNING_MSG("ModPlayerSate ~w~n", [ModPlayerSate]),
            packet_misc:put_info(?INFO_PLAYER_PROCESS_ERROR),
            {noreply, ModPlayerSate#mod_player_state{session_timestamp = time_misc:unixtime()}};
        _ ->
            {noreply, ModPlayerSate#mod_player_state{session_timestamp = time_misc:unixtime()}}
    end.

inner_handle_info(Player,  #mod_player_state{player = NewPlayer,
                                             pid = Pid} = ModPlayerSate) ->
    ?DEBUG("player changed ... ~n", []),
    inner_cmd_send_player_delta(Pid, inner_compare_player(Player, NewPlayer)),
    {noreply, ModPlayerSate}.


inner_compare_player(Player, NewPlayer) ->
    %%{LeagueId, LeagueName, LeagueTitle} = pt_13:league_info(lib_league:league_name_title_new(PlayerId, Sn)),
    case record_misc:record_modified(pt_13:get_detail_user_pack_info(Player, []), pt_13:get_detail_user_pack_info(NewPlayer, [])) of
        [] ->
            [];
        UpdatePlayer ->
            UpdatePlayer#pbuser{id = Player#player.id}
    end.


%% send_activity_mail(Player) ->
%%     case lib_activity:check_activity(mail) of
%%         false -> Player;
%%         Value ->
%%             case Player#player.mail_flag of
%%                 0 ->
%%                     case lib_mail:send_sys_mail(
%%                            Player#player.id, 
%%                            "各种活动",
%%                            Value) of
%%                         ok ->
%%                             Player#player{mail_flag = 1};
%%                         _ -> 
%%                             Player
%%                     end;
%%                 1 ->
%%                     Player
%%             end
%%     end.

%% pack_reply(Cmd) ->
%%     pt:pack(9002, #pbid32{id = Cmd}).

inner_cmd_send_player_delta(_, []) ->
    ignore;
inner_cmd_send_player_delta(_Pid, PbUser) ->
    {ok, BinData} = pt_13:write(13018, PbUser),
    packet_misc:put_packet(BinData).
    %send(Pid, BinData).


%%----------处理gm命令---------------%%
%% inner_handle_gmcmd({cmd_add_goodslist, GoodsInfo, _LogType}, ModPlayerState) ->
%%     case inner_add_goods_list(ModPlayerState, GoodsInfo) of
%%         {ok, NewModPlayerState} ->
%%             {noreply, NewModPlayerState};
%%         {fail, Reason} ->
%%             send_info(ModPlayerState, Reason),
%%             {noreply, ModPlayerState}
%%     end;
%% inner_handle_gmcmd({cmd_add_money, Sum, Type, PointId}, 
%%                    #mod_player_state{player = Player,
%%                                      pid = Pid} = State) ->
%%     io:format("gmcmd add money ~n", []),
%%     NewPlayer = lib_player:add_money(Player, Sum, Type, PointId),
%%     inner_cmd_send_player_delta(Pid, inner_compare_player(Player, NewPlayer)),
%%     {noreply, State#mod_player_state{player = NewPlayer}};
%% inner_handle_gmcmd({modify_player, ValueList}, #mod_player_state{
%%                                                   player = Player,
%%                                                   pid = Pid
%%                                                  } = State) ->
%%     ?DEBUG("modify_player ~p~n", [ValueList]),
%%     FieldList = record_info(fields, player),
%%     PosList = lists:seq(2, record_info(size, player)),    
%%     PosFieldList =  lists:zip(PosList, FieldList),
%%     NPlayer = lists:foldl(fun({Key, Value}, AccPlayer) ->
%%                                   case lists:keyfind(Key, 2, PosFieldList) of
%%                                       false ->
%%                                           ?WARNING_MSG("Wrong Key ~p~n", [Key]),
%%                                           AccPlayer;
%%                                       {Pos, _} ->
%%                                           setelement(Pos, AccPlayer, Value)
%%                                   end
%%                           end, Player, ValueList),
%%     inner_cmd_send_player_delta(Pid, inner_compare_player(Player, NPlayer)),
%%     {noreply, State#mod_player_state{
%%                 player = NPlayer
%%                }};
%% inner_handle_gmcmd({lvlup, Lv}, #mod_player_state{player = Player} = State) ->
%%     NewPlayer = lib_player:reset_by_lv(Player#player{lv = Lv}),
%%     {noreply, State#mod_player_state{player = NewPlayer}};
%% inner_handle_gmcmd(cmd_bag, #mod_player_state{bag = Bag} = State) ->
%%     io:format("~p~n", [Bag]),
%%     {noreply, State};
%% inner_handle_gmcmd(cmd_task, #mod_player_state{task_list = Tasks} = State) ->
%%     io:format("tasks ~p~n", [Tasks]),
%%     {noreply, State};
%% inner_handle_gmcmd(reset_player_lv, #mod_player_state{player = Player} = State) ->
%%     NewState = State#mod_player_state{player = Player#player{lv = 1, exp = 0}},
%%     {noreply, NewState};
%% inner_handle_gmcmd(cmd_reset_main_task, #mod_player_state{task_list = TaskList} = State) ->
%%     NewTaskList = 
%%         case lists:keyfind(1, #task.type, TaskList) of
%%             false ->
%%                 TaskList;
%%             Task ->
%%                 lists:keystore(Task#task.id, #task.id, TaskList, Task#task{task_id = 1000001, schedule = 0, is_dirty = 1})
%%         end,
%%     {noreply, State#mod_player_state{task_list = NewTaskList}};
%% inner_handle_gmcmd(reset_player_reset_time, #mod_player_state{task_list = TaskList,
%%                                                               player = #player{timestamp_daily_reset = Reset} = Player} = State) ->
%%     NewTaskList = lists:map(fun(#task{last_op = LastOp} = Task) ->
%%                                     if
%%                                         LastOp > 0 ->
%%                                             Task#task{last_op = LastOp - ?ONE_DAY_SECONDS,
%%                                                       is_dirty = 1};
%%                                         true ->
%%                                             Task
%%                                     end
%%                             end, TaskList),
%%     {noreply, State#mod_player_state{task_list = NewTaskList, player = Player#player{timestamp_daily_reset = Reset - ?ONE_DAY_SECONDS}}};

%% inner_handle_gmcmd({add_mugen_times, Times}, #mod_player_state{dungeon_mugen = Mugen} = State) ->
%%     NewMugen = Mugen#dungeon_mugen{rest = Mugen#dungeon_mugen.rest + Times},
%%     {noreply, State#mod_player_state{dungeon_mugen = NewMugen}};
inner_handle_gmcmd({get_cache, Value}, State) ->
    FieldList = record_info(fields, mod_player_state),
    case find_pos(Value, FieldList, 0) of
        not_find ->
            ?ERROR_MSG("not find Value ~p~n", [Value]);
        Pos ->
            Cache = element(Pos+1, State),
            ?PRINT("~p~n~p~n", [Value, Cache])
    end,
    {noreply, State};
%% inner_handle_gmcmd(clear_open_boss, #mod_player_state{player = Player} = State) ->
%%     NewPlayer = Player#player{open_boss_info = []},
%%     {noreply, State#mod_player_state{player = NewPlayer}};
%% inner_handle_gmcmd({task_change, TaskId, ToBaseId}, #mod_player_state{task_list = TaskList} = State) when is_integer(ToBaseId) ->
%%     case lists:keytake(TaskId, #task.id, TaskList) of
%%         false ->
%%             ?WARNING_MSG("task not found ~n", []);
%%         {value, Task, Rest} ->
%%             NewTask = Task#task{task_id = ToBaseId,
%%                                 is_dirty = 1},
%%             {noreply, State#mod_player_state{task_list = [NewTask|Rest]}}
%%     end;
inner_handle_gmcmd(Info, State) ->
    ?ERROR_MSG("gmcmd not match Info ~p~n", [Info]),
    {noreply, State}.

find_pos(_, [], _) ->
    not_find;
find_pos(Value, [Value|_Tail], Num) ->
    Num + 1;
find_pos(Value, [_|Tail], Num) ->
    find_pos(Value, Tail, Num + 1).

%%tcp_disconnect之后的一些处理(包括顶号)，都要把队伍和boss给退掉
inner_handle_disconnect(ModPlayerState) ->
    Player = ModPlayerState?PLAYER,
    lib_log_player:log_player_online(Player#player.sn, Player#player.id, Player#player.accid, Player#player.lv, Player#player.timestamp_login, time_misc:unixtime()),
    lib_team:leave_team(ModPlayerState?PLAYER_ID).

may_weekly_reset(Player, Current) ->
    case time_misc:is_same_week(Player#player.timestamp_daily_reset, Current) of
        true ->
            Player;
        _ ->
            Player#player{boss_open_times = 0}
    end.

may_month_reset(Player, Current) ->
    case time_misc:is_same_month(Player#player.timestamp_daily_reset, Current) of
        true ->
            Player;
        _ ->
            Player#player{month_login_days = 0}
    end.


update_combat_attri(PlayerPid) when is_pid(PlayerPid) ->
    gen_server:cast(PlayerPid, cmd_update_combat_attri);
update_combat_attri(PlayerId) when is_integer(PlayerId) ->
    case hmisc:whereis_player_pid(PlayerId) of
        [] ->
            ?WARNING_MSG("Not Player Pid, PlayerId ~w~n", [PlayerId]);
        Pid ->
            update_combat_attri(Pid)
    end.

get_rc4(PlayerId) 
  when is_integer(PlayerId)->
    case hmisc:whereis_player_pid(PlayerId) of
        [] ->
            ?WARNING_MSG("Not Player Pid, PlayerId ~w~n", [PlayerId]),
            {ok, undefined};
        Pid ->
            get_rc4(Pid) 
    end;
get_rc4(Pid) 
  when is_pid(Pid)->
    gen_server:call(Pid, cmd_get_rc4).
