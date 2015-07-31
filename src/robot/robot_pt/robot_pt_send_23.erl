-module(robot_pt_send_23).
-include("define_robot.hrl").
-include("define_arena.hrl").

-export([
         pack_rec/2,
         pack_rec/3
        ]).
pack_rec(Cmd, _State, Args) ->
    pack_rec_args(Cmd, Args).

pack_rec(Cmd, _) ->
    pack_rec(Cmd).

pack_rec(23000) ->
    <<>>;
pack_rec(23001) ->
    <<>>;
pack_rec(23003) ->
    #pbid32{id = 0};
pack_rec(23005) ->
    <<>>;
pack_rec(23006) ->
    <<>>;
pack_rec(23500) ->
    <<>>;
pack_rec(23503) ->
    <<>>;
pack_rec(23504) ->
    <<>>;
pack_rec(23505) ->
    <<>>;
pack_rec(Cmd) ->
    ?WARNING_MSG("not match ~p~n", [Cmd]),
    error.

pack_rec_args(23002, [Id, Robot, Result]) ->
    #pbarenachallenge{id = Id, result = Result, robot = Robot};
pack_rec_args(23501, [Id, Robot]) ->
    #pbarenachallenge{id = Id,
                      robot = Robot};
pack_rec_args(23502, [Id, Result, Robot]) ->
    #pbarenachallenge{id = Id, result = Result, robot = Robot};
pack_rec_args(Cmd, Args) ->
    ?WARNING_MSG("not match ~p~n", [{Cmd, Args}]),
    error.
