-module(gen_web_test).

-behavior(gen_server).

-export([init/1,handle_call/3,handle_cast/2,handle_info/2,terminate/2,code_change/3]).
-export([take_url/2,select_urls/2,select_urls0/2,change_half/3]).

-export([start/0,stop/0,deal_t/3,sort_T/5]).
-export([running/3,management/3,for/5,get_ets/0,test_list/0]).
-compile(export_all).

%%*******************************************************************************
start() ->gen_server:start_link({local,?MODULE},?MODULE,[],[]).

%%*******************************************************************************
stop() -> gen_server:cast(?MODULE,stop).

%%*******************************************************************************
init([]) -> {ok,ets:new(?MODULE,[duplicate_bag,public])}.

%%*******************************************************************************
handle_call({List,Num},_From,State) -> 
    deal_t(State,List,Num),
    io:format("~n~p~n",["OK,one process is over!"]),
    {reply,"Ok",State};
handle_call({_ETS_1,_Name,_Bin},_From,State) ->
    Reply=State,
    {reply,Reply,State}.

handle_cast(_Msg,State) ->{noreply,State}.
handle_info(_Info,State) -> {noreply,State}.
terminate(_Reason,_State) -> ok.
code_change(_OldVsn,State,_Extra) -> {ok,State}.

%%*******************************************************************************
monitor_process([],L) ->
    lists:reverse(L);
monitor_process([H|T],L) -> 
    monitor_process(T,[erlang:monitor(H)] ++L).

%%*******************************************************************************
nano_get_url0(Host) -> 
    case httpc:request(get, {Host, []}, [{connect_timeout,30000}], []) of
        {ok, {{_Version, 200, _ReasonPhrase}, _Headers, Body}}  ->
            [Body];
        {ok,{{_Version,404,_ReasonPhrase},_Headers,_Body}} -> 
            {error,"Not Found"};
        {error,Reason} -> 
            {error,Reason};
        _Other -> 
            {error,"Reason"}
    end.

%%******************************************************************************
%%从Body里面提取Url
take_url([],L) -> 
    lists:reverse(L);
take_url([H|T],L) -> 
    take_url(T,parse(H,[]) ++ L).       %%传入一个列表和一个空列表.H是列表中的一个元素

parse([],L) -> 
    lists:reverse(L);

parse("<A HREF=\"" ++ T,L) ->                           %%传入一个列表元素和一个空列表
    Index1=string:str(T,"</A>"), 
    Urls1="<h3>" ++ "<A HREF=\"" ++ string:sub_string(T, 1, Index1+3) ++ "</h3>",
    Tails1=string:sub_string(T,Index1+4),
    parse(Tails1,[Urls1|L]);

parse("<a href=\"" ++ T,L) -> 
    Index=string:str(T,"</a>"),
    Urls="<h3>" ++ "<a href=\"" ++ string:sub_string(T, 1, Index+3) ++ "</h3>",
    Tails=string:sub_string(T,Index+4),
    parse(Tails,[Urls|L]);

parse([_H|T],L) -> parse(T,L).     
%%*******************************************************************************
%%从Url里面挑选完整的Url
select_urls([],L) -> 
    lists:reverse(L);
select_urls([H|T],L) -> 
    select_urls(T,select_urls_slt(H,[]) ++ L).

select_urls_slt([],L) -> 
    lists:reverse(L);
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
%%*******************************************************************************
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
%%*******************************************************************************
deal_t(Ets_Tab,[{Key,{Name,Host}}|T],Num) ->
    Body=nano_get_url0(Host),
    case Body of
        [_] -> 
            file:write_file(Name,Body),
            Url=take_url(Body,[]),
            Url_1 = select_urls(Url,[]),
            Url_2 = select_urls0(Url,[]),
            Url_s2 = change_half(Host,Url_2,[]),
            Url_all = Url_1 ++ Url_s2,
            sort_T(Ets_Tab,Key-1,Url_all,Num,[]),
            deal_t(Ets_Tab,T,Num+erlang:length(Url_all));
        {error,_Reason} -> deal_t(Ets_Tab,T,Num)
    end;
deal_t(_Ets_Tab,[],_Num) ->
    ["OK,One!"].
%%********************************************************************************
sort_T(Ets_Tab,Key,[H|T],Num,L) ->
    sort_T(Ets_Tab,Key,T,Num+1,[{Key,{erlang:integer_to_list(Num)++".html",H}}]++L);
sort_T(Ets_Tab,_Key,[],_Num,L) ->lists:reverse(L),
                                 ets:insert(Ets_Tab,L).
%%********************************************************************************
change_half(_Host,[],L) -> lists:reverse(L);
change_half(Host,[H|T],L) -> change_half(Host,T,[Host ++ H] ++ L).

%%********************************************************************************
%%上面是服务器，下面相当于客户端
%%********************************************************************************

get_ets() -> gen_server:call(?MODULE,{"ETS",1,2}). 
%%********************************************************************************
for(10,Next,List,Num,L) -> 
    Pid=spawn(fun() -> gen_server:call(?MODULE,{lists:sublist(List,1+9*Next),Num}) end),
    lists:reverse([Pid]++L);

for(T,Next,List,Num,L) -> 
    Pid=spawn(fun() -> gen_server:call(?MODULE,{lists:sublist(List,1+(T-1)*Next,Next),Num}) end),
    for(T+1,Next,List,Num+100000,[Pid]++L).
%%********************************************************************************
test_list() ->
    case erlang:length(process1:gets_state(1,2,3))=:=0 of
        false ->
            timer:sleep(10000),
            test_list();
        true ->
            io:format("~n______________~p______________~n",["One Floor!"])
    end.
%%********************************************************************************
management(0,_Ets_Tab,_Directory) -> 
    io:format("~n______________~p______________~n",["OK,Over_all"]);
management(Key,Ets_Tab,Directory) ->
    io:format("~n____This is the ~p floor!______________~n",[Key]),
    file:make_dir(Directory++"/"++erlang:integer_to_list(Key)),
    file:set_cwd(Directory++"/"++erlang:integer_to_list(Key)),
    List=ets:lookup(Ets_Tab,Key), 
    ets:delete(Ets_Tab,Key),  
    All=erlang:length(List),
    Pragment=All div 10,       
    Pid_list=for(1,Pragment,List,0,[]),
    process1:monitor_p(Pid_list),
    test_list(),                  
    management(Key-1,Ets_Tab,Directory++"/"++erlang:integer_to_list(Key)).  
%%********************************************************************************
running(Host,Key,Drectory) ->
    Ets_Tab=get_ets(),
    ets:insert(Ets_Tab,{Key,{"First.html",Host}}),
    io:format("~n____________~p___________~n",["first is ready!"]),
    spawn(fun() -> management(Key,Ets_Tab,Drectory) end). 
%%********************************************************************************
