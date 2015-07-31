
-module(pt_51).
%% -export([write/2]).

%% -include("common.hrl").
%% -include("define_treasure.hrl").
%% -include("define_info_51.hrl").
%% -include("pb_51_pb.hrl").
%% -include("db_base_treasure.hrl").
%% -include("db_treasure.hrl").

%% %% 获取玩家装备的宝物数据
%% write(51001, PlayerId) ->
%%     write(51006,
%%           #pbtreasurelistupdate{
%%              treasure_list_update = lib_treasure:get_treasure_equip_proto_list(
%%                                       PlayerId, ?USER_TYPE_USER, undefined)});
%% %% 获取伙伴装备的宝物数据
%% write(51004, PartnerId) ->
%%     write(51006,
%%           #pbtreasurelistupdate{
%%              treasure_list_update = lib_treasure:get_treasure_equip_proto_list(
%%                                       PartnerId, ?USER_TYPE_PARTNER, PartnerId)});

%% %% 打包包裹中的宝物数据
%% write(51002, PlayerId) ->
%%     %% 根据 playerid 获取寻宝信息
%%     case lib_treasure:get_treasure_info_by_player_id(PlayerId) of
%%         [] ->
%%             lib_send:send_info(PlayerId, ?INFO_TREASURE_INQUIRE_BAG_FAILED),
%%             %% 必须返回一个 {ok, BinData} 结构
%%             pt:pack(51002, null);
%%         TreasureInfo ->
%%             pt:pack(51006,
%%                     #pbtreasurelistupdate{
%%                        treasure_list_update = 
%%                            lists:map(
%%                              fun(CeilInfo) ->
%%                                      #pbtreasure{
%%                                         player_id = PlayerId,
%%                                         container = ?BAG_LOCATION,
%%                                         position = CeilInfo#ceil_state.pos,
%%                                         state = CeilInfo#ceil_state.state,
%%                                         id = CeilInfo#ceil_state.id,
%%                                         level = CeilInfo#ceil_state.lv,
%%                                         exp = CeilInfo#ceil_state.exp
%%                                        }
%%                              end, 
%%                              TreasureInfo#ets_treasure.treasure_bag)
%%                       })
%%     end;


%% %% 51003协议，获取寻宝列表
%% write(51003, Data) ->
%%     ?DEBUG_TREA("Data:~w~n",[Data]),
%% 	pt:pack(51003, Data);

%% write(51005, {Id, Type}) ->
%%     pt:pack(51005, #pbtreasurelist{
%%                       id = Id,
%%                       type = Type,
%%                       power = lib_treasure:get_treasure_power(Id, Type)
%%                      });

%% %% 打包寻宝背包数据信息
%% write(51006, UpdateData) ->
%%     pt:pack(51006, UpdateData);


%% %% 进行一次寻宝的寻宝结果
%% write(51007, {Treasure, Pos}) ->
%%     %% 打包宝物 id 以及所处 temp 中的位置信息
%% 	pt:pack(51006, #pbtreasurelistupdate{
%%                       treasure_list_update = 
%%                           [#pbtreasure{
%%                               container = ?TEMP_LOCATION,
%%                               id = Treasure#ets_base_treasure.id,
%%                               level = Treasure#ets_base_treasure.lvl,
%%                               exp = lib_treasure:get_treasure_exp_by_quality(
%%                                       Treasure#ets_base_treasure.color),
%%                               position = Pos}]
%%                      });

%% %% 一键寻宝秘籍
%% write(51008, [_Result, Drops])->
%% 	TempList = lists:map(
%%                  fun(E)->
%%                          #pbtreasure{
%%                             id = E#ceil_temp.id,
%%                             position = E#ceil_temp.pos
%%                            }
%%                  end, Drops),
%% 	pt:pack(51008, #pbtreasurelist{
%%                       temp_list = TempList
%%                      });

%% %% %%装备心法
%% %% write(51009, [Result, CeilState, UseState])->
%% %% 	{ok, pt:pack(51009,<<Result:8,
%% %% 						 (UseState#use_state.pos):8, 
%% %% 						 (UseState#use_state.mind_id):32,
%% %% 						 (UseState#use_state.mind_lv):8,
%% %% 						 (CeilState#ceil_state.pos):8,
%% %% 						 (CeilState#ceil_state.mind_id):32,
%% %% 						 (CeilState#ceil_state.lv):8>>)};

%% %% 扩展背包
%% write(51010, [_Result]) ->
%% 	pt:pack(51010, null);

%% %% 获取临时背包
%% write(51011, [List])->
%%     %% 记录临时背包中的宝物数据信息
%% 	TempList = lists:map(fun(Treasure) ->
%%                                  #pbtreasure{
%%                                     position = Treasure#ceil_temp.pos,
%%                                     id = Treasure#ceil_temp.id}
%%                          end, List),
%% 	pt:pack(51011, #pbtreasurelist{temp_list = TempList});

%% %% 拾取
%% write(51012, [_Result, BagPos, MindId])->
%% 	pt:pack(51012, #pbtreasure{
%%                       position = BagPos, 
%%                       id = MindId});
	
%% %% 一键拾取
%% write(51013, [_Result, ResultList]) ->
%%     %% 此处借用container作为源点的位置，不推荐
%% 	BagList = lists:map(fun({TempBagPos, BagPos, MindId}) ->
%%                                 #pbtreasure{
%%                                    container = TempBagPos,
%%                                    position = BagPos,
%%                                    id = MindId
%%                                   }
%%                         end, ResultList),
%% 	pt:pack(51013, #pbtreasurelist{bag_list = BagList});
  
%% %% %% 装备协议
%% %% write(51014, [Result, CeilState, UseState])->
%% %% 	{ok, pt:pack(51014,<<Result:8,
%% %% 						 (UseState#use_state.pos):8, 
%% %% 						 (UseState#use_state.mind_id):32,
%% %% 						 (UseState#use_state.mind_lv):8,
%% %% 						 (CeilState#ceil_state.pos):8,
%% %% 						 (CeilState#ceil_state.mind_id):32,
%% %% 						 (CeilState#ceil_state.lv):8>>)};

%% %% 交换位置
%% write(51015, [_Result, _PosType, _RoleType, _RoleId, _SrcPos, _SrcPosMind, _SrcLv, 
%%               _DestPos, _DestPosMind, _DestLv]) ->
%% 	pt:pack(51015, #pbtreasureexchange{
%%                      });

%% write(51016, PBData) ->
%%     pt:pack(51016, PBData);

%% %% 错误的信息，抛出异常
%% write(Cmd, _R) ->
%% 	?ERROR_MSG("~s_errorcmd_[~p] ", [misc:time_format(misc_timer:now()), Cmd]),
%%     pt:pack(0, null).

%% %% to_pbtreasure(EquipState) 
%% %%   when is_record(EquipState, equip_state) ->
%% %%     #pbtreasure{};
%% %% to_pbtreasure(Other) ->
%% %%     ?WARNING_MSG("~nNot matched: ~w~n", [Other]),
%% %%     #pbtreasure{}.

