#bin/sh
PWD=`dirname $0`
SERVER_ROOT=$PWD/../
IMPORT_DIR=$PWD/../subgit/p02_proto/
INCLUDE_DIR=$PWD/../include/
OUT_SRC_DIR=$PWD/../src/protocol/

erl -pa $SERVER_ROOT/ebin $SERVER_ROOT/deps/protobuffs/ebin -import_dir $IMPORT_DIR -include_dir $INCLUDE_DIR -out_src $OUT_SRC_DIR -sname p02_proto -s protoc -s init stop
