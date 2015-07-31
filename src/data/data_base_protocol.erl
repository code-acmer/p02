%% Warning:本文件由data_generate自动生成，请不要手动修改
-module(data_base_protocol).

-export([get/1]).

-include("db_base_protocol.hrl").

get(9001) ->
    #ets_base_protocol{id = 9001, c2s = null, s2c = pberror,
		       memo = <<"错误提示协议">>};
get(9002) ->
    #ets_base_protocol{id = 9002, c2s = null, s2c = pbid32,
		       memo = <<"消息确认处理返回">>};
get(9003) ->
    #ets_base_protocol{id = 9003, c2s = null, s2c = pbid32,
		       memo = <<"时间戳同步协议">>};
get(9004) ->
    #ets_base_protocol{id = 9004, c2s = null, s2c = pberror,
		       memo = <<"用提示框显示信息">>};
get(9006) ->
    #ets_base_protocol{id = 9006, c2s = null, s2c = null,
		       memo = <<"心跳协议">>};
get(9009) ->
    #ets_base_protocol{id = 9009, c2s = pbidstring,
		       s2c = null, memo = <<"gm命令">>};
get(10000) ->
    #ets_base_protocol{id = 10000, c2s = pbaccount,
		       s2c = pbaccountlogin,
		       memo = <<"登录账号（0失败、1成功、2失败 - 离线时间还没超过5小时（防沉迷））">>};
get(10001) ->
    #ets_base_protocol{id = 10001, c2s = null, s2c = null,
		       memo = <<"角色登陆">>};
get(10002) ->
    #ets_base_protocol{id = 10002, c2s = null,
		       s2c = pbaccountlogin, memo = <<"获取角色列表">>};
get(10003) ->
    #ets_base_protocol{id = 10003, c2s = pbuserlogininfo,
		       s2c = pbuserlogininfo,
		       memo =
			   <<"创建角色（0失败、1创建成功、2未知错误、3角色名称已经被使用、4非法字符、5角色名称长度"
			     "为1~5个汉字、6用户已经创建角色、7账号角色个数已经达到3个、8角色名中含有敏感词）">>};
get(10004) ->
    #ets_base_protocol{id = 10004, c2s = pbuserlogininfo,
		       s2c = pbuserresult,
		       memo =
			   <<"选择角色（0失败、1成功 - 加载场景（成年人）、2成功 - 第一次登陆游戏、3成功 "
			     "- 未成年、4成功 - 但未填写身份证信息）">>};
get(10005) ->
    #ets_base_protocol{id = 10005, c2s = pbuserlogininfo,
		       s2c = pbuserresult, memo = <<"删除角色，删除结果：（1成功、0失败）">>};
get(10006) ->
    #ets_base_protocol{id = 10006, c2s = pbuserlogininfo,
		       s2c = pbuserresult, memo = <<"为角色绑定注册账号">>};
get(10007) ->
    #ets_base_protocol{id = 10007, c2s = null,
		       s2c = pbuserresult, memo = <<"强制下线">>};
get(10008) ->
    #ets_base_protocol{id = 10002, c2s = null,
		       s2c = null, memo = <<"心跳包">>};
get(10009) ->
    #ets_base_protocol{id = 10009, c2s = pbid32, s2c = null,
		       memo = <<"客户端登录日志请求">>};
get(10010) ->
    #ets_base_protocol{id = 10010, c2s = pbaccount,
		       s2c = pbuserlogininfo, memo = <<"直接创建帐号并返回一个帐号">>};
get(10020) ->
    #ets_base_protocol{id = 10020, c2s = pbid32,
		       s2c = pbid32r, memo = <<"随机名">>};
get(10030) ->
    #ets_base_protocol{id = 10020, c2s = null,
		       s2c = pbid32, memo = <<"session">>};
get(10100) ->
    #ets_base_protocol{id = 10100, c2s = pbrc4,
		       s2c = pbrc4, memo = <<"pubkeyswap">>};
get(11010) ->
    #ets_base_protocol{id = 11010, c2s = pbchat,
		       s2c = pbchat, memo = <<"世界聊天">>};
get(11012) ->
    #ets_base_protocol{id = 11012, c2s = pbid32,
		       s2c = pbchatlist, memo = <<"请求世界聊天内容">>};
get(11013) ->
    #ets_base_protocol{id = 11013, c2s = pbchat, s2c = pbchat,
		       memo = <<"发送私聊">>};
get(11014) ->
    #ets_base_protocol{id = 11014, c2s = null, s2c = pbnewmsg,
		       memo = <<"查看私聊新信息">>};
get(11015) ->
    #ets_base_protocol{id = 11015, c2s = null,
		       s2c = pbprivate, memo = <<"请求私聊信息">>};
get(11016) ->
    #ets_base_protocol{id = 11016, c2s = pbfeedbackmsg,
		       s2c = pbfeedbackmsg, memo = <<"请求反馈信息">>};
get(11020) ->
    #ets_base_protocol{id = 11016, c2s = pbchat,
		       s2c = null, memo = <<"工会聊天">>};
get(11021) ->
    #ets_base_protocol{id = 11016, c2s = pbid32,
		       s2c = pbchatlist, memo = <<"请求工会聊天">>};
get(11030) ->
    #ets_base_protocol{id = 11030, c2s = pbchat,
		       s2c = pbchat, memo = <<"帮派聊天">>};
get(11050) ->
    #ets_base_protocol{id = 11050, c2s = pbchat,
		       s2c = pbchat, memo = <<"附近聊天">>};
get(11060) ->
    #ets_base_protocol{id = 11060, c2s = pbchat,
		       s2c = pbchat, memo = <<"小喇叭">>};
get(11070) ->
    #ets_base_protocol{id = 11070, c2s = pbchat,
		       s2c = phchat, memo = <<"私聊">>};
get(11071) ->
    #ets_base_protocol{id = 11071, c2s = null, s2c = pbchat,
		       memo = <<"私聊黑名单提示">>};
get(11072) ->
    #ets_base_protocol{id = 11072, c2s = null, s2c = pbchat,
		       memo = <<"私聊不在线">>};
get(11080) ->
    #ets_base_protocol{id = 11080, c2s = null, s2c = pbchatlist,
		       memo = <<"系统信息">>};
get(11081) ->
    #ets_base_protocol{id = 11081, c2s = null, s2c = pbchat,
		       memo = <<"中央信息提示">>};
get(11082) ->
    #ets_base_protocol{id = 11082, c2s = null, s2c = pbchat,
		       memo = <<"悬浮窗提示">>};
get(12001) ->
    #ets_base_protocol{id = 12001, c2s = pbdungeon,
		       s2c = pbdungeon, memo = <<"进入关卡">>};
get(12002) ->
    #ets_base_protocol{id = 12002, c2s = pbdungeon,
		       s2c = null, memo = <<"通关领取奖励">>};
get(12003) ->
    #ets_base_protocol{id = 12003, c2s = null, s2c = null,
		       memo = <<"副本复活扣钱">>};
get(12004) ->
    #ets_base_protocol{id = 12004, c2s = pbchallengedungeon, s2c = null,
		       memo = <<"极限副本变更信息">>};
get(12005) ->
    #ets_base_protocol{id = 12005, c2s = null, s2c = pbchallengedungeonrank,
		       memo = <<"极限副本排行榜信息">>};
get(12006) ->
    #ets_base_protocol{id = 12006, c2s = null, s2c = pbchallengedungeonrank,
		       memo = <<"超级副本排行榜信息">>};
get(12007) ->
    #ets_base_protocol{id = 12007, c2s = pbchallengedungeon, s2c = null,
		       memo = <<"公平竞技变更信息">>};
get(12008) ->
    #ets_base_protocol{id = 12008, c2s = pbdailydungeon, s2c = null,
		       memo = <<"日常副本领奖">>};
get(12010) ->
    #ets_base_protocol{id = 12010, c2s = pbflipcard, s2c = pbflipcard,
		       memo = <<"副本翻牌">>};
get(12011) ->
    #ets_base_protocol{id = 12011, c2s = pbid32, s2c = null,
		       memo = <<"购买血瓶">>};
get(12020) ->
    #ets_base_protocol{id = 12020, c2s = null, s2c = pbchallengedungeon,
		       memo = <<"登陆获取极限副本信息">>};
get(12021) ->
    #ets_base_protocol{id = 12021, c2s = pbid32, s2c = null,
		       memo = <<"极限格斗跳关">>};
get(12025) ->
    #ets_base_protocol{id = 12025, c2s = pbid64, s2c = null,
		       memo = <<"好友挑战极限副本">>};
get(12026) ->
    #ets_base_protocol{id = 12026, c2s = pbid64, s2c = null,
		       memo = <<"给好友投幸运币">>};
get(12030) ->
    #ets_base_protocol{id = 12030, c2s = null, s2c = pbchallengedungeon,
		       memo = <<"登陆获取公平竞技信息">>};
get(12031) ->
    #ets_base_protocol{id = 12031, c2s = null, s2c = null,
		       memo = <<"公平竞技重新挑战">>};
get(12032) ->
    #ets_base_protocol{id = 12032, c2s = null, s2c = null,
		       memo = <<"公平竞技购买次数">>};
get(12040) ->
    #ets_base_protocol{id = 12040, c2s = pbid32r, s2c = pbdungeonschedule,
		       memo = <<"副本进度信息">>};
get(12041) ->
    #ets_base_protocol{id = 12041, c2s = null, s2c = pbwinrate,
		       memo = <<"副本胜率查询">>};
get(12042) ->
    #ets_base_protocol{id = 12041, c2s = pbid32, s2c = null,
		       memo = <<"王者副本购买次数">>};
get(12043) ->
    #ets_base_protocol{id = 12043, c2s = pbmopuplist, s2c = pbmopuplist,
		       memo = <<"王者副本购买次数">>};
get(12050) ->
    #ets_base_protocol{id = 12050, c2s = null, s2c = pbdailydungeon,
		       memo = <<"日常副本信息">>};
get(12060) ->
    #ets_base_protocol{id = 12060, c2s = null, s2c = pbsourcedungeon,
		       memo = <<"日常资源副本信息">>};

