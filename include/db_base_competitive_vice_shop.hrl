%% Warning:本文件由make_record自动生成，请不要手动修改
-ifndef(DB_BASE_COMPETITIVE_VICE_SHOP_HRL).
-define(DB_BASE_COMPETITIVE_VICE_SHOP_HRL, true).
%% base_competitive_vice_shop => base_competitive_vice_shop
-record(base_competitive_vice_shop, {
          id = 0,                               %% 商品Id
          goods_id = 0,                         %% 物品id
          goods_num = 0,                        %% 物品数量
          consume = [],                         %% 商品花费
          lv = 0,                               %% 商品等级
          weight = 0,                           %% 商品权重
          career = 0                            %% 职业
         }).
-endif.
