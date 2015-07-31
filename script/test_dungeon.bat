set EBIN=
cd ..
for /F %%i in ('dir deps /B /D') do (call set "EBIN=%%EBIN%% ./deps/%%i/ebin/")
rem for /F %%i in ('dir apps /B /D') do (call set "EBIN=%%EBIN%% ./apps/%%i/ebin/")
set EBIN=%EBIN% ./ebin

erl -pa %EBIN%  -name test@127.0.0.1 -config ./rel/files/sys.config -s test_dungeon start > test.txt

pause
@rem # 'lib_dungeon:start_run_all_dungeon(100)' 这个是跑所有副本100次
@rem # 'lib_dungeon:start_run_one_dungeon(31000201,100)' 这个是跑31000201副本100次
