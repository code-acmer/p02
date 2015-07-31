%% Warning:本文件由make_record自动生成，请不要手动修改
-ifndef(DB_BASE_CHOUJIANG_HRL).
-define(DB_BASE_CHOUJIANG_HRL, true).
%% base_choujiang => base_choujiang
-record(base_choujiang, {
          id = 0,                               %% 物件id
          goods_id = 0,                         %% 物品id
          goods_num = 0,                        %% 物品num
          lv = 0,                               %% 物件lv
          coin_weight = 0,                      %% 金币抽物件权重
          gold_weight = 0,                      %% 钻石抽物件权重
          career = 0,                           %% 物件适用的职业
          vip = 0,                              %% 物件vip等级
          is_valuable                           %% 是否是贵重物品
         }).
-endif.
