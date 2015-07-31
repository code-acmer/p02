%% Warning:本文件由make_record自动生成，请不要手动修改
-ifndef(DB_BASE_EQUIPMENT_PROPERTY_HRL).
-define(DB_BASE_EQUIPMENT_PROPERTY_HRL, true).
%% base_equipment_property => ets_base_equipment_property
-record(ets_base_equipment_property, {
          id,                                   %% 唯一id
          hp = 0,                               %% 血量
          attack = 0,                           %% 攻击力
          def = 0,                              %% 防御力
          ice = 0,                              %% 冰元素
          fire = 0,                             %% 火元素
          honly = 0,                            %% 光元素
          dark = 0,                             %% 暗元素
          crit = 0,                             %% 暴击
          ice_up = 0,                           %% 冰元素成长
          fire_up = 0,                          %% 火元素成长
          honly_up = 0,                         %% 光元素成长
          dark_up = 0,                          %% 暗元素成长
          crit_up = 0,                          %% 暴击成长
          hp_up = 0,                            %% 血量成长
          attack_up = 0,                        %% 攻击成长
          def_up = 0,                           %% 防御成长
          exp = 0,                              %% 经验
          exp_ab = 0,                           %% 被吸收时的经验系数（10000为基数）
          memo                                  %% 
         }).
-endif.
