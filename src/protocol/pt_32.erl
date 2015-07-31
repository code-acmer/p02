%%% @author Roowe <bestluoliwe@gmail.com>
%%% @copyright (C) 2013, Roowe
%%% @doc
%%% 成就
%%% @end
%%% Created : 28 Jun 2013 by Roowe <bestluoliwe@gmail.com>

-module(pt_32).

-export([write/2]).

-include("define_logger.hrl").
-include("pb_32_pb.hrl").


write(32001, PbPlayerAchieveList) ->
    ?DEBUG("PbPlayerAchieveList ~p~n", [PbPlayerAchieveList]),
    pt:pack(32001, #pbplayerachievelist{pa_list=PbPlayerAchieveList});
    
write(Cmd, _R) ->
    ?ERROR_MSG("~n Errorcmd ~p ~n",[Cmd]),
    pt:pack(0, null).
