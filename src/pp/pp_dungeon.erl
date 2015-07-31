-module(pp_dungeon).

-export([
         handle/3
        ]).
-include("define_logger.hrl").
-include("pb_12_pb.hrl").
-include("define_player.hrl").
-include("define_dungeon.hrl").
-include("define_money_cost.hrl").
-include("define_goods_type.hrl").
-include("define_info_0.hrl").
-include("define_dungeon_match.hrl").
%% 进入副本
handle(12001, ModPlayerState, #pbdungeon{id = Id, type = Type}) ->
    case lib_dungeon:try_entry_dungeon(ModPlayerState, Id) of
        {ok, #mod_player_state{dungeon_info = DungeonInfo} = NewModPlayerState, AllDrops} ->
            NewHitReward = lib_dungeon:extra_vip_hit_reward(ModPlayerState?PLAYER_VIP, DungeonInfo#dungeon_info.hit_reward),
            NewDungeonInfo = DungeonInfo#dungeon_info{hit_reward = NewHitReward},
            {ok, Bin} = pt_12:write(12001, {Id, Type, NewDungeonInfo, AllDrops}),
            packet_misc:put_packet(Bin),
            %% OldHitReward是配置表的连击宝箱
            ?DEBUG("OldHitReward ~p VipHitReward ~p~n", [DungeonInfo#dungeon_info.hit_reward, NewHitReward]),
            {ok, NewModPlayerState#mod_player_state{dungeon_info = NewDungeonInfo}};
        {fail, Reason} ->
            %% {info, Reason}
            packet_misc:put_info(Reason)
    end;
	
%% 领取奖励
handle(12002, ModPlayerState, #pbdungeon{id = Id, 
                                         sub_route = Route,
                                         score = Score,
                                         pass_time = CostTime,
                                         reward = PbDungeonReward,
                                         is_extra = IsExtra,
                                         state = PassState,
                                         boss_flag = BossFlag,
                                         target_list = TargetList,
                                         hit_reward = HitReward}) ->
    ?DEBUG("Id ~p, Route ~p IsExtra ~p HitReward~p CostTime ~p~n", [Id, Route, IsExtra, HitReward, CostTime]),
    Reward = 
        lists:map(fun(#pbdungeonreward{goods_id = GoodsId,
                                       number = Num}) ->
                          {GoodsId, Num}
                  end, PbDungeonReward),
    HitReward2 =
        case HitReward of
            [#pbdungeonreward{goods_id = BoxId,
                              number = BoxNum}] when BoxNum > 0->
                [{BoxId, BoxNum}];
            _ ->
                []
        end,
    PassDungeonInfo = #pass_dungeon_info{
                         id = Id,
                         route = Route,
                         score = Score,
                         reward = Reward,
                         state = PassState,
                         is_extra = IsExtra,
                         cost_time = CostTime,
                         boss_flag = BossFlag,
                         target_list = TargetList,
                         hit_reward = HitReward2},
    case lib_dungeon:get_reward_new(ModPlayerState, PassDungeonInfo) of
        {ok, NewModPlayerState} ->
            {ok, Bin} = pt_12:write(12002, null),
            packet_misc:put_packet(Bin),
            {ok, NewModPlayerState};
        {fail, Reason} ->
            packet_misc:put_info(Reason)
    end; 
%% 副本复活扣钱
handle(12003, #mod_player_state{player = Player,
                                dungeon_info = #dungeon_info{dungeon_id = Id,
                                                             relive_times = Times} = DungeonInfo} = ModPlayerState, _) ->
    case lib_dungeon:relive(Player, Id, Times) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {ok, NewPlayer} ->
            {ok, Bin} = pt_12:write(12003, null),
            packet_misc:put_packet(Bin),
            NewDungeonInfo = DungeonInfo#dungeon_info{relive_times = Times - 1},
            {ok, ModPlayerState#mod_player_state{
                   player = NewPlayer,
                   dungeon_info = NewDungeonInfo}}
    end;

