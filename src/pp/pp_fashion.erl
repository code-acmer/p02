-module(pp_fashion).

-export([handle/3]).

-include("define_player.hrl").
-include("define_fashion.hrl").
-include("define_logger.hrl").
-include("pb_16_pb.hrl").
-include("define_cache.hrl").

%% 获取时装列表
handle(16001, ModPlayerState, _Data) ->
    #mod_player_state{
       fashion = Fashions
      }=NewModPlayerState = lib_fashion:activate_fashion(ModPlayerState),
    {ok, BinData} = pt_16:write(16001, {Fashions, ModPlayerState?PLAYER#player.fashion}),
    packet_misc:put_packet(BinData),
   {ok, NewModPlayerState};
    %% {ok, Player, BinData};
%%将某个用户的时装列表写入ets和读取
handle(16003, ModPlayerState, #pbid64{id = TID}) ->
    case cache_misc:get(player, TID) of
        [] ->
            ok;
        Player ->
            case cache_misc:get({other_player_fashion, TID}) of
                [] ->                    
                    case hdb:dirty_index_read(fashion, TID, #fashion.player_id) of
                        [] ->
                            skip;
                        FashionList ->
                            cache_misc:set({?OTHER_PLAYER_FASHION, TID}, {FashionList,Player#player.fashion}),
                            {ok, BinData} = pt_16:write(16003, {FashionList,Player#player.fashion}),
                            packet_misc:put_packet(BinData)
                    end;
                {FashionList,FashionId} ->
                    {ok, BinData} = pt_16:write(16003, {FashionList,FashionId}),
                    packet_misc:put_packet(BinData)
            end
    end;

handle(16002, #mod_player_state{
                 fashion = FashionList
                }= ModPlayerState,
       #pbfashionlist{
          change_id = ChangeId
         }) ->
    case lib_fashion:change_fashion(ModPlayerState?PLAYER, FashionList, ChangeId) of
        {fail, Reason} ->
            {info, Reason};
        {ok, NewPlayer} ->
            {ok, BinData} = pt_16:write(16001, {[], NewPlayer#player.fashion}),
            packet_misc:put_packet(BinData),
            %% {ok, NewPlayer, {lists, [BinData, BinData2]}}
            {ok, ModPlayerState#mod_player_state{
                   player = NewPlayer
                  }}
    end;

handle(_Cmd, _, _Data) ->
    ?WARNING_MSG("pp_handle no match, /Cmd/Data/ = /~p/~p/~n", [_Cmd, _Data]),
    {error, "pp_handle no match"}.
