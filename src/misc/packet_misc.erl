%% 将包put到玩家进程的进程字段去
-module(packet_misc).
-export([put_packet/1, send_packet/3, send_packet/1]).
-export([put_info/1]).
-export([send_change/3]).

%% 暂时for战斗PVP或者网关模块发包
-export([directly_send_packet/3, directly_send_packet/4]).
-export([directly_send_info/4, directly_send_info/3]).

-export([directly_send_packet_list/2]).

-export([send/2]).


-include("pb_9_pb.hrl").
-include("common.hrl").
-include("db_base_error_list.hrl").

-define(UPDATE(Key, Default, Var, Expr),
        begin
            %% We deliberately allow Var to escape from the case here
            %% to be used in Expr. Any temporary var we introduced
            %% would also escape, and might conflict.
            case get(Key) of
                undefined -> Var = Default;
                Var       -> ok
            end,
            put(Key, Expr)
        end).

packet(Packet) ->
    [<<(iolist_size(Packet)):16>>, Packet].
    
put_packet(Packet) ->
    ?UPDATE(tcp_send_packet, [], Packets, [packet(Packet) | Packets]).


put_info(Info) when is_integer(Info)->
    put_packet(info_bin(Info)).

info_bin(Info) ->
    %% ?DEBUG("~p ~ts~n", [Info, case data_base_error_list:get(Info) of
    %%                               #base_error_list{
    %%                                  error_desc = ErrorDesc
    %%                                 } ->
    %%                                   ErrorDesc;
    %%                               [] ->
    %%                                   <<"没导入的错误码"/utf8>>
    %%                           end
    %%                    ]),
    {ok, BinData} = pt:pack(9001, #pberror{error_code = Info}),
    BinData.

get_packet(Cmd, F) ->
    case erase(tcp_send_packet) of
        undefined ->
            undefined;
        Bin ->
            [<<Cmd:16, F:8>>, Bin]
    end.

%% 主动发给客户端
send_packet(undefined) ->
    erase(tcp_send_packet);
send_packet(Pid) ->
    send_packet(0, 0, Pid).

%% for mod_player process
%%暂时先不考虑要一起发的问题
send_packet(_, _, undefined) ->
    ignore;
send_packet(Cmd, F, ClientPid) when is_pid(ClientPid) ->
    case get_packet(Cmd, F) of
        undefined ->
            if
                Cmd =:= 0 ->
                    ignore;
                true ->
                    NBin = [<<Cmd:16, F:8>>, <<>>],
                    tcp_client_handler:send(ClientPid, NBin),
                    {ok, NBin}
            end;
        Bin ->
            %?DEBUG("Bin ~p~n", [Bin]),
            tcp_client_handler:send(ClientPid, Bin),
            {ok, Bin}
    end;

%% for tcp_client_handler process
send_packet(Cmd, F, Socket) when is_port(Socket) ->
    case get_packet(Cmd, F) of
        undefined ->
            ignore;
        Bin ->
            ?DEBUG("Bin ~p, size ~p~n", [iolist_to_binary(Bin), iolist_size(Bin)]),
            send(Socket, Bin)
    end.

send(Socket, Data) ->
    ?DEBUG("Socket ~p~n", [Socket]),
    case gen_tcp:send(Socket, Data) of
        ok ->
            ?DEBUG("SendData Success Total Size ~w bytes ~n", [iolist_size(Data)]),
            keep_alive;
        {error, Reason} ->
            ?WARNING_MSG("send_one_error, Reason ~p, Socket ~p~n", [Reason, Socket]),
            shutdown
    end.

%% 直接发，暂时只会一个包
directly_send_packet(Pid, F, Bin) ->
    directly_send_packet(Pid, 0, F, Bin).

directly_send_info(Pid, F, Info) ->
    directly_send_info(Pid, 0, F, Info).

directly_send_packet(Pid, Cmd, F, Bin) 
  when is_pid(Pid) ->
    tcp_client_handler:send(Pid, [<<Cmd:16, F:8>>, packet(Bin)]);
directly_send_packet(Socket, Cmd, F, Bin) 
  when is_port(Socket) ->
    send(Socket, [<<Cmd:16, F:8>>, packet(Bin)]);
directly_send_packet(_, _, _, _) ->
    skip.

directly_send_info(Pid, Cmd, F, Info) 
  when is_integer(Info), is_pid(Pid)->
    tcp_client_handler:send(Pid, [<<Cmd:16, F:8>>, packet(info_bin(Info))]);
directly_send_info(Socket, Cmd, F, Info) 
  when is_integer(Info), is_port(Socket)->
    directly_send_packet(Socket, Cmd, F, info_bin(Info)).


directly_send_packet_list(Pid, BinList) ->
    tcp_client_handler:send(Pid, [<<0:16, 0:8>>| [packet(Bin) || Bin <- BinList]]).

%% 潜规则，第一个字段是Key
send_change(AddOrUpdateList, DelList, FunPacket) ->
    ChangedList = 
        lists:foldl(fun ({OldRecord, NewRecord}, Acc) ->
                            case record_misc:record_modified(OldRecord, NewRecord) of
                                [] ->
                                    Acc;
                                Changed ->
                                    [setelement(2, Changed, element(2, NewRecord)) | Acc]
                            end;
                        (NewRecord, Acc) ->
                            [NewRecord | Acc]
                    end, [], AddOrUpdateList),

    NewDelList = lists:map(fun (Record) 
                                 when is_tuple(Record) ->
                                   element(2, Record);
                               (Id) 
                                 when is_integer(Id)->
                                   Id
                           end, DelList),

    if 
        ChangedList =:= [] andalso
        NewDelList =:= [] ->
            %% 没有变更就不发消息
            ignore;
        true ->
            packet_misc:put_packet(FunPacket(ChangedList, NewDelList))
    end.
