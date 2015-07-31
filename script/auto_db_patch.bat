set SRC_DB_HOST=localhost
set SRC_DB_PORT=3306
set SRC_DB_USER=shsg
set SRC_DB_PSWD=shsg
set SRC_DB=shsg_game

set DES_DB_HOST=localhost
set DES_DB_PORT=3306
set DES_DB_USER=shsg
set DES_DB_PSWD=shsg
set DES_DB=shsg_game_internet

mysqldiff --server1=%SRC_DB_USER%:%SRC_DB_PSWD%@%SRC_DB_HOST%:%SRC_DB_PORT%:socket --server2=%DES_DB_USER%:%DES_DB_PSWD%@%DES_DB_HOST%:%DES_DB_PORT%:socket %SRC_DB%:%DES_DB% --changes-for=server1 --difftype=sql --force > db_patch.sql

rem mysqldbcompare --server1=%SRC_DB_USER%:%SRC_DB_PSWD%@%SRC_DB_HOST%:%SRC_DB_PORT%:socket --server2=%DES_DB_USER%:%DES_DB_PSWD%@%DES_DB_HOST%:%DES_DB_PORT%:socket %SRC_DB%:%DES_DB% --changes-for=server1 --difftype=d --skip-object-compare > db_patch.sql
pause