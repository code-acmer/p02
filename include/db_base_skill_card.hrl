%% Warning:本文件由make_record自动生成，请不要手动修改
-ifndef(DB_BASE_SKILL_CARD_HRL).
-define(DB_BASE_SKILL_CARD_HRL, true).
%% base_skill_card => base_skill_card
-record(base_skill_card, {
          card_id,                              %% 技能卡id
          skill_id,                             %% 技能id
          star_lv,                              %% 星级
          skill_name,                           %% 技能名
          career,                               %% 职业
          type,                                 %% 技能类型
          attribute = [],                       %% 
          teach_skill = []                      %% 传承卡
         }).
-endif.
