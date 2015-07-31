-ifndef(DEFINE_INFO_14_HRL).
-define(DEFINE_INFO_14_HRL, true).

-include("define_info_0.hrl").


-define(INFO_FRIEND_ADD_SUCCESS,                14000).   %% 添加好友成功
-define(INFO_FRIEND_ADD_FAILED,                 14001).   %% 添加好友失败
-define(INFO_FRIEND_NOT_EXIST,                  14002).   %% 目标好友不存在
-define(INFO_FRIEND_IN_BLACK_LIST,              14003).   %% 在目标的黑名单中
-define(INFO_FRIEND_HIS_NUM_EXCEED,             14004).   %% 好友的好友数已达上限
-define(INFO_FRIEND_MY_NUM_EXCEED,              14005).   %% 我的好友数已达上限
-define(INFO_FRIEND_FUNCTION_OFF,               14006).   %% 好友功能未开启
-define(INFO_FRIEND_CAN_NOT_ADD_MYSELF,         14007).   %% 不能添加自己为好友
-define(INFO_FRIEND_DUPLICATED,                 14008).   %% 已经是好友了
-define(INFO_FRIEND_REQUEST_SEND,               14009).   %% 添加好友申请已发送
-define(INFO_FRIEND_DELETE_SUCCESS,             14010).   %% 删除好友成功
-define(INFO_FRIEND_DELETE_FAILED,              14011).   %% 删除好友失败
-define(INFO_FRIEND_NOT_FRIEND,                 14012).   %% 目标不是你的好友
-define(INFO_BUY_FPT_SUCCESS,                   14013).   %% 成功增加5个好友上限
-define(INFO_FRIEND_ADD_BLACK_SUCCESS,          14020).   %% 添加黑名单成功
-define(INFO_FRIEND_ADD_BLACK_FAILED,           14021).   %% 添加黑名单失败
-define(INFO_FRIEND_BLACK_LIST_EXCEED,          14022).   %% 黑名单已满，添加失败
-define(INFO_FRIEND_ADD_ENEMY_SUCCESS,          14030).   %% 添加仇人成功
-define(INFO_FRIEND_ADD_ENEMY_FAILED,           14031).   %% 添加仇人失败
-define(INFO_FRIEND_IN_ENEMY_LIST,              14032).   %% 已经在仇人列表中了
-define(INFO_FRIEND_INQUIRE_SUCCESS,            14040).   %% 查询成功
-define(INFO_FRIEND_INQUIRE_FAILED,             14041).   %% 查询失败
-define(INFO_FRIEND_INQUIRE_OFFLINE,            14042).   %% 查询目标不在线
-define(INFO_FRIEND_DEL_BLACK_SUCCESS,          14050).   %% 删除黑名单成功
-define(INFO_FRIEND_DEL_BLACK_FAILED,           14051).   %% 删除黑名单失败
-define(INFO_FRIEND_NOT_IN_BLACK_LIST,          14052).   %% 不存在的黑名单数据
-define(INFO_FRIEND_DEL_ENEMY_SUCCESS,          14060).   %% 删除仇人成功
-define(INFO_FRIEND_DEL_ENEMY_FAILED,           14061).   %% 删除仇人失败
-define(INFO_FRIEND_NOT_IN_ENEMY,               14062).   %% 不存在的仇人数据


-endif.

