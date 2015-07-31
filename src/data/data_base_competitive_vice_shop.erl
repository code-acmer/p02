%% coding: utf-8
%% Warning:本文件由data_generate自动生成，请不要手动修改
-module(data_base_competitive_vice_shop).
-export([get/1]).
-export([get_all_id/0]).
-export([get_id_by_lv/1]).
-export([get_all_lv/0]).
-export([get_id_by_career/1]).
-export([get_all_career/0]).
-export([get_id_by_lv_and_career/1]).
-include("common.hrl").
-include("db_base_competitive_vice_shop.hrl").
get(1) ->
#base_competitive_vice_shop{id = 1,goods_id = 270201,goods_num = 1,consume = [{1,8}],lv = 30,weight = 100,career = 0};
get(2) ->
#base_competitive_vice_shop{id = 2,goods_id = 270202,goods_num = 1,consume = [{1,24}],lv = 60,weight = 100,career = 0};
get(3) ->
#base_competitive_vice_shop{id = 3,goods_id = 270203,goods_num = 1,consume = [{1,72}],lv = 90,weight = 100,career = 0};
get(4) ->
#base_competitive_vice_shop{id = 4,goods_id = 270301,goods_num = 1,consume = [{1,4}],lv = 30,weight = 100,career = 0};
get(5) ->
#base_competitive_vice_shop{id = 5,goods_id = 270302,goods_num = 1,consume = [{1,12}],lv = 60,weight = 100,career = 0};
get(6) ->
#base_competitive_vice_shop{id = 6,goods_id = 270303,goods_num = 1,consume = [{1,36}],lv = 90,weight = 100,career = 0};
get(7) ->
#base_competitive_vice_shop{id = 7,goods_id = 270101,goods_num = 1,consume = [{1,4}],lv = 30,weight = 100,career = 0};
get(8) ->
#base_competitive_vice_shop{id = 8,goods_id = 270102,goods_num = 1,consume = [{1,12}],lv = 60,weight = 100,career = 0};
get(9) ->
#base_competitive_vice_shop{id = 9,goods_id = 270103,goods_num = 1,consume = [{1,36}],lv = 90,weight = 100,career = 0};
get(10) ->
#base_competitive_vice_shop{id = 10,goods_id = 270401,goods_num = 1,consume = [{1,3}],lv = 30,weight = 100,career = 0};
get(11) ->
#base_competitive_vice_shop{id = 11,goods_id = 270402,goods_num = 1,consume = [{1,9}],lv = 60,weight = 100,career = 0};
get(12) ->
#base_competitive_vice_shop{id = 12,goods_id = 270403,goods_num = 1,consume = [{1,27}],lv = 90,weight = 100,career = 0};
get(13) ->
#base_competitive_vice_shop{id = 13,goods_id = 270501,goods_num = 1,consume = [{1,4}],lv = 30,weight = 100,career = 0};
get(14) ->
#base_competitive_vice_shop{id = 14,goods_id = 270502,goods_num = 1,consume = [{1,12}],lv = 60,weight = 100,career = 0};
get(15) ->
#base_competitive_vice_shop{id = 15,goods_id = 270503,goods_num = 1,consume = [{1,36}],lv = 90,weight = 100,career = 0};
get(16) ->
#base_competitive_vice_shop{id = 16,goods_id = 270601,goods_num = 1,consume = [{1,4}],lv = 30,weight = 100,career = 0};
get(17) ->
#base_competitive_vice_shop{id = 17,goods_id = 270602,goods_num = 1,consume = [{1,12}],lv = 60,weight = 100,career = 0};
get(18) ->
#base_competitive_vice_shop{id = 18,goods_id = 270603,goods_num = 1,consume = [{1,36}],lv = 90,weight = 100,career = 0};
get(19) ->
#base_competitive_vice_shop{id = 19,goods_id = 270701,goods_num = 1,consume = [{1,3}],lv = 30,weight = 100,career = 0};
get(20) ->
#base_competitive_vice_shop{id = 20,goods_id = 270702,goods_num = 1,consume = [{1,9}],lv = 60,weight = 100,career = 0};
get(21) ->
#base_competitive_vice_shop{id = 21,goods_id = 270703,goods_num = 1,consume = [{1,27}],lv = 90,weight = 100,career = 0};
get(22) ->
#base_competitive_vice_shop{id = 22,goods_id = 270801,goods_num = 1,consume = [{1,4}],lv = 30,weight = 100,career = 0};
get(23) ->
#base_competitive_vice_shop{id = 23,goods_id = 270802,goods_num = 1,consume = [{1,12}],lv = 60,weight = 100,career = 0};
get(24) ->
#base_competitive_vice_shop{id = 24,goods_id = 270803,goods_num = 1,consume = [{1,36}],lv = 90,weight = 100,career = 0};
get(25) ->
#base_competitive_vice_shop{id = 25,goods_id = 270201,goods_num = 1,consume = [{1,8}],lv = 50,weight = 100,career = 0};
get(26) ->
#base_competitive_vice_shop{id = 26,goods_id = 270202,goods_num = 1,consume = [{1,24}],lv = 70,weight = 100,career = 0};
get(27) ->
#base_competitive_vice_shop{id = 27,goods_id = 270203,goods_num = 1,consume = [{1,72}],lv = 110,weight = 100,career = 0};
get(28) ->
#base_competitive_vice_shop{id = 28,goods_id = 270301,goods_num = 1,consume = [{1,4}],lv = 50,weight = 100,career = 0};
get(29) ->
#base_competitive_vice_shop{id = 29,goods_id = 270302,goods_num = 1,consume = [{1,12}],lv = 70,weight = 100,career = 0};
get(30) ->
#base_competitive_vice_shop{id = 30,goods_id = 270303,goods_num = 1,consume = [{1,36}],lv = 110,weight = 100,career = 0};
get(31) ->
#base_competitive_vice_shop{id = 31,goods_id = 270101,goods_num = 1,consume = [{1,4}],lv = 50,weight = 100,career = 0};
get(32) ->
#base_competitive_vice_shop{id = 32,goods_id = 270102,goods_num = 1,consume = [{1,12}],lv = 70,weight = 100,career = 0};
get(33) ->
#base_competitive_vice_shop{id = 33,goods_id = 270103,goods_num = 1,consume = [{1,36}],lv = 110,weight = 100,career = 0};
get(34) ->
#base_competitive_vice_shop{id = 34,goods_id = 270401,goods_num = 1,consume = [{1,3}],lv = 50,weight = 100,career = 0};
get(35) ->
#base_competitive_vice_shop{id = 35,goods_id = 270402,goods_num = 1,consume = [{1,9}],lv = 70,weight = 100,career = 0};
get(36) ->
#base_competitive_vice_shop{id = 36,goods_id = 270403,goods_num = 1,consume = [{1,27}],lv = 110,weight = 100,career = 0};
get(37) ->
#base_competitive_vice_shop{id = 37,goods_id = 270501,goods_num = 1,consume = [{1,4}],lv = 50,weight = 100,career = 0};
get(38) ->
#base_competitive_vice_shop{id = 38,goods_id = 270502,goods_num = 1,consume = [{1,12}],lv = 70,weight = 100,career = 0};
get(39) ->
#base_competitive_vice_shop{id = 39,goods_id = 270503,goods_num = 1,consume = [{1,36}],lv = 110,weight = 100,career = 0};
get(40) ->
#base_competitive_vice_shop{id = 40,goods_id = 270601,goods_num = 1,consume = [{1,4}],lv = 50,weight = 100,career = 0};
get(41) ->
#base_competitive_vice_shop{id = 41,goods_id = 270602,goods_num = 1,consume = [{1,12}],lv = 70,weight = 100,career = 0};
get(42) ->
#base_competitive_vice_shop{id = 42,goods_id = 270603,goods_num = 1,consume = [{1,36}],lv = 110,weight = 100,career = 0};
get(43) ->
#base_competitive_vice_shop{id = 43,goods_id = 270701,goods_num = 1,consume = [{1,3}],lv = 50,weight = 100,career = 0};
get(44) ->
#base_competitive_vice_shop{id = 44,goods_id = 270702,goods_num = 1,consume = [{1,9}],lv = 70,weight = 100,career = 0};
get(45) ->
#base_competitive_vice_shop{id = 45,goods_id = 270703,goods_num = 1,consume = [{1,27}],lv = 110,weight = 100,career = 0};
get(46) ->
#base_competitive_vice_shop{id = 46,goods_id = 270801,goods_num = 1,consume = [{1,4}],lv = 50,weight = 100,career = 0};
get(47) ->
#base_competitive_vice_shop{id = 47,goods_id = 270802,goods_num = 1,consume = [{1,12}],lv = 70,weight = 100,career = 0};
get(48) ->
#base_competitive_vice_shop{id = 48,goods_id = 270803,goods_num = 1,consume = [{1,36}],lv = 110,weight = 100,career = 0};
get(Var1) -> ?WARNING_MSG("get not find ~p", [{Var1}]),
[].

