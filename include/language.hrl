-ifndef(LANGUAGE_HRL).
-define(LANGUAGE_HRL,true).


%%%----------------------------------------------------------------------
%%% File    : language.hrl
%%% Created : 2011-06-08
%%% Description: 语言宏定义


-define(_LANG_TEST1, <<"item name is ~p, count is ~p">>).

%%-----------------------GM信息 -------------------------------------
-define(_LANG_GM_INFO_MAIL_TITLE,					"神魔遮天--GM").


%%-----------------------系统消息-----------------------------
-define(_LANG_SYSTEM_SHUTDOWN,					   <<"系统关闭.">>).
-define(_LANG_PACKET_FAST,							<<"您的帐号异常,请重新登陆.">>).


%% ----------------------  登陆系统  --------------------------------
-define(_LANG_ACCOUNT_LOGIN_FAIL,				   <<"登陆失败,请重新登陆.">>).		
-define(_LANG_ACCOUNT_CREATE_SUCCESS,              <<"成功">>).
-define(_LANG_ACCOUNT_CREATE_FAIL,                 <<"失败">>).

-define(_LANG_ACCOUNT_PLAYER_FULL,					<<"服务器人数已满1，请稍后再试。">>).	

-define(_LANG_ACCOUNT_CREATE_IS_EXIST,				<<"此角色名称已存在，请重新起名。">>).		
-define(_LANG_ACCOUNT_CREATE_NOT_VALID,				<<"不能使用非法字符作为角色名称。">>).	
-define(_LANG_ACCOUNT_CREATE_TOO_LONG,				<<"角色名称不能多于14个字符（7个汉字）。">>).	
-define(_LANG_ACCOUNT_CREATE_TOO_SHORT,			    <<"角色名称不能少于4个字符（2个汉字）。">>).


%% ----------------------  好友系统  -------------------------------------
-define(_LANG_FRIEND_ONLINE,                        <<"~s ~s 上线了">>).
-define(_LANG_FRIEND_OFFLINE,                       <<"~s ~s 下线了">>).
-define(_LANG_FRIEND_FRIEND,                        <<"好友">>).
-define(_LANG_FRIEND_ENEMY,                        <<"仇人">>).
-define(_LANG_FRIEND_ADD_FULL,    			<<"好友人数已满">>).
-define(_LANG_FRIEND_BLACK_ADD_FULL,    			<<"黑名单人数已满">>).
-define(_LANG_FRIEND_NOT_ONLINE,          			<<"玩家不在线，不能添加">>).
-define(_LANG_FRIEND_ROLE_NOT_EXIST,      			<<"不存在此角色名称">>).
-define(_LANG_FRIEND_ADD_SUCCESS,         			<<"添加好友成功">>).
-define(_LANG_FRIEND_ADD_REFUSE,          			<<"对方拒绝您添加好友的请求">>).
-define(_LANG_FRIEND_REQUEST_SELF,                  <<"不能添加自己">>).
-define(_LANG_FRIEND_FRIEND_ADD_NOT_SAME_LINE,      <<"玩家不同线">>).
-define(_LANG_FRIEND_BLACK_ALREADY,            		<<"已经在你的黑名单中">>).
-define(_LANG_FRIEND_FAIL,                    		<<"操作失败">>).
-define(_LANG_FRIEND_GROUP_DEFAULT,                 <<"默认分组不能删除">>).
-define(_LANG_FRIEND_GROUP_NOT_EXIST,               <<"分组不存在">>).
-define(_LANG_FRIEND_GROUP_NUM_LIMIT,               <<"分组数量已满">>).
-define(_LANG_FRIEND_FRIEND_ROLE_NULL,              <<"请输入玩家昵称">>).
%% -define(_LANG_FRIEND_GROUP_ALREADY_EXIST,           <<"分组已存在">>).
-define(_LANG_FRIEND_ERROR_FRIEND_EXISTS,			<<"好友已存在">>).	
-define(_LANG_FRIEND_ERROR_BLACK_EXISTS,			<<"黑名单已存在">>).					
-define(_LANG_FRIEND_ERROR_ENEMY_EXISTS,			<<"仇人已存在">>).

