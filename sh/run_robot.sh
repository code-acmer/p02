#!/bin/sh

erl -pa ../ebin/ `pwd`/../deps/*/ebin  ../test -s reloader


