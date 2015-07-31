%% Warning:本文件由make_record自动生成，请不要手动修改
-ifndef(DB_BASE_ONLINE_GIFT_HRL).
-define(DB_BASE_ONLINE_GIFT_HRL, true).
%% base_online_gift => ets_base_online_gift
-record(ets_base_online_gift, {
          id,                                   %% 
          gift_goods = [],                      %% 奖励物品，格式[{1,200,30002},{...},...]大括号中，第一位，1是元宝，2是铜钱，3是物品。第二位是数量，第三位是物品id
          times = 0,                            %% 第几份
          timestamp = 0                         %%  时间间隔
         }).
-endif.