-define(_LANG_FRIEND_ERROR_FRIEND_NOT_EXISTS,<<"好友不存在">>).
-define(_LANG_FRIEND_ERROR_BLACK_NOT_EXISTS,<<"黑名单不存在">>).	
-define(_LANG_FRIEND_ERROR_ENEMY_NOT_EXISTS,<<"仇人不存在">>).	

%% ----------------------  任务系统  --------------------------------
-define(_LANG_TASK_ADD_NOT_EXIST,					<<"任务不存在.">>).
-define(_LANG_TASK_ADD_NOT_NPC,						<<"NPC不存在.">>).
-define(_LANG_TASK_ADD_FAR_NPC,						<<"不在NPC附近.">>).
-define(_LANG_TASK_ADD_BEGIN_DATE,					<<"任务时间未到.">>).
-define(_LANG_TASK_ADD_END_DATE,					<<"任务时间已过.">>).
-define(_LANG_TASK_ADD_MIN_LEVEL,					<<"等级过低.">>).
-define(_LANG_TASK_ADD_MAX_LEVEL,					<<"等级过高.">>).
-define(_LANG_TASK_ADD_PRE_TASK,					<<"前置任务未完成.">>).
-define(_LANG_TASK_ADD_HAS_ACCEPT,					<<"任务已经存在.">>).					

-define(_LANG_TASK_ADD_NOT_REPEAT,					<<"任务不能重复.">>).	
-define(_LANG_TASK_ADD_DAY_REPEAT,					<<"时间间隔未到.">>).	

-define(_LANG_TASK_ADD_NOT_SEX,						<<"性别不符合.">>).	
-define(_LANG_TASK_ADD_NOT_CORP,					<<"阵营不符合.">>).	
-define(_LANG_TASK_ADD_NOT_CAREER,					<<"职业不符合.">>).	

%%运镖
-define(_LANG_TASK_CARGO_OUT_TIMES,					<<"每天只能参加五次运镖.">>).
-define(_LANG_TASK_CARGO_ON_TASK,					<<"您已在押送镖车中.">>).
-define(_LANG_TASK_CARGO_COPPER_NOT_ENOUGH,			<<"您的铜钱不足支付押金.">>).
-define(_LANG_TASK_CARGO_NO_TOKEN,					<<"背包中没有相应的押镖令.">>).
-define(_LANG_TASK_CARGO_NO_BILL,					<<"背包没有银票，加货失败.">>).
-define(_LANG_TASK_CARGO_MAX_AWARD,					<<"镖车已为最高奖励，不能加货.">>).
-define(_LANG_TASK_CARGO_COLOR_WHITE,				<<"白">>).
-define(_LANG_TASK_CARGO_COLOR_GREEN,				<<"绿">>).
-define(_LANG_TASK_CARGO_COLOR_BLUE,				<<"蓝">>).
-define(_LANG_TASK_CARGO_COLOR_PURPLE,				<<"紫">>).
-define(_LANG_TASK_CARGO_ATTACK,					<<"危险！~s玩家的镖车被攻击，兄弟们请立即支援，立即传送。">>).
-define(_LANG_TASK_CARGO_GRABED,					<<"半路杀出个程咬金，{S-65280-~s}玩家镖车转眼已被{S-65280-~s}玩家抢得空空如也。">>).
-define(_LANG_TASK_CARGO_ROB_LIMIT,					<<"每日只有前~p次掠夺镖车能获得奖励。">>).
-define(_LANG_TASK_CARGO_LOSS,						<<"镖车被劫，获得~p经验。">>).
-define(_LANG_TASK_CARGO_ROB_SUCCESS,				<<"劫镖成功，获得~p铜钱。">>).
%%神魔令
-define(_LANG_TASK_SHENMO_NOT_ENOUGH,				<<"背包没有神魔令，接取任务失败.">>).
-define(_LANG_TASK_SHENMO_REFRESH_EXIST,			<<"背包没有玲珑石，不能刷新.">>).
-define(_LANG_TASK_SHENMO_REFRESH_SUCCESS,			<<"刷新成功，任务更改品质为~s色.">>).
-define(_LANG_TASK_SHENMO_MAX_TIMES,				<<"每日最高只可领取~p次神魔令任务.">>).
%% ----------------------  组队系统  --------------------------------
-define(_LANG_TEAM_NAME,							"的队伍").
-define(_LANG_TEAM_VITITE_SELF,						<<"不能邀请自己.">>).
-define(_LANG_TEAM_VITITE_NOT_EXIST,				<<"玩家不存在.">>).
-define(_LANG_TEAM_VITITE_OFFLINE,					<<"玩家不在线.">>).
-define(_LANG_TEAM_VITITE_NOT_LEADER,				<<"你不是队长.">>).
-define(_LANG_TEAM_VITITE_IN_TEAM,					<<"玩家已在本队中.">>).
-define(_LANG_TEAM_VITITE_IN_OTHERTEAM,				<<"玩家在其他队伍中.">>).
-define(_LANG_TEAM_VITITE_SUCCESS,					<<"邀请入队请求已发送,请等待对方回应.">>).		
-define(_LANG_TEAM_VITITE_MAX_MEMBER,				<<"队伍人数已满.">>).
-define(_LANG_TEAM_JOIN_REQUEST,					<<"入队请求已发出，等待队长回应.">>).
-define(_LANG_TEAM_VITITE_DISAGREE,					<<"~s玩家拒绝了您的队伍邀请">>).
-define(_LANG_TEAM_JOIN_TEXT,						"~s玩家成功进入本队伍").
-define(_LANG_TEAM_JOIN_SELFTEXT,					<<"你加入了队伍">>).
-define(_LANG_TEAM_LEAVE_TEXT,						<<"~s玩家已经退出队伍">>).
-define(_LANG_TEAM_LEAVE_SELFTEXT,					<<"你离开了队伍">>).
-define(_LANG_TEAM_KICK_SELFTEXT,					<<"你被移出队伍">>).
-define(_LANG_TEAM_DISBAND_TEXT,					<<"您的队伍已解散">>).
-define(_LANG_TEAM_LEADER_CHANGE,					"现在是队长").
-define(_LANG_TEAM_LEADER_CHANGE_SELF,				<<"你现在是队长">>).
-define(_LANG_TEAM_SETTING_CHANGE,					<<"修改队伍设置">>).
-define(_LANG_TEAM_CREATE,							<<"您已成功创建队伍">>).


