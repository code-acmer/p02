%% Warning:本文件由make_record自动生成，请不要手动修改
-ifndef(DB_BASE_PLAYER_HRL).
-define(DB_BASE_PLAYER_HRL, true).
%% base_player => ets_base_player
-record(ets_base_player, {
          lv = 0,                               %% lv
          exp_curr = 0,                         %% 当前等级累计经验
          exp_next = 0,                         %% 升级到下一级所需的经验
          cost = 0,                             %% 负重值
          vigor = 0,                            %% 体力值
          friends = 0,                          %% 基础好友数量上限
          hp_lim = 0,                           %% 生命上限
          mana_lim = 0,                         %% 法力上限
          hp_rec = 0,                           %% 生命回复力
          mana_rec = 0,                         %% 魔法回复力
          ice = 0,                              %% 冰元素
          fire = 0,                             %% 火元素
          honly = 0,                            %% 光元素
          dark = 0,                             %% 暗元素
          anti_ice = 0,                         %% 冰抗性
          anti_fire = 0,                        %% 火抗性
          anti_honly = 0,                       %% 光抗性
          anti_dark = 0,                        %% 暗抗性
          attack = 0,                           %% 初始攻击值
          def = 0,                              %% 初始防御值
          hit = 0,                              %% 命中
          dodge = 0,                            %% 闪避
          crit = 0,                             %% 暴击
          anti_crit = 0,                        %% 暴击抗性
          stiff = 0,                            %% 硬直
          anti_stiff = 0,                       %% 抗硬直
          attack_speed = 1000,                  %% 攻击速度
          move_speed = 2000                     %% 移动速度
         }).
-endif.
