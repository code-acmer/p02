-module(lib_rank_reward).
-export([reward/2]).

-include("db_base_rank_reward.hrl").
-include("define_logger.hrl").

reward(Item, Rank) 
  when is_integer(Rank) andalso is_atom(Item) ->
    case data_base_rank_reward:get(Rank) of
        [] ->
            [];
        RankReward ->
            Reward = dynarec_rank_reward_misc:rec_get_value(Item, RankReward),
            %lib_reward:generate_reward_list(Reward)
            Reward
    end;
reward(Item, Rank) ->
    ?WARNING_MSG("get rank reward error Item ~p, Rank ~p~n", [Item, Rank]),
    [].
