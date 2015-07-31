%%消费记录点宏定义

%%消费记录点ID命名规范，一般以功能对应的协议号为记录号，后加注释说明
%% COST_Mod的名称_功能描述  ： 协议号

-ifndef(DEFINE_MONEY_COST_HRL).
-define(DEFINE_MONEY_COST_HRL, true).

-define(ACTION_TYPE_INCOME,             0).    %% 产出
-define(ACTION_TYPE_COST,               1).    %% 消耗

-define(INCOME_RECHARGE,           10000).  %%充值收入
-define(INCOME_VIP_REWARD,           10001).  %%VIP礼包
-define(INCOME_CDK_REWARD,           10002).  %%CDkey礼包


%% 副本相关
-define(INCOME_DUNGEON_REWARD,           12000).  %%副本收入
-define(COST_ENTRY_DUNGEON,              12001).  %%进入副本消耗
-define(INCOME_MUGEN_DUNGEON_REWARD,     12004).  %%极限副本收入
-define(COST_FLIP_CARD,                  12010).  %%翻牌消耗
-define(COST_BUY_HEALING_SALVE,          12011).  %%购买血瓶
-define(COST_SKIP_MUGEN,                 12020).  %%爬塔跳关消耗
-define(INCOME_MUGEN_DUNGEON_CHALLENGE,  12025).  %%极限副本好友挑战收入
-define(INCOME_SKIP_MUGEN,               12026).  %%爬塔跳关收入
-define(INCOME_LUCKY_SEND_COIN,          12027).  %%发送幸运币的收入
-define(COST_BUY_SUPER_BATTLE,           12030).  %%购买公平竞技的消耗
-define(COST_BUY_KING_DUNGEON,           12031).  %%购买王者副本的次数
-define(INCOME_DUNGEON_MOP_UP,           12040).  %%副本扫荡收入

%%角色相关
-define(COST_UPGRADE_SKILL,              13300).  %%技能升级消耗
-define(COST_STRENGTH_SKILL,             13301).  %%技能强化消耗

-define(INCOME_DECOMPOSE_GOODS,          15010).  %% 物品分解
-define(INCOME_EXCHANGE_GOODS,           15011).  %% 商城购买

-define(COST_OPEN_BOSS,                  17010).  %%开启boss消耗
-define(INCOME_OPEN_BOSS,                17011).  %%开启boss收入
-define(INCOME_BOSS_KILLED,              17012).  %%参加打boss收入

-define(INCOME_MAIL_ATTACHMENT,          19000).  %%邮件附件

-define(INCOME_ASYNC_CHALLENGE_INCOME,   24002).  %%异步PVP挑战奖励
-define(COST_ASYNC_CHALLENGE_BUY_TIMES,  24003).  %%异步竞技场购买次数
-define(INCOME_CROSS_PVP,                24004).  %%跨服竞技场奖励
-define(COST_CROSS_CHALLENGE_BUY_TIMES,  24005).  %%跨服竞技场购买次数

-define(INCOME_TASK_REWARD,              30000).  %%任务奖励

%% 神秘商店
-define(COST_MYSTERY_SHOP_RESET,         31000).  %% 元宝重置神秘商店
-define(COST_MYSTERY_SHOP_BUY,           31001).  %% 在神秘商店内购买物品

-define(COST_PVP_SHOP_RESET,             31002).  %% PVP竞技场神秘商店刷新
-define(COST_FAIR_CHALLANGE_SHOP_REST,   31003).  %% 公平竞技场商城
-define(COST_CROSS_SHOP_RESET,           31004).  %% 跨服竞技场神秘商店刷新
-define(COST_LEAGUE_SHOP_RESET,          31005).  %% 公会商城刷新消耗

%% 商场之购买物品
-define(COST_ORDINARY_SHOP_BUY,          31010).  %% 在商场购买物品

%% 勋章
-define(COST_UPGRADE_XUNZHANG,           31100).  %% 花费勋章升级

-define(COST_CREATE_LEAGUE,              40000).  %%创建工会消耗
-define(INCOME_LEAGUE_GIFTS,             40100).  %%工会礼包收入

%% 抽奖相关
-define(CHOUJIANG_FREE_COIN,             50000).  %% 金币类型的免费抽奖
-define(CHOUJIANG_FREE_GOLD,             50001).  %% 钻石类型的免费抽奖
-define(COST_CHOUJIANG_COIN_ONE,         50002).  %% 用金币购买一次抽奖
-define(COST_CHOUJIANG_COIN_TEN,         50003).  %% 用金币购买十次抽奖
-define(COST_CHOUJIANG_GOLD_ONE,         50004).  %% 用钻石购买一次抽奖
-define(COST_CHOUJIANG_GOLD_TEN,         50005).  %% 用钻石购买十次抽奖
-define(CHOUJIANG_FIRST_COIN,            50006).  %% 金币首抽
-define(CHOUJIANG_FIRST_GOLD,            50007).  %% 钻石首抽

%% 工会相关
-define(LEAGUE_RECHARGE_GOLD,            60000).  %% 工会充值

