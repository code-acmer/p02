%% Warning:本文件由make_record自动生成，请不要手动修改
-ifndef(DB_BASE_EQUIPMENT_HRL).
-define(DB_BASE_EQUIPMENT_HRL, true).
%% base_equipment => ets_base_equipment
-record(ets_base_equipment, {
          id = 0,                               %% 装备base_id
          nid = 0,                              %% 图谱编号
          name,                                 %% 装备名称
          icon = 0,                             %% icon编号
          res_id = 0,                           %% 美术资源编号
          desc,                                 %% 装备描述
          type = 81,                            %% 装备类型：统一为81，表示装备
          subtype = 0,                          %% 装备子类型
          coin = 0,                             %% 售卖基础价格（0为不可售卖）
          quality = 0,                          %% 品质星级，填1-8分别对应1-8星
          cost = 0,                             %% 对应装备的cost点数值
          lv_lim = 0,                           %% 对应装备的最大等级上限
          beyond = 0,                           %% 突破次数，填0为不可突破
          element = 0,                          %% 分别代表：1-冰，2-火，3-光，4-暗
          sub_element = 0,                      %% 分别代表：1-火，2-水，3-木，4-光，5-暗，0表示没有副属性
          style = 0,                            %% 流派（具体意义待定）
          sub_style = 0,                        %% 流派（具体意义待定）
          property = 0,                         %% 对应装备LV1-LVxxx的强化属性表的索引ID
          lead_skill = 0,                       %% 核心技能的索引ID，填0为没有
          lead_skill2 = 0,                      %% 核心技能2的索引ID，填0为没有
          active_skill = 0,                     %% 主动技能的索引ID，填0为没有
          rate_skill_upgrade = 0,               %% 主动技能升级概率
          master_skills,                        %% 觉醒技能的索引ID，填0为没有，1001,1002,1003，逗号隔开表示数量，最多支持同一装备10个觉醒技能的预留
          rate_master_skill_active = 0,         %% 觉醒技能同类卡片激活概率
          upgrade = 0,                          %% 不可进阶填0，可进阶填索引进阶表的ID
          due_time = 0,                         %% 预留项，物品的有效时间，填0为不限，填数值为该物品的有效时间，时间到既消失，单位为秒
          ext_rate = []                         %% [{hp,rate,1},{def,}]
         }).
-endif.
