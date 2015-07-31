-module(robot_pt_send_17).
-include("define_robot.hrl").
-export([
         pack_rec/2,
         pack_rec/3
        ]).
pack_rec(Cmd, _State, Args) ->
    pack_rec_args(Cmd, Args).

pack_rec(Cmd, _) ->
    pack_rec(Cmd).

pack_rec(17000) ->
    <<>>;
pack_rec(Cmd) ->
    ?WARNING_MSG("not match ~p~n", [Cmd]),
    error.

pack_rec_args(17010, [BossId]) ->
    #pbworldboss{
       boss_id = BossId
      };
pack_rec_args(17011, [BossId]) ->
    #pbworldboss{
       boss_id = BossId
      };
pack_rec_args(17012, [BossId, Damage]) ->
    #pbworldboss{
       boss_id = BossId,
       damage = Damage,
       crit_damage = [Damage]
      };
pack_rec_args(17014, [BossId]) ->
    #pbworldboss{
       boss_id = BossId
      };
pack_rec_args(Cmd, Args) ->
    ?WARNING_MSG("not match ~p~n", [{Cmd, Args}]),
    error.
