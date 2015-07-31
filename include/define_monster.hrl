-ifndef(DEFINE_MONSTER_HRL).
-define(DEFINE_MONSTER_HRL, true).

-include("db_base_mon.hrl").

-define(ETS_BASE_MON, ets_base_mon).
-record(data_mon, 
	{
	 id = 0,
	 mon_drop = []
	}).

-endif.

