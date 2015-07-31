-module(lib_chat).
-export([chat_world/2,
         request_chat_world/2,
         chat_private/3,
         get_private_msg/4,
         login_get_all_private/1,
         chat_league/2,
         get_league_chat/2
        ]).
         %get_new_msg/1]).

-include("define_logger.hrl"). 
-include("pb_11_pb.hrl").
-include("define_player.hrl").
-include("define_chat.hrl").
-include("define_league.hrl").
-include("define_info_40.hrl").

%%世界聊天部分
chat_world(ModPlayerState, Msg) ->
    Chat = #chats_world{
              player_id = ModPlayerState?PLAYER_ID,
              nickname = ModPlayerState?PLAYER#player.nickname,
              lv = ModPlayerState?PLAYER#player.lv,
              career = ModPlayerState?PLAYER#player.career,
              msg = Msg,
              timestamp = time_misc:unixtime()},
    NewChat = insert_chat(Chat, ModPlayerState?PLAYER_SN),
    ?DEBUG("NewChat ~p~n", [NewChat]),
    ok.
    %% {ok, BinData} = pt_11:write(11010, NewChat),
    %% packet_misc:put_packet(BinData).

%%超出长度之后只删除了一个，不知道会不会无限增长表长度
insert_chat(#chats_world{} = Chat, Sn) ->
    WriteTable = hdb:sn_table(chats_world, Sn),
    ChatNum = hdb:size(WriteTable),
    NewChat = Chat#chats_world{
                id = get_next_chat_worlds_id()},
    case mnesia:dirty_first(WriteTable) of
        '$end_of_table' ->
            hdb:dirty_write(WriteTable, NewChat);
        Key ->
            case ChatNum >= ?MAX_CHAT_LIMIT of
                true ->
                    hdb:dirty_delete(WriteTable, Key),
                    hdb:dirty_write(WriteTable, NewChat);
                false ->
                    hdb:dirty_write(WriteTable, NewChat)
            end
    end,
    NewChat.

get_next_chat_worlds_id() ->         
    lib_counter:update_counter(chats_world_uid).

request_chat_world(ModPlayerState, ChatId) ->
    WriteTable = hdb:sn_table(chats_world, ModPlayerState?PLAYER_SN),
    LastKey = hdb:dirty_last(WriteTable),
    get_chats_from_db(WriteTable, LastKey, ?MAX_GET_CHATS, ChatId, []).

get_chats_from_db(_, '$end_of_table', _, _, CharList) ->
    CharList;
get_chats_from_db(_, _, 0, _, CharList) ->
    CharList;
get_chats_from_db(Table, Key, Num, CharId, CharList) ->
    case Key > CharId of
        true ->
            Chat = hdb:dirty_read(Table, Key, true),
            get_chats_from_db(Table, mnesia:dirty_prev(Table, Key), Num - 1, CharId, [Chat|CharList]);
        false ->
            CharList
    end.

chat_league(#player{id = PlayerId,
                    nickname = Nick}, Msg) ->
    case hdb:dirty_read(league_member, PlayerId) of
        [] ->
            {fail, ?INFO_LEAGUE_NOT_MEMBER};
        #league_member{league_id = LeagueId} ->
            NextId = get_next_league_chat_id(),
            hdb:dirty_write(league_msg, #league_msg{id = NextId,
                                                    player_id = PlayerId,
                                                    nickname = Nick,
                                                    msg = Msg,
                                                    timestamp = time_misc:unixtime()}),
            case hdb:dirty_read(chat_league, LeagueId) of
                [] ->
                    hdb:dirty_write(chat_league, #chat_league{league_id = LeagueId,
                                                              size = 1,
                                                              msg_ids = [NextId]});
                #chat_league{
                   size = Size,
                   msg_ids = IdList} = ChatLeague ->
                    if
                        Size >= ?MAX_LEAGUE_CHAT_LIMIT ->
                            NewIdList = handle_over_flow(league_msg, [NextId|IdList], ?MAX_LEAGUE_CHAT_MIN),
                            hdb:dirty_write(chat_league, ChatLeague#chat_league{size = ?MAX_LEAGUE_CHAT_MIN,
                                                                                msg_ids = NewIdList});
                        true ->
                            hdb:dirty_write(chat_league, ChatLeague#chat_league{size = Size + 1,
                                                                                msg_ids = [NextId|IdList]})
                    end
            end
    end.
                    
