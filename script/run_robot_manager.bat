set NODE=24
set SERVER_NO=1
set COOKIE=p02_robot_s%SERVER_NO%
set NODE_NAME=%COOKIE%_game%NODE%@192.168.1.24
set CONFIG_FILE=run_%NODE%

set SMP=auto
set ERL_PROCESSES=102400
cd ..
set EBIN=
for /F %%i in ('dir deps /B /D') do (call set "EBIN=%%EBIN%% ./deps/%%i/ebin/")
rem for /F %%i in ('dir apps /B /D') do (call set "EBIN=%%EBIN%% ./apps/%%i/ebin/")
set EBIN=%EBIN% ./ebin

rem for /r  %%i in (1.txt) do set tmpstr=!tmpstr! %%i 
rem set EBIN=./apps/common02/ebin/ ./apps/mod_arena/ebin/ ./apps/mod_combat/ebin/ ./apps/mod_guild/ebin/ ./apps/mod_log/ebin/ ./apps/mod_mail/ebin/ ./apps/mod_operations/ebin/ ./apps/mod_player/ebin/ ./apps/mod_system/ebin/ ./apps/mod_team/ebin/ ./apps/mod_world_boss/ebin/ ./apps/robot/ebin/ ./apps/server/ebin ./deps/hstdlib/ebin/ ./deps/ibrowse/ebin/ ./deps/leshu_db/ebin/ ./deps/meck/ebin/ ./deps/mysql/ebin/ ./deps/protobuffs/ebin/
rem werl +P %ERL_PROCESSES% +t 2048576 -smp %SMP% -pa ../ebin -name %NODE_NAME% -setcookie %COOKIE% -boot start_sasl -config %CONFIG_FILE% -s main server_start
erl +P %ERL_PROCESSES% +t 2048576 -smp %SMP% -pa %EBIN% -name %NODE_NAME% -setcookie %COOKIE% -boot start_sasl -config ./rel/files/sys.config -s reloader -s robot_manager start_link