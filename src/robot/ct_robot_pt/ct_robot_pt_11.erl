-module(ct_robot_pt_11).

-export([send/2, recv/3]).
-include("define_robot.hrl").

send(11013, Robot) ->
    Data = #pbchat{recv_id = 20000029,
                   msg = "asdf"},
    {ok, Data, Robot};
send(11015, Robot) ->
    Data = #pbchat{id = 20000029},
    {ok, Data, Robot};
send(Cmd, _) ->
    {send_fail, {send_cmd_not_match, Cmd}}.


recv(11015, Robot, _) ->
    {ok, Robot};
recv(Cmd, _, _) ->
    {recv_fail, {recv_cmd_not_match, Cmd}}.


