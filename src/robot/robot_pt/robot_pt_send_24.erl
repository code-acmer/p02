-module(robot_pt_send_24).
-include("define_robot.hrl").
-include("define_rank.hrl").

-export([
         pack_rec/2,
         pack_rec/3
        ]).
pack_rec(Cmd, _State, Args) ->
    pack_rec_args(Cmd, Args).

pack_rec(Cmd, _) ->
    pack_rec(Cmd).

pack_rec(24001) ->
    <<>>;
pack_rec(24002) ->
    <<>>;
pack_rec(24003) ->
    <<>>;
pack_rec(24004) ->
    <<>>;
pack_rec(24005) ->
    <<>>;

pack_rec(Cmd) ->
    ?WARNING_MSG("not match ~p~n", [Cmd]),
    error.

pack_rec_args(Cmd, Args) ->
    ?WARNING_MSG("not match ~p~n", [{Cmd, Args}]),
    error.
