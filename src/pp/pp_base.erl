%%%--------------------------------------
%%% @Module  : pp_base
%%% @Created : 2010.09.23
%%% @Description:  基础功能
%%%--------------------------------------
-module(pp_base).
-export([handle/3]).
-include("define_logger.hrl").
-include("define_player.hrl").
-include("define_info_9.hrl").
-include("pb_common_pb.hrl").


%% 同步时间戳信息
handle(9003, ModPlayerState, _) ->
    {ok, BinData} = pt:pack(9003, #pbid32{id = time_misc:unixtime()}),
    packet_misc:put_packet(BinData);
handle(9009, ModPlayerState, #pbidstring{id = String}) ->
    case lib_gm:cmd(ModPlayerState, String) of
        {fail, Reason} ->
            ?DEBUG("wrong gm cmd~n", []),
            packet_misc:put_info(Reason);
        not_open_gm_cmd ->
            ?DEBUG("gm cmd not open~n", []),
            skip;
        {ok, NewModPlayerState} ->
            ?DEBUG("gm cmd ok~n", []),
            {ok, NewModPlayerState};
        _ ->
            skip
    end;
        
%% 不匹配的协议
handle(_Cmd, _, _Data) ->
	?WARNING_MSG("pp_handle no match, /Cmd/Data/ = /~p/~p/~n", [_Cmd, _Data]),
    {error, "pp_handle no match"}.

