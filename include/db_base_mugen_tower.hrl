%% Warning:本文件由make_record自动生成，请不要手动修改
-ifndef(DB_BASE_MUGEN_TOWER_HRL).
-define(DB_BASE_MUGEN_TOWER_HRL, true).
%% base_mugen_tower => base_mugen_tower
-record(base_mugen_tower, {
          id = 0,                               %% 层数
          scenepic = <<""/utf8>>,               %% 图片配置
          area_id = 0,                          %% 副本id
          normal_reward = [],                   %% 过关奖励
          challenge_reward = [],                %% 好友挑战奖励
          lucky_reward = [],                    %% 幸运币奖励
          reward1 = [],                         %% 10秒
          reward2 = [],                         %% 连击不断
          reward3 = [],                         %% 反击3次
          reward4 = [],                         %% 无伤
          skip_cost1 = [],                      %% 跳关消耗1
          skip_cost2 = []                       %% 跳关消耗2
         }).
-endif.
