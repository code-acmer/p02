#!/bin/sh

erl -smp auto +P 102400 +A 120 +K true -pa ebin/ deps/*/ebin -name robot_ai@192.168.1.122 -s reloader