%% 领取奖励(mugen && super_battle)
handle(Cmd, ModPlayerState, #pbchallengedungeon{
                               dungeon_id = Id,
                               type = _Type,
                               reward = PbReward,
                               score = Score,
                               state = State,
                               sub_route = Route,
                               cur_hp = Hp,
                               condition = Condition} = _Challenge) 
  when Cmd =:= 12004 orelse Cmd =:= 12007 ->
    %% ?PRINT("Cmd ~p~n", [Cmd]),
    %% ?QPRINT(Challenge),
    Reward = 
        lists:map(fun(#pbdungeonreward{goods_id = GoodsId,
                                       number = Num}) ->
                          {GoodsId, Num}
                  end, PbReward),
    PassDungeonInfo = #pass_dungeon_info{
                         id = Id,
                         score = Score,
                         reward = Reward,
                         state = State,
                         route = [Route],
                         condition = Condition,
                         cur_hp = Hp},
    case catch lib_dungeon:get_reward_new(ModPlayerState, PassDungeonInfo) of
        {ok, NewModPlayerState} ->
            send_dungeon_info(Cmd, NewModPlayerState, State),
            {ok, NewModPlayerState};
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        Other ->
            ?ERROR_MSG("error ~p~n ~p~n", [Other, erlang:get_stacktrace()])
    end; 
%%爬塔排行榜top10
handle(12005, ModPlayerState, _) ->
    PlayerId = ModPlayerState?PLAYER_ID,
    %?PRINT("Value ~p~n", [Value]),
    WriteTable = hdb:sn_table(mugen_rank, ModPlayerState?PLAYER_SN),
    {SelfInfo, TopTenList} = lib_rank:get_rank_info(WriteTable, 10, PlayerId),
    {ok, Bin} = pt_12:write(12005, {SelfInfo, TopTenList}),
    packet_misc:put_packet(Bin);
%%超激斗的排行榜
handle(12006, ModPlayerState, _) ->
    PlayerId = ModPlayerState?PLAYER_ID,
    WriteTable = hdb:sn_table(mugen_rank, ModPlayerState?PLAYER_SN),
    {SelfInfo, TopTenList} = lib_rank:get_rank_info(WriteTable, 10, PlayerId),
    {ok, Bin} = pt_12:write(12006, {SelfInfo, TopTenList}),
    packet_misc:put_packet(Bin);