get(13001) ->
    #ets_base_protocol{id = 13001, c2s = null, s2c = pbuser,
		       memo = <<"加载玩家信息">>};
get(13002) ->
    #ets_base_protocol{id = 13002, c2s = null, s2c = pbuser,
		       memo = <<"获取玩家二级属性">>};
get(13003) ->
    #ets_base_protocol{id = 13003, c2s = pbid64,
		       s2c = pbuser, memo = <<"获取玩家二级属性">>};
get(13004) ->
    #ets_base_protocol{id = 13004, c2s = pbid64r,
		       s2c = pbuserlist, memo = <<"获取指定玩家的信息">>};
get(13005) ->
    #ets_base_protocol{id = 13005, c2s = null,
		       s2c = pbhelpbattle, memo = <<"玩家上线 ，提示助战获取的友情值">>};
get(13006) ->
    #ets_base_protocol{id = 13006, c2s = pbid32r, s2c = null,
		       memo = <<"更新玩家的新手流程步骤">>};
get(13007) ->
    #ets_base_protocol{id = 13007, c2s = null, s2c = null,
		       memo = <<"领取登陆奖励">>};
get(13008) ->
    #ets_base_protocol{id = 13008, c2s = pbid64r, s2c = pbarenauserlist,
		       memo = <<"获取竞技场玩家信息">>};
get(13009) ->
    #ets_base_protocol{id = 13008, c2s = null, s2c = null,
		       memo = <<"领取月签到登陆奖励">>};

get(13010) ->
    #ets_base_protocol{id = 13010, c2s = null, s2c = null,
		       memo = <<"购买体力">>};
get(13011) ->
    #ets_base_protocol{id = 13011, c2s = null, s2c = null,
		       memo = <<"购买好友格子">>};
get(13013) ->
    #ets_base_protocol{id = 13013, c2s = null,
		       s2c = pbchangebuff, memo = <<"新增玩家的buff信息">>};
get(13014) ->
    #ets_base_protocol{id = 13014, c2s = null,
		       s2c = pbchangebuff, memo = <<"新增、删除、更新指定玩家的buff信息">>};
get(13018) ->
    #ets_base_protocol{id = 13018, c2s = null, s2c = pbuser,
		       memo = <<"更新指定玩家的一部分角色信息">>};
get(13019) ->
    #ets_base_protocol{id = 13019, c2s = null, s2c = null,
		       memo = <<"提示客户端角色升级">>};

get(13020) ->
    #ets_base_protocol{id = 13020, c2s = null, s2c = pbvipreward,
		       memo = <<"VIP礼包状况">>};
get(13021) ->
    #ets_base_protocol{id = 13021, c2s = pbid32, s2c = null,
		       memo = <<"领取VIP礼包">>};

get(13140) ->
    #ets_base_protocol{id = 13140, c2s = pbid64, 
                       s2c = pbpvprobotattr,
		       memo = <<"获取机器人。">>};
get(13141) ->
    #ets_base_protocol{id = 13141, c2s = pbid64, 
                       s2c = pbpvprobotattr,
		       memo = <<"获取机器人。">>};
get(13150) ->
    #ets_base_protocol{id = 13150, c2s = pbid64r, s2c = null,
		       memo = <<"查找好友数据。">>};
get(13151) ->
    #ets_base_protocol{id = 13151, c2s = pbid64, s2c = null,
		       memo = <<"申请加好友">>};
get(13152) ->
    #ets_base_protocol{id = 13152, c2s = pbid64, s2c = null,
		       memo = <<"拒绝好友申请">>};
get(13153) ->
    #ets_base_protocol{id = 13153, c2s = pbid64, s2c = null,
		       memo = <<"确认好友请求">>};
get(13154) ->
    #ets_base_protocol{id = 13154, c2s = pbid64, s2c = null,
		       memo = <<"删除好友">>};
get(13155) ->
    #ets_base_protocol{id = 13155, c2s = null, s2c = null,
		       memo = <<"获取好友列表">>};
get(13156) ->
    #ets_base_protocol{id = 13156, c2s = null, s2c = null,
		       memo = <<"获取好友列表">>};
get(13170) ->
    #ets_base_protocol{id = 13170, c2s = null,
		       s2c = pbplayertrial, memo = <<"小助手数据查询">>};
get(13171) ->
    #ets_base_protocol{id = 13171, c2s = null,
		       s2c = pbplayertrial, memo = <<"通知客户端小助手数据更新">>};
get(13172) ->
    #ets_base_protocol{id = 13172, c2s = pbtrial,
		       s2c = pbplayertrial, memo = <<"领取小助手奖励">>};
get(13173) ->
    #ets_base_protocol{id = 13173, c2s = pbtrial,
		       s2c = pbtrial, memo = <<"找回试炼">>};
get(13200) ->
    #ets_base_protocol{id = 13200, c2s = pbid32, s2c = null,
		       memo = <<"创建队伍">>};
get(13201) ->
    #ets_base_protocol{id = 13201, c2s = pbid32r, s2c = pbteam,
		       memo = <<"邀请好友">>};
get(13202) ->
    #ets_base_protocol{id = 13202, c2s = pbteam, s2c = null,
		       memo = <<"接受邀请">>};
get(13203) ->
    #ets_base_protocol{id = 13202, c2s = pbid32, s2c = null,
		       memo = <<"踢出玩家">>};
get(13204) ->
    #ets_base_protocol{id = 13204, c2s = null, s2c = null,
		       memo = <<"离开队伍">>};
get(13205) ->
    #ets_base_protocol{id = 13205, c2s = null, s2c = pbteam,
		       memo = <<"查看队伍信息">>};
get(13206) ->
    #ets_base_protocol{id = 13206, c2s = null, s2c = null,
		       memo = <<"准备">>};
get(13207) ->
    #ets_base_protocol{id = 13207, c2s = null, s2c = null,
		       memo = <<"开始副本">>};
get(13208) ->
    #ets_base_protocol{id = 13208, c2s = pbteamchat, s2c = pbteamchat,
		       memo = <<"组队聊天">>};
get(13209) ->
    #ets_base_protocol{id = 13209, c2s = pbid32, s2c = null,
		       memo = <<"约战">>};
get(13300) ->
    #ets_base_protocol{id = 13300, c2s = pbid32, s2c = pbskill,
		       memo = <<"人物技能升级">>};
get(13301) ->
    #ets_base_protocol{id = 13301, c2s = pbid32, s2c = pbskill,
		       memo = <<"人物技能强化">>};
get(13305) ->
    #ets_base_protocol{id = 13305, c2s = pbsigil, s2c = pbskill,
		       memo = <<"切换符印">>};
get(13310) ->
    #ets_base_protocol{id = 13310, c2s = pbid32r, s2c = null,
		       memo = <<"绑定主动技能">>};
get(13333) ->
    #ets_base_protocol{id = 13333, c2s = null, s2c = pbskilllist,
		       memo = <<"获取技能列表">>};
get(13400) ->
    #ets_base_protocol{id = 13400, c2s = pbid32, s2c = null,
		       memo = <<"战斗力发送">>};
get(13401) ->
    #ets_base_protocol{id = 13401, c2s = pbid64r, s2c = pbcombatattrilist,
                       memo = <<"查询战斗属性">>};
get(13500) ->
    #ets_base_protocol{id = 13500, c2s = null, s2c = pbuserlist,
		       memo = <<"附近的人">>};
get(13501) ->
    #ets_base_protocol{id = 13501, c2s = null, s2c = pbcombatrespon,
		       memo = <<"附近的人">>};
get(13600) ->
    #ets_base_protocol{id = 13500, c2s = null, s2c = pbnoticelist,
    		   memo = <<"公告推送信息">>}; 	
get(13601) ->
    #ets_base_protocol{id = 13601, c2s = null, s2c = pbid32,
                       memo = <<"获取剩余Q券">>};
get(13602) ->
    #ets_base_protocol{id = 13602, c2s = pbidstring, s2c = null,
                       memo = <<"绑定QQ">>};
get(13800) ->
    #ets_base_protocol{id = 13800, c2s = pbrefreshpassive,
		       s2c = pbuser, memo = <<"切换主将技能">>};
get(13801) ->
    #ets_base_protocol{id = 13801, c2s = pbrefreshpassive,
		       s2c = pbrefreshpassive, memo = <<"开启被技能栏">>};
get(13802) ->
    #ets_base_protocol{id = 13802, c2s = pbrefreshpassive,
		       s2c = pbrefreshpassive, memo = <<"刷新被动技能">>};
get(13803) ->
    #ets_base_protocol{id = 13803, c2s = pbrefreshpassive,
		       s2c = pbrefreshpassive, memo = <<"保存被动技能栏">>};
get(13810) ->
    #ets_base_protocol{id = 13810, c2s = null, s2c = pbuser,
		       memo = <<"领取军衔俸禄">>};
get(13900) ->
    #ets_base_protocol{id = 13900, c2s = null,
		       s2c = pbid64r, memo = <<"获取参战伙伴列表">>};
get(14000) ->
    #ets_base_protocol{id = 14000, c2s = null,
		       s2c = pbfriendlist, memo = <<"获取好友列表">>};
get(14001) ->
    #ets_base_protocol{id = 14001, c2s = pbfriend,
		       s2c = pbresult, memo = <<"添加好友：0失败1成功">>};
get(14002) ->
    #ets_base_protocol{id = 14002, c2s = pbid64,
		       s2c = pbresult, memo = <<"回应添加好友信息：0拒绝1允许">>};
get(14003) ->
    #ets_base_protocol{id = 14003, c2s = pbfriend,
		       s2c = pbresult, memo = <<"删除好友：0失败1成功">>};
get(14004) ->
    #ets_base_protocol{id = 14004, c2s = pbid64,
		       s2c = pbresult, memo = <<"添加黑名单：0失败1成功2黑名单已满">>};
get(14005) ->
    #ets_base_protocol{id = 14005, c2s = pbid64,
		       s2c = pbresult, memo = <<"添加仇人：0失败1成功">>};
