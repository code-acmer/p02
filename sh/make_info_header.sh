#!/bin/bash
cp config/info_header.conf deps/leshu_db/priv/
erl -pa ebin deps/*/ebin -name tools@127.0.0.1 -s generate_info_header_file start

