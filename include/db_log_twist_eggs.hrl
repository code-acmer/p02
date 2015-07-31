%% Warning:本文件由make_record自动生成，请不要手动修改
-ifndef(DB_LOG_TWIST_EGGS_HRL).
-define(DB_LOG_TWIST_EGGS_HRL, true).
%% log_twist_eggs => log_twist_eggs
-record(log_twist_eggs, {
          id,                                   %% 
          pid = 0,                              %% 玩家ID
          type,                                 %% 扭蛋类型:1友情 2金币 
          count,                                %% 扭蛋次数
          goodsinfo,                            %% 获得的物品
          timestamp = 0                         %% 时间戳函数
         }).
-endif.
