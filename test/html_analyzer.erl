-module(html_analyzer).

-export([start/0]).

-define(URL, "http://www.baidu.com").

start() ->
    UrlList = analyze_body(),
    lists:map(fun(Url) -> 
                      io:format("~ts~n", [Url])
              end, UrlList).

get_body() ->
    {_,_,_,Body} = lib_http_client:get(?URL),
    %mochiutf8:codepoints_to_bytes(Body).
    Body.

analyze_body() ->
    Body = get_body(),
    get_html_url(Body).

get_html_url(Body) ->
    UrlList = get_html_url1(Body, []),
    get_html_url2(UrlList, []).

get_html_url1(Body, UrlList) ->
    case {get_substr_index(Body, "<a"), get_substr_index(Body, "/a>")} of
        {0, 0} ->
            UrlList;
        {Index1, Index2}  ->
            Url = string_substr(Body, Index1, Index2 - Index1 + length("/a>")),
            NewBody = string_substr(Body, Index2 + length("/a>") - 1),
            %%get_html_url1(NewBody, [mochiutf8:codepoints_to_bytes(Url) | UrlList])
            get_html_url1(NewBody, [Url | UrlList])
    end. 

get_html_url2([UrlStr | T] = OldUrlList, NewUrlList) ->
    io:format("UrlStr: ~ts~n", [UrlStr]),
    StartIndex = get_substr_index_first(UrlStr, "href="), 
    io:format("~nStartIndex: ~p~n", [StartIndex]),
    EndIndex = get_substr_index_next(UrlStr, StartIndex),
    if
        EndIndex > StartIndex + 3 ->
            string_substr(UrlStr, StartIndex, EndIndex);
        true ->
            skip
    end.
    
get_substr_index_first(UrlStr, Str) ->
    io:format("Str: ~p", [Str]),
    get_substr_index(UrlStr, Str).

get_substr_index_next(UrlStr, Start) ->
    io:format("UrlStr: ~ts", [UrlStr]),
    NUrlStr = string_substr(UrlStr, Start + 7),
    io:format("~nNUrlStr: ~ts~n", [NUrlStr]),
    R = get_substr_index(NUrlStr, """"),
    io:format("~nR: ~p~n", [R]),
    R.

%% 截取Str的SIndex EIndex之间的元素
string_substr(Str, SIndex, EIndex) ->
    string:substr(Str, SIndex, EIndex).

%% 截取Str的Index后的元素
string_substr(Str, Index) ->
    string:substr(Str, Index).

%% 获取SubStr第一个字符出现在Str中的位置
get_substr_index(Str, SubStr) ->
    string:str(Str, SubStr).
    
