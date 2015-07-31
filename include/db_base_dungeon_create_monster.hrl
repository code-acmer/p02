%% Warning:本文件由make_record自动生成，请不要手动修改
-ifndef(DB_BASE_DUNGEON_CREATE_MONSTER_HRL).
-define(DB_BASE_DUNGEON_CREATE_MONSTER_HRL, true).
%% base_dungeon_create_monster => base_dungeon_create_monster
-record(base_dungeon_create_monster, {
          id,                                   %% 怪物点id
          name,                                 %% 名称
          x_pos,                                %% X坐标
          z_pos,                                %% Z坐标
          create_probability,                   %% 创建概率
          create_count,                         %% 群组怪物总数
          create_range,                         %% 创建范围
          create_type,                          %% 
          refresh_type,                         %% 出现方式
          condition                             %% 触发条件
         }).
-endif.
