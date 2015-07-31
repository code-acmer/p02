%%%----------------------------------------
%%% @Module  : hmisc
%%% @Created : 2013.10.18
%%% @Description: 常用函数
%%% @通用函数 for happytree
%%%----------------------------------------

-module(hmisc).

%%
%% Include files
%%
-include("define_logger.hrl").

%%
%% Exported Functions
%%

-export([
         whereis_name/1,
         player_process_name/1,
         register/3,
         unregister/2,
         whereis_player_pid/1,
         register_player/2,
         unregister_player/1,
         is_process_alive/1,
         create_process_name/2,
         get_process_all_pid/2,
         atomize/1,
         apply_string/1,
         int_to_hex/1,
         to_binary/1,
         to_bool/1,
         to_float/1,
         to_integer/1,
         to_list/1,
         to_record/2,
         to_string/1,
         to_tuple/1,
         to_utf8_string/1,
         to_atom/1,
         get_process_info_detail/3,
         add_in_max/3,
         ceil/1,
         floor/1,

         sleep/1,
         sleep/2,
         format/2,

         bitstring_to_term/1,
         list_to_hex/1,
         list_to_string/1,
         list_to_term/1,
         string_to_term/1,
         term_to_bitstring/1,
         term_to_string/1,
         to_term_list/1,

         combine_lists/2,
         %% compare_record/3,
         ele_tail/2,
         f2s/1,
         filter_list/3,
         filter_undefined/1,
         filter_zero/1,
         get_chinese_count/1,
         get_list/2,
         get_fields_filter/3,
         get_fields_modified/4,
         get_pos_num_min_0/1,
         get_pos_num_min_1/1,
         get_random_list/2,
         get_value_pair_tuple/2,
         get_value_pair_tuple/3,
         list_random/1,
         lists_max/2,
         lists_min/2,
         lists_nth/2,
         lists_nth_replace/3,
         max/1,
         max/2,
         md5/1,
         check_md5_sign/2,
         hmac_sha1/2,
         is_string/1,
         is_string/2,
         keyfind_first/2,
         replace/3,
         odds/2,
         odds_list/1,
         rand_same/2,
         random/2,
         rand/1,
         rand/2,
         %rand/3,
         rand1000/1,
         rand10000/1,
         rand_n/2,
         rand_n_p/2,
         rand_n_p_r/2,
         remove_string_blank/1,
         replace_all/4,
         re_escape/1,
         shuffle/1,
         subatom/2,
         substr_utf8/2,
         sorted_scequence_minus/1,
         split_and_strip/3,
         choose_second_value/1,
         cal_binary_1_count/1,
         gateway_client_process_name/1,
         get_child_count/1,
         get_child_message_queue_length/1,
         get_heap/0,
         get_heap/1,
         get_ip/1,
         get_max_num/2,
         get_msg_queue/0,
         get_memory/0,
         get_memory/1,
         get_processes/0,
         get_process_info/7,
         get_server_name/1,
         ip/1,
         ip_str/1,
         ip_list_to_binary/1,
         log/5,
         pg2_get_members/1,
         implode/2,
         explode/2,
         explode/3,

         compile_base_data/3,
         write_binary/2,
         write_list_to_binary/1,
         write_system_info/3,
         delete_system_info/1,
         write_monitor_pid/3,
         delete_monitor_pid/1,

         new_session/0,
         get_change/3,
         load_base_data/3,
         load_game_data/3,
         record_merge/2,
         url_decode/1,
         rand_str/0,test/0,
         to_32bit_ip/1
        ]).
test() ->
    io:format("~w~n",["中文"]).
%%
%% API Functions
%%
%% get the pid of a registered name
whereis_name({local, Atom}) -> 
    erlang:whereis(Atom);
whereis_name({global, Atom}) ->
    global:whereis_name(Atom).

%% @doc 注册一个原子
%% @spec
%% @end
register(local, Name, Pid) ->
    erlang:register(Name, Pid);
register(global, Name, Pid) ->
    %% 	case global:whereis_name(Name) of
    %% 		Pid0 when is_pid(Pid0) ->
    %% 			exit(Pid0,normal);
    %% 		undefined ->
    %% 			global:re_register_name(Name, Pid)
    %% 	end.
    global:re_register_name(Name, Pid);
register(unique,Name,Pid) ->
    global:register_name(Name, Pid).

%% @doc 取消一个原子的绑定
%% @spec
%% @end
unregister(local, Name) ->
    erlang:unregister(Name);
unregister(global, Name) ->
    global:unregister_name(Name).

%% @doc 注册一个玩家进程，绑定到一个唯一的原子
%%注册废弃了
register_player(PlayerId, Pid) ->
    PlayerPidName = player_process_name(PlayerId),
    register(global, PlayerPidName, Pid).

%% @doc 取消玩家进程的注册
unregister_player(PlayerId) ->
    PlayerPidName = player_process_name(PlayerId),
    unregister(global, PlayerPidName).

%%
%% API Functions
%%
%% get the pid of a registered name
whereis_player_pid(PlayerId) ->
    case gproc:where(player_process_name(PlayerId)) of
        Pid when is_pid(Pid) ->
            Pid;
        _ ->
            []
    end.
            
%% whereis_player_pid(PlayerId) ->
%%     PlayerProcessName = player_process_name(PlayerId),
%%     case whereis_name({local, PlayerProcessName}) of
%%         Pid 
%%           when is_pid(Pid) ->
%%             case hmisc:is_process_alive(Pid) of
%%                 true ->
%%                     Pid;
%%                 _ ->
%%                     []
%%             end;
%%         _ ->
%%             []
%%     end.
%% whereis_player_pid(PlayerId) -> 
%%     PlayerProcessName = player_process_name(PlayerId),
%%     case whereis_name({global, PlayerProcessName}) of
%%         Pid 
%%           when is_pid(Pid) ->
%%             case hmisc:is_process_alive(Pid) of
%%                 true ->
%%                     Pid;
%%                 _ ->
%%                     []
%%             end;
%%         _ ->
%%             []
%%     end.

is_process_alive(Pid) ->    
    try 
        if
            is_pid(Pid) ->
                case rpc:call(node(Pid), erlang, is_process_alive, [Pid]) of
                    {badrpc, _Reason} ->
                        false;
                    Res ->
                        Res
                end;
            true ->
                false
        end
    catch 
        _:_ ->
            false
    end.

player_process_name(PlayerId) ->
    {n, g, {player, PlayerId}}.

gateway_client_process_name(ServerId)
  when is_integer(ServerId) or is_atom(ServerId) ->
    lists:concat([gateway_srv_,ServerId]).

%% 创建进程名
create_process_name(Prefix, List) ->
    to_atom(
      lists:concat(
        lists:flatten([Prefix] ++ lists:map(fun(T) ->
                                                    ['_', T] end,
                                            List)))).

%% 获取来源IP 
get_ip(Socket) ->
    case inet:peername(Socket) of 
        {ok, {PeerIP,_Port}} ->
            ip_to_binary(PeerIP);
        {error, _NetErr} -> 
            ""
    end.

ip_to_binary(Ip) ->
    case Ip of 
        {A1, A2, A3, A4} -> 
            [ integer_to_list(A1), "." ,
              integer_to_list(A2), "." ,
              integer_to_list(A3), "." ,
              integer_to_list(A4) ];
        _ ->
            "-"
    end.

ip_list_to_binary(Data) ->
    case Data of
        []        -> "";
        undefined -> "-";
        {IP,_PORT} -> ip_to_binary(IP);
        _ when is_list(Data) -> 
            [H|T]=Data,
            [ip_list_to_binary(H), "," , ip_list_to_binary(T) ];
        _ -> "-"
    end. 

get_child_count(Atom) ->
    case whereis_name({local, Atom}) of
        undefined -> 
            0;
        _ ->
            [_,{active, ChildCount},_,_] = supervisor:count_children(Atom),
            ChildCount
    end.

get_child_message_queue_length(Atom) ->
    case whereis_name({local, Atom}) of
        undefined -> 
            [];
        _ ->
            Child_list = supervisor:which_children(Atom),
            lists:map(
              fun({Name, Pid, _Type, [Class]})  when is_pid(Pid) ->
                      {message_queue_len, Qlen} = 
                          erlang:process_info(Pid, message_queue_len),
                      {links, Links} = erlang:process_info(Pid, links),
                      {Name, Pid, Qlen, Class, length(Links)}
              end,
              Child_list)
    end.	