-define(_LANG_TEAM_READY_DUPLICATE,					<<"队伍已有其他副本存在，不能再创建新副本.">>).	
-define(_LANG_TEAM_NOT_LEADER_DUPLICATE,			<<"你不是队长.">>).
-define(_LANG_TEAM_TEAMMATE_READY_DUPLICATE,        <<"您有队员已在副本中，不能申请进入副本">>).
-define(_LANG_TEAM_NOT_CREATE_DUPLICATE,            <<"只有队长才能申请进入副本">>).	
-define(_LANG_TEAM_NOT_JOIN,                        <<"此队伍已在副本中，不能加入">>).
-define(_LANG_LEVEL_NOT_TRUE,                       <<"你的等级没有满足进入条件").

%% ----------------------  防沉迷系统  --------------------------------
-define(_LANG_INFANT_VAILD,							<<"防沉迷开始,请填写身份验证">>).
-define(_LANG_INFANT_NOTIC_ONLINE_TIME,				<<"您累积在线已满~w小时。">>).
-define(_LANG_FIVE_MINUTE_LEFT, 					<<"您的账户防沉迷剩余时间将在5分钟后进入防沉迷状态，系统将自动将您离线休息一段时间。">>).

%% ----------------------  战斗相关系统  -------------------------------- 
-define(_LANG_RELIVE_HEALTH,                         <<"花费10元宝，你原地健康复活了">>).
-define(_LANG_YUANBAO_NOT_ENOUGH,                    <<"元宝不足，不能原地健康复活">>).


%% ----------------------  宠物系统  --------------------------------
-define(_LANG_PET_LIST_NUM_LIMIT,                    <<"对不起，您的宠物栏已满，无法装备宠物">>).
-define(_LANG_PET_ALREADY_FIGHTTING,                 <<"宠物已出战">>).
-define(_LANG_PET_CALL_BACK_FIRST,                   <<"请先召回宠物">>).
-define(_LNAG_PET_ONLY_ONE_FIGHT,                    <<"只能有一个宠物出战">>).
-define(_LANG_PET_NOT_EXIST,                         <<"宠物不存在">>).

