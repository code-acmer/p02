%% Warning:本文件由make_record自动生成，请不要手动修改
-ifndef(DB_BASE_GOODS_HRL).
-define(DB_BASE_GOODS_HRL, true).
%% base_goods => base_goods
-record(base_goods, {
          id,                                   %% 物品id
          name,                                 %% 物品名称
          icon = 0,                             %% 美术图标id
          desc = <<""/utf8>>,                   %% 物品介绍(0代表没有)
          type = 0,                             %% 物品类型
          sub_type = 0,                         %% 物品子类型
          bind = 1,                             %% 绑定(1不绑定，2使用后绑定，3已绑定)
          trade = 0,                            %% 交易底价(0表示不可交易)
          decompose = 0,                        %% 是否可分解(0不可，1可以)
          decomposition = [],                   %% 分解获得
          reward = [],                          %% 宝箱，礼包里的物品
          career = 0,                           %% 职业限制(0无限制，100八神，200火舞)
          opear_type = 0,                       %% 使用类型
          max_overlap = 0,                      %% 可叠加数(0不可叠加)
          max_strengthen = 0,                   %% 最高强化等级
          strengthen_id = 0,                    %% 强化索引id
          max_star = 0,                         %% 最高升星等级
          star_id = 0,                          %% 升星索引id
          exp = 0,                              %% 技能卡经验
          expire_time = 0,                      %% 有效时间(单位是秒)
          color = 1,                            %% 装备显示的颜色(1,蓝色 2，紫色 3，橙色， 4红色， 5流光)
          quality = 0,                          %% 品质
          lv = 0,                               %% 等级
          hp_lim = 0,                           %% 生命上限
          hp_lim_percent = 0,                   %% 
          mana_lim = 0,                         %% 法力上限
          mana_rec = 0,                         %% 法力恢复
          attack = 0,                           %% 攻击
          attack_percent = 0,                   %% 
          def = 0,                              %% 防御力
          def_percent = 0,                      %% 
          hit = 0,                              %% 命中
          hit_percent = 0,                      %% 
          dodge = 0,                            %% 闪避
          dodge_percent = 0,                    %% 
          crit = 0,                             %% 暴击
          crit_percent = 0,                     %% 
          anti_crit = 0,                        %% 抗暴击
          anti_crit_percent = 0,                %% 
          stiff = 0,                            %% 僵直
          anti_stiff = 0,                       %% 抗僵直
          attack_speed = 0,                     %% 攻击速度
          move_speed = 0,                       %% 移动速度
          ice = 0,                              %% 冰
          fire = 0,                             %% 火
          honly = 0,                            %% 光
          dark = 0,                             %% 暗
          anti_ice = 0,                         %% 冰抗
          anti_fire = 0,                        %% 火抗
          anti_honly = 0,                       %% 光抗
          anti_dark = 0,                        %% 暗抗
          att_rate = 0,                         %% 属性浮动比例(%)
          buff,                                 %% 
          consume = [],                         %% 消耗
          drop = [],                            %% 掉落
          value_meteorite = []                  %% 物品价值
         }).
-endif.
