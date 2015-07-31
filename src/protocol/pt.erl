%%%-----------------------------------
%%% @Module  : pt
%%% @Created : 2010.10.05
%%% @Description: 协议公共函数
%%%-----------------------------------
-module(pt).
-export([
         routing/1,
         unpack/2,
         unpack_client/1,
         unpack_client/2,
         pack/2,
         pack_client/2,
         pack_client/4
        ]).

-include("define_logger.hrl").
-include("define_server.hrl").
-include("pb_9_pb.hrl").
-include("pb_10_pb.hrl").
-include("db_base_error_list.hrl").
-include("db_base_protocol.hrl").
%% 路由信息，根据Cmd获取protobuf处理module和回调module
routing(Cmd) ->
    case Cmd div 1000 of
        %% 路由到指定的Module名
        9 ->
            {pb_9_pb, pp_base};
        10 -> 
            {pb_10_pb, pp_account};
        11 ->
            {pb_11_pb, pp_chat};
        12 ->
            {pb_12_pb, pp_dungeon};
        13 ->
            {pb_13_pb, pp_player};
        14 ->
            {pb_14_pb, pp_relationship};
        15 ->
            {pb_15_pb, pp_goods};
        16 ->
            {pb_16_pb, pp_fashion};
        17 ->
            {pb_17_pb, pp_boss};
        19 ->
            {pb_19_pb, pp_mail};
        23 ->
            {pb_23_pb, pp_arena};
        24 ->
            {pb_24_pb, pp_rank};
        30 ->
            {pb_30_pb, pp_task};
        32 ->
            {pb_32_pb, pp_achieve};
        34 ->
            {pb_34_pb, pp_activity};
        40 ->
            {pb_40_pb, pp_league};
        44 ->
            {pb_44_pb, pp_camp};
        51 ->
            {pb_51_pb, pp_treasure};
        52 ->
            {pb_52_pb, pp_boss};
        55 ->
            {pb_55_pb, pp_combat};
        _ ->
            error
    end.

%% 解包信息
%% unpack(_Cmd, null) ->
%%     %% 对于null输入，直接返回空的字符串
%%     {ok, <<>>};
%% unpack(_Cmd, <<>>) ->
%%     %% 对于<<>>输入，直接返回空的字符串
%%     {ok, <<>>};
unpack_client(<<>>) ->
    [];
unpack_client(<<Len:16, Cmd:16, RestBinary/binary>>) ->
    BinSize = Len - 2,
    <<Bin:BinSize/binary, PbBin/binary>> = RestBinary,
    if
        Cmd =:= 10100 ->
            PbInfo = unpack_client(Cmd, Bin, PbBin),            
            [{Cmd, PbRecord}] = PbInfo,
            SPub = PbRecord#pbrc4.pub,
            {P, G, _CPub, CPri} = get(rc4_info),
            S = crypto:compute_key(dh, SPub, CPri, [P, G]),
            RC4 = crypto:stream_init(rc4, S),
            {rc4, _RC4Bin} = RC4,
            %% io:format("RC4 : ~p~n",[bin_to_hex:bin_to_hex(RC4Bin)]),
            put(rc4_key, RC4),
            io:format("PbRecord: ~p~n", [PbRecord]),
            PbInfo;
        Cmd =:= 9009 ->
            unpack_client(Cmd, Bin, PbBin);
        (Cmd div 1000) =:= 11 orelse (Cmd div 1000) =:= 17 ->
            unpack_client(Cmd, Bin, PbBin);
        Cmd =:= 13208 orelse Cmd =:= 13205 ->
            unpack_client(Cmd, Bin, PbBin);
        true ->
            RC4 = get(rc4_key),
            {_NewRC4, NBin} = crypto:stream_decrypt(RC4, Bin),
            unpack_client(Cmd, NBin, PbBin)
    end.

unpack_client(Cmd, Bin, PbBin) ->
    case unpack_client(Cmd, Bin) of
        {ok, Rec} ->
            [{Cmd, Rec}|unpack_client(PbBin)];
        _ ->
            ?WARNING_MSG("Cmd unpack error ~p~n", [Cmd]),
            unpack_client(PbBin)
    end.

unpack(Cmd, Binary) ->
    ?DEBUG("Cmd  ~p ~n",[Cmd]),
    case routing(Cmd) of
        error ->
            ?DEBUG(" Ma Dan Cmd ~p~n", [Cmd]),
            {error, <<>>};
        {DecodeModule, _} ->
            case data_base_protocol:get(Cmd) of
                [] ->
                    ?DEBUG("data_base_protocol !!! ~n"),
                    {error, <<>>};
                #ets_base_protocol{
                   c2s = null
                  } when Binary =:= <<>> ->
                    {ok, <<>>};
                #ets_base_protocol{
                   c2s = Type
                  } ->
                    {ok, DecodeModule:decode(Type, Binary)}
            end
    end.


%% 解包信息
unpack_client(Cmd, Binary) ->
    case routing(Cmd) of
        error ->
            {error, <<>>};
        {DecodeModule, _} ->
            case lib_protocol:get_decode_client_type_by_id(Cmd) of
                null ->
                    {ok, <<>>};
                Type ->
                    {ok, DecodeModule:decode(Type, Binary)}
            end
    end.

%% 打包信息，添加消息头
pack(Cmd, <<>>) ->
    %% 空数据只有消息头
    ?DEBUG("pack cmd null : ~p~n",[Cmd]),
    {ok, <<Cmd:16>>};
pack(Cmd, null) ->
    %% 空数据只有消息头
    pack(Cmd, <<>>);
