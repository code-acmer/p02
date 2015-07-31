%% Warning:本文件由make_record自动生成，请不要手动修改
-ifndef(DB_BASE_GENERAL_STORE_HRL).
-define(DB_BASE_GENERAL_STORE_HRL, true).
%% base_general_store => base_general_store
-record(base_general_store, {
          id,                                   %% 商品Id
          goods_id = 0,                         %% 物品Id
          goods_num = 0,                        %% 物品数量
          consume = [],                         %% 商品花费
          lv = 0,                               %% 购买该商品等级
          weight = 0,                           %% 购买该商品权重
          career = 0,                           %% 职业
          store_type = 0,                       %% 储存类型
          show_type = 0,                        %% 是否一定要展示
          level_limit = 0                       %% 等级限制
         }).
-endif.
