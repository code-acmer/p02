rem cp ../config/info_header.conf ../deps/leshu_db/priv/
cd ..
copy /Y .\config\info_header.conf .\deps\leshu_db\priv\

set EBIN=
for /F %%i in ('dir deps /B /D') do (call set "EBIN=%%EBIN%% ./deps/%%i/ebin/")
rem for /F %%i in ('dir apps /B /D') do (call set "EBIN=%%EBIN%% ./apps/%%i/ebin/")
set EBIN=%EBIN% ./ebin

echo to generating ../include/define_info_x.hrl

erl -pa %EBIN% +P 1024000 -smp disable -name tools@127.0.0.1 -s generate_info_header_file start

pause
