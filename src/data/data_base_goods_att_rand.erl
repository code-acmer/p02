%% coding: utf-8
%% Warning:本文件由data_generate自动生成，请不要手动修改
-module(data_base_goods_att_rand).
-export([get/1]).
-include("common.hrl").
-include("db_base_goods_att_rand.hrl").
get(2201) ->
[{attack,13},
 {def,13},
 {hp,13},
 {hit,13},
 {dodge,12},
 {crit,12},
 {anti_crit,12},
 {mana_rec,12},
 {mana_lim,0}];
get(2202) ->
[{attack,12},
 {def,13},
 {hp,13},
 {hit,12},
 {dodge,13},
 {crit,12},
 {anti_crit,13},
 {mana_rec,12},
 {mana_lim,0}];
get(2203) ->
[{attack,13},
 {def,12},
 {hp,13},
 {hit,12},
 {dodge,13},
 {crit,12},
 {anti_crit,12},
 {mana_rec,13},
 {mana_lim,0}];
get(2204) ->
[{attack,12},
 {def,12},
 {hp,12},
 {hit,12},
 {dodge,13},
 {crit,13},
 {anti_crit,13},
 {mana_rec,13},
 {mana_lim,0}];
get(2205) ->
[{attack,12},
 {def,13},
 {hp,12},
 {hit,13},
 {dodge,12},
 {crit,13},
 {anti_crit,13},
 {mana_rec,12},
 {mana_lim,0}];
get(2206) ->
[{attack,12},
 {def,12},
 {hp,13},
 {hit,13},
 {dodge,12},
 {crit,13},
 {anti_crit,12},
 {mana_rec,13},
 {mana_lim,0}];
get(2207) ->
[{attack,13},
 {def,12},
 {hp,12},
 {hit,13},
 {dodge,12},
 {crit,13},
 {anti_crit,12},
 {mana_rec,13},
 {mana_lim,0}];
get(Var1) -> ?WARNING_MSG("get not find ~p", [{Var1}]),
[].
