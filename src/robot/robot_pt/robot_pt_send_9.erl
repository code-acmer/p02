-module(robot_pt_send_9).
-include("define_robot.hrl").
-export([
         pack_rec/2,
         pack_rec/3
        ]).

pack_rec(Cmd, _State, Args) ->
    pack_rec_args(Cmd, Args).

pack_rec(Cmd, _) ->
    pack_rec(Cmd).

pack_rec(9003) ->
    <<>>;
pack_rec(9009) ->
    #pbidstring{id = "-gold,200"};
pack_rec(Cmd) ->
    ?WARNING_MSG("not match ~p~n", [Cmd]),
    error.
pack_rec_args(9009, Args) ->
    #pbidstring{id = Args};
pack_rec_args(Cmd, Args) ->
    ?WARNING_MSG("not match ~p~n", [{Cmd, Args}]),
    error.