get(14007) ->
    #ets_base_protocol{id = 14007, c2s = null,
		       s2c = pbfriendlist, memo = <<"请求黑名单列表">>};
get(14008) ->
    #ets_base_protocol{id = 14008, c2s = null,
		       s2c = pbfriendlist, memo = <<"请求仇人列表">>};
get(14010) ->
    #ets_base_protocol{id = 14010, c2s = pbfriend,
		       s2c = pbfriend, memo = <<"查找角色">>};
get(14013) ->
    #ets_base_protocol{id = 14013, c2s = pbid64,
		       s2c = pbfriend, memo = <<"查询陌生人">>};
get(14014) ->
    #ets_base_protocol{id = 14014, c2s = null,
		       s2c = pbfriendlist, memo = <<"获取最近联系人列表">>};
get(14017) ->
    #ets_base_protocol{id = 14017, c2s = null,
		       s2c = pbfriend, memo = <<"通知好友成员亲密度变化">>};
get(14018) ->
    #ets_base_protocol{id = 14018, c2s = null,
		       s2c = pbfriend, memo = <<"通知好友成员场景信息变化">>};
get(14019) ->
    #ets_base_protocol{id = 14019, c2s = null,
		       s2c = pbfriend, memo = <<"通知最近联系人场景信息变化">>};
get(14020) ->
    #ets_base_protocol{id = 14020, c2s = pbfriend,
		       s2c = pbresult, memo = <<"删除黑名单角色：0失败1成功">>};
get(14021) ->
    #ets_base_protocol{id = 14021, c2s = pbfriend,
		       s2c = pbresult, memo = <<"删除仇人角色：0失败1成功">>};
get(14030) ->
    #ets_base_protocol{id = 14030, c2s = null,
		       s2c = pbfriend, memo = <<"好友上下线通知">>};
get(14031) ->
    #ets_base_protocol{id = 14031, c2s = null,
		       s2c = pbfriend, memo = <<"仇人上下线通知">>};
get(14032) ->
    #ets_base_protocol{id = 14032, c2s = null,
		       s2c = pbfriend, memo = <<"最近联系人上下线通知">>};
get(14055) ->
    #ets_base_protocol{id = 14055, c2s = null,
		       s2c = pbfriendlist, memo = <<"请求推荐好友人列表信息">>};
get(14056) ->
    #ets_base_protocol{id = 14056, c2s = pbid64,
		       s2c = pbfriend, memo = <<"请求好友的详细信息">>};
get(14061) ->
    #ets_base_protocol{id = 14061, c2s = null,
		       s2c = pbfriend, memo = <<"通知好友列表成员的等级变化">>};
get(14062) ->
    #ets_base_protocol{id = 14062, c2s = null,
		       s2c = pbfriend, memo = <<"通知最近联系人成员的等级变化">>};
get(15000) ->
    #ets_base_protocol{id = 15000, c2s = null,
		       s2c = pbgoodslist, memo = <<"获取所有物品列表-包括装备">>};
get(15001) ->
    #ets_base_protocol{id = 15001, c2s = null,
		       s2c = pbgoodschanged, memo = <<"通知客户端物品变更">>};
get(15008) ->
    #ets_base_protocol{id = 15008, c2s = pbid64r,
		       s2c = pbgoods, memo = <<"查看别人的物品信息">>};
get(15010) ->
    #ets_base_protocol{id = 15010, c2s = pbid32,
                       s2c = null, memo = <<"分解装备">>};
get(15020) ->
    #ets_base_protocol{id = 15020, c2s = pbsmriti, s2c = pbsmriti,
		       memo = <<"装备传承">>};
get(15030) ->
    #ets_base_protocol{id = 15030, c2s = pbshopitem, s2c = null,
		       memo = <<"装备兑换">>};
get(15022) ->
    #ets_base_protocol{id = 15022, c2s = null,
		       s2c = pbcontainer, memo = <<"扩充背包">>};
get(15023) ->
    #ets_base_protocol{id = 15023, c2s = pbid32,
		       s2c = pbcontainer, memo = <<"扩充仓库">>};
get(15100) ->
    #ets_base_protocol{id = 15100, c2s = pbequipmove,
		       s2c = null, memo = <<"穿戴装备|更换装备">>};
get(15101) ->
    #ets_base_protocol{id = 15101, c2s = pbequipmove,
		       s2c = null, memo = <<"脱下装备">>};
get(15102) ->
    #ets_base_protocol{id = 15102, c2s = pbgoodslist,
		       s2c = null, memo = <<"技能卡装备">>};

get(15103) ->
    #ets_base_protocol{id = 15103, c2s = null,
		       s2c = pbskillidlist, memo = <<"获取技能卡记录">>};

get(15104) ->
    #ets_base_protocol{id = 15104, c2s = pbsmriti,
		       s2c = null, memo = <<"紫色装备属性转移为橙色装备">>};

get(15110) ->
    #ets_base_protocol{id = 15110, c2s = pbid32,
		       s2c = null, memo = <<"购买时装">>};

get(15200) ->
    #ets_base_protocol{id = 15200, c2s = pbequipstrengthen,
		       s2c = pbid32r, memo = <<"装备强化">>};
get(15201) ->
    #ets_base_protocol{id = 15201, c2s = pbequipaddstar,
		       s2c = pbid32r, memo = <<"装备升星">>};
get(15202) ->
    #ets_base_protocol{id = 15202, c2s = pbupgradeskillcard,
		       s2c = null, memo = <<"技能卡升级">>};
get(15300) ->
    #ets_base_protocol{id = 15300, c2s = pbid32,
		       s2c = null, memo = <<"勋章升级">>};
get(15301) ->
    #ets_base_protocol{id = 15301, c2s = null,
		       s2c = null, memo = <<"获取勋章">>};
get(15401) ->
    #ets_base_protocol{id = 15401, c2s = pbinlaidjewel,
		       s2c = null, memo = <<"宝石镶嵌">>};
get(15402) ->
    #ets_base_protocol{id = 15402, c2s = pbinlaidjewel,
		       s2c = null, memo = <<"宝石合成">>};
get(15403) ->
    #ets_base_protocol{id = 15403, c2s = pbinlaidjewel,
		       s2c = null, memo = <<"宝石摘除">>};
get(15404) ->
    #ets_base_protocol{id = 15404, c2s = pbinlaidjewel,
		       s2c = null, memo = <<"所有宝石摘除">>};
get(15500) ->
    #ets_base_protocol{id = 15404, c2s = null,
		       s2c = pbrewardlist, memo = <<"弹出客户端奖励">>};
get(15501) ->
    #ets_base_protocol{id = 15501, c2s = null,
		       s2c = pbsteriousshop, memo = <<"神秘商店之请求获取">>};
get(15502) ->
    #ets_base_protocol{id = 15502, c2s = null,
		       s2c = pbsteriousshop, memo = <<"神秘商店之请求刷新">>};
get(15503) ->
    #ets_base_protocol{id = 15503, c2s = pbshopbuy,
		       s2c = null, memo = <<"神秘商店之购买物品">>};

get(15504) ->
    #ets_base_protocol{id = 15504, c2s = null,
		       s2c = pbsteriousshop, memo = <<"竞技场神秘商店之请求获取">>};
get(15505) ->
    #ets_base_protocol{id = 15505, c2s = null,
		       s2c = pbsteriousshop, memo = <<"竞技场神秘商店之请求刷新">>};
get(15506) ->
    #ets_base_protocol{id = 15506, c2s = pbshopbuy,
		       s2c = null, memo = <<"竞技场神秘商店之购买商品">>};

get(15510) ->
    #ets_base_protocol{id = 15510, c2s = null,
		       s2c = pbsellinglist, memo = <<"商城之热卖物品列表">>};
get(15511) ->
    #ets_base_protocol{id = 15511, c2s = pbordinarybuy,
		       s2c = null, memo = <<"商城之购买物品">>};
get(15512) ->
    #ets_base_protocol{id = 15510, c2s = null,
		       s2c = pbsellinglist, memo = <<"获取竞技场热卖商品列表">>};
get(15513) ->
    #ets_base_protocol{id = 15511, c2s = pbordinarybuy,
		       s2c = null, memo = <<"竞技场商场之购买商品">>};

get(15555) ->
    #ets_base_protocol{id = 15511, c2s = null,
		       s2c = pbactivityshop, memo = <<"获取抢购活动信息">>};
get(15556) ->
    #ets_base_protocol{id = 15511, c2s = pbshopitem,
		       s2c = null, memo = <<"抢购商品">>};
get(15520) ->
    #ets_base_protocol{id = 15520, c2s = pbitemshop,
		       s2c = pbitemshop, memo = <<"购买物品">>};
get(15521) ->
    #ets_base_protocol{id = 15521, c2s = pbid64r,
		       s2c = pbitemshop, memo = <<"出售物品">>};
get(15522) ->
    #ets_base_protocol{id = 15522, c2s = null,
		       s2c = pbitemshop, memo = <<"刷新神秘商店物品">>};
get(15523) ->
    #ets_base_protocol{id = 15523, c2s = pbitemexchange,
		       s2c = pbitemexchange, memo = <<"拆分物品">>};
get(15525) ->
    #ets_base_protocol{id = 15525, c2s = null,
		       s2c = pbitemshop, memo = <<"获取道具店回购列表">>};
get(15526) ->
    #ets_base_protocol{id = 15526, c2s = pbitem,
		       s2c = pbitem, memo = <<"回购指定的物品">>};
get(15530) ->
    #ets_base_protocol{id = 15530, c2s = pbitemexchange,
		       s2c = pbitemexchange, memo = <<"更换装备">>};
get(15531) ->
    #ets_base_protocol{id = 15531, c2s = pbid64,
		       s2c = pbitemexchange, memo = <<"卸下装备">>};
get(15532) ->
    #ets_base_protocol{id = 15532, c2s = null,
		       s2c = pbitemcontainer, memo = <<"整理仓库">>};
get(15533) ->
    #ets_base_protocol{id = 15533, c2s = null,
		       s2c = pbresourcesexchange, memo = <<"获取体力剩余使用信息">>};
