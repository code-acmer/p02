-module(robot_pt_send_13).
-include("define_robot.hrl").
-export([
         pack_rec/2,
         pack_rec/3
        ]).
pack_rec(Cmd, _State, Args) ->
    pack_rec_args(Cmd, Args).

pack_rec(Cmd, _) ->
    pack_rec(Cmd).

pack_rec(13001) ->
    <<>>;
pack_rec(13002) ->
    <<>>;
pack_rec(13007) ->
    <<>>;
pack_rec(13009) ->
    <<>>;
pack_rec(13155) ->
    <<>>;
pack_rec(13010) ->
    <<>>;
pack_rec(13011) ->
    <<>>;
pack_rec(13020) ->
    <<>>;
pack_rec(13151) ->
    #pbid64{id = 30000043};
pack_rec(13152) ->
    #pbid64{id = 30000036};
pack_rec(13153) ->
    #pbid64{id = 30000036};
pack_rec(13154) ->
    #pbid64{id = 30000036};
pack_rec(13156) ->
    <<>>;
pack_rec(13004) ->
    #pbid64{id = 30000022};
pack_rec(13202) ->
    <<>>;
pack_rec(13204) ->
    <<>>;
pack_rec(13205) ->
    <<>>;
pack_rec(13206) ->
    <<>>;
pack_rec(13207) ->
    <<>>;
%%获取技能列表
pack_rec(13333) ->
    <<>>;
pack_rec(13500) ->
    <<>>;
pack_rec(13501) ->
    <<>>;
pack_rec(13600) ->
    <<>>;
pack_rec(Cmd) ->
    ?WARNING_MSG("not match ~p~n", [Cmd]),
    error.

pack_rec_args(13006, [IdList]) when is_list(IdList) -> 
    #pbid32r{id = IdList};
pack_rec_args(13008, [IdList]) when is_list(IdList) -> 
    #pbid64r{ids = IdList};
pack_rec_args(13004, [IdList]) -> 
    #pbid64r{ids = IdList};
pack_rec_args(13021, [Id]) -> 
    #pbid32{id = Id};
pack_rec_args(13140, [Id]) ->
    #pbid64{id = Id};
pack_rec_args(13141, [Id]) ->
    #pbid64{id = Id};
pack_rec_args(13150, [Ids]) -> 
    #pbid64r{ids = Ids};
pack_rec_args(13200, [Id]) -> 
    #pbid32{id = Id};
pack_rec_args(13202, [TeamNum, DungeonId]) ->
    #pbteam{team_num = TeamNum, dungeon_id = DungeonId};
pack_rec_args(13203, [Id]) -> 
    #pbid32{id = Id};
pack_rec_args(13201, [List]) -> 
    #pbid32r{id = List};
pack_rec_args(13208, [Msg]) -> 
    #pbteamchat{msg = Msg};
pack_rec_args(13209, [Id]) -> 
    #pbid32{id = Id};
pack_rec_args(13400, [Id]) -> 
    #pbid32{id = Id};

pack_rec_args(Cmd, [Id]) 
  when Cmd >= 13151 andalso
       Cmd =< 13154 ->
     #pbid64{id = Id};
%%技能升级
pack_rec_args(13300, [Id]) -> 
    #pbid32{id = Id};
%%技能强化
pack_rec_args(13301, [Id]) ->
    #pbid32{id = Id};
%切换符印
pack_rec_args(13305, [Id, Tid]) ->
    #pbsigil{id = Id, tid = Tid};
pack_rec_args(Cmd, Args) ->
    ?WARNING_MSG("not match ~p~n", [{Cmd, Args}]),
    error.
