-module(robot_pt_send_44).
-include("define_robot.hrl").
-export([
         pack_rec/2,
         pack_rec/3
        ]).
pack_rec(Cmd, _State, Args) ->
    pack_rec_args(Cmd, Args).

pack_rec(Cmd, _) ->
    pack_rec(Cmd).

pack_rec(Cmd) ->
    ?WARNING_MSG("not match ~p~n", [Cmd]),
    error.
pack_rec_args(44000, [Timestamp]) ->
    #pbid32{
       id = Timestamp
      };
pack_rec_args(44100, [CampId, PosList]) ->
    PbPosList = lists:map(fun({Pos, Gid}) -> 
                                  {pbcamppos, Pos, Gid} 
                          end, PosList),
    #pbcamp{id = CampId,
            pos_list = PbPosList
           };
pack_rec_args(44101, [Id]) ->
    #pbid32{
       id = Id
      };
pack_rec_args(Cmd, Args) ->
    ?WARNING_MSG("not match ~p~n", [{Cmd, Args}]),
    error.
