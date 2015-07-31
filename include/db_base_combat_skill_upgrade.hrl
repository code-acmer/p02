%% Warning:本文件由make_record自动生成，请不要手动修改
-ifndef(DB_BASE_COMBAT_SKILL_UPGRADE_HRL).
-define(DB_BASE_COMBAT_SKILL_UPGRADE_HRL, true).
%% base_combat_skill_upgrade => base_combat_skill_upgrade
-record(base_combat_skill_upgrade, {
          id = 0,                               %% 技能id
          name = <<""/utf8>>,                   %% 名称
          damage = 0,                           %% 伤害
          fixed_damage = 0,                     %% 基础固定伤害
          consume = [],                         %% 升级消耗
          req_lv = 0,                           %% 需求玩家等级
          desc,                                 %% 
          sp,                                   %% 
          cd,                                   %% 
          add_attr = <<""/utf8>>                %% 附加属性
         }).
-endif.
