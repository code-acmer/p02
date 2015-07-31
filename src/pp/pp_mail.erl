%%%------------------------------------
%%% @Module     : pp_mail
%%% @Created    : 2010.10.05
%%% @Description: 信件操作
%%%------------------------------------
-module(pp_mail).
-export([handle/3]).

-include("define_logger.hrl").
-include("pb_19_pb.hrl").
-include("define_player.hrl").
-include("define_mail.hrl").
-include("define_info_19.hrl").
-include("define_operate.hrl").

%% 提取附件
handle(19002, ModPlayerSate, #pbmail{id = MailId,
                                     type = Type}) ->
    case lib_mail:recv_attachments(ModPlayerSate, MailId, Type) of
        {ok, NewModPlayerSate} ->
            {ok, NewModPlayerSate};          
        {fail, Reason}  ->
            packet_misc:put_info(Reason)
    end;

%% 删除信件(暂时不给删除接口了)
%% handle(19003, ModPlayerState,  #pbid32{id = MailId}) ->
%%     case lib_mail:delete_mails(ModPlayerState?PLAYER, MailId) of
%%         {fail, Reason} ->
%%             packet_misc:put_info(Reason);
%%         DeleteMail ->
%%             {ok, Bin} = pt_19:write(19004, {[], [DeleteMail]}),
%%             packet_misc:put_packet(Bin)
%%     end;
    

%% 获取邮件列表
handle(19004, ModPlayerState, _)->
    {Mails, OperatorsMailList} = 
        lib_mail:get_mails(ModPlayerState?PLAYER, ModPlayerState#mod_player_state.operators_mail_list),
    ?DEBUG("OperatorsMailList: ~p", [Mails]),
    {ok, Bin} = pt_19:write(19004, {Mails, []}),
    packet_misc:put_packet(Bin),
    {ok, ModPlayerState#mod_player_state{operators_mail_list = OperatorsMailList}};

%% 不匹配的协议
handle(Cmd, _, Data) ->
    ?WARNING_MSG("pp_handle no match, /Cmd/Data/ = /~p/~p/~n", [Cmd, Data]),
    {error, "pp_handle no match"}.

