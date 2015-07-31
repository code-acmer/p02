%%% @author Roowe <bestluoliwe@gmail.com>
%%% @copyright (C) 2013, Roowe
%%% @doc
%%% 成就协议
%%% @end
%%% Created : 28 Jun 2013 by Roowe <bestluoliwe@gmail.com>

-module(pp_achieve).
%% -export([handle/3]).

%% -include("define_logger.hrl").
%% -include("pb_32_pb.hrl").
%% -include("define_info_32.hrl").

%% %% 查看当前成就
%% handle(32001, Status, _) ->
%%     case mod_achieve:get_current_player_all_achieve(Status) of
%%         {fail, Reason} ->
%%             {info, Reason};
%%         {ok, PbPlayerAchieveList} ->
%%             case pt_32:write(32001, PbPlayerAchieveList) of
%%                 [] ->
%%                     ok;
%%                 {ok, BinData} ->
%%                     {binary, BinData}
%%             end
%%     end;
%% handle(32002, Status, #pbplayerachieve{
%%                          achieve_id = AchieveID,
%%                          type       = _Type
%%                         }) ->
%%     case mod_achieve:receive_achieve_reward(Status, AchieveID) of
%%         {fail, Reason} ->
%%             {info, Reason};
%%         {ok, NewPlayer} ->
%%             %% 领取奖励成功
%%             handle(32001, NewPlayer, null),
%%             {ok, NewPlayer}
%%     end;
%% %% 不匹配的协议
%% handle(_Cmd, _, _Data) ->
%%     ?WARNING_MSG("pp_achieve no match, /Cmd/Data/ = /~p/~p/~n", [_Cmd, _Data]),
%%     {error, "pp_achieve no match"}.

