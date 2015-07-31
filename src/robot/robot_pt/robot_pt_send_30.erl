-module(robot_pt_send_30).
-include("define_robot.hrl").
-export([
         pack_rec/2,
         pack_rec/3
        ]).

pack_rec(Cmd, _State, Args) ->
    pack_rec_args(Cmd, Args).

pack_rec(Cmd, _) ->
    pack_rec(Cmd).

pack_rec(30000) ->
    <<>>;
pack_rec(30001) ->
    <<>>;
pack_rec(Cmd) ->
    ?WARNING_MSG("not match ~p~n", [Cmd]),
    error.

pack_rec_args(30005, [Args]) ->
    #pbid32{id = Args};
pack_rec_args(30006, [Args]) ->
    #pbtask{id = Args};
pack_rec_args(Cmd, Args) ->
    ?WARNING_MSG("not match ~p~n", [{Cmd, Args}]),
    error.
