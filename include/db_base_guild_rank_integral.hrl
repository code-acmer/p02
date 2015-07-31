%% Warning:本文件由make_record自动生成，请不要手动修改
-ifndef(DB_BASE_GUILD_RANK_INTEGRAL_HRL).
-define(DB_BASE_GUILD_RANK_INTEGRAL_HRL, true).
%% base_guild_rank_integral => base_guild_rank_integral
-record(base_guild_rank_integral, {
          id,                                   %% 
          rank_wage,                            %% 段位日奖励
          rank_score,                           %% 段位积分最小值
          name = ""                             %% 段位名
         }).
-endif.