get(15534) ->
    #ets_base_protocol{id = 15534, c2s = null,
		       s2c = pbresourcesexchange, memo = <<"购买体力">>};
get(15535) ->
    #ets_base_protocol{id = 15535, c2s = pbitemexchange,
		       s2c = null, memo = <<"快速换装">>};
get(15536) ->
    #ets_base_protocol{id = 15536, c2s = pbitemexchange,
		       s2c = null, memo = <<"变武器">>};
get(15540) ->
    #ets_base_protocol{id = 15540, c2s = pbitemexchange,
		       s2c = pbitemexchange, memo = <<"背包中拖动物品">>};
get(15541) ->
    #ets_base_protocol{id = 15541, c2s = pbitemexchange,
		       s2c = pbitemexchange, memo = <<"背包和仓库之间拖动物品">>};
get(15547) ->
    #ets_base_protocol{id = 15547, c2s = null,
		       s2c = pbresourcesexchange, memo = <<"查询招财符剩余使用次数">>};
get(15548) ->
    #ets_base_protocol{id = 15548, c2s = pbid32,
		       s2c = pbresourcesexchange, memo = <<"使用招财符">>};
get(15550) ->
    #ets_base_protocol{id = 15550, c2s = pbitem,
		       s2c = pbitem, memo = <<"使用物品">>};
get(15551) ->
    #ets_base_protocol{id = 15551, c2s = pbitem,
		       s2c = pbitem, memo = <<"丢弃物品">>};
get(15552) ->
    #ets_base_protocol{id = 15552, c2s = null,
		       s2c = pbitemcontainer, memo = <<"整理背包">>};
get(15554) ->
    #ets_base_protocol{id = 15554, c2s = pbid64,
		       s2c = pbitem, memo = <<"强化装备">>};
get(15560) ->
    #ets_base_protocol{id = 15560, c2s = pbid32,
		       s2c = pbgeneralstoreinfo, memo = <<"获取神秘商城信息">>};
get(15561) ->
    #ets_base_protocol{id = 15561, c2s = pbid32,
		       s2c = pbgeneralstoreinfo, memo = <<"刷新神秘商城">>};
get(15562) ->
    #ets_base_protocol{id = 15562, c2s = pbgeneralstorebuy,
		       s2c = pbgeneralstorebuy, memo = <<"神秘商城购买">>};

get(15570) ->
    #ets_base_protocol{id = 15570, c2s = pbitem,
		       s2c = pbitem, memo = <<"装备进阶，将装备进阶为新的装备">>};
get(15571) ->
    #ets_base_protocol{id = 15571, c2s = pbitem,
		       s2c = pbitem, memo = <<"装备升级">>};
get(15580) ->
    #ets_base_protocol{id = 15580, c2s = pbrewardlist,
		       s2c = pbreward, memo = <<"查询奖励列表">>};
get(15581) ->
    #ets_base_protocol{id = 15581, c2s = pbrewardlist,
		       s2c = pbreward, memo = <<"领取奖励列表">>};
get(15583) ->
    #ets_base_protocol{id = 15583, c2s = null, s2c = pbid32,
		       memo = <<"查看下次能领取在线奖励的时间戳">>};
get(15584) ->
    #ets_base_protocol{id = 15584, c2s = null, s2c = pbid32,
		       memo = <<"查看签到开放了木有">>};
get(15585) ->
    #ets_base_protocol{id = 15585, c2s = pbid32,
		       s2c = pbresourcesexchange,
		       memo = <<"查询当月已补签的次数和可以补签的次数">>};
get(15586) ->
    #ets_base_protocol{id = 15586, c2s = pbid32, s2c = null,
		       memo = <<"补签">>};
get(15587) ->
    #ets_base_protocol{id = 15587, c2s = null, s2c = null,
		       memo = <<"有奖励通知协议">>};
get(15590) ->
    #ets_base_protocol{id = 15590, c2s = null, s2c = pbid32,
		       memo = <<"通知客户端有新的装备">>};
get(15600) ->
    #ets_base_protocol{id = 15600, c2s = null, s2c = null,
		       memo = <<"领取更新奖励">>};
get(15601) ->
    #ets_base_protocol{id = 15601, c2s = pbgift, s2c = null,
		       memo = <<"礼包领取">>};
get(15700) ->
    #ets_base_protocol{id = 15700, c2s = null, s2c = null,
		       memo = <<"群雄争霸军粮购买协议">>};
get(15801) ->
    #ets_base_protocol{id = 15801, c2s = pbid32,
		       s2c = pbstoreproductlist, memo = <<"充值商店物品">>};
get(15900) ->
    #ets_base_protocol{id = 15900, c2s = null,
		       s2c = pbchoujianginfo, memo = <<"请求抽奖信息">>};
get(15901) ->
    #ets_base_protocol{id = 15901, c2s = pbchoujiang,
		       s2c = pbchoujiangresult, memo = <<"抽奖">>};
get(15910) ->
    #ets_base_protocol{id = 15910, c2s = pbid32,
		       s2c = null, memo = <<"充值">>};
get(15911) ->
    #ets_base_protocol{id = 15911, c2s = pbid32,
		       s2c = null, memo = <<"获取首充奖励">>};
get(15912) ->
    #ets_base_protocol{id = 15912, c2s = pbcdkreward,
		       s2c = null, memo = <<"获取CDKey奖励">>};

get(16001) ->
    #ets_base_protocol{id = 16001, c2s = null,
		       s2c = pbfashionlist, memo = <<"时装背包">>};
get(16002) ->
    #ets_base_protocol{id = 16002, c2s = pbfashionlist,
		       s2c = null, memo = <<"却换时装">>};
get(16003) ->
    #ets_base_protocol{id = 16003, c2s = pbid64,
		       s2c = pbfashionlist, memo = <<"查看别人的时装">>};

get(17000) ->
    #ets_base_protocol{id = 17000, c2s = null,
		       s2c = pbbosslist, memo = <<"获取boss列表">>};
get(17001) ->
    #ets_base_protocol{id = 17001, c2s = null,
		       s2c = pbworldboss, memo = <<"boss变更">>};
get(17010) ->
    #ets_base_protocol{id = 17010, c2s = pbworldboss,
		       s2c = pbworldboss, memo = <<"boss开启">>};
get(17011) ->
    #ets_base_protocol{id = 17011, c2s = pbworldboss,
		       s2c = null, memo = <<"进入boss场景">>};
get(17012) ->
    #ets_base_protocol{id = 17012, c2s = pbworldboss,
		       s2c = null, memo = <<"挑战boss">>};
get(17014) ->
    #ets_base_protocol{id = 17014, c2s = pbworldboss,
		       s2c = null, memo = <<"离开boss场景">>};
get(19001) ->
    #ets_base_protocol{id = 19001, c2s = pbmail,
		       s2c = pbid32, memo = <<"客户端发邮件">>};
get(19002) ->
    #ets_base_protocol{id = 19002, c2s = pbmail,
		       s2c = pbmaillist, memo = <<"提取附件">>};
get(19003) ->
    #ets_base_protocol{id = 19003, c2s = pbid32,
		       s2c = pbmaillist, memo = <<"删除信件">>};
get(19004) ->
    #ets_base_protocol{id = 19004, c2s = null,
		       s2c = pbmaillist, memo = <<"获取邮件列表">>};
get(19005) ->
    #ets_base_protocol{id = 19005, c2s = pbmail,
		       s2c = pbid32, memo = <<"发送系统邮件">>};
get(22011) ->
    #ets_base_protocol{id = 22011, c2s = pbrankquery,
		       s2c = pbrankboard, memo = <<"请求排行榜 ">>};
get(22100) ->
    #ets_base_protocol{id = 22100, c2s = pbrankquery,
		       s2c = pbpartnerrankboard, memo = <<"查询单挑排行榜">>};
get(23000) ->
    #ets_base_protocol{id = 23000, c2s = null,
		       s2c = pbarenainfo, memo = <<"查看竞技状态信息">>};
get(23001) ->
    #ets_base_protocol{id = 23001, c2s = null,
		       s2c = pbarenainfolist, memo = <<"获取随机玩家">>};
get(23002) ->
    #ets_base_protocol{id = 23002, c2s = pbarenachallenge,
		       s2c = null, memo = <<"挑战玩家">>};
get(23003) ->
    #ets_base_protocol{id = 23003, c2s = pbid32,
		       s2c = pbarenabattlereportlist, memo = <<"获取战报信息">>};
get(23005) ->
    #ets_base_protocol{id = 23001, c2s = null,
		       s2c = pbarenainfolist, memo = <<"异步排行榜">>};
get(23006) ->
    #ets_base_protocol{id = 23006, c2s = null,
		       s2c = null, memo = <<"购买次数">>};
get(23500) ->
    #ets_base_protocol{id = 23500, c2s = null,
		       s2c = pbcrossfighter, memo = <<"获取小组信息">>};
get(23501) ->
    #ets_base_protocol{id = 23002, c2s = pbarenachallenge,
		       s2c = pbcrossisland, memo = <<"攻击小岛">>};
get(23502) ->
    #ets_base_protocol{id = 23002, c2s = pbarenachallenge,
		       s2c = null, memo = <<"挑战玩家的结果">>};
%% get(23503) ->
%%     #ets_base_protocol{id = 23503, c2s = null,
%% 		       s2c = pbarenabattlereportlist, memo = <<"获取战报信息">>};
get(23504) ->
    #ets_base_protocol{id = 23504, c2s = null,
		       s2c = pbcrossfighter, memo = <<"购买挑战次数">>};
get(23505) ->
    #ets_base_protocol{id = 23505, c2s = pbid32,
		       s2c = pbcrossisland, memo = <<"重置小岛">>};

get(23506) ->
    #ets_base_protocol{id = 23506, c2s = null, s2c = null, memo = <<"领取奖励">>};
%% get(23505) ->
%%     #ets_base_protocol{id = 23505, c2s = null,
%% 		       s2c = pbcrosshistorylist, memo = <<"购买挑战次数">>};

get(24001) ->
    #ets_base_protocol{id = 24001, c2s = null,
		       s2c = pbranklist, memo = <<"战斗力排行榜">>};
