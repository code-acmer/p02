%% Warning:本文件由make_record自动生成，请不要手动修改
-ifndef(DB_BASE_DUNGEON_DETAIL_HRL).
-define(DB_BASE_DUNGEON_DETAIL_HRL, true).
%% base_dungeon_detail => base_dungeon_detail
-record(base_dungeon_detail, {
          id,                                   %% 关卡id
          name,                                 %% 关卡名称
          desc,                                 %% 关卡描述
          goal,                                 %% 通关条件
          map_id,                               %% 场景id
          portal_create_id,                     %% 传送门
          monster_create_id,                    %% 怪物点
          object_create_id,                     %% 物件点
          decoration_create_id,                 %% 挂件点
          has_boss,                             %% BOSS预警效果
          buff,                                 %% 关卡buff
          sound,                                %% 关卡音乐
          player_x_pos,                         %% 出生点x坐标
          player_z_pos,                         %% 出生点z坐标
          drama_map_id,                         %% 
          drama_decoration_create_id,           %% 
          drama                                 %% 
         }).
-endif.
