-module(ct_robot_pt_19).

-export([send/2, recv/3]).
-include("define_robot.hrl").

send(19001, Robot) ->
    Mail = 
        #pbmail{
           recv_id = 10000008,
           recv_name = "hello",
           title = "title",
           content = "content"
          },
    {ok, Mail, Robot};
send(19002, #ct_robot{mail = Mails} = Robot) ->
    case get_one_mail_not_empty(Mails) of
        [] ->
            ct:fail(no_mail_with_goods);
        PbMail ->
            {ok, #pbid32{id = PbMail#pbmail.id}, Robot}
    end;

send(19003, #ct_robot{mail = Mails} = Robot) ->
    [M|_] = Mails,
    {ok, #pbid32{id = M#pbmail.id}, Robot};
send(19004, Robot) ->
    {ok, <<>>, Robot};
send(Cmd, _) ->
    {send_fail, {send_cmd_not_match, Cmd}}.


recv(19004, #ct_robot{mail = Mails} = Robot, 
     #pbmaillist{update_list = PbUpdateMailList,
                 delete_list = PbDeleteMail
                } =Data) ->
    NewMailList = lists:foldl(fun(PbUpdateMail, NewMails) ->
                                      lists:keystore(PbUpdateMail#pbmail.id, #pbmail.id, NewMails, PbUpdateMail)
                              end, Mails, PbUpdateMailList),
    MailList2 = lists:foldl(fun(PbDelete, AccMaillist) ->
                                    lists:keydelete(PbDelete#pbmail.id, #pbmail.id, AccMaillist)
                            end, NewMailList, PbDeleteMail),
    {ok, Robot#ct_robot{mail = MailList2}};
recv(19004, Robot, _) ->
    {ok, Robot};
recv(19002, #ct_robot{mail = Mails} = Robot, 
     #pbmaillist{update_list = PbUpdateMailList,
                 delete_list = PbDeleteMail
                } =Data) ->
   NewMailList = lists:foldl(fun(PbUpdateMail, NewMails) ->
                       lists:keystore(PbUpdateMail#pbmail.id,#pbmail.id,NewMails,PbUpdateMail)
               end, Mails, PbUpdateMailList),
    {ok, Robot#ct_robot{mail = NewMailList}};
recv(Cmd, _, _) ->
    {recv_fail, {recv_cmd_not_match, Cmd}}.


get_one_mail_not_empty([]) ->
    [];
get_one_mail_not_empty([#pbmail{goodslist = GoodsList} = Pbmail|Tail]) ->
    if
        GoodsList =:= [] -> 
            get_one_mail_not_empty(Tail);
        true ->
            Pbmail
    end.
