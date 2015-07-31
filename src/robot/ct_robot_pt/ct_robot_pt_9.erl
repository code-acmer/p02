-module(ct_robot_pt_9).

-export([send/2, recv/3,
         send/3]).
-include("define_robot.hrl").

send(9009, Robot, Str) ->
    Rec = #pbidstring{id = Str},
    {ok, Rec, Robot};
send(Cmd, _, _) ->
    {send_fail, {send_cmd_not_match, Cmd}}.

send(Cmd, _) ->
    {send_fail, {send_cmd_not_match, Cmd}}.

recv(9001, Robot, _) ->
    {ok, Robot};
recv(9002, Robot, _) ->
    {ok, Robot};
recv(9003, Robot, _) ->
    {ok, Robot};

recv(Cmd, _, _) ->
    {recv_fail, {recv_cmd_not_match, Cmd}}.



