-ifndef(DEFINE_ARENA_HRL).
-define(DEFINE_ARENA_HRL,true).

-include("db_base_pvp_robot_attribute.hrl").

-define(RANK_ROBOT, 0).
-define(RANK_PLAYER, 1).

-define(RANK_STATE_FREE, 0).
-define(RANK_STATE_BUSY, 1).

-define(RANK_TYPE_ASYNC, 1).
-define(RANK_TYPE_SYNC, 2).

-define(RANK_LEVEL_HIGH, 20).
-define(RANK_RANGE, 10).
-define(RANK_REC_COUNT, 3).

-define(DAILI_CHALLENGE_TIMES, 10).

-define(CHALLENGE_LOSE, 2).
-define(CHALLENGE_WIN, 1).
-define(CHALLENGE_DRAW, 3).

-define(RANK_NO_CHANGE, 0).
-define(RANK_UP, 1).
-define(RANK_DOWN, 2).

-define(RANK_SEND_SIZE, 100).
-define(REPORT_MAX_SIZE, 10).

-define(MAX_BUY_TIMES, 1). %%购买次数限制
-define(EACH_BUY_TIMES, 10). %%增加的次数
-define(BUY_TIMES_COST, 100). %%花费的钻石

-define(EACH_BUY_TIMES_CROSS, 5). %%跨服购买增加的次数

-define(ARENA_REWARD_LV, 22). %%发放奖励的等级限制

-record(async_arena_rank, {
          rank,
          version = async_arena_rank_version:current_version(),
          player_id = 0,
          nickname,
          lv = 0,
          battle_ability = 0,
          career,
          win = 0,
          lose = 0,
          challenge_times = 0,
          rest_challenge_times = 0,
          buy_times = 0,
          is_robot = ?RANK_PLAYER,
          robot_id = 0,
          state = ?RANK_STATE_FREE}).

-record(sync_arena_rank, {
          rank,
          version = sync_arena_rank_version:current_version(),
          player_id = 0,
          nickname,
          lv = 0,
          battle_ability = 0,
          career,
          win = 0,
          lose = 0,
          challenge_times = 0,
          rest_challenge_times = 0,
          state = ?RANK_STATE_FREE}).

-record(async_arena_report, {
          id = 0,
          version = async_arena_report_version:current_version(),
          attack_id,
          nickname,
          deffender_id,
          deffender_name,
          result,
          rank_change_type,
          attack_rank,
          defender_rank,
          timestamp = 0
         }).

-record(sync_arena_report, {
          id = 0,
          version = sync_arena_report_version:current_version(),
          attack_id,
          nickname,
          deffender_id,
          deffender_name,
          result,
          rank_change_type,
          attack_rank,
          defender_rank,
          timestamp = 0
         }).

-endif.

