%%%-----------------------------------
%%% @Module  : pt_11
%%% @Created : 2011.10.18
%%% @Description: 11聊天信息
%%%-----------------------------------
-module(pt_11).
-export([write/2, write/3]).

-include("define_logger.hrl").
-include("pb_11_pb.hrl").
-include("define_chat.hrl").

%%
%%客户端 -> 服务端 ----------------------------
%%

%% %%世界聊天
%% read(11010, <<Bin/binary>>) ->
%%     {Msg, _} = pt:read_string(Bin),
%%     {ok, [Msg]};

%% %%帮派聊天
%% read(11030, <<Bin/binary>>) ->
%%     {Msg, _} = pt:read_string(Bin),
%%     {ok, [Msg]};

%% %%附近聊天
%% read(11050, <<Bin/binary>>) ->
%%     {Msg, _} = pt:read_string(Bin),
%%     {ok, [Msg]};

%% %%小喇叭
%% read(11060, <<Color:8, Bin/binary>>) ->
%%     {Msg, _} = pt:read_string(Bin),
%%     {ok, [Color, Msg]};

%% %%私聊
%% read(11070, <<Id:64, Bin/binary>>) ->
%% 	{Msg, _} = pt:read_string(Bin),
%%     {ok, [Id, Msg]};

%% read(_Cmd, _R) ->
%%     {error, no_match}.

%%
%%服务端 -> 客户端 ------------------------------------
%%

%%世界
write(11010, #chats_world{} = Chats) ->
	%% pack_chat(11010, [Id, Nick, Career, Realm, Sex, Vip,State,Bin]);
    PBData = pack_pbchat(Chats),
    pt:pack(11010, PBData);

%%世界错误
%% write(11011, [Errno, Value]) ->
%% 	pack_error(11011, [Errno, Value]);

%%请求世界聊天内容
write(11012, CharList) ->
    PBDataList = [pack_pbchat(Chat) || Chat <- CharList],
    ?DEBUG("PBDataList~p~n", [PBDataList]),
    pt:pack(11012, #pbchatlist{update_list = PBDataList});
write(11013, {PlayerId, SendId, Chat}) ->
    PbChat = pack_private(PlayerId, SendId, Chat),
    pt:pack(11013, PbChat);
write(11014, Ids) ->
    pt:pack(11014, #pbnewmsg{send_list = Ids});
%%私聊
write(11015, {PlayerId, InfoList}) ->
    PbChatList = 
        lists:foldl(fun
                        ({_SendId, []}, AccPb) ->
                           AccPb;
                        ({SendId, MsgList}, AccPb) ->
                           [pack_private(SendId, PlayerId, Msg) || Msg <- MsgList] ++ AccPb 
                   end, [], InfoList),
    pt:pack(11015, #pbprivate{recv_list = PbChatList
                            });

%%请求工会聊天
write(11021, ChatList) ->
    PbChatList = 
        lists:map(fun(#league_msg{
                         id = Id,
                         player_id = PlayerId,
                         nickname = Nick,
                         msg = Msg,
                         timestamp = Time}) ->
                          #pbchat{
                             id_n = Id,
                             send_id = PlayerId,
                             nickname = Nick,
                             msg = Msg,
                             timestamp = Time}
                  end, ChatList),
    pt:pack(11021, #pbchatlist{update_list = PbChatList});

%%帮派
write(11030, [Id, Nick, Career, Realm, Sex,Vip,State, Msg]) ->
	pack_pbchat(11030, [Id, Nick, Career, Realm, Sex,Vip,State, Msg]);

%%帮派错误
%% write(11031, [Errno, Value]) ->
%% 	pack_error(11031, [Errno, Value]);

%%帮派公告
write(11032,[Type, Msg])->
	%% MsgBin = pt:write_string(Msg),	
    %% Data = <<Type:8, MsgBin/binary>>,

    PBData = #pbchat{
                type = Type,
                msg  = hmisc:to_binary(Msg)
               },
    pt:pack(11032,PBData);
    %% {ok, pt:pack(11032, Data)};

%%附近
write(11050, [Id, Nick, Career, Realm, Sex,Vip,State, Msg]) ->
    pack_pbchat(11050, [Id, Nick, Career, Realm, Sex,Vip,State, Msg]);

%%附近聊天错误
%% write(11051, [Errno, Value]) ->
%% 	pack_error(11051, [Errno, Value]);

%%小喇叭
%% write(11060, [Id, Nick, Lv, Realm, Sex, Career, Color,Vip,State, Msg]) ->
%% 	%% NickBin = pt:write_string(Nick),
%%     %% Data = <<Id:64, NickBin/binary, Lv:8, Realm:8, Sex:8, Career:8, Color:8, Vip:8,State:8,BinBin/binary>>,

%% 	%% BinBin = pt:write_string(Bin),
%%     PBData = #pbchat{
%%                 id = Id,
%%                 nickname = Nick,
%%                 lv   = Lv,
%%                 realm = Realm,
%%                 gender = Sex,
%%                 career = Career,
%%                 color  = Color,
%%                 vip    = Vip,
%%                 state  = State,
%%                 msg    = hmisc:to_binary(Msg)},
%%     pt:pack(11060, PBData);

