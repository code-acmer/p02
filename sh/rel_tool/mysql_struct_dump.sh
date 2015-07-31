#!/bin/bash
#把远端的表结构导出来

SSHHost=$1
DB_HOST=$2
DB_USER=$3
DB_PASSWORD=$4
DB_NAME=$5
DumpFile=$SSHHost'_'$DB_NAME.sql
FullDumpFile=/tmp/$DumpFile
LOGIN_STR="-h$DB_HOST -u$DB_USER -p$DB_PASSWORD"
FindTableStr="\$(mysql $LOGIN_STR -D $DB_NAME -Bse \"SHOW TABLES WHERE Tables_in_$DB_NAME NOT LIKE 'log_player_%'\")"
ssh $SSHHost "mysql $LOGIN_STR -e 'CREATE DATABASE IF NOT EXISTS \`$DB_NAME\` CHARACTER SET utf8 COLLATE utf8_general_ci;' && mysqldump -d $LOGIN_STR $DB_NAME $FindTableStr > $FullDumpFile"
scp $SSHHost:$FullDumpFile /tmp/
echo -n $FullDumpFile



