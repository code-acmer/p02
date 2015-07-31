-module(ai_lib_player).
-include("define_robot.hrl").
-include("define_reward.hrl").
-include("db_base_combat_skill_upgrade.hrl").
-export([get_available_lv/2,
         ensure_money/2,
         check_login_reward/1,
         get_upgrade_skill/1,
         get_str_skill/1,
         get_sigil_change/1
         %get_random_robot/1
        ]).

get_available_lv(Lv, LvList) ->
    Lvs = 
        lists:filter(fun(Tlv) ->
                             if
                                 Lv < Tlv ->
                                     false;
                                 true ->
                                     true
                             end
                     end, LvList),
    hmisc:rand(Lvs).

ensure_money(AccountInfo, Robot) ->
    Gold = Robot?ROBOT_GOLD,
    Coin = Robot?ROBOT_COIN,
    if
        Gold < 100000 andalso Coin < 1000000 ->
            both_less;
        Gold < 100000 ->
            gold_less;
        Coin < 1000000 ->
            coin_less;
        true ->
            skip
    end.

check_login_reward(AccountInfo) ->
    Robot = ct_robot:get_robot(AccountInfo),
    Flag = Robot#ct_robot.user#pbuser.login_reward_flag,
    Flag =:= ?REWARD_CAN_TAKE.

get_upgrade_skill(AccountInfo) ->
    Robot = ct_robot:get_robot(AccountInfo),
    case Robot#ct_robot.skill_list of
        [] ->
            [];
        SkillList when is_list(SkillList)->
            MoneyConf = ensure_money(AccountInfo, Robot),
            {MoneyConf, get_upgrade_skill2(Robot?ROBOT_LV, SkillList)}
    end.
                
get_upgrade_skill2(_, []) ->
    [];
get_upgrade_skill2(RobotLv, [#pbskill{skill_id = BaseId,
                                      lv = Lv} = Skill|Tail]) ->
    case data_base_combat_skill:get(BaseId) of
        #base_combat_skill{max_upgrade_lv = MaxLv,
                           upgrade_id = Index}
          when Lv < MaxLv ->
            case data_base_combat_skill_upgrade:get(Index + Lv) of
                #base_combat_skill_upgrade{req_lv = ReqLv}
                  when ReqLv =< RobotLv ->
                    Skill;
                _ ->
                    get_upgrade_skill2(RobotLv, Tail)
            end;
        _ ->
            get_upgrade_skill2(RobotLv, Tail)
    end.

get_str_skill(AccountInfo) ->
    Robot = ct_robot:get_robot(AccountInfo),
    case Robot#ct_robot.skill_list of
        [] ->
            [];
        SkillList when is_list(SkillList)->
            MoneyConf = ensure_money(AccountInfo, Robot),
            {MoneyConf, get_str_skill2(SkillList)}
    end.

get_str_skill2([]) ->
    [];
get_str_skill2([#pbskill{skill_id = BaseId,
                         str_lv = StrLv} = Skill|Tail]) ->
    case data_base_combat_skill:get(BaseId) of
        #base_combat_skill{max_strengthen_lv = MaxLv} 
          when StrLv < MaxLv ->
            Skill;
        _ ->
            get_str_skill2(Tail)
    end.

get_sigil_change(AccountInfo) ->
    Robot = ct_robot:get_robot(AccountInfo),
    SkillList = Robot#ct_robot.skill_list,
    case list_misc:list_match_one([{#pbskill.sigil, "=/=", []}], SkillList) of
        [] ->
            ?INFO("no sigil skill~n", []),
            [];
        #pbskill{
           skill_id = Id,
           sigil = Sigil} ->
            {Id, hmisc:rand(Sigil)}
    end.

%% get_random_robot(AccountInfo) ->
%%     Robot = ct_robot:get_robot(AccountInfo),
%%     case ets:lookup(robot_ai_cache, robot_count) of
%%         [{_, Count}] when Count > 1->
%%             case get_random_robot2(Robot#ct_robot.account#account_info.num, Count) of
%%                 [] ->
%%                     ?INFO("cannot rand other player~n", []),
%%                     [];
%%                 TNum -> 
%%                     try
%%                         TarRobot = ct_robot:get_robot(robot_ai:robot_info(TNum)),
%%                         Tid = TarRobot?ROBOT_ID,
%%                         case lists:keyfind(Tid, #pbfriend.id, Robot#ct_robot.friendslist) of
%%                             false ->
%%                                 Tid;
%%                             _ ->
%%                                 ?INFO("Already friend ~n", []),
%%                                 []
%%                         end
%%                     catch
%%                         What:Why ->
%%                             ?INFO("What ~p Why ~p~n", [What,Why]),
%%                             []
%%                     end
%%             end;
%%         _ ->
%%             ?INFO("not other robot ~n", []),
%%             []
%%     end.

%% get_random_robot2(Num, Count) ->
%%     TNum = hmisc:rand(1, Count),
%%     if
%%         TNum =:= Num ->
%%             case hmisc:rand(1, Count) of
%%                 Num ->
%%                     [];
%%                 Other ->
%%                     Other
%%             end;
%%         true ->
%%             TNum
%%     end.