get(24002) ->
    #ets_base_protocol{id = 24002, c2s = null,
		       s2c = pbranklist, memo = <<"等级排行榜">>};
get(24003) ->
    #ets_base_protocol{id = 24003, c2s = null,
		       s2c = pbranklist, memo = <<"玩家铜钱消费排行榜">>};
get(24004) ->
    #ets_base_protocol{id = 24004, c2s = null,
		       s2c = pbranklist, memo = <<"玩家金币消费排行榜">>};
get(24005) ->
    #ets_base_protocol{id = 24005, c2s = null,
		       s2c = pbranklist, memo = <<"世界boss排行榜">>};
get(30000) ->
    #ets_base_protocol{id = 30000, c2s = null,
		       s2c = pbtasklist, memo = <<"查看任务列表">>};
get(30001) ->
    #ets_base_protocol{id = 30001, c2s = null, s2c = pbtask,
		       memo = <<"放弃一个任务">>};
get(30004) ->
    #ets_base_protocol{id = 30004, c2s = null, s2c = pbtasklist,
		       memo = <<"任务变更">>};
get(30005) ->
    #ets_base_protocol{id = 30005, c2s = pbid32, s2c = null,
		       memo = <<"任务领奖">>};
get(30006) ->
    #ets_base_protocol{id = 30006, c2s = pbtask,
		       s2c = pbtask, memo = <<"完成任务">>};
get(30012) ->
    #ets_base_protocol{id = 30012, c2s = pbtasklist,
		       s2c = pbtasklist, memo = <<"接受委托任务">>};
get(30014) ->
    #ets_base_protocol{id = 30014, c2s = pbtasklist,
		       s2c = pbtasklist, memo = <<"立即完成委托任务">>};
get(30080) ->
    #ets_base_protocol{id = 30080, c2s = pbcamp,
		       s2c = pbcamp, memo = <<"选取阵营">>};
get(30082) ->
    #ets_base_protocol{id = 30082, c2s = pbtask,
		       s2c = pbtask, memo = <<"与NPC对话">>};
get(30100) ->
    #ets_base_protocol{id = 30100, c2s = pbtask, s2c = null,
		       memo = <<"客户端任务类型">>};
get(30900) ->
    #ets_base_protocol{id = 30900, c2s = null,
		       s2c = pbtasklist, memo = <<"获取任务状态列表">>};
get(30901) ->
    #ets_base_protocol{id = 30901, c2s = pbtask,
		       s2c = pbtask, memo = <<"领取任务">>};
get(30902) ->
    #ets_base_protocol{id = 30902, c2s = pbtask,
		       s2c = pbtask, memo = <<"提交任务">>};
get(31001) ->
    #ets_base_protocol{id = 31001, c2s = null,
		       s2c = pbkiloride, memo = <<"查询过关斩将数据">>};
get(31002) ->
    #ets_base_protocol{id = 31002, c2s = null, s2c = pbid32,
		       memo = <<"挑战当前关卡">>};
get(31003) ->
    #ets_base_protocol{id = 31003, c2s = pbid32, s2c = null,
		       memo = <<"领取宝箱">>};
get(31004) ->
    #ets_base_protocol{id = 31004, c2s = pbid32, s2c = null,
		       memo = <<"召唤NPC">>};
get(31005) ->
    #ets_base_protocol{id = 31005, c2s = null, s2c = null,
		       memo = <<"快速过关">>};
get(31006) ->
    #ets_base_protocol{id = 31006, c2s = null,
		       s2c = pbcombatreward, memo = <<"每5关星级奖励">>};
get(31007) ->
    #ets_base_protocol{id = 31007, c2s = null,
		       s2c = pbcombatreward, memo = <<"宝箱奖励">>};
get(32001) ->
    #ets_base_protocol{id = 32001, c2s = null,
		       s2c = pbplayerachievelist, memo = <<"当前进行的所有成就查询">>};
get(32002) ->
    #ets_base_protocol{id = 32002, c2s = pbplayerachieve,
		       s2c = pbplayerachievelist, memo = <<"领取成就奖励">>};
get(34001) ->
    #ets_base_protocol{id = 34001, c2s = null,
		       s2c = pbactivitylist, memo = <<"活动列表">>};
get(34002) ->
    #ets_base_protocol{id = 34002, c2s = pbtwistegg,
		       s2c = pbtwistegglist, memo = <<"扭蛋">>};
get(40000) ->
    #ets_base_protocol{id = 40000, c2s = pbgetleague,
		       s2c = pbleaguelist, memo = <<"查询工会列表">>};
get(40001) ->
    #ets_base_protocol{id = 40001, c2s = pbleague,
		       s2c = null, memo = <<"创建工会">>};
get(40002) ->
    #ets_base_protocol{id = 40002, c2s = null,
		       s2c = pbleague, memo = <<"查询工会">>};
get(40003) ->
    #ets_base_protocol{id = 40003, c2s = null,
		       s2c = pbleaguememberlist, memo = <<"工会成员列表">>};
get(40004) ->
    #ets_base_protocol{id = 40004, c2s = null,
		       s2c = null, memo = <<"离开工会">>};
get(40005) ->
    #ets_base_protocol{id = 40005, c2s = pbaddleaguemsg,
		       s2c = null, memo = <<"加入工会">>};
get(40006) ->
    #ets_base_protocol{id = 40006, c2s = pbid64,
		       s2c = null, memo = <<"踢出工会">>};
get(40007) ->
    #ets_base_protocol{id = 40007, c2s = pbleaguemember,
		       s2c = null, memo = <<"委任">>};
get(40008) ->
    #ets_base_protocol{id = 40008, c2s = pbleague,
		       s2c = null, memo = <<"修改帮派宣言">>};
get(40009) ->
    #ets_base_protocol{id = 40009, c2s = pbleague,
		       s2c = null, memo = <<"修改帮派允许加入战斗力">>};
get(40010) ->
    #ets_base_protocol{id = 40010, c2s = pbid32,
		       s2c = pbguild, memo = <<"取消帮派申请">>};
get(40011) ->
    #ets_base_protocol{id = 40011, c2s = pbid32,
		       s2c = pbguild, memo = <<"帮派职位变更">>};
get(40015) ->
    #ets_base_protocol{id = 40015, c2s = pbid64,
		       s2c = pbguild, memo = <<"踢出指定的帮派成员">>};
get(40019) ->
    #ets_base_protocol{id = 40019, c2s = pbguild,
		       s2c = pbguild, memo = <<"变更公告板内容">>};
get(40020) ->
    #ets_base_protocol{id = 40020, c2s = pbid64,
		       s2c = pbguild, memo = <<"通过某人的加入军团的请求">>};
get(40021) ->
    #ets_base_protocol{id = 40021, c2s = pbid64,
		       s2c = pbguild, memo = <<"拒绝某人的加入军团的请求">>};
get(40022) ->
    #ets_base_protocol{id = 40022, c2s = null,
		       s2c = pbguild, memo = <<"离开军团">>};
get(40030) ->
    #ets_base_protocol{id = 40030, c2s = null,
		       s2c = pbguild, memo = <<"设置军团界面关闭状态">>};
get(40031) ->
    #ets_base_protocol{id = 40031, c2s = null, s2c = null,
		       memo = <<"发送军团招募公告">>};
get(40040) ->
    #ets_base_protocol{id = 40040, c2s = null,
		       s2c = pbguildfightlist, memo = <<"查看军团战的状态">>};
get(40041) ->
    #ets_base_protocol{id = 40041, c2s = null,
		       s2c = pbguildfightmemberlist, memo = <<"查看军团战成员排名">>};
get(40043) ->
    #ets_base_protocol{id = 40043, c2s = null,
		       s2c = pbguildfightmemberlist, memo = <<"查看世界八强个人排名">>};
get(40044) ->
    #ets_base_protocol{id = 40044, c2s = null,
		       s2c = pbguildfightmember, memo = <<"查看积分战玩家状态信息">>};
get(40045) ->
    #ets_base_protocol{id = 40045, c2s = null, s2c = null,
		       memo = <<"领取积分战礼包">>};
get(40046) ->
    #ets_base_protocol{id = 40046, c2s = null, s2c = null,
		       memo = <<"应战">>};
get(40047) ->
    #ets_base_protocol{id = 40047, c2s = pbguildgambleinfo,
		       s2c = null, memo = <<"投注">>};
get(40048) ->
    #ets_base_protocol{id = 40048,
		       c2s = pbguildfightreportquery,
		       s2c = pbguildfightreportlist, memo = <<"查看军团战战报">>};
get(40050) ->
    #ets_base_protocol{id = 40050, c2s = pbid32, s2c = null,
		       memo = <<"查看八强战斗结束界面">>};
get(40051) ->
    #ets_base_protocol{id = 40051, c2s = pbguildfightswap,
		       s2c = pbguildfightswap, memo = <<"军团战交换出场顺序">>};
get(40052) ->
    #ets_base_protocol{id = 40052, c2s = null,
		       s2c = pbfightmemberlist, memo = <<"军团出场顺序">>};

get(40100) ->
    #ets_base_protocol{id = 40100, c2s = null,
		       s2c = pbowngifts, memo = <<"获取自身礼包信息">>};
get(40101) ->
    #ets_base_protocol{id = 40101, c2s = null,
		       s2c = pbleaguegifts, memo = <<"获取公会礼包信息">>};
get(40102) ->
    #ets_base_protocol{id = 40102, c2s = pbsendgiftsmsg,
		       s2c = pbleaguegifts, memo = <<"玩家单键发送礼包">>};
get(40103) ->
    #ets_base_protocol{id = 40103, c2s = null,
		       s2c = pbonekeysendmsg, memo = <<"玩家一键发送礼包">>};

get(40104) ->
    #ets_base_protocol{id = 40104, c2s = pbid32,
		       s2c = pbid32, memo = <<"领取工会礼包">>};
get(40105) ->
    #ets_base_protocol{id = 40105, c2s = null,
		       s2c = pbgiftsrecordlist, memo = <<"公会礼包历史记录">>};

