-module(lib_vip).
-include("db_base_vip_cost.hrl").
-include("db_base_vip.hrl").
-export([get_vip_cost/2,
         buy_arena_times/1,
         max_reset_super_battle/1,
         vip_king_dungeon_buy/1,
         max_cross_buy_times/1,
         can_mop_up/2,
         max_mysterious_fresh/1,
         get_master_prentice/1
        ]).

get_vip_cost(Name, Times) 
  when is_atom(Name), is_integer(Times) ->
    case data_base_vip_cost:get(Times) of
        [] ->
            error;
        VipCost ->
            dynarec_vip_cost_misc:rec_get_value(Name, VipCost)
    end;
get_vip_cost(_, _) ->
    error.

buy_arena_times(Vip) ->
    case data_base_vip:get(Vip) of
        [] ->
            0;
        #base_vip{pvp_challange_times = Times} ->
            Times
    end.

%% 调整为公平竞技重置次数
max_reset_super_battle(Vip) ->
    case data_base_vip:get(Vip) of
        [] ->
            1;
        #base_vip{fair_challange_times = Times} ->
            Times
    end.

vip_king_dungeon_buy(Vip) ->
    case data_base_vip:get(Vip) of
        [] ->
            0;
        #base_vip{king_dungeon_times = Times} ->
            Times
    end.

max_cross_buy_times(Vip) ->
    case data_base_vip:get(Vip) of
        [] ->
            0; 
        #base_vip{cross_challange_time = Times} ->
            Times
    end.

can_mop_up(Vip, 1) ->
    case data_base_vip:get(Vip) of
        #base_vip{saodang = 1} ->
            true;
        _ ->
            false
    end;
can_mop_up(Vip, 10) ->
    case data_base_vip:get(Vip) of
        #base_vip{ten_saodang = 1} ->
            true;
        _ ->
            false
    end;

%% 这里处理王者副本的3次, 以后扩展可能有坑
can_mop_up(Vip, 3) ->
    case data_base_vip:get(Vip) of
        #base_vip{ten_saodang = 1} ->
            true;
        _ ->
            false
    end;

can_mop_up(_, _) ->
    false.

max_mysterious_fresh(Vip) ->
    case data_base_vip:get(Vip) of
        #base_vip{mysterious_shop_refresh = Num} 
          when is_integer(Num)->
            Num;
        _ ->
            0
    end.

get_master_prentice(Vip) ->
    case data_base_vip:get(Vip) of
        [] ->
            0;
        #base_vip{prentice = Prentice} ->
            Prentice
    end.
