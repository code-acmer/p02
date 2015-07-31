-ifndef(DEFINE_ACHIEVE_HRL).
-define(DEFINE_ACHIEVE_HRL, true).

-define(ALL_NODES, '__ALL_NODES__').
-define(RANGE, 10000000).
-define(MAX_LOCAL_COUNTER, 16#0effffff).

-define(ALL_COUNTERS,[player_uid, dungeon_uid, fashion_uid, 
                      mails_uid, chats_private_uid, chats_world_uid,
                      goods_uid, player_skill_uid, task_uid,team_uid,
                      mugen_reward_uid, base_operators_mail_uid, league_uid,
                      league_chat_uid, pay_gifts_uid, league_gifts_record,
                      league_recharge_gold_record, request_gifts_msg,
                      next_own_gifts_id, cross_pvp_history_uid, general_store_id,
                      league_fight_point
                     ]).

-endif.