get(40106) ->
    #ets_base_protocol{id = 40106, c2s = null,
		       s2c = pbleaguehouse, memo = <<"获取公会信息">>};

get(40107) ->
    #ets_base_protocol{id = 40107, c2s = pbmembergetlisttype,
		       s2c = pbmembersendlist, memo = <<"获取手速(发送及领取)榜">>};

get(40108) ->
    #ets_base_protocol{id = 40108, c2s = pbbosssendgold,
		       s2c = pbid32, memo = <<"会长花费公会礼金,发放红包">>};

get(40109) ->
    #ets_base_protocol{id = 40109, c2s = pbid32,
		       s2c = null, memo = <<"会长发送请求">>};

get(40110) ->
    #ets_base_protocol{id = 40110, c2s = null,
		       s2c = pbbossinvitemsg, memo = <<"玩家接受会长邀请">>};

get(40111) ->
    #ets_base_protocol{id = 40111, c2s = null,
		       s2c = pbid32, memo = <<"获取玩家双倍额度值">>};

get(40200) ->
    #ets_base_protocol{id = 40200, c2s = pbid32,
		       s2c = pbpointsendmsglist, memo = <<"请求指定发送红包列表">>};

get(40201) ->
    #ets_base_protocol{id = 40201, c2s = pbpointsend,
		       s2c = null, memo = <<"玩家指定发送红包">>};
get(40202) ->
    #ets_base_protocol{id = 40202, c2s = pbid32,
		       s2c = pbrequestgiftsmsglist, memo = <<"玩家请求索要红包信息">>};
get(40203) ->
    #ets_base_protocol{id = 40203, c2s = pbid32,
		       s2c = null, memo = <<"索要红包">>};
get(40204) ->
    #ets_base_protocol{id = 40204, c2s = null,
		       s2c = pbrequestplayergiftsmsglist, memo = <<"获取索要红包信息">>};
get(40205) ->
    #ets_base_protocol{id = 40205, c2s = pbid32,
		       s2c = null, memo = <<"同意索要红包">>};
get(40206) ->
    #ets_base_protocol{id = 40206, c2s = pbid32,
		       s2c = null, memo = <<"拒绝索要红包">>};
get(40207) ->
    #ets_base_protocol{id = 40207, c2s = null,
		       s2c = pbid32, memo = <<"是否有红包可领取">>};

get(40208) ->
    #ets_base_protocol{id = 40208, c2s = pbid32,
		       s2c = pbid32, memo = <<"分解礼包">>};

get(40300) ->
    #ets_base_protocol{id = 40300, c2s = null,
		       s2c = null, memo = <<"工会战报名">>};

get(40301) ->
    #ets_base_protocol{id = 40301, c2s = pbgetleaguegrouprankinfo,
		       s2c = pbleagueranklist, memo = <<"获取排行榜">>};

get(40302) ->
    #ets_base_protocol{id = 40302, c2s = null,
		       s2c = pbleaguefightrankinfo, memo = <<"获取自身公会排名信息">>};

get(40303) ->
    #ets_base_protocol{id = 40303, c2s = null,
		       s2c = pbleaguechallengelist, memo = <<"获取公会挑战列表">>};

get(40304) ->
    #ets_base_protocol{id = 40304, c2s = pbleaguechallengeresult,
		       s2c = null, memo = <<"处理公会单人挑战战报">>};

get(40305) ->
    #ets_base_protocol{id = 40305, c2s = pbid32,
		       s2c = pbleaguerecordlist, memo = <<"获取玩家挑战记录">>};

get(40306) ->
    #ets_base_protocol{id = 40306, c2s = pbid32,
		       s2c = null, memo = <<"检查玩家挑战条件">>};

get(40400) ->
    #ets_base_protocol{id = 40400, c2s = pbid32,
		       s2c = pbleaguefightpointlist, memo = <<"获取工会据点信息列表">>};

get(40401) ->
    #ets_base_protocol{id = 40401, c2s = pbid32,
		       s2c = pbpointprotectlist, memo = <<"获取据点守卫玩家信息列表">>};

get(40402) ->
    #ets_base_protocol{id = 40402, c2s = pbappointplayer,
		       s2c = null, memo = <<"指定玩家守卫据点">>};

get(40403) ->
    #ets_base_protocol{id = 40403, c2s = pbappointplayer,
		       s2c = null, memo = <<"取消玩家守卫据点">>};

get(40404) ->
    #ets_base_protocol{id = 40404, c2s = pbgetpointrecord,
		       s2c = pbpointchallengerecordinfo, memo = <<"获取据点挑战记录">>};

get(40405) ->
    #ets_base_protocol{id = 40405, c2s = pbleaguepointchallengeresult,
		       s2c = null, memo = <<"处理据点挑战战报">>};

get(40406) ->
    #ets_base_protocol{id = 40406, c2s = pbid32,
		       s2c = null, memo = <<"请求据点挑战">>};

get(40407) ->
    #ets_base_protocol{id = 40407, c2s = null,
		       s2c = pbleagueinfolist, memo = <<"获取公会信息">>};

get(40408) ->
    #ets_base_protocol{id = 40408, c2s = null,
		       s2c = pbid32, memo = <<"获取公会信息">>};
get(40409) ->
    #ets_base_protocol{id = 40409, c2s = null,
		       s2c = pbgetleaguestatu, memo = <<"获取军团当前状态">>};
get(40410) ->
    #ets_base_protocol{id = 40410, c2s = pbid64,
		       s2c = pbfightrecords, memo = <<"获取自己的挑战记录">>};
get(40411) ->
    #ets_base_protocol{id = 40411, c2s = pbid32,
		       s2c = pbcountrecords, memo = <<"获取指定军团的记录统计">>};

%% get(40405) ->
%%     #ets_base_protocol{id = 40405, c2s = pbleaguepointchallengeresult,
%% 		       s2c = null, memo = <<"处理据点挑战战报">>};

%% get(40406) ->
%%     #ets_base_protocol{id = 40406, c2s = pbid32,
%% 		       s2c = null, memo = <<"请求据点挑战">>};

%% get(40407) ->
%%     #ets_base_protocol{id = 40407, c2s = null,
%% 		       s2c = pbleagueinfolist, memo = <<"获取公会信息">>};

%% get(40408) ->
%%     #ets_base_protocol{id = 40408, c2s = null,
%% 		       s2c = pbid32, memo = <<"获取公会信息">>};

get(40500) ->
    #ets_base_protocol{id = 40500, c2s = pbg17guildquery,
		       s2c = pbleague, memo = <<"军团长创建g17公会">>};
get(40501) ->
    #ets_base_protocol{id = 40501, c2s = pbg17guildquery,
		       s2c = null, memo = <<"军团长申请加入g17公会">>};
get(40502) ->
    #ets_base_protocol{id = 40502, c2s = pbleaguemember,
		       s2c = null, memo = <<"军团长已加入g17,成员跟随加入">>};
get(40503) ->
    #ets_base_protocol{id = 40503, c2s = null,
		       s2c = null , memo = <<"退出g17公会">>};
get(40504) ->
    #ets_base_protocol{id = 40504, c2s = null,
		       s2c = pbg17guildlist, memo = <<"获取g17公会列表">>};
get(40505) ->
    #ets_base_protocol{id = 40505, c2s = null,
		       s2c = pbg17guild, memo = <<"查询自己的g17公会信息">>};
get(40506) ->
    #ets_base_protocol{id = 40506, c2s = null,
		       s2c = pbg17guildmember, memo = <<"查询自己的g17公会属性">>};
get(40507) ->
    #ets_base_protocol{id = 40507, c2s = null,
                       s2c = pbleaguelist, memo = <<"获取可加入公会属性">>};

get(40600) ->
    #ets_base_protocol{id = 40600, c2s = null,
                       s2c = pbowncardsinfo, memo = <<"获取技能卡（师傅和徒弟）">>};

get(40601) ->
    #ets_base_protocol{id = 40601, c2s = pbid32,
                       s2c = pbidstring, memo = <<"生成技能码">>};

get(40602) ->
    #ets_base_protocol{id = 40602, c2s = pbidstring,
                       s2c = null, memo = <<"由技能码获得技能卡">>};

get(40603) ->
    #ets_base_protocol{id = 40603, c2s = null,
                       s2c = pballmasterinfo, memo = <<"获取军团中所有师傅信息">>};

get(40604) ->
    #ets_base_protocol{id = 40604, c2s = pbidstring,
                       s2c = null, memo = <<"驱逐徒弟">>};

get(40605) ->
    #ets_base_protocol{id = 40605, c2s = pbidstring,
                       s2c = null, memo = <<"徒弟销毁技能卡">>};

get(40606) ->
    #ets_base_protocol{id = 40606, c2s = null,
                       s2c = pbcardrequestlist, memo = <<"获取所有技能卡的请求信息">>};

get(40607) ->
    #ets_base_protocol{id = 40607, c2s = pbmasteragreemsg,
                       s2c = null, memo = <<"同意接受徒弟">>};

get(40608) ->
    #ets_base_protocol{id = 40608, c2s = pbidstring,
                       s2c = null, memo = <<"领取出师奖励">>};

get(40609) ->
    #ets_base_protocol{id = 40609, c2s = pbidstring,
                       s2c = null, memo = <<"一键删除技能卡请求信息">>};

get(40610) ->
    #ets_base_protocol{id = 40610, c2s = pbapprenticebuycard,
                       s2c = null, memo = <<"购买师傅技能卡">>};

get(44000) ->
    #ets_base_protocol{id = 44000, c2s = pbid32,
		       s2c = pbplayercamp, memo = <<"获取玩家阵法信息">>};
get(44001) ->
    #ets_base_protocol{id = 44001, c2s = null,
		       s2c = pbcamplist, memo = <<"获取阵法角色的阵法列表">>};
get(44003) ->
    #ets_base_protocol{id = 44003, c2s = pbid32,
		       s2c = pbcampresult, memo = <<"切换阵法">>};
get(44008) ->
    #ets_base_protocol{id = 44008, c2s = pbcamplist,
		       s2c = pbcampresult, memo = <<"阵法信息改变">>};
