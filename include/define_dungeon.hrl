-ifndef(DEFINE_DUNGEON_HRL).
-define(DEFINE_DUNGEON_HRL,true).

-include("db_base_dungeon_area.hrl").
-include("db_base_dungeon_detail.hrl").
-include("db_base_dungeon_create_monster.hrl").
-include("db_base_dungeon_monsters_attribute.hrl").
-include("db_base_dungeon_create_portal.hrl").
-include("db_base_dungeon_create_object.hrl").
-include("db_base_dungeon_object_attribute.hrl").
-include("db_base_daily_dungeon_info.hrl").
-include("db_base_daily_dungeon_lv.hrl").
-include("db_base_daily_dungeon_condition.hrl").
-include("db_base_mugen_tower.hrl").
-include("db_base_monster_level_attribute.hrl").
-include("define_daily_dungeon_rec.hrl").
-include("db_base_dungeon_target.hrl").

%%%------------------------------------------------
%%% File    : common.hrl
%%% Created : 2010-09-15
%%% Description: 公共定义
%%%------------------------------------------------

%%新建的dungeon结构，记录玩家副本信息
-record(dungeon, {id = 0,
                  version = dungeon_version:current_version(),
                  base_id = 0,
                  player_id = 0,
                  best_score = 0,   %%最高分数
                  best_pass = 0,    %%通关时间最好记录
                  done = 0,         %%通关次数
                  boss_win_times = 0, %%抢夺boss的胜场
                  boss_fail_times = 0,
                  best_grade = 0,   %%最好的评级
                  dungeon_level = 0,
                  left_times = 0,
                  buy_times = 0,
                  target_list = [],
                  dirty = 0,
                  boss_reward_flag = 0     %% 潜规则标记 0 暂未掉落， 1 已掉落
                 }).

%% %%副本奖励的每一项
%% -record(reward_item,{
%%           id     = 0,    %%奖励编号
%%           goods_id   = 3,    %%奖励种类，1为元宝，3为铜钱，6龙魄 ... 80+为普通物品
%%           num        = 100,  %%奖励数目
%%           bind       = ?GOODS_BOUND,     %%奖励的物品id
%%           value1 = 0, %%普通类型0,特殊类型1
%%           value2 = 0   %%第几天
%%          }).
-define(MOP_UP_PAY_CARD, 1).

-define(GUARD_REVIVE_TICK, 30).         %% 复活时间30秒
-define(GUARD_REVIVE_SECONDS, 30).      %% 复活时间20秒
-define(MON_BATTLE_TICK, 5).            %% 怪物战斗状态持续时间，5秒
-define(MON_BATTLE_SECONDS, 5).

-define(TEAM_FLAG_NONE, 0). %%不允许乱入
-define(TEAM_FLAG_PLAYER, 1). %%玩家乱入
-define(TEAM_FLAG_NPC, 2). %%NPC乱入

-define(TEAM_FLAG_SNATCH, 0). %%允许抢夺
-define(TEAM_FLAG_NO_SNATCH, 1). %%不允许抢夺

-record(dungeon_rewards,{
                         dungeon_id       = 0,    %%副本id
                         rewards          = [],   %%副本普通奖励
                         extra_rewards    = [],   %%
                         monsters_rewards = [],   %%怪物掉落
                         special_reward   = [],   %%
                         free_card_reward = [],   %%免费翻牌奖励
                         free_card_times  = 0,    %%免费翻牌次数
                         pay_card_reward  = [],   %%付费翻牌奖励
                         pay_card_times   = 0,    %%付费翻牌次数
                         pay_card_consume = 0     %%付费翻牌消耗
                        }).

-define(FLAG_TAKE_REWARD, 1).

-record(dungeon_info, {
          dungeon_id = 0,
          normal_rewards = [],
          monsters_rewards = [],
          extra_rewards = [],
          free_card_times = 0,
          pay_card_times = 0,
          relive_times = 0,
          team_id = 0,
          team_type = 0,
          sub_dungeon_id = 0,
          hit_reward = [],
          hit_reward_detail = [],
          grade = 0,  %%评级
          pass_time = 0,
          team_flag = ?TEAM_FLAG_NONE,
          flag = 0    %%防止多次领奖
          }).

-define(DUNGEON_MASTER, 1).     %% 主线副本
-define(DUNGEON_ACTIVITY, 2).   %% 活动副本
-define(DUNGEON_MEGUN, 3).    %% 极限副本
-define(DUNGEON_SUPER_BATTLE, 4).    %% 公平竞技
-define(DUNGEON_DAILY, 5).    %% 日常副本
-define(DUNGEON_SOURCE_GOLD, 7). %%资源钻石副本
-define(DUNGEON_SOURCE_COIN, 8). %%资源金钱副本
-define(DUNGEON_SOURCE_EXP,  9). %%资源经验副本
-define(DUNGEON_CROSS_PVP_BOSS, 11).  %% PVP

-define(DUNGEON_PASS,                 1).
-define(DUNGEON_NOT_PASS,             0).

-define(TYPE_FLIP_CARD_FREE,          1).
-define(TYPE_FLIP_CARD_PAY,           2).

-define(DUNGEON_NOT_ACHIEVE, 0).   %%没通关过
-define(DUNGEON_ACHIEVE,     1).   %%已经通过关

-define(TEAM_TYPE_MASTER,    1).   %%黄雀在后
-define(TEAM_TYPE_TEAM,    2).   %%组队副本

-define(BOSS_FLAG_FAIL, 2).
-define(BOSS_FLAG_WIN, 1).
-define(BOSS_FLAG_NONE, 0).

