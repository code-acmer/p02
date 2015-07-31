%% Warning:本文件由make_record自动生成，请不要手动修改
-ifndef(DB_BASE_COMBAT_SKILL_STRENGTHEN_HRL).
-define(DB_BASE_COMBAT_SKILL_STRENGTHEN_HRL, true).
%% base_combat_skill_strengthen => base_combat_skill_strengthen
-record(base_combat_skill_strengthen, {
          id = 0,                               %% 唯一Id
          name = <<""/utf8>>,                   %% 名称
          probability = 0,                      %% 技能释放成功率
          consume = [],                         %% 强化消耗
          desc                                  %% 
         }).
-endif.
