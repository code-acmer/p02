#!/bin/bash
erl -pa ./ebin ./deps/*/ebin  -name test@127.0.0.1\
    -s generate_cost_type start

