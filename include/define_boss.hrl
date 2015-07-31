-ifndef(DEFINE_BOSS_HRL).
-define(DEFINE_BOSS_HRL, true).
-include("db_base_dungeon_world_boss.hrl").

-define(BOSS_STATE_ALIVE,               0).    %% BOSS 活着
-define(BOSS_STATE_DEAD,                1).    %% BOSS 已经死亡

-define(BOSS_TYPE_PLAYER, 1).
-define(BOSS_TYPE_SYSTEM, 2).

-define(WAIT_BOSS_TIME, 0).  %%等待进入boss场景的时间(秒)

%% 最大排行榜人数
-define(MAX_RANK_SIZE,         10).
-define(MAX_ALLOW_COUNT,       100).

-record(bossinfo, {player_id = 0,     %%开启者
                   nickname = "",
                   boss_id = 0,
                   start = 0,
                   stop = 0,
                   pid                %%mod_boss
                  }).

-record(player_info, {player_id = 0,
                      damage = 0,
                      nickname = "",
                      career = 0
                     }).
-record(open_boss_rank, {key,          %%key应该是 {-open_times, player_id}
                         version = 0,  %%暂时还没建表
                         nickname
                         }).
-endif.
