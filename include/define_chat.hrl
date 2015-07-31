-ifndef(DEFINE_CHAT_HRL).
-define(DEFINE_CHAT_HRL, true).
-define(MAX_CHAT_LIMIT, 100).
-define(MAX_GET_CHATS, 20).
-define(MAX_PRIVATE_SAVE, 50).

-define(MAX_LEAGUE_CHAT_LIMIT, 100). %%要清除的阀值
-define(MAX_LEAGUE_CHAT_MIN, 50).  %%清除到还剩余条数

-define(ACM_TYPE_RECHARGE_GIFTS, 1). %%红包充值公告
-define(ACM_TYPE_SEND_GIFTS, 2).  %%红包发放公告
-define(ACM_TYPE_RECEIVE_GIFT, 3). %%红包领取公告


-record(chats_world, {
          id = 0,
          version = chats_world_version:current_version(),
          player_id = 0,
          nickname = "",
          lv = 0,
          career = 0,
          msg = "",
          timestamp = 0}
         ).

-record(chat_private, {
          id,           %%{send_id, recv_id}
          version = chat_private_version:current_version(),
          msg_ids = [],
          new_msg = 0,
          recv_id = 0}).

-record(private_msg, {          
          id = 0,
          version = private_msg_version:current_version(),
          msg = "",
          timestamp = 0
         }).

-record(chat_league, {
          league_id = 0,
          version = chat_league_version:current_version(),
          size = 0,
          msg_ids = []}).

-record(league_msg, {
          id = 0,
          version = private_msg_version:current_version(),
          player_id = 0,
          nickname = "",
          msg = "",
          timestamp = 0
         }).

-endif.

