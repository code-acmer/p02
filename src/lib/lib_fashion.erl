-module(lib_fashion).
-export([%get_fashion_list/2, 
         activate_fashion/1,
         change_fashion/3,
         save/1,
         role_login/1,
         init_player_fashion/1]).

%% 内部使用，清理数据
-export([delete_fashions_by_player_id/1]).

-include("db_base_fashion.hrl").
-include("define_fashion.hrl").
-include("define_player.hrl").
-include("define_info_16.hrl").
-include("define_logger.hrl").

%% get_fashion_list(Player,ModPlayerState) ->
%%     activate_fashion(Player,ModPlayerState). %% TODO 充值加了接口，就可以注释掉
    

%% 激活时装

activate_fashion(#mod_player_state{
                    player = Player
                   } = ModPlayerState) ->
    FashionList = data_base_fashion:get_career_fashion(Player#player.career),
    {FashionIds,NewModPlayerState} = 
        lists:foldl(
            fun(Id, {AccFashionIds, AccModPlayerState}=AccIn) -> 
                    Fashion = data_base_fashion:get(Id),
                    case (Player#player.total_gold   >= Fashion#data_base_fashion.price) andalso 
                        (Player#player.last_fashion < Fashion#data_base_fashion.id) of
                        true ->
                            NowModPlayerState = insert_fashion(Player, Fashion, AccModPlayerState),
                            {[Id | AccFashionIds],NowModPlayerState};
                        false ->
                            AccIn
                    end
            end,
            {[], ModPlayerState}, FashionList),
    NewPlayer = 
        case FashionIds of
            [] ->
                Player;
            _ -> 
                LastFashion = lists:max(FashionIds),
                Player#player{last_fashion = LastFashion}
        end,
    NewModPlayerState#mod_player_state{
                 player = NewPlayer
                }.

%% 切换时装
%% change_fashion(Player,ModPlayerState, Fashion) 
%%   when is_record(Fashion, fashion) ->
%%     {ok, Player#player{fashion = Fashion#fashion.id}};
change_fashion(Player, FashionList, ChangeId) 
  when is_integer(ChangeId)->
    case lists:keyfind(ChangeId, #fashion.id, FashionList) of
        false ->
            {fail, ?ERROR_ONT_FASHION};
        Fashion ->
            {ok, Player#player{fashion = Fashion#fashion.id}}
    end.

%%=================================================================
%% inner function
%%=================================================================    
%insert_fashion(Player, BaseFashion) ->
    %Fashion = 
       % #fashion{
        %    id           = get_next_fashion_id(),
        %    player_id    = Player#player.id,
        %    fashion_id   = BaseFashion#data_base_fashion.id,
        %    container    = 0,
         %   property     = BaseFashion#data_base_fashion.property,
        %    nid          = BaseFashion#data_base_fashion.nid,
       %     name         = BaseFashion#data_base_fashion.name,
      %      fashion_desc = BaseFashion#data_base_fashion.fashion_desc,
     %       price        = BaseFashion#data_base_fashion.price

    %    },
   % hdb:dirty_write(fashion, Fashion).
insert_fashion(Player, BaseFashion, ModPlayerState) ->
    Fashion = 
        #fashion{
           id           = get_next_fashion_id(),
           player_id    = Player#player.id,
           fashion_id   = BaseFashion#data_base_fashion.id,
           container    = 0,
           property     = BaseFashion#data_base_fashion.property,
           nid          = BaseFashion#data_base_fashion.nid,
           name         = BaseFashion#data_base_fashion.name,
           fashion_desc = BaseFashion#data_base_fashion.fashion_desc,
           price        = BaseFashion#data_base_fashion.price
          },
    #mod_player_state{fashion = FashionList} = ModPlayerState,
    ModPlayerState#mod_player_state{
      player = Player,
      fashion = [Fashion|FashionList]
     }.

save([]) ->
    [];
save([Fashion|FashionList]) ->
    hdb:dirty_write(fashion, Fashion),
    save(FashionList).
   
role_login(PlayerId) ->
    db_get_player_fashions_list(PlayerId).

db_get_player_fashions_list(PlayerId) ->
    hdb:dirty_index_read(fashion, PlayerId, #fashion.player_id).

get_fashions(#mod_player_state{
                         fashion = Fashion} = State) ->
    %hdb:dirty_index_read(fashion, PlayerId, #fashion.player_id).
    Fashion.
    

%% get_fashions_by_id(FashionList, Id) ->
%%     case lists:keyfind(Id, 1, FashionList) of
%%         false ->
%%             [];
%%         Fashion ->
%%             Fashion
%%     end.
    %hdb:dirty_read(fashion, Id). 
    
get_next_fashion_id() ->
    lib_counter:update_counter(fashion_uid).

delete_fashions_by_player_id(#mod_player_state{
                              player = Player,
                         fashion = Fashion} = State) ->
    case get_fashions(State) of
        [] ->
            ingore;
        List ->
           hdb:dirty_delete(fashion, [Fashion#fashion.id || Fashion <- List]),
            State#mod_player_state{
              player = Player,
              fashion = []
             }
    end.

%% TODO 创建角色初始化直接写数据库
init_player_fashion(Player) ->
    Player.
 %% = activate_fashion(Player,[]),    
 %%    case get_fashions(Player#player.id) of
 %%        [] ->
 %%            ?WARNING_MSG("init_player_fashion fail, not insert data~n", []),
 %%            NPlayer;
 %%        [HdFashion|_] ->
 %%            {ok, NNPlayer} = change_fashion(Player, HdFashion),
 %%            NNPlayer
 %%    end.
