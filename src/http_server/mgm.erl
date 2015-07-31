-module(mgm).
-include("common.hrl").
-export([excute/1,
         kick/1,
         ban/1,
         send_mail/1,
         online_count/1,
         send_sys_acm/1
        ]).

excute(Args) when is_list(Args) ->
    ?DEBUG("Args:~p~n",[Args]),
    Op    = mutil:get_op(Args),
    ArgList = mutil:get_args(Args),
    ?DEBUG("Op : ~p, Args : ~p~n", [Op, ArgList]),
    %% {ok, rfc4627:encode(JsonList)};
    ?MODULE:Op(ArgList),
    {ok, <<"success">>};
excute(Args) ->
    ?DEBUG("Args:~p~n",[Args]),
    %% http_misc:reply_ok(Req, Return)    
    [].

%% 踢下线
kick(Args) ->
    case lists:keyfind("player_id", 1, Args) of
        {_, Value} ->
            PlayerId = hmisc:to_integer(Value),
            mod_player:stop(PlayerId, 0);
        _  ->
            ignored
    end.
%% 封号 AND 踢下线
ban(Args) ->
    case lists:keyfind("player_id", 1, Args) of
        {_, Value} ->
            PlayerId = hmisc:to_integer(Value),
            case lists:keyfind("time", 1, Args) of
                {_, OriTimestamp} ->
                    Timestamp = hmisc:to_integer(OriTimestamp),
                    %% BANK
                    mod_player:banrole(PlayerId, Timestamp);
                _ ->
                    ignored
            end;
        _ ->
            ignored
    end.

send_mail(Args) ->
    ?DEBUG("Args:~p~n", [Args]),
    PlayerIds = get_args_value("player_ids", Args),
    Title     = get_args_value("title", Args),
    Content   = get_args_value("content", Args),
    Sender    = get_args_value("sname", Args),
    Attachment = convert_attachment(get_args_value("attachment",Args)),
    ?WARNING_MSG("Sending mail to : ~p, Title : ~p, Content : ~p, Attachment:~p~n",[PlayerIds, Title, Content, Attachment]),
    if
        PlayerIds =/= []  ->
            Mail = lib_mail:mail(Sender, Title, Content, Attachment),
            lib_mail:send_mail(PlayerIds, Mail);
        true -> 
            ignored
    end,
    ok.

send_sys_acm(Args) ->
    Msg = get_args_value("msg", Args),
    Sn = get_args_value("sn", Args),
    %% ?DEBUG("gm send sys acm Msg : ~p~n",[Msg]),
    mod_sys_acm:new_msg(Msg, Sn),
    ok.
    

online_count(_) ->
    case supervisor:count_children(tcp_acceptor_sup_tcp_client_handler) of
        CountList when is_list(CountList) ->
            case lists:keyfind(workers, 1, CountList) of
                {_, Count} ->
                    Count;
                _ ->
                    0
            end;
        _ ->
            0
    end.

get_args_value(Key, Args) ->
    case lists:keyfind(Key, 1, Args) of
        {_, Value} ->
            Value;
        _ ->
            []
    end.

convert_attachment(Attachments) ->
    lists:map(fun([GoodsId, GoodsNum]) ->
                      {GoodsId, GoodsNum}
              end, Attachments).
