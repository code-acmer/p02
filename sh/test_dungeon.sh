#!/bin/bash
erl -pa ./ebin ./deps/*/ebin  -name test@127.0.0.1\
    -config ./rel/files/sys.config \
    -kernel error_logger \{file,\"./logs/test_dungeon.txt\"\} \
    -eval 'lib_dungeon:test_dungeon()'


