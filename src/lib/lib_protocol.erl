%%%-------------------------------------------------------------------
%%% @author Zhangr <>
%%% @copyright (C) 2012, Zhangr
%%% @doc
%%% artifact server
%%% @end
%%% Created : 11 Dec 2012 by Zhangr <>
%%%-------------------------------------------------------------------
-module(lib_protocol).

-include("define_logger.hrl").
-include("define_protocol.hrl").

%% API
-export([
         %% load_all/0,
         get_decode_type_by_id/1,
         get_encode_type_by_id/1,
         get_decode_client_type_by_id/1
        ]).

%% @doc
%% @spec load_all() -> ok.
%% @end

%% load_all() ->
%%     L = db_base:select_all(base_protocol, "*", []),
%%     hetsutil:lock(?ETS_BASE_PROTOCOL),
%%     try
%%         hetsutil:truncate(?ETS_BASE_PROTOCOL),
%%         lists:foreach(
%%           fun(Protocol) ->
%%                   Res = list_to_tuple([ets_base_protocol | Protocol]),
%%                   NRes = Res#ets_base_protocol{
%%                            %% 载入时需要将对应的配置转换成atom
%%                            c2s = hmisc:atomize(Res#ets_base_protocol.c2s),
%%                            s2c = hmisc:atomize(Res#ets_base_protocol.s2c)
%%                           },
%%                   ets:insert(?ETS_BASE_PROTOCOL, NRes)
%%           end, L)
%%     catch
%%         _:R ->
%%             ?WARNING_MSG("load_base_protocol failed R:~w Stack: ~p~n",
%%                          [R, erlang:get_stacktrace()])
%%     after
%%         hetsutil:unlock(?ETS_BASE_PROTOCOL)
%%     end,
%%     ok.

%% @doc 根据id获取解码所需要的type字段信息
%% @spec get_decode_type_by_id(Id) -> atom | null
%% @end
get_decode_type_by_id(Id) ->
    case data_base_protocol:get(Id) of
        [] ->
            null;
        Res ->
            Res#ets_base_protocol.c2s
    end.

%% @doc 根据id获取解码所需要的type字段信息
%% @spec get_decode_type_by_id(Id) -> atom | null
%% @end
get_decode_client_type_by_id(Id) ->
    case data_base_protocol:get(Id) of
        [] ->
            null;
        Res ->
            Res#ets_base_protocol.s2c
    end.

%% @doc 根据id获取编码所需要的type字段信息
%% @spce get_encode_type_by_id(Id) -> atom | null
%% @end
get_encode_type_by_id(Id) ->
    case data_base_protocol:get(Id) of
        [] ->
            null;
        Res ->
            Res#ets_base_protocol.s2c
    end.

