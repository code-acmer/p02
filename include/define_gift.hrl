-ifndef(DEFINE_GIFT_HRL).
-define(DEFINE_GIFT_HRL, true).

-include("db_base_online_gift.hrl").
-include("db_base_login_gift.hrl").

-define(ETS_BASE_ONLINE_GIFT, ets_base_online_gift).
-define(ETS_BASE_LOGIN_GIFT,  ets_base_login_gift).
-define(ETS_ONLINE_GIFT,      ets_online_gift).
-define(ETS_PLAYER_GIFT,      ets_player_gift).

-endif.

