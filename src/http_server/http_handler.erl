-module(http_handler).

-export([init/2]).
-export([terminate/3]).

-include("define_logger.hrl").

init(Req, Opts) ->
    case lists:member(center_node, Opts) of
        true ->
            {ok, execute(Req), Opts};
        false ->
            case http_misc:require_ip_address(Req) of
                true ->
                    Req1 = execute(Req),
                    {ok, Req1, Opts};
                _->
                    Req1 = http_misc:reply_error(Req, <<"only for local user!">>),
                    {ok, Req1, Opts}
            end
    end.

terminate(_Reason, _Req, _State) ->
    ok.

execute(Req) ->
    case cowboy_req:method(Req) of
        <<"GET">> ->
            %?DEBUG("Req1 ~p~n", [Req1]),
            execute_get(Req);
        <<"POST">> ->
            execute_post(Req);
        %% <<"POST">> ->
        %%     ?DEBUG("recv post ~n", []),
        %%     http_misc:reply_error(Req, <<"only get method allow">>);
        _ ->
            http_misc:reply_error(Req, <<"only get method allow">>)
    end.

execute_get(Req) ->
    Path = cowboy_req:path(Req),
    %?QPRINT(Path),
    KeyValues = cowboy_req:parse_qs(Req),
    %?QPRINT(KeyValues),
    %?QPRINT(cowboy_req:parse_qs(Req)),
    case route(Path) of
        {fail, Reason} ->
            http_misc:reply_error(Req, Reason);
        {Mod, FunName} ->
            case Mod:FunName(KeyValues) of
                {fail, Return} ->
                    http_misc:reply_error(Req, Return);
                {ok, RET} ->
                    http_misc:reply_ok(Req, RET);
                Return ->
                    http_misc:reply_ok(Req, Return)
            end
    end.

execute_post(Req) ->
    Path = cowboy_req:path(Req),
    %?QPRINT(Path),
    %?QPRINT(Req),
    {ok, PostVals, Req2} = cowboy_req:body_qs(Req),
    %?QPRINT(PostVals),
    case route(Path, PostVals) of
        {fail, Reason} ->
            http_misc:reply_error(Req, Reason);
        {Mod, FunName, Args} ->
            %% ?PRINT("read apply~n", []),
            case apply(Mod, FunName, Args) of
                {fail, R} ->
                    http_misc:reply_error(Req2, R);
                Other ->
                    http_misc:reply_ok(Req2, Other)
            end
    end.
%% execute_get(Req) ->
%%     cowboy_req:reply(200, 
%%                      [{<<"content-type">>, <<"application/json; charset=utf-8">>}], <<"[{\"a\":1,\"b\":2}{\"a\":1,\"b\":2}]">>, Req).


%% execute_post(KeyValues, Req) ->    
%%     Account = proplists:get_value(<<"user">>, KeyValues),
%%     Password = proplists:get_value(<<"password">>, KeyValues),
%%     ?DEBUG("user ~p, Password ~p~n", [Account, Password]),
%%     cowboy_req:reply(200, 
%%                      [{<<"content-type">>, <<"application/json; charset=utf-8">>}], jiffy:encode(<<"测试get">>), Req).
route(<<"/get_instance_info">>) ->
    {http_user, get_instance_info};
route(<<"/get_player_by_id">>) ->
    {http_user, get_player_by_id};
route(<<"/get_player_skill">>) ->
    {http_user, get_player_skill};
route(<<"/get_server_list">>) ->
    {http_server_list, get_server_list};
route(<<"/get_player_info">>) ->
    {http_user, get_server_player};
route(<<"/get_role_list">>) ->
    {http_user, get_server_player};
route(<<"/mquery">>) ->
    {mquery, excute};
route(<<"/mcount">>) ->
    {mcount, excute};
route(<<"/systeminfo">>) ->
    {msysteminfo, excute};
route(<<"/gm">>) ->
    {mgm, excute};
route(OTHER) ->
    ?DEBUG("Unroute Http Request : ~p~n",[OTHER]),
    {fail, <<"error api">>}.
    
route(<<"/state_get_player">>, KeyValues) ->
    case check_value_valid(<<"player_id">>, KeyValues) of
        fail ->
            {fail, <<"输入错误"/utf8>>};
        {ok, Val} ->
            {server_state_handler, state_get_player, [Val]}
    end;
route(<<"/state_get_bag">>, KeyValues) ->
    case check_value_valid(<<"player_id">>, KeyValues) of
        fail ->
            {fail, <<"输入错误"/utf8>>};
        {ok, Val} ->
            {server_state_handler, state_get_bag, [Val]}
    end;
route(Other, _) ->
    ?WARNING_MSG("Other ~p~n", [Other]),
    {fail, <<"error api">>}.

check_value_valid(Value, KeyValues) ->
    case proplists:get_value(Value, KeyValues) of
        undefined ->
            %?WARNING_MSG("http not recv value ~s~n", [binary_to_list(Value)]),
            fail;
        Bin ->
            case catch binary_to_integer(Bin) of
                Val when is_integer(Val) ->
                    {ok, Val};
                _ ->
                    ?WARNING_MSG("invalid value ~p~n", [Bin]),
                    fail
            end
    end.
