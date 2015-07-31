%% Warning:本文件由make_record自动生成，请不要手动修改
-ifndef(DB_BASE_MON_HRL).
-define(DB_BASE_MON_HRL, true).
%% base_mon => ets_base_mon
-record(ets_base_mon, {
          id = 0,                               %% 怪物编号
          name = <<""/utf8>>,                   %% 名字
          icon = 0,                             %% 图标资源id
          portrait = 0,                         %% 头像资源id
          animation = 0,                        %% 模型动作资源id
          lv = 0,                               %% 怪物等级
          quality = 0,                          %% 怪物星级
          type = 1,                             %% 1怪物2精英3boss11障碍物12陷阱13补给
          patrol_area = 0,                      %% 巡逻范围
          trace_area = 0,                       %% 追踪范围
          guard_area = 0,                       %% 警戒范围
          speed = 0,                            %% 移动速度
          time_dis = 0,                         %% 0不消失，指定秒数后消失
          element = 0,                          %% 主属性
          active_skill = 0,                     %% 主动技能
          passive_skill = 0,                    %% 被动技能
          ai = 0,                               %% 普通ai
          property = 0,                         %% 怪物属性
          property_max = 0,                     %% 怪物属性最大值（若有值则会随机选择一个范围）
          mon_drop,                             %% 励奖字段
          desc                                  %% 用“|”分隔的怪物台词。
         }).
-endif.
