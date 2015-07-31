%% Warning:本文件由make_record自动生成，请不要手动修改
-ifndef(DB_BASE_RANK_REWARD_HRL).
-define(DB_BASE_RANK_REWARD_HRL, true).
%% base_rank_reward => base_rank_reward
-record(base_rank_reward, {
          id = 0,                               %% 排名
          world_boss1 = [],                     %% 世界boss奖励
          world_boss2 = [],                     %% 
          world_boss3 = [],                     %% 
          super_battle = [],                    %% 公平竞技
          mugen = [],                           %% 爬塔
          battle_ability = [],                  %% 战力排行榜（周）
          golden = [],                          %% 金币排行榜周
          coins = [],                           %% 铜钱周排行榜
          boss_open = []                        %% 周开启boss排行榜
         }).
-endif.
