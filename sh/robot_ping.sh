#!/bin/bash
erl -pa ./ebin ./deps/*/ebin  -name robot_ping@127.0.0.1 \
    -s reloader \
    -s robot_ping_sup_ctl start_link 

