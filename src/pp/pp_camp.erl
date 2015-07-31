-module(pp_camp).

%% -export([
%%          handle/3
%%         ]).

%% -include("define_logger.hrl").
%% -include("define_player.hrl").
%% -include("define_camp.hrl").
%% -include("define_info_44.hrl").
%% -include("pb_44_pb.hrl").

%% %% @doc 获取玩家阵法列表
%% handle(44000, #mod_player_state{
%%                  player = #player{
%%                              camp_send_timestamp = CampSendTimeStamp
%%                             }
%%                 } = ModPlayerSate, #pbid32{
%%                                       id = TimeStamp
%%                                      }) ->
%%     if 
%%         TimeStamp =/= 0 andalso TimeStamp =:= CampSendTimeStamp->
%%             ignore;
%%         true ->
%%             Now = hmisctime:unixtime(),
%%             case lib_camp:get_player_camp(ModPlayerSate?PLAYER_ID) of
%%                 #player_camp{
%%                   } = PlayerCamp ->
%%                     {ok, BinData} = pt_44:write(44000, {Now, PlayerCamp}),
%%                     %% {binary, BinData};
%%                     mod_player:send(ModPlayerSate, BinData),
%%                     {ok, ModPlayerSate#mod_player_state{
%%                            player = ModPlayerSate?PLAYER#player{
%%                                                     camp_send_timestamp = Now
%%                                                    }
%%                           }};
%%                 _ ->
%%                     %% {info, ?INFO_CAMP_NOT_FOUND}
%%                     mod_player:send_info(ModPlayerSate, ?INFO_CAMP_NOT_FOUND)
%%             end            
%%     end;
%% %% @doc 保存玩家阵法
%% handle(44100, ModPlayerSate, #pbcamp{id = CampId,
%%                                      pos_list = PbPosList
%%                                     }) ->
%%     PosList = lists:map(fun({pbcamppos, Pos, Gid}) -> {Pos, Gid} end, PbPosList),
%%     case lib_camp:save_camp(ModPlayerSate, CampId, PosList) of
%%         {ok, NewModPlayerState, NewCamp, UpdatedGoods} ->
%%             Now = hmisctime:unixtime(),
%%             {ok, BinData1} = pt_15:write(15001, {ModPlayerSate?PLAYER_ID, [], [], UpdatedGoods}),
%%             {ok, BinData2} = pt_44:write(44100, {Now, NewCamp}),
%%             mod_player:send(ModPlayerSate, {lists, [BinData1, BinData2]}),
%%             {ok, NewModPlayerState#mod_player_state{
%%                    player = NewModPlayerState?PLAYER#player{
%%                                                 camp_send_timestamp = Now
%%                                                }
%%                   }};
%%         {fail, Reason} ->
%%             %% {info, Reaon}
%%             mod_player:send_info(ModPlayerSate, Reason)
%%     end;
%% handle(44101, ModPlayerSate, #pbid32{id = CampId
%%                              }) ->
%%     case lib_camp:switch_camp(ModPlayerSate, CampId) of
%%         {ok, NewModPlayerState, UpdatedGoods} ->
%%             Now = hmisctime:unixtime(),
%%             {ok, BinData1} = pt_15:write(15001, {ModPlayerSate?PLAYER_ID, [], [], UpdatedGoods}),
%%             {ok, BinData2} = pt_44:write(44101, {Now, CampId}),
%%             mod_player:send(ModPlayerSate, {lists, [BinData1, BinData2]}),
%%             {ok, NewModPlayerState#mod_player_state{
%%                    player = NewModPlayerState?PLAYER#player{
%%                                                 camp_send_timestamp = Now
%%                                                }
%%                   }};
%%         {fail, Reason} ->
%%             mod_player:send_info(ModPlayerSate, Reason);
%%         ok  ->
%%             ok
%%     end;


%% %% 不匹配的协议
%% handle(_Cmd, _, _Data) ->
%%     ?WARNING_MSG("pp_handle no match, /Cmd/Data/ = /~p/~p/~n", [_Cmd, _Data]),
%%     {error, "pp_handle no match"}.
