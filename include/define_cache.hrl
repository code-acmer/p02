
-ifndef(DEFINE_CACHE_HRL).
-define(DEFINE_CACHE_HRL, true).

-define(RECORD_STATE_NORMAL,  0).
-define(RECORD_STATE_DIRTY,   1).
-define(RECORD_STATE_NEW,     2).
-define(RECORD_STATE_DELETED, 4).

%%for cache_misc----------%%
-define(CACHE_DATA_TABLE, cache_data_table).

-define(OTHER_PLAYER_FASHION, other_player_fashion).
-define(OTHER_PLAYER_EQUIP, other_player_equip).
-define(OTHER_PLAYER_INFO, other_player_info).
-define(OTHER_PLAYER_MUGEN, other_player_mugen).
-define(OTHER_PLAYER_SKILL, other_player_skill).
%%-------------------------%%

-endif.

