%%% @author Roowe <bestluoliwe@gmail.com>
%%% @copyright (C) 2013, Roowe
%%% @doc
%%% 成就头文件
%%% @end
%%% Created : 27 Jun 2013 by Roowe <bestluoliwe@gmail.com>
-ifndef(DEFINE_ACHIEVE_HRL).
-define(DEFINE_ACHIEVE_HRL, true).

-include("db_base_achieve.hrl").
-include("db_base_achieve_gift.hrl").
-include("db_player_achieve.hrl").
-include("db_player_achieve_times.hrl").

-define(ETS_BASE_ACHIEVE, ets_base_achieve).
-define(ETS_PLAYER_ACHIEVE, ets_player_achieve).

-define(ACHIEVE_TYPE_SINGLE_DUNGEON, 1).
-define(ACHIEVE_TYPE_SINGLE_ELITE_DUNGEON, 2).
-define(ACHIEVE_TYPE_ARENA, 3).

-define(RECEIVE_ACHIEVE_GOODS, 1).
-define(NOT_RECEIVE_ACHIEVE_GOODS, 0).

-define(ACHIEVE_FINISH, 1).
-define(ACHIEVE_NOT_FINISH, 0).

-endif.



