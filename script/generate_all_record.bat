cd ..
set EBIN=
for /F %%i in ('dir deps /B /D') do (call set "EBIN=%%EBIN%% ./deps/%%i/ebin/")
for /F %%i in ('dir apps /B /D') do (call set "EBIN=%%EBIN%% ./apps/%%i/ebin/")

erl -pa %EBIN% ./ebin/ D:\erl6.1\lib\distel-master\ebin\ -name generate_all_record@127.0.0.1 -boot start_clean -s generate_all_record  start -s init stop

pause
cd script
