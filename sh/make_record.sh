#!/bin/bash
cp ./config/table_to_record.conf ./deps/leshu_db/priv/
erl -pa ./ebin ./deps/*/ebin -name tools@127.0.0.1 -s table_to_record start

