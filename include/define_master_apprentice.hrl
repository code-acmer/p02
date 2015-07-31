-ifndef(DEFINE_MASTER_APPRENTICE_HRL).
-define(DEFINE_MASTER_APPRENTICE_HRL, true).

-define(SKILL_CARD_WORK_DAY, 30). %% 出师进度

-define(MASTER, 0).     %% 师傅
-define(APPRENTICE, 1). %% 徒弟

-record(master_apprentice, {id = 0,
                            version = master_apprentice_version:current_version(),
                            master_player_id = 0,
                            master_accid = "",
                            master_player_name = "",
                            master_login_time = 0,
                            master_lv = 0,
                            master_ability = 0,
                            master_contribute = 0,            %%贡献
                            master_contribute_lv = 0,         %% 贡献等级
                            master_title = 0,
                            master_goods_id = 0,
                            master_skill_base_id = 0,
                            master_vip = 0,
                            apprentice_player_id = 0,
                            apprentice_player_name = "",
                            apprentice_login_time = 0,
                            apprentice_goods_id = 0,
                            apprentice_skill_base_id = 0,
                            skill_card_status = 0,            %% 0自身卡, 1未冻结, 2冻结, 3出师卡未领奖, 4出师卡领奖  
                            skill_card_work_day = 0,  %% 卡的进度
                            request_card_msg = []     %% 请求消息　[master_request_msg]
                           }).

-record(master_request_msg, {player_id = 0,
                             player_name = ""
                            }).

-define(MASTER_SELF_CARD,       0).  %% 普通卡
-define(MASTER_NOT_FREEZE_CARD, 1).  %% 解冻卡
-define(MASTER_FREEZE_CARD,     2).  %% 冻结卡
-define(MASTER_SUCCESS_CARD_NOT_REWARD, 3).  %% 出师卡未领奖
-define(MASTER_SUCCESS_CARD_REWARD,     4).  %% 出师卡领奖

-define(MASTER_LV_LIMIT, 30). %% 师傅等级限制
-define(MASTER_VIP_LIMIT, 4). %% 师傅Vip限制
-define(MASTER_CARD_STAR_LIMIT, 4). %% 4星级卡
-define(APPRENTICE_LV_LIMIT, 20). %% 徒弟等级限制

-define(MASTER_DAILY_REWAD_HONOR, 1000). %% 师傅每日奖励天赋点

-define(MASTER_TYPE_BUG_GOLD, 2). %% 钻石购买

-endif.

