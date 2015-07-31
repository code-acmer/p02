-ifndef(DEFINE_CAMP_HRL).
-define(DEFINE_CAMP_HRL, true).


-record(camp, {id       = 0, %% 
               pos_list = [], %% 位置信息 [{Pos, GoodsUid},....] 6个位置，6为好友核心
               ext1     = 0,
               ext2     = 0,
               ext3     = 0
              }).


-record(player_camp, {player_id = 0, %%
                      version = player_camp_version:current_version(),
                      using_camp = 0,
                      camp_list = [], %% [#camp{},....]
                      ext1      = 0,
                      ext2      = 0,
                      ext3      = 0
                     }).

-define(MAX_CAMP_CNT,     6).

-define(CLOSE_POS,        0).

-endif.
