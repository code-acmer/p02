
-ifndef(DEFINE_GOODS_HRL).
-define(DEFINE_GOODS_HRL,true).

-include("db_base_goods.hrl").
-include("db_base_goods_att_lv.hrl").
-include("db_base_goods_att_rand.hrl").
-include("db_base_goods_att_color.hrl").
-include("db_base_goods_jewel.hrl").
-include("db_base_goods_color_hole.hrl").
-include("db_base_goods_strengthen.hrl").
-include("db_base_shop.hrl").
-include("define_goods_rec.hrl").
-include("db_base_skill_exp.hrl").

%% BAG Container定义

%% 物品颜色定义
-define(WHITE, 0).		%%白色
-define(GREEN, 1).		%%绿色
-define(BLUE, 2).		%%蓝色
-define(PURPLE, 3).		%%紫色
-define(ORANGE, 4).		%%橙色
-define(RED, 5).        %%红色

%% 绑定类型：0没绑定，1使用后绑定，2已绑定
%% 统一成一样的
-define(GOODS_BOUND_DEFAULT,  0).               %%使用默认配制表的绑定
-define(GOODS_NOT_BIND,       1).               %% 非绑定
-define(GOODS_BIND_WHEN_USED, 2).               %% 使用后绑定
-define(GOODS_BOUND,          3).               %% 已经绑定

%%装备属性
-record(equip_attribute,{
		hp = 0,						%%生命值
		attack = 0,					%%攻击
		def = 0,					%%防御
		magic_attack = 0,			%%法术攻击
		magic_def = 0,				%%法术防御
		stunt_attack = 0,			%%绝技攻击
		stunt_def = 0,				%%绝技防御
		hit = 0,					%%命中
		dodge = 0,					%%躲闪
		crit = 0,					%%暴击
		parry = 0,					%%格挡
		counter = 0,				%%反击
		force = 0,					%%武力
		magic = 0,					%%法术
		stunt = 0					%%绝技
}).


-record(player_goods, {player_id  = 1,
                       goods_list = [],
                       update_timestamp = 0
                      }).

%% 神秘商店的商品
-record(mdb_shop_msg,
        {
          base_id,        %%  商品属性
          version = mdb_shop_msg_version:current_version(),
          is_buy = 0,       %%  商品是否被购买
          pos = 0         %%  商品位置
        }).

%% 神秘商店
-record(sterious_shop, 
        {
          player_id = 0,                   %% 玩家ID
          version = sterious_shop_version:current_version(),
          shop_list = [],                  %% 神秘商店信息
          shop_last_refresh_time = 0,      %% 最后一次神秘商店刷新 时间戳
          shop_refresh_num = 0,            %% 神秘商店一天内刷新次数
          is_dirty = 0                     %% 商店数据变换的标记，用于优化数据库插入
        }).

%% 普通商城的热卖商品
-record(ordinary_shop_msg,
        {
          base_id,        %%  商品属性
          version = ordinary_shop_msg_version:current_version(),
          buy_num = 0,     %%  商品一天内被购买次数
          is_dirty = 0
        }).

%% 玩家的普通商城购买信息
-record(ordinary_shop,
        {
          player_id,       
          version = ordinary_shop_version:current_version(),
          shop_list = [],  %% [{id, num}, {id, num}, {id, num} ... ]
          is_dirty = 0
        }).

%% 竞技场普通商城的热卖商品
-record(main_shop_msg,
        {
          base_id,        %%  商品属性
          version = main_shop_msg_version:current_version(),
          buy_num = 0,     %%  商品一天内被购买次数
          is_dirty = 0
        }).

%% 竞技场玩家的普通商城购买信息
-record(main_shop,
        {
          player_id,
          version = main_shop_version:current_version(),
          shop_list = [],  %% [{id, num}, {id, num}, {id, num} ... ]
          is_dirty = 0
        }).

%% 抢购商店的商品信息
-record(activity_shop_msg,
        {
          base_id,
          version = activity_shop_msg_version:current_version(),
          goods_id,
          buy_num = 0, %% 实时购买总次数
          num_limit = 0,
          is_dirty = 0,
          activity_id
        }).

%% 玩家抢购商品的购买记录
-record(activity_shop_record,
        {
          player_id,
          version = activity_shop_record_version:current_version(),
          activity_id,
          shop_list = [], %% [{Id, Num} ... ]
          is_dirty = 0
        }).

-record(choujiang_info,
        {
          player_id,
          version = choujiang_info_version:current_version(),
          coin_timestamp = 0,
          gold_timestamp = 0,
          coin_free_num = 0,
          is_coin_first = 0,
          is_gold_first = 0,
          is_dirty = 0
        }).

%% 竞技场神秘商店
-record(vice_shop, 
        {
          player_id = 0,                   %% 玩家ID
          version = vice_shop_version:current_version(),
          shop_list = [],                  %% 神秘商店信息
          shop_last_refresh_time = 0,      %% 最后一次神秘商店刷新 时间戳
          shop_refresh_num = 0,            %% 神秘商店一天内刷新次数
          is_dirty = 0                     %% 商店数据变换的标记，用于优化数据库插入
        }).

%% 通用性神秘商店
-record(general_store,
        {
          id = 0,
          version = general_store_version:current_version(),
          player_id = 0,
          store_type = 0,
          shop_list = [],             %% 神秘商店信息
          last_refresh_time = 0,      %% 最后一次神秘商店刷新 时间戳
          refresh_num = 0,            %% 神秘商店一天内刷新次数
          is_dirty = 0                %% 商店数据变换的标记，用于优化数据库插入
        }).


