-module(server_state_handler).
-include("define_player.hrl").
-include("define_goods_rec.hrl").
-include("define_logger.hrl").
-export([state_get_player/1,
         state_get_bag/1]).

%%API
state_get_player(PlayerId) ->
    Player = 
        case hmisc:whereis_player_pid(PlayerId) of
            [] ->
                hdb:dirty_read(player, PlayerId);
            Pid ->
                gen_server:call(Pid, cmd_player)
        end,
    if
        Player =:= [] ->
            {fail, <<"不存在的玩家"/utf8>>};
        true ->
            Json = record_to_json(Player, player),
            jiffy:encode([Json], [pretty])
    end.

state_get_bag(PlayerId) ->
    GoodsList = 
        case hmisc:whereis_player_pid(PlayerId) of
            [] ->
                lib_goods:role_login(PlayerId);
            _ ->
                {_Player, Bag, _, _Mugen} = 
                    lib_player:get_other_player_detail(PlayerId),
                Bag
        end,
    JsonList = 
        lists:map(fun(Goods) ->
                          record_to_json(Goods, goods)     
                  end, GoodsList),
    jiffy:encode(JsonList, [pretty]).

record_to_json(Player, player) ->
    Fields = record_info(fields, player),
    [_|Values] = tuple_to_list(handle_db_data(Player)),
    record_to_json2(Fields, transform(Values));
record_to_json(Goods, goods) ->
    Fields = record_info(fields, goods),
    [_|Values] = tuple_to_list(Goods),
    record_to_json2(Fields, transform(Values)).

record_to_json2(Fields, Values)->
    {lists:zip(Fields, Values)}.
%%数据格式要转
%%{a,1} => <<"{a, 1}">>
%%[1,2] => <<"[1,2]">>
%%"abc123" 这种要在hangle_db_data中另外用to_binary转
transform(Values) ->
    lists:map(fun
                  (Val) when is_tuple(Val) -> 
                      hmisc:term_to_bitstring(Val);
                  (Val) when is_list(Val) ->
                      hmisc:term_to_bitstring(Val);
                  (Other) ->
                      Other
              end, Values).

handle_db_data(Player) ->
    Player#player{
      %nickname = Player#player.nickname,
      accid = hmisc:to_binary(Player#player.accid),
      accname = hmisc:to_binary(Player#player.accname)
     }.

