-module(dynarec_rank_reward_misc).
-include("db_base_rank_reward.hrl").
-compile({parse_transform, dynarec}).

-export([rec_set_value/3,
         rec_get_value/2]).

rec_set_value(KeyName, Value, Rec) ->
    set_value(KeyName, Value, Rec).

rec_get_value(KeyName, Rec) ->
    get_value(KeyName, Rec).