%% --------------------------------------------------------------------
%% Func: get pid info/7
%% Param Process: atom Pid or Pid RegName
%% 		 Top: 0=all result, N=0-N record in the result
%% 		 NeedModule fiter Pid module,[]=all
%% 		 Layer node child layer, 0=all,1=self
%%       MinMsgLen message queue length >= MinMsgLen
%%       MinMemSize pid memory size >= MinMemSize
%%       OrderKey, type atom and the value is: msglen,memory
%% Purpose: get pid info
%% Returns: {ok,Result,Count} Result=[{Pid,RegName,MemSize,MessageLength,Module},...]
%% 			{error,Reason}
%% --------------------------------------------------------------------
get_process_info(Process, Top, NeedModule, Layer, MinMsgLen, MinMemSize, OrderKey) ->
    RootPid =
        if erlang:is_pid(Process) ->
                Process;
           true ->
                case whereis_name({local, Process}) of
                    undefined ->
                        error;
                    ProcessPid ->
                        ProcessPid
                end
        end,
    case RootPid of
        error ->
            {error,lists:concat([Process," is not process reg name in the ", node()])};
        _ ->
            AllPidList = get_process_all_pid(RootPid,Layer),
            RsList = get_process_info_detail(NeedModule, AllPidList,[]),
            Len = erlang:length(RsList),
            FilterRsList = 
                case OrderKey of 
                    msglen ->
                        lists:filter(fun({_,_,_,Qlen,_}) -> Qlen >= MinMsgLen end, RsList);
                    memory ->
                        lists:filter(fun({_,_,Qmem,_,_}) -> Qmem >= MinMemSize end, RsList);
                    _ ->
                        lists:filter(fun({_,_,_,Qlen,_}) -> Qlen >= MinMsgLen end, RsList)
                end,
            RsList2 = 
                case OrderKey of
                    msglen ->
                        lists:sort(fun({_,_,_,MsgLen1,_},{_,_,_,MsgLen2,_}) -> MsgLen1 > MsgLen2 end, FilterRsList);
                    memory ->
                        lists:sort(fun({_,_,MemSize1,_,_},{_,_,MemSize2,_,_}) -> MemSize1 > MemSize2 end, FilterRsList);
                    _ ->
                        lists:sort(fun({_,_,_,MsgLen1,_},{_,_,_,MsgLen2,_}) -> MsgLen1 > MsgLen2 end, FilterRsList)
                end,
            NewRsList = 
                if Top =:= 0 ->
                        RsList2;
                   true ->
                        if erlang:length(RsList2) > Top ->
                                lists:sublist(RsList2, Top);
                           true ->
                                RsList2
                        end
                end,
            {ok,NewRsList, Len}
    end.

%% --------------------------------------------------------------------
%% Func: get_process_info_detail/3
%% Purpose: get pid detail info
%% Returns: [{Pid,RegName,MemSize,MessageLength,Module},...]
%% --------------------------------------------------------------------
get_process_info_detail(_NeedModule, [], Result) -> Result;
get_process_info_detail(NeedModule, [H|T], Result) ->
    Mql = get_process_data({message_queue_len, H}),
    MemSize = get_process_data({memory, H}),
    RegName = get_process_data({registered_name, H}),
    case NeedModule of
        [] ->
            Module =get_process_info_initial_call(H),
            %% 			io:format("~p process RegName:~p,Mql:~p,MemSize:~p,Module:~p\n",[H, RegName, Mql, MemSize, Module]),
            get_process_info_detail(NeedModule, T, lists:append(Result, [{H,RegName,MemSize,Mql,Module}]));
        _ ->
            case get_process_info_check_initial_call(NeedModule, H) of
                "" ->
                    get_process_info_detail(NeedModule, T, Result);
                Module ->
                    %% io:format("~p process RegName:~p,Mql:~p,MemSize:~p\n",[H, RegName, Mql, MemSize]),
                    get_process_info_detail(NeedModule, T, lists:append(Result, [{H,RegName,MemSize,Mql,Module}]))

            end
    end.

%% --------------------------------------------------------------------
%% Func: get_process_info_check_initial_call/2
%% Purpose: check inital call
%% Returns: true or false
%% --------------------------------------------------------------------
get_process_info_check_initial_call(NeedModule, Pid) ->
    DictionaryList = get_process_data({dictionary, Pid}),
    %% 	io:format("Dictionary List:~p\n",[DictionaryList]),
    case proplists:lookup('$initial_call', DictionaryList) of
        {'$initial_call',{Module, _, _}} ->
            %% 			io:format("~p found initial_call Module=~p\n",[Pid,Module]),
            case lists:member(Module, NeedModule) of
                true ->
                    Module;
                _ ->
                    ""
            end;
        _ ->
            ""
    end.

%% --------------------------------------------------------------------
%% Func: get_process_info_initial_call/1
%% Purpose: get initial call
%% Returns: true or false
%% --------------------------------------------------------------------
get_process_info_initial_call(Pid) ->
    DictionaryList = get_process_data({dictionary, Pid}),
    %% 	io:format("Dictionary List:~p\n",[DictionaryList]),
    case proplists:lookup('$initial_call', DictionaryList) of
        {'$initial_call',{Module, _, _}} ->
            Module;
        _ ->
            ""
    end.

%% --------------------------------------------------------------------
%% Func: get_process_all_pid/1
%% Purpose: get pid and child pid, Layer 0 all 1 fisrt
%% Returns: [Pid,...]
%% --------------------------------------------------------------------
get_process_all_pid(RootPid, Layer) -> 
    ParentPid =get_process_parent_pid(RootPid),
    RootLinkPidList = get_process_data({links, RootPid}),
    %% 	io:format("~p links process links~p,and parent pid is~p\n",[RootPid, RootLinkPidList, ParentPid]),
    case RootLinkPidList of
        [] ->
            [RootPid];
        _ ->
            if erlang:length(RootLinkPidList) =:= 1 ->
                    [RootPid];
               true ->
                    NewLinkPidList = 
                        if erlang:is_pid(ParentPid) ->
                                lists:delete(ParentPid, RootLinkPidList);
                           true ->
                                RootLinkPidList
                        end,
                    LinkPidList = lists:delete(RootPid, NewLinkPidList),

                    %% 				io:format("~p do handle links process links~p\n",[RootPid,LinkPidList]),
                    if  Layer =:= 1 ->
                            [RootPid];
                        true ->
                            get_process_all_pid(LinkPidList, Layer, [RootPid], 2)
                    end
            end
    end.

get_process_all_pid([], _Layer, ResultList, _Index) -> ResultList;
get_process_all_pid([H|T], Layer, ResultList, Index) -> 
    %% 	io:format("get process all pid Index=~p", [Index]),
    if erlang:is_pid(H) ->
            ParentPid =get_process_parent_pid(H),
            RootLinkPidList = get_process_data({links, H}),
            %% 			io:format("~p links process links~p,and parent pid is~p\n",[H, RootLinkPidList, ParentPid]),
            case RootLinkPidList of
                [] ->
                    get_process_all_pid(T, Layer, lists:append(ResultList, [H]), Index);
                _ ->
                    if erlang:length(RootLinkPidList) =:= 1 ->
                            get_process_all_pid(T, Layer, lists:append(ResultList, [H]), Index);
                       true ->
                            NewLinkPidList =
                                if erlang:is_pid(ParentPid) ->
                                        lists:delete(ParentPid, RootLinkPidList);
                                   true ->
                                        RootLinkPidList
                                end,
                            LinkPidList = lists:delete(H, NewLinkPidList),
                            NewIndex = Index + 1,
                            SubResultList =
                                if NewIndex > Layer, Layer =/= 0 ->
                                        [H];
                                   true ->
                                        get_process_all_pid(LinkPidList, Layer, [H], NewIndex)
                                end,
                            get_process_all_pid(T, Layer, lists:append(ResultList, SubResultList), Index)
                    end
            end;
       true ->
            get_process_all_pid(T, Layer, ResultList, Index)
    end.

%% --------------------------------------------------------------------
%% Func: get_process_parent_pid/1
%% Purpose: get the pid parent pid
%% Returns: Pid or ignore
%% --------------------------------------------------------------------
get_process_parent_pid(Pid) ->
    DictionaryList = get_process_data({dictionary, Pid}),
    %% 	io:format("Dictionary List:~p\n",[DictionaryList]),
    case proplists:lookup('$ancestors', DictionaryList) of
        {'$ancestors',[ParentPid|_]} ->
            %% 			io:format("~p found parent pid is ~p\n",[Pid,ParentPid]),
            if erlang:is_pid(ParentPid) ->
                    ParentPid;
               true ->
                    whereis_name({local, ParentPid})
            end;
        _ ->
            ignore
    end.
%% --------------------------------------------------------------------
%% Func: get_process_data/1
%% Purpose: get the dictionary info of the process
%% Returns: [] or DictionaryList
%% --------------------------------------------------------------------
get_process_data({dictionary, Pid}) ->
    try erlang:process_info(Pid, dictionary) of
        {_, DList} -> DList;
        _ -> []
    catch 
        _:_ -> []
    end;
