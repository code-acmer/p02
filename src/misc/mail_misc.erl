%% 该模块主要参考了boss_mail的封装，去掉了没用到的功能
%% https://github.com/ChicagoBoss/ChicagoBoss/blob/master/src/boss/boss_mail.erl
-module(mail_misc).

-export([send/2, send/3]).

-include("common.hrl").

-define(MAIL_ACCOUNT, "moyou_notify@163.com").

-define(MAIL_OPTIONS, [{relay, "smtp.163.com"}, 
                       {username, ?MAIL_ACCOUNT}, 
                       {password, "moyou@1234"},
                       {ssl, true}, 
                       {tls, true}, 
                       {auth, always}]).

-define(TO_ADDRESS_LIST, []).
                          %"tiantian20007@gmail.com"]).
%% moyou_notify@163.com
%% * 问题一：
%% 您大学辅导员的名字是？
%% 答案：erlang
%% * 问题二：
%% 您孩子的名字是？
%% 答案：opensource

%% * 问题三：
%% 对你影响最大的人是？
%% 答案：cplusplus
%% test() ->
%%     Body = io_lib:format("node: ~p ~p",["哎呀","少年"]),
%%     do_send(?MAIL_ACCOUNT, "136716454@qq.com", list_to_binary(io_lib:format(<<"猜猜我是谁 ~p ~p~n"/utf8>>, [node(), atom])), Body).
%%注意：主题和内容传进来都要求是二进制，防止出现很奇怪的编码问题 中文就unicode:characters_to_binary(）  其他<<"xxx">>
send(Subject, Body) ->
    [do_send(?MAIL_ACCOUNT, ToAddress, Subject, Body) || ToAddress <- ?TO_ADDRESS_LIST].

send(Subject, Body, BodyArgs) ->
    FormatBody = io_lib:format(Body, BodyArgs),
    send(Subject, FormatBody).

do_send(FromAddress, ToAddress, OSubject, OBody) ->
    Subject = transform(OSubject),
    Body = transform(OBody),
    MessageHeader = build_message_header([{"Subject", Subject},
                                          {"To", ToAddress},
                                          {"From", FromAddress}],
                                         "text/plain"), 
    deliver(?MAIL_OPTIONS, FromAddress, ToAddress, 
            fun() -> 
                    [MessageHeader, "\r\n", convert_unix_newlines_to_dos(Body)] 
            end,
            fun
                ({exit, Error}) ->             
                   ?WARNING_MSG("send_mail exit ~p~n", [Error]);
                ({error, Type, Message}) ->
                   ?WARNING_MSG("send_mail error, Type ~p, Message ~p~n", [Type, Message]);
                ({ok, Receipt}) ->
                   ?DEBUG("send_mail successful, result is ~p~n", [Receipt])
           end),
    ok.

deliver(Options, FromAddress, ToAddress, BodyFun, ResultFun) ->
    Email = {FromAddress, [ToAddress], BodyFun},
    gen_smtp_client:send(Email, Options, ResultFun).

transform(Object) when is_list(Object) ->
    list_to_binary(Object);
transform(Other) ->
    Other.


convert_unix_newlines_to_dos(Body) when is_binary(Body) ->
    convert_unix_newlines_to_dos(binary_to_list(Body));
convert_unix_newlines_to_dos(Body) when is_list(Body) ->
    convert_unix_newlines_to_dos(Body, []).

convert_unix_newlines_to_dos([], Acc) ->
    lists:reverse(Acc);
convert_unix_newlines_to_dos([$\r, $\n|Rest], Acc) ->
    convert_unix_newlines_to_dos(Rest, [$\n, $\r|Acc]);
convert_unix_newlines_to_dos([$\n|Rest], Acc) ->
    convert_unix_newlines_to_dos(Rest, [$\n, $\r|Acc]);
convert_unix_newlines_to_dos([H|T], Acc) when is_binary(H); is_list(H) ->
    convert_unix_newlines_to_dos(T, [convert_unix_newlines_to_dos(H)|Acc]);
convert_unix_newlines_to_dos([H|T], Acc) ->
    convert_unix_newlines_to_dos(T, [H|Acc]).

build_message_header(HeaderFields, DefaultMimeType) ->
    ContentType = proplists:get_value("Content-Type", HeaderFields, DefaultMimeType),
    AllHeaders = [{"Content-Type", ContentType} | HeaderFields],
    add_fields(AllHeaders, [], []).

add_fields([], _, Acc) ->
    lists:reverse(Acc);
add_fields([{Key, Value}|Rest], Seen, Acc) ->
    case proplists:get_value(Key, Seen) of
        undefined ->
            add_fields(Rest, [Key|Seen], [[Key, ": ", Value, "\r\n"] | Acc]);
        _ ->
            add_fields(Rest, Seen, Acc)
    end.


