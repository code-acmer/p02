%% Warning:本文件由make_record自动生成，请不要手动修改
-ifndef(DB_BASE_SHOP_HRL).
-define(DB_BASE_SHOP_HRL, true).
%% base_shop => base_shop
-record(base_shop, {
          id,                                   %% 
          type,                                 %% 
          goods_id,                             %% 
          goods_num,                            %% 
          consume = [],                         %% 
          vip,                                  %% 
          total,                                %% 
          day_lim,                              %% 
          rang_lim                              %% 
         }).
-endif.
