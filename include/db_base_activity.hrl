%% Warning:本文件由make_record自动生成，请不要手动修改
-ifndef(DB_BASE_ACTIVITY_HRL).
-define(DB_BASE_ACTIVITY_HRL, true).
%% base_activity => data_base_activity
-record(data_base_activity, {
          id,                                   %% 
          type,                                 %% 类型 1邮件 2副本 3扭蛋 4技能
          category,                             %% 对应的类型数字
          key,                                  %% 
          req_time,                             %% 
          activity_desc,                        %% 
          client_range,                         %% 填写副本id，用于客户端用
          range,                                %% 
          value,                                %% {邮件title,奖励物品}
          content,                              %% 
          notice,                               %% 系统公告
          start_time,                           %% 公告开始时间
          end_time,                             %% 公告结束时间
          interval                              %% 时间间隔
         }).
-endif.
