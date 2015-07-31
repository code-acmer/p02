-module(lib_boss).
-include("define_logger.hrl").
-include("define_boss.hrl").
-include("define_info_17.hrl").
-include("define_money_cost.hrl").
-include("define_player.hrl").
-include("define_time.hrl").
-include("define_dungeon.hrl").
-include("define_reward.hrl").
-include("define_log.hrl").
-include("define_rank.hrl").
-include("pb_17_pb.hrl").

-export([open_boss/5,
         check_entry_boss/4,
         get_player_boss/2,
         
         get_boss_list/1,         
         open_boss_pp/2,
         entry_boss_scene/2
        ]).

%%系统开boss,跳过条件判断
open_boss(0, NickName, DbSn, BossId, _) ->
    start_boss_process(0, NickName, BossId, DbSn);
open_boss(PlayerId, NickName, DbSn, BossId, BossDict) ->
    case dict:find(BossId, BossDict) of
        error ->
            {fail, ?INFO_CONF_ERR};
        {ok, BossList} ->
            case lists:keyfind(PlayerId, #bossinfo.player_id, BossList) of
                false ->
                    start_boss_process(PlayerId, NickName, BossId, DbSn);
                _ ->
                    {fail, ?NO_MORE_BOSS}
            end
    end.
start_boss_process(PlayerId, NickName, BossId, Sn) ->
    case mod_boss:start_link(BossId, Sn) of
        {ok, Pid} ->
            case data_base_dungeon_world_boss:get(BossId) of
                [] ->
                    {fail, ?INFO_CONF_ERR};
                #base_dungeon_world_boss{summon_reward = SummonReward} ->
                    {Start, Stop} = mod_boss:get_start_stop(Pid),
                    NewBoss = #bossinfo{player_id = PlayerId,
                                        nickname = NickName,
                                        boss_id = BossId,
                                        pid = Pid,
                                        start = Start,
                                        stop = Stop
                                       },
                    {ok, NewBoss, SummonReward}
            end;
        Other ->
            ?WARNING_MSG("start boss error reason ~p~n", [Other]),
            {fail, ?OPEN_BOSS_FAIL}
    end.

check_entry_boss(BossId, Start, EndTime, Count) ->
    Now = time_misc:unixtime(),
    if
        Start < Now andalso Now < EndTime ->
            case data_base_dungeon_world_boss:get(BossId) of
                #base_dungeon_world_boss{challengers_place = MaxCount} when Count <  MaxCount ->
                    ok;
                [] ->
                    {fail, ?INFO_CONF_ERR};
                _ ->
                    {fail, ?INFO_BOSS_MAX_COUNT}
            end;
        true ->
            {fail, ?INFO_BOSS_NOT_IN_TIME}
    end.

get_player_boss(BossIdList, BossDict) ->
    lists:foldl(fun(BossId, AccBossInfo) ->
                        case dict:find(BossId, BossDict) of
                            error ->
                                AccBossInfo;
                            {ok, BossList} ->
                                case get_avail_boss(BossList, []) of
                                    [] ->
                                        AccBossInfo;
                                    AvailBossList ->
                                        Boss = hmisc:rand(AvailBossList),
                                        [Boss|AccBossInfo]
                                end
                        end
                end, [], BossIdList).
get_avail_boss([], AccBossList) ->
    AccBossList;
get_avail_boss([#bossinfo{
                   pid = Pid,
                   boss_id = BossId} = Boss|Tail], AccBossList) ->
    case catch mod_boss:get_count(Pid) of
        {ok, Count} ->
            case data_base_dungeon_world_boss:get(BossId) of
                #base_dungeon_world_boss{challengers_place = MaxCount} when Count < MaxCount ->
                    get_avail_boss(Tail, [Boss|AccBossList]);
                _ ->
                    get_avail_boss(Tail, AccBossList)
            end;
        Other ->
            ?WARNING_MSG("call mod boss pid ~p error Reason ~p~n", [Pid, Other]),
            get_avail_boss(Tail, AccBossList)
    end;
get_avail_boss([_|T], AccBossList) ->
    get_avail_boss(T, AccBossList).

%%-----玩家业务处理-----------------------------------------------------------------
get_boss_list(PlayerSn) ->
    AllBossId = data_base_dungeon_world_boss:get_all_id(),
    case catch mod_boss_manage:get_boss(AllBossId, PlayerSn) of
        {ok, GetBossList} ->
            GetBossList;
        _ ->
            []
    end.

