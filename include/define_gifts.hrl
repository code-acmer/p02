-ifndef(DEFINE_GIFTS_HRL).
-define(DEFINE_GIFTS_HRL,true).

-include("define_time.hrl").

-record(pay_gifts, {id = 0,
                    version = pay_gifts_version:current_version(),
                    player_id = 0,
                    sum = 0,          %%礼包的类型(100,200,500)
                    per_gold = 0,     %%每个礼包的价值
                    day_num = 0,      %%一天内发送的礼包数
                    recharge_gold_num = 0, %%充值钻石总数
                    rest_num = 0,     %%礼包剩余数量
                    all_num = 0,      %%礼包总的数量
                    last_send = 0,
                    over_time = 0,
                    dirty = 0,
                    recv_list = [],         %%谁领到了礼包
                    is_league = 0,          %%是否是会长发送的工会礼金产生的红包
                    all_days_value_list = [],        %%所有礼包的单个价值, [[a1,a2,a3....a10], [b1,b2,b3....b10] ... ]
                    one_days_value_list = []         %%一天中所有礼包的单个价值, [a1,a2,a3....a10]
                   }).

-record(league_gifts, {id = 0,
                       version = league_gifts_version:current_version(),
                       league_id = 0,
                       player_id = 0,
                       player_name = "",
                       rest_num = 0,          %%剩余数量
                       sum = 0,               %%礼包总数
                       per_gold = 0,          %%每个礼包的价值
                       gold_type = 0,         %%礼包的类型(100,200,500)
                       over_time = 0,
                       recv_list = [],         %%谁领到了礼包
                       is_league = 0,           %%是否是会长发送的工会礼金产生的红包
                       one_days_value_list = []
                      }).

-record(request_gifts_msg,{id = 0,
                           version = request_gifts_msg_version:current_version(),
                           player_id = 0,           %%被请求者ID
                           request_player_id = 0,   %%请求者ID
                           request_num = 0,         %%同一请求的次数
                           request_name = "",
                           is_read = 0
                          }).

-record(own_gift, {id = 0,
                   version = own_gift_version:current_version(),
                   player_id = 0,
                   goods_id = 0,
                   value = [],
                   timestamp = 0,
                   lv = 0,
                   is_bind = 0
                  }).

-define(GOLD_RECHARGE_BLOCK, 200). %%200个钻石一个块
-define(GOLD_OF_BLOCK, 50). %%每个块价值
-define(RETURN_GOLD_SCALE, 0.5). %%充值返还比例
-define(DAY_SEND_GIFTS, 10). %%每天发放的礼包数

-define(GIFT_ONE_KEY_SEND, 1). %% 一键发送
-define(GIFT_SEND, 0). %% 按键发送

-define(RECHARGE_GOLD, 0.1). %% 抽取10%给公会

-define(BOSS_GIFTS_OVERTIME, 3600 * 72). %% 72小时过期

-define(GIFT_FIVE_FOLD,   5). %% 5倍 
-define(GIFT_FOUR_FOLD,   4). %% 4倍
-define(GIFT_THREE_FOLD,  3). %% 3倍
-define(GIFT_TWO_FOLD,    2). %% 2倍

-define(GIFT_FIVE_FOLD_IN_EVEN,   5). %% 5倍 0.05 的概率
-define(GIFT_FOUR_FOLD_IN_EVEN,  15). %% 4倍 0.10 的概率
-define(GIFT_THREE_FOLD_IN_EVEN, 30). %% 3倍 0.15 的概率

-define(SERVER_EVEN_DAY,  7). %% 开服七天

-define(GIFT_FIVE_FOLD_OUT_EVEN,   2). %% 5倍 0.02 的概率
-define(GIFT_FOUR_FOLD_OUT_EVEN,   6). %% 4倍 0.04 的概率
-define(GIFT_THREE_FOLD_OUT_EVEN, 14). %% 3倍 0.08 的概率

-define(SERVER_FIFTY_DAY, 15). %% 开服15天

-define(GIFT_FIVE_FOLD_OUT_FIFTY,   1). %% 5倍 0.01 的概率
-define(GIFT_FOUR_FOLD_OUT_FIFTY,   3). %% 4倍 0.02 的概率
-define(GIFT_THREE_FOLD_OUT_FIFTY,  8). %% 3倍 0.05 的概率

-define(FIRST_LOGIN_GIFT_ZERO,  0). %% 间隔 0 次
-define(FIRST_LOGIN_GIFT_FIVE,  5). %% 间隔 5 次
-define(FIRST_LOGIN_GIFT_EVEN, 12). %% 间隔 7 次

-define(GIFT_GOLD_NUM, 50).

-define(GIFT_OUT_TIME, ?ONE_DAY_SECONDS*2).

-endif.
