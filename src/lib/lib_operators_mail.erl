-module(lib_operators_mail).

-export([send/4, send/5]).

-export([to_mail/2]).

-export([find_base_operators_mail/1]).

-export([update_operators_mail/2,
         find_operators_mail/2]).

-export([login/1, save/1]).

-include("define_mail.hrl").
-include("define_player.hrl").
-include("common.hrl").

login(PlayerId) ->
    hdb:dirty_index_read(operators_mail, PlayerId, #operators_mail.player_id, true).

save(OperatorsMailList) ->
    lists:map(fun(Mail) ->
                      hdb:save(Mail, #operators_mail.dirty)
              end, OperatorsMailList).

send(Title, Content, Attachments, Options) ->
    send(?SYSTEM_NAME, Title, Content, Attachments, Options).

send(SendName, Title, Content, Attachments,
     [BeginTimeStamp, EndTimeStamp, MinLv, MaxLv]) ->
    BaseOperatorsMail = base_operators_mail(SendName, Title, Content, Attachments,
                                            BeginTimeStamp, EndTimeStamp, MinLv, MaxLv),
    hdb:dirty_write(base_operators_mail, BaseOperatorsMail),
    ok;
send(SendName, Title, Content, Attachments,
     [PlayerIds]) 
  when is_list(PlayerIds) ->
    Mail = lib_mail:mail(SendName, Title, Content, Attachments),
    lib_mail:send_mail(PlayerIds, Mail),
    ok.


base_operators_mail(SendName, Title, Content, Attachments,
                    BeginTimeStamp, EndTimeStamp, MinLv, MaxLv) ->
    #base_operators_mail{
       id = lib_counter:update_counter(base_operators_mail_uid),
       send_timestamp = time_misc:unixtime(),
       begin_timestamp = BeginTimeStamp,
       end_timestamp = EndTimeStamp,
       min_lv = MinLv,
       max_lv = MaxLv,
       send_name = SendName,
       title = Title,
       content = Content,
       attachments = Attachments
      }.

to_mail(#player{
           id = PlayerId,
           lv = Lv
          }, OperatorsMailList0) ->
    Now = time_misc:unixtime(),
    {Mails, AllBaseIds, OperatorsMailList} = 
        hdb:dirty_foldl(fun(#base_operators_mail{
                               id = BaseId,
                               begin_timestamp = BeginTimeStamp,
                               end_timestamp = EndTimeStamp,
                               min_lv = MinLv,
                               max_lv = MaxLv,
                               attachments = Attachments
                              } = BaseOperatorsMail, {AccMails, AccAllBaseIds, AccOperatorsMailList}) ->
                                {NewAccOperatorsMailList, OperatorsMail} = 
                                    case {BeginTimeStamp =< Now, EndTimeStamp >= Now,
                                          condition(MinLv, MaxLv, Lv), find_operators_mail(AccOperatorsMailList, BaseId)} of
                                        {true, true, true, false} -> 
                                            OperatorsMail0 = operators_mail(PlayerId, BaseId),
                                            {[OperatorsMail0 | AccOperatorsMailList], OperatorsMail0};
                                        {_, false, _, OperatorsMail0}
                                          when is_record(OperatorsMail0, operators_mail) ->
                                            if
                                                Attachments =:= [] ->
                                                    db_delete_operators_mail(OperatorsMail0),
                                                    {delete_operators_mail(AccOperatorsMailList, OperatorsMail0), false};
                                                true ->
                                                    {AccOperatorsMailList, OperatorsMail0}
                                            end;
                                        {_, _, _, OperatorsMail0} ->
                                            {AccOperatorsMailList, OperatorsMail0}                                                             
                                    end,
                                {
                                  operators_mail_to_mail(OperatorsMail, BaseOperatorsMail, AccMails), 
                                  [BaseId|AccAllBaseIds],
                                  NewAccOperatorsMailList
                                }
                        end, {[], [], OperatorsMailList0}, base_operators_mail),
    NewOperatorsMailList = lists:foldl(fun(#operators_mail{
                                              base_id = BaseId
                                             } = OperatorsMail, Acc) ->
                                               case lists:member(BaseId, AllBaseIds) of
                                                   true ->
                                                       [OperatorsMail|Acc];
                                                   false ->
                                                       %% 模板库已经删除，可以清理掉
                                                       db_delete_operators_mail(OperatorsMail),
                                                       Acc
                                               end
                                       end, [], OperatorsMailList),
    {Mails, NewOperatorsMailList}.

db_delete_operators_mail(OperatorsMail) ->
    hdb:dirty_delete(operators_mail, OperatorsMail#operators_mail.id).

condition(MinLv, MaxLv, Lv) ->
    MinBool = if
                  MinLv =:= 0 ->
                      true;
                  true ->
                      Lv >= MinLv
              end,
    MaxBool = if
                  MaxLv =:= 0 ->
                      true;
                  true ->
                      Lv =< MaxLv
              end,
    MinBool andalso MaxBool.

operators_mail(PlayerId, BaseId) ->
    #operators_mail{
       id = lib_counter:update_counter(operators_mail_uid),
       player_id = PlayerId,
       base_id = BaseId
      }.

operators_mail_to_mail(false, _, Mails) ->
    Mails;
operators_mail_to_mail(#operators_mail{
                             recv_attachments_state = ?MAIL_ATTACHMENTS_STATE_RECV
                            }, _, Mails) ->
    Mails;
operators_mail_to_mail(#operators_mail{
                               state = State
                              }, 
                       #base_operators_mail{
                          id = BaseId,
                          title = Title,
                          content = Content,
                          attachments = Attachments,
                          send_timestamp = SendTimeStamp,
                          send_name = SendName
                         }, Mails) ->
    [#mails{
        id = BaseId,
        state = State,
        timestamp = SendTimeStamp,
        sname = SendName,
        title = Title,
        content = Content,
        attachment = Attachments,
        type = ?MAIL_TYPE_OPERATORS_DYNAMIC
       } | Mails].

find_base_operators_mail(Id) ->
    hdb:dirty_read(base_operators_mail, Id).

find_operators_mail(List, BaseId) ->
    lists:keyfind(BaseId, #operators_mail.base_id, List).

update_operators_mail(List, OperatorsMail) ->
    lists:keystore(OperatorsMail#operators_mail.base_id, #operators_mail.base_id, 
                   List,
                   OperatorsMail#operators_mail{
                     dirty = 1
                    }).


delete_operators_mail(List, OperatorsMail) ->
    lists:keydelete(OperatorsMail#operators_mail.base_id, #operators_mail.base_id, List).