%% 礼包相关
-define(DECOMPOSITION_GIFT,              60100).  %% 分解礼包

%% 师徒系统相关
-define(GET_MASTER_CARD,                 70000).  %% 获得拜师卡
-define(INCOME_MASTER_REWARD,            70001).  %% 出师奖励

%% 角色相关
-define(COST_PLAYER_TRAINING,            1327).                   %% 培养属性
-define(COST_PLAYER_UPGRADE_GENIUS,      1329).                   %% 升级天赋
-define(INCOME_PLAYER_TANK_SALARY,       1330).                   %% 军衔俸禄
-define(INCOME_CHARGE,                   1350).                   %% 充值获得元宝
-define(INCOME_DAILY_LOGIN,              1360).                   %% 每日登录奖励
-define(INCOME_VIP_GIFT,                 1361).                   %% VIP礼包领取
-define(INCOME_ACHIEVE_GIFT,             1362).                   %% 成就礼包领取
-define(INCOME_GUILD_FIGHT_GIFT,         1363).                   %% 军团战礼包领取
-define(COST_BUY_LIFE,                   1364).                   %% 复活扣gold
-define(INCOME_MONTH_LOGIN,              1365).                   %% 月登录奖励


-define(INCOME_ONLINE_GIFT,              1370).                   %% 在线奖励
-define(INCOME_MONSTER_DROP,             1372).                   %% 怪物掉落
-define(INCOME_LEVLE_GIFT,               1373).                   %% 等级礼包
-define(INCOME_TRIAL_SYSTEM,             1374).                   %% 试炼/小助手系统产出

-define(COST_PASSIVE_SKILL_ADD,          1380).                   %% 开户被动技能栏
-define(COST_FIX_CHECK_IN,               1381).                   %% 补签

%% 邮件相关
-define(COST_SEND_MAIL,                  1413).                   %% 发送邮件

%% 物品相关
-define(COST_STRENGTHEN_EQUIP,           1500).                   %% 强化装备
-define(COST_BUY_GOODS,                  1520).                   %% 购买物品
-define(COST_SELL_GOODS,                 1521).                   %% 出售物品
-define(COST_EXTEND_BAG,                 1522).                   %% 扩展包裹
-define(COST_REBUY_GOODS,                1526).                   %% 回购物品
-define(COST_BUY_VIGOR,                  1534).                   %% 购买体力
-define(COST_BUY_FRIEND_EXT,             1535).                   %% 购买好友格子
-define(COST_BUY_FASHION,                1536).                   %% 购买时装
-define(COST_NEW_STRENGTHEN_QUEUE,       1545).                   %% 开启新的强化队列
-define(COST_CLEAR_STREN_CD_FOREVER,     1546).                   %% 永久清除强化 CD
-define(COST_USE_MONEY_RUNE,             1548).                   %% 使用招财符
-define(COST_EQUIP_STRENGTHEN,           1554).                   %% 装备强化
-define(COST_CLEAR_STREN_CD,             1555).                   %% 清除强化 CD
-define(COST_EQUIP_PRACTISE,             1556).                   %% 装备冶炼
-define(COST_EQUIP_DEVIDE,               1557).                   %% 装备分解
-define(COST_COMPOSE_JEWELS,             1558).                   %% 宝石合成
-define(COST_EQUIP_HOLE,                 1559).                   %% 装备开孔
-define(COST_EQUIP_INLAY_JEWELS,         1560).                   %% 宝石镶嵌
-define(COST_EQUIP_REMOVE_JEWELS,        1561).                   %% 宝石移除
-define(COST_COMPOSE_EQUIP,              1562).                   %% 装备合成
-define(COST_REFINE_EQUIP,               1563).                   %% 装备精练
-define(COST_FORGE_EQUIP,                1570).                   %% 装备进阶
-define(COST_UPGRADE_EQUIP,              1571).                   %% 装备升阶
-define(COST_STRENGTHEN_TRANSFER,        1572).                   %% 强化转移
-define(COST_ARTIFACT_UPGRADE,           1573).                   %% 法宝升级的材料补齐
-define(COST_USE_PRESTIGE_CARD,          1582).                   %% 使用声望卡
-define(COST_BUY_SCORE2,                 1583).                   %% 购买军粮 - 群雄争霸
-define(INCOME_UPDATE_REWARD,            1590).                   %% 更新包奖励
-define(INCOME_TREASURE_SOLD,            1591).                   %% 废魂出售
-define(INCOME_GIFT_CODE,                1592).                   %% 礼包奖励
-define(INCOME_MONEY_RUNE,               1593).                   %% 使用招财符
-define(INCOME_FIRST_RECHARGE,           1594).                   %% 首次充值

%% 扣除元宝失败
-define(COST_GOLD_FAILED,                9990).                   %% 扣除元宝失败了的记录
-define(INCOME_GOLD_FAILED,              9998).                   %% 收益元宝失败了的记录
-define(INCOME_GOLD_GM,                  9999).                   %% GM命令收益

-endif.

