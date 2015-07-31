#!/bin/bash
DB_HOST=$1
DB_USER=$2
DB_PASSWORD=$3

SOURCE_DB=$4
TARGET_DB=$5

SOURCE_DB_FILE=$6
TARGET_DB_FILE=$7

DB_NAME=$8

recreate() {
    mysql -h$DB_HOST -u$DB_USER -p$DB_PASSWORD -B -s -N -e "DROP DATABASE IF EXISTS\`$1\`; CREATE DATABASE IF NOT EXISTS\`$1\` CHARACTER SET utf8 COLLATE utf8_general_ci;"
}

recreate $SOURCE_DB
recreate $TARGET_DB

import_run() {
    mysql -h$DB_HOST -u$DB_USER -p$DB_PASSWORD $1 < $2
}
import_run $SOURCE_DB $SOURCE_DB_FILE
import_run $TARGET_DB $TARGET_DB_FILE

OUTPUT_DIR=/tmp/mysql_compare
mkdir -p $OUTPUT_DIR
cd $OUTPUT_DIR
[ -f "$DB_NAME.*.sql" ] && rm $OUTPUT_DIR/$TARGET_DB"*.sql"

echo "comparing struct may spend serveral minutes, please wait..."
schemasync --output-directory=$OUTPUT_DIR mysql://$DB_USER:$DB_PASSWORD@$DB_HOST:3306/$SOURCE_DB mysql://$DB_USER:$DB_PASSWORD@$DB_HOST:3306/$TARGET_DB
# ##处理新的sql
if [ -f $TARGET_DB.*.patch.sql ]; 
then
    mv $TARGET_DB.*.patch.sql $DB_NAME.patch.sql
    sed '/USE/d' -i $DB_NAME.patch.sql
fi;
if [ -f $TARGET_DB.*.revert.sql ]; 
then
    mv $TARGET_DB.*.revert.sql $DB_NAME.revert.sql
    sed '/USE/d' -i $DB_NAME.revert.sql
fi;

