-module(ct_robot_pt_17).

-export([send/2, recv/3]).
-export([send/3]).
-include("define_robot.hrl").

send(17000, Robot) ->
    {ok, <<>>, Robot};
send(Cmd, _) ->
    {send_fail, {send_cmd_not_match, Cmd}}.

send(17010, Robot, Id) ->
    Data = #pbworldboss{
              boss_id = Id
             },
    {ok, Data, Robot};
send(17011, Robot, Id) ->
    Data = #pbworldboss{
              boss_id = Id
             },
    {ok, Data, Robot#ct_robot{entry_boss_id = Id}};
send(17012, Robot, Id) ->
    Data = #pbworldboss{
              boss_id = Id,
              damage = hmisc:rand(1, 100)
             },
    {ok, Data, Robot};
send(Cmd, _ ,Args) ->
    {send_fail, {send_cmd_not_match, Cmd, Args}}.


recv(17000, #ct_robot{cur_boss = CurBoss} = Robot, #pbbosslist{update_list = PbBossList}) ->
    NewCurBoss = 
        case lists:keyfind(CurBoss, #pbworldboss.boss_id, PbBossList) of
            false ->
                undefined;
            _ ->
                CurBoss
        end,
    {ok, Robot#ct_robot{boss_list = PbBossList,
                        cur_boss = NewCurBoss}};
recv(17001, Robot, #pbworldboss{hp_cur = Hp}) ->
    CurBoss = 
        if
            Hp =:= 0 ->
                undefined;
            true ->
                Robot#ct_robot.cur_boss
        end,
    {ok, Robot#ct_robot{cur_boss = CurBoss}};
recv(17010, #ct_robot{boss_list = BossList} = Robot, PbWorldBoss) ->
    NewBossList = lists:keystore(PbWorldBoss#pbworldboss.boss_id, #pbworldboss.boss_id, BossList, PbWorldBoss),
    {ok, Robot#ct_robot{boss_list = NewBossList}};
recv(17011, #ct_robot{entry_boss_id = Id} = Robot, _) ->
    {ok, Robot#ct_robot{cur_boss = Id}};
recv(Cmd, _, _) ->
    {recv_fail, {recv_cmd_not_match, Cmd}}.
