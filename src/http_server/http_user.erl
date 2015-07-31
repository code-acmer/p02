-module(http_user).
-include("define_player.hrl").
-include("define_logger.hrl").
-include("define_goods.hrl").

-export([get_player_by_id/1,
         get_player_skill/1,
         get_instance_info/1,
         get_server_player/1,
         transform/1
        ]).



%%API
get_player_by_id(KeyValues) ->
    case check_player_id(KeyValues) of
        fail ->
            {fail, <<"[]">>};
        {ok, PlayerId} ->
            case lib_player:get_other_player_detail(PlayerId) of  %%之后会加上session验证
                [] ->
                    ?WARNING_MSG("player data not found ~p~n", [PlayerId]),
                    {fail, <<"[]">>};
                {Player, GoodsList, _, _, _} ->
                    PlayerJson = record_to_json(Player, player),
                    SwearedFashions = lists:foldl(fun(Goods, RET) ->
                                                          case Goods#goods.container =:= ?CONTAINER_EQUIP andalso 
                                                              Goods#goods.type =:= ?TYPE_GOODS_FAHSION of
                                                              true ->
                                                                  [record_to_json(Goods, goods)|RET];
                                                              _ ->
                                                                  RET
                                                          end
                                                  end, [], GoodsList),
                    Json = record_to_json(#player_response{player  = PlayerJson,
                                                           fashion = SwearedFashions
                                                          }, player_response),
                    ?DEBUG("Json:~p~n",[Json]),
                    %% jiffy:encode([Json], [pretty])
                    %% rfc4627:encode({obj, Json})
                    rfc4627:encode(Json)
            end
    end.

get_player_skill(KeyValues) ->
    case check_player_id(KeyValues) of
        {fail, Return} ->
            {fail, Return};
        {ok, PlayerId} ->
            case lib_player:get_all_player_skill_from_db(PlayerId) of
                [] ->
                    <<"[]">>;
                SkillList ->
                    JsonList = 
                        lists:map(fun(Skill) ->
                                          record_to_json(Skill, player_skill)   
                                  end, SkillList),
                    %% jiffy:encode(JsonList, [pretty])
                    rfc4627:encode(JsonList)
            end
    end.

get_instance_info(KeyValues) ->
    ?DEBUG("KeyValues ~p~n", [KeyValues]),
    case inner_get_key_values([<<"instanceId">>, <<"subDungeonId">>, <<"invalid">>], KeyValues, []) of
        [InstanceId, SubDungeonId, Invalid] 
          when InstanceId =/= <<>>,
               SubDungeonId =/= <<>> ->
            lib_dungeon_match:instance_info(binary_to_integer(InstanceId), 
                                            binary_to_integer(SubDungeonId), 
                                            list_to_atom(binary_to_list(Invalid))),
            %% jiffy:encode({[{result, true}]}, [pretty]);
            rfc4627:encode({obj, [{result, true}]});
        Other ->
            ?WARNING_MSG("Other ~p~n", [Other]),
            {fail, <<"{result : false}">>}
    end.

