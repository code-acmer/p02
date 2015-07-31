-module(ct_robot_pt_13).

-export([send/2, recv/3,
         send/3]).
-include("define_robot.hrl").

send(13001, Robot) ->
    {ok, <<>>, Robot};
send(13002, Robot)->
    {ok, <<>>, Robot};
send(13007, Robot) ->
    {ok, <<>>, Robot};
send(13005, Robot) ->
    {ok, <<>>, Robot};
send(13006, Robot) ->
    {ok, #pbid32r{id = hmisc:random(1,100)}, Robot};
send(13010, Robot) ->
    {ok, <<>>, Robot};
send(13011, Robot) ->
    {ok, <<>>, Robot};
send(13152, #ct_robot{user = Data} = Robot) ->
    %io:format("13152user~p",[Data]),
    {ok, #pbid64{id = Data#pbuser.id}, Robot};
send(13153, #ct_robot{user = Data} = Robot) ->
    {ok, #pbid64{id = Data#pbuser.id}, Robot};
send(13155, Robot) ->
    {ok, <<>>, Robot};
send(13200, #ct_robot{
               user = #pbuser{lv = PlayerLv}
              } = Robot) ->
    Data = #pbid32{ id = lib_robot:get_rand_dungeon(PlayerLv) },
    {ok, Data, Robot};
send(13202, Robot) ->
    {ok, <<>>, Robot};
send(13205, Robot) ->
    {ok, <<>>, Robot};
send(13206, Robot) ->
    {ok, <<>>, Robot};
send(13207, Robot) ->
    {ok, <<>>, Robot};
send(13204, Robot) ->
    {ok, <<>>, Robot};

send(13310, #ct_robot{
               skill_list = SkillList
              } = Robot) ->
    [Skill | _T] = SkillList,
    {ok, #pbid32r{id = [Skill#pbskill.skill_id]}, Robot};

send(13333, Robot) ->
    {ok, <<>>, Robot};
send(13156, Robot) ->
    {ok, <<>>, Robot};
send(13400, #ct_robot{
               user = #pbuser{battle_ability = BattleAbility}
              }=Robot) ->
    {ok, #pbid32{id = BattleAbility+1}, Robot};
send(13500, Robot) ->
    {ok, <<>>, Robot};

send(13300, #ct_robot{
               skill_list = SkillList,
               user = #pbuser{lv = PlayerLv}
              } = Robot) ->
    ct:log("SkillList : ~p",[SkillList]),
    case lib_robot:get_skill_by_lv(SkillList, PlayerLv) of 
        no_find ->
            ct:log("1"),
            SkillId = lib_robot:get_skill_id(Robot),
            ct:log("2"),
            NewRobot = lib_robot:add_skill(Robot, SkillId),
            ct:log("3"),
            {ok, #pbid32{id = SkillId}, NewRobot};
        PbSkill->
            ct:log(" PbSkill: ~p ",[PbSkill]),
            {ok, #pbid32{id = PbSkill#pbskill.id}, Robot}
    end;

send(13301, #ct_robot{
               skill_list = SkillList
              } = Robot) ->
    case lib_robot:get_skill_by_str_lv(SkillList) of
        no_find -> 
            SkillId = lib_robot:get_skill_id(Robot),
            NewRobot = lib_robot:add_skill(Robot, SkillId),
            {ok, #pbid32{id = SkillId}, NewRobot};
        PbSkill ->
           {ok, #pbid32{id = PbSkill#pbskill.id}, Robot}
    end;    

send(13305, #ct_robot{
               skill_list = SkillList
              } = Robot) ->
    case lib_robot:get_skill_by_sigil(SkillList) of
        no_find ->
            SkillId = lib_robot:get_skill_id(Robot),
            NewRobot1 = lib_robot:add_skill(Robot, SkillId),
            NewRobot2 = lib_robot:add_sigil(NewRobot1, SkillId),
            {ok, #pbid32{id = SkillId}, NewRobot2};
        #pbskill{
           id = Id,
           sigil = [Tid | _TSigilList]
          } ->
            {ok, #pbsigil{id = Id, tid = Tid}, Robot}
    end;



send(Cmd, _) ->
    {send_fail, {send_cmd_not_match, Cmd}}.

send(13150, Robot, IdList) ->
    {ok, #pbid64r{ids = IdList}, Robot};
send(13151, Robot, Tid) ->
    {ok, #pbid64{id = Tid}, Robot};
send(13152, Robot, Tid) ->
    {ok, #pbid64{id = Tid}, Robot};
send(13153, Robot, Tid) ->
    {ok, #pbid64{id = Tid}, Robot};
send(13154, Robot, Tid) ->
    {ok, #pbid64{id = Tid}, Robot};
send(13201, Robot, IdList)->
    {ok, #pbid32r{id = IdList}, Robot};
send(13203, Robot, PlayerId)->
    {ok, #pbid32{id = PlayerId}, Robot};
send(13208, Robot, Msg) ->
    {ok, #pbteamchat{msg = Msg}, Robot};




send(Cmd, _, _) ->
    {send_fail, {send_cmd_not_match, Cmd}}.


recv(13001, Robot, Data) when is_record(Data, pbuser)->
    {ok, Robot#ct_robot{
           user = Data
          }};
recv(13018, #ct_robot{
                 user = User
                } = Robot, Data) 
  when is_record(Data, pbuser) ->
    NewUser = hmisc:record_merge(User, Data),
    {ok, Robot#ct_robot{user = NewUser}};
recv(13150, Robot, _) ->
    {ok, Robot};
recv(13151, Robot, _) ->
    {ok, Robot};
recv(13202, Robot, _) ->
    {ok, Robot};
recv(13204, Robot, _) ->
    {ok, Robot};
recv(13205, Robot, Team)->
    {ok, Robot#ct_robot{team = Team}};
recv(13206, Robot, _) ->
    {ok, Robot};
recv(13333, Robot, #pbskilllist{skill_list = SkillList}) ->
    ct:log(" SkillList: ~p ",[SkillList]),
    NewSkillList = 
        lists:foldl(fun(PbSkill, AccSkillList) ->
                            lists:keystore(PbSkill#pbskill.id, #pbskill.id, AccSkillList, PbSkill)
                    end, Robot#ct_robot.skill_list, SkillList),
    {ok, Robot#ct_robot{skill_list = NewSkillList}};
recv(13400, Robot, _) ->
    {ok, Robot};
recv(13500, Robot, _) ->
    {ok, Robot};
recv(Cmd, _, _) ->
    {recv_fail, {recv_cmd_not_match, Cmd}}.



