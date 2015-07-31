%%%----------------------------------------
%%% @Module  : lib_misc_admin
%%% @Created : 2010.10.09 
%%% @Description: 系统状态管理和查询
%%%----------------------------------------
-module(lib_misc_admin).

%%
%% Include files
%%
-include("define_logger.hrl").
-include("define_server.hrl").
-include("define_player.hrl").
-include("define_mail.hrl").

%%
%% Exported Functions
%%

-export([
         treat_http_request/1,
         check_ip/1,
         get_cmd_parm/1,
         new_vip_info/3,
         get_online_count/0,
         node_info/0,
         donttalk/2,
         kickuser/1,
         banrole/2,
         get_process_info_detail_list/3,
         get_message_queue_len/1,
         reply_msg/2
        ]).

-define(SOCKET_TOP, 5000).

%% @doc 回复消息
%% @spec
%% @end
reply_msg(Req, Msg) ->
    Req:respond({200, [{"Content-Type", "text/plain"}], 
                 hmisc:to_string(Msg)}).

%% @doc 处理http请求【需加入身份验证或IP验证】
%% @spec
%% @end
treat_http_request(Req) ->
    try
        case check_ip(Req:get(peer)) of
            true ->
                case Req:get(method) of
                    Method when Method =:= 'GET'; Method =:= 'HEAD' ->
                        ?DEBUG("Req:get(raw_path)~s~n", [Req:get(raw_path)]),
                        inner_handle(Req, get_cmd_parm(Req:get(raw_path)));
                    _ ->
                        Req:respond({501, [], []})
                end;
            false ->
                %% 非法 ip
                reply_msg(Req, "permission denied for this ip.")
        end
    catch
        Type1:What ->
            Report = ["web request failed",
                      {type, Type1}, {what, What},
                      {trace, erlang:get_stacktrace()}],
            error_logger:error_report(Report),
            %% NOTE: mustache templates need \ because they are not awesome.
            Req:respond({500, [{"Content-Type", "text/plain"}], 
                         "request failed, sorry\n"})
    end.

inner_handle(Req, {"get_node_status", Parms}) ->
    ?DEBUG("Parms ~p~n", [Parms]),
    Data = get_nodes_info(),
    reply_msg(Req, Data);
inner_handle(Req, {"cl", Parm}) ->
    Modname = hmisc:get_value_pair_tuple(mod_name, Parm),
    Data = reload_module(Modname),
    reply_msg(Req, Data);
inner_handle(Req, {"get_node_info", Parm}) ->  
    Type = hmisc:get_value_pair_tuple(type, Parm),
    Data = get_nodes_cmq(1, hmisc:to_integer(Type)),
    DataFormat = io_lib:format("~p", [Data]),
    reply_msg(Req, DataFormat);
%% inner_handle(Req, {"close_nodes", Parm}) ->
%%     Type = hmisc:get_value_pair_tuple(t, Parm),
%%     Data = close_nodes(hmisc:to_integer(Type), Req:get(socket)),
%%     DataFormat = io_lib:format("~p", [Data]),
%%     reply_msg(Req, DataFormat);
inner_handle(Req, {"donttalk", Parm}) ->
    Id = hmisc:get_value_pair_tuple(id, Parm),
    Stoptime = hmisc:get_value_pair_tuple(
                 stoptime, Parm),
    operate_to_player(lib_misc_admin, donttalk, 
                      [list_to_integer(Id), 
                       list_to_integer(Stoptime)]),
    reply_msg(Req, "ok!");
inner_handle(Req, {"server_start_time", _}) ->
    TimeStamp = time_misc:get_server_start_time(),
    reply_msg(Req, hmisc:to_binary(TimeStamp));
inner_handle(Req, {"safe_quit", Parm}) ->
    Id = hmisc:get_value_pair_tuple(gm_close, Parm),
    if
        Id =:= "110" ->
            ?ERROR_MSG("trying to stop server. safe_quit Parm:~w~n",
                       [Parm]),
            %% safe_quit(Parm, Socket),
            %% 10s后关闭服务器
            spawn(fun() ->
                          main:server_stop(10)
                  end),
            %% main:server_stop(10),
            reply_msg(Req, "ok!"),
            timer:sleep(10000),
            erlang:halt();
        true ->
            reply_msg(Req, "error cmd")
    end;
inner_handle(Req, {"server_status", _}) ->
    reply_msg(Req, "OK");
inner_handle(Req, {"remove_nodes", Parm}) ->
    Node = hmisc:get_value_pair_tuple(nodes, Parm),
    remove_nodes(Node),
    reply_msg(Req, "ok!");
inner_handle(Req, {"online_count", _Parm}) ->
    Data = get_online_count(),
    reply_msg(Req, Data);
inner_handle(Req, {"new_mail", Parm}) ->
    %% NO  CMD?
    MailInfo = hmisc:get_value_pair_tuple(mail, Parm),
    send_new_mail(MailInfo),
    reply_msg(Req, "ok");
inner_handle(Req, {"new_vip_info_yes", Parm}) ->
    PlayerId = hmisc:get_value_pair_tuple(player_id, Parm),
    new_vip_info(vip_value, true, PlayerId),
    reply_msg(Req, "ok!");
inner_handle(Req, {"new_vip_info_no", Parm}) ->
    PlayerId = hmisc:get_value_pair_tuple(player_id, Parm),
    new_vip_info(vip_value, false, PlayerId),
    reply_msg(Req, "ok!");
inner_handle(Req, {"add_white_ip", Parm}) ->
    IPStr = hmisc:get_value_pair_tuple(ipstr, Parm),
    ?WARNING_MSG("Add IP ~p~n", [IPStr]),
    IPList = hmisc:split_and_strip(IPStr, ",", 32),
    data_config:add_ip(IPList),
    reply_msg(Req, "ok!");
%% inner_handle(Req, {"update_server_state", _}) ->
%%     ?WARNING_MSG("Update Server State~n", []),
%%     update_server_state(),
%%     reply_msg(Req, "update server state success!");
inner_handle(Req, {"reload_config", Parm}) -> 
    Val = hmisc:get_value_pair_tuple(val, Parm),
    ?WARNING_MSG("Reload Config~n", []),
    Par = hmisc:get_value_pair_tuple(par, Parm),
    NewPar = hmisc:to_atom(Par),
    DecodeVal = http_uri:decode(Val),
    NewVal = hmisc:string_to_term(DecodeVal),
    ?WARNING_MSG("Val ~ts, NewVal ~w~n", [DecodeVal, NewVal]),
    case application:get_env(application:get_application(), NewPar) of
        {ok, _} ->
            application:set_env(
              config_app:get_application(),
              NewPar, NewVal),
            dynamic_config:start(),
            reply_msg(Req, "ok!");
        _ ->
            ?WARNING_MSG("reload_config failed, not key ~w~n", [NewPar]),
            reply_msg(Req, "failed")
    end;