%% --------------------------------------------------------------------
%% Func: get_process_data/1
%% Purpose: get the links info of the process
%% Returns: [] or LinksList
%% --------------------------------------------------------------------
get_process_data({links, Pid}) ->
    try erlang:process_info(Pid,links) of
        {_, Links} -> lists:filter(fun(I) -> erlang:is_pid(I) end, Links);
        _ -> []
    catch 
        _:_ -> []
    end;
%% --------------------------------------------------------------------
%% Func: get_process_data/1
%% Purpose: get the message queue length info of the process
%% Returns: 0 or Length
%% --------------------------------------------------------------------
get_process_data({message_queue_len, Pid}) ->
    try erlang:process_info(Pid, message_queue_len) of
        {message_queue_len, Length} -> Length;
        _ -> 0
    catch 
        _:_ -> 0
    end;

%% --------------------------------------------------------------------
%% Func: get_process_data/1
%% Purpose: get the memory size info of the process
%% Returns: 0 or MemorySize
%% --------------------------------------------------------------------
get_process_data({memory, Pid}) ->
    try erlang:process_info(Pid, memory) of
        {memory, Size} -> Size;
        _ -> 0
    catch 
        _:_ -> 0
    end;

%% --------------------------------------------------------------------
%% Func: get_process_data/1
%% Purpose: get the registered name info of the process
%% Returns: "" or RegisteredName
%% --------------------------------------------------------------------
get_process_data({registered_name, Pid}) ->
    try erlang:process_info(Pid, registered_name) of
        {registered_name, RegName} -> RegName;
        _ ->
            ""
    catch 
        _:_ ->
            ""
    end.
%% --------------------------------------------------------------------
%% Func: get_online_role_count/1
%% Purpose: get online role count
%% Returns: {0,0} or {SpecsCount,ActiveCount}
%% --------------------------------------------------------------------
%% get_online_role_count(AccountList) ->
%% 	case AccountList of
%% 		AccAtom when is_atom(AccAtom) ->
%% 			get_online_role_count([AccAtom], 0, 0);
%% 		AccList when is_list(AccList) ->
%% 			get_online_role_count(AccList, 0, 0)
%% 	end.
%% 
%% get_online_role_count([], Count, ActiveCount) ->{Count,ActiveCount};
%% get_online_role_count(Ports, Count, ActiveCount) ->
%% 	[AccountSupName|T] = Ports,
%% 	{SNum,ANum} = get_online_role_count_item(AccountSupName),
%% 	get_online_role_count(T, Count + SNum, ActiveCount + ANum).
%% 
%% get_online_role_count_item(SupName) ->
%% 	try supervisor:count_children(SupName) of
%% 		[] -> {0,0};
%% 		SupList when erlang:is_list(SupList) ->
%% %% 			io:format("SupList ~p ~n", [SupList]),
%% 			SCount = 
%% 			case proplists:lookup(specs, SupList) of
%% 				{specs, SNum} -> SNum;
%% 				_ -> 0
%% 			end,
%% 			ACount = 
%% 			case proplists:lookup(active, SupList) of
%% 				{active, ANum} -> ANum;
%% 				_ -> 0
%% 			end,
%% 			{SCount,ACount};
%% 		_ -> {0,0}
%% 	catch 
%% 		_:_ -> {0,0}
%% 	end.

%% --------------------------------------------------------------------
%% Func: replace_all/4
%% Purpose: Subject,RE,Replacement,Options
%% Returns: List
%% --------------------------------------------------------------------
replace_all(Subject,RE,Replacement,Options) ->
    ReSubject = re:replace(Subject, RE, Replacement, Options),
    case ReSubject =:= Subject of
        false ->
            replace_all(ReSubject,RE,Replacement,Options);
        _ ->
            ReSubject
    end.

pg2_get_members(Pg2_name) ->
    L = case pg2:get_members(Pg2_name) of 
            {error, _} ->
                timer:sleep(100),
                pg2:get_members(Pg2_name);
            Other when is_list(Other) ->
                Other
        end,
    if
        not is_list(L) ->
            [];
        true ->
            lists:usort(L)
    end.

%% get_http_content(Url) ->
%%     case httpc:request(Url) of
%%         {ok, {_Status, _Headers, Raw}} ->
%%             Raw;
%%         {error, _Reason} ->
%%             ""
%%     end.

write_system_info(Pid, Module, Args) ->
    ets:insert(ets_system_info, {Pid, Module, Args}).

delete_system_info(Pid) ->
    ets:delete(ets_system_info, Pid).	

write_monitor_pid(Pid, Module, Args) ->
    ets:insert(ets_system_info, {Pid, Module, Args}).

delete_monitor_pid(Pid) ->
    ets:delete(ets_system_info, Pid).

%% @doc get IP address string from Socket
ip(Socket) ->
    {ok, {IP, _Port}} = inet:peername(Socket),
    {Ip0,Ip1,Ip2,Ip3} = IP,
    list_to_binary(
      integer_to_list(Ip0) ++ "." ++
          integer_to_list(Ip1) ++ "." ++
          integer_to_list(Ip2) ++ "." ++
          integer_to_list(Ip3)).

%% @doc convert float to string,  f2s(1.5678) -> 1.57
f2s(N) when is_integer(N) ->
    integer_to_list(N) ++ ".00";
f2s(F) when is_float(F) ->
    [A] = io_lib:format("~.2f", [F]),
    A.

%% @doc convert other type to atom
to_atom(Msg) when is_atom(Msg) -> 
    Msg;
to_atom(Msg) when is_binary(Msg) -> 
    list_to_atom2(binary_to_list(Msg));
to_atom(Msg) when is_list(Msg) -> 
    list_to_atom2(Msg);
to_atom(_) -> 
    throw(other_value).  %%list_to_atom("").

%% @doc convert other type to list
to_list(X) when is_integer(X) -> 
    integer_to_list(X);
to_list(X) when is_float(X) -> 
    float_to_list(X);
to_list(X) when is_atom(X) ->
    atom_to_list(X);
to_list(X) when is_binary(X) ->
    binary_to_list(X);
to_list(X) when is_list(X) ->
    X;
to_list(_) ->
    throw(other_value).

%% @doc convert other type to binary
to_binary(Msg) when is_binary(Msg) -> 
    Msg;
to_binary(Msg) when is_atom(Msg) ->
    list_to_binary(atom_to_list(Msg));
%%atom_to_binary(Msg, utf8);
to_binary(Msg) when is_list(Msg) -> 
    %% Bin = ,
    case unicode:characters_to_binary(Msg, latin1, latin1) of
        Bin 
          when is_binary(Bin) ->
            list_to_binary(Msg);
        _ ->
            unicode:characters_to_binary(Msg, unicode, unicode)
    end;
to_binary(Msg) when is_integer(Msg) -> 
    list_to_binary(integer_to_list(Msg));
to_binary(Msg) when is_float(Msg) -> 
    list_to_binary(f2s(Msg));
to_binary(_Msg) ->
    throw(other_value).

%% @doc convert other type to float
to_float(Msg)->
    Msg2 = to_list(Msg),
    list_to_float(Msg2).

%% @doc convert other type to integer
-spec to_integer(Msg :: any()) -> integer().
to_integer(undefined) ->
    ?WARNING_MSG("type error undefined~n", []),
    0;
to_integer(true) ->
    1;
to_integer(false) ->
    0;
to_integer(Msg) when is_integer(Msg) -> 
    Msg;
to_integer(Msg) when is_binary(Msg) ->
    Msg2 = binary_to_list(Msg),
    list_to_integer(Msg2);
to_integer(Msg) when is_list(Msg) -> 
    list_to_integer(Msg);
to_integer(Msg) when is_float(Msg) -> 
    round(Msg);
to_integer(_Msg) ->
    ?WARNING_MSG("type error: ~p~n", [_Msg]),
    throw(other_value).

to_bool(D) when is_integer(D) ->
    D =/= 0;
to_bool(D) when is_list(D) ->
    length(D) =/= 0;
to_bool(D) when is_binary(D) ->
    to_bool(binary_to_list(D));
to_bool(D) when is_boolean(D) ->
    D;
to_bool(_D) ->
    throw(other_value).

%% @doc convert other type to tuple
to_tuple(T) when is_tuple(T) -> T;
to_tuple(T) -> {T}.

%% @spec is_string(List)-> yes|no|unicode  
is_string([]) ->
    yes;
is_string(List) ->
    is_string(List, non_unicode).
is_string([C|Rest], non_unicode)
  when C >= 0, C =< 255 ->
    is_string(Rest, non_unicode);
is_string([C|Rest], _)
  when C =< 65000 ->
    is_string(Rest, unicode);
is_string([], non_unicode) ->
    yes;
is_string([], unicode) ->
    unicode;
is_string(_, _) ->
    no.

