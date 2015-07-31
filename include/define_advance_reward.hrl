-ifndef(DEFINE_ADVANCE_REWARD_HRL).
-define(DEFINE_ADVANCE_REWARD_HRL, true).

-include("db_base_advance_reward.hrl").

-define(TAR_NOT_FINISH, 0).
-define(TAR_FINISH, 1).

-record(advance_reward, {player_id = 0,
                         version = advance_reward_version:current_version(),
                         target_id = 0, %%进度id
                         finish = ?TAR_NOT_FINISH, %%是否完成
                         dirty = 0
                        }).

-endif.
