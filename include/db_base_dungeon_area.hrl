%% Warning:本文件由make_record自动生成，请不要手动修改
-ifndef(DB_BASE_DUNGEON_AREA_HRL).
-define(DB_BASE_DUNGEON_AREA_HRL, true).
%% base_dungeon_area => base_dungeon_area
-record(base_dungeon_area, {
          id,                                   %% 场景id
          name,                                 %% 场景名称
          name_icon,                            %% 名称图标
          desc,                                 %% 描述
          type,                                 %% 类型
          icon,                                 %% 美术资源
          lv,                                   %% 等级
          area_id,                              %% 区域id
          dungeon_id,                           %% 副本id
          condition,                            %% 开启条件
          dungeon_type,                         %% 副本类型
          req_vigor,                            %% 体力消耗
          reward,                               %% 通关基本奖励
          soul_id,                              %% 奖励显示
          req_time,                             %% 开启时间
          max_times,                            %% 次数限制
          goal,                                 %% 通关条件
          score_reward = [],                    %% 评级奖励
          first_reward,                         %% 加成奖励
          buff,                                 %% 副本buff
          hit_reward = [],                      %% 连击宝箱
          hit_reward_detail = [],               %% 连击宝箱规则
          sub_dungeon_id,                       %% 第一个子关卡id
          free_card_reward = [],                %% 免费翻牌奖励
          free_card_times = 1,                  %% 免费翻牌次数
          pay_card_reward = [],                 %% 付费翻牌奖励
          pay_card_times = 1,                   %% 付费翻牌次数
          pay_card_consume = <<""/utf8>>,       %% 付费翻牌消耗
          relive = 0,                           %% 复活次数
          relive_cost = [],                     %% 复活消耗
          target_reward = [],                   %% 目标奖励
          boss_id = 0,                          %% Boss Id
          task_id = 0,                          %% 任务id
          boss_skill_piece,                     %% 
          boss_icon                             %% 
         }).
-endif.
