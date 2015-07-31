#!/usr/bin/env escript
%% -*- erlang -*-
%%! -noshell -pa ../ebin

main ([File]) ->
	io:format("is_list:~p~n",[is_list(File)]),
	io:format ("File:~s~n",[File]),
	protobuffs_compile:generate_source (File);
main (_) ->
  io:format ("usage: ~s <protofile>~n",
             [filename:basename (escript:script_name())]),
  halt (1).
