
-ifndef(DEFINE_LOG_HRL).
-define(DEFINE_LOG_HRL, true).

-include("define_time.hrl").

-record(log_state, {
          db_conf,
          log_list = [],
          len = 0,
          timestamp_pos,
          last_check,
          is_rotate = false,                     %% 按照1.5kw条的溢出标准，每一个小时检测一次
          base_table_name,                       %% 不需要配置，从db_conf取，运行时是字符串
          table_index = 1,                       %% 当天表的段，比如log_player_20140703_1
          insert_fun = fun db_mysql_base:r_list_insert_withnot_id/2
         }).

-define(TABLE_OVERFLOW_COUNT, 15000000).
-define(ROTATE_CHECK_INTERVAL, ?ONE_HOUR_SECONDS).

%-define(TABLE_OVERFLOW_COUNT, 100000).
%-define(ROTATE_CHECK_INTERVAL, 1).
-include("define_log_event.hrl").
-include("db_log_player.hrl").
-include("define_log_type.hrl").
-endif.
