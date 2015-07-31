-ifndef(DEFINE_DAILY_DUNGEON_REC_HRL).
-define(DEFINE_DAILY_DUNGEON_REC_HRL,true).

%%日常副本
-record(daily_dungeon, {
          player_id = 0,
          version = daily_dungeon_version:current_version(),
          dungeon_id = 0,
          %%=====通关条件====
          time = 0,
          damage = 0,
          hurt = 0,
          combo = 0,
          aircombo = 0,
          skillcancel = 0,
          crit = 0,
          %%================
          left_times = 0,  %%剩余挑战次数
          dirty = 0
         }).


-endif.
