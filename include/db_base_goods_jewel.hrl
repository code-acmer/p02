%% Warning:本文件由make_record自动生成，请不要手动修改
-ifndef(DB_BASE_GOODS_JEWEL_HRL).
-define(DB_BASE_GOODS_JEWEL_HRL, true).
%% base_goods_jewel => base_goods_jewel
-record(base_goods_jewel, {
          id,                                   %% 宝石id
          desc = <<""/utf8>>,                   %% 宝石描述
          meterial = 0,                         %% 合成材料
          price = []                            %% 
         }).
-endif.
