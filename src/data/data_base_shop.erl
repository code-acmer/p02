%% coding: utf-8
%% Warning:本文件由data_generate自动生成，请不要手动修改
-module(data_base_shop).
-export([get/1]).
-export([get_all_shop_id/0]).
-export([get_shop_id_by_type/1]).
-include("common.hrl").
-include("db_base_shop.hrl").
get(9000001) ->
#base_shop{id = 9000001,type = 1,goods_id = 280124,goods_num = 1,consume = [{1,500}],vip = 1,total = 999,day_lim = 10,rang_lim = 200};
get(9000002) ->
#base_shop{id = 9000002,type = 1,goods_id = 280125,goods_num = 1,consume = [{1,400}],vip = 1,total = 999,day_lim = 10,rang_lim = 200};
get(9000003) ->
#base_shop{id = 9000003,type = 1,goods_id = 280126,goods_num = 1,consume = [{1,250}],vip = 1,total = 999,day_lim = 10,rang_lim = 200};
get(9000004) ->
#base_shop{id = 9000004,type = 1,goods_id = 280127,goods_num = 1,consume = [{1,250}],vip = 1,total = 999,day_lim = 10,rang_lim = 200};
get(9000005) ->
#base_shop{id = 9000005,type = 1,goods_id = 280128,goods_num = 1,consume = [{1,250}],vip = 1,total = 999,day_lim = 10,rang_lim = 200};
get(9000006) ->
#base_shop{id = 9000006,type = 1,goods_id = 280129,goods_num = 1,consume = [{1,250}],vip = 1,total = 999,day_lim = 10,rang_lim = 200};
get(9000007) ->
#base_shop{id = 9000007,type = 1,goods_id = 3,goods_num = 1250,consume = [{1,5}],vip = 0,total = 999,day_lim = 100,rang_lim = 200};
get(9000008) ->
#base_shop{id = 9000008,type = 1,goods_id = 6,goods_num = 750,consume = [{1,5}],vip = 0,total = 999,day_lim = 100,rang_lim = 200};
get(9000009) ->
#base_shop{id = 9000009,type = 1,goods_id = 240100101,goods_num = 15,consume = [{1,5}],vip = 0,total = 999,day_lim = 100,rang_lim = 200};
get(9000010) ->
#base_shop{id = 9000010,type = 1,goods_id = 280113,goods_num = 5,consume = [{1,10}],vip = 0,total = 999,day_lim = 100,rang_lim = 200};
get(9000011) ->
#base_shop{id = 9000011,type = 1,goods_id = 270101,goods_num = 1,consume = [{1,5}],vip = 0,total = 999,day_lim = 30,rang_lim = 200};
get(9000012) ->
#base_shop{id = 9000012,type = 1,goods_id = 270201,goods_num = 1,consume = [{1,5}],vip = 0,total = 999,day_lim = 30,rang_lim = 200};
get(9000013) ->
#base_shop{id = 9000013,type = 2,goods_id = 280130,goods_num = 1,consume = [{280115,100}],vip = 0,total = 999,day_lim = 999,rang_lim = 200};
get(9000014) ->
#base_shop{id = 9000014,type = 2,goods_id = 280116,goods_num = 1,consume = [{280113,100}],vip = 0,total = 999,day_lim = 999,rang_lim = 200};
get(9000015) ->
#base_shop{id = 9000015,type = 2,goods_id = 280117,goods_num = 1,consume = [{280113,70}],vip = 0,total = 999,day_lim = 999,rang_lim = 200};
get(9000016) ->
#base_shop{id = 9000016,type = 2,goods_id = 280118,goods_num = 1,consume = [{280113,50}],vip = 0,total = 999,day_lim = 999,rang_lim = 200};
get(9000017) ->
#base_shop{id = 9000017,type = 2,goods_id = 280119,goods_num = 1,consume = [{280113,50}],vip = 0,total = 999,day_lim = 999,rang_lim = 200};
get(9000018) ->
#base_shop{id = 9000018,type = 2,goods_id = 280120,goods_num = 1,consume = [{280113,50}],vip = 0,total = 999,day_lim = 999,rang_lim = 200};
get(9000019) ->
#base_shop{id = 9000019,type = 2,goods_id = 280121,goods_num = 1,consume = [{280113,50}],vip = 0,total = 999,day_lim = 999,rang_lim = 200};
get(9000020) ->
#base_shop{id = 9000020,type = 3,goods_id = 3,goods_num = 5000,consume = [{1,10}],vip = 0,total = 6,day_lim = 10,rang_lim = 2};
get(9000021) ->
#base_shop{id = 9000021,type = 3,goods_id = 240100101,goods_num = 200,consume = [{1,10}],vip = 0,total = 6,day_lim = 10,rang_lim = 2};
get(9000022) ->
#base_shop{id = 9000022,type = 3,goods_id = 22110011,goods_num = 1,consume = [{1,20}],vip = 2,total = 6,day_lim = 10,rang_lim = 2};
get(9000023) ->
#base_shop{id = 9000023,type = 3,goods_id = 22200011,goods_num = 1,consume = [{1,21}],vip = 0,total = 6,day_lim = 10,rang_lim = 3};
get(9000024) ->
#base_shop{id = 9000024,type = 3,goods_id = 22300011,goods_num = 1,consume = [{1,22}],vip = 5,total = 6,day_lim = 10,rang_lim = 2};
get(9000025) ->
#base_shop{id = 9000025,type = 3,goods_id = 22400011,goods_num = 1,consume = [{1,23}],vip = 0,total = 6,day_lim = 10,rang_lim = 3};
get(9000026) ->
#base_shop{id = 9000026,type = 3,goods_id = 22500011,goods_num = 1,consume = [{1,24}],vip = 0,total = 6,day_lim = 10,rang_lim = 3};
get(9000027) ->
#base_shop{id = 9000027,type = 3,goods_id = 22700011,goods_num = 1,consume = [{1,25}],vip = 0,total = 6,day_lim = 10,rang_lim = 3};
get(9000028) ->
#base_shop{id = 9000028,type = 3,goods_id = 22110111,goods_num = 1,consume = [{1,26}],vip = 1,total = 6,day_lim = 10,rang_lim = 3};
get(9000029) ->
#base_shop{id = 9000029,type = 3,goods_id = 22200111,goods_num = 1,consume = [{1,27}],vip = 2,total = 6,day_lim = 10,rang_lim = 3};
get(9000030) ->
#base_shop{id = 9000030,type = 3,goods_id = 22300111,goods_num = 1,consume = [{1,28}],vip = 0,total = 6,day_lim = 10,rang_lim = 3};
get(9000031) ->
#base_shop{id = 9000031,type = 3,goods_id = 22400111,goods_num = 1,consume = [{1,29}],vip = 5,total = 6,day_lim = 10,rang_lim = 3};
get(9000032) ->
#base_shop{id = 9000032,type = 3,goods_id = 22500111,goods_num = 1,consume = [{1,28}],vip = 9,total = 6,day_lim = 10,rang_lim = 3};
get(9000033) ->
#base_shop{id = 9000033,type = 3,goods_id = 22700111,goods_num = 1,consume = [{1,27}],vip = 8,total = 6,day_lim = 10,rang_lim = 6};
get(9000034) ->
#base_shop{id = 9000034,type = 3,goods_id = 22110211,goods_num = 1,consume = [{1,26}],vip = 7,total = 6,day_lim = 10,rang_lim = 6};
get(9000035) ->
#base_shop{id = 9000035,type = 3,goods_id = 22200211,goods_num = 1,consume = [{1,25}],vip = 6,total = 6,day_lim = 10,rang_lim = 6};
get(9000036) ->
#base_shop{id = 9000036,type = 3,goods_id = 22300211,goods_num = 1,consume = [{1,24}],vip = 5,total = 6,day_lim = 10,rang_lim = 6};
get(9000037) ->
#base_shop{id = 9000037,type = 3,goods_id = 22400211,goods_num = 1,consume = [{1,23}],vip = 4,total = 6,day_lim = 10,rang_lim = 6};
get(9000038) ->
#base_shop{id = 9000038,type = 3,goods_id = 22500211,goods_num = 1,consume = [{1,22}],vip = 3,total = 6,day_lim = 10,rang_lim = 6};
get(9000039) ->
#base_shop{id = 9000039,type = 3,goods_id = 22700211,goods_num = 1,consume = [{1,21}],vip = 2,total = 6,day_lim = 10,rang_lim = 6};
get(9000040) ->
#base_shop{id = 9000040,type = 3,goods_id = 22110311,goods_num = 1,consume = [{1,20}],vip = 1,total = 6,day_lim = 10,rang_lim = 6};
get(9000041) ->
#base_shop{id = 9000041,type = 3,goods_id = 22200311,goods_num = 1,consume = [{1,19}],vip = 0,total = 6,day_lim = 10,rang_lim = 6};
get(9000042) ->
#base_shop{id = 9000042,type = 3,goods_id = 22300311,goods_num = 1,consume = [{1,18}],vip = 0,total = 6,day_lim = 10,rang_lim = 6};
get(9000043) ->
#base_shop{id = 9000043,type = 3,goods_id = 22400311,goods_num = 1,consume = [{1,17}],vip = 0,total = 6,day_lim = 10,rang_lim = 6};
get(9000044) ->
#base_shop{id = 9000044,type = 3,goods_id = 22500311,goods_num = 1,consume = [{1,16}],vip = 0,total = 6,day_lim = 10,rang_lim = 6};
get(9000045) ->
#base_shop{id = 9000045,type = 3,goods_id = 22700311,goods_num = 1,consume = [{1,15}],vip = 0,total = 6,day_lim = 10,rang_lim = 6};
get(9000046) ->
#base_shop{id = 9000046,type = 3,goods_id = 280101,goods_num = 1,consume = [{1,14}],vip = 0,total = 6,day_lim = 10,rang_lim = 6};
get(9000047) ->
#base_shop{id = 9000047,type = 3,goods_id = 280102,goods_num = 1,consume = [{1,13}],vip = 0,total = 6,day_lim = 10,rang_lim = 6};
get(9000048) ->
#base_shop{id = 9000048,type = 3,goods_id = 280103,goods_num = 1,consume = [{1,12}],vip = 0,total = 6,day_lim = 10,rang_lim = 6};
get(9000049) ->
#base_shop{id = 9000049,type = 3,goods_id = 280104,goods_num = 1,consume = [{1,11}],vip = 0,total = 6,day_lim = 10,rang_lim = 6};
get(9000050) ->
#base_shop{id = 9000050,type = 3,goods_id = 280105,goods_num = 1,consume = [{1,10}],vip = 0,total = 6,day_lim = 10,rang_lim = 6};
get(9000051) ->
#base_shop{id = 9000051,type = 3,goods_id = 280106,goods_num = 1,consume = [{1,9}],vip = 0,total = 6,day_lim = 10,rang_lim = 6};
get(9000052) ->
#base_shop{id = 9000052,type = 3,goods_id = 280107,goods_num = 1,consume = [{1,8}],vip = 0,total = 6,day_lim = 10,rang_lim = 6};
get(9000053) ->
#base_shop{id = 9000053,type = 1,goods_id = 270301,goods_num = 1,consume = [{1,5}],vip = 0,total = 999,day_lim = 30,rang_lim = 200};
get(9000054) ->
#base_shop{id = 9000054,type = 1,goods_id = 270401,goods_num = 1,consume = [{1,4}],vip = 0,total = 999,day_lim = 30,rang_lim = 200};
get(9000055) ->
#base_shop{id = 9000055,type = 1,goods_id = 270501,goods_num = 1,consume = [{1,5}],vip = 0,total = 999,day_lim = 30,rang_lim = 200};
get(9000056) ->
#base_shop{id = 9000056,type = 1,goods_id = 270601,goods_num = 1,consume = [{1,5}],vip = 0,total = 999,day_lim = 30,rang_lim = 200};
get(9000057) ->
#base_shop{id = 9000057,type = 1,goods_id = 270701,goods_num = 1,consume = [{1,4}],vip = 0,total = 999,day_lim = 30,rang_lim = 200};
get(9000058) ->
#base_shop{id = 9000058,type = 1,goods_id = 270801,goods_num = 1,consume = [{1,4}],vip = 0,total = 999,day_lim = 30,rang_lim = 200};
get(9000059) ->
#base_shop{id = 9000059,type = 4,goods_id = 40000001,goods_num = 1,consume = [{1,999}],vip = 0,total = 999,day_lim = 999,rang_lim = 999};
get(9000060) ->
#base_shop{id = 9000060,type = 4,goods_id = 40000002,goods_num = 1,consume = [{1,999}],vip = 0,total = 999,day_lim = 999,rang_lim = 999};
get(9000061) ->
#base_shop{id = 9000061,type = 4,goods_id = 40000003,goods_num = 1,consume = [{1,999}],vip = 0,total = 999,day_lim = 999,rang_lim = 999};
get(9000062) ->
#base_shop{id = 9000062,type = 4,goods_id = 40000004,goods_num = 1,consume = [{1,999}],vip = 0,total = 999,day_lim = 999,rang_lim = 999};
get(9000063) ->
#base_shop{id = 9000063,type = 4,goods_id = 40000005,goods_num = 1,consume = [{1,999}],vip = 0,total = 999,day_lim = 999,rang_lim = 999};
get(9000064) ->
#base_shop{id = 9000064,type = 4,goods_id = 40001103,goods_num = 1,consume = [{1,1999}],vip = 0,total = 999,day_lim = 999,rang_lim = 999};
get(9000065) ->
#base_shop{id = 9000065,type = 4,goods_id = 40002103,goods_num = 1,consume = [{1,2999}],vip = 0,total = 999,day_lim = 999,rang_lim = 999};
get(9000066) ->
#base_shop{id = 9000066,type = 4,goods_id = 40003103,goods_num = 1,consume = [{1,3999}],vip = 0,total = 999,day_lim = 999,rang_lim = 999};
get(9000067) ->
#base_shop{id = 9000067,type = 4,goods_id = 40003113,goods_num = 1,consume = [{1,3999}],vip = 0,total = 999,day_lim = 999,rang_lim = 999};
get(9000068) ->
#base_shop{id = 9000068,type = 4,goods_id = 40004103,goods_num = 1,consume = [{1,4999}],vip = 0,total = 999,day_lim = 999,rang_lim = 999};
get(9000069) ->
#base_shop{id = 9000069,type = 4,goods_id = 40004004,goods_num = 1,consume = [{1,4999}],vip = 0,total = 999,day_lim = 999,rang_lim = 999};
get(9000070) ->
#base_shop{id = 9000070,type = 4,goods_id = 40004005,goods_num = 1,consume = [{1,4999}],vip = 0,total = 999,day_lim = 999,rang_lim = 999};
get(9000071) ->
#base_shop{id = 9000071,type = 1,goods_id = 280134,goods_num = 5,consume = [{1,10}],vip = 0,total = 999,day_lim = 100,rang_lim = 200};
get(Var1) -> ?WARNING_MSG("get not find ~p", [{Var1}]),
[].

