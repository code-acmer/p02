%%竞技场模块
-module(lib_arena).
-include("define_arena.hrl").
-include("define_rank.hrl").
-include("define_player.hrl").
-include("define_info_23.hrl").
-include("define_logger.hrl").
-include("define_reward.hrl").
-include("db_base_pvp_battle_reward.hrl").
-include("define_money_cost.hrl").
-include("define_goods_type.hrl").
-include("define_task.hrl").
-include("define_log.hrl").
-include("db_base_pvp_rank_reward.hrl").

-export([new_player/2,
         challenge/5]).

-export([get_player_rank/2,
         recommend_player/1,
         daily_reset/1,
         player_challenge/3,
         get_arena_report/2,
         rank_top/3,
         buy_challenge_times/1,
         get_pvp_reward/2,
         get_pvp_reward_first/1
        ]).

new_player(async_arena_rank, Player) ->
    #player{id = Id,
            lv = Lv,
            sn = Sn,
            career = Career,
            battle_ability = BattleAbility,
            nickname = NickName} = Player,
    WriteTable = hdb:sn_table(async_arena_rank, Sn),
    Rank = hdb:size(WriteTable) + 1,
    Fun = fun() ->
                  RankRec = 
                      #async_arena_rank{rank = Rank,
                                        player_id = Id,
                                        nickname = NickName,
                                        lv = Lv,
                                        battle_ability = BattleAbility,
                                        career = Career,
                                        challenge_times = 0,
                                        rest_challenge_times = ?DAILI_CHALLENGE_TIMES},
                  mnesia:write(WriteTable, RankRec, write),
                  RankRec
          end,
    hdb:transaction(Fun);
new_player(sync_arena_rank, Player) ->
    #player{id = Id,
            lv = Lv,
            sn = Sn,
            career = Career,
            battle_ability = BattleAbility,
            nickname = NickName} = Player,
    WriteTable = hdb:sn_table(sync_arena_rank, Sn),
    Rank = hdb:size(WriteTable) + 1,
    Fun = fun() ->
                  RankRec = 
                      #sync_arena_rank{rank = Rank,
                                       player_id = Id,
                                       nickname = NickName,
                                       lv = Lv,
                                       battle_ability = BattleAbility,
                                       career = Career,
                                       challenge_times = 0,
                                       rest_challenge_times = ?DAILI_CHALLENGE_TIMES},
                  mnesia:write(WriteTable, RankRec, write),
                  RankRec
          end,
    hdb:transaction(Fun).

challenge(Table, #player{sn = Sn,
                         id = Id} = Player, TarId, RobotFlag, Result) ->
    WriteTable = hdb:sn_table(Table, Sn),
    case check_challenge(WriteTable, Id, TarId, RobotFlag) of
        {true, PlayerRank, TarRank} ->
            NewArena = may_swap_rank(WriteTable, [PlayerRank, TarRank], Result, RobotFlag),
            AddTimesArena = add_win_lose_times(NewArena, Result),
            %%
            {ok, update_challenge(Player, WriteTable, AddTimesArena)};
        {fail, Reason} ->
            {fail, Reason}
    end.

check_challenge(WriteTable, Id, Tid, RobotFlag) ->
    case get_challenge_info(WriteTable, Id, Tid, RobotFlag) of
        {fail, Reason} ->
            {fail, Reason};
        {true, PlayerRank, TarRank} ->
            {true, PlayerRank, TarRank}
    end.