get(44009) ->
    #ets_base_protocol{id = 44009, c2s = pbcamp, s2c = null,
		       memo = <<"保存阵法数据">>};
get(44100) ->
    #ets_base_protocol{id = 44100, c2s = pbcamp,
		       s2c = pbcamp, memo = <<"保存阵法信息">>};
get(44101) ->
    #ets_base_protocol{id = 44101, c2s = pbid32,
		       s2c = pbplayercamp, memo = <<"切换阵法">>};
get(45001) ->
    #ets_base_protocol{id = 45001, c2s = pbuser,
		       s2c = pbuser, memo = <<"获取伙伴信息">>};
get(45002) ->
    #ets_base_protocol{id = 45002, c2s = pbuser,
		       s2c = pbuser,
		       memo = <<"招募伙伴，结果：0招募成功，1队伍人数超上限，2声望值不够，3铜钱不够">>};
get(45003) ->
    #ets_base_protocol{id = 45003, c2s = pbuser,
		       s2c = pbuser, memo = <<"解散伙伴">>};
get(45004) ->
    #ets_base_protocol{id = 45004, c2s = null,
		       s2c = pbpartnerlist, memo = <<"获取招募列表">>};
get(45005) ->
    #ets_base_protocol{id = 45005, c2s = null,
		       s2c = pbpartnerlist, memo = <<"读取队伍列表">>};
get(45006) ->
    #ets_base_protocol{id = 45006, c2s = pbid64,
		       s2c = pbuser, memo = <<"武将突破">>};
get(45007) ->
    #ets_base_protocol{id = 45007, c2s = null,
		       s2c = pbpartnerlist, memo = <<"获取武将传数据">>};
get(45013) ->
    #ets_base_protocol{id = 45013, c2s = pbuser,
		       s2c = pbuser, memo = <<"再次招募伙伴">>};
get(45015) ->
    #ets_base_protocol{id = 45015, c2s = null,
		       s2c = pbpartnerlist, memo = <<"更新武将传数据">>};
get(45018) ->
    #ets_base_protocol{id = 45018, c2s = null, s2c = pbuser,
		       memo = <<"更新伙伴数据">>};
get(45020) ->
    #ets_base_protocol{id = 45020, c2s = pbuser,
		       s2c = pbuser,
		       memo =
			   <<"修改跟随伙伴数据，结果：0失败、1成功、2伙伴不归你所有、3vip等级不足、8系统错误">>};
get(45030) ->
    #ets_base_protocol{id = 45030, c2s = null,
		       s2c = pbtavern, memo = <<"查询酒馆数据">>};
get(45031) ->
    #ets_base_protocol{id = 45031, c2s = pbid32,
		       s2c = pbtavern,
		       memo = <<"进行酒馆进酒，1 - 绿色进酒；2 - 蓝色进酒；3 - 紫色进酒。">>};
get(45040) ->
    #ets_base_protocol{id = 45040, c2s = null,
		       s2c = pbpartnertraininglis, memo = <<"查询伙伴历练状态">>};
get(45041) ->
    #ets_base_protocol{id = 45041, c2s = pbpartnertraining,
		       s2c = pbpartnertraininglis, memo = <<"进行伙伴历练">>};
get(45042) ->
    #ets_base_protocol{id = 45042, c2s = pbid32,
		       s2c = pbpartnertraininglis, memo = <<"历练品质刷新">>};
get(45043) ->
    #ets_base_protocol{id = 45043, c2s = pbid32,
		       s2c = pbpartnertraininglis, memo = <<"vip历练品质刷新">>};
get(45044) ->
    #ets_base_protocol{id = 45044, c2s = null,
		       s2c = pbpartnertraininglis, memo = <<"开启新的历练位置">>};
get(45050) ->
    #ets_base_protocol{id = 45050, c2s = pbuser,
		       s2c = pbrecruit, memo = <<"伙伴封禅数据">>};
get(46301) ->
    #ets_base_protocol{id = 46301, c2s = null, s2c = pbuser,
		       memo = <<"查询灵兽信息">>};
get(46302) ->
    #ets_base_protocol{id = 46302, c2s = null,
		       s2c = pbbeasttrainres, memo = <<"灵兽培养">>};
get(46303) ->
    #ets_base_protocol{id = 46303, c2s = null,
		       s2c = pbnotify, memo = <<"通知新技能开启">>};
get(46304) ->
    #ets_base_protocol{id = 46304, c2s = pbupgradedrequest,
		       s2c = pbupgradedrespon, memo = <<"灵兽绝技升级">>};
get(46305) ->
    #ets_base_protocol{id = 46305, c2s = null,
		       s2c = pbnotify, memo = <<"通知新守护属性开放">>};
get(46306) ->
    #ets_base_protocol{id = 46306, c2s = pbupgradedrequest,
		       s2c = pbupgradedrespon, memo = <<"灵兽守护属性开放">>};
get(46307) ->
    #ets_base_protocol{id = 46307, c2s = null,
		       s2c = pbnotify, memo = <<"新阵法开启">>};
get(46308) ->
    #ets_base_protocol{id = 46308, c2s = pbupgradedrequest,
		       s2c = pbupgradedrespon, memo = <<"阵法升级">>};
get(46399) ->
    #ets_base_protocol{id = 46399, c2s = null, s2c = pbuser,
		       memo = <<"测试协议获取一只灵兽">>};
get(46400) ->
    #ets_base_protocol{id = 46400, c2s = null,
		       s2c = pbbeastchangeinfo, memo = <<"灵兽幻变信息">>};
get(46401) ->
    #ets_base_protocol{id = 46401, c2s = pbid32,
		       s2c = pbbeastchangeinfo, memo = <<"获取灵兽幻变">>};
get(46402) ->
    #ets_base_protocol{id = 46402, c2s = pbid32,
		       s2c = pbuser, memo = <<"启用灵兽幻变">>};
get(46403) ->
    #ets_base_protocol{id = 46403, c2s = pbid32,
		       s2c = pbuser, memo = <<"跟随灵兽幻变">>};
get(46404) ->
    #ets_base_protocol{id = 46404, c2s = pbid32,
		       s2c = pbuser, memo = <<"取消跟随灵兽幻变">>};
get(46500) ->
    #ets_base_protocol{id = 46500, c2s = pbupgradedrequest,
		       s2c = pbstarpowerresult, memo = <<"星力激活">>};
get(47000) ->
    #ets_base_protocol{id = 47000, c2s = null,
		       s2c = pbforagestatus, memo = <<"查询保卫粮草状态">>};
get(47001) ->
    #ets_base_protocol{id = 47001, c2s = null,
		       s2c = pbforageguildlist, memo = <<"查询粮草地列表">>};
get(47002) ->
    #ets_base_protocol{id = 47002, c2s = null,
		       s2c = pbforageplayerlist, memo = <<"查询盗贼列表">>};
get(47003) ->
    #ets_base_protocol{id = 47003, c2s = null,
		       s2c = pbforageguildlist, memo = <<"查询军团名次列表">>};
get(47004) ->
    #ets_base_protocol{id = 47004, c2s = null,
		       s2c = pbforageplayerlist, memo = <<"查询个人名次列表">>};
get(47005) ->
    #ets_base_protocol{id = 47005, c2s = pbid64,
		       s2c = pbforagestatus, memo = <<"偷盗粮草">>};
get(48000) ->
    #ets_base_protocol{id = 48000, c2s = null,
		       s2c = pbresult, memo = <<"进入到护送场景">>};
get(48001) ->
    #ets_base_protocol{id = 48001, c2s = null,
		       s2c = pbresult, memo = <<"退出护送场景">>};
get(48002) ->
    #ets_base_protocol{id = 48002, c2s = null,
		       s2c = pbescortscene, memo = <<"请求护送场景详细信息">>};
get(48003) ->
    #ets_base_protocol{id = 48003, c2s = null,
		       s2c = pbescortscene, memo = <<"新增护送信息">>};
get(48004) ->
    #ets_base_protocol{id = 48004, c2s = null,
		       s2c = pbescortscene, memo = <<"护送结束">>};
get(48005) ->
    #ets_base_protocol{id = 48005, c2s = null,
		       s2c = pbescortscene, memo = <<"护送的数据有变更">>};
get(48052) ->
    #ets_base_protocol{id = 48052, c2s = null,
		       s2c = pbescortscene, memo = <<"获取当前的护送列表">>};
get(48053) ->
    #ets_base_protocol{id = 48053, c2s = pbid64,
		       s2c = pbescort, memo = <<"查询指定对象的护送详细信息">>};
get(48100) ->
    #ets_base_protocol{id = 48100, c2s = pbid64,
		       s2c = pbescortcombat, memo = <<"发起打劫">>};
get(48101) ->
    #ets_base_protocol{id = 48101, c2s = null,
		       s2c = pbresult, memo = <<"清除打劫的CD时间">>};
get(48102) ->
    #ets_base_protocol{id = 48102, c2s = null,
		       s2c = pbresult, memo = <<"购买打劫次数">>};
get(48103) ->
    #ets_base_protocol{id = 48103, c2s = null,
		       s2c = pbescortcombat, memo = <<"被打劫信息">>};
get(48201) ->
    #ets_base_protocol{id = 48201, c2s = pbid64,
		       s2c = pbresult, memo = <<"邀请好友护送">>};
get(48301) ->
    #ets_base_protocol{id = 48301, c2s = null,
		       s2c = pbescort, memo = <<"刷新护送品质">>};
get(48302) ->
    #ets_base_protocol{id = 48302, c2s = null,
		       s2c = pbresult, memo = <<"一键刷新品质到橙色">>};
get(48400) ->
    #ets_base_protocol{id = 48400, c2s = null,
		       s2c = pbescort, memo = <<"开始护送">>};
get(48401) ->
    #ets_base_protocol{id = 48401, c2s = null,
		       s2c = pbresult, memo = <<"加速护送">>};
get(48402) ->
    #ets_base_protocol{id = 48402, c2s = null,
		       s2c = pbresult, memo = <<"立即完成护送">>};
