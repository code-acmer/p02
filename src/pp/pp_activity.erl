-module(pp_activity).
-export([handle/3]).
-include("define_logger.hrl").
-include("define_player.hrl").
-include("pb_34_pb.hrl").


handle(34001, ModPlayerSate, _) ->
	case lib_activity:activity_list() of
		{fail, Reason}->
			{info, Reason};
		ActivityList ->
			Count = lib_mail:not_read_mail_count(ModPlayerSate?PLAYER_ID),
            {ok, BinData} = pt_34:write(34001, {ActivityList, Count}),
            packet_misc:put_packet(BinData),
            ok
    end;


%% handle(34002, ModPlayerSate, #pbtwistegg{type = Type, count = Count}) ->
%%     case lib_activity:twist_egg(ModPlayerSate, Type, Count) of
%%         {fail, Reason}->
%%             {info, Reason};
%%         {ok, NewModPlayerSate, UpdateGoodsList, GoodsList} ->
%%             {ok, BinData1} = pt_15:write(15001, {ModPlayerSate?PLAYER_ID, UpdateGoodsList, [], []}),
%%             {ok, BinData2} = pt_34:write(34002, GoodsList),
%%             %% {ok, NewPlayer, {lists, [BinData1, BinData2]}}
%%             packet_misc:put_packet(BinData1),
%%             packet_misc:put_packet(BinData2),
%%             {ok,NewModPlayerSate}
%%     end;

handle(_Cmd, _, _Data) ->
    ?WARNING_MSG("pp_handle no match, /Cmd/Data/ = /~p/~p/~n", [_Cmd, _Data]),
    {error, "pp_handle no match"}.
