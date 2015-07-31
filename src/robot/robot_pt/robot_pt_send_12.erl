-module(robot_pt_send_12).
-include("define_robot.hrl").

-export([
         pack_rec/2,
         pack_rec/3
        ]).
pack_rec(Cmd, _State, Args) ->
    pack_rec_args(Cmd, Args).

pack_rec(Cmd, _) ->
    pack_rec(Cmd).

pack_rec(12003) ->
    <<>>;
pack_rec(12005) ->
    <<>>;
pack_rec(12006) ->
    <<>>;
pack_rec(12011) ->
    #pbid32{id = 2};
pack_rec(12020) ->
    <<>>;
pack_rec(12030) ->
    <<>>;
pack_rec(12031) ->
    <<>>;
pack_rec(12032) ->
    <<>>;
pack_rec(12041) ->
    <<>>;
pack_rec(12050) ->
    <<>>;
pack_rec(12060) ->
    <<>>;
pack_rec(Cmd) ->
    ?WARNING_MSG("not match ~p~n", [Cmd]),
    error.

pack_rec_args(12001, [Id]) ->
    #pbdungeon{
       id = Id
      };

pack_rec_args(12002, [Id, Route, State, TargetList]) ->
    #pbdungeon{
       id = Id, 
       sub_route = Route,
       score = 9999,
       pass_time = 44,
       %reward = [],
       is_extra = 6,
       state = State,
       boss_flag = 1,
       reward = [],
       %hit_reward = #pbdungeonreward{goods_id = 9100001, number = 10},
       target_list = TargetList
      };
pack_rec_args(12010, [Id, Type]) ->
    #pbflipcard{dungeon_id = Id,
                card_type = Type,
                pos = 1};
pack_rec_args(12011, [Id]) ->
    #pbid32{
       id = Id
      };
pack_rec_args(Cmd, [Id, Route, State]) 
  when Cmd =:= 12004 orelse Cmd =:=12007 ->
    #pbchallengedungeon{
       dungeon_id = Id,
       reward = [],
       score = 1000,
       state = State,
       cur_hp = 100,
       sub_route = Route,
       condition = [1,1,1,0]};
pack_rec_args(12008,[Id, Route, State]) ->
    #pbdailydungeon{dungeon = #pbdungeon{id = Id,
                                         sub_route = Route,
                                         state = State,
                                         reward = []}};
pack_rec_args(12021, [Id]) ->
    #pbid32{id = Id};
pack_rec_args(Cmd, [Id]) 
  when Cmd =:= 12025 orelse Cmd =:= 12026  ->
    #pbid64{id = Id};
pack_rec_args(12040, [Ids]) ->
    #pbid32r{id = Ids};
pack_rec_args(12042, [Id]) ->
    #pbid32{id = Id};
pack_rec_args(12043, [Id]) ->
    #pbmopuplist{dungeon_id = Id,
                 times = 10,
                 flip_pay_card = 1};

pack_rec_args(Cmd, Args) ->
    ?WARNING_MSG("not match ~p~n", [{Cmd, Args}]),
    error.