%% @doc get a random integer between Min and Max
random(Min, Max)->
    Min2 = Min - 1,
    random:uniform(Max - Min2) + Min2.

%% @doc get random list
list_random(List)->
    case List of
        [] ->
            {};
        _ ->
            RS = lists:nth(random:uniform(length(List)), List),
            ListTail = lists:delete(RS, List),
            {RS, ListTail}
    end.

%% @doc 掷骰子
%% random_dice(Face,Times)->
%%     if
%%         Times == 1 ->
%%             random(1, Face);
%%         true ->
%%             lists:sum(for(1,Times, fun(_)-> random(1,Face) end))
%%     end.

%% @doc 机率
odds(Numerator, Denominator)->
    Odds = random:uniform(Denominator),
    if
        Odds =< Numerator -> 
            true;
        true ->
            false
    end.

odds_list(List)->
    Sum = odds_list_sum(List),
    odds_list(List,Sum).

odds_list([{Id,Odds} | List], Sum)->
    case odds(Odds,Sum) of
        true ->
            Id;
        false ->
            odds_list(List,Sum-Odds)
    end.

odds_list_sum(List)->
    {_List1, List2} = lists:unzip(List),
    lists:sum(List2).

add_in_max(Old, Delta, Max) ->
    if
        Old >= Max ->
            Old;
        true ->
            if
                Old + Delta >= Max ->
                    Max;
                true ->
                    Old + Delta
            end
    end.

%% @doc 取整 大于X的最小整数
ceil(X) ->
    T = trunc(X),
    if 
        X - T == 0 ->
            T;
        true ->
            if
                X > 0 ->
                    T + 1;
                true ->
                    T
            end			
    end.


%% @doc 取整 小于X的最大整数
floor(X) ->
    T = trunc(X),
    if 
        X - T == 0 ->
            T;
        true ->
            if
                X > 0 ->
                    T;
                true ->
                    T-1
            end
    end.
%% 4舍5入
%% round(X)

%% subatom
subatom(Atom,Len)->	
    list_to_atom(lists:sublist(atom_to_list(Atom),Len)).

%% @doc 暂停多少毫秒
sleep(Msec) ->
    receive
    after Msec ->
            true
    end.

%% @doc md5 string
%% @spec
%% @end
md5(S) ->        
    Md5_bin =  erlang:md5(S), 
    Md5_list = binary_to_list(Md5_bin), 
    lists:flatten(list_to_hex(Md5_list)). 

check_md5_sign(ValueList, Sign) 
  when is_list(ValueList) ->
    NewList = lists:concat(ValueList),
    md5(NewList) =:= Sign.
    
list_to_hex(L) -> 
    lists:map(fun(X) -> int_to_hex(X) end, L). 

int_to_hex(N) when N < 256 -> 
    [hex(N div 16), hex(N rem 16)]. 

hex(N) when N < 10 -> 
    $0 + N; 
hex(N) when N >= 10, N < 16 ->      
    $a + (N - 10).

list_to_atom2(List) when is_list(List) ->
    case catch(list_to_existing_atom(List)) of
        {'EXIT', _} ->
            erlang:list_to_atom(List);
        Atom
          when is_atom(Atom) ->
            Atom
    end.

combine_lists(L1, L2) ->
    Rtn = 
	lists:foldl(
          fun(T, Acc) ->
                  case lists:member(T, Acc) of
                      true ->
                          Acc;
                      false ->
                          [T|Acc]
                  end
          end, lists:reverse(L1), L2),
    lists:reverse(Rtn).


get_process_info_and_zero_value(InfoName) ->
    PList = erlang:processes(),
    ZList = lists:filter( 
              fun(T) -> 
                      case erlang:process_info(T, InfoName) of 
                          {InfoName, 0} -> false; 
                          _ -> true 	
                      end
              end, PList ),
    ZZList = lists:map( 
               fun(T) -> {T, erlang:process_info(T, InfoName), erlang:process_info(T, registered_name)} 
               end, ZList ),
    [ length(PList), InfoName, length(ZZList), ZZList ].

get_process_info_and_large_than_value(InfoName, Value) ->
    PList = erlang:processes(),
    ZList = lists:filter( 
              fun(T) -> 
                      case erlang:process_info(T, InfoName) of 
                          {InfoName, VV} -> 
                              if VV >  Value -> true;
                                 true -> false
                              end;
                          _ -> true 	
                      end
              end, PList ),
    ZZList = lists:map( 
               fun(T) -> {T, erlang:process_info(T, InfoName), erlang:process_info(T, registered_name)} 
               end, ZList ),
    [ length(PList), InfoName, Value, length(ZZList), ZZList ].

get_msg_queue() ->
    io:fwrite("process count:~p~n~p value is not 0 count:~p~nLists:~p~n", 
              get_process_info_and_zero_value(message_queue_len)).

get_memory() ->
    io:fwrite(
      "process count:~p~n~p value is large than ~p count:~p~nLists:~p~n", 
      get_process_info_and_large_than_value(memory, 1048576)).

get_memory(Value) ->
    io:fwrite(
      "process count:~p~n~p value is large than ~p count:~p~nLists:~p~n", 
      get_process_info_and_large_than_value(memory, Value)).

get_heap() ->
    io:fwrite(
      "process count:~p~n~p value is large than ~p count:~p~nLists:~p~n", 
      get_process_info_and_large_than_value(heap_size, 1048576)).

get_heap(Value) ->
    io:fwrite(
      "process count:~p~n~p value is large than ~p count:~p~nLists:~p~n", 
      get_process_info_and_large_than_value(heap_size, Value) ).

get_processes() ->
    io:fwrite(
      "process count:~p~n~p value is large than ~p count:~p~nLists:~p~n",
      get_process_info_and_large_than_value(memory, 0) ).


list_to_term(String) ->
    {ok, T, _} = erl_scan:string(String++"."),
    case erl_parse:parse_term(T) of
        {ok, Term} ->
            Term;
        {error, Error} ->
            Error
    end.


substr_utf8(Utf8EncodedString, Length) ->
    substr_utf8(Utf8EncodedString, 1, Length).
substr_utf8(Utf8EncodedString, Start, Length) ->
    ByteLength = 2*Length,
    Ucs = xmerl_ucs:from_utf8(Utf8EncodedString),
    Utf16Bytes = xmerl_ucs:to_utf16be(Ucs),
    SubStringUtf16 = lists:sublist(Utf16Bytes, Start, ByteLength),
    Ucs1 = xmerl_ucs:from_utf16be(SubStringUtf16),
    xmerl_ucs:to_utf8(Ucs1).

ip_str(IP) ->
    case IP of
        {A, B, C, D} ->
            lists:concat([A, ".", B, ".", C, ".", D]);
        {A, B, C, D, E, F, G, H} ->
            lists:concat([A, ":", B, ":", C, ":", D, ":", E, ":", F, ":", G, ":", H]);
        Str when is_list(Str) ->
            Str;
        _ ->
            []
    end.

%% 去掉字符串空格
remove_string_blank(L) ->
    F = fun(S) ->
                if S == 32 -> [];
                   true -> S
                end
        end,
    Result = [F(lists:nth(I,L)) || I <- lists:seq(1,length(L))],
    lists:filter(fun(T) -> T =/= [] end,Result).

%% 汉字unicode编码范围 0x4e00 - 0x9fa5
-define(UNICODE_CHINESE_BEGIN, (4*16*16*16 + 14*16*16)).
-define(UNICODE_CHINESE_END,   (9*16*16*16 + 15*16*16 + 10*16 + 5)).

%% atomize a string
atomize(Para)
  when is_binary(Para) ->
    atomize(to_list(Para));
atomize(Para) when is_list(Para) ->
    list_to_atom(string:to_lower(Para)).

apply_string(RawData) ->
    {M, F, A} = inner_split_out_mfa(RawData),
    apply(M, F, A).

inner_split_out_mfa(MFA) ->
    {match, [M, F, A]} = 
        re:run(MFA, "(.*):(.*)\\((.*)\\)$",
               [{capture, [1, 2, 3], list}, ungreedy]),
    {list_to_atom(M), list_to_atom(F), inner_args_to_terms(A)}.
inner_args_to_terms(RawArgs) ->
    {ok, Toks, _Line} = erl_scan:string("[" ++ RawArgs ++ "]. ", 1),
    {ok, Args} = erl_parse:parse_term(Toks),
    Args.

%% 在List中的每两个元素之间插入一个分隔符
implode(_S, [H])->
    [to_list(H)];
implode(S, [H|T]) ->
    [to_list(H), S|implode(S, T)].
%% %    implode(S, L, []).
%% implode(_S, [H], NList) ->
%%     lists:reverse([to_list(H) | NList]);
%% implode(S, [H | T], NList) ->
%%     L = [to_list(H) | NList],
%%     implode(S, T, [S | L]).


    

