%% coding: utf-8
%% Warning:本文件由data_generate自动生成，请不要手动修改
-module(data_base_goods_att_lv).
-export([get/1]).
-include("common.hrl").
-include("db_base_goods_att_lv.hrl").
get(Lv) when Lv >= 0 andalso Lv =< 9 ->
#base_goods_att_lv{id = [0,9],attack = 9,def = 5,hp = 92,hit = 3,dodge = 3,crit = 3,anti_crit = 3,mana_lim = 0,mana_rec = 13};
get(Lv) when Lv >= 10 andalso Lv =< 19 ->
#base_goods_att_lv{id = [10,19],attack = 14,def = 7,hp = 138,hit = 4,dodge = 4,crit = 4,anti_crit = 4,mana_lim = 0,mana_rec = 18};
get(Lv) when Lv >= 20 andalso Lv =< 29 ->
#base_goods_att_lv{id = [20,29],attack = 21,def = 10,hp = 206,hit = 6,dodge = 6,crit = 6,anti_crit = 6,mana_lim = 0,mana_rec = 25};
get(Lv) when Lv >= 30 andalso Lv =< 39 ->
#base_goods_att_lv{id = [30,39],attack = 31,def = 15,hp = 308,hit = 9,dodge = 9,crit = 9,anti_crit = 9,mana_lim = 0,mana_rec = 35};
get(Lv) when Lv >= 40 andalso Lv =< 49 ->
#base_goods_att_lv{id = [40,49],attack = 46,def = 23,hp = 459,hit = 14,dodge = 14,crit = 14,anti_crit = 14,mana_lim = 0,mana_rec = 50};
get(Lv) when Lv >= 50 andalso Lv =< 59 ->
#base_goods_att_lv{id = [50,59],attack = 68,def = 34,hp = 681,hit = 20,dodge = 20,crit = 20,anti_crit = 20,mana_lim = 0,mana_rec = 70};
get(Lv) when Lv >= 60 andalso Lv =< 69 ->
#base_goods_att_lv{id = [60,69],attack = 101,def = 50,hp = 1009,hit = 30,dodge = 30,crit = 30,anti_crit = 30,mana_lim = 0,mana_rec = 85};
get(Lv) when Lv >= 70 andalso Lv =< 79 ->
#base_goods_att_lv{id = [70,79],attack = 149,def = 75,hp = 1491,hit = 45,dodge = 45,crit = 45,anti_crit = 45,mana_lim = 0,mana_rec = 93};
get(Lv) when Lv >= 80 andalso Lv =< 89 ->
#base_goods_att_lv{id = [80,89],attack = 220,def = 110,hp = 2199,hit = 66,dodge = 66,crit = 66,anti_crit = 66,mana_lim = 0,mana_rec = 102};
get(Lv) when Lv >= 90 andalso Lv =< 99 ->
#base_goods_att_lv{id = [90,99],attack = 324,def = 162,hp = 3237,hit = 97,dodge = 97,crit = 97,anti_crit = 97,mana_lim = 0,mana_rec = 112};
get(Var1) -> ?WARNING_MSG("get not find ~p", [{Var1}]),
[].