may_swap_rank(WriteTable, [#async_arena_rank{rank = Rank1} = Arena1, 
                           #async_arena_rank{rank = Rank2, player_id = TargetId} = Arena2], Result, RobotFlag) ->
    TargetPlayer = lib_player:get_player(TargetId),
    if
        Result =:= ?CHALLENGE_WIN andalso Rank1 > Rank2 ->
            NewArena1 = Arena1#async_arena_rank{rank = Rank2},
            NewArena2 = case RobotFlag of
                            ?RANK_ROBOT ->
                                Arena2#async_arena_rank{rank = Rank1};
                            ?RANK_PLAYER ->
                                Arena2#async_arena_rank{rank = Rank1,
                                                        lv = element(#player.lv, TargetPlayer), 
                                                        battle_ability = element(#player.high_ability, TargetPlayer)
                                                       }
                        end,
            make_challenge_report(NewArena1, NewArena2, ?CHALLENGE_WIN, ?RANK_UP),
            %% 
            hdb:dirty_write(WriteTable, NewArena2),
            NewArena1;
        true ->
            case RobotFlag of
                ?RANK_PLAYER ->
                    NewArena2 = Arena2#async_arena_rank{lv = element(#player.lv, TargetPlayer), 
                                                        battle_ability = element(#player.high_ability, TargetPlayer)},
                    hdb:dirty_write(WriteTable, NewArena2);
                _ ->
                    ignored
            end,            
            make_challenge_report(Arena1, Arena2, Result, ?RANK_NO_CHANGE),
            Arena1
    end.    

%%下面接口是提供给mod_player用的，获取的信息可能不准确，不过不影响
%%胜利场数和失败场数要维护
player_challenge(async_arena_rank, 
                 #mod_player_state{player = Player} = ModPlayerState,
                 {Tid, Result, RobotFlag}) ->
    ?DEBUG("Result ~p~n", [Result]),
    case call_player_challenge(async_arena_rank, Player, Tid, RobotFlag, Result) of
        {fail, Reason} ->
            {fail, Reason};
        {ok, Arena} ->
            case take_challenge_reward(ModPlayerState, Arena, Result) of
                {fail, Reason} ->
                    {fail, Reason, Arena};
                {ok, NewModPlayerState} ->
                    lib_log_player:log_system({Player#player.id, ?LOG_ASYNC_ARENA, 1, RobotFlag, Result}),
                    NModPlayerState = lib_task:task_event(NewModPlayerState, {?TASK_ARENA, ?TASK_ARENA_NORMAL, 1}),
                    {Reward, NNModPlayerState} = recv_pvp_reward(Arena, NModPlayerState),
                    ?WARNING_MSG("Reward: ~p", [Reward]),
                    case lib_reward:take_reward(NNModPlayerState, Reward, ?INCOME_ASYNC_CHALLENGE_INCOME, ?REWARD_TYPE_ASYNC_CHALLENGE) of
                        {fail, Reason} ->
                            {fail, Reason};
                        {ok, MModPlayerState} ->
                            {ok, MModPlayerState, Arena}       
                    end
            end
    end.

recv_pvp_reward(#async_arena_rank{
                   rank = Rank
                  }, #mod_player_state{
                        player = Player
                       } = ModPlayerState) ->
    HighPvpRank = Player#player.high_pvp_rank,
    DbSn = Player#player.sn,
    ?WARNING_MSG("HighPvpRank: ~p, Rank : ~p", [HighPvpRank, Rank]),
    {Reward, HighRank} = 
        if
            HighPvpRank =:= 0 ->
                Table = 
                    list_to_atom(lists:concat([async_arena_rank, "_", DbSn])),
                Max = length(hdb:dirty_all_keys(Table)),
                %% R1 = 
                %%     case data_base_pvp_rank_reward:get_reward_by_rank(Max) of
                %%         [] ->
                %%             [];
                %%         #base_pvp_rank_reward{disposable_rank_reward = L} ->
                %%             L
                %%     end,                              
                R2 = get_pvp_reward(Rank, Max),
                {R2, Rank};
            HighPvpRank =< Rank ->
                {[], HighPvpRank};
            true ->
                {get_pvp_reward(Rank, HighPvpRank), min(Rank, HighPvpRank)}
        end,
    {Reward, ModPlayerState#mod_player_state{player = Player#player{high_pvp_rank = HighRank}}}.

get_pvp_reward(Rank, HighPvpRank) ->
    case data_base_pvp_rank_reward:get_reward_by_rank(Rank) of
        [] ->
            [];
        #base_pvp_rank_reward{
           disposable_rank_range = Range,
           disposable_rank_reward = Reward 
          } ->
            [_, R] = Range,
            if
                HighPvpRank =< R ->
                    [];
                true ->
                    Reward ++ get_pvp_reward(R+1, HighPvpRank)
            end
    end.

get_pvp_reward_first(Rank) ->
    case data_base_pvp_rank_reward:get_reward_by_rank(Rank) of
        [] ->
            [];
        #base_pvp_rank_reward{
           disposable_rank_range = [_L, R],
           disposable_rank_reward = Reward 
          } ->
            Reward ++ get_pvp_reward_first(R+1)
    end.

take_challenge_reward(ModPlayerState, #async_arena_rank{rank = Rank}, Result) ->
    case data_base_pvp_battle_reward:get(Rank) of
        [] ->
            {fail, ?INFO_CONF_ERR};
        #base_pvp_battle_reward{win_reward = WinReward,
                                lose_reward = LoseReward} ->
            RewardTake = 
                if
                    Result =:= ?CHALLENGE_WIN ->
                        WinReward;
                    true ->
                        LoseReward
                end,
            ?DEBUG("RewardTake ~p~n", [RewardTake]),
            lib_reward:take_reward(ModPlayerState, RewardTake, ?INCOME_ASYNC_CHALLENGE_INCOME, ?REWARD_TYPE_ASYNC_CHALLENGE)
    end.

add_win_lose_times(#async_arena_rank{win = Win, lose = Lose} = Arena, Result) ->
    if
        Result =:= ?CHALLENGE_WIN -> 
            Arena#async_arena_rank{win = Win + 1};
        Result =:= ?CHALLENGE_LOSE ->
            Arena#async_arena_rank{lose = Lose + 1};
        true -> 
            Arena
    end.
%% add_win_lose_times(#sync_arena_rank{win = Win, lose = Lose} = Arena, Result) ->
%%     if
%%         Result =:= ?CHALLENGE_WIN -> 
%%            Arena#sync_arena_rank{win = Win + 1};
%%         Result =:= ?CHALLENGE_LOSE ->
%%             Arena#sync_arena_rank{lose = Lose + 1};
%%         true -> 
%%             Arena
%%     end.

call_player_challenge(async_arena_rank, Player, Tid, RobotFlag, Result) ->
    case catch mod_arena:challenge(async_arena_rank, Player, Tid, RobotFlag, Result) of
        {fail, Reason} ->
            {fail, Reason};
        {ok, Arena} ->
            {ok, Arena};
        Other ->
            ?WARNING_MSG("challenge error ~p~n", [Other]),
            {fail, ?INFO_ARENA_SERVER_ERROR}
    end.

make_challenge_report(Arena1, Arena2, Result, RankType) ->
    Report = 
        #async_arena_report{id = next_report_id(),
                            attack_id = Arena1#async_arena_rank.player_id,
                            nickname = Arena1#async_arena_rank.nickname,
                            deffender_id = Arena2#async_arena_rank.player_id,
                            deffender_name = Arena2#async_arena_rank.nickname,
                            result = Result,
                            rank_change_type = RankType,
                            attack_rank = Arena1#async_arena_rank.rank,
                            defender_rank = Arena2#async_arena_rank.rank,
                            timestamp = time_misc:unixtime()},
    hdb:dirty_write(async_arena_report, Report).

update_challenge(Player, WriteTable, #async_arena_rank{rest_challenge_times = Rest,
                                                       challenge_times = Times} = PlayerRank) ->
    NewArena = PlayerRank#async_arena_rank{
                 lv = Player#player.lv,
                 battle_ability = Player#player.battle_ability,
                 challenge_times = Times + 1,
                 rest_challenge_times = Rest - 1},
    hdb:sync_write(WriteTable, NewArena),
    NewArena.

next_report_id() ->
    lib_counter:update_counter(arena_report_uid, 1).

get_challenge_info(WriteTable, Id, Tid, RobotFlag) ->
    case hdb:dirty_index_read(WriteTable, Id, #async_arena_rank.player_id) of
        [PlayerRank] ->
            if
                PlayerRank#async_arena_rank.rest_challenge_times =< 0 ->
                    {fail, ?INFO_ARENA_CHALLENGE_TIMES_LIMIT};
                RobotFlag =:= ?RANK_ROBOT ->
                    case hdb:dirty_index_read(WriteTable, Tid, #async_arena_rank.robot_id, true) of
                        [TarRank] ->
                            {true, PlayerRank, TarRank};
                        Other ->
                            ?WARNING_MSG("rank info error ~p~n", [Other]),
                            {fail, ?INFO_ARENA_ERROR_RANK_INFO}
                    end;
                RobotFlag =:= ?RANK_PLAYER ->
                    case hdb:dirty_index_read(WriteTable, Tid, #async_arena_rank.player_id, true) of
                        [TarRank] ->
                            {true, PlayerRank, TarRank};
                        Other ->
                            ?WARNING_MSG("rank info error ~p~n", [Other]),
                            {fail, ?INFO_ARENA_ERROR_RANK_INFO}
                    end;
                true ->
                    {fail, ?INFO_NOT_LEGAL_INT}
            end;
        Other ->
            ?WARNING_MSG("rank info error ~p~n", [Other]),
            {fail, ?INFO_ARENA_ERROR_RANK_INFO}
    end.

get_player_rank(sync_arena_rank, #player{id = Id, sn = Sn}) ->
    WriteTable = hdb:sn_table(sync_arena_rank, Sn),
    hdb:dirty_index_read(WriteTable, Id, #sync_arena_rank.player_id, true);
get_player_rank(async_arena_rank, #player{id = Id, sn = Sn} = Player) ->
    WriteTable = hdb:sn_table(async_arena_rank, Sn),
    case hdb:dirty_index_read(WriteTable, Id, #async_arena_rank.player_id, true) of
        [] ->
            ArenaRank = new_player(async_arena_rank, Player),
            [ArenaRank];
        ArenaRank ->
            ArenaRank
    end.

%%推荐只能支持异步竞技场的，同步用不上
recommend_player(Player) ->
    WriteTable = hdb:sn_table(async_arena_rank, Player#player.sn),
    case get_player_rank(async_arena_rank, Player) of
        [#async_arena_rank{rank = Rank}] = SelfRank ->
            {SelfRank, recommend_player2(WriteTable, Rank)};
        Other ->         %%不应该出现的，一旦出现可能有bug
            ?ERROR_MSG("async_arena_rank error ~p~n", [Other]),
            {fail, ?INFO_ARENA_ERROR_RANK_INFO}  
    end.

recommend_player2(WriteTable, Rank) when Rank >= ?RANK_LEVEL_HIGH ->
    Range = Rank div ?RANK_RANGE,
    Size = hdb:size(WriteTable),
    lists:map(fun(Num) ->
                      Low = Rank - Range * Num,
                      if
                          Num =:= 1 -> %%可能会超出长度。。。2倍的话
                              RecommendRank = rand_last(Low, Size, Rank, Range),
                              hdb:dirty_read(WriteTable, RecommendRank, true);
                          true ->
                              RecommendRank = hmisc:rand(Low, Low + Range - 1),
                              hdb:dirty_read(WriteTable, RecommendRank, true)
                      end
              end, lists:seq(1, ?RANK_REC_COUNT));
recommend_player2(WriteTable, Rank) when Rank =< ?RANK_REC_COUNT ->
    FrontList = lists:seq(1, ?RANK_REC_COUNT) -- [Rank],
    lists:map(fun(RecommendRank) ->
                      hdb:dirty_read(WriteTable, RecommendRank, true)
              end, FrontList ++ [hmisc:rand(?RANK_REC_COUNT + 1, ?RANK_REC_COUNT + 3)]);
recommend_player2(WriteTable, Rank) ->
    FrontList = hmisc:rand_n(?RANK_REC_COUNT - 1, lists:seq(1, Rank - 1)),
    lists:map(fun(RecommendRank) ->
                      hdb:dirty_read(WriteTable, RecommendRank, true)
              end, FrontList ++ [hmisc:rand(Rank + 1, Rank + 5)]).

rand_last(Low, Size, Rank, Range) ->
    Num1 = hmisc:rand(Low, Low + Range - 1),
    High = Low + Range*2 - 1,
    if
        Rank + 1 > Size ->
            Num1; 
        High > Size ->
            hmisc:rand([Num1, hmisc:rand(Rank + 1, Size)]);
        true ->
            hmisc:rand([Num1, hmisc:rand(Rank + 1, High)])
    end.
            
    

daily_reset(Player) ->
    mod_arena:reset_player(async_arena_rank, Player).

get_arena_report(async_arena_report, PlayerId) ->
    AllReports = 
        hdb:dirty_index_read(async_arena_report, PlayerId, #async_arena_report.deffender_id) ++ 
        hdb:dirty_index_read(async_arena_report, PlayerId, #async_arena_report.attack_id),
    SortList = 
        lists:sort(fun(#async_arena_report{timestamp = Time1}, #async_arena_report{timestamp = Time2}) ->
                           Time1 > Time2
                   end, AllReports),
    {Head, Tail} = list_misc:sublist(SortList, ?REPORT_MAX_SIZE),
    may_clean_report(Tail),
    Head;
get_arena_report(sync_arena_report, _PlayerId) ->
    [].


may_clean_report(CleanList) ->
    lists:foreach(fun
                      (#async_arena_report{id = Id}) ->
                          hdb:dirty_delete(async_arena_report, Id);
                      (#sync_arena_report{id = Id}) ->
                          hdb:dirty_delete(sync_arena_report, Id)
                  end, CleanList).


rank_top(Table, Sn, Count) ->    
    WriteTable = hdb:sn_table(Table, Sn),
    lists:reverse(rank_top2(WriteTable, 1, Count, [])).

rank_top2(_, _, 0, RankList) ->
    RankList;
rank_top2(WriteTable, Rank, Count, AccRankList) ->
    case hdb:dirty_read(WriteTable, Rank, true) of
        [] ->
            AccRankList;
        RankInfo ->
            rank_top2(WriteTable, Rank + 1, Count - 1, [RankInfo|AccRankList])
    end.

buy_challenge_times(Player) ->    
    case catch mod_arena:buy_challenge_times(async_arena_rank, Player) of
        {ok, NewPlayer, Rank} ->
            {ok, NewPlayer, Rank};
        {fail, Reason} ->
            {fail, Reason};
        Other ->
            ?WARNING_MSG("Other ~p~n", [Other]),
            {fail, ?INFO_SERVER_DATA_ERROR}
    end.
%%%%%%%%%%%%%%%%%%%%for test%%%%%%%%%%%%%%%%%%%%%%%%%%%
test() ->
    T1 = os:timestamp(),
    List = lists:seq(1, 2000),
    PidMRefs = [spawn_monitor(fun() -> mod_arena:new_player(async_arena_rank, #player{id = Id, sn = 1}) end) || Id <- List],
    [receive
         {'DOWN', MRef, process, _, normal} -> 
             ok;
         {'DOWN', MRef, process, _, Reason} ->
             io:format("reason ~p~n", [Reason]),
             exit(Reason)
     end || {_Pid, MRef} <- PidMRefs],
    T2 = os:timestamp(),
    Times = timer:now_diff(T2, T1),
    io:format("~p: ~p microseconds~n", [?MODULE, Times]).

test2() ->
    List = lists:seq(1, 5000),
    T1 = os:timestamp(),
    PidMRefs = [spawn_monitor(fun() -> recommend_player(#player{id = Id, sn = 1}) end) || Id <- List],
    [receive
         {'DOWN', MRef, process, _, normal} -> 
             ok;
         {'DOWN', MRef, process, _, Reason} -> 
             exit(Reason)
     end || {_Pid, MRef} <- PidMRefs],
    T2 = os:timestamp(),
    Times = timer:now_diff(T2, T1),
    io:format("~p: ~p microseconds~n", [?MODULE, Times]).

clear_rank() ->
    [ hdb:clear_table(list_to_atom(lists:concat([async_arena_rank, "_", DbSn]))) || DbSn <- server_misc:mnesia_sn_list()].
