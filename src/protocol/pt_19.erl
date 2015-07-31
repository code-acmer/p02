%%------------------------------------
%%% @Module     : pt_19
%%% @Created 	: 2010.10.05
%%% @Description: 信件协议处理 
%%%------------------------------------
-module(pt_19).

-export([write/2]).

-include("define_logger.hrl").
-include("pb_19_pb.hrl").
-include("pb_common_pb.hrl").
-include("define_mail.hrl").

%%
%%服务端 -> 客户端 ------------------------------------
%%

%%回应客户端发信
write(19001, _) ->
    pt:pack(19001, <<>>);
  
write(19004, {UpdateMailList, DeleteMail}) ->
    PbUpdateMailList = to_mails(UpdateMailList),
    PbDeleteMail = 
        lists:map(fun(#mails{id = Id}) ->
                          #pbmail{id = Id}
                  end, DeleteMail),    
    PbMailList = #pbmaillist{update_list = PbUpdateMailList, 
                             delete_list = PbDeleteMail},
    pt:pack(19004, PbMailList);
write(Cmd, _R) ->
    ?WARNING_MSG("pt write error Cmd ~p, Reason ~p~n", [Cmd, _R]),
    pt:pack(0,null).

to_mails(Mails) ->
    lists:map(
        fun(Mail) -> 
                to_pb_mail(Mail)
        end, Mails). 


to_pb_mail_goods(Attachments) ->
    %?PRINT("Attachments ~p~n",[Attachments]),
    lists:map(fun({Id, Sum}) ->
                      #pbmailgoods{goodsid = Id,
                                   goodsum = Sum}
              end, Attachments).

to_pb_mail(#mails{id          = Id,
                  type        = Type,
                  state       = State, 
                  timestamp   = Time,
                  sname       = Sname,
                  splayer_id  = SPlayerId,
                  title       = Title,
                  content     = Connent,
                  attachment = Attachments
                 }) -> 
    PbMailGoods = to_pb_mail_goods(Attachments),
    #pbmail{
        id          = Id,
        type        = Type,
        state       = State, 
        timestamp   = Time,
        sender_id   = SPlayerId,
        sender_name = Sname,
        title       = Title,
        content     = Connent,
        goodslist   = PbMailGoods
    }.

