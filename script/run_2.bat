set NODE=2
set SERVER_NO=1
set COOKIE=xxm_s%SERVER_NO%
set NODE_NAME=%COOKIE%_game%NODE%@127.0.0.1
set CONFIG_FILE=run_%NODE%

set SMP=auto
set ERL_PROCESSES=102400

cd ../config
werl +P %ERL_PROCESSES% +t 2048576 -smp %SMP% -pa ../ebin -name %NODE_NAME% -setcookie %COOKIE% -boot start_sasl -config %CONFIG_FILE% -s main server_start