-define(DOUBLE_DROP_MONS_TYPE, 5).

-define(DEFINE_GRADE_S, 4). %%S级评分

%% %%针对一系列副本
%% -record(dungeon_data, {
%%           id = 0,
%%           version = dungeon_data_version:current_version(),
%%           dungeon_id = 0,
%%           player_id = 0,
%%           type = 0,              %%副本类型
%%           series_id = 0,         %%系列id
%%           score = 0,             %%总分数
%%           pass_time = 0,         %%通关总时间
%%           last_dungeon = 0,      %%系列副本的最新本
%%           count = 0,             %%该系列跑了几个本
%%           dirty = 0
%%          }).

-define(DEFAULT_KING_DUNGEON_TIMES, 3). %%默认王者副本的挑战次数是3
-define(KING_DUNGEON_TYPE, 3). %%王者副本默认是3等级

-record(mdb_dungeon_info, {
          base_id = 0,
          version = mdb_dungeon_info_version:current_version(),
          condition = [],
          dungeon_level = 0,
          left_times = 0,
          buy_times = 0}).

%%副本进度表
-record(dungeon_schedule, {
          id = 0,          %%自增
          version = dungeon_schedule_version:current_version(),
          player_id = 0,
          dungeon_id = 0,      %%base_dungeon_area的dungeon_id 表示一系列副本(包括几个难度的)
          last_dungeon = 0,
          state = ?DUNGEON_NOT_ACHIEVE,
          %condition = [],  %%副本的目标奖励，[{dungeon_id, [condition1, 2, 3]}].
          mdb_dungeon_info = [],  %%支持嵌套升级 [#mdb_dungeon_info...]
          dirty = 0
          }).


-define(PLAYER_ALIVE, 1).
-define(PLAYER_DEAD, 0).

-define(RANK_SIZE, 500).

-define(HAS_EXTRA_REWARD, 1).
-define(NO_EXTRA_REWARD, 0).

-define(MAX_RANGE, 1000).

-define(SOURCE_DUNGEON_TIMES, 2).

-define(SKIP_MUGEN_1, 1).
-define(SKIP_MUGEN_2, 2).
-define(SKIP_MIN_SIZE, 1).
-define(SKIP_MAX_SIZE, 6).
-define(SKIP_MUGEN2_SIZE, 9).
-define(MAX_PASS_SKIP_MUGEN, 90).
-define(MAX_MUGEN_CHALLENGE_COUNT, 1). %%同时挑战好友的数量
-define(MAX_LUCKY_COINS, 10).
-define(LUCKY_COIN_NEW,  0).
-define(LUCKY_COIN_RECV, 1).

-define(SKIP_MUGEN_OFF, 0).  %%不能使用跳关
-define(SKIP_MUGEN_ON, 1).  %%能使用跳关

-define(EACH_BUY_SUPER_BATTLE_TIMES, 1). %%每次购买增加的次数

%%极限副本
-record(dungeon_mugen, {
          player_id,
          version = dungeon_mugen_version:current_version(),
          last_dungeon = 0,      %%能打的id
          next_dungeon = 0,      %%下一关的id, 是0的话表示全通了
          score = 0,             %%总分
          pass_time = 0,         %%总时间
          state = ?PLAYER_ALIVE, %% 1、正常，0、死亡。
          rest = 0,              %%剩余挑战次数
          have_pass_times = 0,   %%已通关多少
          old_key,               %%用来记录排行榜上的key       
          max_pass_rec = 0,
          challenge_list = [],   %%挑战的好友{id, 层数}
          challenge_times = 1,
          send_lucky_coin = 0,  %%已经投放幸运币的次数
          use_lucky_coin = 0,    %%使用的幸运币次数
          skip_flag = ?SKIP_MUGEN_ON,
          dirty = 0
         }).

%%超激斗
-record(super_battle, {
          player_id = 0,
          version = super_battle_version:current_version(),
          last_dungeon = 0,
          next_dungeon = 0,
          score = 0,
          pass_time = 0,
          rest = 0,
          state = ?PLAYER_ALIVE,
          have_pass_times = 0,
          cur_hp = 100,
          buy_times = 0,
          dirty = 0,
          ability = 0    %% 玩家战力
          }).

%%通天塔要做一个奖励表，记录每一层领奖的状况
-record(mugen_reward, {
          id,
          version = mugen_reward_version:current_version(),
          player_id = 0,
          level = 0,
          reward1 = 0,   %%10s通关
          reward2 = 0,   %%连击不断
          reward3 = 0,   %%反击
          reward4 = 0,    %%无伤
          dirty = 0
         }).
%%爬塔的幸运币
-record(lucky_coin, {
          key,
          version = lucky_coin_version:current_version(),
          send,
          recv,
          state = ?LUCKY_COIN_NEW
         }).
%%用于对通关领奖的结构
-record(pass_dungeon_info, {
          id,
          route = [],
          score = 0,
          reward = [],
          state = ?PLAYER_ALIVE,
          is_extra = 0,
          cost_time = 0,
          condition = [],
          boss_flag = 0,
          target_list = [],
          cur_hp = 0,
          hit_reward = []}).   %%公平竞技的当前血量百分比

-record(source_dungeon, {
          player_id = 0,
          version = source_dungeon_version:current_version(),
          info = [],    %%用来记录今天打过的资源本{类型,剩余次数}
          dirty = 0}).

-record(dungeon_mop_up, {
          normal_reward = [],
          boss_reward = [],
          free_card_reward = [],
          pay_card_reward = []}).
      

-define(KING_RULE_DROPED,         1).  %% 王者FB潜规则，已掉落BOSS奖励

-endif.

