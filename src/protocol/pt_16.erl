%%%-----------------------------------
%%% @Module  : pt_16
%%% @Created : 2013.12.06
%%% @Description: 12 时装信息
%%%-----------------------------------
-module(pt_16).
-export([write/2]).

-include_lib("define_logger.hrl").
-include_lib("pb_16_pb.hrl").
-include("define_fashion.hrl").
%%
%%客户端 -> 服务端 ----------------------------
%%
write(16001, {Fashions, FashionId}) ->
    PbFashions = to_fashions(Fashions),
    pt:pack(16001, #pbfashionlist{
                      current_id = FashionId,
                      fashion_list = PbFashions});
write(16003, {Fashions,FashionId}) ->
    PbFashions = to_fashions(Fashions),
    pt:pack(16003, #pbfashionlist{
                      current_id = FashionId,
                      fashion_list = PbFashions});

write(16002, _) ->
    pt:pack(16002, <<>>);

write(Cmd, _R) ->
    ?WARNING_MSG("pt write error Cmd ~p, Reason ~p~n", [Cmd, _R]),
    pt:pack(0, <<>>).

to_fashions(Fashions) ->
    lists:map(
        fun(#fashion{
               id = Id,
               fashion_id = BaseId
              }) ->
            #pbfashion{id = Id,  
                       base_id = BaseId}
        end, Fashions).
    
