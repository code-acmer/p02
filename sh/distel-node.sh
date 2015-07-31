#!/bin/bash
ROOT=/home/moyou/server/server_p02/
# ROOT=$1
#READ=/home/roowe/open_source/rabbitmq-server
#BOSS=/home/roowe/happytree/ls_web_tools/
erl -name human@127.0.0.1 -pa $ROOT/ebin $ROOT/deps/*/ebin  -s reloader -detached