get_server_player(KeyValues) ->
    case inner_get_key_values([<<"accid">>], KeyValues, []) of
        [AccIdBin] when AccIdBin =/= <<>> ->
            case catch binary_to_list(AccIdBin) of
                AccId 
                  %% when is_integer(AccId)
                       ->
                    get_server_player2(hdb:dirty_index_read(player, AccId, #player.accid, true));
                Other ->
                    ?WARNING_MSG("Other ~p~n", [Other]),
                    {fail, <<"{result : false}">>}
            end;
        Other ->
            ?WARNING_MSG("Other ~p~n", [Other]),
            {fail, <<"{result : false}">>}
    end.

get_server_player2(PlayerList) ->
    %% PlayerInfoList = 
    %%     dict:to_list(
    %%       lists:foldl(fun(#player{sn = Sn}, Dict) ->
    %%                           dict:update_counter(Sn, 1, Dict)
    %%                   end, dict:new(), PlayerList)),
    %% jiffy:encode(PlayerInfoList, [pretty]).
    JsonList= lists:map(fun(Item) ->
                                TableName = element(1, Item),
                                Fields = all_record:get_fields(TableName),
                                {obj, lists:zip(Fields, http_user:transform(lists:nthtail(1,tuple_to_list(Item))))}
                        end, PlayerList),
    {ok, rfc4627:encode(JsonList)}.
    



%%----------------------------------------------------------------
check_player_id(KeyValues) ->
    case check_value_valid(<<"player_id">>, KeyValues) of
        {ok, PlayerId} ->
            case check_value_valid(<<"session">>, KeyValues) of
                undefined ->
                    {ok, PlayerId};
                {ok, Sesssion} ->
                    {TSession, _SessionTimestamp} = mod_player:get_session(PlayerId),
                    case Sesssion =:= TSession of
                        true ->
                            {ok, PlayerId};
                        _ ->
                            ?WARNING_MSG("invalid session ~p TSession ~p~n", [Sesssion, TSession]),
                            fail
                    end;
                _ ->
                    fail
            end;
        _ ->
            fail
    end.

check_value_valid(Value, KeyValues) ->
    case proplists:get_value(Value, KeyValues) of
        undefined ->
            %?WARNING_MSG("http not recv value ~s~n", [binary_to_list(Value)]),
            undefined;
        Bin ->
            case catch binary_to_integer(Bin) of
                Val when is_integer(Val) ->
                    {ok, Val};
                _ ->
                    ?WARNING_MSG("invalid value ~p~n", [Bin]),
                    fail
            end
    end.

record_to_json(Player, player) ->
    Fields = record_info(fields, player),
    [_|Values] = tuple_to_list(handle_db_data(Player)),
    record_to_json2(Fields, transform(Values));
record_to_json(Goods, goods) ->
    Fields = record_info(fields, goods),
    [_|Values] = tuple_to_list(Goods),
    record_to_json2(Fields, transform(Values));
record_to_json(PlayerResponse, player_response) ->
    Fields = record_info(fields, player_response),
    [_|Values] = tuple_to_list(PlayerResponse),
    record_to_json2(Fields, transform(Values));
record_to_json(PlayerSkill, player_skill) ->
    Fields = record_info(fields, player_skill),
    [_|Values] = tuple_to_list(PlayerSkill),
    %?WARNING_MSG("Values ~p~n", [Values]),
    record_to_json2(Fields, transform(Values)).

record_to_json2(Fields, Values)->
    {obj, lists:zip(Fields, Values)}.
%%数据格式要转
%%{a,1} => <<"{a, 1}">>
%%[1,2] => <<"[1,2]">>
%%"abc123" 这种要在hangle_db_data中另外用to_binary转
transform(Values) ->
    lists:map(fun
                  ({obj, _Val} = Obj) ->
                     Obj;
                  ([{obj,_}|_] = Obj) ->
                      Obj;
                  ([]) ->
                      [];
                  (Val) when is_tuple(Val) -> 
                      hmisc:term_to_bitstring(Val);
                  (Val) when is_list(Val) ->
                      hmisc:term_to_bitstring(Val);
                  (Other) ->
                      Other
              end, Values).

handle_db_data(Player) ->
    Player#player{
      nickname = Player#player.nickname,
      accid = hmisc:to_binary(Player#player.accid),
      accname = hmisc:to_binary(Player#player.accname)
     }.

inner_get_key_values([], _KeyValues, AccValues) ->
    lists:reverse(AccValues);
inner_get_key_values([Key|Tail], KeyValues, AccValues) ->
    case proplists:get_value(Key, KeyValues) of
        undefined ->
            false;
        Value ->
            inner_get_key_values(Tail, KeyValues, [Value|AccValues])
    end.