%% %%小喇叭错误
%% write(11061, [Errno, Value]) ->
%% 	pack_error(11061, [Errno, Value]);

%%私聊
write(11070, Data) ->
	%% NickBin = pt:write_string(Nick),
	%% BinBin = pt:write_string(Bin),
    %% Data = <<Id:64, Career:8, Sex:8, NickBin/binary, BinBin/binary>>,

    %% MsgBin = pt:write_string(Msg),
    pt:pack(11070, Data);
    %% {ok, pt:pack(11070, Data)};

%%私聊返回黑名单通知
write(11071, Id) ->
    PBData = #pbchat{
                id = Id
               },
    pt:pack(11071, PBData);
    %% {ok, pt:pack(11071, <<Id:64>>)};

%%私聊返回，假如对方不在线 
write(11072, Id) ->
    PBData = #pbchat{id = Id},
    pt:pack(11072, PBData);
%% {ok, pt:pack(11072, <<Id:64>>)};

%%系统信息
%% write(11080, Msg) ->
%%     %% MsgBin = pt:write_string(Msg),
%%     PBData = #pbchat{
%%                 type    = 1,
%%                 msg     = hmisc:to_binary(Msg)
%%                },
%%     pt:pack(11080, PBData);

write(11080, MsgList) when is_list(MsgList) ->
    PbChatList =
        lists:map(fun ({{NickName, PlayerId, LeagueId, GoldNum}, Time, ?ACM_TYPE_SEND_GIFTS}) ->
                          #pbchat{
                             id = PlayerId,
                             league_id = LeagueId,
                             type = ?ACM_TYPE_SEND_GIFTS,
                             nickname = NickName,
                             timestamp = Time,
                             gold_num = GoldNum
                            };
                      ({{NickName, PlayerId, LeagueId}, Time, ?ACM_TYPE_RECHARGE_GIFTS}) ->
                          #pbchat{
                             id = PlayerId,
                             league_id = LeagueId,
                             type = ?ACM_TYPE_RECHARGE_GIFTS,
                             nickname = NickName,
                             timestamp = Time
                            };
                      ({Msg, Time, Type}) ->
                          #pbchat{msg = unicode:characters_to_binary(Msg),
                                  type = Type,
                                  timestamp = Time}
                  end, MsgList),
    pt:pack(11080, #pbchatlist{update_list = PbChatList});
%%中央提示
write(11081, Msg) ->
	%% MsgBin = pt:write_string(Msg),
    %% Data = <<MsgBin/binary>>,
    PBData = #pbchat{
                msg = hmisc:to_binary(Msg)
               },
    pt:pack(11081, PBData);

%%悬浮提示
write(11082, Msg) ->
	%% MsgBin = pt:write_string(Msg),
    PBData = #pbchat{
                msg = hmisc:to_binary(Msg)
               },
    pt:pack(11082, PBData);


write(Cmd, _R) ->
    ?WARNING_MSG("pt write error Cmd ~p Reason ~p~n", [Cmd, _R]),
    pt:pack(0, null).

%%系统信息
write(11080, Type, Msg) ->
    %% MsgBin = pt:write_string(Msg),    
    ?DEBUG("~nSysMsg:~ts~n", [Msg]),
    PBData = #pbchat{
                type    = Type,
                msg     = Msg
               },
    pt:pack(11080, PBData).

%%聊天内容打包
%% pack_chat(Cmd, [Id, Nick, Lv, Realm, Sex,Vip,State, Bin ]) ->
%% 	NickBin = pt:write_string(Nick),
%% 	BinBin = pt:write_string(Bin),	
%%     Data = <<Id:64, NickBin/binary, Lv:8, Realm:8, Sex:8,Vip:8,State:8, BinBin/binary>>,
%%     {ok, pt:pack(Cmd, Data)}.

pack_pbchat(#chats_world{id = Id, player_id = PlayerId, nickname = Nick,
                         lv = Lv, career = Career, msg = Msg, timestamp = Time}) ->
    #pbchat{
       id_n     = Id,
       id       = PlayerId,
       nickname = Nick,
       lv       = Lv,
       career   = Career,
       msg      = Msg,
       timestamp = Time
      }.

%% {
%%   id ,
%%   league_id, 
%%   nickname, 
%%   msg = Num,
%%   type
%% }


pack_pbchat(_, _) ->
    ok.
%%错误打包
%% pack_error(Cmd, [Errno, Value]) ->
%%     PBData = #pbchat{
%%                 value     =  Value
%%                },
%%     pt:pack(Cmd, PBData).
pack_private(SendId, RecvId, #private_msg{id = Id,
                                          msg = Msg,
                                          timestamp = Time}) ->
    #pbchat{
       id_n = Id,
       send_id = SendId,
       recv_id = RecvId,
       msg = Msg,
       timestamp = Time}.
