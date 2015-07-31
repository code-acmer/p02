cd ..
copy /Y .\config\table_to_record.conf .\deps\leshu_db\priv\

set EBIN=
for /F %%i in ('dir deps /B /D') do (call set "EBIN=%%EBIN%% ./deps/%%i/ebin/")
for /F %%i in ('dir apps /B /D') do (call set "EBIN=%%EBIN%% ./apps/%%i/ebin/")

erl -pa %EBIN% -name tools@127.0.0.1 -s table_to_record start

pause