%% 玩家开启boss业务
open_boss_pp(ModPlayerState, #pbworldboss{
                                   boss_id = BossId
                                  }) ->
    case check_open_boss(ModPlayerState, BossId) of
        {fail, Reason} ->
            {fail, Reason};
        {ok, NModPlayerState} ->
            %%顺便去检查一下目前的boss能不能开
            case open_boss_pp1(NModPlayerState, BossId) of
                {fail, Reason} ->
                    {fail, Reason};
                Other ->
                    Other
            end
    end.

open_boss_pp1(#mod_player_state{
                 boss_list = BossList
                } = ModPlayerState, BossId) ->
    PlayerId = ModPlayerState?PLAYER_ID,
    NickName = ModPlayerState?PLAYER_NAME,
    PlayerSn = ModPlayerState?PLAYER_SN,
    case catch mod_boss_manage:get_boss([BossId], PlayerSn) of
        {ok, GetBossList} when GetBossList =/= [] ->
            {fail, ?INFO_BOSS_OPEN_NOT_VALID};
        _ ->
            case mod_boss_manage:open_boss(PlayerId, NickName, PlayerSn, BossId) of
                {fail, Reason} ->
                    {fail, Reason};
                {ok, NewBoss, SummonReward} ->
                    case lib_reward:take_reward_direct(ModPlayerState, SummonReward, ?INCOME_OPEN_BOSS) of
                        {fail, Reason} ->
                            {fail, Reason};
                        {ok, NModPlayerState} ->
                            NewBossList = 
                                lists:keystore(NewBoss#bossinfo.boss_id, #bossinfo.boss_id, BossList, NewBoss),
                            lib_log_player:add_log(?LOG_EVENT_OPEN_BOSS, BossId, 0),
                            NPlayer = insert_boss_rank(NModPlayerState#mod_player_state.player),
                            {ok, NewBoss, NModPlayerState#mod_player_state{boss_list = NewBossList,
                                                                           player = NPlayer}}
                    end
            end
    end.

insert_boss_rank(#player{battle_ability = Ability,
                         id = PlayerId,
                         sn = Sn,
                         nickname = NickName,
                         career = Career,
                         lv = Level,
                         boss_open_times = OpenTimes
                        } = Player) ->
    WriteTable = hdb:sn_table(world_boss_rank, Sn),
    mod_rank:insert(WriteTable, PlayerId,
                    {OpenTimes + 1, PlayerId}, {NickName, Career, Ability, Level}),
    Player#player{boss_open_times = OpenTimes + 1}.

check_open_boss(#mod_player_state{player = Player,
                                  boss_list = BossList} = ModPlayerState, BossId) ->
    case lists:keyfind(BossId, #bossinfo.boss_id, BossList) of
        true ->
            {fail, ?INFO_BOSS_OPEN_NOT_VALID};
        false ->
            case data_base_dungeon_world_boss:get(BossId) of
                [] ->
                    {fail, ?INFO_CONF_ERR};
                #base_dungeon_world_boss{
                   type = Type
                  } = WorldBoss->
                    case Type =:= ?BOSS_TYPE_PLAYER of
                        false ->
                            {fail, ?INFO_CONF_ERR};
                        true ->
                            case check_open_boss1(Player, WorldBoss) of
                                {fail, Reason} ->
                                    {fail, Reason};
                                {ok, NPlayer} ->
                                    {ok, ModPlayerState#mod_player_state{ player = NPlayer }}
                            end
                    end
            end
    end.

check_open_boss1(Player, #base_dungeon_world_boss{
                            id = BossId,
                            consume = Consume,
                            place_day = MaxDay,
                            place_hour = MaxHour,
                            open_time = OpenTime
                           }) ->
    case check_open_time(OpenTime) of
        false ->
            {fail, ?INFO_BOSS_OPEN_NOT_VALID_TIME};
        true ->
            case check_open_boss2(Player, BossId, MaxHour, MaxDay) of
                {fail, Reason} ->
                    {fail, Reason};
                {ok, NewPlayer} ->                    
                    case lib_player:cost_money(NewPlayer, Consume, ?COST_OPEN_BOSS) of
                        {fail, Reason} ->
                            {fail, Reason};
                        {ok, NPlayer} ->
                            {ok, NPlayer}                                            
                    end
            end
    end.

