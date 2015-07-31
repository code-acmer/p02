-module(http_misc).
-include("define_http.hrl").
-include("define_player.hrl").
-include("define_logger.hrl").
-compile(export_all).

reply_error(Req, Content) ->
    cowboy_req:reply(?HTTP_BAD_REQUEST, [content_type(json)], Content, Req).
reply_ok(Req, Content) ->
    cowboy_req:reply(?HTTP_OK, [content_type(json)], Content, Req).

http_reply(Code, Req, Content) ->
    cowboy_req:reply(Code, [content_type(json)], Content, Req).
content_type(html) ->
    {<<"content-type">>, <<"text/html; charset=utf-8">>};
content_type(json) ->
    {<<"content-type">>, <<"application/json; charset=utf-8">>};
content_type(plain) ->
    {<<"content-type">>, <<"text/plain; charset=utf-8">>}.

require_ip_address(Req) ->
    {ClientIp, _Port} = cowboy_req:peer(Req),
    lists:foldr(fun
                    (IPBlock, false) ->
                       case string:tokens(IPBlock, "/") of
                           [IPAddress] ->
                               IPAddress =:= string:join(lists:map(fun erlang:integer_to_list/1, tuple_to_list(ClientIp)), ".");
                           [IPAddress, Mask] ->
                               MaskInt = list_to_integer(Mask),
                               IPAddressTuple = list_to_tuple(lists:map(fun erlang:list_to_integer/1, string:tokens(IPAddress, "."))),
                               mask_ipv4_address(ClientIp, MaskInt) =:= mask_ipv4_address(IPAddressTuple, MaskInt)
                       end;
                    (_, true) ->
                       true
                end, false, ["192.168.0.0/16", "127.0.0.1", "10.0.0.0/16"]),
    true.

mask_ipv4_address({I1, I2, I3, I4}, MaskInt) ->
    ((I1 bsl 24 + I2 bsl 16 + I3 bsl 8 + I4) band ((1 bsl 32) - (1 bsl (32 - MaskInt)))).
