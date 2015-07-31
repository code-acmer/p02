-module(platform_check).
-export([check_pp_account_pass/1,
         check_g17_account_pass/1,
         check_sina_account_pass/1,
         decode_pp/1]).

-include("define_logger.hrl").
-include("pb_10_pb.hrl").
-include_lib("g17/include/g17.hrl").

check_pp_account_pass(#pbaccount{login_ticket = SessionId}) ->
    RequestUrl = info_get(pp_url),
    {ok, _, _, Body} = lib_http_client:post(RequestUrl, SessionId),
    ?DEBUG("pp_platform body ~p~n", [Body]),
    decode_pp(Body).

info_get(pp_url) ->
    "http://passport_i.25pp.com:8080/index?tunnel-command=2852126756";
info_get(_) ->
    ?DEBUG("wrong args~n", []).

decode_pp(Body) ->
    List = string:tokens(Body, ","),
    NewList = lists:map(fun(E) ->
                                [Key, Val] = string:tokens(E, ":"),
                                {Key, Val}
                        end, List),
    %case lists:keyfind("\"status\"", 1, NewList) of
    case proplists:get_value("\"state\"", NewList) of
        0 ->
            AccName = proplists:get_value("user_name", NewList),
            AccId = proplists:get_value("user_id", NewList),
            {AccName, AccId};
        _->
            false
    end.

check_g17_account_pass(#pbaccount{suid = UserId,
                                  device_id = DeviceId,
                                  login_ticket = Token}) ->
    case g17:passport_checkin(DeviceId, Token, UserId) of        
        {ok, #passport_checkin_ret{
                code = ?G17_SIMPLE_RET_SUCCESS,
                error = "",
                data = #user_info_ret{
                          user_id = _UserId,
                          guild_id = GuildId,
                          mb_title_id = MbTitleId,
                          mb_number_id = MbNumber
                         }
               }} ->
            {ok, UserId, GuildId, MbTitleId, MbNumber};
        Other  ->
            ?WARNING_MSG("Other:~p~n", [Other]),
            false
    end.

check_sina_account_pass(#pbaccount{suid = UserId,
                                   device_id = DeviceId,
                                   login_ticket = Token}) ->
    AppKey = app_misc:get_sdk_config(weibo, appkey),
    Signature = app_misc:get_sdk_config(weibo, signature),
    %% SinaAddress = app_misc:get_sdk_config(weibo, weibo_address),
    Url = app_misc:get_sdk_config(weibo, login_url),

    AppKeyParam = "appkey=" ++ AppKey,
    DeviceIdParam = "deviceid=" ++ DeviceId,
    TokenParam = "token=" ++ Token,
    SuidParam = "suid=" ++ UserId,
    ParamList = [AppKeyParam, DeviceIdParam, SuidParam, TokenParam],
    ParamString =  string:join(ParamList, "&"),
    Md5OriString = string:join([ParamString, Signature], "|"),
    %% Sign = binary_to_list(erlang:md5(Md5OriString)),
    Md5_bin = erlang:md5(Md5OriString),
    Md5_list = binary_to_list(Md5_bin),
    Sign = lists:flatten(list_to_hex(Md5_list)),
    SignParam = "signature=" ++ Sign,
    QueryParmStr = string:join([ParamString, SignParam], "&"),
    ?DEBUG("Url:~p~n",[Url]),
    ?DEBUG("QueryParmStr : ~s~n",[QueryParmStr]),
    case httpc:request(post,{Url, [], "application/x-www-form-urlencoded", QueryParmStr},[],[]) of   
        {ok, {_, _, Body}}->
            ?DEBUG("Return Body :~p~n",[Body]),
            case catch rfc4627:decode(Body) of
                {ok, {obj, Values}, _} ->
                    case lists:keyfind("suid",1, Values) of
                        {_, SuidBinary} ->
                            Suid = hmisc:to_list(SuidBinary),
                            case lists:keyfind("token", 1, Values) of
                                {_, TokenBinary} ->
                                    Token = hmisc:to_list(TokenBinary),
                                    {ok, Suid, Token};
                                _ ->
                                    false
                            end;
                        _ ->
                            false
                    end;
                Other ->
                    ?WARNING_MSG("rfc4627:decode body error cause ~p~n",[Other]),
                    false
            end;
        {error, Reason} ->
            ?WARNING_MSG("error cause ~p~n",[Reason]),
            false
    end.  

list_to_hex(L) ->
    lists:map(fun(X) -> int_to_hex(X) end, L).

int_to_hex(N) when N < 256 ->
    [hex(N div 16), hex(N rem 16)].

hex(N) when N < 10 ->
    $0+N;
hex(N) when N >= 10, N < 16 ->
    $a + (N-10).

