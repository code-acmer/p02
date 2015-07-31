%% Warning:本文件由make_record自动生成，请不要手动修改
-ifndef(DB_BASE_EQUIPMENT_UPGRADE_HRL).
-define(DB_BASE_EQUIPMENT_UPGRADE_HRL, true).
%% base_equipment_upgrade => ets_base_equipment_upgrade
-record(ets_base_equipment_upgrade, {
          id = 0,                               %% 原装备ID
          next_id = [],                         %% 进阶装备ID
          type = 0,                             %% 进阶类型：1为普通进阶，2为究极进阶
          lv_max_req = 0,                       %% 进阶是否需要满级：0不需要，1需要
          coin = 0,                             %% 该件装备进阶操作所需游戏币消耗
          material01 = 0,                       %% 进阶材料1
          material02 = 0,                       %% 进阶材料2

          material03 = 0,                       %% 进阶材料3
          material04 = 0,                       %% 进阶材料4
          material05 = 0                        %% 进阶材料5
         }).
-endif.
