set ERL_MAX_PORTS=32000
set ERL_PROCESSES=250000
set ERL_MAX_ETS_TABLES=14000
set THREADS_ASYNC_THREAD=120
set ERL_MAX_ATOM=10485760
erl -smp auto +A 120 +K true -pa ./ -name test_mnesia_node_1@192.168.1.88 -setcookie test_mnesia_cookie -mnesia dump_log_write_threshold 50000 -mnesia dc_dump_limit 64


