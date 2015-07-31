#bin/sh
make_release(){
    cd $SERVER_ROOT
    mkdir -p release
    for dir in `ls ./deps/`; do
        if [ $dir = "jiffy" ]; then
            mkdir -p release/deps/$dir/priv/
            cp -rf deps/$dir/priv release/deps/$dir/
        fi
        mkdir -p release/deps/$dir/ebin/
        cp -rf deps/$dir/ebin release/deps/$dir/
        mkdir -p release/ebin/
        cp -rf ./ebin release/
        mkdir -p release/sh/
        cp -rf $NODE_CONFIG release/sh/
        mkdir -p release/config/
        cp ./config/server_list.conf.bak release/config/
        cp ./config/dirty_words.txt release/config/
        cp ./config/center.config.bak release/config/
        mkdir -p $GIT_EBIN_ROOT
    done
}

pack()
{
    make_release
    cd $GIT_EBIN_ROOT
    cp -rf $SERVER_ROOT/release/* ./
}

update_ebin()
{
    cd $GIT_EBIN_ROOT
    cp -rf $SERVER_ROOT/release/* ./
    git pull   
    git add .
    git commit -m "new_version"
    git push origin master

}

update_moyou.me()
{
    export_db $MOYOU_ACCOUNT $MOYOU_DB_HOST $MOYOU_DB_USER $MOYOU_DB_PASSWORD
    import $MOYOU_ACCOUNT
    insert $MOYOU_ACCOUNT $MOYOU_DB_HOST $MOYOU_DB_USER $MOYOU_DB_PASSWORD $MOYOU_EBIN_DIR
}
update_sina()
{
    export_db $SINA_ACCOUNT $SINA_DB_HOST $SINA_DB_USER $SINA_DB_PASSWORD
    import $SINA_ACCOUNT
    insert $SINA_ACCOUNT $SINA_DB_HOST $SINA_DB_USER $SINA_DB_PASSWORD $SINA_EBIN_DIR
}

help()
{
    echo -e "\E[0;31;1m脚本需要参数(pack,release,moyou.me,sina,all)\E[0m"
    echo -ne "\E[0;37;1m"
    echo -e "\tpack 仅仅是拷贝beam到本地git，需要手动提交"
    echo -e "\trelease 其实是pack加上自动传到moyou的git上面"
    echo -e "\tmoyou.me 比较齐全的更新到moyou.me,过程会自动比对MYSQL的结构和同步，所以比较慢"
    echo -e "\tsina 同上"
    echo -e "\tall 同时更新moyou.me和sina"
    echo -ne "\E[0m"
}

################ mysql ################
#把远端的表结构导出来
export_db()
{
    LOGIN_STR="-h$2 -u$3 -p$4"
    FindStr="\$(mysql $LOGIN_STR -D $SOURCE_TABLE -Bse \"SHOW TABLES WHERE Tables_in_$SOURCE_TABLE NOT LIKE 'log_player_20%'\")"
    ssh $1 "mysql -h$2 -u$3 -p$4 -e 'CREATE DATABASE IF NOT EXISTS\`$SOURCE_TABLE\` CHARACTER SET utf8 COLLATE utf8_general_ci;' && mysqldump -d -h$2 -u$3 -p$4 $SOURCE_TABLE $FindStr >/tmp/$1.sql"
    scp $1:/tmp/$1.sql /tmp/
}
##把远端的表结构导进去bakup_db 之后和source_db对比
##用正则表达式匹配分表(暂时先不改)
##FindTableStr="\$(mysql $LOGIN_STR -D $DB_NAME -Bse \"SHOW TABLES WHERE Tables_in_$DB_NAME NOT REGEXP '.*_[0-9]{8}$'\")"

import()
{
    ##外网表结构导入到p02_log_out1
    mysql -h$SOURCE_DB_HOST -u$SOURCE_DB_USER -p$SOURCE_DB_PASSWORD -e "DROP DATABASE IF EXISTS\`$BACKUP_TABLE\`; CREATE DATABASE IF NOT EXISTS\`$BACKUP_TABLE\` CHARACTER SET utf8 COLLATE utf8_general_ci;"
    mysql -h$SOURCE_DB_HOST -u$SOURCE_DB_USER -p$SOURCE_DB_PASSWORD $BACKUP_TABLE < /tmp/$1.sql
    ##149表结构导入到p02_log_out2
    mysql -h$SOURCE_DB_HOST -u$SOURCE_DB_USER -p$SOURCE_DB_PASSWORD -e "DROP DATABASE IF EXISTS\`$BACKUP_TABLE2\`; CREATE DATABASE IF NOT EXISTS\`$BACKUP_TABLE2\` CHARACTER SET utf8 COLLATE utf8_general_ci;"
    mysql -h$SOURCE_DB_HOST -u$SOURCE_DB_USER -p$SOURCE_DB_PASSWORD $BACKUP_TABLE2 < /tmp/$SOURCE_ACCOUNT.sql
    
    cd $GIT_EBIN_ROOT
    mkdir -p log/$1
    cd log/$1
    ##要删掉老的sql，否则对比没有更新的时候跑原来那个，出错
    if [ -f $BACKUP_TABLE.patch.sql ]; 
    then
        mv $BACKUP_TABLE.patch.sql $BACKUP_TABLE.patch.sql.bak
    fi;
    if [ -f $BACKUP_TABLE.revert.sql ]; 
    then
        mv $BACKUP_TABLE.revert.sql $BACKUP_TABLE.revert.sql.bak
    fi;

    echo "comparing struct may spend serveral minutes, please wait..."
    schemasync --output-directory=$GIT_EBIN_ROOT/log/$1 mysql://$SOURCE_DB_USER:$SOURCE_DB_PASSWORD@$SOURCE_DB_HOST:3306/$BACKUP_TABLE2 mysql://$SOURCE_DB_USER:$SOURCE_DB_PASSWORD@$SOURCE_DB_HOST:3306/$BACKUP_TABLE
    ##处理新的sql
    if [ -f $BACKUP_TABLE.*.patch.sql ]; 
    then
        mv $BACKUP_TABLE.*.patch.sql $BACKUP_TABLE.patch.sql
        sed '/USE `p02_log_out`;/d' -i p02_log_out*
    fi;
    if [ -f $BACKUP_TABLE.*.revert.sql ]; 
    then
        mv $BACKUP_TABLE.*.revert.sql $BACKUP_TABLE.revert.sql
        sed '/USE `p02_log_out`;/d' -i p02_log_out*
    fi;
}

insert()
{
    update_ebin  ##到这里才update 是因为远程要用到patch.sql,传上取再继续下面的操作
    cd $GIT_EBIN_ROOT/log/$1
    if [ -f $BACKUP_TABLE.patch.sql ]; 
    then
        ssh $1 "cd $5 && git pull && mysql -h$2 -u$3 -p$4 $SOURCE_TABLE < $5/log/$1/$BACKUP_TABLE.patch.sql"
    fi;
}
################ end ################

export_source()
{
    export_db $SOURCE_ACCOUNT $SOURCE_DB_HOST $SOURCE_DB_USER $SOURCE_DB_PASSWORD
}

. `dirname $0`/pub_config
case $1 in
    'pack')pack;;
    'release')make_release; update_ebin;;
    'moyou.me')export_source; update_moyou.me;;
    'sina')export_source; update_sina;;
    'all')export_source; update_moyou.me; update_sina;;
    *)help;;
esac
