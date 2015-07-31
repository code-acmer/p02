set NODE=1
set SERVER_NO=robot_1
set COOKIE=xxm_s%SERVER_NO%
set NODE_NAME=%COOKIE%_game%NODE%@192.168.1.99
set CONFIG_FILE=run_%NODE%

set SMP=auto
set ERL_PROCESSES=102400
cd ..
set EBIN=
for /F %%i in ('dir deps /B /D') do (call set "EBIN=%%EBIN%% ./deps/%%i/ebin/")
for /F %%i in ('dir apps /B /D') do (call set "EBIN=%%EBIN%% ./apps/%%i/ebin/")

erl +P %ERL_PROCESSES% +t 2048576 -smp %SMP% -pa %EBIN% -name %NODE_NAME% -setcookie %COOKIE% -boot start_sasl -config -config ./rel/files/sys.config  -s new_robot start

pause
