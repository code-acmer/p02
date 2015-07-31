%% Warning:本文件由generate_log_event自动生成，请不要手动修改
-ifndef(DEFINE_LOG_EVENT_HRL).
-define(DEFINE_LOG_EVENT_HRL, true).

-define(LOG_EVENT_ONLINE, 10001).   %% 上线 || 账户id || IP
-define(LOG_EVENT_OFFLINE, 10002).   %% 下线 || 账户id || IP
-define(LOG_EVENT_CREATE_ROLE, 10003).   %% 创建角色 || 账户id || 返回值
-define(LOG_EVENT_ENTER_DUNGEON, 12001).   %% 进入副本 || 副本id || 当前等级
-define(LOG_EVENT_LEAVE_DUNGEON, 12002).   %% 离开副本 || 副本id || 当前等级
-define(LOG_EVENT_ADD_GOLD, 13001).   %% 加元宝 || 消费点 || 加的元宝
-define(LOG_EVENT_SUB_GOLD, 13002).   %% 扣元宝 || 消费点 || 扣的元宝
-define(LOG_EVENT_ADD_COIN, 13003).   %% 加铜钱 || 消费点 || 加的铜钱
-define(LOG_EVENT_SUB_COIN, 13004).   %% 扣铜钱 || 消费点 || 扣的铜钱
-define(LOG_EVENT_ADD_VIGOR, 13005).   %% 加体力 || 消费点 || 加的体力
-define(LOG_EVENT_SUB_VIGOR, 13006).   %% 扣体力 || 消费点 || 扣的体力
-define(LOG_EVENT_ADD_EXP, 13007).   %% 加经验 || 消费点 || 加的经验
-define(LOG_EVENT_ADD_VGOLD, 13008).   %% 加充值元宝 || 消费点 || 加的充值元宝
-define(LOG_EVENT_LV_UP, 13009).   %% 升级 || 旧等级 || 新等级
-define(LOG_EVENT_ADD_COMBAT_POINT, 13010).   %% 加竞技点 || 消费点 || 数量
-define(LOG_EVENT_ADD_HONOR, 13011).   %% 加荣誉点 || 消费点 || 数量
-define(LOG_EVENT_ADD_BIND_GOLD, 13012).   %% 加绑定钻石 || 消费点 || 数量
-define(LOG_EVENT_ADD_SEAL, 13013).   %% 加征途印章 || 消费点 || 数量
-define(LOG_EVENT_ADD_CROSS_COIN, 13014).   %% 加跨服竞技场货币 || 消费点 || 数量
-define(LOG_EVENT_ADD_ARENA_COIN, 13015).   %% 加竞技场货币 || 消费点 || 数量
-define(LOG_EVENT_ADD_LEAGUE_SEAL, 13016).   %% 加公会印章 || 消费点 || 数量
-define(LOG_EVENT_LOGIN_REWARD, 13025).   %% 登录奖励 || 天数 || 领取前状态
-define(LOG_EVENT_SKILL_LV_UP, 13300).   %% 人物技能升级 || 技能baseid || 新等级
-define(LOG_EVENT_SKILL_STR, 13301).   %% 人物技能强化 || 技能baseid || 新等级
-define(LOG_EVENT_SKILL_CHANGE_SIGIL, 13302).   %% 技能符印切换 || 符印id || 新符印id
-define(LOG_EVENT_GOLD_TO_VIGOR, 13027).   %% 购买体力 || 当前已购买次数 || null
-define(LOG_EVENT_ADD_FRIEND, 13150).   %% 加好友 || 好友id || null
-define(LOG_EVENT_DEL_FRIEND, 13151).   %% 删好友 || 好友id || null

-define(LOG_EVENT_ADD_GOODS, 15001).   %% 获得物品 || 物品base_id || 数量
-define(LOG_EVENT_SUB_GOODS, 15002).   %% 扣物品 || 物品base_id || 数量
-define(LOG_EVENT_GOODS_STRENGTH, 15003).   %% 物品强化 || 物品base_id || 等级
-define(LOG_EVENT_GOODS_ADD_STAR, 15004).   %% 物品升星 || 物品base_id || 等级
-define(LOG_EVENT_GOODS_SMRITI, 15005).   %% 物品传承 || 物品base_id || 目标base_id
-define(LOG_EVENT_INLAID_JEWEL, 15010).  %% 宝石镶嵌 || 物品base_id || 宝石 base_id
-define(LOG_EVENT_COMPOSE_JEWEL, 15011).  %% 宝石合成 || 宝石 base_id || null
-define(LOG_EVENT_REMOVE_JEWEL, 15012).  %% 宝石摘除 || 物品base_id || 宝石 base_id
-define(LOG_EVENT_REMOVE_ALL_JEWEL, 15013).  %% 摘除所有宝石 || 物品base_id || null

-define(LOG_EVENT_OPEN_BOSS, 17000).   %% 开启BOSS || boss_id || null
-define(LOG_EVENT_ENTRY_BOSS, 17001).  %% 进入BOSS场景 || boss_id || 开启者id
-define(LOG_EVENT_DAMAGE_BOSS, 17002). %% 攻击BOSS || boss_id || 伤害值
-define(LOG_EVENT_LEAVE_BOSS, 17003). %% 退出Boss场景 || boss_id || 开启者id
-define(macro, id).   %% comment || arg1_comment || arg2_comment


-endif.