%% 字符->列
explode(S, B)->
    re:split(B, S, [{return, list}]).
explode(S, B, int) ->
    [list_to_integer(Str) || Str <- explode(S, B), Str =/= []].


%% 日志记录函数
log(T, F, A, Mod, Line) ->
    {ok, Fl} = file:open("logs/error_log.txt", [write, append]),
    Format = list_to_binary("#" ++ T ++" ~s[~w:~w] " ++ F ++ "\r\n~n"),
    {{Y, M, D},{H, I, S}} = erlang:localtime(),
    Date = list_to_binary(
             [integer_to_list(Y),"-", integer_to_list(M), "-", 
              integer_to_list(D), " ", integer_to_list(H), ":", 
              integer_to_list(I), ":", integer_to_list(S)]),
    io:format(
      Fl, unicode:characters_to_list(Format), [Date, Mod, Line] ++ A),
    file:close(Fl).    


%% 转换成HEX格式的md5
%% md5(S) ->
%%     lists:flatten(
%%       [io_lib:format("~2.16.0b", [N]) || N <- binary_to_list(erlang:md5(S))]).

hmac_sha1(Key, S) ->
    lists:flatten(
      [io_lib:format("~2.16.0b", [N]) 
       || N <- binary_to_list(crypto:sha_mac(Key, S))]).

%% 随机选择list中的一个元素
rand([]) ->
    [];
rand([{_, _} | _] = List) ->
    rand(List, full);
rand([[_, _] | _] = List) ->
    rand(List, full);
rand(Tuple)
  when is_tuple(Tuple) ->
    element(rand(1, tuple_size(Tuple)), Tuple);
rand(List)
  when is_list(List) ->
    %% 先随机获取一个位置，然后返回对一个的元素
    rand(list_to_tuple(List));
    %%lists:nth(rand(1, length(List)), List);
rand(_) ->
    0.

rand_same(_, _, 0, L) ->
    L;
rand_same(Min, Max, Num, List) ->
    Key = rand(Min, Max),
    case lists:keytake(Key, 1, List) of
        false ->
            rand_same(Min, Max, Num-1, [{Key, 1} | List]);
        {value, Tuple, Reset} ->
            rand_same(Min, Max, Num-1, [{Key, element(2, Tuple)+1} | Reset])
    end.

%% list中随机 num 个数据(可相同)
rand_same(List, Num)
  when is_integer(Num) andalso is_list(List) ->
    Tuple = list_to_tuple(List),
    Size = tuple_size(Tuple),
    Ns = rand_same(1, Size, Num, []),
    [{element(Index, Tuple), N} || {Index, N} <- Ns].

rand([{_, _} | _] = List, full) ->
    FullPower = 
        lists:foldl(
          fun({_IKey, IPower}, OldPower) ->
                  %% 叠加权重处理
                  OldPower + IPower
          end, 0, List),
    rand(List, FullPower);
rand([[_, _] | _] = List, full) ->
    {NewList, FullPower} = 
        lists:foldl(
          fun([IKey, IPower], {Acc, OldPower}) ->
                  %% 叠加权重处理
                  {[{IKey, IPower}|Acc], OldPower + IPower}
          end, {[], 0}, List),
    rand(NewList, FullPower);
rand([{_, _} | _] = List, Base) ->
    Rand = rand(1, Base),
    %% 过滤掉小于随机值的数据
    inner_select(Rand, 0, List);
%% 产生一个介于Min到Max之间的随机整数
%% rand(1, Max-Min+1) + (Min-1)
%% 随机数+偏移量
rand(Min, Max) 
  when Min =< Max->
    %% 如果没有种子，将从核心服务器中去获取一个种子，以保证不同进程都可取得不同的种子
    RandSeed = case get(hmisc_rand_seed) of
                   undefined ->
                       hmod_rand:get_seed();
                   TmpRandSeed ->
                       TmpRandSeed
               end,
    {F, NewRandSeed} =  random:uniform_s(Max - (Min - 1), RandSeed),
    put(hmisc_rand_seed, NewRandSeed),
    F + (Min - 1).

%% 根据权重选取 n 个目标
inner_rand_n_helper(Number, _, SelectedList)
  when Number =< 0 ->
    SelectedList;
inner_rand_n_helper(Number, RandomList, SelectedList) ->
    Target = rand(RandomList),
    inner_rand_n_helper(Number - 1, 
                        lists:filter(fun({Tar, _Power}) ->
                                        if
                                            Tar =/= Target ->
                                                true;
                                            true -> 
                                                false
                                        end
                                     end, RandomList),
                        [Target | SelectedList]).

%% 根据权重选取指定的 N 个目标对象(不重复)
rand_n_p(Number, [{_, _} | _Tail] = RandomList) ->
    %% 从一个候选列表中根据权重选取指定数量的后备
    if
        length(RandomList) =< Number ->
            %% 候选列表不足，返回所有的数据
            lists:map(fun({Tar, _Power}) ->
                              Tar
                      end, RandomList);
        true -> 
            %% 选取指定数量的
            inner_rand_n_helper(Number, RandomList, [])
    end.

%% 根据权重选取 n 个目标
inner_rand_n_helper_r(Number, _, _, SelectedList)
  when Number =< 0 ->
    SelectedList;
inner_rand_n_helper_r(Number, RandomList, Base, SelectedList) ->
    Target = rand(RandomList, Base),
    inner_rand_n_helper_r(Number - 1, RandomList, Base, [Target | SelectedList]).

%% 根据权重选取指定的 N 个目标对象(可重复)
rand_n_p_r(Number, [{_, _} | _Tail] = RandomList) ->
    %% 从一个候选列表中根据权重选取指定数量的后备
    if
        length(RandomList) =< Number ->
            %% 候选列表不足，返回所有的数据
            lists:map(fun({Tar, _Power}) ->
                              Tar
                      end, RandomList);
        true -> 
            Base = lists:foldl(fun({_, N}, B) ->
                                       B+N
                               end, 0, RandomList),
            %% 选取指定数量的
            inner_rand_n_helper_r(Number, RandomList, Base, [])
    end.

%% List 中选取 N 个不同的对象
rand_n(N, List) when is_list(List) ->
    %% Len = length(List),
    %% Ns = rand_n(N, 1, Len),
    %% [lists:nth(Index, List) || Index <- Ns];
    rand_n(N, list_to_tuple(List));
rand_n(N, Tuple) when is_tuple(Tuple) ->
    Len = tuple_size(Tuple),
    Ns = rand_n1(N, 1, Len),
    [element(Index, Tuple) || Index <- Ns].


%% 从[min , max] 中取出 N个数，不重复
rand_n1(Count, Min, Max) 
  when (Max - Min)+1 > Count->
    rand_n2(Count, Min, Max, []);
rand_n1(_Count, Min, Max) ->
    shuffle(lists:seq(Min, Max)).
	
rand_n2(0, _Min, _Max, List) ->
	List;
rand_n2(Count, Min, Max, List) ->
    Num = rand(Min, Max),
    case lists:member(Num, List) of
        false->
            rand_n2(Count - 1, Min, Max, [Num|List]);
        true ->
            rand_n2(Count, Min, Max, List)
    end.

shuffle(L) ->
    List1 = [{rand(1, 10000000), X} || X <- L], 
    List2 = lists:keysort(1, List1), 
    [E || {_, E} <- List2]. 

%% ------------------------------------------------------

%% 过滤掉 0 数据
filter_zero(Num) ->
    if
        Num =:= 0 ->
            undefined;
        true -> 
            Num
    end.

%% 随机从集合中选出指定个数的元素length(List) >= Num
%% [1,2,3,4,5,6,7,8,9]中选出三个不同的数字[1,2,4]
get_random_list(List, Num) ->
    ListSize = length(List),
    F = fun(N, List1) ->
                Random = rand(1,(ListSize-N+1)),
                Elem = lists:nth(Random, List1),
                List2 = lists:delete(Elem, List1),
                List2
        end,
    Result = lists:foldl(F, List, lists:seq(1, Num)),
    List -- Result.

%% %% @doc 根据职业获取性别，仅限于主角
%% get_sex_by_career(Career) ->
%%     case Career of
%%         ?CAPTAIN_POWER_HONOR ->
%%             ?MALE;
%%         ?CAPTAIN_SWORDS_MAN ->
%%             ?FEMALE;
%%         ?CAPTAIN_MAGICIAN ->
%%             ?MALE;
%%         ?CAPTAIN_DANCER ->
%%             ?FEMALE;
%%         ?CAPTAIN_FEATHER_SHINE ->
%%             ?MALE;
%%         ?CAPTAIN_TIAN_YU ->
%%             ?FEMALE;
%%         _ ->
%%             ?MALE
%%     end.

