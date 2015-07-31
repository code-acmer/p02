%% Warning:本文件由make_record自动生成，请不要手动修改
-ifndef(DB_BASE_DUNGEON_CREATE_OBJECT_HRL).
-define(DB_BASE_DUNGEON_CREATE_OBJECT_HRL, true).
%% base_dungeon_create_object => base_dungeon_create_object
-record(base_dungeon_create_object, {
          id,                                   %% 物件id
          name,                                 %% 名称
          x_pos,                                %% 物件点X坐标
          y_pos,                                %% 物件点Y坐标
          z_pos,                                %% 物件点Z坐标
          is_flip,                              %% 是否翻转
          create_probability,                   %% 创建概率
          create_count,                         %% 物件总数
          create_range                          %% 创建范围
         }).
-endif.
