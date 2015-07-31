-module(robot_pt_send_16).
-include("define_robot.hrl").
-export([
         pack_rec/2,
         pack_rec/3
        ]).
pack_rec(Cmd, _State, Args) ->
    pack_rec_args(Cmd, Args).

pack_rec(Cmd, _) ->
    pack_rec(Cmd).

pack_rec(16001) ->
    <<>>;
pack_rec(16002) ->
    #pbfashionlist{
       change_id = 1
      };
pack_rec(16003) ->
      #pbid64{id = 30000008};
pack_rec(Cmd) ->
    ?WARNING_MSG("not match ~p~n", [Cmd]),
    error.

pack_rec_args(16002, [ChangeId]) ->
    #pbfashionlist{
       change_id = ChangeId
      };
pack_rec_args(Cmd, Args) ->
    ?WARNING_MSG("not match ~p~n", [{Cmd, Args}]),
    error.