sleep(T, F) ->
    receive
    after T -> F()
    end.

get_list([], _) ->
    [];
get_list(X, F) ->
    F(X).

%% 取列表Ele后面的元素
ele_tail(_Ele, []) ->
    [];
ele_tail(Ele, [Ele|T]) ->
    T;
ele_tail(Ele, [_|T]) ->
    ele_tail(Ele, T).

to_string(Integer) when is_integer(Integer) ->
    lists:flatten(io_lib:format("~p", [Integer]));
to_string(Other) ->
    Other.

%% term序列化，term转换为string格式，e.g., [{a},1] => "[{a},1]"
term_to_string(Term) ->
    binary_to_list(list_to_binary(io_lib:format("~p", [Term]))).

%% term序列化，term转换为bitstring格式，e.g., [{a},1] => <<"[{a},1]">>
term_to_bitstring(Term) ->
    erlang:list_to_bitstring(io_lib:format("~p", [Term])).

%% term反序列化，string转换为term，e.g., "[{a},1]"  => [{a},1]
string_to_term(String) ->
    case erl_scan:string(String++".") of
        {ok, Tokens, _} ->
            case erl_parse:parse_term(Tokens) of
                {ok, Term} -> Term;
                _Err -> undefined
            end;
        _Error ->
            undefined
    end.

%% 将列表转换为string [a,b,c] -> "a,b,c"
list_to_string(List) ->
    case List == [] orelse List == "" of
        true -> "";
        false ->
            F = fun(E) ->
                        to_list(E)++","
                end,
            L1 = [F(E)||E <- List] ,
            L2 = lists:concat(L1),
            string:substr(L2,1,length(L2)-1)
    end.

%% term反序列化，bitstring转换为term，e.g., <<"[{a},1]">>  => [{a},1]
bitstring_to_term(undefined) -> 
    undefined;
bitstring_to_term(BitString) ->
    string_to_term(binary_to_list(BitString)).

%% 对list进行去重，排序
%% Replicat 0不去重，1去重
%% Sort 0不排序，1排序
filter_list(List, 1, 1) ->
    %% 排序且去重复
    lists:usort(List);
filter_list(List, 1, 0) ->
    %% 排序
    lists:sort(List);
filter_list(List, 0, 1) ->
    %% 去重复
    lists:reverse(filter_replicat(List, []));
filter_list(List, _, _) ->
    %% 什么都不处理
    List.

%% list去重
filter_replicat([], List) ->
	List;
filter_replicat([H|Rest], List) ->
    List1 =
	case lists:member(H, List) of
            true ->
                [[] | List];
            false ->
                [H | List]
	end,
    List2 = lists:filter(fun(T) ->
                                 T =/= []
                         end, List1),
    filter_replicat(Rest, List2).

%% ------------------------------------------------------
%% desc   获取字符串汉字和非汉字的个数  
%% parm   UTF8String  			UTF8编码的字符串
%% return {汉字个数,非汉字个数}
%% -------------------------------------------------------
get_chinese_count(UTF8String)->
    UnicodeList = unicode:characters_to_list(list_to_binary(UTF8String)),
    Fun = fun(Num,{Sum})->
                  case Num >= ?UNICODE_CHINESE_BEGIN andalso
                      Num =< ?UNICODE_CHINESE_END of
                      true ->
                          {Sum + 1};
                      false ->
                          {Sum}
                  end
          end,
    {ChineseCount} = lists:foldl(Fun, {0}, UnicodeList),
    OtherCount = length(UnicodeList) - ChineseCount,
    {ChineseCount,OtherCount}.

%% 与lists:nth一样，不过多了0判断和N>length(List)情况的判断
lists_nth(0, _) ->
    [];
lists_nth(1, [H|_]) ->
    H;
lists_nth(_, []) ->
    [];
lists_nth(N, [_|T]) 
  when N > 1 ->
    lists_nth(N - 1, T).

%% 替换列表第n个元素
lists_nth_replace(N, L, V) ->
    lists_nth_replace(N, L, V, []).
lists_nth_replace(0, L, _V, _OH) ->
    L;
lists_nth_replace(1, [_H|T], V, OH) ->
    recover(OH, [V|T]);
lists_nth_replace(_, [], _V, OH) ->
    recover(OH, []);
lists_nth_replace(N, [H|T], V, OH)
  when N > 1 ->
    lists_nth_replace(N - 1, T, V, [H|OH]).

recover([], Hold) ->Hold;
recover([H|T], Hold) ->
    recover(T, [H|Hold]).

%% 如果参数小于0，则取0
get_pos_num_min_0(Num) ->
    if
        Num < 0 ->
            0;
        true ->
            Num
    end.

%% 如果参数小于1，则取1
get_pos_num_min_1(Num) ->
	if Num < 1 ->
		   1;
	   true ->
		   Num
	end.

get_max_num(Num, Max) ->
    if
        Num > Max ->
            Max;
        true ->
            Num
    end.

compile_base_data(Table, ModName, IDPoses) ->
    ModNameString = term_to_string(ModName),
    HeadString = 
        "-module("++ModNameString++").
		-compile(export_all).
		",
    BaseDataList = db_base:select_all(Table, "*", []),
    ContentString = 
	lists:foldl(
          fun(BaseData0, PreString) ->
                  FunChange = 
                      fun(Field) ->
                              if
                                  is_integer(Field) ->
                                      Field; 
                                  true -> 
                                      case bitstring_to_term(Field) of
                                          undefined ->
                                              Field;
                                          Term ->
                                              Term
                                      end
                              end
                      end,
                  BaseData = [FunChange(Item)||Item <- BaseData0],
                  Base =list_to_tuple([Table|BaseData]),
                  BaseString = util:term_to_string(Base),
                  IDs = [element(Pos, Base)||Pos<-IDPoses],
                  IDList0 = 
                      lists:foldl(
                        fun(ID, PreString2)->
                                IdList = 
                                    if erlang:is_integer(ID) ->
                                            integer_to_list(ID);
                                       true ->
                                            ID
                                    end,
                                PreString2 ++ "," ++ IdList
                        end, [], IDs),
                  [_|IDList] = IDList0,
                  PreString ++ 
                      "get(" ++ 
                      IDList ++ 
                      ") ->" ++ 
                      BaseString ++
                      ";
						      "
          end
          , "", BaseDataList),

    _List0 = [",_"||_Pos<-IDPoses],
    [_|_List] = lists:flatten(_List0),
    ErrorString = "get("++_List++") -> undefined.
	",
	FinalString = HeadString++ContentString++ErrorString,
    %% io:format("string=~s~n",[FinalString]),
    try
        {Mod,Code} = hdynamic_compile:from_string(FinalString),
        code:load_binary(Mod, ModNameString++".erl", Code)
    catch
        Type:Error -> 
            ?ERROR_MSG("Error compiling (~p): ~p~n", [Type, Error])
    end,
    ok.

%% 注册函数
%% register_fun(Fun, Times, Key) ->
%%     case get({register_fun, Key}) of
%%         [_|_] = RegisteredFuns ->
%%             put({register_fun, Key}, [{Fun, Times}|RegisteredFuns]);
%%         _ ->
%%             put({register_fun, Key}, [{Fun, Times}])
%%     end.

%% 返回两个中较大的数
max(Arg1,Arg2) ->
    Res =  if
               Arg1 >= Arg2 -> 
                   Arg1;
               true -> 
                   Arg2
           end,
    Res.

%%从一列数组中找出最大值
max(NumList) ->
    lists:foldl(fun(Num,Max) ->
                       if
                           Num >= Max ->
                               Num;
                           true ->
                               Max
                       end
                end, 0, NumList).
                     
rand1000(Rate) ->
    R = rand(1,1000),
    if
        Rate > R-> 
            false;
        true -> 
            true
    end.

rand10000(Rate) ->
    R = rand(1, 10000),
    if
        Rate > R ->
            false;
        true ->
            true
    end.

%% @spec
%% sorted_scequence_minus([{1, Pid1}, {5, Pid2}, {7, Pid3}]) ->
%%                        [{0, Pid1}, {4, Pid2}, {6, Pid3}]
%% @end
sorted_scequence_minus([]) ->
    {0, []};
sorted_scequence_minus(List) ->
    SortedList = lists:sort(List),
    [{DelayToMinus, _Pid} | _Tail] = SortedList,
    MinusFunc = fun({Delay, Pid}) ->
                        {Delay - DelayToMinus, Pid}
                end,
    {DelayToMinus, lists:map(MinusFunc, SortedList)}.

%% @spec
%% list to record
%% @end
to_record(Record, RecordInfo) 
  when is_list(RecordInfo) ->
    list_to_tuple([Record | RecordInfo]).

