%% Warning:本文件由make_record自动生成，请不要手动修改
-ifndef(DB_BASE_DUNGEON_MONSTERS_ATTRIBUTE_HRL).
-define(DB_BASE_DUNGEON_MONSTERS_ATTRIBUTE_HRL, true).
%% base_dungeon_monsters_attribute => base_dungeon_monsters_attribute
-record(base_dungeon_monsters_attribute, {
          id,                                   %% 怪物id
          name,                                 %% 怪物名称
          icon,                                 %% 头像资源
          portrait,                             %% 模型
          monster_scale,                        %% 生物尺寸
          type,                                 %% 生物类型
          patrol_area,                          %% 巡逻范围
          trace_area,                           %% 追踪范围
          guard_area,                           %% 警戒范围
          speed,                                %% 移动速度
          time_dis,                             %% 存在时间
          active_skill,                         %% 主动技能
          passive_skill,                        %% 被动技能
          ai,                                   %% 普通ai
          ai_change,                            %% 
          ai_level,                             %% 
          hurt_event,                           %% 受伤ai
          dead_event,                           %% 死亡ai
          mon_drop,                             %% 怪物掉落
          desc,                                 %% 台词
          lv,                                   %% 等级
          hp_lim = 0,                           %% 生命
          attack = 0,                           %% 攻击
          def = 0,                              %% 防御
          attack_effect = 0,                    %% 攻击效果
          def_effect = 0,                       %% 防御效果
          hit = 0,                              %% 命中
          dodge = 0,                            %% 闪避
          crit = 0,                             %% 暴击
          anti_crit = 0,                        %% 抗暴击
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
          anti_dark = 0,                        %% 暗属性抗性
          mon_drop2 = []                        %% 特殊时段boss掉落
         }).
-endif.
