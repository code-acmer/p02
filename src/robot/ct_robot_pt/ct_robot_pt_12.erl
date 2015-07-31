-module(ct_robot_pt_12).

-export([send/2, recv/3]).
-export([send/3]).
-include("define_robot.hrl").
-include("db_base_dungeon_area.hrl").

send(12001, #ct_robot{
               user = #pbuser{lv = PlayerLv}
              } = Robot) ->
    Data = #pbdungeon{ id = lib_robot:get_rand_dungeon(PlayerLv) },
    {ok, Data, Robot};
send(12002, Robot) ->
    NewRobot = lib_robot:get_sub_route(Robot),
    DungeonInfo = NewRobot#ct_robot.dungeon_info,
    Data = #pbdungeon{
              id = DungeonInfo#pbdungeon.id,
              score = 8888,
              sub_route = DungeonInfo#pbdungeon.sub_route,
              reward = [],
              state = ?PLAYER_ALIVE },    
    {ok, Data, NewRobot};
send(12003, Robot) ->
    {ok, <<>>, Robot};
send(Cmd, _) ->
    {send_fail, {send_cmd_not_match, Cmd}}.

send(12001, Robot, DungeonId) ->
    Data = #pbdungeon{id = DungeonId},
    {ok, Data, Robot};
send(12002, _, NewRobot) ->
    DungeonInfo = NewRobot#ct_robot.dungeon_info,
    Data = #pbdungeon{
              id = DungeonInfo#pbdungeon.id,
              score = hmisc:rand(1,9999),
              sub_route = DungeonInfo#pbdungeon.sub_route,
              reward = []},
    {ok, Data, NewRobot#ct_robot{dungeon_info = #pbdungeon{}}};
send(Cmd, _Robot, Args) ->
    {send_fail, {send_cmd_not_match, Cmd, Args}}.
    

recv(12001, Robot, #pbdungeon{} = Data) ->
    {ok, Robot#ct_robot{dungeon_info = Data}};
recv(12002, Robot, _) ->
    {ok, Robot#ct_robot{dungeon_info = #pbdungeon{}}};
recv(12003, Robot, _) ->
    {ok, Robot};
recv(12040, Robot, _) ->
    {ok, Robot};
recv(Cmd, _, _) ->
    {recv_fail, {recv_cmd_not_match, Cmd}}.