%% @spec
%% 按照指定的格式打包指定的数据
%% @end
write_binary(bin, Value)
  when is_binary(Value) ->
    %% for: bin     value
    Value;
write_binary(bit, Value)
  when is_number(Value) ->
    %% for: bit     value
    <<Value:1>>;
write_binary(byte, Value)
  when is_number(Value) ->
    %% for: int:8   value
    <<Value:8>>;
write_binary(int8, Value)
  when is_number(Value) ->
    %% for: int:8   value
    <<Value:8>>;
write_binary(int16, Value)
  when is_number(Value) ->
    %% for: int:16  value
    <<Value:16>>;
write_binary(int32, Value)
  when is_number(Value) ->
    %% for: int:32  value
    <<Value:32>>;
write_binary(int64, Value)
  when is_number(Value) ->
    %% for: int:64  value
    <<Value:64>>;
write_binary(string, [Head | _Tail] = Value)
  when is_list(Value) andalso is_number(Head) ->
    %% for: string  value
    BinString = pt:write_string(Value),
    <<BinString/binary>>;
write_binary(Type, ValueList) 
  when is_atom(Type) andalso is_list(ValueList) ->
    %% for: int:16 repeated_time
    %%      array(
    %%          type value
    %%      )
    Length = length(ValueList),
    NewBinary = to_binary(lists:map(fun(Value) ->
                                            write_binary(Type, Value)
                                    end,
                                    ValueList)),
    <<Length:16, NewBinary/binary>>;
write_binary(TypeList, ValueTuple) 
  when is_list(TypeList) andalso is_tuple(ValueTuple) ->
    write_binary(TypeList, tuple_to_list(ValueTuple));
write_binary(TypeList, []) 
  when is_list(TypeList) ->
    %%TypeList不为空，value为空是，直接打包为空
    <<0:16>>;
write_binary(TypeList, [Head | _Tail] = ValueList) 
  when is_list(TypeList) andalso is_list(ValueList) andalso 
       not is_list(Head) andalso not is_tuple(Head) ->
    %% [type1, type2, ...], [value1, value2, ...]
    %% for: type1  value1
    %%      type2  value2
    %%      ...
    if
        length(TypeList) =:= length(ValueList) -> 
            %% 根据TypeList和ValueList匹配打包成二进制数据
            to_binary(lists:zipwith(fun(Type, Value) ->
                                            write_binary(Type, Value)
                                    end, TypeList, ValueList));
        true ->
            ?DEBUG("TypeList's length and ValueList's length not matched.~p", []),
            <<>>
    end;
write_binary(TypeList, [Head | _Tail] = ValueList) 
  when is_list(TypeList) andalso is_list(ValueList) andalso 
       (is_list(Head) orelse is_tuple(Head)) ->
    %% [type1, type2, ...], [[value1, value2, ...], 
    %%                       [value3, value4, ...], 
    %%                       ...]
    %% for: int:16   repeated_time
    %%      array(
    %%      type1    value1
    %%      type2    value2
    %%      ...
    %%      )
    Length = length(ValueList),
    NBinary = to_binary(lists:map(
                          fun(ValueListIn) ->
                                  write_binary(TypeList, ValueListIn)
                          end, ValueList)),
    <<Length:16, NBinary/binary>>.

%% @spec
%% 将数据列表写成二进制串
%% [{byte, Byte}, {int16, Int16} ... {string, String}] -> Binary.
%% @end
write_list_to_binary(ArgList) when is_list(ArgList) ->
    to_binary(lists:map(fun({Type, Value}) ->
                                %% ?DEBUG("TYPE:~w~nValue:~w~n", [Type, Value]),
                                write_binary(Type, Value)
                        end, ArgList)).

%% 根据伙伴id获取包裹位置及伙伴id，用于给客户端发消息时的数据处理
%% get_container_and_partner_id(ParterId) ->
%%     if
%%         ParterId =:= 0 ->
%%             {?PLAYER_EQUIP_LOCATION, undefined};
%%         true ->
%%             {?PARTNER_EQUIP_LOCATION, ParterId}
%%     end.


-spec keyfind_first(Pred, List) -> boolean() when
      Pred :: fun((Elem :: T) -> boolean()),
      List :: [T],
      T :: term().
keyfind_first(F, [H|T]) ->
    Res = F(H),
    if
        Res =:= true -> 
            H;
        true ->
            keyfind_first(F, T)
    end;
keyfind_first(F, []) 
  when is_function(F, 1) ->
    [].

-spec replace(Key, NewKey, List) -> list() when
      Key :: term(),
      NewKey :: term(),
      List :: [T],
      T :: term().
replace(Key, NewKey, List) ->
    lists:map(fun(K) ->
                      if
                          K =:= Key -> 
                              NewKey;
                          true -> 
                              K
                      end
              end, List).

%% @doc 分解并去除字符两端的无用数据
%% @spec
%% @end
split_and_strip(String, SplitChar, StripChar) ->
    lists:map(fun(Word) ->
                      string:strip(Word, both, StripChar)
              end, string:tokens(String, SplitChar)).


-spec get_fields_modified(R1, R2, FieldsList, ListModified) -> list() when
      R1 :: tuple(),
      R2 :: tuple(),
      FieldsList :: list(),
      ListModified :: list().
get_fields_modified(R1, R2, FieldsList, ListModified)
  when is_tuple(R1) andalso
       is_tuple(R2) ->
    L1 = tuple_to_list(R1),
    L2 = tuple_to_list(R2),
    [H1 | Rest1] = L1,
    [H2 | Rest2] = L2,
    if
        is_atom(H1) andalso 
        is_atom(H2) andalso
        H1 =:= H2 -> 
            RetList = 
                lists:map(fun({A, B}) ->
                                  if
                                      A =:= B ->
                                          undefined;
                                      true -> 
                                          1
                                  end
                          end, lists:zip(Rest1, Rest2)),
            FieldsModified = 
                lists:foldl(
                  fun({Field, Value}, InList) ->
                          if
                              Value =:= undefined ->
                                  %% 被过滤掉了
                                  InList;
                              Field =:= dirty ->
                                  %% 指定的用于标记的field需要过滤掉
                                  InList;
                              true -> 
                                  %% 有变化，加入到列表中
                                  [Field | InList]
                          end
                  end, [], lists:zip(FieldsList, RetList)),
            lists:umerge(
              lists:sort(ListModified), lists:sort(FieldsModified));
        true -> 
            %% 不匹配，那么直接返回原变化列表
            ListModified
    end.

get_fields_filter(Record, Fields, Func) 
  when is_tuple(Record) andalso 
       is_list(Fields) andalso
       is_function(Func) ->
    RList = tuple_to_list(Record),
    [_H | Values] = RList,
    ZipList = lists:zip(Fields, Values),
    lists:filter(fun({_Field, Value}) ->
                         Func(Value)
                 end, ZipList).

%% @doc 获取一个列表中对应关键字的值
%% @spec
%% @end
get_value_pair_tuple(Key, List) ->
    get_value_pair_tuple(Key, List, undefined).
get_value_pair_tuple(Key, List, V) ->
    case lists:keyfind(Key, 1, List) of
        {_, Val} ->
            Val;
        _ ->
            V
    end.

to_utf8_string(String)
  when is_list(String) ->
    binary_to_list(unicode:characters_to_binary(String));
to_utf8_string(String) 
  when is_binary(String) ->
    String;
to_utf8_string(_Other) ->
    ?DEBUG("to_utf8_string unknow sting : ~w ~n",[_Other]),
    [].


to_term_list(Ids)
  when is_binary(Ids) ->
    case util:bitstring_to_term(Ids) of
        List 
          when is_list(List) ->
            List;
        _ ->
            []        
    end;
to_term_list(Ids) 
  when is_list(Ids) ->
    Ids;
to_term_list(_other) ->
    ?INFO_MSG("to_id_list unknown ids : ~w ~n",[_other]),
    [].

%% to_list(ListBin)
%%   when is_binary(ListBin) ->
%%     case util:bitstring_to_term(ListBin) of
%%         List 
%%           when is_list(List) ->
%%             List;
%%         _ ->
%%             []        
%%     end;
%% to_list(List) 
%%   when is_list(List) ->
%%     List;
%% to_list(_other) ->
%%     ?INFO_MSG("to_id_list unknown ids : ~w ~n",[_other]),
%%     [].

format(Content, Args) 
  when is_list(Args)->
    NewArgs = 
        lists:map(fun(Arg) ->
                          if
                              is_binary(Arg) -> 
                                  Arg;
                              true -> 
                                  to_string(Arg)
                          end
                  end, Args),
    io_lib:format(Content, NewArgs).

%% test_utf8() ->
%%     S1 = to_utf8_string(<<"中国">>),
%%     S2 = to_utf8_string("中国"),
%%     S3 = to_utf8_string("china"),
%%     S4 = to_utf8_string([20013,22269]),
    