get(48404) ->
    #ets_base_protocol{id = 48404, c2s = null,
		       s2c = pbresult, memo = <<"购买护送次数">>};
get(48500) ->
    #ets_base_protocol{id = 48500, c2s = null,
		       s2c = pbescortplayer, memo = <<"查询自己的详细护送信息">>};
get(48502) ->
    #ets_base_protocol{id = 48502, c2s = pbid64r,
		       s2c = pbfriendescort, memo = <<"查询好友的剩余护送次数">>};
get(48801) ->
    #ets_base_protocol{id = 48801, c2s = null,
		       s2c = pbwarcraftlist, memo = <<"矿点列表">>};
get(48802) ->
    #ets_base_protocol{id = 48802, c2s = null,
		       s2c = pbwarcraft, memo = <<"自己矿点信息">>};
get(48803) ->
    #ets_base_protocol{id = 48803, c2s = pbwarcraftquery,
		       s2c = pbwarcraftlist, memo = <<"查询指定页的矿点列表">>};
get(48804) ->
    #ets_base_protocol{id = 48804, c2s = pbwarcraftquery,
		       s2c = pbwarcraft, memo = <<"占领矿点，成功返回消息头">>};
get(48805) ->
    #ets_base_protocol{id = 48805, c2s = pbwarcraftquery,
		       s2c = pbwarcraft, memo = <<"掠夺矿点,成功返回消息头">>};
get(48806) ->
    #ets_base_protocol{id = 48806, c2s = pbwarcraftquery,
		       s2c = pbwarcraft, memo = <<"撤出矿点，成功返回消息头">>};
get(51001) ->
    #ets_base_protocol{id = 51001, c2s = null,
		       s2c = pbtreasurelistupdate, memo = <<"获取玩家装备宝物信息">>};
get(51002) ->
    #ets_base_protocol{id = 51002, c2s = null,
		       s2c = pbtreasurelistupdate, memo = <<"获取玩家宝物背包信息">>};
get(51003) ->
    #ets_base_protocol{id = 51003, c2s = null,
		       s2c = pbtreasurelist, memo = <<"获取玩家宝物探索状态">>};
get(51004) ->
    #ets_base_protocol{id = 51004, c2s = pbid64,
		       s2c = pbtreasurelistupdate, memo = <<"查询伙伴装备宝物信息">>};
get(51005) ->
    #ets_base_protocol{id = 51005, c2s = null,
		       s2c = pbtreasurelistupdate, memo = <<"查询其他玩家装备宝物的信息">>};
get(51006) ->
    #ets_base_protocol{id = 51006, c2s = null,
		       s2c = pbtreasurelistupdate, memo = <<"更新宝物的位置信息">>};
get(51007) ->
    #ets_base_protocol{id = 51007, c2s = pbid32,
		       s2c = pbtreasurelist, memo = <<"探索宝物">>};
get(51008) ->
    #ets_base_protocol{id = 51008, c2s = null,
		       s2c = pbtreasurelist, memo = <<"一键探索宝物">>};
get(51009) ->
    #ets_base_protocol{id = 51009, c2s = null,
		       s2c = pbtreasurelist, memo = <<"使用元宝刷新探索场景">>};
get(51010) ->
    #ets_base_protocol{id = 51010, c2s = pbid32,
		       s2c = pbtreasurelist, memo = <<"扩展宝物包裹">>};
get(51011) ->
    #ets_base_protocol{id = 51011, c2s = null,
		       s2c = pbtreasurelistupdate, memo = <<"获取临时宝物包裹数据">>};
get(51012) ->
    #ets_base_protocol{id = 51012, c2s = pbid32,
		       s2c = pbtreasure, memo = <<"拾取宝物">>};
get(51013) ->
    #ets_base_protocol{id = 51013, c2s = null,
		       s2c = pbtreasurelist, memo = <<"一键拾取宝物">>};
get(51014) ->
    #ets_base_protocol{id = 51014, c2s = null,
		       s2c = pbtreasurelistupdate, memo = <<"购买寻宝生命">>};
get(51015) ->
    #ets_base_protocol{id = 51015, c2s = pbtreasureexchange,
		       s2c = pbtreasurelistupdate, memo = <<"交换两个格子中的物品">>};
get(51016) ->
    #ets_base_protocol{id = 51016, c2s = pbid64,
		       s2c = pballtreasurelist, memo = <<"查看其它玩家装备宝物">>};
get(52001) ->
    #ets_base_protocol{id = 52001, c2s = null,
		       s2c = pbbossstate, memo = <<"查询世界BOSS状态">>};
get(52002) ->
    #ets_base_protocol{id = 52002, c2s = null,
		       s2c = pbdicplayerboss, memo = <<"查询自己的杀BOSS信息">>};
get(52003) ->
    #ets_base_protocol{id = 52003, c2s = null, s2c = null,
		       memo = <<"发起挑战">>};
get(52004) ->
    #ets_base_protocol{id = 52004, c2s = null, s2c = pbid32,
		       memo = <<"复活">>};
get(52005) ->
    #ets_base_protocol{id = 52005, c2s = null, s2c = pbid32,
		       memo = <<"BOSS血量更新">>};
get(52006) ->
    #ets_base_protocol{id = 52006, c2s = null,
		       s2c = pbranklist, memo = <<"排行榜数据更新">>};
get(52007) ->
    #ets_base_protocol{id = 52007, c2s = null,
		       s2c = pbdicplayerboss, memo = <<"玩家信息刷新">>};
get(52008) ->
    #ets_base_protocol{id = 52008, c2s = null, s2c = null,
		       memo = <<"BOSS死亡活动结束通知">>};
get(52100) ->
    #ets_base_protocol{id = 52100, c2s = null,
		       s2c = pbsoutherninfo, memo = <<"查询玩家南蛮信息">>};
get(52101) ->
    #ets_base_protocol{id = 52101, c2s = null,
		       s2c = pbsouthernstate, memo = <<"查询活动状态">>};
get(52102) ->
    #ets_base_protocol{id = 52102, c2s = null,
		       s2c = pbsouthernbosslist, memo = <<"查询BOSS信息">>};
get(52103) ->
    #ets_base_protocol{id = 52103, c2s = null, s2c = null,
		       memo = <<"复活">>};
get(52200) ->
    #ets_base_protocol{id = 52200, c2s = null,
		       s2c = pbfowstate, memo = <<"查询天下第一对阵列表">>};
get(52201) ->
    #ets_base_protocol{id = 52201, c2s = null,
		       s2c = pbfowstate, memo = <<"更新天下第一对阵列表">>};
get(52202) ->
    #ets_base_protocol{id = 52202, c2s = null, s2c = null,
		       memo = <<"更新天下第一战斗数据">>};
get(52500) ->
    #ets_base_protocol{id = 52500, c2s = pbupsquery,
		       s2c = null, memo = <<"查询跨服战斗的战斗角色信息">>};
get(52501) ->
    #ets_base_protocol{id = 52501, c2s = pbupsquery,
		       s2c = null, memo = <<"查询跨服战斗的战报信息">>};
get(52502) ->
    #ets_base_protocol{id = 52502, c2s = pbupsquery,
		       s2c = null, memo = <<"ups投注">>};
get(52503) ->
    #ets_base_protocol{id = 52503, c2s = null, s2c = null,
		       memo = <<"ups报名">>};
get(54001) ->
    #ets_base_protocol{id = 54001, c2s = pbid64,
		       s2c = pbartifact, memo = <<"获取法宝的详细信息">>};
get(54002) ->
    #ets_base_protocol{id = 54002, c2s = pbartifact,
		       s2c = pbartifact, memo = <<"法宝升阶">>};
get(55001) ->
    #ets_base_protocol{id = 55001, c2s = pbstartcombat,
		       s2c = pbcombatreport, memo = <<"发起战斗">>};
get(55002) ->
    #ets_base_protocol{id = 55002, c2s = pbidstring,
		       s2c = pbcombatreport, memo = <<"战报查询协议">>};
get(55003) ->
    #ets_base_protocol{id = 55003, c2s = pbidstring,
		       s2c = pbcombatreport, memo = <<"跨服战报查询协议">>};
get(55100) ->
    #ets_base_protocol{id = 55100, c2s = null,
		       s2c = pbcombatreward, memo = <<"战斗奖励数据">>};
get(56001) ->
    #ets_base_protocol{id = 56001, c2s = pbid32,
		       s2c = pbfightsoulinfo, memo = <<"查询指定武魂的收集进度">>};
get(56002) ->
    #ets_base_protocol{id = 56002, c2s = pbid32,
		       s2c = pbplayerfightsoul, memo = <<"获取武魂">>};
get(56003) ->
    #ets_base_protocol{id = 56003, c2s = null,
		       s2c = pbplayerfightsoul, memo = <<"查询玩家武魂列表">>};
get(56004) ->
    #ets_base_protocol{id = 56004, c2s = pbid32,
		       s2c = pbplayersoullist, memo = <<"激活指定武魂，ID为Uid">>};
get(56005) ->
    #ets_base_protocol{id = 56005, c2s = pbid32,
		       s2c = pbplayersoullist, memo = <<"关闭指定武魂">>};
get(57001) ->
    #ets_base_protocol{id = 57001, c2s = null,
		       s2c = pbkinginfo, memo = <<"查询玩家的奴隶信息">>};
get(57010) ->
    #ets_base_protocol{id = 57010, c2s = pbkinguser,
		       s2c = pbkinginfo, memo = <<"属臣系统互动">>};
get(57014) ->
    #ets_base_protocol{id = 57014, c2s = pbid64,
		       s2c = pbkinginfo, memo = <<"踢出某个属臣">>};
get(57016) ->
    #ets_base_protocol{id = 57016, c2s = null,
		       s2c = pbkinginfo, memo = <<"向军团求助">>};
get(57030) ->
    #ets_base_protocol{id = 57030, c2s = pbid64,
		       s2c = pbkinguser, memo = <<"查询指定目标的主公信息">>};
get(60000) ->
    #ets_base_protocol{id = 60000, c2s = null,
		       s2c = pbserverlist, memo = <<"查询服务器列表">>};
get(_) -> [].
