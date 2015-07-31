%%@File pp_combat.erl
%%@Func 处理战斗协议
%%@author Arno

-module(pp_combat).
%% -export([
%%          handle/3
%%         ]).

%% -include("define_logger.hrl").
%% -include("define_combat.hrl").
%% -include("pb_55_pb.hrl").
%% -include("define_info_55.hrl").
%% -include("define_operate.hrl").

%% handle(55001, Player, Data)
%%   when is_record(Data, pbstartcombat) ->
%%     case hmisc:check_cooldown(?OPERATE_COOLDOWN_COMBAT) of
%%         {fail, Reason} ->
%%             %% 竞技失败了
%%             {info, Reason};
%%         ok ->
%%             %% TODO: combat handle
%%             ok
%%     end;
%% %% 不匹配的协议
%% handle(_Cmd, _, _Data) ->
%% 	?WARNING_MSG("pp_handle no match, /Cmd/Data/ = /~p/~p/~n", [_Cmd, _Data]),
%%     {error, "pp_handle no match"}.