%%     ?DEBUG("S1 : ~w, S2 : ~w, S3 : ~w, S4 : ~w", [S1, S2, S3, S4]),
%%     ?DEBUG("S1 : ~ts, S2 : ~ts, S3 : ~ts, S4 : ~ts", [S1, S2, S3, S4]),
%%     ok.


%% test_rand_power() ->
%%     test_rand_power_inner(1000000,0),
%%     ok.


%% test_rand_power_inner(0, FailedCnt) ->
%%     io:format("RAND_FAILDE Cnt : ~w~n",[FailedCnt]);
%% test_rand_power_inner(N, FailedCnt) ->
%%     RankList = [{1, 750}, {2, 200}, {3, 50}],
%%     case rand(RankList) of
%%         Result when is_integer(Result) andalso Result >=1 andalso Result =< 3 ->
%%             test_rand_power_inner(N-1, FailedCnt);
%%         _Other ->
%%             test_rand_power_inner(N-1, FailedCnt+1)
%%     end.  

%%--------------------------------------------------------------------
%% @doc
%% 将相同的值赋值为undefined，不同值取新的
%% @spec
%% @end
%%--------------------------------------------------------------------
choose_second_value({Old, New}) ->
    if
        Old =:= New -> 
            undefined;
        true -> 
            New
    end.

%%--------------------------------------------------------------------
%% @doc
%% 过滤掉undefined的值用的
%% @spec
%% @end
%%--------------------------------------------------------------------
filter_undefined(Value) ->
    case Value of
        undefined -> 
            false;
        "undefined" -> 
            false;
        <<"undefined">> ->
            false;
        _ -> 
            true
    end.

%%--------------------------------------------------------------------
%% @doc 跟erlang的lists:max有点类似，但是加了自定义的Func函数来比较
%% @spec
%% @end
%%--------------------------------------------------------------------

lists_max(Func, List) 
  when is_function(Func) ->
    lists:foldl(Func, hd(List), tl(List)).   

%%--------------------------------------------------------------------
%% @doc 跟erlang的lists:min有点类似，但是加了自定义的Func函数来比较
%% @spec
%% @end
%% example
%% util:lists_min(fun(A, B) ->
%%                  if A#base_achieve.task_id =< B#base_achieve.task_id ->
%%                          A;
%%                     true ->
%%                          B
%%                  end
%%          end, BaseAchieveList)
%%--------------------------------------------------------------------

lists_min(Func, List) 
  when is_function(Func) ->
    lists:foldl(Func, hd(List), tl(List)).   

%% %% 较高效率的lists ++ 如果lists1 是大数组时使用
%% append(List1, List2) ->
%%     append(lists:reverse(List1), lists:reverse(List2), []).
%% append([], [], Result) ->
%%     Result;
%% append([E|Rest1], [], Result) ->
%%     append(Rest1, [], [E|Result]);
%% append(List1, [E|Rest2], Result) ->
%%     append(List1, Rest2, [E|Result]).

%% %% 较高效率的lists ++ 如果lists1 是大数组时使用
%% append_1(List1, List2) ->
%%     append2(lists:reverse(List1), List2).
%% append2(List1, []) ->
%%     lists:reverse(List1);
%% append2(List1, [E|Rest2]) ->
%%     append2([E|List1], Rest2).
cal_binary_1_count(N) ->
    cal_binary_1_count(N, 0).
cal_binary_1_count(0, Res) ->
    Res;
cal_binary_1_count(N, Res) ->
    cal_binary_1_count(N bsr 1, Res+(N band 1)).

%% @doc get_server_name
%% @spec
%% @end
get_server_name(Sn) ->
    ServerNameList = 
        case lib_syssetting:get_game_data(
               server_name_list, config:get_one_server_no()) of
            List when is_list(List) ->
                List;
            _ ->
                []
        end,
    %%?DEBUG("~p~n", [ServerNameList]),
    to_binary(
      proplists:get_value(to_integer(Sn), ServerNameList, "一将功成")).

-define(RE_METACHARACTERS, "()[]{}\|*.+?:!$^<>=").

re_escape(List) when is_list(List)->
    re_escape(List, []);
re_escape(BinList) when is_binary(BinList)->
    re_escape(to_list(BinList), []);
re_escape(_) ->
    [].
re_escape([], Acc) -> 
    lists:reverse(Acc);
re_escape([H|T], Acc) ->
    case lists:member(H, ?RE_METACHARACTERS) of
        true ->
            re_escape(T, [H, $\\|Acc]);
        false ->
            re_escape(T, [H|Acc])
    end.

%% @doc get random(1 - 2 ^ 31)
%% @spec
%% @end
new_session() ->
    rand(1, 2147483647).

%% =============== Internal functions ================

%% @doc 
%% @spec
%% @end
inner_select(Base, Current, [{Item, Power} | Tail]) ->
    %?DEBUG("Base : ~p", [Base]),
    NewCurrent = Current + Power,
    if
        NewCurrent >= Base ->
            Item;
        true ->
            inner_select(Base, NewCurrent, Tail)
    end;
inner_select(_, _, []) ->
    %% 到最后还没有选取到，那么返回 []
    [].


get_change(Rec1, Rec2, FieldList) ->
    [_|List1] = tuple_to_list(Rec1),
    [_|List2] = tuple_to_list(Rec2),
    get_change2(List1, List2, FieldList, []).

get_change2([], [], [], Ans) ->
    Ans;
get_change2([H|L1], [H|L2], [_|FieldList], Ans) ->
    get_change2(L1, L2, FieldList, Ans);
get_change2([_|L1], [undefined|L2], [_|FieldList], Ans) ->
    get_change2(L1, L2, FieldList, Ans);
get_change2([_|L1], ["undefined"|L2], [_|FieldList], Ans) ->
    get_change2(L1, L2, FieldList, Ans);
get_change2([_|L1], [<<"undefined">>|L2], [_|FieldList], Ans) ->
    get_change2(L1, L2, FieldList, Ans);
get_change2([_|L1], [V2|L2], [Field|FieldList], Ans) ->
    get_change2(L1, L2, FieldList, [{Field,V2}|Ans]).


load_base_data(DbTable, EtsTable, HandleFun) ->
    L = db_base:select_all(DbTable, "*", []),
    hetsutil:lock(EtsTable),
    try
        hetsutil:truncate(EtsTable),
        lists:foreach(fun(Info) ->
                              RecInfo = HandleFun(Info),
                              hetsutil:insert(EtsTable, RecInfo)
                      end, L)
    catch _:R ->
            ?WARNING_MSG("load ~p failed R:~w Stack: ~p~n",[DbTable, R, erlang:get_stacktrace()])
    after
        hetsutil:unlock(EtsTable)
    end,
    ok.

load_game_data(L, EtsTable, HandleFun) ->
    try
        lists:foreach(fun(Info) ->
                              RecInfo = HandleFun(Info),
                              hetsutil:insert(EtsTable, RecInfo)
                      end, L)
    catch _:R ->
            ?WARNING_MSG("insert ~p failed R:~w Stack: ~p~n",[EtsTable, R, erlang:get_stacktrace()])
    end,
    ok.


record_merge(R1, R2) 
  when is_tuple(R1),
       is_tuple(R2) ->
    record_merge(tuple_to_list(R1), tuple_to_list(R2), []).

record_merge([], [], Ans) ->
    list_to_tuple(lists:reverse(Ans));
record_merge([H1 | L1], [undefined | L2], Ans) ->
    record_merge(L1, L2, [H1|Ans]);
record_merge([H1 | L1], [[] | L2], Ans) ->
    record_merge(L1, L2, [H1|Ans]);
record_merge([_H1 | L1], [H2 | L2], Ans) ->
    record_merge(L1, L2, [H2|Ans]).


%% 获取HEX格式的字串
rand_str() ->
    to_hex(crypto:rand_bytes(4)).

to_hex([]) ->
    [];
to_hex(Bin) when is_binary(Bin) ->
    to_hex(binary_to_list(Bin));
to_hex([H|T]) ->
    [to_digit(H div 16), to_digit(H rem 16) | to_hex(T)].

to_digit(N) when N < 10 -> $0 + N;
to_digit(N) -> $a + N-10.

url_decode(URL) ->
    url_decode(URL, []).

url_decode([], Acc) ->
    lists:reverse(Acc);
url_decode([37,H,L|T], Acc) ->
    url_decode(T, [erlang:list_to_integer([H,L], 16) | Acc]);
url_decode([$+|T], Acc) ->
    url_decode(T, [32|Acc]);
url_decode([H|T], Acc) ->
    url_decode(T, [H|Acc]).

to_32bit_ip({A, B, C, D}) ->
    A * (1 bsl 24) + B * (1 bsl 16) + C * (1 bsl 8) + D.
