%%% @author Roowe <bestluoliwe@gmail.com>
%%% @copyright (C) 2013, Roowe
%%% @doc
%%% 
%%% @end
%%% Created : 12 Aug 2013 by Roowe <bestluoliwe@gmail.com>
-ifndef(DEFINE_ACTIVITY_RATE_HRL).
-define(DEFINE_ACTIVITY_RATE_HRL, true).
-define(ALL_SERVER, 0).

-include("db_base_activity_rate.hrl").

-define(ETS_BASE_ACTIVITY_RATE, rec_base_activity_rate).

%% 副本 1
%% 群雄争霸 2
%% 摇钱树 3
%% 挂机 4
%% 属臣交互 5
-define(ACTIVITY_RATE_TYPE_DUNGEON, 1).
-define(ACTIVITY_RATE_TYPE_WARCRAFT, 2).
-define(ACTIVITY_RATE_TYPE_MONEY_RUNE, 3).
-define(ACTIVITY_RATE_TYPE_SIT, 4).
-define(ACTIVITY_RATE_TYPE_MASTER_SLAVE, 5).
-define(ACTIVITY_RATE_TYPE_GUILD_SCORE_FIGHT, 6).
-define(ACTIVITY_RATE_TYPE_GUILD_EIGHT_FIGHT, 7).

-define(DEFAULT_RATE, 1000).

-define(ALL_GOOD_REWARD_TYPE, 0).


-endif.

