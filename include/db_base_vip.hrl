%% Warning:本文件由make_record自动生成，请不要手动修改
-ifndef(DB_BASE_VIP_HRL).
-define(DB_BASE_VIP_HRL, true).
%% base_vip => base_vip
-record(base_vip, {
          id = 0,                               %% VIP等级
          vip_value = 0,                        %% 对应的vip值
          vip_reward = [],                      %% vip礼包奖励
          times_for_vigor = 0,                  %% 购买体力的次数
          saodang = 0,                          %% 扫荡次数
          ten_saodang = 0,                      %% 扫荡十次
          day_benefits = [],                    %% 每天登陆送奖
          mugen_tower_pass = 0,                 %% 体力购买次数限制
          day_resource_refresh = 0,             %% 资源副本刷新次数
          equip_strength_limit = 0,             %% 是否能超出等级上限的强化
          one_key_strength = 0,                 %% 是否能使用10次强化升星
          mysterious_shop_refresh = 0,          %% 神秘商店刷新次数
          pvp_challange_times = 0,              %% 竞技场购买次数
          fair_challange_times = 0,             %% 公平竞技刷新次数
          cross_challange_time = 0,             %% 跨服竞技场购买次数
          king_dungeon_times = 0,               %% 王者副本次数
          combo_ratio = 0,                      %% 连击宝箱系数
          dungeon_score_ratio = 0,              %% 副本通关评级宝箱系数
          pvp_shop_refresh = 0,                 %% 
          fair_shop_refresh = 0,                %% 
          cross_shop_refresh = 0,               %% 
          guild_shop_refresh,                   %% 
          prentice                              %% 师傅收徒的次数
         }).
-endif.
