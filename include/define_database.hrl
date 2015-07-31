-ifndef(DEFINE_DATABASE_HRL).
-define(DEFINE_DATABASE_HRL, true).

%%数据库分库列表
-define(DB_LIST,
		[
         db_admin,
         db_center,
         db_base,
         db_game,
         db_log
        ]).

-define(DB_ERROR, -1).

-endif.

