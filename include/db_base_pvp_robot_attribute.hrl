%% Warning:本文件由make_record自动生成，请不要手动修改
-ifndef(DB_BASE_PVP_ROBOT_ATTRIBUTE_HRL).
-define(DB_BASE_PVP_ROBOT_ATTRIBUTE_HRL, true).
%% base_pvp_robot_attribute => base_pvp_robot_attribute
-record(base_pvp_robot_attribute, {
          id = 0,                               %% 排名
          robot_id = 0,                         %% 机器人id
          name = <<""/utf8>>,                   %% 名字
          career = 1,                           %% 职业
          lv = 0,                               %% 等级
          battle_ability = 0,                   %% 战斗力
          skill_1,                              %% 
          skill_1_lv,                           %% 
          skill_2,                              %% 
          skill_2_lv,                           %% 
          skill_3,                              %% 
          skill_3_lv,                           %% 
          skill_4,                              %% 
          skill_4_lv,                           %% 
          equ_weapon,                           %% 
          equ_clothes,                          %% 
          equ_shoes,                            %% 
          equ_neck,                             %% 
          equ_ring,                             %% 
          equ_pants,                            %% 
          weapon_strengthen = 0,                %% 强化等级
          weapon_star = 0,                      %% 
          clothes_strengthen = 0,               %% -
          clothes_star = 0,                     %% -
          shoes_strengthen = 0,                 %% 
          shoes_star = 0,                       %% 
          neck_strengthen = 0,                  %% 
          neck_star = 0,                        %% 
          ring_strengthen = 0,                  %% 
          ring_star = 0,                        %% 
          pants_strengthen = 0,                 %% 
          pants_star = 0                        %% 
         }).
-endif.
