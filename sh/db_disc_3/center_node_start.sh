#!/bin/sh
SERVER_ROOT=/home/li/server_p02
MASTER_NODE=center@127.0.0.1
COOKIE=p02_server_cookie

LOG_PATH=$SERVER_ROOT/logs/center_counter_log.txt
MNESIA_DIR=$SERVER_ROOT/mnesia/$MASTER_NODE
CONFIG=$SERVER_ROOT/deps/p02_center/center_config/center.config

start(){
    erl -detached -pa $SERVER_ROOT/ebin/ $SERVER_ROOT/deps/*/ebin \
        -setcookie $COOKIE \
        -name $1 \
        -kernel error_logger \{file,\"$LOG_PATH\"\} \
        -s center_main start \
        -config $CONFIG \
        -mnesia dir \"$MNESIA_DIR\"
}

stop(){
    erl -pa $SERVER_ROOT/ebin/ $SERVER_ROOT/deps/*/ebin \
        -setcookie p02_server_cookie -hidden \
        -name center_node_stop@127.0.0.1 \
        -s center_main stop_master $1
}

live(){
    erl -pa $SERVER_ROOT/ebin/ $SERVER_ROOT/deps/*/ebin \
        -setcookie $COOKIE \
        -name $1 \
        -config $CONFIG \
        -kernel error_logger \{file,\"$LOG_PATH\"\} \
        -s center_main start \
        -mnesia dir \"$MNESIA_DIR\"
}

case $1 in
    'start')
        start $MASTER_NODE;;
    'stop')
        stop $MASTER_NODE;;
    *)
        live $MASTER_NODE
esac
