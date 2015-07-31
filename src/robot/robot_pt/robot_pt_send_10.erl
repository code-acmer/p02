-module(robot_pt_send_10).
-include("define_robot.hrl").
-export([
         pack_rec/2,
         pack_rec/3
        ]).

pack_rec(10001, State, [Args]) ->
    {<<>>, State#state{player_id = Args}};
pack_rec(Cmd, State, Args) ->
    pack_rec_args(Cmd, State, Args).

pack_rec(10000, #state{
                  accname = AccName,
                  acc_passwd = AccPassWd,
                  sn = Sn
                 }=State) ->
    case robot_account:get_acc_info_from_php(AccName, AccPassWd) of
        {ok, [AccId, Timestamp, LoginTicket]} ->
            Rec = #pbaccount{
                     suid = AccId,
                     timestamp = list_to_integer(Timestamp),
                     login_ticket = LoginTicket,
                     server_id = Sn,
                     acc_name = AccName
                    },
            {Rec, State#state{accid=AccId}};
        {error, Error} ->
            ?DEBUG("get acc info Err ~p~n", [Error]),
            {error, State}
    end;

pack_rec(10003, #state{
                  accname = AccName,
                  sn = Sn,
                  accid = AccId,
                  last_msg = LastMsg
                 }=State) ->
    case lists:keyfind(10000, 1, LastMsg) of
        false ->
            ?DEBUG("Please Send 10000~n", []),
            {error, State};
        {_, #pbaccountlogin{
               user_info = _
              }} ->
            Rec = #pbuserlogininfo{
                     acc_id = AccId,
                     acc_name = AccName,
                     server_id = Sn,
                     nickname = hmisc:rand_str()
                    },
            {Rec, State}
    end;

pack_rec(Cmd, _) ->
    pack_rec(Cmd).

pack_rec(10008) ->
    <<>>;

pack_rec(10100) ->
    %% [P, G] = crypto:dh_generate_parameters(64, 5),
    %% {PubClient, PriClient} = crypto:generate_key(dh, [P, G]),
    %% #pbrc4{p = P,  %% P是一个大素数
    %%        g = G,  %% G是素数的原根
    %%        pub = PubClient %% CPub = G^CPri mod P 
    %%       };
    <<>>;

pack_rec(Cmd) ->
    ?WARNING_MSG("not match ~p~n", [Cmd]),
    error.

pack_rec_args(10000, State, [Sn]) ->
    NewState = State#state{sn = Sn},
    pack_rec(10000, NewState);
pack_rec_args(Cmd, _, Args) ->
    ?WARNING_MSG("not match ~p~n", [{Cmd, Args}]),
    error.