get_league_chat(PlayerId, LastId) ->
    case hdb:dirty_read(league_member, PlayerId) of
        [] ->
            [];
        #league_member{league_id = LeagueId} ->
            case hdb:dirty_read(chat_league, LeagueId) of
                [] ->
                    [];
                #chat_league{msg_ids = IdList} ->
                    lists:foldl(fun
                                    (Id, AccList) when Id > LastId ->
                                        [hdb:dirty_read(league_msg, Id)|AccList];
                                    (_, AccList) ->
                                        AccList
                                end, [], IdList)
            end
    end.

%%私聊部分
chat_private(ModPlayerState, SendId, Msg) ->
    PlayerId = ModPlayerState?PLAYER_ID,
    MsgId = get_next_chat_private_id(),
    IfOnLine = 
        case mod_player:get_client_pid(SendId) of
            undefined ->
                false;
            Pid ->
                Pid
        end,
    NewNumFun = fun(Count) ->
                        case IfOnLine of
                            false ->
                                Count;
                            _ ->
                                MsgId
                        end
                end,            
    NewChat = 
        case hdb:dirty_read(chat_private, {PlayerId, SendId}) of
            [] ->
                #chat_private{id = {PlayerId, SendId},
                              msg_ids = [MsgId],
                              recv_id = SendId,
                              new_msg = NewNumFun(0)};
            #chat_private{msg_ids = MsgIds,
                          new_msg = Num} = Chat ->
                NewMsgIds = handle_over_flow(private_msg, [MsgId|MsgIds], ?MAX_PRIVATE_SAVE),
                Chat#chat_private{msg_ids = NewMsgIds,
                                  new_msg = NewNumFun(Num)}
        end,
    hdb:dirty_write(chat_private, NewChat),
    PrivateMsg = #private_msg{id = MsgId,
                              msg = Msg,
                              timestamp = time_misc:unixtime()},
    hdb:dirty_write(private_msg, PrivateMsg),
    {PrivateMsg, IfOnLine}.

handle_over_flow(Table, MsgIds, Length) ->
    {NewMsgIds, DelIds} = list_misc:sublist(MsgIds, Length),
    lists:foreach(fun(Id) ->
                          hdb:dirty_delete(Table, Id)
                  end, DelIds),
    NewMsgIds.


get_next_chat_private_id() ->
    lib_counter:update_counter(chats_private_uid).
get_next_league_chat_id() ->
    lib_counter:update_counter(league_chat_uid).
%%            发送人ID, 接收方ID
get_private_msg(PlayerId, ToPlayerId, ChatId, Flag) ->   %%flag是否改new_msg
    case hdb:dirty_read(chat_private, {PlayerId, ToPlayerId}) of
        [] ->
            [];
        #chat_private{msg_ids = MsgIds} = Chat ->
            if
                Flag =:= true ->
                    hdb:dirty_write(chat_private, Chat#chat_private{new_msg = 0});
                true ->
                    skip
            end,
            lists:foldl(fun
                            (MsgId, AccChat) when MsgId > ChatId ->
                                NewMsg = hdb:dirty_read(private_msg, MsgId),
                                [NewMsg|AccChat];
                            (_, AccChat) ->
                                AccChat
                        end, [], MsgIds)
    end.

login_get_all_private(PlayerId) ->   
    case hdb:dirty_index_read(chat_private, PlayerId, #chat_private.recv_id, true) of
        [] ->
            [];
        ChatList ->
            lists:foldl(fun(Chat, AccMsg) ->
                                [get_private_msg(Chat)|AccMsg]
                        end, [], ChatList)
    end.

get_private_msg(#chat_private{id = {SendId, _},
                              new_msg = Num,
                              msg_ids = MsgIds} = Chat) ->
    NewMsgIdList = 
        lists:filter(fun(MsgId) ->
                             if
                                 MsgId > Num ->
                                     true;
                                 true ->
                                     false
                             end
                     end, MsgIds),
    PrivateMsgList = 
        lists:map(fun(MsgId) ->
                          hdb:dirty_read(private_msg, MsgId)
                  end, NewMsgIdList),
    NewMsg = 
        if
            NewMsgIdList =:= [] ->
                Num;
            true ->
                lists:max(NewMsgIdList)
        end,
    WriteFun = fun() ->
                       hdb:write(chat_private, Chat#chat_private{new_msg = NewMsg})
               end,
    hdb:transaction(WriteFun),
    {SendId, PrivateMsgList}.
