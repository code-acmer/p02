-ifndef(DEFINE_TEAM_HRL).
-define(DEFINE_TEAM_HRL,true).

-define(MEMBER_STATE_NOT_READY, 0).
-define(MEMBER_STATE_READY, 1).
-define(MEMBER_STATE_INVITE, 2).  %%受邀请状态

-define(TEAM_DUNGEON_OFF,0).
-define(TEAM_DUNGEON_ON,1).

-define(CHALLENGE_TYPE_OFF, 0). %%不约战
-define(CHALLENGE_TYPE_ON, 1). %%约战

-record(team, {leaderid = 0,
               nickname = undefined,
               members = [],
               dungeon_id = 0,
               state = ?TEAM_DUNGEON_OFF,
               number = 0,
               challenge_type = ?CHALLENGE_TYPE_OFF}).

-record(member, {player_id = 0,
                 nickname,
                 lv = 0,
                 career,
                 battle_ability = 0,
                 state = ?MEMBER_STATE_NOT_READY
                }).

-define(TEAM_STATE_NOT_IN_TEAM, 0).
-define(TEAM_STATE_INVITE,  1).
-define(TEAM_STATE_IN_TEAM, 2).

-endif.
