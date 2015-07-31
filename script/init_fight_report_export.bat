set SRC_DB_HOST=192.168.1.149
set SRC_DB_PORT=3306
set SRC_DB_USER=shsg
set SRC_DB_PSWD=shsg
set SRC_DB_GAME=shsg_game
set SRC_DB_LOG=shsg_log
set SRC_DB_ADMIN=shsg_admin
set SRC_DB_CENTER=shsg_center

set DES_DB_HOST=localhost
set DES_DB_PORT=3306
set DES_DB_USER=shsg
set DES_DB_PSWD=shsg
set DES_DB=shsg_game_internet


set WHERE="uuid in('82080a03-dd5e-46ac-b075-cc9c475dc3a1','4e738bfb-3d92-4cdb-bec5-7f841590ffeb','99a95aa5-61c5-4b05-8212-8e37f772ddef','82a3afae-229a-4716-8452-7fb0a85a050f','8de526a0-0c1b-4219-ae51-f563c2893055','cd0283e8-77f2-4478-9d5a-7c89ed311278')"

mysqldump -h %SRC_DB_HOST% -u%SRC_DB_USER% -p%SRC_DB_PSWD% --no-create-info %SRC_DB_GAME% fight_report --where=%WHERE% > ../db/init_fight_report.sql


pause