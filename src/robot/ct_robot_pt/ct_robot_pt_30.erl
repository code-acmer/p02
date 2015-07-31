-module(ct_robot_pt_30).

-export([send/2, recv/3]).
-include("define_robot.hrl").

send(30000, Robot) ->
    {ok, <<>>, Robot};
send(30005, #ct_robot{task = TaskList} = Robot) ->
    case TaskList of
        [] ->
            {send_fail, task_null};
        [Task|_] ->
            {ok, Task, Robot}
    end;
send(Cmd, _) ->
    {send_fail, {send_cmd_not_match, Cmd}}.


recv(30004, Robot, _) ->
    {ok, Robot};
recv(Cmd, _, _) ->
    {recv_fail, {recv_cmd_not_match, Cmd}}.