get_all_id() ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48].

get_id_by_lv(30) ->
[22,19,16,13,10,7,4,1];
get_id_by_lv(50) ->
[46,43,40,37,34,31,28,25];
get_id_by_lv(60) ->
[23,20,17,14,11,8,5,2];
get_id_by_lv(70) ->
[47,44,41,38,35,32,29,26];
get_id_by_lv(90) ->
[24,21,18,15,12,9,6,3];
get_id_by_lv(110) ->
[48,45,42,39,36,33,30,27];
get_id_by_lv(Var1) -> ?WARNING_MSG("get_id_by_lv not find ~p", [{Var1}]),
[].

get_all_lv() ->
[30,50,60,70,90,110].

get_id_by_career(0) ->
[48,47,46,45,44,43,42,41,40,39,38,37,36,35,34,33,32,31,30,29,28,27,26,25,24,23,22,21,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1];
get_id_by_career(Var1) -> ?WARNING_MSG("get_id_by_career not find ~p", [{Var1}]),
[].

get_all_career() ->
[0].

get_id_by_lv_and_career({30, 0}) ->
[22,19,16,13,10,7,4,1];
get_id_by_lv_and_career({50, 0}) ->
[46,43,40,37,34,31,28,25];
get_id_by_lv_and_career({60, 0}) ->
[23,20,17,14,11,8,5,2];
get_id_by_lv_and_career({70, 0}) ->
[47,44,41,38,35,32,29,26];
get_id_by_lv_and_career({90, 0}) ->
[24,21,18,15,12,9,6,3];
get_id_by_lv_and_career({110, 0}) ->
[48,45,42,39,36,33,30,27];
get_id_by_lv_and_career(Var1) -> [].