check_open_boss2(#player{open_boss_info = OpenBossInfo} = Player, BossId, MaxHour, MaxDay) ->
    Now = time_misc:unixtime(),
    {CurDay, CurHour, NewTimestampList} = 
        case lists:keyfind(BossId, 1, OpenBossInfo) of
            false ->
                {0, 0, [Now]};
            {_, Times, TimestampList} ->
                {HourOpenTimes, FilterTimestampList} = 
                    lists:foldl(fun(Timestamp, {AccTimes, AccTimestamp}) ->
                                        case Now - Timestamp > ?ONE_HOUR_SECONDS of
                                            true ->
                                                {AccTimes, AccTimestamp};
                                            false ->
                                                {AccTimes + 1, [Timestamp|AccTimestamp]}
                                        end
                                end, {0, []}, TimestampList),
                {Times, HourOpenTimes, [Now|FilterTimestampList]}
        end,
    if
        CurDay >= MaxDay  ->
            {fail, ?INFO_OPEN_BOSS_FULL_TODAY};
        CurHour >= MaxHour ->
            {fail, ?INFO_OPEN_BOSS_FULL_CUR_HOUR};
        true ->
            NewBossInfo = {BossId, CurDay + 1, NewTimestampList},
            NewOpenBossInfo = lists:keystore(BossId, 1, OpenBossInfo, NewBossInfo),
            {ok, Player#player{open_boss_info = NewOpenBossInfo}}
    end.

check_open_time(_) ->
    true.

entry_boss_scene(#mod_player_state{
                    cur_boss_pid = OldBossPid
                   } = ModPlayerState, BossId) ->
    case data_base_dungeon_world_boss:get(BossId) of
        [] ->
            {fail, ?INFO_CONF_ERR};
        #base_dungeon_world_boss{dungeon_id = DungeonId} ->
            case data_base_dungeon_area:get(DungeonId) of
                [] ->
                    {fail, ?INFO_CONF_ERR};
                #base_dungeon_area{lv = ReqLv} when ModPlayerState?PLAYER_LV >= ReqLv ->
                    case ModPlayerState?PLAYER_LV >= ReqLv of
                        false ->
                             {fail, ?INFO_NOT_ENOUGH_LEVEL};
                        true ->
                            %% ?DEBUG("OldBossPid : ~p~n", [OldBossPid]),
                            %% if
                            %%     OldBossPid =/= undefined ->
                            %%         mod_boss:quip_boss(ModPlayerState?PLAYER_ID, OldBossPid);    %%先把老的boss退掉
                            %%     true ->
                            %%         skip
                            %% end,
                            case entry_boss_scene1(ModPlayerState, BossId) of
                                {fail, Reason} ->
                                    {fail, Reason};
                                {ok, #mod_player_state{
                                        cur_boss_pid = NewBossPid
                                       } = _NewModPlayerState, _Binary} = RET ->
                                    ?DEBUG("OldBossPid : ~p~n", [OldBossPid]),
                                    lib_log_player:log_system({ModPlayerState?PLAYER_ID, ?LOG_WORLD_BOSS, 1, DungeonId, 0}),
                                    if
                                        OldBossPid =/= undefined andalso OldBossPid =/= NewBossPid ->
                                            mod_boss:quip_boss(ModPlayerState?PLAYER_ID, OldBossPid);    %%先把老的boss退掉
                                        true ->
                                            skip
                                    end,
                                    RET
                            end                                
                    end
            end
    end.

entry_boss_scene1(#mod_player_state{
                     boss_list = BossList,
                     player = #player{
                                 id = PlayerId,
                                 nickname = PlayerName,
                                 career = PlayerCareer
                                }
                    } = ModPlayerState, BossId) ->
    case lists:keyfind(BossId, #bossinfo.boss_id, BossList) of
        false ->
            ?DEBUG("not found data in cache ~n", []),
            {fail, ?BOSS_INFO_NOT_FOUND};
        #bossinfo{
           player_id = Opener,
           pid = Pid
          } ->
            case catch mod_boss:entry_boss_scene(PlayerId, PlayerName, PlayerCareer, Pid) of
                {fail, Reason} ->
                    {fail, Reason};
                {ok, Bin} ->
                    lib_log_player:add_log(?LOG_EVENT_ENTRY_BOSS, BossId, Opener),
                    {DungeonId, Relive} = get_boss_relive(BossId),
                    {ok, ModPlayerState#mod_player_state{
                           cur_boss_pid = Pid,
                           dungeon_info = #dungeon_info{
                                             dungeon_id = DungeonId,
                                             relive_times = Relive
                                            }}, Bin};
                _ ->
                    ?DEBUG("process deaded BossId ~p~n", [BossId]),
                    {fail, ?BOSS_IS_KILLED}
            end
    end.

get_boss_relive(BossId) ->
    case data_base_dungeon_world_boss:get(BossId) of
        [] ->
            {0, 0};
        #base_dungeon_world_boss{dungeon_id = DungeonId} ->
            case data_base_dungeon_area:get(DungeonId) of
                [] ->
                    {0, 0};
                #base_dungeon_area{relive = ReLiveTimes} ->
                    {DungeonId, ReLiveTimes}
            end
    end.