%%----------------------- 聊天系统-----------------------------------
-define(_LANG_CHAT_GUILD_TIME,"帮会聊天间隔还剩余").
-define(_LANG_CHAT_TEAM_TIME,"队伍聊天间隔还剩余").
-define(_LANG_CHAT_TIME_UNIT,"秒").
-define(_LANG_CHAT_WORLD_TIME,"世界聊天间隔还剩余").
-define(_LANG_CHAT_TEAM_MSG,"您没有所在队伍").
-define(_LANG_CHAT_GUILD_MSG,"您没有所在帮会").
-define(_LANG_CHAT_USER_MSG,"用户不在线").
-define(_LANG_CHAT_NOT_PRIVATE,"不能对自己私聊").
-define(_LANG_CHAT_NOT_LABA,"你没有喇叭了，快去买吧！").
-define(_LANG_CHAT_WORLD_LEVEL,"世界聊天需要达到15级。").
-define(_LANG_CHAT_CP,"世界聊天需要消耗1点体力，您的体力不足。").
-define(_LANG_CHAT_BAN, <<"您被禁止发言了！">>).

-define(_LANG_CHAT_FINISH_DARTS, "押运镖车成功， 获得~p经验、~p铜钱奖励。").
-define(_LANG_CHAT_ACCEPT_DARTS, "接取~s色镖车，扣除~s色押镖令与~p铜钱，请开始护送镖车。").
-define(_LANG_CHAT_ACCEPT_PURPLE_CAR, "恭喜~s玩家接取{S-10040013-紫色镖车}将会获得大量奖励。").
%%----------------------- 邮件系统-----------------------------------
-define(_LANG_MAIL_LESS_COPPER,"铜钱不足").

%%------------------------打坐修炼系统----------------------------------
-define(_LANGUAGE_SIT_ALREADY, "已经在打坐状态中。").
-define(_LANGUAGE_SIT_ON_PK, "战斗状态中，不能进行打坐修炼。").
-define(_LANGUAGE_SIT_START, "您进入【单人打坐】状态，每隔20秒获得xx点经验和xx点历练值，增加xx点所修炼的神通熟练度。").
-define(_LANGUAGE_SIT_CANCLE, "您的打坐状态已经取消。").

%%------------------------寄售系统----------------------------------
-define(_LANGUAGE_SALE_TITLE, "寄售系统邮件").

-define(_LANGUAGE_SALE_ITEM_ONSALE_TIMEOUT, "超过寄售时间，没人购买, 物品【~s】x~p退还给您。").
-define(_LANGUAGE_SALE_YB_ONSALE_TIMEOUT, "超过寄售时间，没人购买, 元宝x~p退还给您。").
-define(_LANGUAGE_SALE_COPPER_ONSALE_TIMEOUT, "超过寄售时间，没人购买, 铜钱x~p退还给您。").

-define(_LANGUAGE_SALE_ITEM_ONSALE_DELETE, "您撤消了寄售，物品【~s】退还给您。").
-define(_LANGUAGE_SALE_YB_ONSALE_DELETE, "您撤消了寄售，元宝x~p退还给您。").
-define(_LANGUAGE_SALE_COPPER_ONSALE_DELETE, "您撤消了寄售，铜钱x~p退还给您。").

-define(_LANGUAGE_SALE_ITEM_BUY_SUCCESS, "您成功购买了【~s】x~p, 花费~p铜钱。").
-define(_LANGUAGE_SALE_YB_BUY_SUCCESS, "您成功购买了元宝x~p, 花费~p铜钱。").
-define(_LANGUAGE_SALE_COPPER_BUY_SUCCESS, "您成功购买了铜钱x~p, 花费~p元宝。").


