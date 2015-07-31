%% Warning:本文件由make_record自动生成，请不要手动修改
-ifndef(DB_BASE_COMBAT_SKILL_HRL).
-define(DB_BASE_COMBAT_SKILL_HRL, true).
%% base_combat_skill => base_combat_skill
-record(base_combat_skill, {
          id = 0,                               %% 主动技能ID 唯一ID值
          unique_id = 0,                        %% 唯一技能id
          type = 0,                             %% 技能类型
          uiname = <<""/utf8>>,                 %% 唯一名字
          name = <<""/utf8>>,                   %% 
          desc = <<""/utf8>>,                   %% 技能描述
          icon = 0,                             %% 图标id
          upgrade_id = 0,                       %% 升级索引
          max_upgrade_lv = 0,                   %% 最大升级等级
          strengthen_id = 0,                    %% 强化索引
          max_strengthen_lv = 0,                %% 最大强化等级
          action = 0,                           %% 动作
          skill_count,                          %% 
          condition = []                        %% 符印开放条件
         }).
-endif.
