-module(http_test).
-export([
         test/0,
         start_work/0,
         check_ip/1
        ]).

-include("db_url_mini.hrl").
-include("define_logger.hrl").
-define(URL, "http://www.baidu.com").

test()->
    ok.
    %% {_,_,_,Result} = lib_http_client:get(?URL),
    %% NResult = mochiutf8:codepoints_to_bytes(Result),
    %% %NResult = unicode:characters_to_binary(Result),
    %% io:format("Result: ~ts ~n", [NResult]),
    %% {_, A} = lib_http_client:async_post(Url, Result),
    %% %NA = mochiutf8:codepoints_to_bytes(A),
    %% io:format("A: ~p ~n", [A]).

get_body(Url) ->
    %{_,_,_,Body} = lib_http_client:get(Url),
    case lib_http_client:get(Url) of
        {error, _} ->
            [];
        {_,_,_,Body} ->
            Body
    end.
    %[mochiutf8:codepoints_to_bytes(Body)].

start_work() ->
    start_work([?URL], gb_trees:empty()).
    
start_work([], _Tree) ->
    ok;

start_work([Url|T], Tree) ->
    Body = get_body(Url),
    Url0 = take_url(Body),
    Url1 = select_urls(Url0,[]),
    Url2 = select_urls0(Url0,[]),
    Urls2 = change_half(Url,Url2,[]),
    AllUrl = Url1 ++ Urls2,
    {NTree, NUrlList} = pass_url(AllUrl, {Tree, []}),
    set_url_to_db(NUrlList),
    start_work(NUrlList ++ T, NTree).

pass_url([], {Tree, L}) ->
    {Tree, L};

pass_url([H | AllUrl], {Tree, L}) ->
    case gb_trees:lookup(H, Tree) of
        none ->
            case check_ip(H) of
                true ->
                    pass_url(AllUrl, {gb_trees:insert(H, H, Tree), [H|L]});
                false ->
                    pass_url(AllUrl, {Tree, L})
            end;
        {_, _} ->
            pass_url(AllUrl, {Tree, L})
    end.

get_host(Str) ->
    [Host | _] = string:tokens(Str, "/"),
    Host.

check_ip("http://" ++ Host) ->
    NHost = get_host(Host),
    case inet:getaddr(NHost, inet) of
        {error, _} ->
            false;
        {ok, Ip} ->
            check_ip1(Ip);
        _ ->
            false
    end;

check_ip("https://" ++ Host) ->
    NHost = get_host(Host),
    case inet:getaddr(NHost, inet) of
        {error, _} ->
            false;
        {ok, Ip} ->
            check_ip1(Ip);
        _ ->
            false
    end;

check_ip(_) ->
    false.

check_ip1(_Ip) ->
    true.


set_url_to_db(UrlList) ->
    lists:map(fun(Url) ->
                      mod_base_log:log(url_mini_p, #url_mini{
                                                      url = unicode:characters_to_binary(Url)
                                                     })
              end, UrlList).
    

take_url(Body) -> 
    parse(Body, []).


parse([],L) -> 
    lists:reverse(L);

parse("<A HREF=\"" ++ T,L) ->     %%传入一个列表元素和一个空列表
    Index1=string:str(T,"</A>"), 
    Urls1="<h3>" ++ "<A HREF=\"" ++ string:sub_string(T, 1, Index1+3) ++ "</h3>",
    Tails1=string:sub_string(T,Index1+4),
    parse(Tails1,[Urls1|L]);

parse("<a href=\"" ++ T,L) -> 
    Index=string:str(T,"</a>"),
    Urls="<h3>" ++ "<a href=\"" ++ string:sub_string(T, 1, Index+3) ++ "</h3>",
    Tails=string:sub_string(T,Index+4),
    parse(Tails,[Urls|L]);

parse([_H|T],L) ->
    %io:format("ok"),
    parse(T,L).     

%%从Url里面挑选完整的Url
select_urls([],L) -> lists:reverse(L);
select_urls([H|T],L) -> select_urls(T,select_urls_slt(H,[]) ++ L).
select_urls_slt([],L) -> lists:reverse(L);
select_urls_slt("<h3><a href=\"http" ++ T,L) ->
    Index=string:str(T,"\""),
    Urls="http" ++ string:sub_string(T, 1, Index-1),
    Tails=string:sub_string(T,Index+1),
    select_urls_slt(Tails,[Urls|L]);

select_urls_slt("<h3><A HREF=\"http" ++ T,L) ->
    Index=string:str(T,"\""),
    Urls1="http" ++ string:sub_string(T, 1, Index-1),
    Tails1=string:sub_string(T,Index+2),
    select_urls_slt(Tails1,[Urls1|L]);

select_urls_slt([_H|T],L) -> select_urls_slt(T,L). 

%%从Url里面挑选不完整格式的Url,然后下一步对其处理拼接.
select_urls0([],L) -> lists:reverse(L);
select_urls0([H|T],L) -> select_urls0(T,select_urls_slt0(H,[]) ++ L).
select_urls_slt0([],L) -> lists:reverse(L);
select_urls_slt0("<h3><a href=\"/" ++ T,L) ->
    Index=string:str(T,"\""),
    Urls="/" ++ string:sub_string(T, 1, Index-1),
    Tails=string:sub_string(T,Index+2),
    select_urls_slt0(Tails,[Urls|L]);

select_urls_slt0("<h3><A HREF=\"/" ++ T,L) ->
    Index=string:str(T,"\""),
    Urls1="/" ++ string:sub_string(T, 1, Index-1),
    Tails1=string:sub_string(T,Index+2),
    select_urls_slt0(Tails1,[Urls1|L]);

select_urls_slt0([_H|T],L) -> select_urls_slt0(T,L). 

change_half(_Host,[],L) -> lists:reverse(L);
change_half(Host,[H|T],L) -> change_half(Host,T,[Host ++ H] ++ L).

%% sort_T(Key,[H|T],Num,L) ->
%%     sort_T(Key,T,Num+1,[{Key,{erlang:integer_to_list(Num)++".html",H}}]++L);
%% sort_T(_Key,[],_Num,L) ->lists:reverse(L).
