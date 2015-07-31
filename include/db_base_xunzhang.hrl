%% Warning:本文件由make_record自动生成，请不要手动修改
-ifndef(DB_BASE_XUNZHANG_HRL).
-define(DB_BASE_XUNZHANG_HRL, true).
%% base_xunzhang => base_xunzhang
-record(base_xunzhang, {
          id = 0,                               %% 物品id
          next_id = 0,                          %% 下个物品索引
          lv = 0,                               %% 玩家等级
          consume = []                          %% 花费
         }).
-endif.