pack(Cmd, []) ->
    %% 空列表数据
    pack(Cmd, <<>>);
pack(Cmd, Data) ->
    %% 非空数据需要根据对应的协议module来打包信息
    %% spawn(fun()-> 
    %%               pack_stat(Cmd)
    %%       end),
    try
        %% 打包数据，消息长度2个字节，协议号2个字节，共计4个字节
        {EncodeModule, _} = routing(Cmd),
        %?DEBUG("EncodeModule ~w~n", [EncodeModule]),
        %% 调用指定的打包接口打包二进制数据
        PbData = case Cmd of
                     55001 ->                        
                         %% PbBin = EncodeModule:encode(Data),
                         %% io:format("Before compress : ~w~n",[byte_size(PbBin)]),
                         %% ?DEBUG("fight report zipdata : ~w ~n",[ZData]),
                         %% ?DEBUG("Size of ZData : ~w~n",[byte_size(ZData)]),
                         zlib:compress(EncodeModule:encode(Data));
                     _ ->
                         EncodeModule:encode(Data)
                 end,
        NewPbData = case Cmd of
                        Cmd when Cmd =:= 10100 orelse
                                 Cmd =:= 13208 orelse 
                                 Cmd =:= 13205 ->
                            PbData;
                        Cmd when (Cmd div 1000) =:= 11 orelse %% 聊天
                                 (Cmd div 1000) =:= 17 ->     %% BOSS
                            PbData;
                        _ ->                            
                            RC4 = get(rc4_key),
                            %% ?DEBUG("encrypting...Cmd : ~p Using RC4 : ~p~n", [Cmd, RC4]),
                            {_NewRC4, EncryptPbData}= crypto:stream_encrypt(RC4, PbData),
                            EncryptPbData
                    end,
        %% ?DEBUG("pack ~w: ~w    =>~w~n.", [Cmd, short_record(Data), PbData]),
        if
            Cmd =:= 9001, is_record(Data, pberror) ->
                case data_base_error_list:get(Data#pberror.error_code) of
                    [] ->
                        skip;
                    #base_error_list{error_desc = Desc} ->
                        ?DEBUG("pack ~w: ~ts~n", [Cmd, Desc]),
                        ?DEBUG("Cmd :~w size : ~w bytes~n",[Cmd, iolist_size(PbData)])
                end;
            true ->
                %?DEBUG("pack ~w: ~w~n", [Cmd, short_record(Data)]),
                ?DEBUG("pack ~p: ~p~n", [Cmd, all_record:pr(Data)]),
                ?DEBUG("Cmd :~w size : ~w bytes~n",[Cmd, iolist_size(PbData)])
        end,
        {ok, [<<Cmd:16>> | NewPbData]}
    catch
        _:_ ->
            %% 打包失败，记录日志并返回空的协议消息
            ?WARNING_MSG("pack error: ~p.~n", [erlang:get_stacktrace()]),
            {ok, <<Cmd:16>>}
    end.

pack_client(Cmd, Data) ->
    pack_client(Cmd, 987654321, 123456789, Data).
pack_client(Cmd, PlayerId, Session, <<>>) ->
    if
        Cmd =:= 10100 ->
            pack_client(Cmd, PlayerId, Session, 10100);
        true ->
            R = hmisc:rand(1, 127),
            {ok, <<PlayerId:32, Session:32, Cmd:16, R:8>>}
    end;

pack_client(Cmd, PlayerId, Session, null) ->
    pack_client(Cmd, PlayerId, Session, <<>>);
pack_client(Cmd, PlayerId, Session, []) ->
    pack_client(Cmd, PlayerId, Session, <<>>);
pack_client(Cmd, PlayerId, Session, Data) ->
    R = hmisc:rand(1, 127),
    try
        {EncodeModule, _} = routing(Cmd),
        PbData = 
            if
                Cmd =:= 10100 ->
                    {P, G, PubClient, _PriClient} = get(rc4_info),
                    ?DEBUG("info: ~p ~n", [{P, G, PubClient, _PriClient}]),
                    EncodeModule:encode(#pbrc4{p = P,  %% P是一个大素数
                                               g = G,  %% G是素数的原根
                                               pub = PubClient %% CPub = G^CPri mod P 
                                              });
                Cmd =/= 13205  andalso Cmd =/= 13208 andalso
                (Cmd div 1000 =/= 11) andalso (Cmd div 1000 =/= 17) -> 
                    RC4 = get(rc4_key),
                    %% ?DEBUG("encrypting...Cmd : ~p Using RC4 : ~p~n", [Cmd, RC4]),
                    Pbdata = EncodeModule:encode(Data),
                    {_NewRC4, EncryptPbData}= crypto:stream_encrypt(RC4, Pbdata),
                    EncryptPbData;
                true ->
                    EncodeModule:encode(Data)
            end,
        %% ?DEBUG("pack client: ~p~n >>> ~p~n", [Data, PbData]),
        {ok, [<<PlayerId:32, Session:32, Cmd:16, R:8>> | PbData]}
    catch
        _:_ ->
            %% 打包失败，记录日志并返回空的协议消息
            ?PRINT("pack error: ~p.~n", [erlang:get_stacktrace()]),
            {ok, <<987654321:32, 123456789:32, Cmd:16, R:8>>}
    end.


short_record(Record) ->
    list_to_tuple(lists:reverse(
                    lists:foldl(fun
                                    ([], Acc) ->
                                       Acc;
                                    (undefined, Acc) ->
                                       Acc;
                                    (X, Acc) ->
                                       [X|Acc]
                               end, [], tuple_to_list(Record)))).
