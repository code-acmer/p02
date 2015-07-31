%% Warning:本文件由make_record自动生成，请不要手动修改
-ifndef(DB_BASE_SHOP_GOODS_HRL).
-define(DB_BASE_SHOP_GOODS_HRL, true).
%% base_shop_goods => ets_shop_goods
-record(ets_shop_goods, {
          id,                                   %% 编号
          shop_id = 0,                          %% 商店ID
          shop_subtype = 0,                     %% 商店子类型，1热卖商品，2坐骑宠物，3辅助材料，4丹药宝石，5礼券商店,6特惠商品
          goods_id = 0,                         %% 物品类型ID
          quantity = 1,                         %% 
          price_type = 0,                       %% 物品价格类型：1元宝，2绑定元宝，3铜钱
          price_old = 0,                        %% 道具原价
          price_now = 0,                        %% 道具现价
          sold_out = 0,                         %% 
          sequence = 0,                         %% 商品排序
          level = 0,                            %% 抽取等级（用于神秘商店的刷新）。
          power = 0                             %% 抽取权重（用于神秘商店的抽取规则）。
         }).
-endif.
