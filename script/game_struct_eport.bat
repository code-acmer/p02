set SRC_DB_HOST=192.168.1.149
set SRC_DB_PORT=3306
set SRC_DB_USER=shsg
set SRC_DB_PSWD=shsg
set SRC_DB=shsg_game
set SRC_DB_LOG=shsg_log
set SRC_DB_ADMIN=shsg_admin
set SRC_DB_CENTER=shsg_center

set DES_DB_HOST=localhost
set DES_DB_PORT=3306
set DES_DB_USER=shsg
set DES_DB_PSWD=shsg
set DES_DB=shsg_game_internet

mkdir ..\db\shsg_db_struct

mysqldump -h %SRC_DB_HOST% -u%SRC_DB_USER% -p%SRC_DB_PSWD%  -d %SRC_DB% > ../db/shsg_db_struct/%SRC_DB%_struct.sql
mysqldump -h %SRC_DB_HOST% -u%SRC_DB_USER% -p%SRC_DB_PSWD%  -d %SRC_DB_LOG% > ../db/shsg_db_struct/%SRC_DB_LOG%_struct.sql
mysqldump -h %SRC_DB_HOST% -u%SRC_DB_USER% -p%SRC_DB_PSWD%  -d %SRC_DB_ADMIN% > ../db/shsg_db_struct/%SRC_DB_ADMIN%_struct.sql
mysqldump -h %SRC_DB_HOST% -u%SRC_DB_USER% -p%SRC_DB_PSWD%  -d %SRC_DB_CENTER% > ../db/shsg_db_struct/%SRC_DB_CENTER%_struct.sql

pause