-record(fashion_record, 
        {
          id = 0,
          version = fashion_record_version:current_version(),
          fashion_base_ids = [], %% 购买后拥有的时装
          wear_history = [],     %% 穿戴时装记录[{timestamp, goods_id}, ...]
          take_off_history = []  %% 脱下时装记录[{timestamp, goods_id}, ...]
        }).


-define(TYPE_GOODS_STRENGTH, 1).
-define(TYPE_GOODS_ADD_STAR, 2).

-define(ENSURE_UPGRADE_TIMES, 3). %% 确保升级的次数

-define(TYPE_GOODS_SOURCE,    1).  %%资源
-define(TYPE_GOODS_EQUIPMENT, 2).  %%装备
-define(TYPE_GOODS_METERIAL,  3).  %%材料
-define(TYPE_GOODS_PACKET,    5).  %%礼包
-define(TYPE_GOODS_JEWEL,     6).  %%宝石
-define(TYPE_GOODS_UNUSED,    7).  %%不能领取的
-define(TYPE_GOODS_SKILL_EXP, 8).  %%技能经验
-define(TYPE_GOODS_SKILL_CARD, 9). %%技能卡
-define(TYPE_GOODS_FAHSION,   90). %%时装

-define(TYPE_GOODS_PAY_SUBTYPE,  9901). %%红包子类型
-define(TYPE_GOODS_PAY_TYPE,       99). %%红包类型

-define(BASE_RATE,    100).
-define(EQUIP_NO_LIMIT, 0). %%装备没有职业限制
-define(PURPLE_EQUIP,   2). %%紫色装备
-define(ORANGE_EQUIP,   3). %%橙色装备

%% 时装
-define(FASHION_NO_LIMIT, 0). %%装备没有职业限制

-define(SKILL_UPGRADE,    1).
-define(SKILL_STRENGTHEN, 2).

%-define(BUY_VIGOR_MAX_NUM, 10).
-define(BUY_VIGOR_VAULE, 50).

%% 神秘商店相关
-define(STERIOUS_SHOP_RAND_NUM, 8).  %%商品随机次数
-define(LV_LIMIT,              20).  %%商品等级上下限20
-define(GET_SHOP,               1).  %%玩家请求（花钱）
-define(REFRESH_SHOP,           0).  %%玩家请求（不花钱）

%% 商城相关
-define(ORDINARY_SHOP,   1).
-define(BUY_NUM_LIMIT, 10000). %% 日购买商品数限制
-define(ORDINARY_SHOP_SAVE_TIME, 300000).  %% 5分钟保存一次ordinary_shop_list数据

%% 通用神秘商城
-define(PVP_SHOP, 1). %% 竞技场商城
-define(PVP_SHOP_NUM, 8). %%pvp神秘商城的商品数量

-define(FAIR_CHALLANGE_SHOP, 2). %% 公平竞技场商城
-define(FAIR_CHALLANGE_SHOP_NUM, 8). %% 公平竞技场商城商品数量

-define(CROSS_SHOP, 3). %%跨服竞技场商城
-define(CROSS_SHOP_NUM, 8). %% 跨服竞技场商城商品数量

-define(LEAGUE_SHOP, 4). %% 公会商城

%% 抢购
-define(ACTIVITY_SHOP,   3).

%% 子类型
-define(XUNZHANG_SUBTYPE, 2206).

%% 扭蛋抽奖
-define(TWIST_EGG_COMMON_COIN,  -2).
-define(TWIST_EGG_COMMON_GOLD,  -1).
-define(TWIST_EGG_SPECIAL,       0). %%
%% 潜规则类型
-define(COIN_TWIST_EGG_FIRST,     1). %% 金币首抽
-define(COIN_TWIST_EGG_TEN,       2). %% 金币十连抽
-define(GOLD_TWIST_EGG_FIRST,     3). %% 钻石首抽
-define(GOLD_TWIST_EGG_TEN,       4). %% 钻石十连抽
-define(GOLD_TWIST_EGG_GOLD_NUM,  5). %% 钻石之五星卡保底抽
%% 抽奖业务相关
-define(COIN_FREE_NUM_MAX, 5). %% 一天内免费次数上限
-define(COIN_FREE_TIME, 300).
-define(GOLD_FREE_TIME, 3600*72).

-define(COST_COIN_CHOUJIANG_ONE, 2000). %% 金币购买一次抽奖机会
-define(COST_GOLD_CHOUJIANG_ONE, 300). %% 钻石购买一次抽奖机会
-define(COST_COIN_CHOUJIANG_TEN, 18000). %% 金币购买十次抽奖机会
-define(COST_GOLD_CHOUJIANG_TEN, 2700). %% 钻石购买十次抽奖机会

-define(CHOUJIANG_IS_FREE,  0). %% 抽奖免费
-define(CHOUJIANG_NO_FREE,  1). %% 抽奖收费

-define(CHOUJIANG_COIN_IS_FREE,  0). %% 金币类型免费
-define(CHOUJIANG_GOLD_IS_FREE,  1). %% 钻石类型免费

-define(CHOUJIANG_COIN_NO_FREE,  0). %% 金币类型收费
-define(CHOUJIANG_GOLD_NO_FREE,  1). %% 钻石类型收费

-define(CHOUJIANG_NUM_ONE,  1). %% 抽奖一次
-define(CHOUJIANG_NUM_TEN, 10). %% 抽奖十次

-define(CHOUJIANG_LV_OFF,  10). %% 等级段，目前需求是10级一段

-define(CHOUJIANG_FIVE_STAR, 1). %% 五星级卡的抽奖限制数
-define(CHOUJIANG_GOLD_NUM, 40). %% 五星级卡保底抽奖

-define(AEROLITE_ID,      280134).  %% 陨石id

-endif.

