-ifndef(DEFINE_FRIEND_HRL).
-define(DEFINE_FRIEND_HRL,true).



%%好友系统相关宏


-define(MAX_FRIENDS, 100).  %% 好友上限
-define(MAX_CONTACTS, 10). %% 最近联系人
-define(MAX_BLACKS,30).    %% 黑名单
-define(FRIEND_MAX_BLESS, 20).%%每天祝福别人的最大次数
-define(FRIEND_MAX_BLESSED, 20).%%每天被祝福的最大次数

-define(FRIEND_RECOMMEND_LIST_MAX, 5).%%好友推荐列表最大数量
-define(FRIEND_RECOMMEND_LIST_MIN_LV, 12).%%符合推荐好友的最低等级


-endif.
