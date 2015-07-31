%% coding: utf-8
%% Warning:本文件由data_generate自动生成，请不要手动修改
-module(data_base_error_list).
-export([get/1]).
-include("common.hrl").
-include("db_base_error_list.hrl").
get(1) ->
#base_error_list{error_code = 1,error_define = <<"INFO_UNKNOWN"/utf8>>,error_desc = <<" 未知错误"/utf8>>};
get(2) ->
#base_error_list{error_code = 2,error_define = <<"INFO_DB_ERROR"/utf8>>,error_desc = <<" 数据库操作失败"/utf8>>};
get(3) ->
#base_error_list{error_code = 3,error_define = <<"INFO_NOT_ENOUGH_VIGOR"/utf8>>,error_desc = <<" 没有足够的体力"/utf8>>};
get(4) ->
#base_error_list{error_code = 4,error_define = <<"INFO_NOT_ENOUGH_GOLD"/utf8>>,error_desc = <<" 元宝不足，无法进行此操作"/utf8>>};
get(5) ->
#base_error_list{error_code = 5,error_define = <<"INFO_NOT_ENOUGH_COIN"/utf8>>,error_desc = <<" 金钱不足，无法进行此操作"/utf8>>};
get(6) ->
#base_error_list{error_code = 6,error_define = <<"INFO_NOT_ENOUGH_PRESTIGE"/utf8>>,error_desc = <<" 声望不足，无法进行此操作"/utf8>>};
get(7) ->
#base_error_list{error_code = 7,error_define = <<"INFO_COST_MONEY_ERR"/utf8>>,error_desc = <<" 消耗不能是负数"/utf8>>};
get(8) ->
#base_error_list{error_code = 8,error_define = <<"INFO_FUNCTION_NOT_OPENED"/utf8>>,error_desc = <<" 功能尚未开放"/utf8>>};
get(9) ->
#base_error_list{error_code = 9,error_define = <<"INFO_OPERATE_TOO_FREQUENTLY"/utf8>>,error_desc = <<" 操作过于频繁，请稍后再试"/utf8>>};
get(10) ->
#base_error_list{error_code = 10,error_define = <<"INFO_NO_VIP"/utf8>>,error_desc = <<" 非VIP用户无法进行此操作"/utf8>>};
get(11) ->
#base_error_list{error_code = 11,error_define = <<"INFO_VIP_LEVEL_TOO_LOW"/utf8>>,error_desc = <<" VIP等级不足，无法进行此操作"/utf8>>};
get(12) ->
#base_error_list{error_code = 12,error_define = <<"INFO_NOT_SUPPORT_COST_MONEY_TYPE"/utf8>>,error_desc = <<" 不支持的消耗类型"/utf8>>};
get(13) ->
#base_error_list{error_code = 13,error_define = <<"INFO_NOT_ENOUGH_SCORE_1"/utf8>>,error_desc = <<" 竞技积分不足，无法进行此操作"/utf8>>};
get(14) ->
#base_error_list{error_code = 14,error_define = <<"INFO_NOT_ENOUGH_LEVEL"/utf8>>,error_desc = <<" 等级不足，无法进行此操作"/utf8>>};
get(15) ->
#base_error_list{error_code = 15,error_define = <<"INFO_NOT_ENOUGH_NUM"/utf8>>,error_desc = <<" 数量不足，无法进行此操作"/utf8>>};
get(16) ->
#base_error_list{error_code = 16,error_define = <<"INFO_NOT_FOR_USE"/utf8>>,error_desc = <<" 该物品无法使用"/utf8>>};
get(17) ->
#base_error_list{error_code = 17,error_define = <<"INFO_SERVER_STOPPED"/utf8>>,error_desc = <<" 服务器维护中，请稍后…"/utf8>>};
get(18) ->
#base_error_list{error_code = 18,error_define = <<"INFO_LOGIN_OTHER"/utf8>>,error_desc = <<" 帐号在其它地方登录，您已断开连接"/utf8>>};
get(19) ->
#base_error_list{error_code = 19,error_define = <<"INFO_SERVER_KICK_OUT"/utf8>>,error_desc = <<" 您的帐号异常，请联系GM"/utf8>>};
get(20) ->
#base_error_list{error_code = 20,error_define = <<"INFO_CUSTOM_MESSAGE"/utf8>>,error_desc = <<" %s"/utf8>>};
get(21) ->
#base_error_list{error_code = 21,error_define = <<"INFO_NOT_ENOUGH_COST"/utf8>>,error_desc = <<" 消耗不足"/utf8>>};
get(22) ->
#base_error_list{error_code = 22,error_define = <<"INFO_CONF_ERR"/utf8>>,error_desc = <<" 配置错误"/utf8>>};
get(23) ->
#base_error_list{error_code = 23,error_define = <<"INFO_NOT_ENOUGH_COMBAT_POINT"/utf8>>,error_desc = <<" 竞技点不足"/utf8>>};
get(24) ->
#base_error_list{error_code = 24,error_define = <<"INFO_NOT_LEGAL_INT"/utf8>>,error_desc = <<" 非法的数据"/utf8>>};
get(25) ->
#base_error_list{error_code = 25,error_define = <<"INFO_OK"/utf8>>,error_desc = <<" 操作成功"/utf8>>};
get(26) ->
#base_error_list{error_code = 26,error_define = <<"INFO_NOT_ENOUGH_HONOR"/utf8>>,error_desc = <<" 天赋点不足"/utf8>>};
get(27) ->
#base_error_list{error_code = 27,error_define = <<"INFO_SERVER_DATA_ERROR"/utf8>>,error_desc = <<" 服务器数据异常"/utf8>>};
get(28) ->
#base_error_list{error_code = 28,error_define = <<"INFO_PLAYER_PROCESS_ERROR"/utf8>>,error_desc = <<" 玩家进程异常"/utf8>>};
get(29) ->
#base_error_list{error_code = 29,error_define = <<"INFO_NOT_ENOUGH_SEAL"/utf8>>,error_desc = <<" 征途印章不足"/utf8>>};
get(30) ->
#base_error_list{error_code = 30,error_define = <<"INFO_NOT_ENOUGH_CROSS_COIN"/utf8>>,error_desc = <<" 荣誉印章不足"/utf8>>};
get(31) ->
#base_error_list{error_code = 31,error_define = <<"INFO_NOT_ENOUGH_LEAGUE_SEAL"/utf8>>,error_desc = <<" 公会印章不足"/utf8>>};
get(32) ->
#base_error_list{error_code = 32,error_define = <<"INFO_NOT_ENOUGH_ARENA_COIN"/utf8>>,error_desc = <<" 挑战印章不足"/utf8>>};
get(250) ->
#base_error_list{error_code = 250,error_define = <<"INFO_WRONG_OWNER"/utf8>>,error_desc = <<" 物品所属错误，无法进行此操作"/utf8>>};
get(251) ->
#base_error_list{error_code = 251,error_define = <<"INFO_NOT_EQUIPMENT"/utf8>>,error_desc = <<" 非装备，无法进行此操作"/utf8>>};
get(252) ->
#base_error_list{error_code = 252,error_define = <<"INFO_NOT_GOODS"/utf8>>,error_desc = <<" 错误的物品信息，无法进行此操作"/utf8>>};
get(253) ->
#base_error_list{error_code = 253,error_define = <<"INFO_NOT_IN_BAG"/utf8>>,error_desc = <<" 不在包裹中，无法进行此操作"/utf8>>};
get(254) ->
#base_error_list{error_code = 254,error_define = <<"INFO_FULL_OF_BAG"/utf8>>,error_desc = <<" 包裹已满，无法进行此操作"/utf8>>};
get(255) ->
#base_error_list{error_code = 255,error_define = <<"INFO_FULL_OF_STORAGE"/utf8>>,error_desc = <<" 仓库已满，无法进行此操作"/utf8>>};
get(256) ->
#base_error_list{error_code = 256,error_define = <<"INFO_FULL_OF_TREASURE"/utf8>>,error_desc = <<" 宝物库已满，无法容纳更多宝物！请先清理宝物库后再领取"/utf8>>};
get(266) ->
#base_error_list{error_code = 266,error_define = <<"INFO_ITEM_NOT_SATISFIED"/utf8>>,error_desc = <<" 材料不足，无法进行此操作"/utf8>>};
get(267) ->
#base_error_list{error_code = 267,error_define = <<"INFO_WRONG_POSITION"/utf8>>,error_desc = <<" 错误的位置信息，无法进行此操作"/utf8>>};
get(268) ->
#base_error_list{error_code = 268,error_define = <<"INFO_COOLDOWN_RESET_ALREADY"/utf8>>,error_desc = <<" 冷却时间已经完成，无需重置"/utf8>>};
get(269) ->
#base_error_list{error_code = 269,error_define = <<"INFO_WRONG_REWARD_LIST"/utf8>>,error_desc = <<" 奖励信息配置错误"/utf8>>};
get(270) ->
#base_error_list{error_code = 270,error_define = <<"INFO_WRONG_CAREER"/utf8>>,error_desc = <<" 职业不符，无法进行此操作"/utf8>>};
get(271) ->
#base_error_list{error_code = 271,error_define = <<"INFO_NOT_IN_RAID"/utf8>>,error_desc = <<" 非扫荡状态中，无法进行此操作"/utf8>>};
get(272) ->
#base_error_list{error_code = 272,error_define = <<"INFO_NOT_ONLINE"/utf8>>,error_desc = <<" 对方不在线"/utf8>>};
get(500) ->
#base_error_list{error_code = 500,error_define = <<"INFO_FULL_OF_MONEY"/utf8>>,error_desc = <<" 金钱已满，无法获取"/utf8>>};
get(501) ->
#base_error_list{error_code = 501,error_define = <<"INFO_FULL_OF_EXP"/utf8>>,error_desc = <<" 经验已经达到上限，无法获取"/utf8>>};
get(502) ->
#base_error_list{error_code = 502,error_define = <<"INFO_PARTNER_FULL_OF_EXP"/utf8>>,error_desc = <<" 伙伴经验已经达到上限，无法获取"/utf8>>};
get(503) ->
#base_error_list{error_code = 503,error_define = <<"INFO_PARTNER_LEVEL_EXCEED"/utf8>>,error_desc = <<" 伙伴等级已达角色等级，无法继续获取经验"/utf8>>};
get(510) ->
#base_error_list{error_code = 510,error_define = <<"INFO_GOODS_USE_SUCCESS"/utf8>>,error_desc = <<" 物品使用成功"/utf8>>};
get(511) ->
#base_error_list{error_code = 511,error_define = <<"INFO_UPGRADE_SUCCESS"/utf8>>,error_desc = <<" 升级成功"/utf8>>};
get(520) ->
#base_error_list{error_code = 520,error_define = <<"INFP_GET_REWARD"/utf8>>,error_desc = <<" 恭喜您获得%s"/utf8>>};
get(9009) ->
#base_error_list{error_code = 9009,error_define = <<"INFO_GM_CMD_ERROR"/utf8>>,error_desc = <<" 错误的GM命令"/utf8>>};
get(10000) ->
#base_error_list{error_code = 10000,error_define = <<"INFO_LOGIN_LOGIN_SUCCESS"/utf8>>,error_desc = <<" 登录成功"/utf8>>};
get(10001) ->
#base_error_list{error_code = 10001,error_define = <<"INFO_LOGIN_LOGIN_FAILED"/utf8>>,error_desc = <<" 登录失败"/utf8>>};
get(10002) ->
#base_error_list{error_code = 10002,error_define = <<"INFO_LOGIN_LOGIN_TIME_OUT"/utf8>>,error_desc = <<" 登录超时，无法进入游戏"/utf8>>};
get(10003) ->
#base_error_list{error_code = 10003,error_define = <<"INFO_LOGIN_NOT_SERVER_TIME"/utf8>>,error_desc = <<" 服务器尚未开启"/utf8>>};
get(10004) ->
#base_error_list{error_code = 10004,error_define = <<"INFO_LOGIN_ACCID_FAIL"/utf8>>,error_desc = <<" 帐号认证失败"/utf8>>};
get(10005) ->
#base_error_list{error_code = 10005,error_define = <<"INFO_LOGIN_SERVER_ON_UPDATE"/utf8>>,error_desc = <<" 服务器正在维护,请留意开服时间"/utf8>>};
get(10006) ->
#base_error_list{error_code = 10006,error_define = <<"INFO_LOGIN_SERVER_ERROR_ID"/utf8>>,error_desc = <<" 服务器号发生错误"/utf8>>};
get(10007) ->
#base_error_list{error_code = 10007,error_define = <<"INFO_LOGIN_ROLE_NOT_EXIST"/utf8>>,error_desc = <<" 角色不存在"/utf8>>};
get(10008) ->
#base_error_list{error_code = 10008,error_define = <<"INFO_LOGIN_ROLE_NUM_LIMIT"/utf8>>,error_desc = <<" 帐号角色达到上限"/utf8>>};
get(10010) ->
#base_error_list{error_code = 10010,error_define = <<"INFO_LOGIN_CREATE_ROLE_SUCCESS"/utf8>>,error_desc = <<" 创建角色成功"/utf8>>};
get(10011) ->
#base_error_list{error_code = 10011,error_define = <<"INFO_LOGIN_CREATE_ROLE_FAILED"/utf8>>,error_desc = <<" 创建角色失败"/utf8>>};
get(10012) ->
#base_error_list{error_code = 10012,error_define = <<"INFO_LOGIN_USED_NAME"/utf8>>,error_desc = <<" 角色名已经被使用"/utf8>>};
get(10013) ->
#base_error_list{error_code = 10013,error_define = <<"INFO_LOGIN_INVALID_NAME"/utf8>>,error_desc = <<" 角色名包含非法字符，无法使用"/utf8>>};
get(10014) ->
#base_error_list{error_code = 10014,error_define = <<"INFO_LOGIN_INVALID_LENGTH"/utf8>>,error_desc = <<" 角色名长度需要为 6 - 12 个字符"/utf8>>};
get(10015) ->
#base_error_list{error_code = 10015,error_define = <<"INFO_LOGIN_ROLE_EXIST"/utf8>>,error_desc = <<" 已经创建过角色，无法再创建"/utf8>>};
get(10016) ->
#base_error_list{error_code = 10016,error_define = <<"INFO_LOGIN_ROLE_MAX"/utf8>>,error_desc = <<" 同账号角色已经达到2个，无法再创建"/utf8>>};
get(10017) ->
#base_error_list{error_code = 10017,error_define = <<"INFO_LOGIN_BAN_WORDS"/utf8>>,error_desc = <<" 角色名包含敏感词，无法使用"/utf8>>};
get(10018) ->
#base_error_list{error_code = 10018,error_define = <<"INFO_LOGIN_ACCOUNT_NOT_EXIST"/utf8>>,error_desc = <<" 账号不存在"/utf8>>};
get(11010) ->
#base_error_list{error_code = 11010,error_define = <<"INFO_CHAT_WORLD_NO_HORN"/utf8>>,error_desc = <<" 世界聊天喇叭没有了，无法进行世界聊天"/utf8>>};
get(12001) ->
#base_error_list{error_code = 12001,error_define = <<"INFO_DUNGEON_DUNGEON_NOT_EXIST"/utf8>>,error_desc = <<" 关卡不存在"/utf8>>};
get(12002) ->
#base_error_list{error_code = 12002,error_define = <<"INFO_DUNGEON_TAKEN_REWARD"/utf8>>,error_desc = <<" 已经领过奖励了"/utf8>>};
get(12003) ->
#base_error_list{error_code = 12003,error_define = <<"INFO_DUNGEON_ONT_ENABLE"/utf8>>,error_desc = <<" 关卡还未开启"/utf8>>};
get(12004) ->
#base_error_list{error_code = 12004,error_define = <<"INFO_DUNGEON_IN_TIME"/utf8>>,error_desc = <<" 时间未到，关卡尚未开启"/utf8>>};
get(12006) ->
#base_error_list{error_code = 12006,error_define = <<"INFO_SUPER_BATTLE_OUT_OF_TIMES"/utf8>>,error_desc = <<" 挑战次数不足"/utf8>>};
get(12007) ->
#base_error_list{error_code = 12007,error_define = <<"INFO_DUNGEON_NEED_PREV"/utf8>>,error_desc = <<" 前置难度副本没有完成"/utf8>>};
get(12008) ->
#base_error_list{error_code = 12008,error_define = <<"INFO_DUNGEON_NO_DAILY"/utf8>>,error_desc = <<" 没有可打的日常副本"/utf8>>};
get(12009) ->
#base_error_list{error_code = 12009,error_define = <<"INFO_DUNGEON_DAILY_OUT_OF_TIMES"/utf8>>,error_desc = <<" 没有日常副本挑战次数"/utf8>>};
get(12010) ->
#base_error_list{error_code = 12010,error_define = <<"INFO_DUNGEON_SOURCE_OUT_OF_TIMES"/utf8>>,error_desc = <<" 该类资源副本次数已耗光"/utf8>>};
get(12011) ->
#base_error_list{error_code = 12011,error_define = <<"INFO_DUNGEON_NEED_PREV_TASK"/utf8>>,error_desc = <<" 需要完成前置任务"/utf8>>};
get(12020) ->
#base_error_list{error_code = 12020,error_define = <<"INFO_DUNGEON_MUGEN_PASS_ALL"/utf8>>,error_desc = <<" 通天塔已全部通关"/utf8>>};
get(12021) ->
#base_error_list{error_code = 12021,error_define = <<"INFO_DUNGEON_MUGEN_CAN_NOT_SKIP"/utf8>>,error_desc = <<" 通天塔当前关数不能使用跳关功能"/utf8>>};
get(12025) ->
#base_error_list{error_code = 12025,error_define = <<"INFO_DUNGEON_MUGEN_CHALLENGE_MAX"/utf8>>,error_desc = <<" 通天塔挑战好友数量已达到最高"/utf8>>};
get(12026) ->
#base_error_list{error_code = 12026,error_define = <<"INFO_DUNGEON_MUGEN_CHALLENGE_LIMIT"/utf8>>,error_desc = <<" 没有通天塔挑战次数"/utf8>>};
get(12027) ->
#base_error_list{error_code = 12027,error_define = <<"INFO_DUNGEON_MUGEN_CHALLENGE_LESS"/utf8>>,error_desc = <<" 不能挑战通关次数比你低的好友"/utf8>>};
get(12028) ->
#base_error_list{error_code = 12028,error_define = <<"INFO_DUNGEON_MUGEN_LUCKY_COIN_LIMIT"/utf8>>,error_desc = <<" 今天投放的幸运币已达到上限"/utf8>>};
get(12029) ->
#base_error_list{error_code = 12029,error_define = <<"INFO_DUNGEON_LUCKY_COIN_DUNPLICATE"/utf8>>,error_desc = <<" 你已经投放过幸运币给该好友"/utf8>>};
get(12030) ->
#base_error_list{error_code = 12030,error_define = <<"INFO_DUNGEON_RECV_LUCKY_COIN_LIMIT"/utf8>>,error_desc = <<" 目标好友接收的幸运币已经达到上限"/utf8>>};
get(12031) ->
#base_error_list{error_code = 12031,error_define = <<"INFO_DUNGEON_SUPER_BATTLE_BUY_LIMIT"/utf8>>,error_desc = <<" 公平竞技购买次数用光"/utf8>>};
get(12040) ->
#base_error_list{error_code = 12040,error_define = <<"INFO_KING_DUNGEON_BUY_TIMES_LIMIT"/utf8>>,error_desc = <<" 王者副本购买次数用光"/utf8>>};
get(12041) ->
#base_error_list{error_code = 12041,error_define = <<"INFO_TYPE_NOT_KING_DUNGEON"/utf8>>,error_desc = <<" 非王者副本类型，无法操作"/utf8>>};
get(12042) ->
#base_error_list{error_code = 12042,error_define = <<"INFO_DUNGEON_CANNOT_MOP_UP"/utf8>>,error_desc = <<" 达到S级以上的副本才能使用扫荡功能"/utf8>>};
get(12109) ->
#base_error_list{error_code = 12109,error_define = <<"INFO_DUNGEON_DUNGEON_DATA_NOT_FOUND"/utf8>>,error_desc = <<" 对应副本数据未找到，无法进行挂机"/utf8>>};
get(12110) ->
#base_error_list{error_code = 12110,error_define = <<"INFO_DUNGEON_FULL_OF_BAG"/utf8>>,error_desc = <<" 包裹已满，请先整理包裹后再尝试挂机"/utf8>>};
get(12111) ->
#base_error_list{error_code = 12111,error_define = <<"INFO_DUNGEON_RAID_INFO_NOT_FOUND"/utf8>>,error_desc = <<" 挂机数据获取失败"/utf8>>};
get(12120) ->
#base_error_list{error_code = 12120,error_define = <<"INFO_DUNGEON_ENTER_SUCCESS"/utf8>>,error_desc = <<" 副本可以进入"/utf8>>};
get(12121) ->
#base_error_list{error_code = 12121,error_define = <<"INFO_DUNGEON_ENTER_FAILED"/utf8>>,error_desc = <<" 副本进入失败"/utf8>>};
get(12122) ->
#base_error_list{error_code = 12122,error_define = <<"INFO_DUNGEON_ENTER_OUT_OF_TIMES"/utf8>>,error_desc = <<" 极限挑战大赛次数已经使用完毕，无法进入"/utf8>>};
get(12123) ->
#base_error_list{error_code = 12123,error_define = <<"INFO_DUNGEON_NOT_ALLOW_ENTER"/utf8>>,error_desc = <<" 不可进入的副本，无法进入"/utf8>>};
get(12124) ->
#base_error_list{error_code = 12124,error_define = <<"INFO_CANNOT_HELP"/utf8>>,error_desc = <<" 助战冷却中，不可选择"/utf8>>};
get(12130) ->
#base_error_list{error_code = 12130,error_define = <<"INFO_DUNGEON_ELITE_RESET_SUCCESS"/utf8>>,error_desc = <<" 重置精英副本成功"/utf8>>};
get(12131) ->
#base_error_list{error_code = 12131,error_define = <<"INFO_DUNGEON_ELITE_RESET_FAILED"/utf8>>,error_desc = <<" 重置精英副本失败"/utf8>>};
get(12132) ->
#base_error_list{error_code = 12132,error_define = <<"INFO_DUNGEON_ELITE_OPENED"/utf8>>,error_desc = <<" 精英副本激活中，无需重置"/utf8>>};
get(12133) ->
#base_error_list{error_code = 12133,error_define = <<"INFO_DUNGEON_ELITE_OUT_OF_RESET"/utf8>>,error_desc = <<" 重置次数使用完毕，请改日再来"/utf8>>};
get(12222) ->
#base_error_list{error_code = 12222,error_define = <<"INFO_DUNGEON_ROUTE_ERROR"/utf8>>,error_desc = <<" 副本路径出错"/utf8>>};
get(12223) ->
#base_error_list{error_code = 12223,error_define = <<"INFO_DUNGEON_REWARD_ERROR"/utf8>>,error_desc = <<" 奖励信息错误"/utf8>>};
get(12224) ->
#base_error_list{error_code = 12224,error_define = <<"INFO_DUNGEON_NOT_ALLOW_EXTRA"/utf8>>,error_desc = <<" 不允许的额外奖励"/utf8>>};
get(12225) ->
#base_error_list{error_code = 12225,error_define = <<"INFO_DUNGEON_SUPER_BATTLE_DEAD"/utf8>>,error_desc = <<" 目前状态不能继续挑战,请先重置副本"/utf8>>};
get(12300) ->
#base_error_list{error_code = 12300,error_define = <<"INFO_FLIP_CARD_REWARD_NOT_MATCH"/utf8>>,error_desc = <<" 翻牌奖励和副本不匹配"/utf8>>};
get(12301) ->
#base_error_list{error_code = 12301,error_define = <<"INFO_FLIP_CARD_TIMES_OUT"/utf8>>,error_desc = <<" 没有翻牌次数了"/utf8>>};
get(12302) ->
#base_error_list{error_code = 12302,error_define = <<"INFO_FLIP_CARD_NO_REWARD"/utf8>>,error_desc = <<" 翻牌奖励不存在"/utf8>>};
get(12303) ->
#base_error_list{error_code = 12303,error_define = <<"INFO_FLIP_CARD_ERROR_TYPE"/utf8>>,error_desc = <<" 翻牌类型错误"/utf8>>};
get(12400) ->
#base_error_list{error_code = 12400,error_define = <<"INFO_RELIVE_TIMES_OUT"/utf8>>,error_desc = <<" 复活次数不足"/utf8>>};
get(13004) ->
#base_error_list{error_code = 13004,error_define = <<"INFO_QUERY_OTHER_ERROR"/utf8>>,error_desc = <<" 亲，不要查看自己"/utf8>>};
get(13005) ->
#base_error_list{error_code = 13005,error_define = <<"INFO_QUERY_OTHER_NOTFIND"/utf8>>,error_desc = <<" 查找玩家不存在"/utf8>>};
get(13006) ->
#base_error_list{error_code = 13006,error_define = <<"INFO_ADD_MONEY_TYPE_ERR"/utf8>>,error_desc = <<" 玩家属性添加类型错误"/utf8>>};
get(13020) ->
#base_error_list{error_code = 13020,error_define = <<"INFO_VIP_REWARD_RECV"/utf8>>,error_desc = <<" 该VIP礼包已经领取"/utf8>>};
get(13110) ->
#base_error_list{error_code = 13110,error_define = <<"INFO_DAILY_REWARD_SUCCESS"/utf8>>,error_desc = <<" 登录奖励领取成功"/utf8>>};
get(13111) ->
#base_error_list{error_code = 13111,error_define = <<"INFO_DAILY_REWARD_FAILED"/utf8>>,error_desc = <<" 登录奖励领取失败"/utf8>>};
get(13112) ->
#base_error_list{error_code = 13112,error_define = <<"INFO_DAILY_REWARD_RECEIVED"/utf8>>,error_desc = <<" 所有的登录奖励均已领取"/utf8>>};
get(13113) ->
#base_error_list{error_code = 13113,error_define = <<"INFO_DAILY_REWARD_NOT_FOUND"/utf8>>,error_desc = <<" 登录奖励数据获取失败"/utf8>>};
get(13114) ->
#base_error_list{error_code = 13114,error_define = <<"INFO_DAILY_REWARD_RECEIVED_TODAY"/utf8>>,error_desc = <<" 今日的登录奖励已经领取过了，不可再领取"/utf8>>};
get(13152) ->
#base_error_list{error_code = 13152,error_define = <<"INFO_CHECK_IN_RECEIVED"/utf8>>,error_desc = <<" 今日的签到奖励已经领取过了，不可再领取"/utf8>>};
get(13200) ->
#base_error_list{error_code = 13200,error_define = <<"INFO_TEAM_DUNPLICATE"/utf8>>,error_desc = <<" 不能创建多个队伍"/utf8>>};
get(13201) ->
#base_error_list{error_code = 13201,error_define = <<"INFO_TEAM_CREATE_ERROR"/utf8>>,error_desc = <<" 创建队伍失败"/utf8>>};
get(13202) ->
#base_error_list{error_code = 13202,error_define = <<"INFO_TEAM_MEMBER_FULL"/utf8>>,error_desc = <<" 该队伍已经满员"/utf8>>};
get(13203) ->
#base_error_list{error_code = 13203,error_define = <<"INFO_TEAM_NOT_EXIST"/utf8>>,error_desc = <<" 该队伍已经解散"/utf8>>};
get(13204) ->
#base_error_list{error_code = 13204,error_define = <<"INFO_TEAM_IN_TEAM"/utf8>>,error_desc = <<" 你已经在队伍里面"/utf8>>};
get(13205) ->
#base_error_list{error_code = 13205,error_define = <<"INFO_TEAM_GET_TEAM_ERROR"/utf8>>,error_desc = <<" 获取队伍信息失败"/utf8>>};
get(13206) ->
#base_error_list{error_code = 13206,error_define = <<"INFO_TEAM_NOT_IN_TEAM"/utf8>>,error_desc = <<" 你当前不在队伍里面"/utf8>>};
get(13207) ->
#base_error_list{error_code = 13207,error_define = <<"INFO_TEAM_INVITE_SEND"/utf8>>,error_desc = <<" 好友邀请已经发送"/utf8>>};
get(13208) ->
#base_error_list{error_code = 13208,error_define = <<"INFO_TEAM_NO_KICK_MYSELF"/utf8>>,error_desc = <<" 你不能踢出自己"/utf8>>};
get(13209) ->
#base_error_list{error_code = 13209,error_define = <<"INFO_TEAM_NOT_LEADER"/utf8>>,error_desc = <<" 只有队长才能踢人"/utf8>>};
get(13210) ->
#base_error_list{error_code = 13210,error_define = <<"INFO_TEAM_TAR_NOT_IN_TEAM"/utf8>>,error_desc = <<" 踢出目标不在队伍里面"/utf8>>};
get(13211) ->
#base_error_list{error_code = 13211,error_define = <<"INFO_TEAM_DO_IN_READY"/utf8>>,error_desc = <<" 已经是准备状态"/utf8>>};
get(13212) ->
#base_error_list{error_code = 13212,error_define = <<"INFO_TEAM_DUNGEON_ON"/utf8>>,error_desc = <<" 副本已经开始，不能加入"/utf8>>};
get(13213) ->
#base_error_list{error_code = 13213,error_define = <<"INFO_TEAM_DUNGEON_START_LIMIT"/utf8>>,error_desc = <<" 只有队长才能开始副本"/utf8>>};
get(13214) ->
#base_error_list{error_code = 13214,error_define = <<"INFO_TEAM_NOT_ALL_READY"/utf8>>,error_desc = <<" 全部准备才能开始"/utf8>>};
get(13215) ->
#base_error_list{error_code = 13215,error_define = <<"INFO_TEAM_MEMBER_SINGLE"/utf8>>,error_desc = <<" 组队副本不能单人开始"/utf8>>};
get(13301) ->
#base_error_list{error_code = 13301,error_define = <<"INFO_SKILL_NOT_FOUND"/utf8>>,error_desc = <<" 没有该技能"/utf8>>};
get(13302) ->
#base_error_list{error_code = 13302,error_define = <<"INFO_SKILL_MAX"/utf8>>,error_desc = <<" 技能等级已满"/utf8>>};
get(13303) ->
#base_error_list{error_code = 13303,error_define = <<"INFO_LV_LIMIT"/utf8>>,error_desc = <<" 人物等级不足"/utf8>>};
get(13305) ->
#base_error_list{error_code = 13305,error_define = <<"INFO_SIGIL_SAME"/utf8>>,error_desc = <<" 切换的符印跟当前符印一致"/utf8>>};
get(13306) ->
#base_error_list{error_code = 13306,error_define = <<"INFO_SIGIL_NOT_FOUND"/utf8>>,error_desc = <<" 没有该符印"/utf8>>};
get(13307) ->
#base_error_list{error_code = 13307,error_define = <<"INFO_MONTH_SIGN_FALSE"/utf8>>,error_desc = <<" 今日已签"/utf8>>};
get(14000) ->
#base_error_list{error_code = 14000,error_define = <<"INFO_FRIEND_ADD_SUCCESS"/utf8>>,error_desc = <<" 添加好友成功"/utf8>>};
get(14001) ->
#base_error_list{error_code = 14001,error_define = <<"INFO_FRIEND_ADD_FAILED"/utf8>>,error_desc = <<" 添加好友失败"/utf8>>};
get(14002) ->
#base_error_list{error_code = 14002,error_define = <<"INFO_FRIEND_NOT_EXIST"/utf8>>,error_desc = <<" 目标好友不存在"/utf8>>};
get(14003) ->
#base_error_list{error_code = 14003,error_define = <<"INFO_FRIEND_IN_BLACK_LIST"/utf8>>,error_desc = <<" 在目标的黑名单中"/utf8>>};
get(14004) ->
#base_error_list{error_code = 14004,error_define = <<"INFO_FRIEND_HIS_NUM_EXCEED"/utf8>>,error_desc = <<" 好友的好友数已达上限"/utf8>>};
get(14005) ->
#base_error_list{error_code = 14005,error_define = <<"INFO_FRIEND_MY_NUM_EXCEED"/utf8>>,error_desc = <<" 我的好友数已达上限"/utf8>>};
get(14006) ->
#base_error_list{error_code = 14006,error_define = <<"INFO_FRIEND_FUNCTION_OFF"/utf8>>,error_desc = <<" 好友功能未开启"/utf8>>};
get(14007) ->
#base_error_list{error_code = 14007,error_define = <<"INFO_FRIEND_CAN_NOT_ADD_MYSELF"/utf8>>,error_desc = <<" 不能添加自己为好友"/utf8>>};
get(14008) ->
#base_error_list{error_code = 14008,error_define = <<"INFO_FRIEND_DUPLICATED"/utf8>>,error_desc = <<" 已经是好友了"/utf8>>};
get(14009) ->
#base_error_list{error_code = 14009,error_define = <<"INFO_FRIEND_REQUEST_SEND"/utf8>>,error_desc = <<" 添加好友申请已发送"/utf8>>};
get(14010) ->
#base_error_list{error_code = 14010,error_define = <<"INFO_FRIEND_DELETE_SUCCESS"/utf8>>,error_desc = <<" 删除好友成功"/utf8>>};
get(14011) ->
#base_error_list{error_code = 14011,error_define = <<"INFO_FRIEND_DELETE_FAILED"/utf8>>,error_desc = <<" 删除好友失败"/utf8>>};
get(14012) ->
#base_error_list{error_code = 14012,error_define = <<"INFO_FRIEND_NOT_FRIEND"/utf8>>,error_desc = <<" 目标不是你的好友"/utf8>>};
get(14013) ->
#base_error_list{error_code = 14013,error_define = <<"INFO_BUY_FPT_SUCCESS"/utf8>>,error_desc = <<" 成功增加5个好友上限"/utf8>>};
get(14020) ->
#base_error_list{error_code = 14020,error_define = <<"INFO_FRIEND_ADD_BLACK_SUCCESS"/utf8>>,error_desc = <<" 添加黑名单成功"/utf8>>};
get(14021) ->
#base_error_list{error_code = 14021,error_define = <<"INFO_FRIEND_ADD_BLACK_FAILED"/utf8>>,error_desc = <<" 添加黑名单失败"/utf8>>};
get(14022) ->
#base_error_list{error_code = 14022,error_define = <<"INFO_FRIEND_BLACK_LIST_EXCEED"/utf8>>,error_desc = <<" 黑名单已满，添加失败"/utf8>>};
get(14030) ->
#base_error_list{error_code = 14030,error_define = <<"INFO_FRIEND_ADD_ENEMY_SUCCESS"/utf8>>,error_desc = <<" 添加仇人成功"/utf8>>};
get(14031) ->
#base_error_list{error_code = 14031,error_define = <<"INFO_FRIEND_ADD_ENEMY_FAILED"/utf8>>,error_desc = <<" 添加仇人失败"/utf8>>};
get(14032) ->
#base_error_list{error_code = 14032,error_define = <<"INFO_FRIEND_IN_ENEMY_LIST"/utf8>>,error_desc = <<" 已经在仇人列表中了"/utf8>>};
get(14040) ->
#base_error_list{error_code = 14040,error_define = <<"INFO_FRIEND_INQUIRE_SUCCESS"/utf8>>,error_desc = <<" 查询成功"/utf8>>};
get(14041) ->
#base_error_list{error_code = 14041,error_define = <<"INFO_FRIEND_INQUIRE_FAILED"/utf8>>,error_desc = <<" 查询失败"/utf8>>};
get(14042) ->
#base_error_list{error_code = 14042,error_define = <<"INFO_FRIEND_INQUIRE_OFFLINE"/utf8>>,error_desc = <<" 查询目标不在线"/utf8>>};
get(14050) ->
#base_error_list{error_code = 14050,error_define = <<"INFO_FRIEND_DEL_BLACK_SUCCESS"/utf8>>,error_desc = <<" 删除黑名单成功"/utf8>>};
get(14051) ->
#base_error_list{error_code = 14051,error_define = <<"INFO_FRIEND_DEL_BLACK_FAILED"/utf8>>,error_desc = <<" 删除黑名单失败"/utf8>>};
get(14052) ->
#base_error_list{error_code = 14052,error_define = <<"INFO_FRIEND_NOT_IN_BLACK_LIST"/utf8>>,error_desc = <<" 不存在的黑名单数据"/utf8>>};
get(14060) ->
#base_error_list{error_code = 14060,error_define = <<"INFO_FRIEND_DEL_ENEMY_SUCCESS"/utf8>>,error_desc = <<" 删除仇人成功"/utf8>>};
get(14061) ->
#base_error_list{error_code = 14061,error_define = <<"INFO_FRIEND_DEL_ENEMY_FAILED"/utf8>>,error_desc = <<" 删除仇人失败"/utf8>>};
get(14062) ->
#base_error_list{error_code = 14062,error_define = <<"INFO_FRIEND_NOT_IN_ENEMY"/utf8>>,error_desc = <<" 不存在的仇人数据"/utf8>>};
get(15000) ->
#base_error_list{error_code = 15000,error_define = <<"INFO_GOODS_CFG_NOT_FOUND"/utf8>>,error_desc = <<" 斗魂配置数据未找到"/utf8>>};
get(15001) ->
#base_error_list{error_code = 15001,error_define = <<"INFO_PLAYER_GOODS_NOT_FOUND"/utf8>>,error_desc = <<" 玩家斗魂数据未找到"/utf8>>};
get(15002) ->
#base_error_list{error_code = 15002,error_define = <<"INFO_GOODS_UPGRADE_INFO_NOT_FOUND"/utf8>>,error_desc = <<" 装备升级配置未找到"/utf8>>};
get(15003) ->
#base_error_list{error_code = 15003,error_define = <<"INFO_GOODS_LV_LIMIT"/utf8>>,error_desc = <<" 斗魂已升到顶级"/utf8>>};
get(15004) ->
#base_error_list{error_code = 15004,error_define = <<"INFO_GOODS_BAG_EXT_SUCCESS"/utf8>>,error_desc = <<" 成功增加5个斗魂仓库"/utf8>>};
get(15005) ->
#base_error_list{error_code = 15005,error_define = <<"INFO_GOODS_JEWEL_FULL"/utf8>>,error_desc = <<" 装备宝石已达到上限，无法再镶嵌"/utf8>>};
get(15006) ->
#base_error_list{error_code = 15006,error_define = <<"INFO_GOODS_JEWEL_HAS_INLAID"/utf8>>,error_desc = <<" 该宝石已经镶嵌在装备上了"/utf8>>};
get(15007) ->
#base_error_list{error_code = 15007,error_define = <<"INFO_GOODS_NOT_JEWEL_TYPE"/utf8>>,error_desc = <<" 非宝石类型，无法操作"/utf8>>};
get(15008) ->
#base_error_list{error_code = 15008,error_define = <<"INFO_GOODS_JEWEL_NOT_INLAID"/utf8>>,error_desc = <<" 目标宝石不在该装备上"/utf8>>};
get(15009) ->
#base_error_list{error_code = 15009,error_define = <<"INFO_GOODS_NOT_JEWEL"/utf8>>,error_desc = <<" 该装备上没有宝石"/utf8>>};
get(15010) ->
#base_error_list{error_code = 15010,error_define = <<"INFO_GOODS_NOT_JEWEL_HOLE"/utf8>>,error_desc = <<" 该装备上没有宝石孔,不能镶嵌宝石"/utf8>>};
get(15011) ->
#base_error_list{error_code = 15011,error_define = <<"INFO_GOODS_HOLE_HAS_JEWEL"/utf8>>,error_desc = <<" 该孔上已存在宝石,请先脱下"/utf8>>};
get(15012) ->
#base_error_list{error_code = 15012,error_define = <<"INFO_GOODS_HOLE_NOT_JEWEL"/utf8>>,error_desc = <<" 装备目标孔上没有宝石"/utf8>>};
get(15013) ->
#base_error_list{error_code = 15013,error_define = <<"INFO_GOODS_NOT_COMPOSE"/utf8>>,error_desc = <<" 该物品无法合成"/utf8>>};
get(15020) ->
#base_error_list{error_code = 15020,error_define = <<"INFO_GOODS_NOT_SAME_SUB_TYPE"/utf8>>,error_desc = <<" 装备部位不同，传承失败"/utf8>>};
get(15021) ->
#base_error_list{error_code = 15021,error_define = <<"INFO_GOODS_HAVE_UPGRADE"/utf8>>,error_desc = <<" 升级装备无法传承"/utf8>>};
get(15022) ->
#base_error_list{error_code = 15022,error_define = <<"INFO_GOODS_TARGET_LV_LOWER"/utf8>>,error_desc = <<" 无法传承低级装备"/utf8>>};
get(15023) ->
#base_error_list{error_code = 15023,error_define = <<"INFO_GOODS_COLOR_LV_LOWER"/utf8>>,error_desc = <<" 无法传承低级颜色装备"/utf8>>};
get(15100) ->
#base_error_list{error_code = 15100,error_define = <<"INFO_GOODS_HAVE_EQUIPED"/utf8>>,error_desc = <<" 物品已经装备"/utf8>>};
get(15101) ->
#base_error_list{error_code = 15101,error_define = <<"INFO_GOODS_NOT_ENOUGH_LV"/utf8>>,error_desc = <<" 技能卡等级不够,不能升阶"/utf8>>};
get(15300) ->
#base_error_list{error_code = 15300,error_define = <<"INFO_SHOP_GOODS_TIMEOUT"/utf8>>,error_desc = <<" 商品不在上架时间内"/utf8>>};
get(15500) ->
#base_error_list{error_code = 15500,error_define = <<"INFO_GOODS_REPURCHASE_SUCCESS"/utf8>>,error_desc = <<" 回购成功"/utf8>>};
get(15501) ->
#base_error_list{error_code = 15501,error_define = <<"INFO_GOODS_REPURCHASE_FAILED"/utf8>>,error_desc = <<" 回购失败"/utf8>>};
get(15502) ->
#base_error_list{error_code = 15502,error_define = <<"INFO_GOODS_REPURCHASE_WRONG_INFO"/utf8>>,error_desc = <<" 回购数据获取失败，无法回购"/utf8>>};
get(15503) ->
#base_error_list{error_code = 15503,error_define = <<"INFO_GOODS_UPGRADE_TIMES_ERROR"/utf8>>,error_desc = <<" 装备升级次数出错"/utf8>>};
get(15504) ->
#base_error_list{error_code = 15504,error_define = <<"INFO_GOODS_NOT_IN_EQUIP"/utf8>>,error_desc = <<" 物品没有装备上，无法卸下"/utf8>>};
get(15510) ->
#base_error_list{error_code = 15510,error_define = <<"INFO_GOODS_SELL_ITEM_SUCCESS"/utf8>>,error_desc = <<" 出售成功"/utf8>>};
get(15511) ->
#base_error_list{error_code = 15511,error_define = <<"INFO_GOODS_SELL_ITEM_FAILED"/utf8>>,error_desc = <<" 出售失败"/utf8>>};
get(15512) ->
#base_error_list{error_code = 15512,error_define = <<"INFO_GOODS_SELL_ITEM_DUPLICATED"/utf8>>,error_desc = <<" 出售的物品中有重复的信息，出售失败"/utf8>>};
get(15513) ->
#base_error_list{error_code = 15513,error_define = <<"INFO_GOODS_SELL_WRONG_ITEM_INFO"/utf8>>,error_desc = <<" 错误的物品信息，出售失败"/utf8>>};
get(15514) ->
#base_error_list{error_code = 15514,error_define = <<"INFO_GOODS_CANNOT_BE_SOLD"/utf8>>,error_desc = <<" 该物品不可出售"/utf8>>};
get(15515) ->
#base_error_list{error_code = 15515,error_define = <<"INFO_GOODS_NOT_ENOUGH_COST"/utf8>>,error_desc = <<" 消耗材料不足"/utf8>>};
get(15520) ->
#base_error_list{error_code = 15520,error_define = <<"INFO_GOODS_BUY_ITEM_SUCCESS"/utf8>>,error_desc = <<" 购买成功"/utf8>>};
get(15521) ->
#base_error_list{error_code = 15521,error_define = <<"INFO_GOODS_BUY_ITEM_FAILED"/utf8>>,error_desc = <<" 购买失败"/utf8>>};
get(15522) ->
#base_error_list{error_code = 15522,error_define = <<"INFO_GOODS_NOT_ENOUGH_BAG"/utf8>>,error_desc = <<" 包裹剩余空间不足，请整理后再尝试"/utf8>>};
get(15523) ->
#base_error_list{error_code = 15523,error_define = <<"INFO_GOODS_WRONG_BUY_NUMBER"/utf8>>,error_desc = <<" 购买的数量错误，无法购买"/utf8>>};
get(15524) ->
#base_error_list{error_code = 15524,error_define = <<"INFO_GOODS_WRONG_ITEM_INFO"/utf8>>,error_desc = <<" 获取购买物品信息失败，无法购买"/utf8>>};
get(15525) ->
#base_error_list{error_code = 15525,error_define = <<"INFO_GOODS_NO_VIP"/utf8>>,error_desc = <<" 非VIP玩家无法使用VIP商店"/utf8>>};
get(15526) ->
#base_error_list{error_code = 15526,error_define = <<"INFO_GOODS_NOT_ENOUGH_GOLD"/utf8>>,error_desc = <<" 元宝不足，无法购买"/utf8>>};
get(15527) ->
#base_error_list{error_code = 15527,error_define = <<"INFO_GOODS_NOT_ENOUGH_COIN"/utf8>>,error_desc = <<" 金钱不足，无法购买"/utf8>>};
get(15530) ->
#base_error_list{error_code = 15530,error_define = <<"INFO_GOODS_SWITCH_ITEM_SUCCESS"/utf8>>,error_desc = <<" 更换武器成功"/utf8>>};
get(15531) ->
#base_error_list{error_code = 15531,error_define = <<"INFO_GOODS_SWITCH_ITEM_FAILED"/utf8>>,error_desc = <<" 更换武器失败"/utf8>>};
get(15532) ->
#base_error_list{error_code = 15532,error_define = <<"INFO_GOODS_ITEM_NOT_FOUND"/utf8>>,error_desc = <<" 未找到对应物品"/utf8>>};
get(15533) ->
#base_error_list{error_code = 15533,error_define = <<"INFO_GOODS_TAKE_OFF_FULL_OF_BAG"/utf8>>,error_desc = <<" 包裹已满，无法取下"/utf8>>};
get(15534) ->
#base_error_list{error_code = 15534,error_define = <<"INFO_GOODS_PARTNER_NOT_FOUND"/utf8>>,error_desc = <<" 未找到伙伴信息"/utf8>>};
get(15535) ->
#base_error_list{error_code = 15535,error_define = <<"INFO_GOODS_BAD_OWNER_INFO"/utf8>>,error_desc = <<" 装备或伙伴所属错误"/utf8>>};
get(15536) ->
#base_error_list{error_code = 15536,error_define = <<"INFO_GOODS_ITEM_NOT_IN_BAG"/utf8>>,error_desc = <<" 装备未在包裹中，请整理后再尝试"/utf8>>};
get(15537) ->
#base_error_list{error_code = 15537,error_define = <<"INFO_GOODS_WRONG_TARGET_POSITION"/utf8>>,error_desc = <<" 目标位置错误，无法穿戴"/utf8>>};
get(15538) ->
#base_error_list{error_code = 15538,error_define = <<"INFO_GOODS_NOT_EQUIPMENT"/utf8>>,error_desc = <<" 非装备类型，无法操作"/utf8>>};
get(15539) ->
#base_error_list{error_code = 15539,error_define = <<"INFO_GOODS_WRONG_CAREER"/utf8>>,error_desc = <<" 装备职业类型不符，无法穿戴"/utf8>>};
get(15540) ->
#base_error_list{error_code = 15540,error_define = <<"INFO_GOODS_LEVEL_NOT_SATISFIED"/utf8>>,error_desc = <<" 等级不足，无法穿戴"/utf8>>};
get(15541) ->
#base_error_list{error_code = 15541,error_define = <<"INFO_GOODS_NOT_SAME_CARRER"/utf8>>,error_desc = <<" 职业不同，武器部位未交换"/utf8>>};
get(15542) ->
#base_error_list{error_code = 15542,error_define = <<"INFO_GOODS_CHANGE_EQUIP_FAILED"/utf8>>,error_desc = <<" 变化武器失败"/utf8>>};
get(15543) ->
#base_error_list{error_code = 15543,error_define = <<"INFO_GOODS_CHANGE_EQUIP_DESC_ERROR"/utf8>>,error_desc = <<" 变化武器的目标武器信息错误"/utf8>>};
get(15550) ->
#base_error_list{error_code = 15550,error_define = <<"INFO_GOODS_TREASURE_SUCCESS"/utf8>>,error_desc = <<" 成功使用摇钱树，金钱 + %s"/utf8>>};
get(15551) ->
#base_error_list{error_code = 15551,error_define = <<"INFO_GOODS_TREASURE_FAILED"/utf8>>,error_desc = <<" 使用摇钱树失败"/utf8>>};
get(15552) ->
#base_error_list{error_code = 15552,error_define = <<"INFO_GOODS_TREASURE_GOLD_OUT"/utf8>>,error_desc = <<" 元宝不足，无法使用摇钱树"/utf8>>};
get(15553) ->
#base_error_list{error_code = 15553,error_define = <<"INFO_GOODS_TREASURE_TIMES_OUT"/utf8>>,error_desc = <<" 今日的剩余摇钱树使用次数不足"/utf8>>};
get(15560) ->
#base_error_list{error_code = 15560,error_define = <<"INFO_GOODS_STAMINA_SUCCESS"/utf8>>,error_desc = <<" 体力购买成功"/utf8>>};
get(15561) ->
#base_error_list{error_code = 15561,error_define = <<"INFO_GOODS_STAMINA_FAILED"/utf8>>,error_desc = <<" 体力购买失败"/utf8>>};
get(15562) ->
#base_error_list{error_code = 15562,error_define = <<"INFO_GOODS_STAMINA_GOLD_OUT"/utf8>>,error_desc = <<" 元宝不足，无法购买体力"/utf8>>};
get(15563) ->
#base_error_list{error_code = 15563,error_define = <<"INFO_GOODS_STAMINA_TIMES_OUT"/utf8>>,error_desc = <<" 今日的体力购买次数已经使用完毕"/utf8>>};
get(15564) ->
#base_error_list{error_code = 15564,error_define = <<"INFO_GOODS_STAMINA_EXCEED"/utf8>>,error_desc = <<" 体力较为充沛，无需购买"/utf8>>};
get(15570) ->
#base_error_list{error_code = 15570,error_define = <<"INFO_GOODS_STRENGTHEN_SUCCESS"/utf8>>,error_desc = <<" 强化成功"/utf8>>};
get(15571) ->
#base_error_list{error_code = 15571,error_define = <<"INFO_GOODS_STRENGTHEN_LV_FULL"/utf8>>,error_desc = <<" 强化等级已满"/utf8>>};
get(15572) ->
#base_error_list{error_code = 15572,error_define = <<"INFO_GOODS_STRENGTHEN_LEVEL_EXCEED"/utf8>>,error_desc = <<" 强化等级不能超过主角等级，强化失败"/utf8>>};
get(15573) ->
#base_error_list{error_code = 15573,error_define = <<"INFO_GOODS_STRENGTHEN_WRONG_RULE"/utf8>>,error_desc = <<" 错误的强化规则，强化失败"/utf8>>};
get(15574) ->
#base_error_list{error_code = 15574,error_define = <<"INFO_GOODS_STAR_FULL"/utf8>>,error_desc = <<" 物品星级已满    "/utf8>>};
get(15580) ->
#base_error_list{error_code = 15580,error_define = <<"INFO_GOODS_SWITCH_SUCCESS"/utf8>>,error_desc = <<" 物品交换成功"/utf8>>};
get(15581) ->
#base_error_list{error_code = 15581,error_define = <<"INFO_GOODS_SWITCH_FAILED"/utf8>>,error_desc = <<" 物品交换失败"/utf8>>};
get(15582) ->
#base_error_list{error_code = 15582,error_define = <<"INFO_GOODS_SWITCH_THE_SAME"/utf8>>,error_desc = <<" 同一个物品，无法交换"/utf8>>};
get(15583) ->
#base_error_list{error_code = 15583,error_define = <<"INFO_GOODS_SWITCH_SAME_POSITION"/utf8>>,error_desc = <<" 目标位置和源位置相同，无法移动"/utf8>>};
get(15584) ->
#base_error_list{error_code = 15584,error_define = <<"INFO_GOODS_SWITCH_WRONG_TARGET"/utf8>>,error_desc = <<" 目标位置错误，无法移动"/utf8>>};
get(15590) ->
#base_error_list{error_code = 15590,error_define = <<"INFO_GOODS_FORGE_SUCCESS"/utf8>>,error_desc = <<" 装备升阶成功"/utf8>>};
get(15591) ->
#base_error_list{error_code = 15591,error_define = <<"INFO_GOODS_FORGE_FAILED"/utf8>>,error_desc = <<" 装备升阶失败"/utf8>>};
get(15592) ->
#base_error_list{error_code = 15592,error_define = <<"INFO_GOODS_FORGE_RULE_NOT_FOUND"/utf8>>,error_desc = <<" 装备升阶规则获取失败，无法进阶"/utf8>>};
get(15593) ->
#base_error_list{error_code = 15593,error_define = <<"INFO_GOODS_FORGE_EQUIP_NOT_FOUND"/utf8>>,error_desc = <<" 装备升阶后的数据获取失败，无法进阶"/utf8>>};
get(15594) ->
#base_error_list{error_code = 15594,error_define = <<"INFO_GOODS_FORGE_LEVEL_EXCEED"/utf8>>,error_desc = <<" 升阶后的装备穿戴等级不足，无法进阶"/utf8>>};
get(15595) ->
#base_error_list{error_code = 15595,error_define = <<"INFO_GOODS_KEY_ITEM_NOT_SATISFIED"/utf8>>,error_desc = <<" 无法补齐： [%s] 为关键材料，不能使用元宝补齐"/utf8>>};
get(15596) ->
#base_error_list{error_code = 15596,error_define = <<"INFO_GOODS_FORGE_KEY_NOT_SATISFIED"/utf8>>,error_desc = <<" 无法补齐： [%s] 为关键材料，不能使用元宝补齐，需通过精英副本掉落来获得"/utf8>>};
get(15597) ->
#base_error_list{error_code = 15597,error_define = <<"INFO_GOODS_ARTIFACT_KEY_NOT_SATISFIED"/utf8>>,error_desc = <<" 无法补齐： [%s] 为关键材料，不能使用元宝补齐，需通过神秘商人、每日奖励等方式获得"/utf8>>};
get(15598) ->
#base_error_list{error_code = 15598,error_define = <<"INFO_GOODS_DUNGEON_NOT_PASSED"/utf8>>,error_desc = <<" 无法补齐：需要通关副本 [%s] 后，才能用元宝补齐 [%s]"/utf8>>};
get(15599) ->
#base_error_list{error_code = 15599,error_define = <<"INFO_GOODS_FORGE_VIP_LOWER"/utf8>>,error_desc = <<" vip等级不足，无法使用材料补齐功能"/utf8>>};
get(15600) ->
#base_error_list{error_code = 15600,error_define = <<"INFO_GOODS_RESET_MYSTERY_SHOP_SUCCESS"/utf8>>,error_desc = <<" 刷新神秘商店成功"/utf8>>};
get(15601) ->
#base_error_list{error_code = 15601,error_define = <<"INFO_GOODS_RESET_MYSTERY_SHOP_FAILED"/utf8>>,error_desc = <<" 刷新神秘商店失败"/utf8>>};
get(15602) ->
#base_error_list{error_code = 15602,error_define = <<"INFO_GOODS_NOT_IN_MYSTERY_SHOP"/utf8>>,error_desc = <<" 非神秘商店物品或已经购买，购买失败"/utf8>>};
get(15603) ->
#base_error_list{error_code = 15603,error_define = <<"INFO_GOODS_WRONG_MYSTERY_SHOP"/utf8>>,error_desc = <<" 神秘商店信息获取失败，购买失败"/utf8>>};
get(15604) ->
#base_error_list{error_code = 15604,error_define = <<"INFO_GOODS_MYSTERY_SHOP_TIMES_OUT"/utf8>>,error_desc = <<" 神秘商店刷新次数使用完毕，刷新失败"/utf8>>};
get(15605) ->
#base_error_list{error_code = 15605,error_define = <<"INFO_GOODS_WRONG_TIME_MYSTERY_SHOP"/utf8>>,error_desc = <<" 当前时间段您已免费刷新过，可购买刷新机会"/utf8>>};
get(15606) ->
#base_error_list{error_code = 15606,error_define = <<"INFO_GOODS_WRONG_REPEAT_BUY"/utf8>>,error_desc = <<" 该物品已购买，不可重复"/utf8>>};
get(15607) ->
#base_error_list{error_code = 15607,error_define = <<"INFO_GOODS_WRONG_SHOP_OVERDUE"/utf8>>,error_desc = <<" 神秘商店过期，请尝试重新获取神秘商店"/utf8>>};
get(15608) ->
#base_error_list{error_code = 15608,error_define = <<"INFO_GOODS_WRONG_POS"/utf8>>,error_desc = <<" 商品位置错误"/utf8>>};
get(15610) ->
#base_error_list{error_code = 15610,error_define = <<"INFO_GOODS_CONTAINER_EXTEND_SUCCESS"/utf8>>,error_desc = <<" 开启容器成功"/utf8>>};
get(15611) ->
#base_error_list{error_code = 15611,error_define = <<"INFO_GOODS_CONTAINER_EXTEND_FAILED"/utf8>>,error_desc = <<" 开启容器失败"/utf8>>};
get(15612) ->
#base_error_list{error_code = 15612,error_define = <<"INFO_GOODS_CONTAINER_EXTEND_ALL"/utf8>>,error_desc = <<" 容器已经开启完毕"/utf8>>};
get(15613) ->
#base_error_list{error_code = 15613,error_define = <<"INFO_UPDATE_REWARD_ALEADY_GET"/utf8>>,error_desc = <<" 您已领取过更新奖励"/utf8>>};
get(15700) ->
#base_error_list{error_code = 15700,error_define = <<"INFO_SCORE2_BUY_TIMES_LIMIT"/utf8>>,error_desc = <<" 已达最大军粮够买次数"/utf8>>};
get(15701) ->
#base_error_list{error_code = 15701,error_define = <<"INFO_GOODS_BUY_SCORE2_SUCCESS"/utf8>>,error_desc = <<" 购买军粮成功"/utf8>>};
get(15800) ->
#base_error_list{error_code = 15800,error_define = <<"INFO_GOODS_GIFT_OK"/utf8>>,error_desc = <<" 礼包领取成功"/utf8>>};
get(15801) ->
#base_error_list{error_code = 15801,error_define = <<"INFO_GOODS_GIFT_FAILED"/utf8>>,error_desc = <<" 礼包领取失败"/utf8>>};
get(15802) ->
#base_error_list{error_code = 15802,error_define = <<"INFO_GOODS_GIFT_WRONG_CODE"/utf8>>,error_desc = <<" 激活码输入错误，领取失败"/utf8>>};
get(15803) ->
#base_error_list{error_code = 15803,error_define = <<"INFO_GOODS_GIFT_ALREADY_GOT"/utf8>>,error_desc = <<" 该礼包已经领取过了"/utf8>>};
get(15850) ->
#base_error_list{error_code = 15850,error_define = <<"INFO_XUNZHANG_NO_FIND"/utf8>>,error_desc = <<" 背包中没有该勋章"/utf8>>};
get(15851) ->
#base_error_list{error_code = 15851,error_define = <<"INFO_XUNZHANG_LV_LIMIT"/utf8>>,error_desc = <<" 勋章升级，等级不足"/utf8>>};
get(15852) ->
#base_error_list{error_code = 15852,error_define = <<"INFO_XUNZHANG_GET_WRONG"/utf8>>,error_desc = <<" 配置没有该勋章"/utf8>>};
get(15853) ->
#base_error_list{error_code = 15853,error_define = <<"INFO_XUNZHANG_FIND"/utf8>>,error_desc = <<" 勋章已激活"/utf8>>};
get(15870) ->
#base_error_list{error_code = 15870,error_define = <<"INFO_BUY_NUM_LIMIT"/utf8>>,error_desc = <<" 您在一天内被购买该商品次数有限制，请勿超量购买"/utf8>>};
get(15880) ->
#base_error_list{error_code = 15880,error_define = <<"INFO_ACTIVITY_SHOP_OVERDUE"/utf8>>,error_desc = <<" 抢购活动过期"/utf8>>};
get(15881) ->
#base_error_list{error_code = 15881,error_define = <<"INFO_SHOP_NO_FIND"/utf8>>,error_desc = <<" 当前活动不存在该商品"/utf8>>};
get(15882) ->
#base_error_list{error_code = 15882,error_define = <<"INFO_SHOP_NUM_LIMIT"/utf8>>,error_desc = <<" 商品数量限制"/utf8>>};
get(15883) ->
#base_error_list{error_code = 15883,error_define = <<"INFO_NOT_ACTIVITY_OPEN"/utf8>>,error_desc = <<" 当前没有抢购活动开放"/utf8>>};
get(15884) ->
#base_error_list{error_code = 15884,error_define = <<"INFO_ACTIVITY_PLAYER_BUY_LIMIT"/utf8>>,error_desc = <<" 您抢购该商品次数已达上限"/utf8>>};
get(15890) ->
#base_error_list{error_code = 15890,error_define = <<"INFO_CHOUJIANG_FREE_NUM_LIMIT"/utf8>>,error_desc = <<" 当前免费抽奖次数用完"/utf8>>};
get(15891) ->
#base_error_list{error_code = 15891,error_define = <<"INFO_CHOUJIANG_FREE_TIME_LIMIT"/utf8>>,error_desc = <<" 进行多次免费抽奖操作，有时间限制"/utf8>>};
get(15900) ->
#base_error_list{error_code = 15900,error_define = <<"INFO_CAREER_FALSE"/utf8>>,error_desc = <<" 职业不符"/utf8>>};
get(15910) ->
#base_error_list{error_code = 15910,error_define = <<"INFO_GOODS_PVP_SHOP_TIMES_OUT"/utf8>>,error_desc = <<" pvp商城刷新次数今日已用完"/utf8>>};
get(15911) ->
#base_error_list{error_code = 15911,error_define = <<"INFO_GOODS_FAIR_SHOP_TIMES_OUT"/utf8>>,error_desc = <<" 公平竞技场商城刷新次数今日已用完"/utf8>>};
get(15912) ->
#base_error_list{error_code = 15912,error_define = <<"INFO_GOODS_CROSS_SHOP_TIMES_OUT"/utf8>>,error_desc = <<" 跨服竞技场商城刷新次数今日已用完"/utf8>>};
get(15913) ->
#base_error_list{error_code = 15913,error_define = <<"INFO_GOODS_LEAGUE_SHOP_TIMES_OUT"/utf8>>,error_desc = <<" 公会商城刷新次数今日已用完"/utf8>>};
get(16001) ->
#base_error_list{error_code = 16001,error_define = <<"ERROR_ONT_FASHION"/utf8>>,error_desc = <<" 你还没有激活这套时装"/utf8>>};
get(17000) ->
#base_error_list{error_code = 17000,error_define = <<"NO_MORE_BOSS"/utf8>>,error_desc = <<"同种boss不能同时开启多个"/utf8>>};
get(17001) ->
#base_error_list{error_code = 17001,error_define = <<"BOSS_INFO_NOT_FOUND"/utf8>>,error_desc = <<"boss数据没有找到"/utf8>>};
get(17002) ->
#base_error_list{error_code = 17002,error_define = <<"INFO_BOSS_NOT_IN_TIME"/utf8>>,error_desc = <<"不在boss有效时间内"/utf8>>};
get(17003) ->
#base_error_list{error_code = 17003,error_define = <<"INFO_BOSS_MAX_COUNT"/utf8>>,error_desc = <<"该boss挑战人数已达到上限"/utf8>>};
get(17010) ->
#base_error_list{error_code = 17010,error_define = <<"OPEN_BOSS_FAIL"/utf8>>,error_desc = <<"boss开启失败"/utf8>>};
get(17011) ->
#base_error_list{error_code = 17011,error_define = <<"INFO_OPEN_BOSS_FULL_TODAY"/utf8>>,error_desc = <<"该boss今天开启次数已用完"/utf8>>};
get(17012) ->
#base_error_list{error_code = 17012,error_define = <<"INFO_OPEN_BOSS_FULL_CUR_HOUR"/utf8>>,error_desc = <<"该boss当前小时开启次数已用完"/utf8>>};
get(17013) ->
#base_error_list{error_code = 17013,error_define = <<"BOSS_IS_KILLED"/utf8>>,error_desc = <<"该boss已经阵亡"/utf8>>};
get(17014) ->
#base_error_list{error_code = 17014,error_define = <<"INFO_BOSS_OPEN_NOT_VALID_TIME"/utf8>>,error_desc = <<"不在boss开启时间"/utf8>>};
get(17015) ->
#base_error_list{error_code = 17015,error_define = <<"INFO_BOSS_OPEN_NOT_VALID"/utf8>>,error_desc = <<"当前不能开启Boss"/utf8>>};
get(19000) ->
#base_error_list{error_code = 19000,error_define = <<"INFO_MAIL_SEND_SUCCESS"/utf8>>,error_desc = <<" 邮件发送成功"/utf8>>};
get(19001) ->
#base_error_list{error_code = 19001,error_define = <<"INFO_MAIL_SEND_FAILED"/utf8>>,error_desc = <<" 邮件发送失败"/utf8>>};
get(19002) ->
#base_error_list{error_code = 19002,error_define = <<"INFO_MAIL_WRONG_TITLE"/utf8>>,error_desc = <<" 标题不合法（非法字符/长度超限），发送失败"/utf8>>};
get(19003) ->
#base_error_list{error_code = 19003,error_define = <<"INFO_MAIL_WRONG_CONTENT"/utf8>>,error_desc = <<" 内容不合法（非法字符/长度超限），发送失败"/utf8>>};
get(19004) ->
#base_error_list{error_code = 19004,error_define = <<"INFO_MAIL_WRONG_RECEIVER"/utf8>>,error_desc = <<" 无法找到收件人，发送失败"/utf8>>};
get(19005) ->
#base_error_list{error_code = 19005,error_define = <<"INFO_MAIL_FULL_OF_RECEIVER"/utf8>>,error_desc = <<" 对方邮箱已满，发送失败"/utf8>>};
get(19006) ->
#base_error_list{error_code = 19006,error_define = <<"INFO_MAIL_WRONG_ATTATCH_FOR_MULTI_SEND"/utf8>>,error_desc = <<" 群发邮件不可发送附件"/utf8>>};
get(19007) ->
#base_error_list{error_code = 19007,error_define = <<"INFO_MAIL_WRONG_ATTATCH"/utf8>>,error_desc = <<" 错误的附件信息"/utf8>>};
get(19008) ->
#base_error_list{error_code = 19008,error_define = <<"INFO_MAIL_WRONG_GOODS_TYPE"/utf8>>,error_desc = <<" 错误的物品信息，获取失败"/utf8>>};
get(19009) ->
#base_error_list{error_code = 19009,error_define = <<"INFO_MAIL_TOO_FREQUENTLY"/utf8>>,error_desc = <<" 邮件发送过于频繁，请稍后再试"/utf8>>};
get(19010) ->
#base_error_list{error_code = 19010,error_define = <<"INFO_MAIL_RECEIVE_SUCCESS"/utf8>>,error_desc = <<" 邮件获取成功"/utf8>>};
get(19011) ->
#base_error_list{error_code = 19011,error_define = <<"INFO_MAIL_RECEIVE_FAILED"/utf8>>,error_desc = <<" 邮件获取失败"/utf8>>};
get(19020) ->
#base_error_list{error_code = 19020,error_define = <<"INFO_MAIL_DELETE_SUCCESS"/utf8>>,error_desc = <<" 邮件删除成功"/utf8>>};
get(19021) ->
#base_error_list{error_code = 19021,error_define = <<"INFO_MAIL_DELETE_FAILED"/utf8>>,error_desc = <<" 邮件删除失败"/utf8>>};
get(19030) ->
#base_error_list{error_code = 19030,error_define = <<"INFO_MAIL_ATTATCH_GET_SUCCESS"/utf8>>,error_desc = <<" 邮件附件获取成功"/utf8>>};
get(19031) ->
#base_error_list{error_code = 19031,error_define = <<"INFO_MAIL_ATTATCH_GET_FAILED"/utf8>>,error_desc = <<" 邮件附件获取失败"/utf8>>};
get(19040) ->
#base_error_list{error_code = 19040,error_define = <<"INFO_MAIL_NOT_FOUND"/utf8>>,error_desc = <<" 没有该邮件"/utf8>>};
get(22100) ->
#base_error_list{error_code = 22100,error_define = <<"INFO_PARTNER_FIGHT_SELF"/utf8>>,error_desc = <<" 不能单挑自己"/utf8>>};
get(22101) ->
#base_error_list{error_code = 22101,error_define = <<"INFO_PARTNER_FIGHT_CAREER_LIMIT"/utf8>>,error_desc = <<" 武将职业不符"/utf8>>};
get(23000) ->
#base_error_list{error_code = 23000,error_define = <<"INFO_ARENA_ERROR_RANK_INFO"/utf8>>,error_desc = <<" 排行榜信息错误"/utf8>>};
get(23001) ->
#base_error_list{error_code = 23001,error_define = <<"INFO_ARENA_SERVER_ERROR"/utf8>>,error_desc = <<" 排行榜进程错误"/utf8>>};
get(23002) ->
#base_error_list{error_code = 23002,error_define = <<"INFO_ARENA_CHALLENGE_TIMES_LIMIT"/utf8>>,error_desc = <<" 挑战次数已用光"/utf8>>};
get(23003) ->
#base_error_list{error_code = 23003,error_define = <<"INFO_ARENA_BUY_TIMES_LIMIT"/utf8>>,error_desc = <<" 可购买的次数已用光"/utf8>>};
get(23500) ->
#base_error_list{error_code = 23500,error_define = <<"INFO_CHALLENGE_NOT_TIME"/utf8>>,error_desc = <<"没有在挑战时间内"/utf8>>};
get(23501) ->
#base_error_list{error_code = 23501,error_define = <<"INFO_CHALLENGE_SELF_BUSY"/utf8>>,error_desc = <<"你正在战斗中，请稍后重试"/utf8>>};
get(23502) ->
#base_error_list{error_code = 23502,error_define = <<"INFO_CHALLENGE_TAR_BUSY"/utf8>>,error_desc = <<"目标正在和别人挑战，请稍后重试"/utf8>>};
get(23503) ->
#base_error_list{error_code = 23503,error_define = <<"INFO_CHALLENGE_NOT_FOUND"/utf8>>,error_desc = <<" 未找到挑战信息"/utf8>>};
get(23504) ->
#base_error_list{error_code = 23504,error_define = <<"INFO_PVP_ISLAND_NOT_FOUND"/utf8>>,error_desc = <<" 攻击的海岛信息未找到"/utf8>>};
get(23505) ->
#base_error_list{error_code = 23505,error_define = <<"INFO_CANT_ATTACK_SELF"/utf8>>,error_desc = <<" 不能攻击已经占领的海岛"/utf8>>};
get(30000) ->
#base_error_list{error_code = 30000,error_define = <<"INFO_TASK_FULL"/utf8>>,error_desc = <<" 任务已满"/utf8>>};
get(30001) ->
#base_error_list{error_code = 30001,error_define = <<"INFO_TASK_UNKNOWN_TASK"/utf8>>,error_desc = <<" 未找到该任务数据"/utf8>>};
get(30002) ->
#base_error_list{error_code = 30002,error_define = <<"ERROR_TASK_SYSTEM_ERROR"/utf8>>,error_desc = <<" 系统错误，无法进行此操作"/utf8>>};
get(30003) ->
#base_error_list{error_code = 30003,error_define = <<"ERROR_TASK_NOT_EXIST"/utf8>>,error_desc = <<" 任务数据不存在，无法进行此操作"/utf8>>};
get(30004) ->
#base_error_list{error_code = 30004,error_define = <<"ERROR_TASK_ALREADY_ACCEPTED"/utf8>>,error_desc = <<" 任务已经领取"/utf8>>};
get(30005) ->
#base_error_list{error_code = 30005,error_define = <<"ERROR_TASK_PLAYER_LV_TOO_LOW"/utf8>>,error_desc = <<" 等级不足，无法领取"/utf8>>};
get(30006) ->
#base_error_list{error_code = 30006,error_define = <<"ERROR_TASK_PLAYER_LV_TOO_HIGH"/utf8>>,error_desc = <<" 等级过高，无法领取"/utf8>>};
get(30007) ->
#base_error_list{error_code = 30007,error_define = <<"ERROR_TASK_NOT_OPEN_TIME"/utf8>>,error_desc = <<" 任务还没开放"/utf8>>};
get(30008) ->
#base_error_list{error_code = 30008,error_define = <<"ERROR_TASK_INVALID_PLAYER_CAREER"/utf8>>,error_desc = <<" 玩家职业不符，无法领取"/utf8>>};
get(30009) ->
#base_error_list{error_code = 30009,error_define = <<"ERROR_TASK_PREV_NOT_DELIVERED"/utf8>>,error_desc = <<" 前置任务还未完成，无法领取"/utf8>>};
get(30010) ->
#base_error_list{error_code = 30010,error_define = <<"ERROR_TASK_ALREADY_DELIVERED"/utf8>>,error_desc = <<" 任务已经完成"/utf8>>};
get(30011) ->
#base_error_list{error_code = 30011,error_define = <<"ERROR_TASK_DAILY_TIMES_OVER"/utf8>>,error_desc = <<" 日常任务次数已经使用完毕"/utf8>>};
get(30012) ->
#base_error_list{error_code = 30012,error_define = <<"ERROR_TASK_NO_ENOUGH_CELLS"/utf8>>,error_desc = <<" 背包空间不足，无法进行此操作"/utf8>>};
get(30013) ->
#base_error_list{error_code = 30013,error_define = <<"ERROR_TASK_NOT_IN_GUILD"/utf8>>,error_desc = <<" 未在帮派中，无法进行此操作"/utf8>>};
get(30014) ->
#base_error_list{error_code = 30014,error_define = <<"ERROR_TASK_NOT_ACCEPTED"/utf8>>,error_desc = <<" 任务还未领取，无法进行此操作"/utf8>>};
get(30015) ->
#base_error_list{error_code = 30015,error_define = <<"ERROR_TASK_CONTENT_NOT_DONE"/utf8>>,error_desc = <<" 任务还未完成，无法进行此操作"/utf8>>};
get(30016) ->
#base_error_list{error_code = 30016,error_define = <<"ERROR_TASK_NOT_GOODS_TRIGGER_TASK"/utf8>>,error_desc = <<" 非道具触发类任务，无法进行此操作"/utf8>>};
get(30017) ->
#base_error_list{error_code = 30017,error_define = <<"ERROR_TASK_CANNOT_ACCEPTED"/utf8>>,error_desc = <<" 任务领取失败"/utf8>>};
get(30018) ->
#base_error_list{error_code = 30018,error_define = <<"INFO_TASK_CAN_NOT_GIVE_UP"/utf8>>,error_desc = <<" 任务不能放弃"/utf8>>};
get(31001) ->
#base_error_list{error_code = 31001,error_define = <<"INFO_KILO_RDIE_NO_FOUND"/utf8>>,error_desc = <<" 过关斩将数据未找到"/utf8>>};
get(31002) ->
#base_error_list{error_code = 31002,error_define = <<"INFO_CHEST_REWARD_CNT_LIMIT"/utf8>>,error_desc = <<" 不能再开启更多宝箱"/utf8>>};
get(31003) ->
#base_error_list{error_code = 31003,error_define = <<"INFO_KILO_RIDE_QUICK_PASS_LIMIT"/utf8>>,error_desc = <<" 今天已经不能不快速通关了"/utf8>>};
get(31004) ->
#base_error_list{error_code = 31004,error_define = <<"INFO_KILO_RIDE_INIT_FAILED"/utf8>>,error_desc = <<" 过关斩将数据初始化失败"/utf8>>};
get(31005) ->
#base_error_list{error_code = 31005,error_define = <<"INFO_KILO_RIDE_CALL_NPC"/utf8>>,error_desc = <<" 已召唤过NPC"/utf8>>};
get(31006) ->
#base_error_list{error_code = 31006,error_define = <<"INFO_KILO_RDIE_NPC_NO_FOUND"/utf8>>,error_desc = <<" 过关斩将NPC数据未找到"/utf8>>};
get(31007) ->
#base_error_list{error_code = 31007,error_define = <<"INFO_KILO_RDIE_STAR_NOT_ENOUGH"/utf8>>,error_desc = <<" 未达到指定的星级"/utf8>>};
get(32001) ->
#base_error_list{error_code = 32001,error_define = <<"INFO_NOT_GOT_ACHIEVE"/utf8>>,error_desc = <<" 没有获得这个成就，不能领取奖励"/utf8>>};
get(32002) ->
#base_error_list{error_code = 32002,error_define = <<"INFO_ACHIEVE_CONF_ERROR"/utf8>>,error_desc = <<" 获取成就数据失败"/utf8>>};
get(32003) ->
#base_error_list{error_code = 32003,error_define = <<"INFO_RECEIVE_ACHIEVE_REWARD_ERROR"/utf8>>,error_desc = <<" 领取奖励失败"/utf8>>};
get(32004) ->
#base_error_list{error_code = 32004,error_define = <<"INFO_RECEIVE_ACHIEVE_REWARD_SUCCESS"/utf8>>,error_desc = <<" 领取奖励成功"/utf8>>};
get(32005) ->
#base_error_list{error_code = 32005,error_define = <<"INFO_RECEIVED_ACHIEVE_REWARD"/utf8>>,error_desc = <<" 已经领取奖励，不可再领取"/utf8>>};
get(34001) ->
#base_error_list{error_code = 34001,error_define = <<"ERROR_TYPE_ENPTY"/utf8>>,error_desc = <<" 没有该类型的扭蛋"/utf8>>};
get(34002) ->
#base_error_list{error_code = 34002,error_define = <<"ERROR_TWIST_EGG_LIMIT"/utf8>>,error_desc = <<" 超出连续扭蛋上限"/utf8>>};
get(34003) ->
#base_error_list{error_code = 34003,error_define = <<"ERROR_ONT_FRIENDPOINT"/utf8>>,error_desc = <<" 友情点不足，不能扭蛋"/utf8>>};
get(34004) ->
#base_error_list{error_code = 34004,error_define = <<"ERROR_ONT_DIAMOND"/utf8>>,error_desc = <<" 砖石不足，不能扭蛋"/utf8>>};
get(40000) ->
#base_error_list{error_code = 40000,error_define = <<"INFO_LEAGUE_IN_LEAGUE"/utf8>>,error_desc = <<"你已经在工会里面"/utf8>>};
get(40001) ->
#base_error_list{error_code = 40001,error_define = <<"INFO_LEAGUE_ADD_LEAGUE_LIMIT"/utf8>>,error_desc = <<"今天不能再加入工会了哦"/utf8>>};
get(40002) ->
#base_error_list{error_code = 40002,error_define = <<"INFO_LEAGUE_ADD_ABILITY_LIMIT"/utf8>>,error_desc = <<"战斗力不足，不能加入工会"/utf8>>};
get(40003) ->
#base_error_list{error_code = 40003,error_define = <<"INFO_LEAGUE_ADD_NUM_LIMIT"/utf8>>,error_desc = <<"工会人数已满"/utf8>>};
get(40004) ->
#base_error_list{error_code = 40004,error_define = <<"INFO_LEAGUE_NOT_MEMBER"/utf8>>,error_desc = <<"非工会成员不能操作"/utf8>>};
get(40005) ->
#base_error_list{error_code = 40005,error_define = <<"INFO_LEAGUE_NOT_ENOUGH_POWER"/utf8>>,error_desc = <<"权限不足"/utf8>>};
get(40006) ->
#base_error_list{error_code = 40006,error_define = <<"INFO_LEAGUE_TAGET_INFO_CHANGE"/utf8>>,error_desc = <<"目标成员信息已经发生变化"/utf8>>};
get(40007) ->
#base_error_list{error_code = 40007,error_define = <<"INFO_LEAGUE_BOSS_CANNOT_LEAVE"/utf8>>,error_desc = <<"会长不能离开工会，请先转交权限"/utf8>>};
get(40008) ->
#base_error_list{error_code = 40008,error_define = <<"INFO_LEAGUE_LIMIT_NAME"/utf8>>,error_desc = <<"工会名字含有敏感词汇"/utf8>>};
get(40009) ->
#base_error_list{error_code = 40009,error_define = <<"INFO_LEAGUE_TAR_SELF"/utf8>>,error_desc = <<"不能以自己为对象"/utf8>>};
get(40010) ->
#base_error_list{error_code = 40010,error_define = <<"INFO_LEAGUE_LONG_NAME"/utf8>>,error_desc = <<"工会名字过长"/utf8>>};
get(40011) ->
#base_error_list{error_code = 40011,error_define = <<"INFO_LEAGUE_LONG_DER"/utf8>>,error_desc = <<"宣言字数过多"/utf8>>};
get(40012) ->
#base_error_list{error_code = 40012,error_define = <<"INFO_LEAGUE_GET_LIST_ERROR"/utf8>>,error_desc = <<"获取工会列表数据异常"/utf8>>};
get(40013) ->
#base_error_list{error_code = 40013,error_define = <<"INFO_LEAGUE_TITLE_FULL"/utf8>>,error_desc = <<"该职位人数达到上限"/utf8>>};
get(40014) ->
#base_error_list{error_code = 40014,error_define = <<"INFO_LEAGUE_MEMBRE_NUM_NO_ENOUGH"/utf8>>,error_desc = <<"公会人数不足"/utf8>>};
get(40015) ->
#base_error_list{error_code = 40015,error_define = <<"INFO_LEAGUE_GOLD_NO_ENOUGH"/utf8>>,error_desc = <<"公会礼金不足"/utf8>>};
get(40016) ->
#base_error_list{error_code = 40016,error_define = <<"INFO_LEAGUE_NOT_BOSS"/utf8>>,error_desc = <<"不是会长"/utf8>>};
get(40017) ->
#base_error_list{error_code = 40017,error_define = <<"INFO_LEAGUE_NOT_FIND_GIFTS"/utf8>>,error_desc = <<"工会中没有礼包"/utf8>>};
get(40018) ->
#base_error_list{error_code = 40018,error_define = <<"INFO_LEAGUE_LEVEL_LIMIT"/utf8>>,error_desc = <<" 公会等级限制"/utf8>>};
get(40100) ->
#base_error_list{error_code = 40100,error_define = <<"INFO_PAY_GIFTS_NOT_FOUND"/utf8>>,error_desc = <<"没有该礼包"/utf8>>};
get(40101) ->
#base_error_list{error_code = 40101,error_define = <<"INFO_PAY_GIFTS_TODAY_SEND"/utf8>>,error_desc = <<"该礼包今天已经派发过了"/utf8>>};
get(40102) ->
#base_error_list{error_code = 40102,error_define = <<"INFO_PAY_GIFTS_OVER_TIME"/utf8>>,error_desc = <<"该礼包已经过期"/utf8>>};
get(40103) ->
#base_error_list{error_code = 40103,error_define = <<"INFO_LEAGUE_GIFTS_RECV"/utf8>>,error_desc = <<"你已经领过这个土豪发的同批次礼包了"/utf8>>};
get(40104) ->
#base_error_list{error_code = 40104,error_define = <<"INFO_LEAGUE_GIFTS_NUM_LIMIT"/utf8>>,error_desc = <<"该礼包已经被抢光了,下次早点来吧"/utf8>>};
get(40105) ->
#base_error_list{error_code = 40105,error_define = <<"INFO_PAY_GIFTS_SEND_OVER"/utf8>>,error_desc = <<"该礼包已经发完"/utf8>>};
get(40106) ->
#base_error_list{error_code = 40106,error_define = <<"INFO_PAY_GIFTS_NOT_ENOUGH"/utf8>>,error_desc = <<"今日派发礼包数量不足"/utf8>>};
get(40107) ->
#base_error_list{error_code = 40107,error_define = <<"INFO_PAY_GIFTS_APPOINT_SAME"/utf8>>,error_desc = <<"该批次礼包已指定发过该玩家"/utf8>>};
get(40108) ->
#base_error_list{error_code = 40108,error_define = <<"INFO_PAY_GIFTS_RECV_FALSE"/utf8>>,error_desc = <<"玩家已经领过该批次的红包"/utf8>>};
get(40109) ->
#base_error_list{error_code = 40109,error_define = <<"INFO_PAY_GIFTS_NOT_REQUEST"/utf8>>,error_desc = <<"没有请求信息"/utf8>>};
get(40200) ->
#base_error_list{error_code = 40200,error_define = <<"INFO_PAY_GIFTS_SEND_NOT_SELF"/utf8>>,error_desc = <<"玩家不可给自己发红包"/utf8>>};
get(40201) ->
#base_error_list{error_code = 40201,error_define = <<"INFO_BAG_GIFTS_OVER_TIME"/utf8>>,error_desc = <<"该礼包已经过期,系统自动销毁"/utf8>>};
get(40300) ->
#base_error_list{error_code = 40300,error_define = <<"INFO_LEAGUE_ALREADY_APPLY"/utf8>>,error_desc = <<"本月已报名参战, 等待下一轮匹配参战"/utf8>>};
get(40301) ->
#base_error_list{error_code = 40301,error_define = <<"INFO_LEAGUE_NOT_APPLY"/utf8>>,error_desc = <<"暂时没有资格参战, 如未报名, 请先报名"/utf8>>};
get(40302) ->
#base_error_list{error_code = 40302,error_define = <<"INFO_LEAGUE_APPLY_ERROR"/utf8>>,error_desc = <<"暂时没有资格参战, 如未报名, 请先报名"/utf8>>};
get(40303) ->
#base_error_list{error_code = 40303,error_define = <<"INFO_LEAGUE_NOT_ENEMY"/utf8>>,error_desc = <<"本轮作战幸运轮空, 将获取幸运大奖"/utf8>>};
get(40304) ->
#base_error_list{error_code = 40304,error_define = <<"INFO_LEAGUE_GROUP_ERROR"/utf8>>,error_desc = <<" 申请段位越界"/utf8>>};
get(40305) ->
#base_error_list{error_code = 40305,error_define = <<"INFO_CHALLENGE_ERROR_MEMBER"/utf8>>,error_desc = <<" 挑战非敌方公会成员"/utf8>>};
get(40306) ->
#base_error_list{error_code = 40306,error_define = <<"INFO_NOT_CHALLENGE_RECORD"/utf8>>,error_desc = <<" 没有挑战记录"/utf8>>};
get(40307) ->
#base_error_list{error_code = 40307,error_define = <<"INFO_ENEMY_LEAGUE_POINT_ERROR"/utf8>>,error_desc = <<" 敌方工会据点有错"/utf8>>};
get(40308) ->
#base_error_list{error_code = 40308,error_define = <<"INFO_LEAGUE_POINT_ERROR"/utf8>>,error_desc = <<" 我方工会据点有错"/utf8>>};
get(40309) ->
#base_error_list{error_code = 40309,error_define = <<"INFO_LEAGUE_APPOINT_ERROR"/utf8>>,error_desc = <<" 会员已经被指派到其他据点"/utf8>>};
get(40310) ->
#base_error_list{error_code = 40310,error_define = <<"INFO_LEAGUE_NOT_POINT"/utf8>>,error_desc = <<" 没有该据点"/utf8>>};
get(40311) ->
#base_error_list{error_code = 40311,error_define = <<"INFO_LEAGUE_POINT_ALREADY_OCC"/utf8>>,error_desc = <<" 据点已经被其他玩家占领"/utf8>>};
get(40312) ->
#base_error_list{error_code = 40312,error_define = <<"INFO_FIGHT_OWN_POINT_ERROR"/utf8>>,error_desc = <<" 不可攻击我方公会据点"/utf8>>};
get(40313) ->
#base_error_list{error_code = 40313,error_define = <<"INFO_LEAGUE_POINT_ATTACK"/utf8>>,error_desc = <<" 据点正在被其他玩家攻击"/utf8>>};
get(40314) ->
#base_error_list{error_code = 40314,error_define = <<"INFO_LEAGUE_ABILITY_ENOUGH"/utf8>>,error_desc = <<"挑战战斗力不足"/utf8>>};
get(40315) ->
#base_error_list{error_code = 40315,error_define = <<"INFO_CHALLENGE_POINT_NUM_LIMIT"/utf8>>,error_desc = <<" 你已经挑战过据点, 无法再挑战"/utf8>>};
get(40316) ->
#base_error_list{error_code = 40316,error_define = <<"INFO_CHALLENGE_POINT_OVER_TIME"/utf8>>,error_desc = <<" 挑战该据点超时"/utf8>>};
get(40317) ->
#base_error_list{error_code = 40317,error_define = <<"INFO_LEAGUE_APPLY_MEMBER_NUM_LIMIT"/utf8>>,error_desc = <<" 工会战报名, 会员数量不够, 去拉人入会吧"/utf8>>};
get(40318) ->
#base_error_list{error_code = 40318,error_define = <<"INFO_LEAGUE_CHALLENGE_POINT_SAME"/utf8>>,error_desc = <<" 同一据点不可重复挑战"/utf8>>};
get(40319) ->
#base_error_list{error_code = 40319,error_define = <<"INFO_MEMBRE_CHALLENGE_NUM_LIMIT"/utf8>>,error_desc = <<" 挑战次数不足"/utf8>>};
get(40320) ->
#base_error_list{error_code = 40320,error_define = <<"INFO_LEAGUE_ENEMY_GRAP_NUM_LIMIT"/utf8>>,error_desc = <<" 敌人接受挑战次数用完"/utf8>>};
get(40321) ->
#base_error_list{error_code = 40321,error_define = <<"INFO_CHALLENGE_ENEMY_OVER_TIME"/utf8>>,error_desc = <<" 挑战敌方玩家超时"/utf8>>};
get(40322) ->
#base_error_list{error_code = 40322,error_define = <<"INFO_NOT_REPEAT_CHALLENGE_ENEMY"/utf8>>,error_desc = <<" 不可重复挑战敌方玩家"/utf8>>};
get(40323) ->
#base_error_list{error_code = 40323,error_define = <<"INFO_LEAGUE_CHALLENGE_RECORD_ERROR"/utf8>>,error_desc = <<" 公会单人挑战记录出错"/utf8>>};
get(40324) ->
#base_error_list{error_code = 40324,error_define = <<"INFO_LEAGUE_CHALLENGE_TIMES_LIMIT"/utf8>>,error_desc = <<" 挑战次数限制"/utf8>>};
get(40325) ->
#base_error_list{error_code = 40325,error_define = <<"INFO_LEAGUE_FIGHT_NOT_RANK"/utf8>>,error_desc = <<" 当前公会战没有排名"/utf8>>};
get(40326) ->
#base_error_list{error_code = 40326,error_define = <<"INFO_LEAGUE_FIGHT_NOT_START"/utf8>>,error_desc = <<" 掠夺战准备时段, 军团可安排据点守卫"/utf8>>};
get(40327) ->
#base_error_list{error_code = 40327,error_define = <<"INFO_LEAGUE_FIGHT_START"/utf8>>,error_desc = <<" 掠夺战已开始, 不能调整据点"/utf8>>};
get(40328) ->
#base_error_list{error_code = 40328,error_define = <<"INFO_LEAGUE_FIGHT_STARTING_NOT_LEAVE"/utf8>>,error_desc = <<" 掠夺战已开始, 当前不能离开公会"/utf8>>};
get(40329) ->
#base_error_list{error_code = 40329,error_define = <<"INFO_LEAGUE_MEMBRE_HAVE_FIGHT_RECORD"/utf8>>,error_desc = <<" 本轮掠夺战结束方可加入其他公会"/utf8>>};
get(40400) ->
#base_error_list{error_code = 40400,error_define = <<"INFO_LEAGUE_NOT_JOINT_FIGHT"/utf8>>,error_desc = <<" 您还未加入跨服军团战"/utf8>>};
get(40401) ->
#base_error_list{error_code = 40401,error_define = <<"INFO_LEAGUE_ENEMY_NOT_JOIN"/utf8>>,error_desc = <<" 您要挑战的军团未加入战役"/utf8>>};
get(40402) ->
#base_error_list{error_code = 40402,error_define = <<"INFO_LEAGUE_BAD_ENEMY"/utf8>>,error_desc = <<" 您不能挑战非对战军团"/utf8>>};
get(40403) ->
#base_error_list{error_code = 40403,error_define = <<"INFO_LEAGUE_DEFEND_POINT_NOT_FOUND"/utf8>>,error_desc = <<" 军团据点未找到"/utf8>>};
get(40404) ->
#base_error_list{error_code = 40404,error_define = <<"INFO_LEAGUE_DEFEND_POINT_STATUS_ERROR"/utf8>>,error_desc = <<" 该据点状态不可挑战"/utf8>>};
get(40500) ->
#base_error_list{error_code = 40500,error_define = <<"INFO_G17_GUILD_BAD_PARAM"/utf8>>,error_desc = <<" 参数错误"/utf8>>};
get(40501) ->
#base_error_list{error_code = 40501,error_define = <<"INFO_G17_GUILD_TIMEOUT"/utf8>>,error_desc = <<" 查询时间过期"/utf8>>};
get(40502) ->
#base_error_list{error_code = 40502,error_define = <<"INFO_G17_GUILD_BAD_SIGN"/utf8>>,error_desc = <<" 签名错误"/utf8>>};
get(40503) ->
#base_error_list{error_code = 40503,error_define = <<"INFO_G17_GUILD_NOT_GUILD_MEMBER"/utf8>>,error_desc = <<" 非公会成员"/utf8>>};
get(40504) ->
#base_error_list{error_code = 40504,error_define = <<"INFO_G17_GUILD_LEADER_CANT_QUIT"/utf8>>,error_desc = <<" 会长不能退出公会"/utf8>>};
get(40505) ->
#base_error_list{error_code = 40505,error_define = <<"INFO_G17_GUILD_ERROR_QIUT"/utf8>>,error_desc = <<" 退出失败"/utf8>>};
get(40506) ->
#base_error_list{error_code = 40506,error_define = <<"INFO_G17_GUILD_SYSTEM_ERROR"/utf8>>,error_desc = <<" 公会平台系统错误"/utf8>>};
get(40507) ->
#base_error_list{error_code = 40507,error_define = <<"INFO_G17_GUILD_BAND_TIME"/utf8>>,error_desc = <<" 公会在封禁期间内无法接收新成员"/utf8>>};
get(40508) ->
#base_error_list{error_code = 40508,error_define = <<"INFO_G17_GUILD_JION_FAILED"/utf8>>,error_desc = <<" 加入失败"/utf8>>};
get(40509) ->
#base_error_list{error_code = 40509,error_define = <<"INFO_G17_GUILD_GUILD_NOTFOUND"/utf8>>,error_desc = <<" 公会不存在"/utf8>>};
get(40510) ->
#base_error_list{error_code = 40510,error_define = <<"INFO_G17_GUILD_ALEADY_JOIN"/utf8>>,error_desc = <<" 已经加入其它公会，不能再申请或创建公会"/utf8>>};
get(40511) ->
#base_error_list{error_code = 40511,error_define = <<"INFO_G17_GUILD_ALEADY_APPLY"/utf8>>,error_desc = <<" 已经提交过申请，请不能重复提交"/utf8>>};
get(40512) ->
#base_error_list{error_code = 40512,error_define = <<"INFO_G17_GUILD_APPLY_FAILED"/utf8>>,error_desc = <<" 申请加入失败"/utf8>>};
get(40513) ->
#base_error_list{error_code = 40513,error_define = <<"INFO_G17_GUILD_USER_NOTFOUND"/utf8>>,error_desc = <<" 用户不存在"/utf8>>};
get(40514) ->
#base_error_list{error_code = 40514,error_define = <<"INFO_G17_GUILD_NAME_EMPTY"/utf8>>,error_desc = <<" 公会名为空"/utf8>>};
get(40515) ->
#base_error_list{error_code = 40515,error_define = <<"INFO_G17_GUILD_NAME_LEN_ERROR"/utf8>>,error_desc = <<" 公会名长度不对"/utf8>>};
get(40516) ->
#base_error_list{error_code = 40516,error_define = <<"INFO_G17_GUILD_NAME_SPEICAL"/utf8>>,error_desc = <<" 公会名中含有非法字"/utf8>>};
get(40517) ->
#base_error_list{error_code = 40517,error_define = <<"INFO_G17_GUILD_NAME_USED"/utf8>>,error_desc = <<" 公会名已经被使用"/utf8>>};
get(40518) ->
#base_error_list{error_code = 40518,error_define = <<"INFO_G17_GUILD_CREATE_FAILED"/utf8>>,error_desc = <<" 创建公会失败"/utf8>>};
get(40519) ->
#base_error_list{error_code = 40519,error_define = <<"INFO_G17_GUILD_QUIT_FAILED"/utf8>>,error_desc = <<" 退出公会失败"/utf8>>};
get(40520) ->
#base_error_list{error_code = 40520,error_define = <<"INFO_G17_GUILD_LEADER_NOT_JOIN"/utf8>>,error_desc = <<" 帮主未加入公会"/utf8>>};
get(40521) ->
#base_error_list{error_code = 40521,error_define = <<"INFO_G17_GUILD_JOIN_NOT_SAME"/utf8>>,error_desc = <<" 不能加入与军团长不一致的公会"/utf8>>};
get(44001) ->
#base_error_list{error_code = 44001,error_define = <<"INFO_CAMP_ALEADY_USING"/utf8>>,error_desc = <<" 该阵法已启用"/utf8>>};
get(44002) ->
#base_error_list{error_code = 44002,error_define = <<"INFO_CAMP_HAVE_NOT_LEARN"/utf8>>,error_desc = <<" 该阵法暂未学习"/utf8>>};
get(44003) ->
#base_error_list{error_code = 44003,error_define = <<"INFO_CAMP_NOT_FOUND"/utf8>>,error_desc = <<" 编成数据未找到"/utf8>>};
get(44004) ->
#base_error_list{error_code = 44004,error_define = <<"INFO_CAMP_POSITION_CHECK_FAILED"/utf8>>,error_desc = <<" 检验编成失败，请检查阵法设置与COST值是否已超上限"/utf8>>};
get(44005) ->
#base_error_list{error_code = 44005,error_define = <<"INFO_BEAST_CAMP_NO_LEARN"/utf8>>,error_desc = <<" 阵法还未学习"/utf8>>};
get(45000) ->
#base_error_list{error_code = 45000,error_define = <<"INFO_PARTNER_RECRUIT_SUCCESS"/utf8>>,error_desc = <<" 伙伴招募成功"/utf8>>};
get(45001) ->
#base_error_list{error_code = 45001,error_define = <<"INFO_PARTNER_RECRUIT_FAILED"/utf8>>,error_desc = <<" 伙伴招募失败"/utf8>>};
get(45002) ->
#base_error_list{error_code = 45002,error_define = <<"INFO_PARTNER_RECRUIT_TEAM_EXCEED"/utf8>>,error_desc = <<" 队伍人数已达上限，无法招募"/utf8>>};
get(45003) ->
#base_error_list{error_code = 45003,error_define = <<"INFO_PARTNER_RECRUIT_WRONG_PARTNER"/utf8>>,error_desc = <<" 错误的武将数据，无法招募"/utf8>>};
get(45004) ->
#base_error_list{error_code = 45004,error_define = <<"INFO_PARTNER_ALEADY_GOT"/utf8>>,error_desc = <<" 该武将已在队伍中"/utf8>>};
get(45005) ->
#base_error_list{error_code = 45005,error_define = <<"INFO_PARTNER_NOT_FOUND"/utf8>>,error_desc = <<" 武将获取失败，无法进行此操作"/utf8>>};
get(45006) ->
#base_error_list{error_code = 45006,error_define = <<"INFO_PARTNER_NOT_ENOUGH_SOUL"/utf8>>,error_desc = <<" 武将武魂不足，无法进行此操作"/utf8>>};
get(45007) ->
#base_error_list{error_code = 45007,error_define = <<"INFO_PARTNER_QUALITY_TOO_LOW"/utf8>>,error_desc = <<" 目标武将品质较低，无法进行此操作"/utf8>>};
get(45008) ->
#base_error_list{error_code = 45008,error_define = <<"INFO_PARTNER_CANNOT_BE_RECRUITED"/utf8>>,error_desc = <<" 该武将还不在招募列表中，无法招募"/utf8>>};
get(45009) ->
#base_error_list{error_code = 45009,error_define = <<"INFO_PARTNER_HAVE_BE_RECRUITED"/utf8>>,error_desc = <<" 已经招募过该武将了，无法再招募"/utf8>>};
get(45010) ->
#base_error_list{error_code = 45010,error_define = <<"INFO_RANK_UPGRADE_SUCCESS"/utf8>>,error_desc = <<" 军衔进阶成功"/utf8>>};
get(45011) ->
#base_error_list{error_code = 45011,error_define = <<"INFO_RANK_UPGRADE_FAILED"/utf8>>,error_desc = <<" 军衔进阶失败"/utf8>>};
get(45012) ->
#base_error_list{error_code = 45012,error_define = <<"INFO_RANK_INIT_INFO_NOT_FOUND"/utf8>>,error_desc = <<" 初始军衔数据获取失败"/utf8>>};
get(45020) ->
#base_error_list{error_code = 45020,error_define = <<"INFO_RANK_UPGRADE_CHECK_SUCCESS"/utf8>>,error_desc = <<" 当前有军衔可进阶"/utf8>>};
get(45021) ->
#base_error_list{error_code = 45021,error_define = <<"INFO_RANK_UPGRADE_CHECK_FAILED"/utf8>>,error_desc = <<" 军衔进阶检测失败"/utf8>>};
get(45022) ->
#base_error_list{error_code = 45022,error_define = <<"INFO_RANK_UPGRADE_PRESTIGE_TOO_LOW"/utf8>>,error_desc = <<" 声望不足，无法进阶"/utf8>>};
get(45023) ->
#base_error_list{error_code = 45023,error_define = <<"INFO_RANK_UPGRADE_LEVEL_TOO_LOW"/utf8>>,error_desc = <<" 等级不足，无法进阶"/utf8>>};
get(45024) ->
#base_error_list{error_code = 45024,error_define = <<"INFO_RANK_UPGRADE_NEXT_NOT_FOUND"/utf8>>,error_desc = <<" 升级军衔未找到，无法进阶"/utf8>>};
get(45030) ->
#base_error_list{error_code = 45030,error_define = <<"INFO_PARTNER_INQUIRE_SUCCESS"/utf8>>,error_desc = <<" 伙伴详细信息查询成功"/utf8>>};
get(45031) ->
#base_error_list{error_code = 45031,error_define = <<"INFO_PARTNER_INQUIRE_FAILED"/utf8>>,error_desc = <<" 伙伴详细信息查询失败"/utf8>>};
get(45032) ->
#base_error_list{error_code = 45032,error_define = <<"INFO_PARTNER_INQUIRE_HERO_EMPTY"/utf8>>,error_desc = <<" 群英传信息为空"/utf8>>};
get(45033) ->
#base_error_list{error_code = 45033,error_define = <<"INFO_PARTNER_NEW_PARTNER_FOR_RECRUIT"/utf8>>,error_desc = <<" 新的伙伴 [%s] 可以招募了"/utf8>>};
get(45034) ->
#base_error_list{error_code = 45034,error_define = <<"INFO_PARTNER_CONVERT_TO_BEYOND_POINT"/utf8>>,error_desc = <<" 由于存在更高品质的伙伴， [%s] 已经转换成 %s 突破点"/utf8>>};
get(45035) ->
#base_error_list{error_code = 45035,error_define = <<"INFO_PARTNER_RECRUIT_SUCCESS_TO_TEAM"/utf8>>,error_desc = <<" 恭喜您成功招募 [%s] ，请到已有武将中查询"/utf8>>};
get(45036) ->
#base_error_list{error_code = 45036,error_define = <<"INFO_PARTNER_RECRUIT_UPGRADE"/utf8>>,error_desc = <<" 恭喜您， [%s] 已经成功进阶"/utf8>>};
get(45037) ->
#base_error_list{error_code = 45037,error_define = <<"INFO_PARTNER_SOUL_PARTNER_IN"/utf8>>,error_desc = <<" 新的伙伴 [%s] 加入队伍"/utf8>>};
get(45038) ->
#base_error_list{error_code = 45038,error_define = <<"INFO_PARTNER_SOUL_PARTNER_CONVERT"/utf8>>,error_desc = <<" 恭喜您获得武将%s · [%s] ，该武将已经自动转换成 %s 将魂（您可以通过将魂来升阶）。"/utf8>>};
get(45040) ->
#base_error_list{error_code = 45040,error_define = <<"INFO_PARTNER_FREE_SUCCESS"/utf8>>,error_desc = <<" 伙伴解散成功"/utf8>>};
get(45041) ->
#base_error_list{error_code = 45041,error_define = <<"INFO_PARTNER_FREE_FAILED"/utf8>>,error_desc = <<" 伙伴解散失败"/utf8>>};
get(45042) ->
#base_error_list{error_code = 45042,error_define = <<"INFO_PARTNER_NOT_IN_TEAM"/utf8>>,error_desc = <<" 伙伴不在队伍中，无法解散"/utf8>>};
get(45050) ->
#base_error_list{error_code = 45050,error_define = <<"INFO_PARTNER_CHEERS_SUCCESS"/utf8>>,error_desc = <<" 酒馆进酒成功"/utf8>>};
get(45051) ->
#base_error_list{error_code = 45051,error_define = <<"INFO_PARTNER_CHEERS_FAILED"/utf8>>,error_desc = <<" 材料不足，酒馆进酒失败"/utf8>>};
get(45052) ->
#base_error_list{error_code = 45052,error_define = <<"INFO_PARTNER_TAVERN_NOT_FOUND"/utf8>>,error_desc = <<" 玩家酒馆数据获取失败，无法进行此操作"/utf8>>};
get(45053) ->
#base_error_list{error_code = 45053,error_define = <<"INFO_PARTNER_CHEERS_NOT_COOLDOWN"/utf8>>,error_desc = <<" 进酒冷却中，请稍后再尝试"/utf8>>};
get(45054) ->
#base_error_list{error_code = 45054,error_define = <<"INFO_PARTNER_CHEERS_TIMES_OUT"/utf8>>,error_desc = <<" 米酒进酒次数已经使用完毕，请明日再试"/utf8>>};
get(45055) ->
#base_error_list{error_code = 45055,error_define = <<"INFO_PARTNER_CHEERS_WRONG_TYPE"/utf8>>,error_desc = <<" 错误的进酒类型，无法进行进酒操作"/utf8>>};
get(45056) ->
#base_error_list{error_code = 45056,error_define = <<"INFO_PARTNER_BLUE_CHEERS_TIMES_OUT"/utf8>>,error_desc = <<" 汾酒进酒次数已经使用完毕，请明日再试"/utf8>>};
get(45057) ->
#base_error_list{error_code = 45057,error_define = <<"INFO_PARTNER_PURPLE_CHEERS_TIMES_OUT"/utf8>>,error_desc = <<" 杜康进酒次数已经使用完毕，请明日再试"/utf8>>};
get(45060) ->
#base_error_list{error_code = 45060,error_define = <<"INFO_PARTNER_BEYOND_SUCCESS"/utf8>>,error_desc = <<" [%s] 突破成功，武力 + 1，智力 + 1，绝学 + 1"/utf8>>};
get(45061) ->
#base_error_list{error_code = 45061,error_define = <<"INFO_PARTNER_BEYOND_FAILED"/utf8>>,error_desc = <<" 突破失败"/utf8>>};
get(45062) ->
#base_error_list{error_code = 45062,error_define = <<"INFO_PARTNER_NOT_ENOUGH_BEYOND_POINT"/utf8>>,error_desc = <<" 突破点不足"/utf8>>};
get(45070) ->
#base_error_list{error_code = 45070,error_define = <<"INFO_PARTNER_RERECRUIT_SUCCESS"/utf8>>,error_desc = <<" 伙伴归队成功"/utf8>>};
get(45071) ->
#base_error_list{error_code = 45071,error_define = <<"INFO_PARTNER_RERECRUIT_FAILED"/utf8>>,error_desc = <<" 伙伴归队失败"/utf8>>};
get(45072) ->
#base_error_list{error_code = 45072,error_define = <<"INFO_PARTNER_CANNOT_BE_RERECRUIT"/utf8>>,error_desc = <<" 该伙伴不可归队"/utf8>>};
get(45080) ->
#base_error_list{error_code = 45080,error_define = <<"INFO_PARTNER_TRAIN_SUCCESS"/utf8>>,error_desc = <<" [%s] 完成历练，经验 + %s"/utf8>>};
get(45081) ->
#base_error_list{error_code = 45081,error_define = <<"INFO_PARTNER_TRAIN_FAILED"/utf8>>,error_desc = <<" 伙伴历练失败"/utf8>>};
get(45082) ->
#base_error_list{error_code = 45082,error_define = <<"INFO_PARTNER_TRAIN_INFO_NOT_FOUND"/utf8>>,error_desc = <<" 玩家历练数据获取失败"/utf8>>};
get(45083) ->
#base_error_list{error_code = 45083,error_define = <<"INFO_BASE_TRAIN_INFO_NOT_FOUND"/utf8>>,error_desc = <<" 历练场景数据获取失败"/utf8>>};
get(45084) ->
#base_error_list{error_code = 45084,error_define = <<"INFO_PARTNER_WRONG_TRAIN_POSITION"/utf8>>,error_desc = <<" 错误的历练场景信息，无法进行此操作"/utf8>>};
get(45085) ->
#base_error_list{error_code = 45085,error_define = <<"INFO_PARTNER_POSITION_NOT_OPENED"/utf8>>,error_desc = <<" 历练场景未开放，无法进行此操作"/utf8>>};
get(45086) ->
#base_error_list{error_code = 45086,error_define = <<"INFO_PARTNER_TRAIN_NOT_CD"/utf8>>,error_desc = <<" 该历练场景还未冷却，无法进行此操作"/utf8>>};
get(45087) ->
#base_error_list{error_code = 45087,error_define = <<"INFO_PARTNER_TRAIN_TIMES_OUT"/utf8>>,error_desc = <<" 今日的历练次数已经使用完毕"/utf8>>};
get(45088) ->
#base_error_list{error_code = 45088,error_define = <<"INFO_PARTNER_TRAIN_MAX_QUALITY"/utf8>>,error_desc = <<" 历练品质已经是最高了"/utf8>>};
get(45090) ->
#base_error_list{error_code = 45090,error_define = <<"INFO_PARTNER_NEW_TRAIN_SUCCESS"/utf8>>,error_desc = <<" 开启新的历练场景成功"/utf8>>};
get(45091) ->
#base_error_list{error_code = 45091,error_define = <<"INFO_PARTNER_NEW_TRAIN_FAILED"/utf8>>,error_desc = <<" 开启新的历练场景失败"/utf8>>};
get(45092) ->
#base_error_list{error_code = 45092,error_define = <<"INFO_PARTNER_TRAIN_OPENED"/utf8>>,error_desc = <<" 所有的历练场景均已经开启过了"/utf8>>};
get(45100) ->
#base_error_list{error_code = 45100,error_define = <<"INFO_PARTNER_ADVANCED_SUCCESS"/utf8>>,error_desc = <<" 封禅成功"/utf8>>};
get(45101) ->
#base_error_list{error_code = 45101,error_define = <<"INFO_PARTNER_ADVANCED_FAILED"/utf8>>,error_desc = <<" 封禅失败"/utf8>>};
get(45102) ->
#base_error_list{error_code = 45102,error_define = <<"INFO_PARTNER_NOT_BLUE"/utf8>>,error_desc = <<" 非觉醒武将，无法使用该功能"/utf8>>};
get(45103) ->
#base_error_list{error_code = 45103,error_define = <<"INFO_PARTNER_ADVANCED_TIMES_OUT"/utf8>>,error_desc = <<" 今日已经使用过此类封禅了"/utf8>>};
get(46000) ->
#base_error_list{error_code = 46000,error_define = <<"INFO_BEAST_TOO_FAST"/utf8>>,error_desc = <<" 操作太过频繁，请稍后再做尝试"/utf8>>};
get(46001) ->
#base_error_list{error_code = 46001,error_define = <<"INFO_MAKE_BEAST_FAILED"/utf8>>,error_desc = <<" 生成灵兽失败"/utf8>>};
get(46002) ->
#base_error_list{error_code = 46002,error_define = <<"INFO_GET_BEAST"/utf8>>,error_desc = <<" 恭喜您获得灵兽[%s]"/utf8>>};
get(46003) ->
#base_error_list{error_code = 46003,error_define = <<"INFO_BEAST_MAX_LV"/utf8>>,error_desc = <<" 灵兽已最高等级"/utf8>>};
get(46004) ->
#base_error_list{error_code = 46004,error_define = <<"INFO_BEAST_ATTRI_MAX"/utf8>>,error_desc = <<" 属性已达最高等级，无法再升级！！"/utf8>>};
get(46005) ->
#base_error_list{error_code = 46005,error_define = <<"INFO_BEAST_ATTRI_NO_FOUND"/utf8>>,error_desc = <<" 未找到相应的灵兽属性！！！"/utf8>>};
get(46006) ->
#base_error_list{error_code = 46006,error_define = <<"INFO_BEAST_ATTRI_LV_UP_FAILED"/utf8>>,error_desc = <<" 灵兽属性升级失败"/utf8>>};
get(46007) ->
#base_error_list{error_code = 46007,error_define = <<"INFO_BEAST_NO_FOUND"/utf8>>,error_desc = <<" 还未拥有灵兽，无法进行该操作"/utf8>>};
get(46008) ->
#base_error_list{error_code = 46008,error_define = <<"INFO_BEAST_NOT_OWNER"/utf8>>,error_desc = <<" 不是灵兽拥有者"/utf8>>};
get(46009) ->
#base_error_list{error_code = 46009,error_define = <<"INFO_BEAST_SKILL_MAX"/utf8>>,error_desc = <<" 技能已达最高等级"/utf8>>};
get(46010) ->
#base_error_list{error_code = 46010,error_define = <<"INFO_BEAST_SKILL_LV_UP_FAILED"/utf8>>,error_desc = <<" 灵兽技能升级失败"/utf8>>};
get(46011) ->
#base_error_list{error_code = 46011,error_define = <<"INFO_BASE_SKILL_NO_FOUND"/utf8>>,error_desc = <<" 技能数据未找到"/utf8>>};
get(46012) ->
#base_error_list{error_code = 46012,error_define = <<"INFO_BEAST_CAMP_MAX"/utf8>>,error_desc = <<" 阵法已达最高等级"/utf8>>};
get(46013) ->
#base_error_list{error_code = 46013,error_define = <<"INFO_BEAST_CAMP_NO_FOUND"/utf8>>,error_desc = <<" 未找到阵法数据"/utf8>>};
get(46014) ->
#base_error_list{error_code = 46014,error_define = <<"INFO_BASE_CAMP_NO_FOUND"/utf8>>,error_desc = <<" 未找到基础阵法数据"/utf8>>};
get(46015) ->
#base_error_list{error_code = 46015,error_define = <<"INFO_BEAST_CAMP_LV_UP_FAILED"/utf8>>,error_desc = <<" 阵法升级失败"/utf8>>};
get(46016) ->
#base_error_list{error_code = 46016,error_define = <<"INFO_BASE_BEAST_NO_FOUND"/utf8>>,error_desc = <<" 基础灵兽数据未找到"/utf8>>};
get(46017) ->
#base_error_list{error_code = 46017,error_define = <<"INFO_BEAST_UPDATE_FAILED"/utf8>>,error_desc = <<" 更新灵兽数据失败"/utf8>>};
get(46018) ->
#base_error_list{error_code = 46018,error_define = <<"INFO_BEAST_LV_LIMIT"/utf8>>,error_desc = <<" 灵兽等级不够"/utf8>>};
get(46019) ->
#base_error_list{error_code = 46019,error_define = <<"INFO_BEAST_LV_TOO_HIGHT"/utf8>>,error_desc = <<" 灵兽等级不能超过玩家等级"/utf8>>};
get(46020) ->
#base_error_list{error_code = 46020,error_define = <<"INFO_BEAST_CHANGE_CONF_ERR"/utf8>>,error_desc = <<" 灵兽幻化配置错误"/utf8>>};
get(46021) ->
#base_error_list{error_code = 46021,error_define = <<"INFO_BEAST_CHANGE_OWN"/utf8>>,error_desc = <<" 已经拥有此灵兽幻化"/utf8>>};
get(46022) ->
#base_error_list{error_code = 46022,error_define = <<"INFO_BEAST_CHANGE_CANNOT_NEW"/utf8>>,error_desc = <<" 未达到获取该宠物的条件，请再接再厉"/utf8>>};
get(46023) ->
#base_error_list{error_code = 46023,error_define = <<"INFO_BEAST_CHANGE_NOT_OWN"/utf8>>,error_desc = <<" 未获得该宠物"/utf8>>};
get(46500) ->
#base_error_list{error_code = 46500,error_define = <<"INFO_STAR_POWER_MAX"/utf8>>,error_desc = <<" 星力已经达上限！！！"/utf8>>};
get(46501) ->
#base_error_list{error_code = 46501,error_define = <<"INFO_STAR_POWER_SUCCESS"/utf8>>,error_desc = <<" 星力激活成功"/utf8>>};
get(47000) ->
#base_error_list{error_code = 47000,error_define = <<"INFO_FORAGE_NOT_RUNNING"/utf8>>,error_desc = <<" 保卫粮草未开放"/utf8>>};
get(47001) ->
#base_error_list{error_code = 47001,error_define = <<"INFO_FORAGE_NOT_ENDED"/utf8>>,error_desc = <<" 保卫粮草未结束"/utf8>>};
get(47002) ->
#base_error_list{error_code = 47002,error_define = <<"INFO_FORAGE_NOT_OPEN"/utf8>>,error_desc = <<" 未达到开放条件"/utf8>>};
get(47003) ->
#base_error_list{error_code = 47003,error_define = <<"INFO_FORAGE_PLAYER_IS_STEALING"/utf8>>,error_desc = <<" 正在偷取"/utf8>>};
get(47004) ->
#base_error_list{error_code = 47004,error_define = <<"INFO_FORAGE_NOT_ENOUGH_IDLE_QTY"/utf8>>,error_desc = <<" 没有粮草了"/utf8>>};
get(47005) ->
#base_error_list{error_code = 47005,error_define = <<"INFO_FORAGE_NOT_ENOUGH_PIT_QTY"/utf8>>,error_desc = <<" 没有坑了"/utf8>>};
get(47006) ->
#base_error_list{error_code = 47006,error_define = <<"INFO_FORAGE_PLAYER_IS_COOLING_DOWN"/utf8>>,error_desc = <<" 正在冷却"/utf8>>};
get(48501) ->
#base_error_list{error_code = 48501,error_define = <<"INFO_BASE_WARCRAFT_NO_FOUND"/utf8>>,error_desc = <<" 未找到配置数据"/utf8>>};
get(48502) ->
#base_error_list{error_code = 48502,error_define = <<"INFO_WARCRAFT_NOT_FOUND"/utf8>>,error_desc = <<" 不存在城池"/utf8>>};
get(48503) ->
#base_error_list{error_code = 48503,error_define = <<"INFO_WARCRAFT_LV_LIMIT"/utf8>>,error_desc = <<" 等级不足，无法占领"/utf8>>};
get(48504) ->
#base_error_list{error_code = 48504,error_define = <<"INFO_WARCRAFT_MOBI_LIMIT"/utf8>>,error_desc = <<" 军粮不足，发兵失败"/utf8>>};
get(48505) ->
#base_error_list{error_code = 48505,error_define = <<"INFO_WARCRAFT_30_MIN_CD"/utf8>>,error_desc = <<" 城池仍在30分钟保护期内"/utf8>>};
get(48506) ->
#base_error_list{error_code = 48506,error_define = <<"INFO_RETREAT_AFTER_30_MIN"/utf8>>,error_desc = <<" 30分钟后方能撤出占领"/utf8>>};
get(48507) ->
#base_error_list{error_code = 48507,error_define = <<"INFO_WARCRAFT_HAVE_SNATCHED"/utf8>>,error_desc = <<" 你已经掠夺过他了。"/utf8>>};
get(48508) ->
#base_error_list{error_code = 48508,error_define = <<"INFO_WARCRAFT_OWNER_MINE"/utf8>>,error_desc = <<" 不能攻击自己的城池"/utf8>>};
get(48509) ->
#base_error_list{error_code = 48509,error_define = <<"INFO_WARCRAFT_NO_OWNER"/utf8>>,error_desc = <<" 不能掠夺没有被占领的城池"/utf8>>};
get(48510) ->
#base_error_list{error_code = 48510,error_define = <<"INFO_WARCRAFT_NO_OWNER_RETREAT"/utf8>>,error_desc = <<" 非自己的城池不能撤出"/utf8>>};
get(48511) ->
#base_error_list{error_code = 48511,error_define = <<"INFO_WARCRAFT_LV_TOO_HIGHT"/utf8>>,error_desc = <<" 已有更多高级城池可攻击，切勿再贪。"/utf8>>};
get(48512) ->
#base_error_list{error_code = 48512,error_define = <<"INFO_WARCRAFT_SNATCH_TIMES_LIMIT"/utf8>>,error_desc = <<" 该城池被打劫多次，已是城破楼空了。"/utf8>>};
get(51000) ->
#base_error_list{error_code = 51000,error_define = <<"INFO_TREASURE_INQUIRE_BAG_SUCCESS"/utf8>>,error_desc = <<" 查询宝物背包成功"/utf8>>};
get(51001) ->
#base_error_list{error_code = 51001,error_define = <<"INFO_TREASURE_INQUIRE_BAG_FAILED"/utf8>>,error_desc = <<" 查询宝物背包失败"/utf8>>};
get(51002) ->
#base_error_list{error_code = 51002,error_define = <<"INFO_TREASURE_INFO_FAILED"/utf8>>,error_desc = <<" 获取玩家探索信息失败"/utf8>>};
get(51010) ->
#base_error_list{error_code = 51010,error_define = <<"INFO_TREASURE_EXPLORE_SUCCESS"/utf8>>,error_desc = <<" 探索成功"/utf8>>};
get(51011) ->
#base_error_list{error_code = 51011,error_define = <<"INFO_TREASURE_EXPLORE_FAILED"/utf8>>,error_desc = <<" 探索失败"/utf8>>};
get(51012) ->
#base_error_list{error_code = 51012,error_define = <<"INFO_TREASURE_EXPLORE_WRONG_TREASURE_ID"/utf8>>,error_desc = <<" 错误的宝藏信息，探索失败"/utf8>>};
get(51014) ->
#base_error_list{error_code = 51014,error_define = <<"INFO_TREASURE_FULL_OF_TEMP"/utf8>>,error_desc = <<" 临时背包空间不足，无法进行寻宝"/utf8>>};
get(51016) ->
#base_error_list{error_code = 51016,error_define = <<"INFO_TREASURE_EXPLORE_TIMES_OUT"/utf8>>,error_desc = <<" 购买次数已经使用完毕，购买失败"/utf8>>};
get(51017) ->
#base_error_list{error_code = 51017,error_define = <<"INFO_TREASURE_EXPLORE_WRONG_CURRENT"/utf8>>,error_desc = <<" 当前探索场景信息获取失败"/utf8>>};
get(51018) ->
#base_error_list{error_code = 51018,error_define = <<"INFO_TREASURE_EXPLORE_WRONG_PREVIOUS"/utf8>>,error_desc = <<" 前一探索场景信息获取失败"/utf8>>};
get(51019) ->
#base_error_list{error_code = 51019,error_define = <<"INFO_TREASURE_EXPLORE_OUT_OF_LIFE"/utf8>>,error_desc = <<" 探索生命消耗完毕，无法进行当前场景探索"/utf8>>};
get(51021) ->
#base_error_list{error_code = 51021,error_define = <<"INFO_TREASURE_EXPLORE_DUPLICATED"/utf8>>,error_desc = <<" 该场景已经探索过了，无法再次探索"/utf8>>};
get(51022) ->
#base_error_list{error_code = 51022,error_define = <<"INFO_TREASURE_EXPLORE_NOT_OPENED"/utf8>>,error_desc = <<" 指定的场景还未开放，无法进行探索"/utf8>>};
get(51023) ->
#base_error_list{error_code = 51023,error_define = <<"INFO_TREASURE_EXPLORE_IN_EXPLORE"/utf8>>,error_desc = <<" 已经在当前场景探索了，无法使用元宝探索"/utf8>>};
get(51030) ->
#base_error_list{error_code = 51030,error_define = <<"INFO_TREASURE_PICK_SUCCESS"/utf8>>,error_desc = <<" 拾取成功"/utf8>>};
get(51031) ->
#base_error_list{error_code = 51031,error_define = <<"INFO_TREASURE_PICK_FAILED"/utf8>>,error_desc = <<" 拾取失败"/utf8>>};
get(51032) ->
#base_error_list{error_code = 51032,error_define = <<"INFO_TREASURE_PICK_FULL_OF_BAG"/utf8>>,error_desc = <<" 包裹已满，无法拾取"/utf8>>};
get(51033) ->
#base_error_list{error_code = 51033,error_define = <<"INFO_TREASURE_EMPTY_TEMP_BAG"/utf8>>,error_desc = <<" 临时包裹为空，不可拾取"/utf8>>};
get(51040) ->
#base_error_list{error_code = 51040,error_define = <<"INFO_TREASURE_ADD_BAG_SUCCESS"/utf8>>,error_desc = <<" 扩充包裹成功"/utf8>>};
get(51041) ->
#base_error_list{error_code = 51041,error_define = <<"INFO_TREASURE_ADD_BAG_FAILED"/utf8>>,error_desc = <<" 扩充包裹失败"/utf8>>};
get(51042) ->
#base_error_list{error_code = 51042,error_define = <<"INFO_TREASURE_BAG_ALL_OPENED"/utf8>>,error_desc = <<" 所有的包裹空间均已经开启"/utf8>>};
get(51050) ->
#base_error_list{error_code = 51050,error_define = <<"INFO_TREASURE_SWAP_SUCCESS"/utf8>>,error_desc = <<" 宝物交换成功"/utf8>>};
get(51051) ->
#base_error_list{error_code = 51051,error_define = <<"INFO_TREASURE_SWAP_FAILED"/utf8>>,error_desc = <<" 宝物交换失败"/utf8>>};
get(51052) ->
#base_error_list{error_code = 51052,error_define = <<"INFO_TREASURE_EXP_EXCEED"/utf8>>,error_desc = <<" 宝物经验已达上限，无法合并"/utf8>>};
get(51053) ->
#base_error_list{error_code = 51053,error_define = <<"INFO_TREASURE_EMPTY_SOURCE"/utf8>>,error_desc = <<" 源位置为空，无法交换"/utf8>>};
get(51054) ->
#base_error_list{error_code = 51054,error_define = <<"INFO_TREASURE_WRONG_BASE_TREASURE"/utf8>>,error_desc = <<" 错误的宝物数据，无法交换"/utf8>>};
get(51055) ->
#base_error_list{error_code = 51055,error_define = <<"INFO_TREASURE_DISTINGUISH_FAILED"/utf8>>,error_desc = <<" 已装备有同类型的宝物，无法再装备"/utf8>>};
get(51060) ->
#base_error_list{error_code = 51060,error_define = <<"INFO_TREASURE_SCENE_SUCCESS"/utf8>>,error_desc = <<" 探索场景成功"/utf8>>};
get(51061) ->
#base_error_list{error_code = 51061,error_define = <<"INFO_TREASURE_SCENE_FAILED"/utf8>>,error_desc = <<" 探索场景失败"/utf8>>};
get(51062) ->
#base_error_list{error_code = 51062,error_define = <<"INFO_TREASURE_LIFE_OUT"/utf8>>,error_desc = <<" 生命点耗尽！暂且撤退，重新再来吧"/utf8>>};
get(51063) ->
#base_error_list{error_code = 51063,error_define = <<"INFO_TREASURE_LIFE_COST"/utf8>>,error_desc = <<" 遇到陷阱，生命 -1"/utf8>>};
get(51064) ->
#base_error_list{error_code = 51064,error_define = <<"INFO_TREASURE_IN"/utf8>>,error_desc = <<" 找到宝物啦！继续向宝藏深处前进"/utf8>>};
get(51065) ->
#base_error_list{error_code = 51065,error_define = <<"INFO_TREASURE_SCENE_SUCCESS_3"/utf8>>,error_desc = <<" 探索场景成功，且下一个场景的位置至少为3"/utf8>>};
get(51070) ->
#base_error_list{error_code = 51070,error_define = <<"INFO_TREASURE_BUY_LIFE_SUCCESS"/utf8>>,error_desc = <<" 生命购买成功，生命 +3"/utf8>>};
get(51071) ->
#base_error_list{error_code = 51071,error_define = <<"INFO_TREASURE_BUY_LIFE_FAILED"/utf8>>,error_desc = <<" 生命购买失败"/utf8>>};
get(51072) ->
#base_error_list{error_code = 51072,error_define = <<"INFO_TREASURE_LIFE_BUY_TIMES_OUT"/utf8>>,error_desc = <<" 生命购买次数已经使用完毕"/utf8>>};
get(51073) ->
#base_error_list{error_code = 51073,error_define = <<"INFO_TREASURE_LIFE_TOO_HIGH"/utf8>>,error_desc = <<" 生命值高于5，无需购买"/utf8>>};
get(51074) ->
#base_error_list{error_code = 51074,error_define = <<"INFO_TREASURE_BATCH_VIP_LOWER"/utf8>>,error_desc = <<" vip等级不足，无法使用一键寻宝功能"/utf8>>};
get(51080) ->
#base_error_list{error_code = 51080,error_define = <<"INFO_TREASURE_REWARD_FAILED"/utf8>>,error_desc = <<" 获取宝物奖励失败"/utf8>>};
get(51081) ->
#base_error_list{error_code = 51081,error_define = <<"INFO_TREASURE_FULL_OF_BAG"/utf8>>,error_desc = <<" 包裹已满，无法获取奖励"/utf8>>};
get(51082) ->
#base_error_list{error_code = 51082,error_define = <<"INFO_TREASURE_NOT_OPEN_REWARD_FAILED"/utf8>>,error_desc = <<" 宝物功能尚未开放，无法获得奖励"/utf8>>};
get(52000) ->
#base_error_list{error_code = 52000,error_define = <<"INFO_BOSS_TIME_ERROR"/utf8>>,error_desc = <<" 现在不是世界BOSS开放时段"/utf8>>};
get(52001) ->
#base_error_list{error_code = 52001,error_define = <<"INFO_BOSS_SCEN_IS_BUSY"/utf8>>,error_desc = <<" 系统繁忙，请稍候再试"/utf8>>};
get(52002) ->
#base_error_list{error_code = 52002,error_define = <<"INFO_BOSS_ALEADY_DEAD"/utf8>>,error_desc = <<" 世界BOSS已被击败，请明天再来"/utf8>>};
get(52003) ->
#base_error_list{error_code = 52003,error_define = <<"INFO_QUITE_UNEXPECTED"/utf8>>,error_desc = <<" 您异常退出了活动场景，需等待%s秒自动复活后才能重新进入"/utf8>>};
get(52004) ->
#base_error_list{error_code = 52004,error_define = <<"INFO_REBORN_ERROR"/utf8>>,error_desc = <<" 倒计时30秒以内才能复活"/utf8>>};
get(52200) ->
#base_error_list{error_code = 52200,error_define = <<"INFO_FIRST_OF_WORLD_QUERY_SUCCESS"/utf8>>,error_desc = <<" 查询演兵论战状态信息成功"/utf8>>};
get(52201) ->
#base_error_list{error_code = 52201,error_define = <<"INFO_FIRST_OF_WORLD_QUERY_FAILED"/utf8>>,error_desc = <<" 查询演兵论战状态信息失败"/utf8>>};
get(52210) ->
#base_error_list{error_code = 52210,error_define = <<"INFO_FIRST_OF_WORLD_QUALIFY_SUCCESS"/utf8>>,error_desc = <<" 成功参与演兵论战（海选赛）"/utf8>>};
get(52211) ->
#base_error_list{error_code = 52211,error_define = <<"INFO_FIRST_OF_WORLD_QUALIFY_FAILED"/utf8>>,error_desc = <<" 参与演兵论战（海选赛）失败"/utf8>>};
get(52212) ->
#base_error_list{error_code = 52212,error_define = <<"INFO_FIRST_OF_WORLD_QUALIFIED"/utf8>>,error_desc = <<" 已经获取参赛资格，无法再参与海选"/utf8>>};
get(52213) ->
#base_error_list{error_code = 52213,error_define = <<"INFO_FIRST_OF_WORLD_OUT_OF_RANGE"/utf8>>,error_desc = <<" 选位错误，无法参与海选"/utf8>>};
get(52214) ->
#base_error_list{error_code = 52214,error_define = <<"INFO_FIRST_OF_WORLD_TIMES_OUT"/utf8>>,error_desc = <<" 今日海选次数已经使用完毕，请明日再来"/utf8>>};
get(52215) ->
#base_error_list{error_code = 52215,error_define = <<"INFO_FIRST_OF_WORLD_COOLDOWN"/utf8>>,error_desc = <<" 海选竞技战斗发起冷却中，请稍后再尝试"/utf8>>};
get(52216) ->
#base_error_list{error_code = 52216,error_define = <<"INFO_FIRST_OF_WORLD_NOT_IN_QUALIFY"/utf8>>,error_desc = <<" 非海选时间段内，无法参与海选战斗"/utf8>>};
get(52220) ->
#base_error_list{error_code = 52220,error_define = <<"INFO_FIRST_OF_WORLD_UPDATE_SUCCESS"/utf8>>,error_desc = <<" 更新演兵论战数据成功"/utf8>>};
get(52221) ->
#base_error_list{error_code = 52221,error_define = <<"INFO_FIRST_OF_WORLD_UPDATE_FAILED"/utf8>>,error_desc = <<" 更新演兵论战数据失败"/utf8>>};
get(52300) ->
#base_error_list{error_code = 52300,error_define = <<"INFO_REPEAT_UPS_GAMBLE"/utf8>>,error_desc = <<" 已经押注，不能再次押注"/utf8>>};
get(52301) ->
#base_error_list{error_code = 52301,error_define = <<"INFO_UPS_GAMBLE_ERROR_PHASE"/utf8>>,error_desc = <<" 现在不是押注的阶段，请刷新游戏界面"/utf8>>};
get(52302) ->
#base_error_list{error_code = 52302,error_define = <<"INFO_UPS_NOT_SIGN_UP_TIME"/utf8>>,error_desc = <<" 现在不是报名时间，请下次再来"/utf8>>};
get(52303) ->
#base_error_list{error_code = 52303,error_define = <<"INFO_UPS_SIGN_UP_SUCCESS"/utf8>>,error_desc = <<" 报名成功"/utf8>>};
get(52304) ->
#base_error_list{error_code = 52304,error_define = <<"INFO_UPS_REPEAT_SIGN_UP"/utf8>>,error_desc = <<" 你已经报名成功了，无须再次报名"/utf8>>};
get(54000) ->
#base_error_list{error_code = 54000,error_define = <<"INFO_ARTIFACT_UPGRADE_SUCCESS"/utf8>>,error_desc = <<" 法宝进阶成功"/utf8>>};
get(54001) ->
#base_error_list{error_code = 54001,error_define = <<"INFO_ARTIFACT_UPGRADE_FAILED"/utf8>>,error_desc = <<" 法宝进阶失败"/utf8>>};
get(54002) ->
#base_error_list{error_code = 54002,error_define = <<"INFO_ARTIFACT_NOT_ARTIFACT"/utf8>>,error_desc = <<" 非法宝数据，无法进行此操作"/utf8>>};
get(54003) ->
#base_error_list{error_code = 54003,error_define = <<"INFO_ARTIFACT_WRONG_OWNER"/utf8>>,error_desc = <<" 该法宝并不是你的，无法进阶"/utf8>>};
get(54004) ->
#base_error_list{error_code = 54004,error_define = <<"INFO_ARTIFACT_ITEM_NOT_SATISFIED"/utf8>>,error_desc = <<" 升级所需物品不足，无法进阶"/utf8>>};
get(54005) ->
#base_error_list{error_code = 54005,error_define = <<"INFO_ARTIFACT_LEVEL_NOT_SATISFIED"/utf8>>,error_desc = <<" 角色等级不足，无法进阶"/utf8>>};
get(54006) ->
#base_error_list{error_code = 54006,error_define = <<"INFO_ARTIFACT_MAX_LEVEL"/utf8>>,error_desc = <<" 已达升级上限，无法进阶"/utf8>>};
get(54007) ->
#base_error_list{error_code = 54007,error_define = <<"INFO_ARTIFACT_WRONG_BASE_INFO"/utf8>>,error_desc = <<" 法宝升级数据获取失败，无法进阶"/utf8>>};
get(54008) ->
#base_error_list{error_code = 54008,error_define = <<"INFO_ARTIFACT_WRONG_UPGRADE_INFO"/utf8>>,error_desc = <<" 法宝升级信息错误，无法进阶"/utf8>>};
get(54009) ->
#base_error_list{error_code = 54009,error_define = <<"INFO_ARTIFACT_VIP_LEVEL_LOWER"/utf8>>,error_desc = <<" vip等级不足，无法使用法宝炼化材料补齐功能"/utf8>>};
get(55001) ->
#base_error_list{error_code = 55001,error_define = <<"INFO_FIGHT_REPORT_NO_FOUND"/utf8>>,error_desc = <<" 战报已经过期！！！"/utf8>>};
get(55002) ->
#base_error_list{error_code = 55002,error_define = <<"INFO_FIGHT_TOO_FREQUENTLY"/utf8>>,error_desc = <<" 战斗太过频繁"/utf8>>};
get(56001) ->
#base_error_list{error_code = 56001,error_define = <<"ERROR_FIGHT_SOUL_COLLECTED"/utf8>>,error_desc = <<" 武魂已领取"/utf8>>};
get(56002) ->
#base_error_list{error_code = 56002,error_define = <<"ERROR_FIGHT_SOUL_CONDITION_LIMT"/utf8>>,error_desc = <<" 武魂领取条件未满足"/utf8>>};
get(56003) ->
#base_error_list{error_code = 56003,error_define = <<"ERROR_FIGHT_SOUL_UNCOLLECTED"/utf8>>,error_desc = <<" 武魂还未领取"/utf8>>};
get(56004) ->
#base_error_list{error_code = 56004,error_define = <<"ERROR_FIGHT_SOUL_IS_USING"/utf8>>,error_desc = <<" 武魂已经启用"/utf8>>};
get(56005) ->
#base_error_list{error_code = 56005,error_define = <<"ERROR_FIGHT_SOUL_IS_NOT_USED"/utf8>>,error_desc = <<" 武魂还未启用"/utf8>>};
get(56007) ->
#base_error_list{error_code = 56007,error_define = <<"ERROR_FIGHT_SOUL_NO_FOUND"/utf8>>,error_desc = <<" 未找到武魂数据！！！"/utf8>>};
get(56008) ->
#base_error_list{error_code = 56008,error_define = <<"ERROR_FIGHT_SOUL_HAVE_MIN"/utf8>>,error_desc = <<" 需要取得前面所有的武魂后，才能领取此武魂！"/utf8>>};
get(57000) ->
#base_error_list{error_code = 57000,error_define = <<"INFO_SLAVE_QUERY_SUCCESS"/utf8>>,error_desc = <<" 查询属臣信息成功"/utf8>>};
get(57001) ->
#base_error_list{error_code = 57001,error_define = <<"INFO_SLAVE_QUERY_FAILED"/utf8>>,error_desc = <<" 查询属臣信息失败"/utf8>>};
get(57002) ->
#base_error_list{error_code = 57002,error_define = <<"INFO_SLAVE_TARGET_NOT_FOUND"/utf8>>,error_desc = <<" 征服目标未找到或目标尚未开启该功能"/utf8>>};
get(57003) ->
#base_error_list{error_code = 57003,error_define = <<"INFO_SLAVE_INFO_NOT_FOUND"/utf8>>,error_desc = <<" 属臣信息获取失败"/utf8>>};
get(57010) ->
#base_error_list{error_code = 57010,error_define = <<"INFO_SLAVE_ENSLAVE_COMBAT_SUCCESS"/utf8>>,error_desc = <<" 你征服了 %s ！他成为了你的属臣"/utf8>>};
get(57011) ->
#base_error_list{error_code = 57011,error_define = <<"INFO_SLAVE_ENSLAVE_COMBAT_FAILED"/utf8>>,error_desc = <<" 征服战斗发起失败"/utf8>>};
get(57012) ->
#base_error_list{error_code = 57012,error_define = <<"INFO_SLAVE_CANT_ENSLAVE_MASTER"/utf8>>,error_desc = <<" 对方是您的宗主，不可征服，您可以先[反叛]他"/utf8>>};
get(57013) ->
#base_error_list{error_code = 57013,error_define = <<"INFO_SLAVE_TARGET_NOT_COOLDOWN"/utf8>>,error_desc = <<" 对方刚刚被征服了，还在30分钟保护时间内"/utf8>>};
get(57014) ->
#base_error_list{error_code = 57014,error_define = <<"INFO_SLAVE_ENSLAVE_TIMES_OUT"/utf8>>,error_desc = <<" 今日的征服次数耗尽，请明天再进行征服吧"/utf8>>};
get(57015) ->
#base_error_list{error_code = 57015,error_define = <<"INFO_SLAVE_SLAVE_EXCEED"/utf8>>,error_desc = <<" 无法征服，你所拥有的属臣已达上限"/utf8>>};
get(57016) ->
#base_error_list{error_code = 57016,error_define = <<"INFO_SLAVE_CANT_ENSLAVE_SLAVE"/utf8>>,error_desc = <<" 该玩家已经是你的属臣"/utf8>>};
get(57020) ->
#base_error_list{error_code = 57020,error_define = <<"INFO_SLAVE_REBEL_SUCCESS"/utf8>>,error_desc = <<" 反叛战斗发起成功"/utf8>>};
get(57021) ->
#base_error_list{error_code = 57021,error_define = <<"INFO_SLAVE_REBEL_FAILED"/utf8>>,error_desc = <<" 反叛战斗发起失败"/utf8>>};
get(57022) ->
#base_error_list{error_code = 57022,error_define = <<"INFO_SLAVE_REBEL_NO_MASTER"/utf8>>,error_desc = <<" 你现在属于自由身，无需反叛"/utf8>>};
get(57023) ->
#base_error_list{error_code = 57023,error_define = <<"INFO_SLAVE_REBEL_TIMES_OUT"/utf8>>,error_desc = <<" 今日的反叛次数已经使用完毕"/utf8>>};
get(57030) ->
#base_error_list{error_code = 57030,error_define = <<"INFO_SLAVE_RESCUE_SUCCESS"/utf8>>,error_desc = <<" 解救战斗发起成功"/utf8>>};
get(57031) ->
#base_error_list{error_code = 57031,error_define = <<"INFO_SLAVE_RESCUE_FAILED"/utf8>>,error_desc = <<" 解救战斗发起失败"/utf8>>};
get(57032) ->
#base_error_list{error_code = 57032,error_define = <<"INFO_SLAVE_RESCUE_TIMES_OUT"/utf8>>,error_desc = <<" 今日的解救次数已经使用完毕"/utf8>>};
get(57034) ->
#base_error_list{error_code = 57034,error_define = <<"INFO_SLAVE_RESCUE_NO_MASTER"/utf8>>,error_desc = <<" 对方已经是自由身了，无需解救"/utf8>>};
get(57035) ->
#base_error_list{error_code = 57035,error_define = <<"INFO_SLAVE_RESCUE_SELF_SLAVE"/utf8>>,error_desc = <<" 您确定要解救自己的属臣么？"/utf8>>};
get(57040) ->
#base_error_list{error_code = 57040,error_define = <<"INFO_SLAVE_INTERACT_SUCCESS"/utf8>>,error_desc = <<" 属臣交互成功"/utf8>>};
get(57041) ->
#base_error_list{error_code = 57041,error_define = <<"INFO_SLAVE_INTERACT_FAILED"/utf8>>,error_desc = <<" 属臣交互失败"/utf8>>};
get(57042) ->
#base_error_list{error_code = 57042,error_define = <<"INFO_SLAVE_TARGET_NOT_SLAVE"/utf8>>,error_desc = <<" 目标不是您的属臣"/utf8>>};
get(57043) ->
#base_error_list{error_code = 57043,error_define = <<"INFO_SLAVE_WRONG_INTERACT_TYPE"/utf8>>,error_desc = <<" 错误的交互类型，操作失败"/utf8>>};
get(57044) ->
#base_error_list{error_code = 57044,error_define = <<"INFO_SLAVE_TARGET_NOT_MASTER"/utf8>>,error_desc = <<" 目标不是您的宗主"/utf8>>};
get(57045) ->
#base_error_list{error_code = 57045,error_define = <<"INFO_SLAVE_INTERACT_TIMES_OUT"/utf8>>,error_desc = <<" 今日的互动次数已经使用完毕，请明日再来"/utf8>>};
get(57050) ->
#base_error_list{error_code = 57050,error_define = <<"INFO_SLAVE_KICKOUT_SUCCESS"/utf8>>,error_desc = <<" 成功将 %s 释放"/utf8>>};
get(57051) ->
#base_error_list{error_code = 57051,error_define = <<"INFO_SLAVE_KICKOUT_FAILED"/utf8>>,error_desc = <<" 释放属臣失败"/utf8>>};
get(57060) ->
#base_error_list{error_code = 57060,error_define = <<"INFO_SLAVE_SOS_SUCCESS"/utf8>>,error_desc = <<" 军团求救信息发送成功"/utf8>>};
get(57061) ->
#base_error_list{error_code = 57061,error_define = <<"INFO_SLAVE_SOS_FAILED"/utf8>>,error_desc = <<" 求救信息发送失败"/utf8>>};
get(57062) ->
#base_error_list{error_code = 57062,error_define = <<"INFO_SLAVE_SOS_NO_GUILD"/utf8>>,error_desc = <<" 您还没有加入军团，无法求救"/utf8>>};
get(57063) ->
#base_error_list{error_code = 57063,error_define = <<"INFO_SLAVE_SOS_NOT_READY"/utf8>>,error_desc = <<" 已经发送过求救信息，请稍后尝试"/utf8>>};
get(57064) ->
#base_error_list{error_code = 57064,error_define = <<"INFO_SLAVE_SOS_NO_MASTER"/utf8>>,error_desc = <<" 您已经是自由身了，无需求救"/utf8>>};
get(57070) ->
#base_error_list{error_code = 57070,error_define = <<"INFO_SLAVE_BONUS_INFO"/utf8>>,error_desc = <<" 属臣上缴合计：经验 %s、铜钱 %s、声望 %s，属臣互动合计：经验 %s、铜钱 %s、声望 %s"/utf8>>};
get(Var1) -> ?WARNING_MSG("get not find ~p", [{Var1}]),
[].
