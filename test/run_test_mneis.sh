#!/bin/sh
ERL_MAX_PORTS=32000
ERL_PROCESSES=250000
ERL_MAX_ETS_TABLES=14000
THREADS_ASYNC_THREAD=120
ERL_MAX_ATOM=10485760
DATETIME=`date "+%Y%m%d-%H:%M:%S"`
export ERL_MAX_PORTS=32000
export ERL_MAX_ETS_TABLES=14000
erl -smp auto +P 102400 +A 120 +K true -pa ./ -name test_mnesia_node_172@192.168.1.172 -set_cookie test_mnesia_cookie -mnesia dump_log_write_threshold 50000 -mnesia dc_dump_limit 64


