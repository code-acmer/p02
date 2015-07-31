-module(ct_robot_pt_10).

-export([send/2, recv/3]).
-include("define_robot.hrl").

send(10000, Robot) ->
    ct:log("10000 ",[]),
    AccName = Robot#ct_robot.account#account_info.accname,
    PassWd = Robot#ct_robot.account#account_info.password,
    ServerId = Robot#ct_robot.account#account_info.sn,
    case robot_account:get_acc_info_from_php(AccName, PassWd) of
        {ok, [AccId, Timestamp, LoginTicket]} ->
            Rec = #pbaccount{
                     suid = AccId,
                     timestamp = list_to_integer(Timestamp),
                     login_ticket = LoginTicket,
                     acc_name = AccName,
                     server_id = ServerId
                    },
            {ok, Rec, Robot#ct_robot{
                        account = Robot?ROBOT_ACCOUNT#account_info{
                                          accid = AccId
                                         }
                       }};
        {error, HTTPReason} ->
            {send_fail, {http_error, HTTPReason}}
    end;
send(10003, #ct_robot{
               account = #account_info{sn=Sn},
               session = Session
              } = Robot) ->
    if
        (#ct_robot{})#ct_robot.session =:= Session ->
            %% it is ugly, but work.
            {send_fail, not_send_10000};
        true ->
            Rec = #pbuserlogininfo{
                     acc_id = Robot?ROBOT_ACCID,
                     acc_name = Robot?ROBOT_ACCNAME,
                     nickname =  hmisc:rand_str(),
                     career = 1,
                     sex = ?MALE,
                     server_id = Sn
                    },
            {ok, Rec, Robot}
    end;

send(Cmd, _) ->
    {send_fail, {send_cmd_not_match, Cmd}}.

recv(10000, Robot, #pbaccountlogin{
                      user_info = UserInfo,
                      session = Session
                     } = _Data) ->
    PlayerId =
        case UserInfo of
            [Head] ->
                Head#pbuserlogininfo.user_id;
            _ ->
                %?WARNING_MSG("Rec ~p~n", [Data]),
                0
        end,
    ?WARNING_MSG("PlayerId ~p~n", [PlayerId]),
    {ok, Robot#ct_robot{
           session = Session,
           player_id = PlayerId
          }};
recv(10003, Robot, #pbuserresult{user_id = PlayerId}) ->
    {ok, Robot#ct_robot{player_id = PlayerId}};
recv(10007, Robot, _) ->
    {ok, Robot#ct_robot{session = (#ct_robot{})#ct_robot.session}};
recv(10030, Robot, #pbid32{id = Result}) ->
    if
        Result =:= 1 ->
            ?WARNING_MSG("SESSION TIMEOUT ~n", []),
            skip;
        true ->
            ?WARNING_MSG("SESSION TIMEOUT Result ~p~n", [Result]),
            skip
    end,
    {ok, Robot#ct_robot{session = (#ct_robot{})#ct_robot.session}};
recv(Cmd, _, Data) ->
    ?WARNING_MSG("Wrong CMD ~p Data ~p~n", [Cmd, Data]),
    {recv_fail, {recv_cmd_not_match, Cmd}}.


