%%%--------------------------------------
%%% @Module  : pp_chat
%%% @Created : 2011.10.18
%%% @Description:  聊天功能
%%%--------------------------------------
-module(pp_chat).
-export([handle/3]).

-include("define_logger.hrl"). 
-include("pb_11_pb.hrl").
-include("define_player.hrl").
-include("define_relationship.hrl").
-include("define_chat.hrl").
-include("db_log_player_feedback.hrl").

%%世界聊天
handle(11010, ModPlayerState, #pbchat{msg = Msg}) ->
    FileterBin = sensitive(Msg),
    lib_chat:chat_world(ModPlayerState, FileterBin);
handle(11012, ModPlayerState, #pbid32{id = ChatId}) ->    
    ChatList = lib_chat:request_chat_world(ModPlayerState, ChatId),
    ?DEBUG("ChatList~p~n", [ChatList]),
    {ok, BinData} = pt_11:write(11012, ChatList),
    packet_misc:put_packet(BinData);
%%私聊
handle(11013, ModPlayerState, #pbchat{recv_id = ToPlayerId, msg = Msg}) ->
    FileterBin = sensitive(Msg),
    {Chat, Pid} = lib_chat:chat_private(ModPlayerState, ToPlayerId, FileterBin),
    {ok, Bin} = pt_11:write(11013, {ModPlayerState?PLAYER_ID, ToPlayerId, Chat}),
    if
        is_pid(Pid) ->
            packet_misc:directly_send_packet(Pid, 0, Bin);
        true ->
            skip
    end,
    packet_misc:put_packet(Bin);

%% handle(11014, ModPlayerState, _) ->
%%     IdList = lib_chat:get_new_msg(ModPlayerState?PLAYER_ID),
%%     {ok, Bin} = pt_11:write(11014, IdList),
%%     mod_player:send(ModPlayerState, Bin);
%%上线获取私聊信息
handle(11015, ModPlayerState, _) ->
    PlayerId = ModPlayerState?PLAYER_ID,
    InfoList = lib_chat:login_get_all_private(PlayerId),
    {ok, BinData} = pt_11:write(11015, {PlayerId, InfoList}),
    packet_misc:put_packet(BinData);

%% 玩家反馈信息
handle(11016, ModPlayerState, #pbfeedbackmsg{
                                 title = Title,
                                 content = Content
                                })->
    ?DEBUG("playerId  ~p  title ~ts  content ~ts ~n", [ModPlayerState?PLAYER_ID, Title, Content]),
    mod_base_log:log(log_player_feedback_p, #log_player_feedback{
                                               player_id = ModPlayerState?PLAYER_ID,                        
                                               title =  unicode:characters_to_binary(Title),
                                               content = unicode:characters_to_binary(Content)
                                              });

handle(11020, ModPlayerState, #pbchat{msg = Msg}) ->
    lib_chat:chat_league(ModPlayerState?PLAYER, Msg);
handle(11021, ModPlayerState, #pbid32{id = ChatId}) ->
    ChatList = lib_chat:get_league_chat(ModPlayerState?PLAYER_ID, ChatId),
    {ok, Bin} = pt_11:write(11021, ChatList),
    packet_misc:put_packet(Bin);
%% 不匹配的协议
handle(_Cmd, _, _Data) ->
    ?WARNING_MSG("pp_handle no match, /Cmd/Data/ = /~p/~p/~n", [_Cmd, _Data]),
    {error, "pp_handle no match"}.


sensitive(Msg) ->
    MsgBin = unicode:characters_to_binary(Msg),
    sensitive_word_misc:sensitive_word_filter(MsgBin).
