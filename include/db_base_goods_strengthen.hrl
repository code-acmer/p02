%% Warning:本文件由make_record自动生成，请不要手动修改
-ifndef(DB_BASE_GOODS_STRENGTHEN_HRL).
-define(DB_BASE_GOODS_STRENGTHEN_HRL, true).
%% base_goods_strengthen => base_goods_strengthen
-record(base_goods_strengthen, {
          id = 0,                               %% 强化升星Id
          name = <<""/utf8>>,                   %% 描述
          value = 0,                            %% 增加属性比例
          consume = [],                         %% 游戏币消耗
          material = [],                        %% 材料消耗
          rate = 0                              %% 成功率
         }).
-endif.