get_all_shop_id() ->
[9000001,9000002,9000003,9000004,9000005,9000006,9000007,9000008,9000009,9000010,9000011,9000012,9000013,9000014,9000015,9000016,9000017,9000018,9000019,9000020,9000021,9000022,9000023,9000024,9000025,9000026,9000027,9000028,9000029,9000030,9000031,9000032,9000033,9000034,9000035,9000036,9000037,9000038,9000039,9000040,9000041,9000042,9000043,9000044,9000045,9000046,9000047,9000048,9000049,9000050,9000051,9000052,9000053,9000054,9000055,9000056,9000057,9000058,9000059,9000060,9000061,9000062,9000063,9000064,9000065,9000066,9000067,9000068,9000069,9000070,9000071].

get_shop_id_by_type(1) ->
[9000071,9000058,9000057,9000056,9000055,9000054,9000053,9000012,9000011,9000010,9000009,9000008,9000007,9000006,9000005,9000004,9000003,9000002,9000001];
get_shop_id_by_type(2) ->
[9000019,9000018,9000017,9000016,9000015,9000014,9000013];
get_shop_id_by_type(3) ->
[9000052,9000051,9000050,9000049,9000048,9000047,9000046,9000045,9000044,9000043,9000042,9000041,9000040,9000039,9000038,9000037,9000036,9000035,9000034,9000033,9000032,9000031,9000030,9000029,9000028,9000027,9000026,9000025,9000024,9000023,9000022,9000021,9000020];
get_shop_id_by_type(4) ->
[9000070,9000069,9000068,9000067,9000066,9000065,9000064,9000063,9000062,9000061,9000060,9000059];
get_shop_id_by_type(Var1) -> ?WARNING_MSG("get_shop_id_by_type not find ~p", [{Var1}]),
[].
