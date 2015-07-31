-module(robot_pt_send_15).
-include("define_robot.hrl").
-export([
         pack_rec/2,
         pack_rec/3
        ]).
pack_rec(Cmd, _State, Args) ->
    pack_rec_args(Cmd, Args).

pack_rec(Cmd, _) ->
    pack_rec(Cmd).
pack_rec(15022) ->
    <<>>;
pack_rec(15000) ->
    <<>>;
pack_rec(15010) ->
    <<>>;
pack_rec(15103) ->
    <<>>;
pack_rec(15501) ->
    <<>>;
pack_rec(15502) ->
    <<>>;
pack_rec(15504) ->
    <<>>;
pack_rec(15505) ->
    <<>>;
pack_rec(15510) ->
    <<>>;
pack_rec(15512) ->
    <<>>;
pack_rec(15301) ->
    <<>>;
pack_rec(15555) ->
    <<>>;
pack_rec(15900) -> %% 获取抽奖信息
    <<>>;
pack_rec(15911) ->
    <<>>;


pack_rec(Cmd) ->
    ?WARNING_MSG("not match ~p~n", [Cmd]),
    error.
pack_rec_args(15008, [PlayerId, GoodsId]) ->
    #pbid64r{ids = [PlayerId, GoodsId]};
pack_rec_args(15010, [Id]) ->    %%分解
    #pbid32{id = Id};
pack_rec_args(15104, [Id, Tid]) ->  %%紫色装备属性转移为橙色装备
    #pbsmriti{id = Id,
              tid = Tid};

pack_rec_args(15200,[Id, Num]) ->  %%强化
    #pbequipstrengthen{id = Id, num = Num};
pack_rec_args(15201,[Id, Num]) ->  %%升星
    #pbequipaddstar{id = Id, num = Num};
pack_rec_args(15202,[GId, List]) ->  %%强化
    #pbupgradeskillcard{id = GId, consume_list = 
                            lists:map(fun({Id, Sum}) ->
                                              #pbgoodsinfo{id = Id,
                                                           num = Sum}
                                      end, List)};
pack_rec_args(15100, [Id]) ->  %%穿装备
    #pbequipmove{id = Id};
pack_rec_args(15101, [Id]) ->  %%卸下装备
    #pbequipmove{id = Id};
pack_rec_args(15102, [Id]) ->  %%卸下装备
    #pbgoodslist{goods_list = [#pbgoods{id = Id,
                                        card_pos_1 = 1}]};

pack_rec_args(15110, [Id]) ->
    #pbid32{id = Id};
pack_rec_args(15020, [Id, Tid]) ->  %%传承装备
    #pbsmriti{id = Id,
              tid = Tid};
pack_rec_args(15030, [Id, Sum]) ->  
    #pbshopitem{id = Id,
                num = Sum};
pack_rec_args(15300, [Id]) ->  
    #pbid32{id = Id};
pack_rec_args(15401, [Id, Tid, Pos]) ->
    #pbinlaidjewel{id = Id, tid = Tid, pos = Pos};
pack_rec_args(15402, [Id, Num]) ->
    #pbinlaidjewel{id = Id, num = Num};
pack_rec_args(15403, [Tid, Pos]) ->
    #pbinlaidjewel{tid = Tid, pos = Pos};
pack_rec_args(15404, [Tid]) ->
    #pbinlaidjewel{tid = Tid};

pack_rec_args(15503, [Pos]) ->
    #pbshopbuy{
       pos = Pos
      };
pack_rec_args(15504, [Pos]) ->
    #pbshopbuy{
       pos = Pos
      };
pack_rec_args(15511, [Id, Num]) ->
    #pbordinarybuy{
       base_id = Id,
       num = Num
      };
pack_rec_args(15513, [Id, Num]) ->
    #pbordinarybuy{
       base_id = Id,
       num = Num
      };
pack_rec_args(15556, [Id, Num]) ->
    #pbshopitem{
       id = Id,
       num = Num
      };

pack_rec_args(15560, [StoreType]) ->
    #pbid32{
       id = StoreType
      };

pack_rec_args(15561, [StoreType]) ->
    #pbid32{
       id = StoreType
      };

pack_rec_args(15562, [StoreType, Pos]) ->
    #pbgeneralstorebuy{
       store_type = StoreType,
       pos = Pos
      };

pack_rec_args(15801, [Type]) ->
    #pbid32{id = Type};
pack_rec_args(15901, [MoneyType, BuyNum, IsFree]) ->
    #pbchoujiang{
       money_type = MoneyType,
       buy_num = BuyNum,
       is_free = IsFree
      };
pack_rec_args(15910, [MoneyNum]) ->
    #pbid32{id = MoneyNum};

pack_rec_args(15911, [MoneyNum]) ->
    #pbid32{id = MoneyNum};

pack_rec_args(Cmd, Args) ->
    ?WARNING_MSG("not match ~p~n", [{Cmd, Args}]),
    error.
