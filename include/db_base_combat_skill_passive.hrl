%% Warning:本文件由make_record自动生成，请不要手动修改
-ifndef(DB_BASE_COMBAT_SKILL_PASSIVE_HRL).
-define(DB_BASE_COMBAT_SKILL_PASSIVE_HRL, true).
%% base_combat_skill_passive => base_combat_skill_passive
-record(base_combat_skill_passive, {
          id = 0,                               %% 技能ID 唯一值
          unique_id = 0,                        %% 技能ID
          lv = 0,                               %% 当前技能的技能等级
          max_lv = 0,                           %% 最大技能等级
          name = 0,                             %% 技能名称
          desc,                                 %% 技能描述
          trigger = 0,                          %% 触发条件1、初始化触发，永久被动(无value值)2、生命百分比大于多少触发3、生命百分比小于等于多少触发4、连击数触发5、受到致命一击触发(无value值)6、时间触发7、攻击触发(无value值)8、受击触发(无value值)
          value = <<""/utf8>>,                  %% 值
          ele_effect = <<""/utf8>>,             %% 元素效果
          style_effect,                         %% 派系效果
          other_effect,                         %% 其他效果
          buff_id = 0,                          %% buff值
          cd                                    %% 触发冷却时间
         }).
-endif.
