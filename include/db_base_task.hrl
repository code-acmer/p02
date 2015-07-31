%% Warning:本文件由make_record自动生成，请不要手动修改
-ifndef(DB_BASE_TASK_HRL).
-define(DB_BASE_TASK_HRL, true).
%% base_task => base_task
-record(base_task, {
          id,                                   %% 唯一Id
          name = <<""/utf8>>,                   %% 任务名称
          desc = <<""/utf8>>,                   %% 任务描述
          type = 1,                             %% 任务类型
          subtype = 0,                          %% 子类型
          previous = 0,                         %% 前置任务
          level = 0,                            %% 等级限制
          circle_type = 0,                      %% 循环类型(1是普通起止，2日循环，3周循环，4月循环)
          time = [],                            %% 时间限制
          end_time = [],                        %% 活动结束时间
          condition = [],                       %% 完成条件
          func,                                 %% 
          reward = [],                          %% 奖励
          next = 0,                             %% 后续任务
          give_up = 0,                          %% 是否能放弃(0不可,1可以)
          double_time = [],                     %% 双倍奖励时间
          liveness_reward = 0                   %% 活跃度
         }).
-endif.