inner_handle(Req, {"pay_success", Parm}) ->
    send_pay_info(Parm),
    reply_msg(Req, "ok");
inner_handle(Req, {"mnesia", Parm}) ->
    NParm = hmisc:get_value_pair_tuple(apply, Parm),
    ?DEBUG("mnesia operate: ~p~n", [NParm]),
    case inner_check_apply_string(NParm) of
        true ->
            reply_msg(Req, hmisc:apply_string(NParm));
        false ->
            reply_msg(Req, io_lib:format("wrong apply:~p", [NParm]))
    end;
inner_handle(Req, {"banrole", Parm}) ->
    PlayerId = hmisc:to_integer(hmisc:get_value_pair_tuple(uid, Parm)),
    UnLockTimestamp = hmisc:to_integer(hmisc:get_value_pair_tuple(time, Parm)),
    mod_player:banrole(PlayerId, UnLockTimestamp),
    reply_msg(Req, "ok");

inner_handle(Req, {"kickuser", Parm}) ->
    PlayerId = hmisc:to_integer(hmisc:get_value_pair_tuple(uid, Parm)),
    mod_player:stop(PlayerId, ?STOP_REASON_KICK_OUT),
    reply_msg(Req, "ok");

inner_handle(Req, {Other, Parm}) ->
    ?WARNING_MSG("Other ~p~n~p~n", [Other, Parm]),
    reply_msg(Req, io_lib:format("bad command: ~p", [Other])).

%% 加入http来源IP验证 
check_ip(Ip) ->
    lists:member(Ip, app_misc:get_env(http_ips)).

%% 分析解析串
get_cmd_parm(Str) ->
    %% STR ->[CMD|PARMS], PARMS->[{},{},{}]
    NStr = string:to_lower(Str),
    case string:tokens(NStr, "?") of
        [Cmd, Parms] ->
            List = string:tokens(Parms, "&"),
            {lists:nthtail(1, Cmd), 
             lists:foldl(fun(S, Acc) ->
                                 case string:tokens(S, "=") of
                                     [A, B] ->
                                         [{hmisc:to_atom(A), B}|Acc];
                                     _ ->
                                         Acc
                                 end
                         end, [], List)};
        [Cmd] ->
            {lists:nthtail(1, Cmd), []}
    end.

%% 后台修改玩家vip等级和vip值
new_vip_info(Type, Announce, PlayerId) ->
    case hmisc:whereis_player_pid(PlayerId) of
        [] ->
            skip;
        Pid ->
            gen_server:cast(Pid, {new_vip_info, Type, Announce})
    end.

%% 获取在线人数
get_online_count() ->
    lists:concat(['online_count:', online_state()]).

online_state() ->
    gen_server:call(mod_monitor, cmd_query_player_count).