%%日常副本领奖
handle(12008, ModPlayerState, #pbdailydungeon{dungeon = PbDungeon}) ->
    #pbdungeon{id = Id, 
               sub_route = Route,
               score = Score,
               pass_time = CostTime,
               reward = PbReward,
               is_extra = IsExtra,
               state = PassState,
               hit_reward = HitReward} = PbDungeon,
    Reward = 
        lists:map(fun(#pbdungeonreward{goods_id = GoodsId,
                                       number = Num}) ->
                          {GoodsId, Num}
                  end, PbReward),
    HitReward2 =
        case HitReward of
            [#pbdungeonreward{goods_id = BoxId,
                              number = BoxNum}] when BoxNum > 0->
                [{BoxId, BoxNum}];
            _ ->
                []
        end,
    PassDungeonInfo = #pass_dungeon_info{
                         id = Id,
                         route = Route,
                         score = Score,
                         reward = Reward,
                         state = PassState,
                         is_extra = IsExtra,
                         cost_time = CostTime,
                         hit_reward = HitReward2},
    case lib_dungeon:get_reward_new(ModPlayerState, PassDungeonInfo) of
        {ok, #mod_player_state{daily_dungeon = DailyDungeon} = NewModPlayerState, _UpdateSchedule} ->
            {ok, Bin} = pt_12:write(12050, DailyDungeon),
            packet_misc:put_packet(Bin),
            {ok, BinData} = pt_12:write(12008, null),
            packet_misc:put_packet(BinData),
            {ok, NewModPlayerState};
        {fail, Reason} ->
            packet_misc:put_info(Reason)
    end; 
    
%%副本翻牌
handle(12010, ModPlayerState, #pbflipcard{dungeon_id = Id, card_type = Type, pos = Pos}) ->
    case lib_dungeon:dungeon_flip_card(ModPlayerState, Id, Type, Pos) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {ok, NewModPlayerState} ->
            {ok, NewModPlayerState}
    end;

%%副本中购买血瓶
handle(12011, #mod_player_state{player = Player} = ModPlayerState, #pbid32{id = Times}) ->
    case lib_dungeon:buy_healing_salve(Player, Times) of
        {ok, NewPlayer} ->
            {ok, ModPlayerState#mod_player_state{player = NewPlayer}};
        {fail, Reason} ->
            packet_misc:put_info(Reason),
            {ok, ModPlayerState#mod_player_state{dungeon_info = #dungeon_info{}}}
    end;
%%副本的基本信息查询(最高评级)
%%登陆请求极限格斗的数据
handle(12020, #mod_player_state{dungeon_mugen = DungeonMugen,
                                mugen_reward = MugenRewardList}, _) ->
    case DungeonMugen of
        [] ->
            packet_misc:put_info(?INFO_CONF_ERR);
        _ ->
            {ok, Bin} = pt_12:write(12020, 
                                    {DungeonMugen, lib_dungeon:get_mugen_condition(DungeonMugen, MugenRewardList)}),
            packet_misc:put_packet(Bin)
    end;
%%极限格斗跳关
handle(12021, ModPlayerState, #pbid32{id = Type}) ->
    case lib_dungeon:skip_mugen(ModPlayerState, Type) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {ok, NewModPlayerState} ->
            DungeonMugen = NewModPlayerState#mod_player_state.dungeon_mugen,
            Condition = 
                lib_dungeon:get_mugen_condition(DungeonMugen, NewModPlayerState#mod_player_state.mugen_reward),
            PbMugen = pt_12:to_pbmugendungeon({DungeonMugen, Condition}),
            {ok, Bin} = pt_12:write(12020, PbMugen),
            packet_misc:put_packet(Bin),
            {ok, NewModPlayerState}
    end;
%%极限格斗挑战好友
handle(12025, #mod_player_state{dungeon_mugen = Mugen} = ModPlayerState, #pbid64{id = TarId}) ->
    case lib_dungeon:mugen_challenge(Mugen, TarId) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {ok, NewMugen} ->
            Condition = 
                lib_dungeon:get_mugen_condition(NewMugen, ModPlayerState#mod_player_state.mugen_reward),
            {ok, Bin} = pt_12:write(12020, {NewMugen, Condition}),
            packet_misc:put_packet(Bin),
            {ok, ModPlayerState#mod_player_state{dungeon_mugen = NewMugen}}
        %% {ok, #mod_player_state{dungeon_mugen = NewMugen} = NewModPlayerState} ->
        %%     Condition = 
        %%         lib_dungeon:get_mugen_condition(NewMugen, ModPlayerState#mod_player_state.mugen_reward),
        %%     {ok, Bin} = pt_12:write(12020, {NewMugen, Condition}),
        %%     packet_misc:put_packet(Bin),
        %%     {ok, NewModPlayerState}
    end;
%%给好友投幸运币
handle(12026, ModPlayerState, #pbid64{id = TarId}) ->
    case lib_dungeon:send_lucky_coin(ModPlayerState, TarId) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {ok, #mod_player_state{dungeon_mugen = NewMugen} = NewModPlayerState} ->
            {ok, BinData} = pt_12:write(12026, null),
            packet_misc:put_packet(BinData),
            Condition = 
                lib_dungeon:get_mugen_condition(NewMugen, NewModPlayerState#mod_player_state.mugen_reward),           
            {ok, Bin} = pt_12:write(12020, {NewMugen, Condition}),
            packet_misc:put_packet(Bin),
            {ok, NewModPlayerState#mod_player_state{dungeon_mugen = NewMugen}}
    end;
%%公平竞技的登陆数据
handle(12030, #mod_player_state{super_battle = SuperBattle}, _) ->
    ?DEBUG("get super_battle",[]),
    {ok, Bin} = pt_12:write(12030, SuperBattle),
    packet_misc:put_packet(Bin);
%%公平竞技的重新挑战
handle(12031, #mod_player_state{super_battle = SuperBattle} = ModPlayerState, _) ->
    ?DEBUG("restart super_battle : ~p~n",[SuperBattle]),
    case lib_dungeon:restart_super_battle(SuperBattle, ModPlayerState?PLAYER) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {ok, NewSuperBattle} ->
            {ok, Bin} = pt_12:write(12030, NewSuperBattle),
            packet_misc:put_packet(Bin),
            {ok, ModPlayerState#mod_player_state{super_battle = NewSuperBattle}}
    end;
%%购买次数
handle(12032, ModPlayerState, _) ->
    case lib_dungeon:buy_super_battle_times(ModPlayerState) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {ok, NewModPlayerState} ->
            {ok, Bin} = pt_12:write(12030, NewModPlayerState#mod_player_state.super_battle),
            packet_misc:put_packet(Bin),
            {ok, NewModPlayerState}
    end;
%%副本进度(不全部发了，根据需要筛选)
handle(12040, #mod_player_state{dungeon_list = DungeonList}, #pbid32r{id = SeriesIds}) ->
    ?DEBUG("SeriesIds ~p~n", [SeriesIds]),
    DungeonInfoList = 
        lists:foldl(fun
                        (SeriesId, AccInfo) when is_integer(SeriesId) ->
                           lib_dungeon:series_dungeon_info(DungeonList, SeriesId) ++ AccInfo;
                        (_, AccInfo)->
                           AccInfo
                   end, [], SeriesIds),
    {ok, Bin} = pt_12:write(12040, DungeonInfoList),
    packet_misc:put_packet(Bin);

%%获取胜率
handle(12041, ModPlayerState, _) ->
    PlayerId = ModPlayerState?PLAYER_ID,
    Table = lib_dungeon_match:get_player_dungeon_match_table(),
    PlayerDungeonMatch = 
        case hdb:dirty_read(Table, PlayerId, true) of
            [] ->
                NewDungeonMatch = 
                    #player_dungeon_match{player_id = PlayerId,
                                          win_times = 0,
                                          fail_times = 0},
                hdb:dirty_write(Table, NewDungeonMatch),
                NewDungeonMatch;
            DungeonMatch ->
                DungeonMatch
        end,
    {ok, Bin} = pt_12:write(12041, PlayerDungeonMatch),
    packet_misc:put_packet(Bin);
%%购买王者副本的次数
handle(12042, ModPlayerState, #pbid32{id = Id}) ->
    case lib_dungeon:buy_dungeon_times(ModPlayerState, Id) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {ok, NewModPlayerState, NewDungeon} ->
            {ok, Bin} = pt_12:write(12040, [NewDungeon]),
            packet_misc:put_packet(Bin),
            {ok, NewModPlayerState}
    end;
%%扫荡
handle(12043, ModPlayerState, #pbmopuplist{dungeon_id = DungeonId, times = Times, flip_pay_card = Flag}) ->
    case lib_dungeon:mop_up(ModPlayerState, DungeonId, Times, Flag) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {ok, NewModPlayerState, MopUpInfos, _} ->
            {ok, Bin} = pt_12:write(12043, MopUpInfos),
            packet_misc:put_packet(Bin),
            {ok, NewModPlayerState}
    end;
%%日常副本登陆数据
handle(12050, #mod_player_state{daily_dungeon = DailyDungeon}, _) ->
    {ok, Bin} = pt_12:write(12050, DailyDungeon),
    packet_misc:put_packet(Bin);
%%日常资源副本
handle(12060, #mod_player_state{source_dungeon = SourceDungeon}, _) ->
    {ok, Bin} = pt_12:write(12060, SourceDungeon),
    packet_misc:put_packet(Bin);

handle(_Cmd, _, _Data) ->
    ?WARNING_MSG("pp_handle no match, /Cmd/Data/ = /~p/~p/~n", [_Cmd, _Data]),
    {error, "pp_handle no match"}.

send_dungeon_info(12004, #mod_player_state{dungeon_mugen = Mugen} = ModPlayerState, PassState) ->
    Condition = 
        lib_dungeon:get_mugen_condition(Mugen, ModPlayerState#mod_player_state.mugen_reward),  
    PbMugen = pt_12:to_pbmugendungeon({Mugen, Condition}),
    {ok, Bin} = pt_12:write(12020, PbMugen),
    packet_misc:put_packet(Bin),
    if
        PassState =:= ?PLAYER_ALIVE ->
            {ok, BinData} = pt_12:write(12004, null),
            packet_misc:put_packet(BinData);
        true ->
            skip
    end;
send_dungeon_info(12007, ModPlayerState, PassState) ->
    PbData = pt_12:super_battle_to_pbmugendungeon(ModPlayerState#mod_player_state.super_battle),
    {ok, Bin} = pt_12:write(12030, PbData),
    packet_misc:put_packet(Bin),
    if
        PassState =:= ?PLAYER_ALIVE ->
            {ok, BinData} = pt_12:write(12007, null),
            packet_misc:put_packet(BinData);
        true ->
            skip
    end.
