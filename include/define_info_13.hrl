-ifndef(DEFINE_INFO_13_HRL).
-define(DEFINE_INFO_13_HRL, true).

-include("define_info_0.hrl").


-define(INFO_QUERY_OTHER_ERROR,                 13004).   %% 亲，不要查看自己
-define(INFO_QUERY_OTHER_NOTFIND,               13005).   %% 查找玩家不存在
-define(INFO_ADD_MONEY_TYPE_ERR,                13006).   %% 玩家属性添加类型错误
-define(INFO_VIP_REWARD_RECV,                   13020).   %% 该VIP礼包已经领取
-define(INFO_DAILY_REWARD_SUCCESS,              13110).   %% 登录奖励领取成功
-define(INFO_DAILY_REWARD_FAILED,               13111).   %% 登录奖励领取失败
-define(INFO_DAILY_REWARD_RECEIVED,             13112).   %% 所有的登录奖励均已领取
-define(INFO_DAILY_REWARD_NOT_FOUND,            13113).   %% 登录奖励数据获取失败
-define(INFO_DAILY_REWARD_RECEIVED_TODAY,       13114).   %% 今日的登录奖励已经领取过了，不可再领取

-define(INFO_CHECK_IN_RECEIVED,                 13152).   %% 今日的签到奖励已经领取过了，不可再领取

-define(INFO_TEAM_DUNPLICATE,                   13200).   %% 不能创建多个队伍
-define(INFO_TEAM_CREATE_ERROR,                 13201).   %% 创建队伍失败
-define(INFO_TEAM_MEMBER_FULL,                  13202).   %% 该队伍已经满员
-define(INFO_TEAM_NOT_EXIST,                    13203).   %% 该队伍已经解散
-define(INFO_TEAM_IN_TEAM,                      13204).   %% 你已经在队伍里面
-define(INFO_TEAM_GET_TEAM_ERROR,               13205).   %% 获取队伍信息失败
-define(INFO_TEAM_NOT_IN_TEAM,                  13206).   %% 你当前不在队伍里面
-define(INFO_TEAM_INVITE_SEND,                  13207).   %% 好友邀请已经发送
-define(INFO_TEAM_NO_KICK_MYSELF,               13208).   %% 你不能踢出自己
-define(INFO_TEAM_NOT_LEADER,                   13209).   %% 只有队长才能踢人
-define(INFO_TEAM_TAR_NOT_IN_TEAM,              13210).   %% 踢出目标不在队伍里面
-define(INFO_TEAM_DO_IN_READY,                  13211).   %% 已经是准备状态
-define(INFO_TEAM_DUNGEON_ON,                   13212).   %% 副本已经开始，不能加入
-define(INFO_TEAM_DUNGEON_START_LIMIT,          13213).   %% 只有队长才能开始副本
-define(INFO_TEAM_NOT_ALL_READY,                13214).   %% 全部准备才能开始
-define(INFO_TEAM_MEMBER_SINGLE,                13215).   %% 组队副本不能单人开始

-define(INFO_SKILL_NOT_FOUND,                   13301).   %% 没有该技能
-define(INFO_SKILL_MAX,                         13302).   %% 技能等级已满
-define(INFO_LV_LIMIT,                          13303).   %% 人物等级不足
-define(INFO_SIGIL_SAME,                        13305).   %% 切换的符印跟当前符印一致
-define(INFO_SIGIL_NOT_FOUND,                   13306).   %% 没有该符印

-define(INFO_MONTH_SIGN_FALSE,                  13307).   %% 今日已签

-define(INFO_QQ_IS_SAME,                        13308).   %% QQ号相同
-define(INFO_QQ_ALDEADY_USED,                   13309).   %% QQ号已被绑定过
-define(INFO_QQ_ALDEADY_BIND,                   13310).   %% 帐号已经绑定过QQ号

-endif.

