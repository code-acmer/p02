%% Warning:本文件由make_record自动生成，请不要手动修改
-ifndef(DB_BASE_VIP_COST_HRL).
-define(DB_BASE_VIP_COST_HRL, true).
%% base_vip_cost => base_vip_cost
-record(base_vip_cost, {
          id = 0,                               %% 次数
          day_vigor_cost = [],                  %% 体力购买价格
          day_resource_cost = [],               %% 日常资源副本价格
          mysterious_shop_cost = [],            %% 神秘商店刷新价格
          pvp_challange_times_cost = [],        %% 
          fair_shop_refresh_cost = [],          %% 公平竞技神秘商店刷新价格
          cross_challange_times_cost = [],      %% 跨服竞技场重置价格
          cross_shop_refresh_cost = [],         %% 
          king_dungeon_cost = [],               %% 王者副本购买次数价格
          pvp_shop_refresh_cost = [],           %% 
          fair_challange_times_cost = [],       %% 
          guild_shop_refresh_cost = []          %% 军团商城花费
         }).
-endif.
