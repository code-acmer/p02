%% Warning:本文件由make_record自动生成，请不要手动修改
-ifndef(DB_BASE_DUNGEON_CREATE_PORTAL_HRL).
-define(DB_BASE_DUNGEON_CREATE_PORTAL_HRL, true).
%% base_dungeon_create_portal => base_dungeon_create_portal
-record(base_dungeon_create_portal, {
          id,                                   %% 传送门id
          name,                                 %% 名称
          resource,                             %% 资源路径
          filename,                             %% 资源名称
          x_pos,                                %% 传送门X坐标
          y_pos,                                %% 传送门Y坐标
          z_pos,                                %% 传送门Z坐标
          is_flip,                              %% 是否翻转
          next_id,                              %% 下一关卡
          create_count,                         %% 传送门总数
          create_range                          %% 创建范围
         }).
-endif.
