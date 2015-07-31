%% Warning:本文件由make_record自动生成，请不要手动修改
-ifndef(DB_BASE_COMBAT_BUFF_HRL).
-define(DB_BASE_COMBAT_BUFF_HRL, true).
%% base_combat_buff => base_combat_buff
-record(base_combat_buff, {
          id = 0,                               %% buff的id
          unique_id = 0,                        %% 唯一码。唯一码相同的buff不能叠加
          lv = 0,                               %% 等级
          name,                                 %% buff名称
          desc,                                 %% buff描述
          icon = 0,                             %% 图标、效果等
          element = 0,                          %% 属性
          type,                                 %% 类型
          ignore_type = 0,                      %% 持续类型
          value = 0,                            %% 值
          value_rate = 0,                       %% 百分比值
          trigger = 0,                          %% 触发类型
          trigger_rate = 0,                     %% 触发概率
          continue = 0,                         %% 持续时间（ms）
          remove = 0                            %% 1、受击移除2、不移除
         }).
-endif.
