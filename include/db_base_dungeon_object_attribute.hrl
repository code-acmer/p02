%% Warning:本文件由make_record自动生成，请不要手动修改
-ifndef(DB_BASE_DUNGEON_OBJECT_ATTRIBUTE_HRL).
-define(DB_BASE_DUNGEON_OBJECT_ATTRIBUTE_HRL, true).
%% base_dungeon_object_attribute => base_dungeon_object_attribute
-record(base_dungeon_object_attribute, {
          id,                                   %% 编号
          object,                               %% 物件名
          name,                                 %% 名称
          object_scale,                         %% 物件尺寸
          extra_x_size,                         %% 碰撞框X轴修正值
          extra_z_size,                         %% 碰撞框Z轴修正值
          model_type,                           %% 资源库(1.图片 2.模型)
          model_name,                           %% 资源名称
          is_flip,                              %% 是否翻转
          type,                                 %% 设置点的类型
          penetrate,                            %% 是否可穿越
          move,                                 %% 是否移动
          destroy,                              %% 是否破坏
          object_drop,                          %% 物件掉落
          object_event,                         %% 物件事件
          lv = 0,                               %% 等级
          hp_lim = 0,                           %% 生命上限
          attack = 0,                           %% 攻击
          def = 0,                              %% 防御
          attack_effect = 0,                    %% 攻击效果
          def_effect = 0,                       %% 防御效果
          hit = 0,                              %% 命中
          dodge = 0,                            %% 闪避
          crit = 0,                             %% 暴击
          anti_crit = 0,                        %% 暴击抗性
          stiff = 0,                            %% 僵直
          anti_stiff = 0,                       %% 硬直
          attack_speed = 0,                     %% 攻击速度
          move_speed = 0,                       %% 移动速度
          ice = 0,                              %% 冰属性
          fire = 0,                             %% 火属性
          honly = 0,                            %% 光属性
          dark = 0,                             %% 暗属性
          anti_ice = 0,                         %% 冰属性抗性
          anti_fire = 0,                        %% 火属性抗性
          anti_honly = 0,                       %% 光属性抗性
          anti_dark = 0                         %% 暗属性抗性
         }).
-endif.
