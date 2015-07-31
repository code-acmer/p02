-module(robot_pt_send_40).
-include("define_robot.hrl").
-export([
         pack_rec/2,
         pack_rec/3
        ]).

pack_rec(Cmd, _State, Args) ->
    pack_rec_args(Cmd, Args).

pack_rec(Cmd, _) ->
    pack_rec(Cmd).

pack_rec(40002) ->
    <<>>;
pack_rec(40003) ->
    <<>>;
pack_rec(40004) ->
    <<>>;
pack_rec(40100) ->
    <<>>;
pack_rec(40101) ->
    <<>>;
pack_rec(40103) ->
    <<>>;
pack_rec(40105) ->
    <<>>;
pack_rec(40106) ->
    <<>>;
pack_rec(40204) ->
    <<>>;
pack_rec(40207) ->
    <<>>;
pack_rec(40300) ->
    <<>>;
pack_rec(40302) ->
    <<>>;
pack_rec(40303) ->
    <<>>;
pack_rec(40407) ->
    <<>>;
pack_rec(40408) ->
    <<>>;
pack_rec(40409) ->
    <<>>;
pack_rec(40600) ->
    <<>>;
pack_rec(40603) ->
    <<>>;
pack_rec(40606) ->
    <<>>;

pack_rec(Cmd) ->
    ?WARNING_MSG("not match ~p~n", [Cmd]),
    error.

pack_rec_args(40000, [Id, Type]) ->
    #pbgetleague{last_key = Id,
                 type = Type};
pack_rec_args(40001, [Name, Decration]) ->
    #pbleague{name = Name,
              declaration = Decration};
pack_rec_args(40005, [Id, Type]) ->
    #pbaddleaguemsg{league_id = Id, type = Type};
pack_rec_args(40006, [Id]) ->
    #pbid64{id = Id};
pack_rec_args(40007, [Id, Title]) ->
    #pbleaguemember{player_id = Id,
                    title = Title};
pack_rec_args(40008, [Decration]) ->
    #pbleague{declaration = Decration};
pack_rec_args(40009, [Num]) ->
    #pbleague{join_ability = Num};

pack_rec_args(40102, [Id, Num]) ->
    #pbsendgiftsmsg{gifts_id = Id, gifts_num = Num};

pack_rec_args(40104, [Num]) ->
    #pbid32{id = Num};

pack_rec_args(40107, [Type]) ->
    #pbmembergetlisttype{type = Type};

pack_rec_args(40108, [Num]) ->
    #pbbosssendgold{gold_num = Num};

pack_rec_args(40109, [Id]) ->
    #pbid32{id = Id};

pack_rec_args(40200, [Id]) ->
    #pbid32{id = Id};

pack_rec_args(40201, [GId, PId]) ->
    #pbpointsend{
       gifts_id = GId,
       player_id = PId
      };

pack_rec_args(40202, [Id]) ->
    #pbid32{id = Id};

pack_rec_args(40203, [Id]) ->
    #pbid32{id = Id};

pack_rec_args(40205, [Id]) ->
    #pbid32{id = Id};

pack_rec_args(40206, [Id]) ->
    #pbid32{id = Id};

pack_rec_args(40208, [Id]) ->
    #pbid32{id = Id};

pack_rec_args(40301, [Id, Type, Group]) ->
    #pbgetleaguegrouprankinfo{
       last_key = Id,
       type = Type,
       league_group = Group
      };
pack_rec_args(40305, [Id]) ->
    #pbid32{id = Id};

pack_rec_args(40306, [Id]) ->
    #pbid32{id = Id};

pack_rec_args(40400, [Id]) ->
    #pbid32{id = Id};

pack_rec_args(40401, [Id]) ->
    #pbid32{id = Id};

pack_rec_args(40402, [PointId, PlayerId]) ->
    #pbappointplayer{point_id = PointId, player_id = PlayerId};

pack_rec_args(40403, [PointId, PlayerId]) ->
    #pbappointplayer{point_id = PointId, player_id = PlayerId};

pack_rec_args(40404, [PointId]) ->
    #pbid32{id = PointId};

pack_rec_args(40405, [Id, Result, Energy]) ->
    #pbleaguepointchallengeresult{point_id = Id,
                                  result = Result,
                                  energy = Energy
                                 };
pack_rec_args(40406, [Id]) ->
    #pbid32{id = Id};

pack_rec_args(40601, [Id]) ->
    #pbid32{id = Id};

pack_rec_args(40602, [Code]) ->
    #pbidstring{id = Code};

pack_rec_args(40604, [Code]) ->
    #pbidstring{id = Code};

pack_rec_args(40605, [Code]) ->
    #pbidstring{id = Code};

pack_rec_args(40607, [Code, PlayerId]) ->
    #pbmasteragreemsg{id = Code,
                      player_id = PlayerId
                     };

pack_rec_args(40608, [Code]) ->
    #pbidstring{id = Code};

pack_rec_args(Cmd, Args) ->
    ?WARNING_MSG("not match ~p~n", [{Cmd, Args}]),
    error.
