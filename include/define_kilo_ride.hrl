-ifndef(DEFINE_CHALLENGE_HRL).
-define(DEFINE_CHALLENGE_HRL, true).

-include("define_combat.hrl").
-include("define_trial.hrl").
-include("db_base_kilo_ride.hrl").
-include("db_base_kilo_ride_rank_reward.hrl").
-include("db_kilo_ride.hrl").

-define(ETS_BASE_KILO_RIDE, rec_base_kilo_ride).
-define(ETS_BASE_KILO_RIDE_RANK_REWARD, rec_base_kilo_ride_rank_reward).
-define(ETS_KILO_RIDE, rec_kilo_ride).

-define(DEBUG_KILO_RIDE(Format, Args),
        ?DEBUG("<<debug_challenge>> : " ++ Format, Args)).

-define(MAX_KILO_RIDE_LAYER, 100).

-define(CHEST_COLOR_COPPER,    1).
-define(CHEST_COLOR_SLIVER,    2).
-define(CHEST_COLOR_GOLD,      3).

-define(CALL_NPC_FLAG_UNCALL,  0).   %% 未召唤NPC
-define(CALL_NPC_FLAG_CALLED,  1).   %% 已召唤NPC



-endif.
