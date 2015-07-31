set NODE=24
set SERVER_NO=2
set COOKIE=p02_s%SERVER_NO%
set NODE_NAME=%COOKIE%_game%NODE%@192.168.1.24
set CONFIG_FILE=run_%NODE%

set SMP=auto
set ERL_PROCESSES=102400
cd ..
set EBIN=
for /F %%i in ('dir deps /B /D') do (call set "EBIN=%%EBIN%% ./deps/%%i/ebin/")
set EBIN=%EBIN% ./ebin

werl -pa  %EBIN% -s reloader