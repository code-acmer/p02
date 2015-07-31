-ifndef(DEFINE_RECOMMEND_HRL).
-define(DEFINE_RECOMMEND_HRL, true).

-include("db_base_ability.hrl").

-define(DEFAULT_RANGE, 10).       %%默认战斗力浮动百分比
-define(DEFAULT_REC_NUM, 5).  %%默认推荐数量

-define(GET_LEVEL_NUM, 5).  %%一个坑每次取N个
-define(MAX_LEVEL_NUM, 2000).  %%一个坑对应的最大数量

-define(DEFAULT_REC_TIMES, 5).  %%默认递归取的坑数

-endif.
