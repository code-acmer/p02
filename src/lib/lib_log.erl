-module(lib_log).

-include("define_mysql.hrl").
-include("define_log.hrl").
-include("db_log_player.hrl").
-include("db_log_player_mini.hrl").
-include("db_log_player_feedback.hrl").
-include("define_pay_info.hrl").
-include("db_log_player_online.hrl").
-include("db_log_player_login.hrl").
-include("db_log_player_create.hrl").
-include("db_log_system.hrl").

-export([
         log_player_args/0, 
         log_player_mini_args/0, 
         log_player_feedback_args/0, 
         log_pay_info_args/0,
         log_player_login_args/0,
         log_player_create_args/0,
         log_player_online_args/0,
         log_system_args/0
        ]).

log_player_args() ->
    [log_player_p, #log_state{
                      db_conf = #record_mysql_info{
                                   db_pool = db_log,
                                   table_name = log_player,
                                   record_name = log_player,
                                   fields = record_info(fields, log_player)
                                  },
                      timestamp_pos = #log_player.timestamp,
                      is_rotate = true
                     }].
log_player_mini_args() ->
    [log_player_mini_p, #log_state{
                           db_conf = #record_mysql_info{
                                        db_pool = db_log,
                                        table_name = log_player_mini,
                                        record_name = log_player_mini,
                                        fields = record_info(fields, log_player_mini)
                                       },
                           is_rotate = false,
                           insert_fun = fun db_mysql_base:r_list_replace/2
                          }].

log_player_feedback_args() ->
    [log_player_feedback_p, #log_state{
                               db_conf = #record_mysql_info{
                                            db_pool = db_log,
                                            table_name = log_player_feedback,
                                            record_name = log_player_feedback,
                                            fields = record_info(fields, log_player_feedback)
                                           },
                               timestamp_pos = #log_player_feedback.timestamp,
                               is_rotate = false,
                               insert_fun = fun db_mysql_base:r_list_insert_withnot_id/2
                              }].

log_pay_info_args() ->
    [pay_info, #log_state{
                  db_conf = #record_mysql_info{
                               db_pool     = db_log,
                               table_name  = pay_info,
                               record_name = pay_info,
                               fields = record_info(fields, pay_info)
                              },
                  timestamp_pos = #pay_info.time,
                  is_rotate = false,
                  insert_fun = fun db_mysql_base:r_list_insert_with_id/2
                 }].

log_player_online_args() ->
    [log_player_online, #log_state{
                           db_conf = #record_mysql_info{
                                        db_pool     = db_log,
                                        table_name  = log_player_online,
                                        record_name = log_player_online,
                                        fields = record_info(fields, log_player_online)
                                     },
                           %% timestamp_pos = #pay_info.time,
                           is_rotate = false,
                           insert_fun = fun db_mysql_base:r_list_insert_withnot_id/2
                        }].

log_player_login_args() ->
    [log_player_login, #log_state{
                          db_conf = #record_mysql_info{
                                       db_pool     = db_log,
                                       table_name  = log_player_login,
                                       record_name = log_player_login,
                                       fields = record_info(fields, log_player_login)
                                     },
                           %% timestamp_pos = #pay_info.time,
                           is_rotate = false,
                           insert_fun = fun db_mysql_base:r_list_insert_withnot_id/2
                        }].

log_player_create_args() ->
    [log_player_create, #log_state{
                           db_conf = #record_mysql_info{
                                        db_pool     = db_log,
                                        table_name  = log_player_create,
                                        record_name = log_player_create,
                                        fields = record_info(fields, log_player_create)
                                       },
                           %% timestamp_pos = #pay_info.time,
                           is_rotate = false,
                           insert_fun = fun db_mysql_base:r_list_insert_withnot_id/2
                        }].


log_system_args() ->
    [log_system,  #log_state{
                     db_conf = #record_mysql_info{
                                  db_pool = db_log,
                                  table_name = log_system,
                                  record_name = log_system,
                                  fields = record_info(fields, log_system)
                                 },
                     timestamp_pos = #log_system.timestamp,
                     is_rotate = true,
                     insert_fun = fun db_mysql_base:r_list_insert_withnot_id/2
                    }].
