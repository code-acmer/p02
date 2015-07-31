-module(lib_log_player).

-export([put_log/1, flush/1, log/1]).
-export([
         log_player_create/1,
         log_player_online/6,
         %% log_player_login/8,
         log_player_login/1,
         log_system/1
        ]).
-export([add_log/3]).
-include("db_log_player.hrl").
-include("db_log_player_create.hrl").
-include("db_log_player_login.hrl").
-include("db_log_player_online.hrl").
-include("db_log_system.hrl").
-include("define_player.hrl").

-define(UPDATE(Key, Default, Var, Expr),
        begin
            %% We deliberately allow Var to escape from the case here
            %% to be used in Expr. Any temporary var we introduced
            %% would also escape, and might conflict.
            case get(Key) of
                undefined -> Var = Default;
                Var       -> ok
            end,
            put(Key, Expr)
        end).

put_log(Log) 
  when is_record(Log, log_player) ->
    ?UPDATE(log_player_list, [], Logs, [Log | Logs]);
put_log(LogList) 
  when is_list(LogList) ->
    ?UPDATE(log_player_list, [], Logs, LogList ++ Logs).

flush(PlayerId) ->
    case erase(log_player_list) of
        undefined ->
            undefined;
        Logs ->
            log([Log#log_player{
                   player_id = PlayerId
                  } || Log <- Logs])
    end.

log(Logs) ->
    mod_base_log:log(log_player_p, Logs).
    
add_log(EventId, Args1, Args2) ->
    put_log(#log_player{
               event_id = EventId,
               arg1 = Args1,
               arg2 = Args2
              }).

log_player_online(Sn, PlayerId, AccId, Lv, LoginTimestamp, LogoutTimestamp) ->
    Log = #log_player_online{sn                  = Sn,
                             player_id           = PlayerId,
                             accid               = AccId,
                             lv                  = Lv,
                             login_timestamp     = LoginTimestamp,
                             logout_timestamp    = LogoutTimestamp,
                             time                = max(0, LogoutTimestamp - LoginTimestamp)
                            },
    mod_base_log:log(log_player_online, [Log]).

log_player_create(Player) ->
    Log = #log_player_create{sn                  = Player#player.sn,
                             player_id           = Player#player.id,
                             accid               = Player#player.accid,
                             device_id           = Player#player.device_id,
                             create_timestamp    = Player#player.create_timestamp
                            },
    mod_base_log:log(log_player_create, [Log]).

log_player_login(Player) ->
    Log = #log_player_login{player_id           = Player#player.id,
                            sn                  = Player#player.sn,
                            career              = Player#player.career,
                            accid               = Player#player.accid,
                            device_id           = "",
                            lv                  = Player#player.lv,
                            pay_flag            = Player#player.first_recharge_flag,
                            login_timestamp     = time_misc:unixtime(),
                            regist_timestamp    = Player#player.create_timestamp
                           },
    mod_base_log:log(log_player_login, [Log]).


log_system({PlayerId, Type, Value, Ext1, Ext2}) ->
    Log = #log_system{player_id = PlayerId,
                      type      = Type,
                      value     = Value,
                      ext_1     = Ext1,
                      ext_2     = Ext2
                     },
    mod_base_log:log(log_system, [Log]);
log_system(Other) ->
    io:format("Other : ~p~n", [Other]),
    ignored.

