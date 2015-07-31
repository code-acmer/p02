-module(robot_pt_send_34).
-include("define_robot.hrl").
-export([
         pack_rec/2
        ]).

pack_rec(Cmd, _) ->
    pack_rec(Cmd).

pack_rec(34002) ->
    #pbtwistegg{type = 2, count = 2}.
