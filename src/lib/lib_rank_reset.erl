-module(lib_rank_reset).
-include("define_mnesia.hrl").
-include("define_logger.hrl").
-include("define_rank.hrl").
-include("define_reward.hrl").
-include("define_mail.hrl").
-include("define_arena.hrl").
-include("define_player.hrl").
-include("db_base_pvp_rank_reward.hrl").
-export([reset_table/4,
         send_reward/2]).

reset_table(OriginTable, Table, ResetType, RewardFun) ->
    Now = time_misc:unixtime(),
    Key = key(Table),
    ?DEBUG("try to reset table ~p~n", [Table]),
    case hdb:dirty_read(server_config, Key) of
        [] ->
            ?DEBUG("first time to reset table~p~n", [Table]),
            hdb:dirty_write(server_config, #server_config{k = Key,
                                                          v = Now}),
            skip;
        #server_config{v = LastTime} ->
            case is_time_to_reset(ResetType, LastTime, Now) of
                false ->
                    ?DEBUG("not the time to reset ~p last ~p~n", 
                           [Table, time_misc:timestamp_to_datetime(LastTime)]),
                    skip;
                true ->
                    ?DEBUG("ok reset and send reward ~p last ~p~n",
                           [Table, time_misc:timestamp_to_datetime(LastTime)]),
                    send_reward(RewardFun),
                    hdb:dirty_write(server_config, #server_config{k = Key,
                                                                  v = Now}),
                    case may_clean_table(OriginTable) of
                        false ->
                            skip;
                        true ->
                            ?WARNING_MSG("clear_table ~p~n", [Table]),
                            hdb:clear_table(Table)
                    end
            end
    end.

%% send_reward(What) ->
%%     ?WARNING_MSG("What ~p~n", [What]),
%%     skip;
send_reward(undefined) ->
    skip;
send_reward(RewardFun) ->
    RewardFun().

key(Table) ->
    {rank_reset, Table}.

%%for RewardFun
%%兼容一下竞技场的
send_reward(async_arena_rank, WriteTable) ->
    ?DEBUG("async_arena_rank try to send reward ~n", []),
    RankTop = lib_rank:top(WriteTable, all),
    lists:foreach(fun
                      (#async_arena_rank{is_robot = ?RANK_PLAYER,
                                         player_id = PlayerId,
                                         rank = Rank}) ->
                          case lib_player:get_other_player(PlayerId) of
                              #player{lv = Lv} when Lv >= ?ARENA_REWARD_LV ->
                                  case data_base_pvp_rank_reward:get(Rank) of
                                      [] ->
                                          skip;
                                      #base_pvp_rank_reward{reward = []} ->
                                          skip;
                                      #base_pvp_rank_reward{reward = Reward} ->
                                          Mail = lib_mail:base_mail(?ASYNC_ARENA_RANK_REWARD_MAIL, [Rank], Reward),
                                          lib_mail:send_mail(PlayerId, Mail)
                                  end;
                              _ ->
                                  skip
                          end;
                      (_) ->
                          skip
                  end, RankTop);
send_reward(OriginTable, WriteTable) ->
    RankTop = lib_rank:top(WriteTable, all),
    case get_reward_pos(OriginTable) of
        undefined ->
            skip;
        {Pos, MailDefined} ->
            lists:foldl(fun(#rank{value = {_, _, PlayerId}}, AccRank) ->
                                send_reward2(PlayerId, Pos, AccRank, MailDefined),
                                AccRank + 1;
                           (#rank{value = {_, PlayerId}}, AccRank) ->
                                send_reward2(PlayerId, Pos, AccRank, MailDefined),
                                AccRank + 1
                        end, 1, RankTop)
    end.

send_reward2(PlayerId, Pos, Rank, MailDefined) ->
    case data_base_rank_reward:get(Rank) of
        [] ->
            skip;
        RankReward ->
            case element(Pos, RankReward) of
                [] ->
                    skip;
                Reward ->
                    MailReward = Reward,
                    Mail = lib_mail:base_mail(MailDefined, [Rank], MailReward),
                    lib_mail:send_mail(PlayerId, Mail)
            end
    end.

get_reward_pos(mugen_rank) ->
    {#base_rank_reward.mugen, ?MUGEN_RANK_REWARD_MAIL};
get_reward_pos(super_battle_rank) ->
    {#base_rank_reward.super_battle, ?SUPER_BATTLE_RANK_REWARD_MAIL};
get_reward_pos(cost_coin_rank) ->
    {#base_rank_reward.coins, ?COIN_RANK_REWARD_MAIL};
get_reward_pos(cost_gold_rank) ->
    {#base_rank_reward.golden, ?GOLD_RANK_REWARD_MAIL};
get_reward_pos(battle_ability_rank) ->
    {#base_rank_reward.battle_ability, ?BATTLE_ABILITY_RANK_REWARD_MAIL};
get_reward_pos(_) ->
    undefined.

may_clean_table(mugen_rank) ->
    true;
may_clean_table(super_battle_rank) ->
    true;
may_clean_table(_) ->
    false.

is_time_to_reset(daily, LastTime, Now) ->
    case time_misc:is_same_day(LastTime, Now) of
        true ->
            false;
        _ ->
            (Now - LastTime) >= ?ONE_DAY_SECONDS - 3 %%防止出现时间误差
    end;
is_time_to_reset(weekly, LastTime, Now) ->
    not time_misc:is_same_week(LastTime, Now);
is_time_to_reset(monthly, LastTime, Now) ->
    not time_misc:is_same_month(LastTime, Now);
is_time_to_reset(_, _, _) ->
    false.
