#bin/sh
remote_dir=/data/kof/ebin_p02/
DATETIME=`date "+%Y%m%d"`

#把远端的表结构导出来
export_db()
{
    ssh $1 "mysql -h$2 -u$3 -p$4 -e 'CREATE DATABASE IF NOT EXISTS\`$TABLE\` CHARACTER SET utf8 COLLATE utf8_general_ci;' && mysqldump -d -h$2 -u$3 -p$4 $Table>/tmp/$TABLE.sql"
    scp $1:/tmp/$TABLE.sql /tmp/
}
##把远端的表结构导进去bakup_db 之后和source_db对比
import()
{
    mysql -h$source_db_host -u$source_db_user -p$source_db_password -e "DROP DATABASE IF EXISTS\`$backup_db\`; CREATE DATABASE IF NOT EXISTS\`$backup_db\` CHARACTER SET utf8 COLLATE utf8_general_ci;"
    mysql -h$source_db_host -u$source_db_user -p$source_db_password $backup_db < $sql_dir/p02_log.sql
    cd $ebin_p02_dir
    mkdir -p log
    ##删掉老的sql
    if [ -f $backup_db.patch.sql ]; 
    then
        mv $backup_db.patch.sql ./log/$backup_db.patch.sql
    fi;
    if [ -f $backup_db.revert.sql ]; 
    then
        mv $backup_db.revert.sql ./log/$backup_db.revert.sql
    fi;
    echo "comparing struct, please wait..."
    schemasync --output-directory=$ebin_p02_dir mysql://$source_db_user:$source_db_password@$source_db_host:3306/$source_db mysql://$source_db_user:$source_db_password@$source_db_host:3306/$backup_db
    ##处理新的sql
    if [ -f $backup_db.*.patch.sql ]; 
    then
        mv $backup_db.*.patch.sql $backup_db.patch.sql
        sed '/USE `p02_log_out`;/d' -i p02_log_out*
    fi;
    if [ -f $backup_db.*.revert.sql ]; 
    then
        mv $backup_db.*.revert.sql $backup_db.revert.sql
        sed '/USE `p02_log_out`;/d' -i p02_log_out*
    fi;
}

insert()
{
    if [ -f $backup_db.patch.sql ]; 
    then
        ssh root@118.192.89.115 "mysql -h$tar_db_host -u$tar_db_user -p$tar_db_password $source_db < $remote_dir/$backup_db.patch.sql"
    fi;
}

#判断命令
case $1 in
    'export_db') export_db
    'make_sql') export_db; import;;
    'insert') insert;;
    *) echo "only make_sql && insert";;
esac