%% 获取节点列表
get_node_info_list() ->
    %% L = lists:usort(mod_node_interface:server_list()),
    %% Info_list =
    %%     lists:map(
    %%       fun(S) ->
    %%               {Node_status, Node_name, User_count} = 
    %%                   case rpc:call(S#server.node, mod_node_interface, online_state, []) of
    %%                       {badrpc, _} ->
    %%                           {fail, misc:to_list(S#server.node), 0};
    %%                       [_State, Num, _] ->
    %%                           {ok,   misc:to_list(S#server.node), Num}
    %%                   end,    
    %%               Node_info = 
    %%                   try 
    %%                       case rpc:call(S#server.node, misc_admin, node_info, []) of
    %%                           {ok, Node_info_0} ->
    %%                               Node_info_0;
    %%                           _ ->
    %%                               error
    %%                       end
    %%                   catch
    %%                       _:_ -> error
    %%                   end,                                                    
    %%               {Node_status, Node_name, User_count, Node_info}
    %%       end,
    %%       L),

    Info_list = 
        [
         {ok, hmisc:to_list(node()), online_state(), get_node_info()}
        ],
    {ok, Info_list}.

%% 获取各节点状态
get_nodes_info() ->
    case get_node_info_list() of
        {ok, Node_info_list} ->
            Count_list =
                lists:map(
                  fun({_Node_status, _Node_name, User_count, _Node_info}) ->
                          User_count
                  end,
                  Node_info_list),      
            Total_user_count = lists:sum(Count_list),

            Node_ok_list =
                lists:map(
                  fun({Node_status, _Node_name, _User_count, _Node_info}) ->
                          case Node_status of
                              fail -> 0;
                              _ ->  1
                          end
                  end,
                  Node_info_list),      
            Total_node_ok = lists:sum(Node_ok_list),        
            Temp1 = 
                case Total_node_ok =:= length(Node_info_list) of
                    true -> 
                        [];
                    _ ->
                        lists:concat(['/',Total_node_ok])
                end,

            All_Connect_count_str = 
                lists:concat(
                  ['Nodes_count: [', length(Node_info_list),
                   '] ,total_connections: [', Total_user_count, Temp1,
                   ']    [',time_misc:time_format(os:timestamp()),
                   ']']),
            Info_list =
                lists:map(
                  fun({Node_status, Node_name, _User_count, Node_info})->
                          case Node_status of
                              fail ->
                                  lists:concat(['Node: ',Node_name,'[Warning: this node may be crashed or busy.]\t\n']);
                              _ ->
                                  lists:concat(['Node: ',Node_name,'\t\n',Node_info])
                          end
                  end,
                  Node_info_list),      
            lists:concat([All_Connect_count_str, 
                          '\t\n', 
                          '------------------------------------------------------------------------\t\n',
                          Info_list]);            
        _ ->
            ''
    end.

%% 获取本节点的基本信息
node_info() ->
    Info = get_node_info(),
    {ok, Info}.

get_node_info() ->
    Server_no = 
        case ets:match(?ETS_SYSTEM_INFO, {'_', server_no, '$3'}) of
            [[S_no]] ->
                S_no;
            _ ->
                undefined
        end,
    Log_level = 
        case ets:match(?ETS_SYSTEM_INFO, {'_',log_level,'$3'}) of
            [[Log_l]] ->
                Log_l;
            _ ->
                undefined
        end,

    Info_log_level = 
        lists:concat(['    Server_no:[', Server_no
                      ,'], Log_level:[', Log_level
                      ,'], Process_id:[', os:getpid(), ']\t\n']),

    Info_tcp_listener =
        lists:concat(
          case ets:match(?ETS_SYSTEM_INFO, {'_',tcp_listener,'$3'}) of
              [[{Host_tcp, Port_tcp, Start_time}]] ->
                  ['    Tcp listener? [Yes]. IP:[',Host_tcp,
                   '], Port:[', Port_tcp,
                   '], Connections:[', 0,
                   '], Start_time:[', 
                   time_misc:time_format(Start_time),
                   ']\t\n'];
              _ ->
                  []
          end),

    Info_stat_socket = 
        try
            case ets:info(?ETS_STAT_SOCKET) of
                undefined ->
                    [];
                _ ->
                    Stat_list_socket_out = 
                        ets:match(?ETS_STAT_SOCKET,
                                  {'$1', socket_out , '$3','$4'}),
                    Stat_list_socket_out_1 = 
                        lists:sort(fun([_, _, Count1], [_, _, Count2]) ->
                                           Count1 > Count2
                                   end, Stat_list_socket_out),
                    Stat_list_socket_out_2 = 
                        lists:sublist(Stat_list_socket_out_1, ?SOCKET_TOP),
                    Stat_info_socket_out = 
                        lists:map( 
                          fun(Stat_data) ->
                                  case Stat_data of
                                      [Cmd, BeginTime, Count] ->
                                          TimeDiff = 
                                              timer:now_diff(
                                                os:timestamp(), 
                                                BeginTime) / (1000 * 1000)
                                              + 1,
                                          lists:concat(['        ','Cmd:[', Cmd, 
                                                        '], packet_avg/sec:[', Count, 
                                                        '/', round(TimeDiff), ' = ',
                                                        round(Count / TimeDiff),']\t\n']);
                                      _->
                                          ''
                                  end
                          end,
                          Stat_list_socket_out_2),
                    if 
                        length(Stat_info_socket_out) > 0 ->
                            lists:concat(['    Tcp socket packet_out statistic_top',
                                          ?SOCKET_TOP,':\t\n', Stat_info_socket_out]);
                        true ->
                            []
                    end                     
            end
        catch
            _:_ -> []
        end,    

    Info_db =       
        case ets:match(?ETS_SYSTEM_INFO,{'_', db, '$3'}) of
            [] ->
                [];
            Db_list ->
                Db_info_list = 
                    lists:map( 
                      fun([{Db, Type, Host, Port, User, DB, Poolsize, Encode}]) ->
                              lists:concat(['    ','    Db:[', Db ,
                                            '], Type:[', Type,
                                            '], Host:[', Host,
                                            '], Port:[', Port,
                                            '], User:[', User,
                                            '], DB:[', DB,
                                            '], Poolsize:[', Poolsize,
                                            '], Encode:[', Encode,
                                            ']\t\n'])
                      end, 
                      Db_list),
                if
                    length(Db_info_list) > 0 ->
                        lists:concat(['    Db config:\t\n'] ++ Db_info_list);
                    true ->
                        []
                end
        end,

    Info_stat_db = 
        try
            case ets:info(?ETS_STAT_DB) of
                undefined ->
                    [];
                _ ->
                    Stat_list_db = ets:match(?ETS_STAT_DB, {'$1', '$2', '$3', '$4', '$5'}),
                    Stat_list_db_1 = 
                        lists:sort(
                          fun([_, _, _, _, Count1], [_, _, _, _, Count2]) ->
                                  Count1 > Count2
                          end, Stat_list_db),
                    Stat_list_db_2 = lists:sublist(Stat_list_db_1, 5), 
                    Stat_info_db = 
                        lists:map( 
                          fun(Stat_data) ->
                                  case Stat_data of                               
                                      [_Key, Table, Operation, BeginTime, Count] ->
                                          TimeDiff = timer:now_diff(os:timestamp(), BeginTime)/(1000*1000)+1,
                                          lists:concat(['        ','Table:[', lists:duplicate(30-length(hmisc:to_list(Table))," "), Table, 
                                                        '], op:[', Operation,
                                                        '], avg/sec:[', Count, '/',round(TimeDiff),' = ',round(Count / TimeDiff),']\t\n']);
                                      _->
                                          ''
                                  end 
                          end, 
                          Stat_list_db_2),
                    if length(Stat_info_db) > 0 ->
                            lists:concat(['    DB table operation statistic_top5:\t\n', Stat_info_db]);
                       true ->
                            []
                    end                     
            end
        catch
            _:_ -> []
        end,    

    Process_info_detail = 
        try
            get_monitor_process_info_list()
        catch
            _:_ -> {ok, []} 
        end,

    Info_process_queue_top = 
        try
            case get_process_info(Process_info_detail, 5, 2, 0, msglen) of 
                {ok, Process_queue_List, Process_queue_List_len} ->
                    Info_process_queue_list = 
                        lists:map( 
                          fun({Pid, RegName, Mlen, Qlen, Module, Other, Messgaes}) ->
                                  if      is_atom(RegName) -> 
                                          lists:concat(['        ','regname:[', RegName, erlang:pid_to_list(Pid), 
                                                        '],q:[', Qlen ,
                                                        '],m:[', Mlen ,
                                                        '],i:[', Other ,
                                                        Messgaes ,
                                                        ']\t\n']);
                                          is_atom(Module) ->
                                          lists:concat(['        ','module:[', Module, erlang:pid_to_list(Pid), 
                                                        '],q:[', Qlen ,
                                                        '],m:[', Mlen ,
                                                        '],i:[', Other ,
                                                        Messgaes ,
                                                        ']\t\n']);
                                          true ->
                                          lists:concat(['        ','pid:[', erlang:pid_to_list(Pid) ,
                                                        '],q:[', Qlen ,
                                                        '],m:[', Mlen ,
                                                        '],i:[', Other ,
                                                        Messgaes ,
                                                        ']\t\n'])
                                  end     
                          end,
                          Process_queue_List),
                    lists:concat(['    Message_queue_top5: [', Process_queue_List_len, ' only processes being monitored', ']\t\n',Info_process_queue_list]);
                _ ->
                    lists:concat(['    Message_queue_top5: [error_1]\t\n'])
            end
        catch
            _:_ -> lists:concat(['    Message_queue_top5: [error_2]\t\n'])
        end,

    Info_process_memory_top = 
        try
            case get_process_info(Process_info_detail, 20, 0, 0, memory) of 
                {ok, Process_memory_List, Process_memory_List_len} ->
                    Info_process_memory_list = 
                        lists:map( 
                          fun({Pid, RegName, Mlen, Qlen, Module, Other, _Messgaes}) ->
                                  if      is_atom(RegName) -> 
                                          lists:concat(['        ','regname:[', RegName, erlang:pid_to_list(Pid), 
                                                        '],q:[', Qlen ,
                                                        '],m:[', Mlen ,
                                                        '],i:[', Other ,
                                                        ']\t\n']);
                                          is_atom(Module) ->
                                          lists:concat(['        ','module:[', Module, erlang:pid_to_list(Pid), 
                                                        '],q:[', Qlen ,
                                                        '],m:[', Mlen ,
                                                        '],i:[', Other ,
                                                        ']\t\n']);
                                          true ->
                                          lists:concat(['        ','pid:[', erlang:pid_to_list(Pid) ,
                                                        '],q:[', Qlen ,
                                                        '],m:[', Mlen ,
                                                        '],i:[', Other ,
                                                        ']\t\n'])
                                  end     
                          end,
                          Process_memory_List),
                    lists:concat(['    Process_memory_top20: [', Process_memory_List_len,' only processes being monitored', ']\t\n',Info_process_memory_list]);
                _ ->
                    lists:concat(['    Message_memory_top20: [error_1]\t\n'])
            end
        catch
            _:_ -> lists:concat(['    Message_memory_top20: [error_2]\t\n'])
        end,

    System_process_info = 
        try
            lists:concat(["    System process: \t\n",
                          "        ",
                          "process_count:[", erlang:system_info(process_count) ,'],',
                          "processes_limit:[", erlang:system_info(process_limit) ,'],',
                          "ports_count:[", length(erlang:ports()),']',
                          "\t\n"
                         ])
        catch
            _:_ -> []
        end,

    %%                 total = processes + system
    %%         processes = processes_used + ProcessesNotUsed
    %%         system = atom + binary + code + ets + OtherSystem
    %%         atom = atom_used + AtomNotUsed
    %% 
    %%         RealTotal = processes + RealSystem
    %%         RealSystem = system + MissedSystem

    System_memory_info = 
        try
            lists:concat(["    System memory: \t\n",
                          "        ",
                          "total:[", erlang:memory(total) ,'],',
                          "processes:[", erlang:memory(processes) ,'],',
                          "processes_used:[", erlang:memory(processes_used) ,'],\t\n',
                          "        ",
                          "system:[", erlang:memory(system) ,'],',
                          "atom:[", erlang:memory(atom) ,'],',
                          "atom_used:[", erlang:memory(atom_used) ,'],\t\n',
                          "        ",
                          "binary:[", erlang:memory(binary) ,'],',
                          "code:[", erlang:memory(code) ,'],',
                          "ets:[", erlang:memory(ets) ,']',
                          "\t\n"
                         ])
        catch
            _:_ -> []
        end,

    LL1 = string:tokens(binary_to_list(erlang:system_info(info)),"="),
    Atom_tab =
        case lists:filter(fun(I)-> string:str(I,"index_table:atom_tab") == 1 end, LL1) of
            [] -> [];
            [Index_table] -> binary:replace(list_to_binary(Index_table), <<"\n">>, <<", ">>, [global])
        end,

    System_other_info = 
        try
            System_load = get_system_load(),
            {{input,Input},{output,Output}} = statistics(io),

            lists:concat(["    System other: \t\n",
                          "        ",
                          "atom_tab:[", binary_to_list(Atom_tab) ,'],\t\n', 
                          "        ",
                          "run_queue:[", statistics(run_queue) ,'],',
                          "input:[", Input ,'],',
                          "output:[", Output ,'],',
                          "wallclock_time:[", io_lib:format("~.f", [System_load]) ,'],',                                           
                          "\t\n"
                         ])
        catch
            _:_ -> []
        end,            

    Info_global =   
        case ets:match(?ETS_MONITOR_PID, {'$1', node ,'$3'}) of
            [] ->
                [];
            Global_list ->
                Global_info_list = 
                    lists:map( 
                      fun([GPid, P]) ->
                              [ModuleName, WorkerNumber, WeightLoad] = 
                                  case P of
                                      {Module, M_workers, M_load} -> [Module, M_workers, M_load];
                                      {Module, M_load} -> [Module, unknown, M_load];
                                      {Module} -> [Module, unknown, unknown]
                                  end,
                              lists:concat(['        ',ModuleName,' ==> Pid:[',erlang:pid_to_list(GPid),'], WeightLoad:[', WeightLoad,'], WorkerNumber:[', WorkerNumber, ']\t\n'])
                      end, 
                      Global_list),
                if length(Global_info_list) > 0 ->
                        lists:concat(['    node_mod:\t\n'] ++ Global_info_list);
                   true ->
                        []
                end                                    
        end,

    %% Info_scene = 
    %%     try 
    %%         case ets:info(?ETS_MONITOR_PID) of
    %%             undefined ->
    %%                 [];
    %%             _ ->
    %%                 Stat_list_scene = ets:match(?ETS_MONITOR_PID,{'$1', mod_scene ,'$3'}),
    %%                 Stat_info_scene = 
    %%                     lists:map( 
    %%                       fun(Stat_data) ->
    %%                               case Stat_data of                               
    %%                                   [_SceneAgentPid, {SceneId, Worker_Number}] ->
    %%                                       MS = ets:fun2ms(fun(T) when T#player.scene =:= SceneId  -> 
    %%                                                               [T#player.id] 
    %%                                                       end),
    %%                                       %% Players = ets:select(?ETS_ONLINE, MS),
    %%                                       lists:concat([SceneId,'(', Worker_Number ,')_', 0, ', ']);
    %%                                   _->
    %%                                       ''
    %%                               end 
    %%                       end, 
    %%                       Stat_list_scene),
    %%                 case Stat_list_scene of
    %%                     [] -> [];
    %%                     _ -> lists:concat(['    Scene here: [',Stat_info_scene,']\t\n'])
    %%                 end
    %%         end
    %%     catch
    %%         _:_ -> []
    %%     end,

    %% Info_dungeon = 
    %%     try
    %%         case ets:info(?ETS_MONITOR_PID) of
    %%             undefined ->
    %%                 [];
    %%             _ ->
    %%                 Stat_list_dungeon = ets:match(?ETS_MONITOR_PID,{'$1', mod_dungeon ,'$3'}),
    %%                 Stat_info_dungeon = 
    %%                     lists:map( 
    %%                       fun(Stat_data) ->
    %%                               case Stat_data of                               
    %%                                   [_,{Dungeon_state}] ->
    %%                                       {_, Dungeon_scene_id, Scene_id, _, 
    %%                                        Dungeon_role_list, _ , _, _, _, _, _ , _} = Dungeon_state,
    %%                                       lists:concat([Scene_id,'(',Dungeon_scene_id,')','_', length(Dungeon_role_list), ', ']);
    %%                                   _->
    %%                                       ''
    %%                               end 
    %%                       end, 
    %%                       Stat_list_dungeon),
    %%                 case Stat_list_dungeon of
    %%                     [] -> [];
    %%                     _ -> lists:concat(['    Dungeon here: [',Stat_info_dungeon,']\t\n'])
    %%                 end                     
    %%         end
    %%     catch
    %%         _:_ -> []
    %%     end,    

    lists:concat([Info_log_level, Info_global,
                  %% Info_scene, Info_dungeon, 
                  Info_tcp_listener, Info_stat_socket,
                  Info_db, Info_stat_db, 
                  Info_process_queue_top, Info_process_memory_top, 
                  System_process_info, System_memory_info, System_other_info,
                  '------------------------------------------------------------------------\t\n']).

get_process_info(Process_info_detail, Top, MinMsgLen, MinMemSize, OrderKey) ->
    case Process_info_detail of
        {ok, RsList} ->
            Len = erlang:length(RsList),
            FilterRsList = 
                case OrderKey of 
                    msglen ->
                        lists:filter(fun({_,_,_,Qlen,_,_,_}) -> Qlen >= MinMsgLen end, RsList);
                    memory ->
                        lists:filter(fun({_,_,Qmem,_,_,_,_}) -> Qmem >= MinMemSize end, RsList);
                    _ ->
                        lists:filter(fun({_,_,_,Qlen,_,_,_}) -> Qlen >= MinMsgLen end, RsList)
                end,
            RsList2 = 
                case OrderKey of
                    msglen ->
                        lists:sort(fun({_,_,_,MsgLen1,_,_,_},{_,_,_,MsgLen2,_,_,_}) -> MsgLen1 > MsgLen2 end, FilterRsList);
                    memory ->
                        lists:sort(fun({_,_,MemSize1,_,_,_,_},{_,_,MemSize2,_,_,_,_}) -> MemSize1 > MemSize2 end, FilterRsList);
                    _ ->
                        lists:sort(fun({_,_,_,MsgLen1,_,_,_},{_,_,_,MsgLen2,_,_,_}) -> MsgLen1 > MsgLen2 end, FilterRsList)
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
            {ok,NewRsList, Len};
        _->
            {error,'error'}
    end.

get_process_info_detail_list(Process, NeedModule, Layer) ->
    RootPid =
        if
            erlang:is_pid(Process) ->
                Process;
            true ->
                case hmisc:whereis_name({local, Process}) of
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
            AllPidList = hmisc:get_process_all_pid(RootPid,Layer),
            RsList = hmisc:get_process_info_detail(NeedModule, AllPidList,[]),
            {ok, RsList}
    end.

get_monitor_process_info_list() ->
    Monitor_process_info_list =     
        try
            case ets:match(?ETS_MONITOR_PID,{'$1','$2','$3'}) of
                List when is_list(List) ->
                    lists:map(
                      fun([Pid, Module, Pars]) ->
                              get_process_status({Pid, Module, Pars})
                      end,
                      List);   
                _ ->
                    []
            end
        catch
            _:_ -> []
        end,                    
    {ok, Monitor_process_info_list}.

%% get_process_status({Pid, Module, Pars}) when Module =/= mcs_role_send ->
%%      {'', '', -1, -1, '', '', ''};
get_message_queue_len(Pid) ->
    try 
        case erlang:process_info(Pid, [message_queue_len]) of
            [{message_queue_len, Qlen}] ->  Qlen;
            _ -> -1
        end
    catch 
        _:_ -> -2
    end.

get_process_status({Pid, Module, Pars}) ->
    Other = 
        case Module of
            mod_player -> 
                {PlayerId} = Pars,                              
                case erlang:process_info(Pid,[dictionary]) of
                    undefined -> 
                        lists:concat([PlayerId, "__", dead]);
                    [{_, Dic1}] ->
                        case lists:keyfind(last_msg, 1, Dic1) of 
                            {last_msg, Last_msg} -> 
                                Last_msg1 = io_lib:format("~p", Last_msg),
                                lists:concat([PlayerId, "__", Last_msg1]);
                            _->     
                                lists:concat([PlayerId])
                        end
                end;
            mod_pid_send -> 
                case Pars of
                    {PlayerId, _Socket, N} -> 
                        lists:concat([PlayerId, "_Socket_", N ,"_"]);
                    _ -> ""
                end;
            mod_socket -> 
                case Pars of
                    {GroupName, _Socket, PlayerId, _PlayerPid} -> 
                        lists:concat([PlayerId, "_mod_Socket_", GroupName ,"_"]);
                    _ -> ""
                end;                    
            global ->
                case Pars of
                    {M, WorkerNumber, WeightLoad} -> 
                        lists:concat([M, ",", WorkerNumber, ",", WeightLoad]);
                    {M} -> lists:concat([M]);
                    _ -> ""
                end;
            %%                              lists:concat([PlayerId]);

            %%                      
            %%                              {#role_send_state{roleid = Roleid,  client_ip = {P1,P2,P3,P4}, 
            %%                                                      rolepid = RolePid, accountpid = AccountPid, 
            %%                                                      role_status = Role_status, account_status = Account_status,       
            %%                                                      start_time = StartTime, now_time = CheckTime,priority =Priority,
            %%                                                      canStopCount = CanStopCount, lastMsgLen = LastMsgLen,  getMsgError = GetMsgError
            %%                                                      }} = Pars,
            %%                              lists:concat([Roleid,'/',P1,'.',P2,'.',P3,'.',P4,'/',mcs_misc:time_format( StartTime)
            %%                                                      ,'/',mcs_misc:time_format( CheckTime)
            %%                                                      ,'/',CanStopCount
            %%                                                      ,',', LastMsgLen
            %%                                                      ,',', GetMsgError
            %%                                                      ,',', Priority
            %%                                                      ,'/',erlang:is_process_alive(Pid)
            %%                                                      ,'/R', erlang:pid_to_list(RolePid), '[',Role_status,']_', erlang:is_process_alive(RolePid), '_', get_message_queue_len(RolePid)
            %%                                                      ,'/A', erlang:pid_to_list(AccountPid), '[',Account_status,']_', erlang:is_process_alive(AccountPid), '_', get_message_queue_len(AccountPid)
            %%                                                      ]);
            _->
                ''
        end,

    try 
        case erlang:process_info(Pid, [message_queue_len,memory,registered_name, messages]) of
            [{message_queue_len, Qlen},
             {memory, Mlen},
             {registered_name, RegName},
             {messages, _MessageQueue}] ->
                Messages = '',
                %% if length(MessageQueue) > 0, Module == mod_player ->
                %%         Message_Lists = 
                %%             lists:map(
                %%               fun({Mclass, Mbody}) ->
                %%                       if is_tuple(Mbody) ->
                %%                               [Mtype] = lists:sublist(tuple_to_list(Mbody), 1),
                %%                               [Mtype, Module1, Method1] = lists:sublist(tuple_to_list(Mbody),3),
                %%                               lists:concat(['            <'
                %%                                             ,Mclass,
                %%                                             ', ' ,Mtype,
                %%                                             ', ',binary_to_list(Module1), 
                %%                                             ', ',binary_to_list(Method1),
                %%                                             '>\t\n']);
                %%                          true ->
                %%                               lists:concat(['            <',Mclass,'>\t\n'])
                %%                       end
                %%               end,
                %%               lists:sublist(MessageQueue,5)),                              
                %%         lists:concat(['/\t\n',Message_Lists,'            ']);
                %%    true -> ''
                %% end,
                {Pid, RegName, Mlen, Qlen, Module, Other, Messages};
            _ -> 
                {'', '', -1, -1, '', '', ''}
        end
    catch 
        _:_ -> {'', '', -1, -1, '', '', ''}
    end.


%% get_process_status_old({Pid, Module, _Pars}) ->
%%     %%      Other = 
%%     %%              case Module of
%%     %%                      mod_player -> 
%%     %%                              {PlayerId} = Pars,
%%     %%                              lists:concat([PlayerId]);
%%     %% %%                   
%%     %% %%                           {#role_send_state{roleid = Roleid,  client_ip = {P1,P2,P3,P4}, 
%%     %% %%                                                   rolepid = RolePid, accountpid = AccountPid, 
%%     %% %%                                                   role_status = Role_status, account_status = Account_status,       
%%     %% %%                                                   start_time = StartTime, now_time = CheckTime,priority =Priority,
%%     %% %%                                                   canStopCount = CanStopCount, lastMsgLen = LastMsgLen,  getMsgError = GetMsgError
%%     %% %%                                                   }} = Pars,
%%     %% %%                           lists:concat([Roleid,'/',P1,'.',P2,'.',P3,'.',P4,'/',mcs_misc:time_format( StartTime)
%%     %% %%                                                   ,'/',mcs_misc:time_format( CheckTime)
%%     %% %%                                                   ,'/',CanStopCount
%%     %% %%                                                   ,',', LastMsgLen
%%     %% %%                                                   ,',', GetMsgError
%%     %% %%                                                   ,',', Priority
%%     %% %%                                                   ,'/',erlang:is_process_alive(Pid)
%%     %% %%                                                   ,'/R', erlang:pid_to_list(RolePid), '[',Role_status,']_', erlang:is_process_alive(RolePid), '_', get_message_queue_len(RolePid)
%%     %% %%                                                   ,'/A', erlang:pid_to_list(AccountPid), '[',Account_status,']_', erlang:is_process_alive(AccountPid), '_', get_message_queue_len(AccountPid)
%%     %% %%                                                   ]);
%%     %%                      _->
%%     %%                              ''
%%     %%              end,
%%     %%      Other = %%根据刘哥的方案修改,只处理mod_player----xiaomai
%%     %%              case Module of
%%     %%                      mod_player -> 
%%     %%                              {PlayerId} = Pars,
%%     %%                              Dic = erlang:process_info(Pid,[dictionary]),
%%     %%                              [{_, Dic1}] = Dic,
%%     %%                              case lists:keyfind(last_msg, 1, Dic1) of 
%%     %%                                      {last_msg, Last_msg} -> 
%%     %%                                              lists:concat([PlayerId, "__", io_lib:format("~p", Last_msg)]);
%%     %%                                      _-> lists:concat([PlayerId])
%%     %%                              end;
%%     %%                      _ ->
%%     %%                              ''
%%     %%              end,
%%     Other = '',%%去掉last_msg的进程字典，此处修改

%%     try 
%%         case erlang:process_info(Pid, [message_queue_len,memory,registered_name, messages]) of
%%             [{message_queue_len,Qlen},{memory,Mlen},{registered_name, RegName},{messages, _MessageQueue}] ->
%%                 Messages = '',
%%                 %%                      if length(MessageQueue) > 0, Module == mod_player ->
%%                 %%                                 Message_Lists = 
%%                 %%                                 lists:map(
%%                 %%                                       fun({Mclass, Mbody}) ->
%%                 %%                                                       if is_tuple(Mbody) ->
%%                 %% %%                                                                   [Mtype] = lists:sublist(tuple_to_list(Mbody),1),
%%                 %%                                                                      [Mtype, Module1, Method1] = lists:sublist(tuple_to_list(Mbody),3),
%%                 %%                                                                      lists:concat(['            <'
%%                 %%                                                                                               ,Mclass,
%%                 %%                                                                                               ', ' ,Mtype,
%%                 %%                                                                                               ', ',binary_to_list(Module1), 
%%                 %%                                                                                               ', ',binary_to_list(Method1),
%%                 %%                                                                                               '>\t\n']);
%%                 %%                                                         true ->
%%                 %%                                                                      lists:concat(['            <',Mclass,'>\t\n'])
%%                 %%                                                       end
%%                 %%                                       end,
%%                 %%                                 lists:sublist(MessageQueue,5)),                                 
%%                 %%                                 lists:concat(['/\t\n',Message_Lists,'            ']);
%%                 %%                         true -> ''
%%                 %%                      end,
%%                 {Pid, RegName, Mlen, Qlen, Module, Other, Messages};
%%             _ -> 
%%                 {'', '', -1, -1, '', '', ''}
%%         end
%%     catch 
%%         _:_ -> {'', '', -1, -1, '', '', ''}
%%     end.


%% ===================针对玩家的各类操作=====================================
operate_to_player(Module, Method, Args) ->
    %% F = fun(S)->  
    %%             %% io:format("node__/~p/ ~n",[[S, Module, Method, Args]]), 
    %%             rpc:cast(S#server.node, Module, Method, Args)
    %%     end,
    %% [F(S) || S <- ets:tab2list(?ETS_SERVER)],
    ok.

%% 重新加载模块
reload_module(Module_name) ->
    try 
        ResultList = 
            lists:map(
              fun(Node) -> 
                      case rpc:call(Node, c, l, [hmisc:to_atom(Module_name)]) of
                          {module, _Module_name} -> 
                              lists:concat(["(", Node, ") ok. / "]);
                          {error, What} -> 
                              lists:concat(["(", Node, ") error_1[", What , "]. / "]);
                          _ -> 
                              lists:concat(["(", Node, ") error_2.  / "])
                      end
              end, 
              [node() | nodes()]),
        lists:concat([time_misc:time_format(now()), ": " , lists:flatten(ResultList)])
    catch 
        _:_ -> 
            lists:concat([time_misc:time_format(now()), ": reload (", Module_name, ") error_3."])
    end.

%% 设置禁言 或 解除禁言
donttalk(Id, Stop_minutes) ->
    case hmisc:whereis_player_pid(Id) of
        [] ->
            no_action;
        Pid ->
            if
                Stop_minutes > 0 ->
                    Stop_begin_time = time_misc:unixtime(),
                    Stop_chat_minutes = Stop_minutes,
                    gen_server:cast(Pid, {set_donttalk, Stop_begin_time, Stop_chat_minutes}),
                    ok;
               Stop_minutes == 0 ->
                    gen_server:cast(Pid, {set_donttalk, undefined, undefined})
            end
    end.

%% 踢人下线 
kickuser(Id) ->
    case hmisc:whereis_player_pid(Id) of
        [] ->
            no_action;
        Pid ->       
            gen_server:cast(Pid, {stop, ?STOP_REASON_KICK_OUT})
    end.

%% 封/开角色
banrole(Id, Action) ->
    case hmisc:whereis_player_pid(Id) of
        [] -> 
            no_action;
        Pid ->
            if
                Action == 1 ->
                    gen_server:cast(Pid, {update_sg_player, [{status,1}]}),
                    gen_server:cast(Pid, {stop, ?STOP_ACCOUNT_BAND});
                true ->
                    pass
            end
    end.    

%% 通知客户端增减金钱
%% notice_change_money(Id, Action) ->
%%     try
%%         case mod_player:get_player_pid(Id) of
%%             [] ->
%%                 no_action;
%%             Pid ->                       
%%                 [Val1, Val2, Val3, Val4] = string:tokens(Action, "_"),
%%                 Field = case Val1 of
%%                             "gold"  -> 1;
%%                             "coin"  -> 2;
%%                             "cash"  -> 3;
%%                             "bcoin" -> 4;
%%                             _ ->0
%%                         end,
%%                 Optype = case Val2 of
%%                              "add"  -> 1;
%%                              "sub"  -> 2;
%%                              _ ->0
%%                          end,
%%                 Value = list_to_integer(Val3),
%%                 Source = list_to_integer(Val4),
%%                 if
%%                     Field =/=0, Optype =/=0, Value =/=0 ->
%%                         gen_server:cast(Pid, {cmd_player_change_money, [Field, Optype, Value, Source]});
%%                     true ->
%%                         no_action
%%                 end
%%         end
%%     catch
%%         _:_ ->
%%             error
%%     end.

%% 安全退出游戏服务器
%% safe_quit(Node, Socket) ->
%%     ?DEBUG("safe_quit Node:~w~n",[Node]),
%%     case Node of
%%         [] -> 
%%             %% Other_servers = mod_node_interface:server_list_broadcast(),
%%             %%     ?DEBUG("safe_quit Servers:~w~n",[Other_servers]),
%%             %% mod_node_interface:stop_game_server(Other_servers),
%%             %% 调整为 单节点关服
%%             main:server_stop(10),
%%             lib_send:send_one(Socket, hmisc:to_binary(lists:concat(Node,["safe quit ok!"]))),
%%             timer:sleep(1000),
%%             spawn(fun()->
%%                           erlang:halt()
%%                   end),
%%             ok;
%%         _ ->
%%             rpc:cast(hmisc:to_atom(Node), main, server_stop, [])
%%     end,
%%     ok.

%% 动态撤节点
remove_nodes(NodeOrIp) ->
    case NodeOrIp of
        [] -> 
            io:format("You Must Input Ip or NodeName!!!",[]);
        _ ->
            NI_atom = hmisc:to_atom(NodeOrIp),
            NI_str = hmisc:to_list(NodeOrIp),
            case string:tokens(NI_str, "@") of
                [_, _] ->
                    rpc:cast(NI_atom, main, server_remove, []);
                _ ->
                    Server = nodes(),
                    F = fun(S) ->
                                case string:tokens(hmisc:to_list(S), "@") of
                                    [_Left, Right] when Right =:= NI_str ->
                                        rpc:cast(S, main, server_remove, []);
                                    _ ->
                                        ok
                                end
                        end,
                    [F(S) || S <- Server]
            end
    end,
    ok.


%% 请求加载基础数据
%% load_base_data(Parm) ->
%%     Parm_1 = 
%%         case Parm of 
%%             [] -> [];
%%             _ ->                
%%                 [_, ModuleName] = string:tokens(Parm, "="),
%%                 hmisc:to_atom(ModuleName)
%%         end,
%%     ?DEBUG("Parm_1 : ~w~n",[Parm_1]),
%%     %% 关闭全部节点重载
%%     %% mod_node_interface:load_base_data(ets:tab2list(?ETS_SERVER), Parm_1),
%%     case Parm_1 of
%%         all ->
%%             mod_kernel:init_base_data(Parm_1);
%%         Parm_1 ->
%%             mod_kernel:load_base_data(Parm_1)
%%     end,
%%     ok.


%% 获取所有进程的cpu 内存 队列
get_nodes_cmq(_Node,Type)->
    %% L = mod_node_interface:server_list(),
    %% Info_list0 =
    %%     if
    %%         L == [] ->
    %%             [];
    %%         true ->
    %%             lists:map(
    %%               fun(S)  ->
    %%                       case get_nodes_cmq(Type) of
    %%                           {badrpc,_}->
    %%                               [];
    %%                           GetList ->
    %%                               GetList
    %%                       end
    %%               end
    %%               ,L)
    %%     end,

    Info_list0 = [get_nodes_cmq(Type)],

    try
        Info_list = lists:flatten(Info_list0),
        F_sort = fun(A,B)->                                     
                         {_,_,{_K1,V1}}=A,
                         {_,_,{_K2,V2}}=B,
                         V1 > V2
                 end,
        Sort_list = lists:sort(F_sort,Info_list),
        F_print = fun(Ls,Str) ->
                          lists:concat([Str,tuple_to_list(Ls)])
                  end,
        lists:foldl(F_print,[],Sort_list)
    catch _e:_e2 ->
            %%file:write_file("get_nodes_cmq_err.txt",_e2)
            ?DEBUG("_GET_NODES_CMQ_ERR:~p",[[_e,_e2]])
    end.

get_nodes_cmq(Type)->
    A = lists:foldl( 
          fun(P, Acc0) -> 
                  case Type of
                      1 ->
                          [{P, 
                            erlang:process_info(P, registered_name), 
                            erlang:process_info(P, reductions) }
                           | Acc0] ;
                      2 ->
                          [{P,
                            erlang:process_info(P, registered_name), 
                            erlang:process_info(P, memory)}
                           | Acc0] ;
                      3 ->
                          [{P, 
                            erlang:process_info(P, registered_name), 
                            erlang:process_info(P, message_queue_len)} 
                           | Acc0] 
                  end
          end, 
          [], 
          erlang:processes()
         ),
    %%B = io_lib:format("~p", [A]),
    A.

%% 查进程信息    
%% get_porcess_info(Pid_list) ->
%%     L = mod_node_interface:server_list(),
%%     Info_list0 =
%%         if
%%             L == [] ->
%%                 [];
%%             true ->
%%                 %% lists:map(
%%                 %%   fun(S) ->
%%                 %%           case rpc:call(S#server.node,
%%                 %%                         mod_node_interface,
%%                 %%                         get_process_info,
%%                 %%                         [Pid_list]) of
%%                 %%               {badrpc, _} ->
%%                 %%                   [];
%%                 %%               GetList ->
%%                 %%                   GetList
%%                 %%           end
%%                 %%   end, L)
%%                 []
%%         end,
%%     file:write_file("info_1.txt",Info_list0),
%%     Info_list = lists:flatten(Info_list0),
%%     F_print = fun(Ls,Str) ->
%%                       lists:concat([Str,Ls])
%%               end,
%%     lists:foldl(F_print, [],Info_list).

%% close_nodes(Type, Socket) ->
%%     case Type of
%%         2 ->
%%             safe_quit([], Socket);
%%         _ ->
%%             nodes()
%%     end.

%% 后台通知新发的邮件
%% send_new_mail(PlayerId) ->
%%     case hmisc:whereis_player_pid(PlayerId) of
%%         [] ->
%%             pass;
%%         Pid ->
%%             {ok, BinData} = pt_19:write(19005, 1),
%%             gen_server:cast(Pid, {cmd_send_info, BinData})
%%     end,
%%     ok.

send_new_mail(MailString) ->
    spawn(fun() ->
                  ?WARNING_MSG("phpadmin sending mail : ~s~n",[MailString]),
                  {struct, List} = mochijson:decode(MailString),
                  %% ?WARNING_MSG("RET : ~p~n",[RET]),
                  %% {_, State} = lists:keyfind("state", 1, List),
                  %% {_, Type} = lists:keyfind("type", 1, List),
                  %% {_, Timestamp} = lists:keyfind("timestamp", 1, List),
                  %% {_, Sname} = lists:keyfind("sname", 1, List),
                  %% {_, Title} = lists:keyfind("title", 1, List),
                  {_, Content} = lists:keyfind("content", 1, List),
                  {_, Attachment1} = lists:keyfind("attachment1", 1, List),
                  {_, Attachment2} = lists:keyfind("attachment2", 1, List),
                  {_, Attachment3} = lists:keyfind("attachment3", 1, List),
                  {_, Attachment4} = lists:keyfind("attachment4", 1, List),
                  {_, Attachment5} = lists:keyfind("attachment5", 1, List),
                  {_, {array, Uids}} = lists:keyfind("uids", 1, List),
                  ?DEBUG("Uids : ~p~n",[Uids]),
                  DecodedContent = hmisc:url_decode(hmisc:to_list(Content)),
                  SpecialChars = lists:filter(fun(Char) ->
                                                      if
                                                          Char =/= $' -> 
                                                              false;
                                                          true -> 
                                                              true
                                                      end
                                              end, DecodedContent),
                  NewContent = hmisc:to_binary(DecodedContent),
                  FormatAttachment = fun(Attachment) ->
                                             case hmisc:string_to_term(Attachment) of
                                                 [] ->
                                                     {};
                                                 Att ->
                                                     Att
                                                 
                                             end
                                     end,

                  
                  Attachments = [
                                 FormatAttachment(Attachment1),
                                 FormatAttachment(Attachment2),
                                 FormatAttachment(Attachment3),
                                 FormatAttachment(Attachment4),
                                 FormatAttachment(Attachment5)
                                ],
                  %% ?DEBUG("NewContent : ~s~n", [NewContent]),
                  %% Mail = #mails{sname = Sname, type =Type, state = State, timestamp = Timestamp,
                  %%               title = Title, content = NewContent,
                  %%               attachment1 = util:bitstring_to_term(Attachment1),
                  %%               attachment2 = util:bitstring_to_term(Attachment2),
                  %%               attachment3 = util:bitstring_to_term(Attachment3),
                  %%               attachment4 = util:bitstring_to_term(Attachment4),
                  %%               attachment5 = util:bitstring_to_term(Attachment5)
                  %%              },
                  UIDS =
                      lists:foldl(fun("", IDS) -> IDS ;
                                     (ID,  IDS) -> [hmisc:to_integer(ID) | IDS]
                                  end,
                                  [], Uids),
                  ?DEBUG("Uids : ~w~n",[UIDS]),
                  if
                      SpecialChars =/= [] -> 
                          ?WARNING_MSG("Send mail content with ' Content : ~s~n",[DecodedContent]);
                      true -> 
                          lib_mail:send_sys_mail(UIDS, NewContent, Attachments)
                  end
          end).

send_pay_info(Parm) ->
    AccId = hmisc:get_value_pair_tuple(accid, Parm),
    % Sn = tool:to_integer(util:get_value_pair_tuple(sn, ValList)),
    case hdb:dirty_index_read(player, AccId, #player.accid) of
        [] ->
            %% no found
            ?ERROR_MSG("AccId not found: ~s~p", [AccId]);
        [Player] ->
            case hmisc:whereis_player_pid(Player#player.id) of
                [] ->
                    ?ERROR_MSG("New Pay, Player Not Online", []),
                    skip;
                Pid ->
                    gen_server:cast(Pid, cmd_new_pay_info)
            end
    end.

%% 获取负载
get_system_load() ->
    %% 全局进程缺省负载权重
    Load_fact = 10,
    Global_load =	
        case ets:match(?ETS_MONITOR_PID, {'_', global ,'$3'}) of
            [] ->
                0;
            Global_list ->
                Global_load_list = 
                    lists:map( 
                      fun([P]) ->
                              case P of
                                  {_Module, _WorkerNumber, WeightLoad} -> 
                                      WeightLoad;
                                  _ ->
                                      Load_fact
                              end
                      end, Global_list),
                case Global_load_list of
                    [] ->
                        0;
                    _ ->
                        lists:sum(Global_load_list)
                end
        end,
    ScenePlayerCount = 0,
    ConnectionCount = 0,
    Player_Load = 
        try
            ScenePlayerCount / 50 + ConnectionCount / 10
        catch 
            _:_ ->
                0
        end,			
    time_misc:cpu_time() + Global_load + Player_Load.
%% update_server_state() ->
%%     try
%%         case lib_http_client:get(config:get_server_list_url()) of
%%             {ok, _Status, _ResponseHeaders, Body} ->                
%%                 ?DEBUG("~ts~n", [Body]),
%%                 Sn = config:get_one_server_no(),                
%%                 ServerList = string:tokens(Body, ";"),
%%                 {ServerState, ServerNameList} = 
%%                     lists:foldl(fun(Server, {Ans, AccServerNameList}) ->
%%                                         %% 1,1,一将功成,s1.fhzs.4399sy.com,8802,fhzs-cdnres.me4399.com/resources/20130603/,0;
%%                                         L = string:tokens(Server, ","),
%%                                         ServerId = lists:nth(2, L),
%%                                         TimeToServe = lists:last(L),                                        
%%                                         NewAns = 
%%                                             case hmisc:to_integer(ServerId) of
%%                                                 Sn ->
%%                                                     ?WARNING_MSG("Find Server~n", []),
%%                                                     hmisc:to_integer(TimeToServe);
%%                                                 _ ->
%%                                                     Ans
%%                                             end,
%%                                         ServerName = lists:nth(3, L),
%%                                         {NewAns, 
%%                                          [{hmisc:to_integer(ServerId), 
%%                                            ServerName} | AccServerNameList]}
%%                                 end, {0, []}, ServerList),
%%                 ?WARNING_MSG("ServerState ~w", [ServerState]),
%%                 lib_syssetting:put_game_data(server_state, Sn, ServerState),
%%                 lib_syssetting:put_game_data(server_name_list, Sn, ServerNameList);
%%             Other ->
%%                 ?WARNING_MSG("update_server_state error, ~w~n", [Other])
%%         end
%%     catch _:R ->
%%             ?DEBUG("http_client request ~p, get_stacktrace ~p~n", 
%%                    [R, erlang:get_stacktrace()]),
%%             false
%%     end.

inner_check_apply_string(String) ->
    string:sub_string(String, 1, 10) =:= "lib_op:op_".