-define(_LANGUAGE_SALE_ITEM_ONSALE_SUCCESS_COPPER, "您成功寄售了【~s】x~p, 获得~p铜钱。").
-define(_LANGUAGE_SALE_ITEM_ONSALE_SUCCESS_YUANBAO, "您成功寄售了【~s】x~p, 获得~p元宝。").
-define(_LANGUAGE_SALE_YB_ONSALE_SUCCESS, "您成功寄售了元宝x~p, 获得~p铜钱。").
-define(_LANGUAGE_SALE_COPPER_ONSALE_SUCCESS, "您成功寄售了铜钱x~p, 获得~p元宝。").

-define(_LANGUAGE_SALE_COPPER, "铜钱").
-define(_LANGUAGE_SALE_YUAN_BAO, "元宝").

-define(_LANGUAGE_SALE_MSG_ITEM_NOT_EXIST, "物品不存在").
-define(_LANGUAGE_SALE_MSG_NOT_ENOUGH_COPPER, "铜钱不足").
-define(_LANGUAGE_SALE_MSG_ERROR_ITEM_DATA, "物品数据错误").
-define(_LANGUAGE_SALE_MSG_BIND_ITEM, "绑定物品不能寄售").
-define(_LANGUAGE_SALE_MSG_ERROR_ITEM_TEMPLATE, "物品模板错误").
-define(_LANGUAGE_SALE_MSG_ITEM_ON_SALE, "物品已在寄售中").
-define(_LANGUAGE_SALE_MSG_SALE_NOT_EXIST, "寄售不存在").
-define(_LANGUAGE_SALE_MSG_BAG_FULL, "背包满").
-define(_LANGUAGE_SALE_MSG_UNKOWN_SALE_TYPE, "未知寄售类型").
-define(_LANGUAGE_SALE_MSG_ERROR_PRICE_TYPE, "价格类型 错误").
-define(_LANGUAGE_SALE_MSG_NOT_ENOUGH_YUAN_BAO, "元宝不足").
-define(_LANGUAGE_SALE_MSG_DB_ADD_FAIL, "数据库添加寄售记录失败").
-define(_LANGUAGE_SALE_MSG_NOT_MATCH_SALER, "不是添加寄售的玩家").
-define(_LANGUAGE_SALE_MSG_FAIL_CANCEL_SALE_BEACAUSE_BAG_FULL, "撤消寄售失败，背包满").
-define(_LANGUAGE_SALE_MSG_FAIL_YOU_ARE_SALER, "购买寄售失败，不能购买自己的寄售").
-define(_LANGUAGE_SALE_MSG_ERROR_PARAM, "寄售失败，参数错误").
%% -------------------------交易系统 --------------------------------------
-define(_LANGUAGE_TRADE_FAIL_PK, "战斗状态不能交易").
-define(_LANGUAGE_TRADE_FAIL_DEAH, "死亡状态不能交易").
-define(_LANGUAGE_TRADE_FAIL_SIT, "打坐状态不能交易").
-define(_LANGUAGE_TRADE_FAIL_SELF, "不能和自己交易").
-define(_LANGUAGE_TRADE_FAIL_OFFLINE, "对方不在线或没有此玩家").
-define(_LANGUAGE_TRADE_FAIL_BUSY, "对方正在忙").
-define(_LANGUAGE_TRADE_FAIL_TRADE, "已经在交易状态中").
-define(_LANGUAGE_TRADE_FAIL_UNKOWN_VALUE, "参数错误").
-define(_LANGUAGE_TRADE_REQUEST_SUCCESS, "发出请求成功，请等待对方回应").
-define(_LANGUAGE_TRADE_REQUEST_REFUSE, "【~s】拒绝了您的交易请求").
-define(_LANGUAGE_TRADE_REQUEST_ACCEPT, "【~s】同意了您的交易请求").

-define(_LANG_ALREADY_STALL, "您已经在摆摊中").
-define(_LANG_STALL_LOCAL_ERROR, "当前位置不能摆摊").

%% -------------------------帮会--------------------------------------

-define(_LANG_GUILDS_ITEMS_GET,                     "~s 取出了 ~s").
-define(_LANG_GUILDS_ITEMS_PUT,                     "~s 放入了 ~s").

