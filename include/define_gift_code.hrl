-ifndef(DEFINE_GIFT_CODE_HRL).
-define(DEFINE_GIFT_CODE_HRL, true).

-include("db_activation_code.hrl").

-define(ETS_ACTIVATION_CODE, ets_activation_code).

%% 礼包类型编号，唯一，用于标示该礼包是否被领取过
-define(GIFT_IMESSAGE,      1).

-endif.

