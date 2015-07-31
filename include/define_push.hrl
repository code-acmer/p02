
%% @doc 安卓推送宏定义
%% @spec
%% @end

-ifndef(DEFINE_PUSH_HRL).
-define(DEFINE_PUSH_HRL, true).

-define(ETS_PUSH_SCHEDULE, ets_push_schedule).

-define(PUSH_SERVER_KEY,     "cfd5d9c9e973d244aecc4e79").
-define(MASTER_SECRET_KEY,   "10623093aef09f5a260c6555").

-define(PUSH_TYPE_SINGLE,    3).
-define(PUSH_TYPE_ALL,       4).

%% 5000段，群发消息
-define(PUSH_NO_FEAST,       5000).

%% 10000以上段，单人消息
%% 副本扫荡结束
-define(PUSH_NO_PRACTICE,    15000).
%% 群雄争霸
-define(PUSH_NO_WARCRAFT,    48000).
%% 世界boss
-define(PUSH_NO_BOSS_APPEAR, 52000).
%% 伙伴
-define(PUSH_NO_PARTNER,     45000).

%% 延迟推送的消息类型
-define(PUSH_DELAY_MSGS,
        [push_msg_warcraft_time_out,
         push_msg_practice_time_out,
         push_msg_partner_training_ready]).

-record(ets_push_schedule, 
        {id = 0,
         player_id = 0,
         type = 0,
         timestamp = 0}).

-define(DEBUG_PUSH(Format, Args),
        io:format("~w:~w:~w push message>>>" ++ Format,
                  [?MODULE, ?LINE, self()] ++ Args ++ "~n")).

-endif.