-define(_LANG_GUILDS_LEVEL_UP_LOG,					"帮会升到 ~p 级").
-define(_LANG_GUILDS_MEMBER_JOB_CHANGE,				"~s 被任命为 ~s").
-define(_LANG_GUILDS_VICE_PERSIDENT,				"副帮主").
-define(_LANG_GUILDS_HONORARY,				"荣誉成员").
-define(_LANG_GUILDS_COMMON,				"正式成员").
-define(_LANG_GUILDS_ASSOCIATE,				"预备成员").

-define(_LANG_GUILDS_CREATE_GUILD_SUCCESS,			"创建帮会成功").
-define(_LANG_GUILDS_CREATE_GUILD_FAILED,			"创建帮会失败").

-define(_LANG_GUILD_ERROR_NAME_NOT_VALID,			"帮会名不合法").	
-define(_LANG_GUILD_ERROR_NAME_ALREADY_HAVE,		"帮会名重复").
-define(_LANG_GUILD_ERROR_CREATE_TOO_SHORT,		"输入内容太短").
-define(_LANG_GUILD_ERROR_CREATE_TOO_LONG,		"输入内容太长").

-define(_LANG_GUILD_ERROR_NOT_ENOUGH_LEVEL,		"级别不足").	
-define(_LANG_GUILD_ERROR_INVITE_NOT_ENOUGH_LEVEL,		"对方未达到10级，不能入帮").
-define(_LANG_GUILD_ERROR_NOT_ENOUGH_CASH,		"资金不足").
-define(_LANG_GUILD_ERROR_NOT_ENOUGH_GUILD_MONEY,		"帮会资金不足").
-define(_LANG_GUILD_ERROR_NOT_ENOUGH_GUILD_NEED,		"帮会贡献或活跃不足").

-define(_LANG_GUILD_ERROR_TARGET_ALREADY_HAVE_GUILD,				"玩家已有帮会").
-define(_LANG_GUILD_ERROR_ALREADY_HAVE_GUILD,				"您已有帮会").
-define(_LANG_GUILD_ERROR_LEAVE_TIME_NOT_ENOUGH,			"您距上次退出帮会未满24小时").
-define(_LANG_GUILD_ERROR_TARGET_LEAVE_TIME_NOT_ENOUGH,		"对象距上次退出帮会未满24小时").
-define(_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT,		"帮会权限不足").	
-define(_LANG_GUILD_ERROR_NOT_GUILD,		"没有该帮会").
-define(_LANG_GUILD_ERROR_NOT_SAME_GUILD,		"非同一帮会").
-define(_LANG_GUILD_ERROR_NOT_CORP,		"没有该军团").
-define(_LANG_GUILD_ERROR_NOT_SAME_CORP,		"非同一军团").
-define(_LANG_GUILD_ERROR_LEADER_NOT_ALLOW,		"本操作不允许会长或军团长执行").
-define(_LANG_GUILD_ERROR_NOT_EXISTS_PLAYER,		"此人不存在").
-define(_LANG_GUILD_ERROR_TRYIN_NULL,		"申请列表为空").

-define(_LANG_GUILD_ERROR_DB_CAUSE,		"数据库错误").

-define(_LANG_GUILD_ERROR_FULL_MEMBER,		"帮会人员已满").
-define(_LANG_GUILD_ERROR_CORP_FULL_MEMBER,		"军团人员已满").
-define(_LANG_GUILD_ERROR_CORP_NUMBER_MAX,		"军团数量已满").

-define(_LANG_GUILD_ERROR_SETTING_MAX_NUMBER,		"已到最大值").
-define(_LANG_GUILD_ERROR_SETTING_MAX_LEVEL,		"已升到最高级").

-define(_LANG_GUILD_ERROR_ALREADY_TRYIN,		"已经申请过加入此帮会").
-define(_LANG_GUILD_ERROR_NEVER_TRYIN,		"此用户没有申请加入本帮会").

-define(_LANG_GUILD_ERROR_NOT_ONLINE,		"对象不在线").
-define(_LANG_GUILD_ERROR_WAREHOUSE_MAX,		"仓库已满").	
-define(_LANG_GUILD_ERROR_WAREHOUSE_USER_NO_ITEM,		"你没有此物品").
-define(_LANG_GUILD_ERROR_WAREHOUSE_ITEM_BIND,		"不能放入绑定物品").
-define(_LANG_GUILD_ERROR_WAREHOUSE_NULL,		"仓库没有物品").
-define(_LANG_GUILD_ERROR_WAREHOUSE_NOT_ITEM,		"仓库没有此物品").
-define(_LANG_GUILD_ERROR_BAG_MAX,		"背包已满").

