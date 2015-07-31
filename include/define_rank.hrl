-ifndef(DEFINE_RANK_HRL).
-define(DEFINE_RANK_HRL, true).
-record(rank,{
          value,
          player_id,
          ext
         }).

-record(rank_reset_info, {
          table,
          reset_type,
          max_size,
          reward_flag}).

-define(RANK_REWARD_FALSE, 0).
-define(RANK_REWARD_TRUE, 1).

%%key暂时是2，3元的，而且最后一个是playerid
%%所有排行榜的      key     value
%%level_rank      {Level, -Now, PlayerId}     {NickName, Career, Ability}
%%Ability_rank     {NewAbility, PlayerId}     {NickName, Career, Level}
%%mugen_rank & super_battle_rank   {Pass, Score, PlayerId}  {Nickname, lv, career, battle_ability}
%%表名 最大长度 重置类型 是否发奖(daily weekly monthly)
-define(ALL_RANK, [{mugen_rank, 500, daily, ?RANK_REWARD_TRUE}, 
                   %{super_battle_rank, 500, daily, ?RANK_REWARD_TRUE},
                   %{level_rank, 500, undefined, ?RANK_REWARD_FALSE},
                   {battle_ability_rank, 500, weekly, ?RANK_REWARD_TRUE},
                   {cost_coin_rank, 500, weekly, ?RANK_REWARD_TRUE}, 
                   {cost_gold_rank, 500, weekly, ?RANK_REWARD_TRUE},
                   {world_boss_rank, 500, weekly, ?RANK_REWARD_TRUE},
                   %%这条是特殊的,因为他的结构 不是#rank，确切来说不是规范的
                   %%所以不能用insert等接口，但可以用来发奖，500也是没用
                   {async_arena_rank, 500, daily, ?RANK_REWARD_TRUE}
                  ]).

-endif.
