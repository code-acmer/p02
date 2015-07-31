-module(robot_account).
-include("define_logger.hrl").
-define(OUTTER_ACCOUNT_SERVER_URL, "http://fhzs.moyou.me/v2/api/").
-define(INNER_ACCOUNT_SERVER_URL, "http://192.168.1.149/php_srv/v2/api/").
-define(LOGIN_RET_SUCCESS, 0).
-define(LOGIN_RET_ACCOUNT_NOT_FOUND, 2).
-export([get_acc_info_from_php/2]).

account_server() ->
    cache_misc:get_with_default(
      account_server, 
      fun() ->
              {expiration, ?INNER_ACCOUNT_SERVER_URL, infinity}
      end).

change_to_outter_account_server() ->
    cache_misc:set(account_server, ?OUTTER_ACCOUNT_SERVER_URL, infinity).

is_outter() ->
     cache_misc:get(account_server) =:= ?OUTTER_ACCOUNT_SERVER_URL.

login_url(AccName, PassWd) ->
    account_server() ++ "4399_login.php?username=" ++ AccName ++ "&password=" ++ hmisc:md5(PassWd).

register_url(AccName, PassWd) ->    
    account_server() ++  "4399_reg.php?username=" ++ AccName ++ "&password=" ++ hmisc:md5(PassWd).

get_acc_info_from_php(AccName, PassWd) ->
    ensure_mod_cache(),
    case http_get_request(login_url(AccName, PassWd)) of
        {ok, Body} ->
            handle_login_reply(Body, AccName, PassWd);
        re_try ->
            get_acc_info_from_php(AccName, PassWd);
        {error, Error} ->
            {error, Error}
    end.

ensure_mod_cache()->
    case whereis(mod_cache) of
        undefined ->
            mod_cache:start_link();
        Pid when is_pid(Pid) ->
            skip
    end.

handle_login_reply(Body, AccName, PassWd) ->
    ?DEBUG("Body ~p~n", [Body]),
    {struct, InfoList} = mochijson:decode(Body),
    case proplists:get_value("ret", InfoList) of
        ?LOGIN_RET_SUCCESS ->
            AccId = proplists:get_value("id", InfoList),
            Timestamp = proplists:get_value("time", InfoList),
            LoginTicket = proplists:get_value("flag", InfoList),
            {ok, [AccId, Timestamp, LoginTicket]};
        ?LOGIN_RET_ACCOUNT_NOT_FOUND ->
            register_account(AccName, PassWd),
            get_acc_info_from_php(AccName, PassWd);
        Other ->
            {error, Other}
    end.
    
-define(REGISTER_RET_SUCCESS, 0).

register_account(AccName, PassWd) ->
    {ok, Body} = http_get_request(register_url(AccName, PassWd)),
    {struct, InfoList} = mochijson:decode(Body),
    ?REGISTER_RET_SUCCESS = proplists:get_value("ret", InfoList),
    ok.

http_get_request(Url) ->
    ?WARNING_MSG("Url ~p~n", [Url]),
    case lib_http_client:request(Url) of
        {ok, "200", _ResponseHeaders, Body} ->
            {ok, Body};
        Other ->
            ?WARNING_MSG("http request  error ~p~n", [Other]),
            case is_outter() of
                false ->
                    change_to_outter_account_server(),
                    re_try;
                true ->
                    {error, req_timedout}
            end
    end.