-define(_LANG_GUILD_ERROR_MAX_MAILS,	"当日邮件发送限制已到").

-define(_LANG_GUILD_ERROR,		"").

-define(_LANG_GUILD_REQUEST_SUCCESS,	"招收成员成功").
-define(_LANG_GUILD_REQUEST_TARGET_SUCCESS,		"恭喜您，成功加入 ~s 帮会").

-define(_LANG_GUILD_PLAYER_IN, "恭喜 ~s 玩家加入本帮会").
-define(_LANG_GUILD_PLAYER_CORP_IN, "恭喜 ~s 玩家加入军团 ~s ").

-define(_LANG_GUILD_PLAYER_CONTRIBUTION,"感谢 ~s 成员贡献 ~s 个贡献令同时增加 ~s 点帮会资金以及增加 ~s 点个人功勋。").

-define(_LANG_GUILD_PLAYER_INVITE,"邀请信息发送成功").

-define(_LANG_GUILD_CORP_PLAYER_KICKOUT,"您被移出军团").
-define(_LANG_GUILD_PLAYER_KICKOUT,"您被踢出帮会").
-define(_LANG_GUILD_PLAYER_KICKOUT_TO_ALL,"成员 ~s 被踢出帮会").

-define(_LANG_GUILD_PLAYER_LEAVE,"您退出了帮会").
-define(_LANG_GUILD_PLAYER_LEAVE_TO_ALL,"成员 ~s 退出帮会").

-define(_LANG_GUILD_DISMISS, "帮会已解散").
-define(_LANG_GUILD_LEVELUP, "本帮会已升级").
-define(_LANG_GUILD_CONTROL_SUCCESS, "操作成功").

-define(_LANG_GUILD_TRANSPORT_ALREADY_START, "本日已启动过帮会运镖").
-define(_LANG_GUILD_TRANSPORT_SUCCESS, "已开启帮会运镖，在有效时间内完成运镖可获得1.5倍经验与铜钱奖励。").
-define(_LANG_GUILD_TEANSPORT_TO_WORLD, "~s帮会开启帮会运镖，大家从速前往！").

-define(_LANG_GUILD_CREATE_TO_WORLD, "恭喜 ~s 帮会成立，诚邀各位加盟。").
%%========================每日奖励

-define(_LANG_DAILY_AWARD_COPPER, " ~s 铜钱，").
-define(_LANG_DAILY_AWARD_BIND_COPPER, " ~s 绑定铜钱，").
-define(_LANG_DAILY_AWARD_YUANBAO, " ~s 元宝，").
-define(_LANG_DAILY_AWARD_BIND_YUANBAO, " ~s 绑定元宝，").
-define(_LANG_DAILY_AWARD, "恭喜您，获得 ~s~s~s~s~s 奖励").
-define(_LANG_DAILY_AWARD_ITEM_ERROR, "背包空间不足，不能领取").
-define(_LANG_DAILY_AWARD_TIME_ERROR, "需要等待 ~s 秒才能领取奖励").

%%------------------------活动奖励系统----------------------------------
-define(_LANG_ACTIVITY_COLLECT_FAIL, "条件不符合，领取失败。").

%%------------------------PK打死----------------------

-define(_LANG_PK_DEAD, "您已经被 ~s 玩家击杀").
%%------------------------地图系统-----------------------
-define(_LANG_OTHER_REALM_DUNGEON, <<"不可进入其它门派的副本!">>).
-define(_LANG_DUNGEON_PERMISSION_FAILED, <<"进入副本失败!">>).
-define(_LANG_DUNGEON_NEWER_REALM, <<"新手不可进入门派副本!">>).
-define(_LANG_PHYSICAL_STRENGTH_NOT_ENOUGH, <<"体力不足!">>).
-define(_LANG_DUNGEON_NOT_EXIST, <<"不存在这个副本！">>).

-endif.
