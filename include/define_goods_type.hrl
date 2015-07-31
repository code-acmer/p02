-ifndef(DEFINE_GOODS_TYPE_HRL).
-define(DEFINE_GOODS_TYPE_HRL, true).

%% 物品类型
-define(GOODS_TYPE_GOLD,                 1).   %% 元宝与MoneyType合并
-define(GOODS_TYPE_BGOLD,                2).   %% 绑定元宝
-define(GOODS_TYPE_COIN,                 3).   %% 铜钱
-define(GOODS_TYPE_CASH,                 4).   %% 绑定现金        -已废弃
-define(GOODS_TYPE_HONOR,                6).   %% 天赋点         -天赋升级
-define(GOODS_TYPE_COMBAT_POINT,         7).   %% 竞技点          用于升级勋章
-define(GOODS_TYPE_SEAL,                 8).   %% 封印值
-define(GOODS_TYPE_VIGOR,                9).   %% 体力
-define(GOODS_TYPE_CROSS_COIN,          10).   %% 跨服竞技场货币
-define(GOODS_TYPE_ARENA_COIN,          11).   %% 竞技场货币
-define(GOODS_TYPE_LEAGUE_SEAL,         12).   %% 公会印章
-define(GOODS_TYPE_FRIENDPOINT,         14).   %% 友情点
-define(GOODS_TYPE_Q_COIN,              15).   %% Q券
-define(GOODS_TYPE_EXP,                 20).   %% 奖励经验
-define(GOODS_TYPE_VGOLD,               21).   %% 带vip经验的元宝

-define(GOODS_TYPE_PARTNER,             14).   %% 武将，首先要大于80，接着除于GOODS_TYPE_UNIT之后等于这个，下面物品也一样 
-define(GOODS_TYPE_TREASURES,           54).   %% 宝物
-define(GOODS_TYPE_GOODS,               80).   %% 用于各种奖励中判断是否属于物品

-define(GOODS_TYPE_EQUIP,               81).   %% 81装备道具
-define(GOODS_TYPE_STONE,               82).   %% 82宝石道具
-define(GOODS_TYPE_RUNE,                83).   %% 83卷轴|配方
-define(GOODS_TYPE_PET,                 84).   %% 84宠物道具
-define(GOODS_TYPE_MEDICINE,            85).   %% 85材料
-define(GOODS_TYPE_MATERIAL,            86).   %% 86任务道具
-define(GOODS_TYPE_HOME,                87).   %% 87家园道具
-define(GOODS_TYPE_GIFT_BAG,            88).   %% 88礼包
-define(GOODS_TYPE_OTHER,               89).   %% 89其他类

-define(RUNE_SUBTYPE_DRAGON,            10).   %% 龙玉炼化材料子类型
-define(GIFT_SUBTYPE_NORMAL,            10).   %% 固定类礼包
-define(GIFT_SUBTYPE_RANDOM,            20).   %% 随机类礼包
-define(GIFT_SUBTYPE_SPECIAL,           30).   %% 特殊类礼包
-define(GIFT_SUBTYPE_VIP,               40).   %% Vip礼包
-define(GIFT_SUBTYPE_DIRECT,            80).   %% 直接使用礼包

-define(MOP_UP_CARD,            280133).   %% 扫荡券Id

-define(GOODS_SPECIAL_LIST, [
                             ?GOODS_TYPE_GOLD,
                             ?GOODS_TYPE_BGOLD,
                             ?GOODS_TYPE_COIN,
                             ?GOODS_TYPE_CASH,
                             ?GOODS_TYPE_SEAL,
                             ?GOODS_TYPE_DRAGON_SOUL,
                             ?GOODS_TYPE_VIGOR,
                             ?GOODS_TYPE_FRIENDPOINT,
                             ?GOODS_TYPE_EXP,
                             ?GOODS_TYPE_CROSS_COIN,
                             ?GOODS_TYPE_ARENA_COIN,
                             ?GOODS_TYPE_Q_COIN
                            ]).

-define(GOODS_TYPE_UNIT, 1000000). %%物品段

-define(GOODS_STYLE_BEYON,            1).   %% 特殊素材 - 突破素材

-define(BUY_VIGOR_ONE_TIME, 100).

-define(SHOP_NOT_BUY,         0).
-define(SHOP_BUY,             1).

-define(GOODS_TYPE_SKILL_CARD, 9). %% 技能卡大类型为 9 

-endif.

