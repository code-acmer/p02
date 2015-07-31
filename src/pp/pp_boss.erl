-module(pp_boss).
-export([handle/3]).

-include("define_boss.hrl").
-include("pb_17_pb.hrl").
-include("define_info_17.hrl").
-include("define_logger.hrl").
-include("define_player.hrl").
-include("define_log.hrl").
-include("define_dungeon.hrl").
-include("define_money_cost.hrl").

%%获取boss列表
handle(17000, ModPlayerState, _) ->
    AllBossList = lib_boss:get_boss_list(ModPlayerState?PLAYER_SN),
    {ok, Bin} = pt_17:write(17000, AllBossList),
    packet_misc:put_packet(Bin),
    {ok, ModPlayerState#mod_player_state{boss_list = AllBossList}};

%%开启Boss
handle(17010, ModPlayerState, PbWorldBoss) ->
    case lib_boss:open_boss_pp(ModPlayerState, PbWorldBoss) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {ok, NewBoss, NewModPlayerState} ->
            {ok, Bin} = pt_17:write(17010, NewBoss),
            packet_misc:put_packet(Bin),
            {ok, NewModPlayerState}
    end;

%%进入Boss场景
handle(17011, ModPlayerState, #pbworldboss{boss_id = BossId}) ->
    case lib_boss:entry_boss_scene(ModPlayerState, BossId) of
        {fail, Reason} ->
            packet_misc:put_info(Reason);
        {ok, NewModPlayerState, Bin1} ->
            {ok, Bin2} = pt_17:write(17011, <<>>),
            packet_misc:directly_send_packet_list(ModPlayerState?PLAYER_SEND_PID, [Bin1, Bin2]),
            {ok, NewModPlayerState}
    end;

%%打Boss
handle(17012, #mod_player_state{boss_list = BossList} = ModPlayerState, #pbworldboss{boss_id = BossId,
                                                                                     damage = Hurt,
                                                                                     crit_damage = CritList}) ->
    ?DEBUG("Hurt ~p PlayerId ~p~n", [Hurt, ModPlayerState?PLAYER_ID]),
    case lists:keyfind(BossId, #bossinfo.boss_id, BossList) of
        false ->
            ?WARNING_MSG("not found data in cache PlayerId ~p BossId ~p~n Hurt ~p BossList ~p~n",
                         [ModPlayerState?PLAYER_ID, BossId, Hurt, BossList]),
            packet_misc:put_info(?BOSS_INFO_NOT_FOUND);
        #bossinfo{pid = Pid} ->
            %lib_log_player:add_log(?LOG_EVENT_DAMAGE_BOSS, BossId, Hurt),
            mod_boss:damage_boss(ModPlayerState?PLAYER_ID, Pid, Hurt, CritList),
            {ok, Bin} = pt_17:write(17012, null),
            packet_misc:put_packet(Bin)
    end;
 
%%退出Boss场景
handle(17014, #mod_player_state{boss_list = BossList} = ModPlayerState, #pbworldboss{boss_id = BossId}) ->
    case lists:keyfind(BossId, #bossinfo.boss_id, BossList) of
        false ->
            {ok, Bin} = pt_17:write(17014, null),
            packet_misc:put_packet(Bin),
            %%退出场景的时候boss可能死掉了
            %mod_player:send_info(ModPlayerState, ?BOSS_INFO_NOT_FOUND);
            skip;
        #bossinfo{pid = Pid,
                  player_id = Opener} ->
            lib_log_player:add_log(?LOG_EVENT_LEAVE_BOSS, BossId, Opener),
            mod_boss:quip_boss(ModPlayerState?PLAYER_ID, Pid),
            {ok, Bin} = pt_17:write(17014, null),
            packet_misc:put_packet(Bin),
            {ok, ModPlayerState#mod_player_state{cur_boss_pid = undefined}}
    end;
handle(_Cmd, _, _Data) ->
    ?WARNING_MSG("pp_handle no match, /Cmd/Data/ = /~p/~p/~n", [_Cmd, _Data]),
    {error, "pp_handle no match"}.

