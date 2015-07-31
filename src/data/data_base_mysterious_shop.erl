%% coding: utf-8
%% Warning:本文件由data_generate自动生成，请不要手动修改
-module(data_base_mysterious_shop).
-export([get/1]).
-export([get_all_id/0]).
-export([get_id_by_lv/1]).
-export([get_all_lv/0]).
-export([get_id_by_career/1]).
-export([get_all_career/0]).
-export([get_id_by_lv_and_career/1]).
-include("common.hrl").
-include("db_base_mysterious_shop.hrl").
get(1) ->
#base_mysterious_shop{id = 1,goods_id = 270201,goods_num = 1,consume = [{1,4}],lv = 30,weight = 100,career = 0};
get(2) ->
#base_mysterious_shop{id = 2,goods_id = 270202,goods_num = 1,consume = [{1,12}],lv = 60,weight = 100,career = 0};
get(3) ->
#base_mysterious_shop{id = 3,goods_id = 270203,goods_num = 1,consume = [{1,36}],lv = 90,weight = 100,career = 0};
get(4) ->
#base_mysterious_shop{id = 4,goods_id = 270301,goods_num = 1,consume = [{1,4}],lv = 30,weight = 100,career = 0};
get(5) ->
#base_mysterious_shop{id = 5,goods_id = 270302,goods_num = 1,consume = [{1,12}],lv = 60,weight = 100,career = 0};
get(6) ->
#base_mysterious_shop{id = 6,goods_id = 270303,goods_num = 1,consume = [{1,36}],lv = 90,weight = 100,career = 0};
get(7) ->
#base_mysterious_shop{id = 7,goods_id = 270101,goods_num = 1,consume = [{1,4}],lv = 30,weight = 100,career = 0};
get(8) ->
#base_mysterious_shop{id = 8,goods_id = 270102,goods_num = 1,consume = [{1,12}],lv = 60,weight = 100,career = 0};
get(9) ->
#base_mysterious_shop{id = 9,goods_id = 270103,goods_num = 1,consume = [{1,36}],lv = 90,weight = 100,career = 0};
get(10) ->
#base_mysterious_shop{id = 10,goods_id = 270401,goods_num = 1,consume = [{1,3}],lv = 30,weight = 100,career = 0};
get(11) ->
#base_mysterious_shop{id = 11,goods_id = 270402,goods_num = 1,consume = [{1,9}],lv = 60,weight = 100,career = 0};
get(12) ->
#base_mysterious_shop{id = 12,goods_id = 270403,goods_num = 1,consume = [{1,27}],lv = 90,weight = 100,career = 0};
get(13) ->
#base_mysterious_shop{id = 13,goods_id = 270501,goods_num = 1,consume = [{1,4}],lv = 30,weight = 100,career = 0};
get(14) ->
#base_mysterious_shop{id = 14,goods_id = 270502,goods_num = 1,consume = [{1,12}],lv = 60,weight = 100,career = 0};
get(15) ->
#base_mysterious_shop{id = 15,goods_id = 270503,goods_num = 1,consume = [{1,36}],lv = 90,weight = 100,career = 0};
get(16) ->
#base_mysterious_shop{id = 16,goods_id = 270601,goods_num = 1,consume = [{1,4}],lv = 30,weight = 100,career = 0};
get(17) ->
#base_mysterious_shop{id = 17,goods_id = 270602,goods_num = 1,consume = [{1,12}],lv = 60,weight = 100,career = 0};
get(18) ->
#base_mysterious_shop{id = 18,goods_id = 270603,goods_num = 1,consume = [{1,36}],lv = 90,weight = 100,career = 0};
get(19) ->
#base_mysterious_shop{id = 19,goods_id = 270701,goods_num = 1,consume = [{1,3}],lv = 30,weight = 100,career = 0};
get(20) ->
#base_mysterious_shop{id = 20,goods_id = 270702,goods_num = 1,consume = [{1,9}],lv = 60,weight = 100,career = 0};
get(21) ->
#base_mysterious_shop{id = 21,goods_id = 270703,goods_num = 1,consume = [{1,27}],lv = 90,weight = 100,career = 0};
get(22) ->
#base_mysterious_shop{id = 22,goods_id = 270801,goods_num = 1,consume = [{1,4}],lv = 30,weight = 100,career = 0};
get(23) ->
#base_mysterious_shop{id = 23,goods_id = 270802,goods_num = 1,consume = [{1,12}],lv = 60,weight = 100,career = 0};
get(24) ->
#base_mysterious_shop{id = 24,goods_id = 270803,goods_num = 1,consume = [{1,36}],lv = 90,weight = 100,career = 0};
get(25) ->
#base_mysterious_shop{id = 25,goods_id = 270201,goods_num = 1,consume = [{1,4}],lv = 50,weight = 100,career = 0};
get(26) ->
#base_mysterious_shop{id = 26,goods_id = 270202,goods_num = 1,consume = [{1,12}],lv = 70,weight = 100,career = 0};
get(27) ->
#base_mysterious_shop{id = 27,goods_id = 270203,goods_num = 1,consume = [{1,36}],lv = 110,weight = 100,career = 0};
get(28) ->
#base_mysterious_shop{id = 28,goods_id = 270301,goods_num = 1,consume = [{1,4}],lv = 50,weight = 100,career = 0};
get(29) ->
#base_mysterious_shop{id = 29,goods_id = 270302,goods_num = 1,consume = [{1,12}],lv = 70,weight = 100,career = 0};
get(30) ->
#base_mysterious_shop{id = 30,goods_id = 270303,goods_num = 1,consume = [{1,36}],lv = 110,weight = 100,career = 0};
get(31) ->
#base_mysterious_shop{id = 31,goods_id = 270101,goods_num = 1,consume = [{1,4}],lv = 50,weight = 100,career = 0};
get(32) ->
#base_mysterious_shop{id = 32,goods_id = 270102,goods_num = 1,consume = [{1,12}],lv = 70,weight = 100,career = 0};
get(33) ->
#base_mysterious_shop{id = 33,goods_id = 270103,goods_num = 1,consume = [{1,36}],lv = 110,weight = 100,career = 0};
get(34) ->
#base_mysterious_shop{id = 34,goods_id = 270401,goods_num = 1,consume = [{1,3}],lv = 50,weight = 100,career = 0};
get(35) ->
#base_mysterious_shop{id = 35,goods_id = 270402,goods_num = 1,consume = [{1,9}],lv = 70,weight = 100,career = 0};
get(36) ->
#base_mysterious_shop{id = 36,goods_id = 270403,goods_num = 1,consume = [{1,27}],lv = 110,weight = 100,career = 0};
get(37) ->
#base_mysterious_shop{id = 37,goods_id = 270501,goods_num = 1,consume = [{1,4}],lv = 50,weight = 100,career = 0};
get(38) ->
#base_mysterious_shop{id = 38,goods_id = 270502,goods_num = 1,consume = [{1,12}],lv = 70,weight = 100,career = 0};
get(39) ->
#base_mysterious_shop{id = 39,goods_id = 270503,goods_num = 1,consume = [{1,36}],lv = 110,weight = 100,career = 0};
get(40) ->
#base_mysterious_shop{id = 40,goods_id = 270601,goods_num = 1,consume = [{1,4}],lv = 50,weight = 100,career = 0};
get(41) ->
#base_mysterious_shop{id = 41,goods_id = 270602,goods_num = 1,consume = [{1,12}],lv = 70,weight = 100,career = 0};
get(42) ->
#base_mysterious_shop{id = 42,goods_id = 270603,goods_num = 1,consume = [{1,36}],lv = 110,weight = 100,career = 0};
get(43) ->
#base_mysterious_shop{id = 43,goods_id = 270701,goods_num = 1,consume = [{1,3}],lv = 50,weight = 100,career = 0};
get(44) ->
#base_mysterious_shop{id = 44,goods_id = 270702,goods_num = 1,consume = [{1,9}],lv = 70,weight = 100,career = 0};
get(45) ->
#base_mysterious_shop{id = 45,goods_id = 270703,goods_num = 1,consume = [{1,27}],lv = 110,weight = 100,career = 0};
get(46) ->
#base_mysterious_shop{id = 46,goods_id = 270801,goods_num = 1,consume = [{1,4}],lv = 50,weight = 100,career = 0};
get(47) ->
#base_mysterious_shop{id = 47,goods_id = 270802,goods_num = 1,consume = [{1,12}],lv = 70,weight = 100,career = 0};
get(48) ->
#base_mysterious_shop{id = 48,goods_id = 270803,goods_num = 1,consume = [{1,36}],lv = 110,weight = 100,career = 0};
get(49) ->
#base_mysterious_shop{id = 49,goods_id = 90101000,goods_num = 1,consume = [{3,1000}],lv = 10,weight = 50,career = 1};
get(50) ->
#base_mysterious_shop{id = 50,goods_id = 90102000,goods_num = 1,consume = [{3,1000}],lv = 10,weight = 50,career = 1};
get(51) ->
#base_mysterious_shop{id = 51,goods_id = 90103000,goods_num = 1,consume = [{3,1000}],lv = 10,weight = 50,career = 1};
get(52) ->
#base_mysterious_shop{id = 52,goods_id = 90104000,goods_num = 1,consume = [{3,1000}],lv = 10,weight = 50,career = 1};
get(53) ->
#base_mysterious_shop{id = 53,goods_id = 90111000,goods_num = 1,consume = [{3,1000}],lv = 10,weight = 50,career = 1};
get(54) ->
#base_mysterious_shop{id = 54,goods_id = 90122000,goods_num = 1,consume = [{3,1000}],lv = 10,weight = 50,career = 1};
get(55) ->
#base_mysterious_shop{id = 55,goods_id = 90124000,goods_num = 1,consume = [{3,5000}],lv = 10,weight = 50,career = 1};
get(56) ->
#base_mysterious_shop{id = 56,goods_id = 90105000,goods_num = 1,consume = [{3,5000}],lv = 20,weight = 25,career = 1};
get(57) ->
#base_mysterious_shop{id = 57,goods_id = 90107000,goods_num = 1,consume = [{3,5000}],lv = 20,weight = 25,career = 1};
get(58) ->
#base_mysterious_shop{id = 58,goods_id = 90110000,goods_num = 1,consume = [{3,5000}],lv = 20,weight = 25,career = 1};
get(59) ->
#base_mysterious_shop{id = 59,goods_id = 90112000,goods_num = 1,consume = [{3,5000}],lv = 20,weight = 25,career = 1};
get(60) ->
#base_mysterious_shop{id = 60,goods_id = 90125000,goods_num = 1,consume = [{3,5000}],lv = 20,weight = 25,career = 1};
get(61) ->
#base_mysterious_shop{id = 61,goods_id = 90126000,goods_num = 1,consume = [{3,5000}],lv = 20,weight = 25,career = 1};
get(62) ->
#base_mysterious_shop{id = 62,goods_id = 90128000,goods_num = 1,consume = [{3,5000}],lv = 20,weight = 25,career = 1};
get(63) ->
#base_mysterious_shop{id = 63,goods_id = 90106000,goods_num = 1,consume = [{1,120}],lv = 30,weight = 12,career = 1};
get(64) ->
#base_mysterious_shop{id = 64,goods_id = 90108000,goods_num = 1,consume = [{1,120}],lv = 30,weight = 12,career = 1};
get(65) ->
#base_mysterious_shop{id = 65,goods_id = 90113000,goods_num = 1,consume = [{1,120}],lv = 30,weight = 12,career = 1};
get(66) ->
#base_mysterious_shop{id = 66,goods_id = 90114000,goods_num = 1,consume = [{1,120}],lv = 30,weight = 12,career = 1};
get(67) ->
#base_mysterious_shop{id = 67,goods_id = 90127000,goods_num = 1,consume = [{1,120}],lv = 30,weight = 12,career = 1};
get(68) ->
#base_mysterious_shop{id = 68,goods_id = 90129000,goods_num = 1,consume = [{1,120}],lv = 30,weight = 12,career = 1};
get(69) ->
#base_mysterious_shop{id = 69,goods_id = 90101000,goods_num = 1,consume = [{3,1000}],lv = 20,weight = 50,career = 1};
get(70) ->
#base_mysterious_shop{id = 70,goods_id = 90102000,goods_num = 1,consume = [{3,1000}],lv = 20,weight = 50,career = 1};
get(71) ->
#base_mysterious_shop{id = 71,goods_id = 90103000,goods_num = 1,consume = [{3,1000}],lv = 20,weight = 50,career = 1};
get(72) ->
#base_mysterious_shop{id = 72,goods_id = 90104000,goods_num = 1,consume = [{3,1000}],lv = 20,weight = 50,career = 1};
get(73) ->
#base_mysterious_shop{id = 73,goods_id = 90111000,goods_num = 1,consume = [{3,1000}],lv = 20,weight = 50,career = 1};
get(74) ->
#base_mysterious_shop{id = 74,goods_id = 90122000,goods_num = 1,consume = [{3,1000}],lv = 20,weight = 50,career = 1};
get(75) ->
#base_mysterious_shop{id = 75,goods_id = 90124000,goods_num = 1,consume = [{3,5000}],lv = 20,weight = 50,career = 1};
get(76) ->
#base_mysterious_shop{id = 76,goods_id = 90105000,goods_num = 1,consume = [{3,5000}],lv = 30,weight = 25,career = 1};
get(77) ->
#base_mysterious_shop{id = 77,goods_id = 90107000,goods_num = 1,consume = [{3,5000}],lv = 30,weight = 25,career = 1};
get(78) ->
#base_mysterious_shop{id = 78,goods_id = 90110000,goods_num = 1,consume = [{3,5000}],lv = 30,weight = 25,career = 1};
get(79) ->
#base_mysterious_shop{id = 79,goods_id = 90112000,goods_num = 1,consume = [{3,5000}],lv = 30,weight = 25,career = 1};
get(80) ->
#base_mysterious_shop{id = 80,goods_id = 90125000,goods_num = 1,consume = [{3,5000}],lv = 30,weight = 25,career = 1};
get(81) ->
#base_mysterious_shop{id = 81,goods_id = 90126000,goods_num = 1,consume = [{3,5000}],lv = 30,weight = 25,career = 1};
get(82) ->
#base_mysterious_shop{id = 82,goods_id = 90128000,goods_num = 1,consume = [{3,5000}],lv = 30,weight = 25,career = 1};
get(83) ->
#base_mysterious_shop{id = 83,goods_id = 90106000,goods_num = 1,consume = [{1,120}],lv = 40,weight = 12,career = 1};
get(84) ->
#base_mysterious_shop{id = 84,goods_id = 90108000,goods_num = 1,consume = [{1,120}],lv = 40,weight = 12,career = 1};
get(85) ->
#base_mysterious_shop{id = 85,goods_id = 90113000,goods_num = 1,consume = [{1,120}],lv = 40,weight = 12,career = 1};
get(86) ->
#base_mysterious_shop{id = 86,goods_id = 90114000,goods_num = 1,consume = [{1,120}],lv = 40,weight = 12,career = 1};
get(87) ->
#base_mysterious_shop{id = 87,goods_id = 90127000,goods_num = 1,consume = [{1,120}],lv = 40,weight = 12,career = 1};
get(88) ->
#base_mysterious_shop{id = 88,goods_id = 90129000,goods_num = 1,consume = [{1,120}],lv = 40,weight = 12,career = 1};
get(89) ->
#base_mysterious_shop{id = 89,goods_id = 90101000,goods_num = 1,consume = [{3,1000}],lv = 30,weight = 50,career = 1};
get(90) ->
#base_mysterious_shop{id = 90,goods_id = 90102000,goods_num = 1,consume = [{3,1000}],lv = 30,weight = 50,career = 1};
get(91) ->
#base_mysterious_shop{id = 91,goods_id = 90103000,goods_num = 1,consume = [{3,1000}],lv = 30,weight = 50,career = 1};
get(92) ->
#base_mysterious_shop{id = 92,goods_id = 90104000,goods_num = 1,consume = [{3,1000}],lv = 30,weight = 50,career = 1};
get(93) ->
#base_mysterious_shop{id = 93,goods_id = 90111000,goods_num = 1,consume = [{3,1000}],lv = 30,weight = 50,career = 1};
get(94) ->
#base_mysterious_shop{id = 94,goods_id = 90122000,goods_num = 1,consume = [{3,1000}],lv = 30,weight = 50,career = 1};
get(95) ->
#base_mysterious_shop{id = 95,goods_id = 90124000,goods_num = 1,consume = [{3,5000}],lv = 30,weight = 50,career = 1};
get(96) ->
#base_mysterious_shop{id = 96,goods_id = 90105000,goods_num = 1,consume = [{3,5000}],lv = 40,weight = 25,career = 1};
get(97) ->
#base_mysterious_shop{id = 97,goods_id = 90107000,goods_num = 1,consume = [{3,5000}],lv = 40,weight = 25,career = 1};
get(98) ->
#base_mysterious_shop{id = 98,goods_id = 90110000,goods_num = 1,consume = [{3,5000}],lv = 40,weight = 25,career = 1};
get(99) ->
#base_mysterious_shop{id = 99,goods_id = 90112000,goods_num = 1,consume = [{3,5000}],lv = 40,weight = 25,career = 1};
get(100) ->
#base_mysterious_shop{id = 100,goods_id = 90125000,goods_num = 1,consume = [{3,5000}],lv = 40,weight = 25,career = 1};
get(101) ->
#base_mysterious_shop{id = 101,goods_id = 90126000,goods_num = 1,consume = [{3,5000}],lv = 40,weight = 25,career = 1};
get(102) ->
#base_mysterious_shop{id = 102,goods_id = 90128000,goods_num = 1,consume = [{3,5000}],lv = 40,weight = 25,career = 1};
get(103) ->
#base_mysterious_shop{id = 103,goods_id = 90106000,goods_num = 1,consume = [{1,120}],lv = 50,weight = 12,career = 1};
get(104) ->
#base_mysterious_shop{id = 104,goods_id = 90108000,goods_num = 1,consume = [{1,120}],lv = 50,weight = 12,career = 1};
get(105) ->
#base_mysterious_shop{id = 105,goods_id = 90113000,goods_num = 1,consume = [{1,120}],lv = 50,weight = 12,career = 1};
get(106) ->
#base_mysterious_shop{id = 106,goods_id = 90114000,goods_num = 1,consume = [{1,120}],lv = 50,weight = 12,career = 1};
get(107) ->
#base_mysterious_shop{id = 107,goods_id = 90127000,goods_num = 1,consume = [{1,120}],lv = 50,weight = 12,career = 1};
get(108) ->
#base_mysterious_shop{id = 108,goods_id = 90129000,goods_num = 1,consume = [{1,120}],lv = 50,weight = 12,career = 1};
get(109) ->
#base_mysterious_shop{id = 109,goods_id = 90101000,goods_num = 1,consume = [{3,1000}],lv = 40,weight = 50,career = 1};
get(110) ->
#base_mysterious_shop{id = 110,goods_id = 90102000,goods_num = 1,consume = [{3,1000}],lv = 40,weight = 50,career = 1};
get(111) ->
#base_mysterious_shop{id = 111,goods_id = 90103000,goods_num = 1,consume = [{3,1000}],lv = 40,weight = 50,career = 1};
get(112) ->
#base_mysterious_shop{id = 112,goods_id = 90104000,goods_num = 1,consume = [{3,1000}],lv = 40,weight = 50,career = 1};
get(113) ->
#base_mysterious_shop{id = 113,goods_id = 90111000,goods_num = 1,consume = [{3,1000}],lv = 40,weight = 50,career = 1};
get(114) ->
#base_mysterious_shop{id = 114,goods_id = 90122000,goods_num = 1,consume = [{3,1000}],lv = 40,weight = 50,career = 1};
get(115) ->
#base_mysterious_shop{id = 115,goods_id = 90124000,goods_num = 1,consume = [{3,5000}],lv = 40,weight = 50,career = 1};
get(116) ->
#base_mysterious_shop{id = 116,goods_id = 90105000,goods_num = 1,consume = [{3,5000}],lv = 50,weight = 25,career = 1};
get(117) ->
#base_mysterious_shop{id = 117,goods_id = 90107000,goods_num = 1,consume = [{3,5000}],lv = 50,weight = 25,career = 1};
get(118) ->
#base_mysterious_shop{id = 118,goods_id = 90110000,goods_num = 1,consume = [{3,5000}],lv = 50,weight = 25,career = 1};
get(119) ->
#base_mysterious_shop{id = 119,goods_id = 90112000,goods_num = 1,consume = [{3,5000}],lv = 50,weight = 25,career = 1};
get(120) ->
#base_mysterious_shop{id = 120,goods_id = 90125000,goods_num = 1,consume = [{3,5000}],lv = 50,weight = 25,career = 1};
get(121) ->
#base_mysterious_shop{id = 121,goods_id = 90126000,goods_num = 1,consume = [{3,5000}],lv = 50,weight = 25,career = 1};
get(122) ->
#base_mysterious_shop{id = 122,goods_id = 90128000,goods_num = 1,consume = [{3,5000}],lv = 50,weight = 25,career = 1};
get(123) ->
#base_mysterious_shop{id = 123,goods_id = 90106000,goods_num = 1,consume = [{1,120}],lv = 60,weight = 12,career = 1};
get(124) ->
#base_mysterious_shop{id = 124,goods_id = 90108000,goods_num = 1,consume = [{1,120}],lv = 60,weight = 12,career = 1};
get(125) ->
#base_mysterious_shop{id = 125,goods_id = 90113000,goods_num = 1,consume = [{1,120}],lv = 60,weight = 12,career = 1};
get(126) ->
#base_mysterious_shop{id = 126,goods_id = 90114000,goods_num = 1,consume = [{1,120}],lv = 60,weight = 12,career = 1};
get(127) ->
#base_mysterious_shop{id = 127,goods_id = 90127000,goods_num = 1,consume = [{1,120}],lv = 60,weight = 12,career = 1};
get(128) ->
#base_mysterious_shop{id = 128,goods_id = 90129000,goods_num = 1,consume = [{1,120}],lv = 60,weight = 12,career = 1};
get(129) ->
#base_mysterious_shop{id = 129,goods_id = 90101000,goods_num = 1,consume = [{3,1000}],lv = 50,weight = 50,career = 1};
get(130) ->
#base_mysterious_shop{id = 130,goods_id = 90102000,goods_num = 1,consume = [{3,1000}],lv = 50,weight = 50,career = 1};
get(131) ->
#base_mysterious_shop{id = 131,goods_id = 90103000,goods_num = 1,consume = [{3,1000}],lv = 50,weight = 50,career = 1};
get(132) ->
#base_mysterious_shop{id = 132,goods_id = 90104000,goods_num = 1,consume = [{3,1000}],lv = 50,weight = 50,career = 1};
get(133) ->
#base_mysterious_shop{id = 133,goods_id = 90111000,goods_num = 1,consume = [{3,1000}],lv = 50,weight = 50,career = 1};
get(134) ->
#base_mysterious_shop{id = 134,goods_id = 90122000,goods_num = 1,consume = [{3,1000}],lv = 50,weight = 50,career = 1};
get(135) ->
#base_mysterious_shop{id = 135,goods_id = 90124000,goods_num = 1,consume = [{3,5000}],lv = 50,weight = 50,career = 1};
get(136) ->
#base_mysterious_shop{id = 136,goods_id = 90105000,goods_num = 1,consume = [{3,5000}],lv = 60,weight = 25,career = 1};
get(137) ->
#base_mysterious_shop{id = 137,goods_id = 90107000,goods_num = 1,consume = [{3,5000}],lv = 60,weight = 25,career = 1};
get(138) ->
#base_mysterious_shop{id = 138,goods_id = 90110000,goods_num = 1,consume = [{3,5000}],lv = 60,weight = 25,career = 1};
get(139) ->
#base_mysterious_shop{id = 139,goods_id = 90112000,goods_num = 1,consume = [{3,5000}],lv = 60,weight = 25,career = 1};
get(140) ->
#base_mysterious_shop{id = 140,goods_id = 90125000,goods_num = 1,consume = [{3,5000}],lv = 60,weight = 25,career = 1};
get(141) ->
#base_mysterious_shop{id = 141,goods_id = 90126000,goods_num = 1,consume = [{3,5000}],lv = 60,weight = 25,career = 1};
get(142) ->
#base_mysterious_shop{id = 142,goods_id = 90128000,goods_num = 1,consume = [{3,5000}],lv = 60,weight = 25,career = 1};
get(143) ->
#base_mysterious_shop{id = 143,goods_id = 90106000,goods_num = 1,consume = [{1,120}],lv = 70,weight = 12,career = 1};
get(144) ->
#base_mysterious_shop{id = 144,goods_id = 90108000,goods_num = 1,consume = [{1,120}],lv = 70,weight = 12,career = 1};
get(145) ->
#base_mysterious_shop{id = 145,goods_id = 90113000,goods_num = 1,consume = [{1,120}],lv = 70,weight = 12,career = 1};
get(146) ->
#base_mysterious_shop{id = 146,goods_id = 90114000,goods_num = 1,consume = [{1,120}],lv = 70,weight = 12,career = 1};
get(147) ->
#base_mysterious_shop{id = 147,goods_id = 90127000,goods_num = 1,consume = [{1,120}],lv = 70,weight = 12,career = 1};
get(148) ->
#base_mysterious_shop{id = 148,goods_id = 90129000,goods_num = 1,consume = [{1,120}],lv = 70,weight = 12,career = 1};
get(149) ->
#base_mysterious_shop{id = 149,goods_id = 90101000,goods_num = 1,consume = [{3,1000}],lv = 60,weight = 50,career = 1};
get(150) ->
#base_mysterious_shop{id = 150,goods_id = 90102000,goods_num = 1,consume = [{3,1000}],lv = 60,weight = 50,career = 1};
get(151) ->
#base_mysterious_shop{id = 151,goods_id = 90103000,goods_num = 1,consume = [{3,1000}],lv = 60,weight = 50,career = 1};
get(152) ->
#base_mysterious_shop{id = 152,goods_id = 90104000,goods_num = 1,consume = [{3,1000}],lv = 60,weight = 50,career = 1};
get(153) ->
#base_mysterious_shop{id = 153,goods_id = 90111000,goods_num = 1,consume = [{3,1000}],lv = 60,weight = 50,career = 1};
get(154) ->
#base_mysterious_shop{id = 154,goods_id = 90122000,goods_num = 1,consume = [{3,1000}],lv = 60,weight = 50,career = 1};
get(155) ->
#base_mysterious_shop{id = 155,goods_id = 90124000,goods_num = 1,consume = [{3,5000}],lv = 60,weight = 50,career = 1};
get(156) ->
#base_mysterious_shop{id = 156,goods_id = 90105000,goods_num = 1,consume = [{3,5000}],lv = 70,weight = 25,career = 1};
get(157) ->
#base_mysterious_shop{id = 157,goods_id = 90107000,goods_num = 1,consume = [{3,5000}],lv = 70,weight = 25,career = 1};
get(158) ->
#base_mysterious_shop{id = 158,goods_id = 90110000,goods_num = 1,consume = [{3,5000}],lv = 70,weight = 25,career = 1};
get(159) ->
#base_mysterious_shop{id = 159,goods_id = 90112000,goods_num = 1,consume = [{3,5000}],lv = 70,weight = 25,career = 1};
get(160) ->
#base_mysterious_shop{id = 160,goods_id = 90125000,goods_num = 1,consume = [{3,5000}],lv = 70,weight = 25,career = 1};
get(161) ->
#base_mysterious_shop{id = 161,goods_id = 90126000,goods_num = 1,consume = [{3,5000}],lv = 70,weight = 25,career = 1};
get(162) ->
#base_mysterious_shop{id = 162,goods_id = 90128000,goods_num = 1,consume = [{3,5000}],lv = 70,weight = 25,career = 1};
get(163) ->
#base_mysterious_shop{id = 163,goods_id = 90106000,goods_num = 1,consume = [{1,120}],lv = 80,weight = 12,career = 1};
get(164) ->
#base_mysterious_shop{id = 164,goods_id = 90108000,goods_num = 1,consume = [{1,120}],lv = 80,weight = 12,career = 1};
get(165) ->
#base_mysterious_shop{id = 165,goods_id = 90113000,goods_num = 1,consume = [{1,120}],lv = 80,weight = 12,career = 1};
get(166) ->
#base_mysterious_shop{id = 166,goods_id = 90114000,goods_num = 1,consume = [{1,120}],lv = 80,weight = 12,career = 1};
get(167) ->
#base_mysterious_shop{id = 167,goods_id = 90127000,goods_num = 1,consume = [{1,120}],lv = 80,weight = 12,career = 1};
get(168) ->
#base_mysterious_shop{id = 168,goods_id = 90129000,goods_num = 1,consume = [{1,120}],lv = 80,weight = 12,career = 1};
get(169) ->
#base_mysterious_shop{id = 169,goods_id = 90101000,goods_num = 1,consume = [{3,1000}],lv = 70,weight = 50,career = 1};
get(170) ->
#base_mysterious_shop{id = 170,goods_id = 90102000,goods_num = 1,consume = [{3,1000}],lv = 70,weight = 50,career = 1};
get(171) ->
#base_mysterious_shop{id = 171,goods_id = 90103000,goods_num = 1,consume = [{3,1000}],lv = 70,weight = 50,career = 1};
get(172) ->
#base_mysterious_shop{id = 172,goods_id = 90104000,goods_num = 1,consume = [{3,1000}],lv = 70,weight = 50,career = 1};
get(173) ->
#base_mysterious_shop{id = 173,goods_id = 90111000,goods_num = 1,consume = [{3,1000}],lv = 70,weight = 50,career = 1};
get(174) ->
#base_mysterious_shop{id = 174,goods_id = 90122000,goods_num = 1,consume = [{3,1000}],lv = 70,weight = 50,career = 1};
get(175) ->
#base_mysterious_shop{id = 175,goods_id = 90124000,goods_num = 1,consume = [{3,5000}],lv = 70,weight = 50,career = 1};
get(176) ->
#base_mysterious_shop{id = 176,goods_id = 90105000,goods_num = 1,consume = [{3,5000}],lv = 80,weight = 25,career = 1};
get(177) ->
#base_mysterious_shop{id = 177,goods_id = 90107000,goods_num = 1,consume = [{3,5000}],lv = 80,weight = 25,career = 1};
get(178) ->
#base_mysterious_shop{id = 178,goods_id = 90110000,goods_num = 1,consume = [{3,5000}],lv = 80,weight = 25,career = 1};
get(179) ->
#base_mysterious_shop{id = 179,goods_id = 90112000,goods_num = 1,consume = [{3,5000}],lv = 80,weight = 25,career = 1};
get(180) ->
#base_mysterious_shop{id = 180,goods_id = 90125000,goods_num = 1,consume = [{3,5000}],lv = 80,weight = 25,career = 1};
get(181) ->
#base_mysterious_shop{id = 181,goods_id = 90126000,goods_num = 1,consume = [{3,5000}],lv = 80,weight = 25,career = 1};
get(182) ->
#base_mysterious_shop{id = 182,goods_id = 90128000,goods_num = 1,consume = [{3,5000}],lv = 80,weight = 25,career = 1};
get(183) ->
#base_mysterious_shop{id = 183,goods_id = 90106000,goods_num = 1,consume = [{1,120}],lv = 90,weight = 12,career = 1};
get(184) ->
#base_mysterious_shop{id = 184,goods_id = 90108000,goods_num = 1,consume = [{1,120}],lv = 90,weight = 12,career = 1};
get(185) ->
#base_mysterious_shop{id = 185,goods_id = 90113000,goods_num = 1,consume = [{1,120}],lv = 90,weight = 12,career = 1};
get(186) ->
#base_mysterious_shop{id = 186,goods_id = 90114000,goods_num = 1,consume = [{1,120}],lv = 90,weight = 12,career = 1};
get(187) ->
#base_mysterious_shop{id = 187,goods_id = 90127000,goods_num = 1,consume = [{1,120}],lv = 90,weight = 12,career = 1};
get(188) ->
#base_mysterious_shop{id = 188,goods_id = 90129000,goods_num = 1,consume = [{1,120}],lv = 90,weight = 12,career = 1};
get(189) ->
#base_mysterious_shop{id = 189,goods_id = 90101000,goods_num = 1,consume = [{3,1000}],lv = 80,weight = 50,career = 1};
get(190) ->
#base_mysterious_shop{id = 190,goods_id = 90102000,goods_num = 1,consume = [{3,1000}],lv = 80,weight = 50,career = 1};
get(191) ->
#base_mysterious_shop{id = 191,goods_id = 90103000,goods_num = 1,consume = [{3,1000}],lv = 80,weight = 50,career = 1};
get(192) ->
#base_mysterious_shop{id = 192,goods_id = 90104000,goods_num = 1,consume = [{3,1000}],lv = 80,weight = 50,career = 1};
get(193) ->
#base_mysterious_shop{id = 193,goods_id = 90111000,goods_num = 1,consume = [{3,1000}],lv = 80,weight = 50,career = 1};
get(194) ->
#base_mysterious_shop{id = 194,goods_id = 90122000,goods_num = 1,consume = [{3,1000}],lv = 80,weight = 50,career = 1};
get(195) ->
#base_mysterious_shop{id = 195,goods_id = 90124000,goods_num = 1,consume = [{3,5000}],lv = 80,weight = 50,career = 1};
get(196) ->
#base_mysterious_shop{id = 196,goods_id = 90105000,goods_num = 1,consume = [{3,5000}],lv = 90,weight = 25,career = 1};
get(197) ->
#base_mysterious_shop{id = 197,goods_id = 90107000,goods_num = 1,consume = [{3,5000}],lv = 90,weight = 25,career = 1};
get(198) ->
#base_mysterious_shop{id = 198,goods_id = 90110000,goods_num = 1,consume = [{3,5000}],lv = 90,weight = 25,career = 1};
get(199) ->
#base_mysterious_shop{id = 199,goods_id = 90112000,goods_num = 1,consume = [{3,5000}],lv = 90,weight = 25,career = 1};
get(200) ->
#base_mysterious_shop{id = 200,goods_id = 90125000,goods_num = 1,consume = [{3,5000}],lv = 90,weight = 25,career = 1};
get(201) ->
#base_mysterious_shop{id = 201,goods_id = 90126000,goods_num = 1,consume = [{3,5000}],lv = 90,weight = 25,career = 1};
get(202) ->
#base_mysterious_shop{id = 202,goods_id = 90128000,goods_num = 1,consume = [{3,5000}],lv = 90,weight = 25,career = 1};
get(203) ->
#base_mysterious_shop{id = 203,goods_id = 90106000,goods_num = 1,consume = [{1,120}],lv = 100,weight = 12,career = 1};
get(204) ->
#base_mysterious_shop{id = 204,goods_id = 90108000,goods_num = 1,consume = [{1,120}],lv = 100,weight = 12,career = 1};
get(205) ->
#base_mysterious_shop{id = 205,goods_id = 90113000,goods_num = 1,consume = [{1,120}],lv = 100,weight = 12,career = 1};
get(206) ->
#base_mysterious_shop{id = 206,goods_id = 90114000,goods_num = 1,consume = [{1,120}],lv = 100,weight = 12,career = 1};
get(207) ->
#base_mysterious_shop{id = 207,goods_id = 90127000,goods_num = 1,consume = [{1,120}],lv = 100,weight = 12,career = 1};
get(208) ->
#base_mysterious_shop{id = 208,goods_id = 90129000,goods_num = 1,consume = [{1,120}],lv = 100,weight = 12,career = 1};
get(209) ->
#base_mysterious_shop{id = 209,goods_id = 90101000,goods_num = 1,consume = [{3,1000}],lv = 90,weight = 50,career = 1};
get(210) ->
#base_mysterious_shop{id = 210,goods_id = 90102000,goods_num = 1,consume = [{3,1000}],lv = 90,weight = 50,career = 1};
get(211) ->
#base_mysterious_shop{id = 211,goods_id = 90103000,goods_num = 1,consume = [{3,1000}],lv = 90,weight = 50,career = 1};
get(212) ->
#base_mysterious_shop{id = 212,goods_id = 90104000,goods_num = 1,consume = [{3,1000}],lv = 90,weight = 50,career = 1};
get(213) ->
#base_mysterious_shop{id = 213,goods_id = 90111000,goods_num = 1,consume = [{3,1000}],lv = 90,weight = 50,career = 1};
get(214) ->
#base_mysterious_shop{id = 214,goods_id = 90122000,goods_num = 1,consume = [{3,1000}],lv = 90,weight = 50,career = 1};
get(215) ->
#base_mysterious_shop{id = 215,goods_id = 90124000,goods_num = 1,consume = [{3,5000}],lv = 90,weight = 50,career = 1};
get(216) ->
#base_mysterious_shop{id = 216,goods_id = 90105000,goods_num = 1,consume = [{3,5000}],lv = 100,weight = 25,career = 1};
get(217) ->
#base_mysterious_shop{id = 217,goods_id = 90107000,goods_num = 1,consume = [{3,5000}],lv = 100,weight = 25,career = 1};
get(218) ->
#base_mysterious_shop{id = 218,goods_id = 90110000,goods_num = 1,consume = [{3,5000}],lv = 100,weight = 25,career = 1};
get(219) ->
#base_mysterious_shop{id = 219,goods_id = 90112000,goods_num = 1,consume = [{3,5000}],lv = 100,weight = 25,career = 1};
get(220) ->
#base_mysterious_shop{id = 220,goods_id = 90125000,goods_num = 1,consume = [{3,5000}],lv = 100,weight = 25,career = 1};
get(221) ->
#base_mysterious_shop{id = 221,goods_id = 90126000,goods_num = 1,consume = [{3,5000}],lv = 100,weight = 25,career = 1};
get(222) ->
#base_mysterious_shop{id = 222,goods_id = 90128000,goods_num = 1,consume = [{3,5000}],lv = 100,weight = 25,career = 1};
get(223) ->
#base_mysterious_shop{id = 223,goods_id = 90106000,goods_num = 1,consume = [{1,120}],lv = 110,weight = 12,career = 1};
get(224) ->
#base_mysterious_shop{id = 224,goods_id = 90108000,goods_num = 1,consume = [{1,120}],lv = 110,weight = 12,career = 1};
get(225) ->
#base_mysterious_shop{id = 225,goods_id = 90113000,goods_num = 1,consume = [{1,120}],lv = 110,weight = 12,career = 1};
get(226) ->
#base_mysterious_shop{id = 226,goods_id = 90114000,goods_num = 1,consume = [{1,120}],lv = 110,weight = 12,career = 1};
get(227) ->
#base_mysterious_shop{id = 227,goods_id = 90127000,goods_num = 1,consume = [{1,120}],lv = 110,weight = 12,career = 1};
get(228) ->
#base_mysterious_shop{id = 228,goods_id = 90129000,goods_num = 1,consume = [{1,120}],lv = 110,weight = 12,career = 1};
get(229) ->
#base_mysterious_shop{id = 229,goods_id = 90101000,goods_num = 1,consume = [{3,1000}],lv = 100,weight = 50,career = 1};
get(230) ->
#base_mysterious_shop{id = 230,goods_id = 90102000,goods_num = 1,consume = [{3,1000}],lv = 100,weight = 50,career = 1};
get(231) ->
#base_mysterious_shop{id = 231,goods_id = 90103000,goods_num = 1,consume = [{3,1000}],lv = 100,weight = 50,career = 1};
get(232) ->
#base_mysterious_shop{id = 232,goods_id = 90104000,goods_num = 1,consume = [{3,1000}],lv = 100,weight = 50,career = 1};
get(233) ->
#base_mysterious_shop{id = 233,goods_id = 90111000,goods_num = 1,consume = [{3,1000}],lv = 100,weight = 50,career = 1};
get(234) ->
#base_mysterious_shop{id = 234,goods_id = 90122000,goods_num = 1,consume = [{3,1000}],lv = 100,weight = 50,career = 1};
get(235) ->
#base_mysterious_shop{id = 235,goods_id = 90124000,goods_num = 1,consume = [{3,5000}],lv = 100,weight = 50,career = 1};
get(236) ->
#base_mysterious_shop{id = 236,goods_id = 90105000,goods_num = 1,consume = [{3,5000}],lv = 110,weight = 25,career = 1};
get(237) ->
#base_mysterious_shop{id = 237,goods_id = 90107000,goods_num = 1,consume = [{3,5000}],lv = 110,weight = 25,career = 1};
get(238) ->
#base_mysterious_shop{id = 238,goods_id = 90110000,goods_num = 1,consume = [{3,5000}],lv = 110,weight = 25,career = 1};
get(239) ->
#base_mysterious_shop{id = 239,goods_id = 90112000,goods_num = 1,consume = [{3,5000}],lv = 110,weight = 25,career = 1};
get(240) ->
#base_mysterious_shop{id = 240,goods_id = 90125000,goods_num = 1,consume = [{3,5000}],lv = 110,weight = 25,career = 1};
get(241) ->
#base_mysterious_shop{id = 241,goods_id = 90126000,goods_num = 1,consume = [{3,5000}],lv = 110,weight = 25,career = 1};
get(242) ->
#base_mysterious_shop{id = 242,goods_id = 90128000,goods_num = 1,consume = [{3,5000}],lv = 110,weight = 25,career = 1};
get(243) ->
#base_mysterious_shop{id = 243,goods_id = 90106000,goods_num = 1,consume = [{1,120}],lv = 120,weight = 12,career = 1};
get(244) ->
#base_mysterious_shop{id = 244,goods_id = 90108000,goods_num = 1,consume = [{1,120}],lv = 120,weight = 12,career = 1};
get(245) ->
#base_mysterious_shop{id = 245,goods_id = 90113000,goods_num = 1,consume = [{1,120}],lv = 120,weight = 12,career = 1};
get(246) ->
#base_mysterious_shop{id = 246,goods_id = 90114000,goods_num = 1,consume = [{1,120}],lv = 120,weight = 12,career = 1};
get(247) ->
#base_mysterious_shop{id = 247,goods_id = 90127000,goods_num = 1,consume = [{1,120}],lv = 120,weight = 12,career = 1};
get(248) ->
#base_mysterious_shop{id = 248,goods_id = 90129000,goods_num = 1,consume = [{1,120}],lv = 120,weight = 12,career = 1};
get(249) ->
#base_mysterious_shop{id = 249,goods_id = 280101,goods_num = 5,consume = [{1,10}],lv = 30,weight = 300,career = 0};
get(250) ->
#base_mysterious_shop{id = 250,goods_id = 280102,goods_num = 5,consume = [{1,10}],lv = 40,weight = 300,career = 0};
get(251) ->
#base_mysterious_shop{id = 251,goods_id = 280103,goods_num = 5,consume = [{1,10}],lv = 50,weight = 300,career = 0};
get(252) ->
#base_mysterious_shop{id = 252,goods_id = 280104,goods_num = 5,consume = [{1,10}],lv = 60,weight = 300,career = 0};
get(253) ->
#base_mysterious_shop{id = 253,goods_id = 280105,goods_num = 5,consume = [{1,10}],lv = 70,weight = 300,career = 0};
get(254) ->
#base_mysterious_shop{id = 254,goods_id = 280106,goods_num = 5,consume = [{1,10}],lv = 80,weight = 300,career = 0};
get(255) ->
#base_mysterious_shop{id = 255,goods_id = 280107,goods_num = 5,consume = [{1,10}],lv = 90,weight = 300,career = 0};
get(256) ->
#base_mysterious_shop{id = 256,goods_id = 280132,goods_num = 5,consume = [{1,10}],lv = 100,weight = 300,career = 0};
get(257) ->
#base_mysterious_shop{id = 257,goods_id = 30003001,goods_num = 1,consume = [{1,5}],lv = 10,weight = 500,career = 0};
get(258) ->
#base_mysterious_shop{id = 258,goods_id = 30003002,goods_num = 1,consume = [{1,10}],lv = 25,weight = 500,career = 0};
get(259) ->
#base_mysterious_shop{id = 259,goods_id = 30003003,goods_num = 1,consume = [{1,15}],lv = 40,weight = 500,career = 0};
get(260) ->
#base_mysterious_shop{id = 260,goods_id = 30003004,goods_num = 1,consume = [{1,20}],lv = 55,weight = 500,career = 0};
get(261) ->
#base_mysterious_shop{id = 261,goods_id = 30003005,goods_num = 1,consume = [{1,25}],lv = 70,weight = 500,career = 0};
get(262) ->
#base_mysterious_shop{id = 262,goods_id = 30003006,goods_num = 1,consume = [{1,30}],lv = 85,weight = 500,career = 0};
get(263) ->
#base_mysterious_shop{id = 263,goods_id = 30004001,goods_num = 1,consume = [{1,10}],lv = 30,weight = 500,career = 0};
get(264) ->
#base_mysterious_shop{id = 264,goods_id = 30004002,goods_num = 1,consume = [{1,22}],lv = 45,weight = 500,career = 0};
get(265) ->
#base_mysterious_shop{id = 265,goods_id = 30004003,goods_num = 1,consume = [{1,36}],lv = 60,weight = 500,career = 0};
get(266) ->
#base_mysterious_shop{id = 266,goods_id = 30004004,goods_num = 1,consume = [{1,52}],lv = 75,weight = 500,career = 0};
get(267) ->
#base_mysterious_shop{id = 267,goods_id = 30004005,goods_num = 1,consume = [{1,72}],lv = 90,weight = 500,career = 0};
get(268) ->
#base_mysterious_shop{id = 268,goods_id = 30004006,goods_num = 1,consume = [{1,96}],lv = 105,weight = 500,career = 0};
get(269) ->
#base_mysterious_shop{id = 269,goods_id = 30001001,goods_num = 1,consume = [{1,5}],lv = 15,weight = 500,career = 0};
get(270) ->
#base_mysterious_shop{id = 270,goods_id = 30001002,goods_num = 1,consume = [{1,10}],lv = 25,weight = 500,career = 0};
get(271) ->
#base_mysterious_shop{id = 271,goods_id = 30001003,goods_num = 1,consume = [{1,15}],lv = 35,weight = 500,career = 0};
get(272) ->
#base_mysterious_shop{id = 272,goods_id = 30001004,goods_num = 1,consume = [{1,20}],lv = 45,weight = 500,career = 0};
get(273) ->
#base_mysterious_shop{id = 273,goods_id = 30001005,goods_num = 1,consume = [{1,25}],lv = 55,weight = 500,career = 0};
get(274) ->
#base_mysterious_shop{id = 274,goods_id = 30001006,goods_num = 1,consume = [{1,30}],lv = 65,weight = 500,career = 0};
get(275) ->
#base_mysterious_shop{id = 275,goods_id = 30001007,goods_num = 1,consume = [{1,35}],lv = 75,weight = 500,career = 0};
get(276) ->
#base_mysterious_shop{id = 276,goods_id = 30001008,goods_num = 1,consume = [{1,40}],lv = 85,weight = 500,career = 0};
get(277) ->
#base_mysterious_shop{id = 277,goods_id = 30001009,goods_num = 1,consume = [{1,45}],lv = 95,weight = 500,career = 0};
get(278) ->
#base_mysterious_shop{id = 278,goods_id = 30002001,goods_num = 1,consume = [{1,5}],lv = 15,weight = 500,career = 0};
get(279) ->
#base_mysterious_shop{id = 279,goods_id = 30002002,goods_num = 1,consume = [{1,10}],lv = 25,weight = 500,career = 0};
get(280) ->
#base_mysterious_shop{id = 280,goods_id = 30002003,goods_num = 1,consume = [{1,15}],lv = 35,weight = 500,career = 0};
get(281) ->
#base_mysterious_shop{id = 281,goods_id = 30002004,goods_num = 1,consume = [{1,20}],lv = 45,weight = 500,career = 0};
get(282) ->
#base_mysterious_shop{id = 282,goods_id = 30002005,goods_num = 1,consume = [{1,25}],lv = 55,weight = 500,career = 0};
get(283) ->
#base_mysterious_shop{id = 283,goods_id = 30002006,goods_num = 1,consume = [{1,30}],lv = 65,weight = 500,career = 0};
get(284) ->
#base_mysterious_shop{id = 284,goods_id = 30002007,goods_num = 1,consume = [{1,35}],lv = 75,weight = 500,career = 0};
get(285) ->
#base_mysterious_shop{id = 285,goods_id = 30002008,goods_num = 1,consume = [{1,40}],lv = 85,weight = 500,career = 0};
get(286) ->
#base_mysterious_shop{id = 286,goods_id = 30002009,goods_num = 1,consume = [{1,45}],lv = 95,weight = 500,career = 0};
get(287) ->
#base_mysterious_shop{id = 287,goods_id = 300001,goods_num = 2,consume = [{1,2}],lv = 15,weight = 400,career = 0};
get(288) ->
#base_mysterious_shop{id = 288,goods_id = 300001,goods_num = 3,consume = [{1,3}],lv = 25,weight = 400,career = 0};
get(289) ->
#base_mysterious_shop{id = 289,goods_id = 300001,goods_num = 5,consume = [{1,5}],lv = 35,weight = 400,career = 0};
get(290) ->
#base_mysterious_shop{id = 290,goods_id = 300001,goods_num = 6,consume = [{1,6}],lv = 45,weight = 400,career = 0};
get(291) ->
#base_mysterious_shop{id = 291,goods_id = 300001,goods_num = 8,consume = [{1,8}],lv = 55,weight = 400,career = 0};
get(292) ->
#base_mysterious_shop{id = 292,goods_id = 300001,goods_num = 10,consume = [{1,10}],lv = 65,weight = 400,career = 0};
get(293) ->
#base_mysterious_shop{id = 293,goods_id = 300001,goods_num = 13,consume = [{1,13}],lv = 75,weight = 400,career = 0};
get(294) ->
#base_mysterious_shop{id = 294,goods_id = 300001,goods_num = 16,consume = [{1,16}],lv = 85,weight = 400,career = 0};
get(295) ->
#base_mysterious_shop{id = 295,goods_id = 300001,goods_num = 20,consume = [{1,20}],lv = 95,weight = 400,career = 0};
get(296) ->
#base_mysterious_shop{id = 296,goods_id = 300002,goods_num = 1,consume = [{1,4}],lv = 15,weight = 200,career = 0};
get(297) ->
#base_mysterious_shop{id = 297,goods_id = 300002,goods_num = 2,consume = [{1,8}],lv = 25,weight = 200,career = 0};
get(298) ->
#base_mysterious_shop{id = 298,goods_id = 300002,goods_num = 3,consume = [{1,12}],lv = 35,weight = 200,career = 0};
get(299) ->
#base_mysterious_shop{id = 299,goods_id = 300002,goods_num = 3,consume = [{1,12}],lv = 45,weight = 200,career = 0};
get(300) ->
#base_mysterious_shop{id = 300,goods_id = 300002,goods_num = 4,consume = [{1,16}],lv = 55,weight = 200,career = 0};
get(301) ->
#base_mysterious_shop{id = 301,goods_id = 300002,goods_num = 5,consume = [{1,20}],lv = 65,weight = 200,career = 0};
get(302) ->
#base_mysterious_shop{id = 302,goods_id = 300002,goods_num = 7,consume = [{1,28}],lv = 75,weight = 200,career = 0};
get(303) ->
#base_mysterious_shop{id = 303,goods_id = 300002,goods_num = 8,consume = [{1,32}],lv = 85,weight = 200,career = 0};
get(304) ->
#base_mysterious_shop{id = 304,goods_id = 300002,goods_num = 10,consume = [{1,40}],lv = 95,weight = 200,career = 0};
get(305) ->
#base_mysterious_shop{id = 305,goods_id = 300003,goods_num = 1,consume = [{1,16}],lv = 55,weight = 100,career = 0};
get(306) ->
#base_mysterious_shop{id = 306,goods_id = 300003,goods_num = 1,consume = [{1,16}],lv = 65,weight = 100,career = 0};
get(307) ->
#base_mysterious_shop{id = 307,goods_id = 300003,goods_num = 2,consume = [{1,32}],lv = 75,weight = 100,career = 0};
get(308) ->
#base_mysterious_shop{id = 308,goods_id = 300003,goods_num = 2,consume = [{1,32}],lv = 85,weight = 100,career = 0};
get(309) ->
#base_mysterious_shop{id = 309,goods_id = 300003,goods_num = 2,consume = [{1,32}],lv = 95,weight = 100,career = 0};
get(310) ->
#base_mysterious_shop{id = 310,goods_id = 300004,goods_num = 1,consume = [{1,64}],lv = 55,weight = 50,career = 0};
get(311) ->
#base_mysterious_shop{id = 311,goods_id = 300004,goods_num = 1,consume = [{1,64}],lv = 65,weight = 50,career = 0};
get(312) ->
#base_mysterious_shop{id = 312,goods_id = 300004,goods_num = 1,consume = [{1,64}],lv = 75,weight = 50,career = 0};
get(313) ->
#base_mysterious_shop{id = 313,goods_id = 300004,goods_num = 2,consume = [{1,128}],lv = 85,weight = 50,career = 0};
get(314) ->
#base_mysterious_shop{id = 314,goods_id = 300004,goods_num = 2,consume = [{1,128}],lv = 95,weight = 50,career = 0};
get(315) ->
#base_mysterious_shop{id = 315,goods_id = 90201000,goods_num = 1,consume = [{3,1000}],lv = 10,weight = 50,career = 2};
get(316) ->
#base_mysterious_shop{id = 316,goods_id = 90202000,goods_num = 1,consume = [{3,1000}],lv = 10,weight = 50,career = 2};
get(317) ->
#base_mysterious_shop{id = 317,goods_id = 90203000,goods_num = 1,consume = [{3,1000}],lv = 10,weight = 50,career = 2};
get(318) ->
#base_mysterious_shop{id = 318,goods_id = 90204000,goods_num = 1,consume = [{3,1000}],lv = 10,weight = 50,career = 2};
get(319) ->
#base_mysterious_shop{id = 319,goods_id = 90211000,goods_num = 1,consume = [{3,1000}],lv = 10,weight = 50,career = 2};
get(320) ->
#base_mysterious_shop{id = 320,goods_id = 90222000,goods_num = 1,consume = [{3,1000}],lv = 10,weight = 50,career = 2};
get(321) ->
#base_mysterious_shop{id = 321,goods_id = 90224000,goods_num = 1,consume = [{3,5000}],lv = 10,weight = 50,career = 2};
get(322) ->
#base_mysterious_shop{id = 322,goods_id = 90205000,goods_num = 1,consume = [{3,5000}],lv = 20,weight = 25,career = 2};
get(323) ->
#base_mysterious_shop{id = 323,goods_id = 90207000,goods_num = 1,consume = [{3,5000}],lv = 20,weight = 25,career = 2};
get(324) ->
#base_mysterious_shop{id = 324,goods_id = 90210000,goods_num = 1,consume = [{3,5000}],lv = 20,weight = 25,career = 2};
get(325) ->
#base_mysterious_shop{id = 325,goods_id = 90212000,goods_num = 1,consume = [{3,5000}],lv = 20,weight = 25,career = 2};
get(326) ->
#base_mysterious_shop{id = 326,goods_id = 90225000,goods_num = 1,consume = [{3,5000}],lv = 20,weight = 25,career = 2};
get(327) ->
#base_mysterious_shop{id = 327,goods_id = 90226000,goods_num = 1,consume = [{3,5000}],lv = 20,weight = 25,career = 2};
get(328) ->
#base_mysterious_shop{id = 328,goods_id = 90228000,goods_num = 1,consume = [{3,5000}],lv = 20,weight = 25,career = 2};
get(329) ->
#base_mysterious_shop{id = 329,goods_id = 90206000,goods_num = 1,consume = [{1,120}],lv = 30,weight = 12,career = 2};
get(330) ->
#base_mysterious_shop{id = 330,goods_id = 90208000,goods_num = 1,consume = [{1,120}],lv = 30,weight = 12,career = 2};
get(331) ->
#base_mysterious_shop{id = 331,goods_id = 90213000,goods_num = 1,consume = [{1,120}],lv = 30,weight = 12,career = 2};
get(332) ->
#base_mysterious_shop{id = 332,goods_id = 90214000,goods_num = 1,consume = [{1,120}],lv = 30,weight = 12,career = 2};
get(333) ->
#base_mysterious_shop{id = 333,goods_id = 90227000,goods_num = 1,consume = [{1,120}],lv = 30,weight = 12,career = 2};
get(334) ->
#base_mysterious_shop{id = 334,goods_id = 90229000,goods_num = 1,consume = [{1,120}],lv = 30,weight = 12,career = 2};
get(335) ->
#base_mysterious_shop{id = 335,goods_id = 90201000,goods_num = 1,consume = [{3,1000}],lv = 20,weight = 50,career = 2};
get(336) ->
#base_mysterious_shop{id = 336,goods_id = 90202000,goods_num = 1,consume = [{3,1000}],lv = 20,weight = 50,career = 2};
get(337) ->
#base_mysterious_shop{id = 337,goods_id = 90203000,goods_num = 1,consume = [{3,1000}],lv = 20,weight = 50,career = 2};
get(338) ->
#base_mysterious_shop{id = 338,goods_id = 90204000,goods_num = 1,consume = [{3,1000}],lv = 20,weight = 50,career = 2};
get(339) ->
#base_mysterious_shop{id = 339,goods_id = 90211000,goods_num = 1,consume = [{3,1000}],lv = 20,weight = 50,career = 2};
get(340) ->
#base_mysterious_shop{id = 340,goods_id = 90222000,goods_num = 1,consume = [{3,1000}],lv = 20,weight = 50,career = 2};
get(341) ->
#base_mysterious_shop{id = 341,goods_id = 90224000,goods_num = 1,consume = [{3,5000}],lv = 20,weight = 50,career = 2};
get(342) ->
#base_mysterious_shop{id = 342,goods_id = 90205000,goods_num = 1,consume = [{3,5000}],lv = 30,weight = 25,career = 2};
get(343) ->
#base_mysterious_shop{id = 343,goods_id = 90207000,goods_num = 1,consume = [{3,5000}],lv = 30,weight = 25,career = 2};
get(344) ->
#base_mysterious_shop{id = 344,goods_id = 90210000,goods_num = 1,consume = [{3,5000}],lv = 30,weight = 25,career = 2};
get(345) ->
#base_mysterious_shop{id = 345,goods_id = 90212000,goods_num = 1,consume = [{3,5000}],lv = 30,weight = 25,career = 2};
get(346) ->
#base_mysterious_shop{id = 346,goods_id = 90225000,goods_num = 1,consume = [{3,5000}],lv = 30,weight = 25,career = 2};
get(347) ->
#base_mysterious_shop{id = 347,goods_id = 90226000,goods_num = 1,consume = [{3,5000}],lv = 30,weight = 25,career = 2};
get(348) ->
#base_mysterious_shop{id = 348,goods_id = 90228000,goods_num = 1,consume = [{3,5000}],lv = 30,weight = 25,career = 2};
get(349) ->
#base_mysterious_shop{id = 349,goods_id = 90206000,goods_num = 1,consume = [{1,120}],lv = 40,weight = 12,career = 2};
get(350) ->
#base_mysterious_shop{id = 350,goods_id = 90208000,goods_num = 1,consume = [{1,120}],lv = 40,weight = 12,career = 2};
get(351) ->
#base_mysterious_shop{id = 351,goods_id = 90213000,goods_num = 1,consume = [{1,120}],lv = 40,weight = 12,career = 2};
get(352) ->
#base_mysterious_shop{id = 352,goods_id = 90214000,goods_num = 1,consume = [{1,120}],lv = 40,weight = 12,career = 2};
get(353) ->
#base_mysterious_shop{id = 353,goods_id = 90227000,goods_num = 1,consume = [{1,120}],lv = 40,weight = 12,career = 2};
get(354) ->
#base_mysterious_shop{id = 354,goods_id = 90229000,goods_num = 1,consume = [{1,120}],lv = 40,weight = 12,career = 2};
get(355) ->
#base_mysterious_shop{id = 355,goods_id = 90201000,goods_num = 1,consume = [{3,1000}],lv = 30,weight = 50,career = 2};
get(356) ->
#base_mysterious_shop{id = 356,goods_id = 90202000,goods_num = 1,consume = [{3,1000}],lv = 30,weight = 50,career = 2};
get(357) ->
#base_mysterious_shop{id = 357,goods_id = 90203000,goods_num = 1,consume = [{3,1000}],lv = 30,weight = 50,career = 2};
get(358) ->
#base_mysterious_shop{id = 358,goods_id = 90204000,goods_num = 1,consume = [{3,1000}],lv = 30,weight = 50,career = 2};
get(359) ->
#base_mysterious_shop{id = 359,goods_id = 90211000,goods_num = 1,consume = [{3,1000}],lv = 30,weight = 50,career = 2};
get(360) ->
#base_mysterious_shop{id = 360,goods_id = 90222000,goods_num = 1,consume = [{3,1000}],lv = 30,weight = 50,career = 2};
get(361) ->
#base_mysterious_shop{id = 361,goods_id = 90224000,goods_num = 1,consume = [{3,5000}],lv = 30,weight = 50,career = 2};
get(362) ->
#base_mysterious_shop{id = 362,goods_id = 90205000,goods_num = 1,consume = [{3,5000}],lv = 40,weight = 25,career = 2};
get(363) ->
#base_mysterious_shop{id = 363,goods_id = 90207000,goods_num = 1,consume = [{3,5000}],lv = 40,weight = 25,career = 2};
get(364) ->
#base_mysterious_shop{id = 364,goods_id = 90210000,goods_num = 1,consume = [{3,5000}],lv = 40,weight = 25,career = 2};
get(365) ->
#base_mysterious_shop{id = 365,goods_id = 90212000,goods_num = 1,consume = [{3,5000}],lv = 40,weight = 25,career = 2};
get(366) ->
#base_mysterious_shop{id = 366,goods_id = 90225000,goods_num = 1,consume = [{3,5000}],lv = 40,weight = 25,career = 2};
get(367) ->
#base_mysterious_shop{id = 367,goods_id = 90226000,goods_num = 1,consume = [{3,5000}],lv = 40,weight = 25,career = 2};
get(368) ->
#base_mysterious_shop{id = 368,goods_id = 90228000,goods_num = 1,consume = [{3,5000}],lv = 40,weight = 25,career = 2};
get(369) ->
#base_mysterious_shop{id = 369,goods_id = 90206000,goods_num = 1,consume = [{1,120}],lv = 50,weight = 12,career = 2};
get(370) ->
#base_mysterious_shop{id = 370,goods_id = 90208000,goods_num = 1,consume = [{1,120}],lv = 50,weight = 12,career = 2};
get(371) ->
#base_mysterious_shop{id = 371,goods_id = 90213000,goods_num = 1,consume = [{1,120}],lv = 50,weight = 12,career = 2};
get(372) ->
#base_mysterious_shop{id = 372,goods_id = 90214000,goods_num = 1,consume = [{1,120}],lv = 50,weight = 12,career = 2};
get(373) ->
#base_mysterious_shop{id = 373,goods_id = 90227000,goods_num = 1,consume = [{1,120}],lv = 50,weight = 12,career = 2};
get(374) ->
#base_mysterious_shop{id = 374,goods_id = 90229000,goods_num = 1,consume = [{1,120}],lv = 50,weight = 12,career = 2};
get(375) ->
#base_mysterious_shop{id = 375,goods_id = 90201000,goods_num = 1,consume = [{3,1000}],lv = 40,weight = 50,career = 2};
get(376) ->
#base_mysterious_shop{id = 376,goods_id = 90202000,goods_num = 1,consume = [{3,1000}],lv = 40,weight = 50,career = 2};
get(377) ->
#base_mysterious_shop{id = 377,goods_id = 90203000,goods_num = 1,consume = [{3,1000}],lv = 40,weight = 50,career = 2};
get(378) ->
#base_mysterious_shop{id = 378,goods_id = 90204000,goods_num = 1,consume = [{3,1000}],lv = 40,weight = 50,career = 2};
get(379) ->
#base_mysterious_shop{id = 379,goods_id = 90211000,goods_num = 1,consume = [{3,1000}],lv = 40,weight = 50,career = 2};
get(380) ->
#base_mysterious_shop{id = 380,goods_id = 90222000,goods_num = 1,consume = [{3,1000}],lv = 40,weight = 50,career = 2};
get(381) ->
#base_mysterious_shop{id = 381,goods_id = 90224000,goods_num = 1,consume = [{3,5000}],lv = 40,weight = 50,career = 2};
get(382) ->
#base_mysterious_shop{id = 382,goods_id = 90205000,goods_num = 1,consume = [{3,5000}],lv = 50,weight = 25,career = 2};
get(383) ->
#base_mysterious_shop{id = 383,goods_id = 90207000,goods_num = 1,consume = [{3,5000}],lv = 50,weight = 25,career = 2};
get(384) ->
#base_mysterious_shop{id = 384,goods_id = 90210000,goods_num = 1,consume = [{3,5000}],lv = 50,weight = 25,career = 2};
get(385) ->
#base_mysterious_shop{id = 385,goods_id = 90212000,goods_num = 1,consume = [{3,5000}],lv = 50,weight = 25,career = 2};
get(386) ->
#base_mysterious_shop{id = 386,goods_id = 90225000,goods_num = 1,consume = [{3,5000}],lv = 50,weight = 25,career = 2};
get(387) ->
#base_mysterious_shop{id = 387,goods_id = 90226000,goods_num = 1,consume = [{3,5000}],lv = 50,weight = 25,career = 2};
get(388) ->
#base_mysterious_shop{id = 388,goods_id = 90228000,goods_num = 1,consume = [{3,5000}],lv = 50,weight = 25,career = 2};
get(389) ->
#base_mysterious_shop{id = 389,goods_id = 90206000,goods_num = 1,consume = [{1,120}],lv = 60,weight = 12,career = 2};
get(390) ->
#base_mysterious_shop{id = 390,goods_id = 90208000,goods_num = 1,consume = [{1,120}],lv = 60,weight = 12,career = 2};
get(391) ->
#base_mysterious_shop{id = 391,goods_id = 90213000,goods_num = 1,consume = [{1,120}],lv = 60,weight = 12,career = 2};
get(392) ->
#base_mysterious_shop{id = 392,goods_id = 90214000,goods_num = 1,consume = [{1,120}],lv = 60,weight = 12,career = 2};
get(393) ->
#base_mysterious_shop{id = 393,goods_id = 90227000,goods_num = 1,consume = [{1,120}],lv = 60,weight = 12,career = 2};
get(394) ->
#base_mysterious_shop{id = 394,goods_id = 90229000,goods_num = 1,consume = [{1,120}],lv = 60,weight = 12,career = 2};
get(395) ->
#base_mysterious_shop{id = 395,goods_id = 90201000,goods_num = 1,consume = [{3,1000}],lv = 50,weight = 50,career = 2};
get(396) ->
#base_mysterious_shop{id = 396,goods_id = 90202000,goods_num = 1,consume = [{3,1000}],lv = 50,weight = 50,career = 2};
get(397) ->
#base_mysterious_shop{id = 397,goods_id = 90203000,goods_num = 1,consume = [{3,1000}],lv = 50,weight = 50,career = 2};
get(398) ->
#base_mysterious_shop{id = 398,goods_id = 90204000,goods_num = 1,consume = [{3,1000}],lv = 50,weight = 50,career = 2};
get(399) ->
#base_mysterious_shop{id = 399,goods_id = 90211000,goods_num = 1,consume = [{3,1000}],lv = 50,weight = 50,career = 2};
get(400) ->
#base_mysterious_shop{id = 400,goods_id = 90222000,goods_num = 1,consume = [{3,1000}],lv = 50,weight = 50,career = 2};
get(401) ->
#base_mysterious_shop{id = 401,goods_id = 90224000,goods_num = 1,consume = [{3,5000}],lv = 50,weight = 50,career = 2};
get(402) ->
#base_mysterious_shop{id = 402,goods_id = 90205000,goods_num = 1,consume = [{3,5000}],lv = 60,weight = 25,career = 2};
get(403) ->
#base_mysterious_shop{id = 403,goods_id = 90207000,goods_num = 1,consume = [{3,5000}],lv = 60,weight = 25,career = 2};
get(404) ->
#base_mysterious_shop{id = 404,goods_id = 90210000,goods_num = 1,consume = [{3,5000}],lv = 60,weight = 25,career = 2};
get(405) ->
#base_mysterious_shop{id = 405,goods_id = 90212000,goods_num = 1,consume = [{3,5000}],lv = 60,weight = 25,career = 2};
get(406) ->
#base_mysterious_shop{id = 406,goods_id = 90225000,goods_num = 1,consume = [{3,5000}],lv = 60,weight = 25,career = 2};
get(407) ->
#base_mysterious_shop{id = 407,goods_id = 90226000,goods_num = 1,consume = [{3,5000}],lv = 60,weight = 25,career = 2};
get(408) ->
#base_mysterious_shop{id = 408,goods_id = 90228000,goods_num = 1,consume = [{3,5000}],lv = 60,weight = 25,career = 2};
get(409) ->
#base_mysterious_shop{id = 409,goods_id = 90206000,goods_num = 1,consume = [{1,120}],lv = 70,weight = 12,career = 2};
get(410) ->
#base_mysterious_shop{id = 410,goods_id = 90208000,goods_num = 1,consume = [{1,120}],lv = 70,weight = 12,career = 2};
get(411) ->
#base_mysterious_shop{id = 411,goods_id = 90213000,goods_num = 1,consume = [{1,120}],lv = 70,weight = 12,career = 2};
get(412) ->
#base_mysterious_shop{id = 412,goods_id = 90214000,goods_num = 1,consume = [{1,120}],lv = 70,weight = 12,career = 2};
get(413) ->
#base_mysterious_shop{id = 413,goods_id = 90227000,goods_num = 1,consume = [{1,120}],lv = 70,weight = 12,career = 2};
get(414) ->
#base_mysterious_shop{id = 414,goods_id = 90229000,goods_num = 1,consume = [{1,120}],lv = 70,weight = 12,career = 2};
get(415) ->
#base_mysterious_shop{id = 415,goods_id = 90201000,goods_num = 1,consume = [{3,1000}],lv = 60,weight = 50,career = 2};
get(416) ->
#base_mysterious_shop{id = 416,goods_id = 90202000,goods_num = 1,consume = [{3,1000}],lv = 60,weight = 50,career = 2};
get(417) ->
#base_mysterious_shop{id = 417,goods_id = 90203000,goods_num = 1,consume = [{3,1000}],lv = 60,weight = 50,career = 2};
get(418) ->
#base_mysterious_shop{id = 418,goods_id = 90204000,goods_num = 1,consume = [{3,1000}],lv = 60,weight = 50,career = 2};
get(419) ->
#base_mysterious_shop{id = 419,goods_id = 90211000,goods_num = 1,consume = [{3,1000}],lv = 60,weight = 50,career = 2};
get(420) ->
#base_mysterious_shop{id = 420,goods_id = 90222000,goods_num = 1,consume = [{3,1000}],lv = 60,weight = 50,career = 2};
get(421) ->
#base_mysterious_shop{id = 421,goods_id = 90224000,goods_num = 1,consume = [{3,5000}],lv = 60,weight = 50,career = 2};
get(422) ->
#base_mysterious_shop{id = 422,goods_id = 90205000,goods_num = 1,consume = [{3,5000}],lv = 70,weight = 25,career = 2};
get(423) ->
#base_mysterious_shop{id = 423,goods_id = 90207000,goods_num = 1,consume = [{3,5000}],lv = 70,weight = 25,career = 2};
get(424) ->
#base_mysterious_shop{id = 424,goods_id = 90210000,goods_num = 1,consume = [{3,5000}],lv = 70,weight = 25,career = 2};
get(425) ->
#base_mysterious_shop{id = 425,goods_id = 90212000,goods_num = 1,consume = [{3,5000}],lv = 70,weight = 25,career = 2};
get(426) ->
#base_mysterious_shop{id = 426,goods_id = 90225000,goods_num = 1,consume = [{3,5000}],lv = 70,weight = 25,career = 2};
get(427) ->
#base_mysterious_shop{id = 427,goods_id = 90226000,goods_num = 1,consume = [{3,5000}],lv = 70,weight = 25,career = 2};
get(428) ->
#base_mysterious_shop{id = 428,goods_id = 90228000,goods_num = 1,consume = [{3,5000}],lv = 70,weight = 25,career = 2};
get(429) ->
#base_mysterious_shop{id = 429,goods_id = 90206000,goods_num = 1,consume = [{1,120}],lv = 80,weight = 12,career = 2};
get(430) ->
#base_mysterious_shop{id = 430,goods_id = 90208000,goods_num = 1,consume = [{1,120}],lv = 80,weight = 12,career = 2};
get(431) ->
#base_mysterious_shop{id = 431,goods_id = 90213000,goods_num = 1,consume = [{1,120}],lv = 80,weight = 12,career = 2};
get(432) ->
#base_mysterious_shop{id = 432,goods_id = 90214000,goods_num = 1,consume = [{1,120}],lv = 80,weight = 12,career = 2};
get(433) ->
#base_mysterious_shop{id = 433,goods_id = 90227000,goods_num = 1,consume = [{1,120}],lv = 80,weight = 12,career = 2};
get(434) ->
#base_mysterious_shop{id = 434,goods_id = 90229000,goods_num = 1,consume = [{1,120}],lv = 80,weight = 12,career = 2};
get(435) ->
#base_mysterious_shop{id = 435,goods_id = 90201000,goods_num = 1,consume = [{3,1000}],lv = 70,weight = 50,career = 2};
get(436) ->
#base_mysterious_shop{id = 436,goods_id = 90202000,goods_num = 1,consume = [{3,1000}],lv = 70,weight = 50,career = 2};
get(437) ->
#base_mysterious_shop{id = 437,goods_id = 90203000,goods_num = 1,consume = [{3,1000}],lv = 70,weight = 50,career = 2};
get(438) ->
#base_mysterious_shop{id = 438,goods_id = 90204000,goods_num = 1,consume = [{3,1000}],lv = 70,weight = 50,career = 2};
get(439) ->
#base_mysterious_shop{id = 439,goods_id = 90211000,goods_num = 1,consume = [{3,1000}],lv = 70,weight = 50,career = 2};
get(440) ->
#base_mysterious_shop{id = 440,goods_id = 90222000,goods_num = 1,consume = [{3,1000}],lv = 70,weight = 50,career = 2};
get(441) ->
#base_mysterious_shop{id = 441,goods_id = 90224000,goods_num = 1,consume = [{3,5000}],lv = 70,weight = 50,career = 2};
get(442) ->
#base_mysterious_shop{id = 442,goods_id = 90205000,goods_num = 1,consume = [{3,5000}],lv = 80,weight = 25,career = 2};
get(443) ->
#base_mysterious_shop{id = 443,goods_id = 90207000,goods_num = 1,consume = [{3,5000}],lv = 80,weight = 25,career = 2};
get(444) ->
#base_mysterious_shop{id = 444,goods_id = 90210000,goods_num = 1,consume = [{3,5000}],lv = 80,weight = 25,career = 2};
get(445) ->
#base_mysterious_shop{id = 445,goods_id = 90212000,goods_num = 1,consume = [{3,5000}],lv = 80,weight = 25,career = 2};
get(446) ->
#base_mysterious_shop{id = 446,goods_id = 90225000,goods_num = 1,consume = [{3,5000}],lv = 80,weight = 25,career = 2};
get(447) ->
#base_mysterious_shop{id = 447,goods_id = 90226000,goods_num = 1,consume = [{3,5000}],lv = 80,weight = 25,career = 2};
get(448) ->
#base_mysterious_shop{id = 448,goods_id = 90228000,goods_num = 1,consume = [{3,5000}],lv = 80,weight = 25,career = 2};
get(449) ->
#base_mysterious_shop{id = 449,goods_id = 90206000,goods_num = 1,consume = [{1,120}],lv = 90,weight = 12,career = 2};
get(450) ->
#base_mysterious_shop{id = 450,goods_id = 90208000,goods_num = 1,consume = [{1,120}],lv = 90,weight = 12,career = 2};
get(451) ->
#base_mysterious_shop{id = 451,goods_id = 90213000,goods_num = 1,consume = [{1,120}],lv = 90,weight = 12,career = 2};
get(452) ->
#base_mysterious_shop{id = 452,goods_id = 90214000,goods_num = 1,consume = [{1,120}],lv = 90,weight = 12,career = 2};
get(453) ->
#base_mysterious_shop{id = 453,goods_id = 90227000,goods_num = 1,consume = [{1,120}],lv = 90,weight = 12,career = 2};
get(454) ->
#base_mysterious_shop{id = 454,goods_id = 90229000,goods_num = 1,consume = [{1,120}],lv = 90,weight = 12,career = 2};
get(455) ->
#base_mysterious_shop{id = 455,goods_id = 90201000,goods_num = 1,consume = [{3,1000}],lv = 80,weight = 50,career = 2};
get(456) ->
#base_mysterious_shop{id = 456,goods_id = 90202000,goods_num = 1,consume = [{3,1000}],lv = 80,weight = 50,career = 2};
get(457) ->
#base_mysterious_shop{id = 457,goods_id = 90203000,goods_num = 1,consume = [{3,1000}],lv = 80,weight = 50,career = 2};
get(458) ->
#base_mysterious_shop{id = 458,goods_id = 90204000,goods_num = 1,consume = [{3,1000}],lv = 80,weight = 50,career = 2};
get(459) ->
#base_mysterious_shop{id = 459,goods_id = 90211000,goods_num = 1,consume = [{3,1000}],lv = 80,weight = 50,career = 2};
get(460) ->
#base_mysterious_shop{id = 460,goods_id = 90222000,goods_num = 1,consume = [{3,1000}],lv = 80,weight = 50,career = 2};
get(461) ->
#base_mysterious_shop{id = 461,goods_id = 90224000,goods_num = 1,consume = [{3,5000}],lv = 80,weight = 50,career = 2};
get(462) ->
#base_mysterious_shop{id = 462,goods_id = 90205000,goods_num = 1,consume = [{3,5000}],lv = 90,weight = 25,career = 2};
get(463) ->
#base_mysterious_shop{id = 463,goods_id = 90207000,goods_num = 1,consume = [{3,5000}],lv = 90,weight = 25,career = 2};
get(464) ->
#base_mysterious_shop{id = 464,goods_id = 90210000,goods_num = 1,consume = [{3,5000}],lv = 90,weight = 25,career = 2};
get(465) ->
#base_mysterious_shop{id = 465,goods_id = 90212000,goods_num = 1,consume = [{3,5000}],lv = 90,weight = 25,career = 2};
get(466) ->
#base_mysterious_shop{id = 466,goods_id = 90225000,goods_num = 1,consume = [{3,5000}],lv = 90,weight = 25,career = 2};
get(467) ->
#base_mysterious_shop{id = 467,goods_id = 90226000,goods_num = 1,consume = [{3,5000}],lv = 90,weight = 25,career = 2};
get(468) ->
#base_mysterious_shop{id = 468,goods_id = 90228000,goods_num = 1,consume = [{3,5000}],lv = 90,weight = 25,career = 2};
get(469) ->
#base_mysterious_shop{id = 469,goods_id = 90206000,goods_num = 1,consume = [{1,120}],lv = 100,weight = 12,career = 2};
get(470) ->
#base_mysterious_shop{id = 470,goods_id = 90208000,goods_num = 1,consume = [{1,120}],lv = 100,weight = 12,career = 2};
get(471) ->
#base_mysterious_shop{id = 471,goods_id = 90213000,goods_num = 1,consume = [{1,120}],lv = 100,weight = 12,career = 2};
get(472) ->
#base_mysterious_shop{id = 472,goods_id = 90214000,goods_num = 1,consume = [{1,120}],lv = 100,weight = 12,career = 2};
get(473) ->
#base_mysterious_shop{id = 473,goods_id = 90227000,goods_num = 1,consume = [{1,120}],lv = 100,weight = 12,career = 2};
get(474) ->
#base_mysterious_shop{id = 474,goods_id = 90229000,goods_num = 1,consume = [{1,120}],lv = 100,weight = 12,career = 2};
get(475) ->
#base_mysterious_shop{id = 475,goods_id = 90201000,goods_num = 1,consume = [{3,1000}],lv = 90,weight = 50,career = 2};
get(476) ->
#base_mysterious_shop{id = 476,goods_id = 90202000,goods_num = 1,consume = [{3,1000}],lv = 90,weight = 50,career = 2};
get(477) ->
#base_mysterious_shop{id = 477,goods_id = 90203000,goods_num = 1,consume = [{3,1000}],lv = 90,weight = 50,career = 2};
get(478) ->
#base_mysterious_shop{id = 478,goods_id = 90204000,goods_num = 1,consume = [{3,1000}],lv = 90,weight = 50,career = 2};
get(479) ->
#base_mysterious_shop{id = 479,goods_id = 90211000,goods_num = 1,consume = [{3,1000}],lv = 90,weight = 50,career = 2};
get(480) ->
#base_mysterious_shop{id = 480,goods_id = 90222000,goods_num = 1,consume = [{3,1000}],lv = 90,weight = 50,career = 2};
get(481) ->
#base_mysterious_shop{id = 481,goods_id = 90224000,goods_num = 1,consume = [{3,5000}],lv = 90,weight = 50,career = 2};
get(482) ->
#base_mysterious_shop{id = 482,goods_id = 90205000,goods_num = 1,consume = [{3,5000}],lv = 100,weight = 25,career = 2};
get(483) ->
#base_mysterious_shop{id = 483,goods_id = 90207000,goods_num = 1,consume = [{3,5000}],lv = 100,weight = 25,career = 2};
get(484) ->
#base_mysterious_shop{id = 484,goods_id = 90210000,goods_num = 1,consume = [{3,5000}],lv = 100,weight = 25,career = 2};
get(485) ->
#base_mysterious_shop{id = 485,goods_id = 90212000,goods_num = 1,consume = [{3,5000}],lv = 100,weight = 25,career = 2};
get(486) ->
#base_mysterious_shop{id = 486,goods_id = 90225000,goods_num = 1,consume = [{3,5000}],lv = 100,weight = 25,career = 2};
get(487) ->
#base_mysterious_shop{id = 487,goods_id = 90226000,goods_num = 1,consume = [{3,5000}],lv = 100,weight = 25,career = 2};
get(488) ->
#base_mysterious_shop{id = 488,goods_id = 90228000,goods_num = 1,consume = [{3,5000}],lv = 100,weight = 25,career = 2};
get(489) ->
#base_mysterious_shop{id = 489,goods_id = 90206000,goods_num = 1,consume = [{1,120}],lv = 110,weight = 12,career = 2};
get(490) ->
#base_mysterious_shop{id = 490,goods_id = 90208000,goods_num = 1,consume = [{1,120}],lv = 110,weight = 12,career = 2};
get(491) ->
#base_mysterious_shop{id = 491,goods_id = 90213000,goods_num = 1,consume = [{1,120}],lv = 110,weight = 12,career = 2};
get(492) ->
#base_mysterious_shop{id = 492,goods_id = 90214000,goods_num = 1,consume = [{1,120}],lv = 110,weight = 12,career = 2};
get(493) ->
#base_mysterious_shop{id = 493,goods_id = 90227000,goods_num = 1,consume = [{1,120}],lv = 110,weight = 12,career = 2};
get(494) ->
#base_mysterious_shop{id = 494,goods_id = 90229000,goods_num = 1,consume = [{1,120}],lv = 110,weight = 12,career = 2};
get(495) ->
#base_mysterious_shop{id = 495,goods_id = 90201000,goods_num = 1,consume = [{3,1000}],lv = 100,weight = 50,career = 2};
get(496) ->
#base_mysterious_shop{id = 496,goods_id = 90202000,goods_num = 1,consume = [{3,1000}],lv = 100,weight = 50,career = 2};
get(497) ->
#base_mysterious_shop{id = 497,goods_id = 90203000,goods_num = 1,consume = [{3,1000}],lv = 100,weight = 50,career = 2};
get(498) ->
#base_mysterious_shop{id = 498,goods_id = 90204000,goods_num = 1,consume = [{3,1000}],lv = 100,weight = 50,career = 2};
get(499) ->
#base_mysterious_shop{id = 499,goods_id = 90211000,goods_num = 1,consume = [{3,1000}],lv = 100,weight = 50,career = 2};
get(500) ->
#base_mysterious_shop{id = 500,goods_id = 90222000,goods_num = 1,consume = [{3,1000}],lv = 100,weight = 50,career = 2};
get(501) ->
#base_mysterious_shop{id = 501,goods_id = 90224000,goods_num = 1,consume = [{3,5000}],lv = 100,weight = 50,career = 2};
get(502) ->
#base_mysterious_shop{id = 502,goods_id = 90205000,goods_num = 1,consume = [{3,5000}],lv = 110,weight = 25,career = 2};
get(503) ->
#base_mysterious_shop{id = 503,goods_id = 90207000,goods_num = 1,consume = [{3,5000}],lv = 110,weight = 25,career = 2};
get(504) ->
#base_mysterious_shop{id = 504,goods_id = 90210000,goods_num = 1,consume = [{3,5000}],lv = 110,weight = 25,career = 2};
get(505) ->
#base_mysterious_shop{id = 505,goods_id = 90212000,goods_num = 1,consume = [{3,5000}],lv = 110,weight = 25,career = 2};
get(506) ->
#base_mysterious_shop{id = 506,goods_id = 90225000,goods_num = 1,consume = [{3,5000}],lv = 110,weight = 25,career = 2};
get(507) ->
#base_mysterious_shop{id = 507,goods_id = 90226000,goods_num = 1,consume = [{3,5000}],lv = 110,weight = 25,career = 2};
get(508) ->
#base_mysterious_shop{id = 508,goods_id = 90228000,goods_num = 1,consume = [{3,5000}],lv = 110,weight = 25,career = 2};
get(509) ->
#base_mysterious_shop{id = 509,goods_id = 90206000,goods_num = 1,consume = [{1,120}],lv = 120,weight = 12,career = 2};
get(510) ->
#base_mysterious_shop{id = 510,goods_id = 90208000,goods_num = 1,consume = [{1,120}],lv = 120,weight = 12,career = 2};
get(511) ->
#base_mysterious_shop{id = 511,goods_id = 90213000,goods_num = 1,consume = [{1,120}],lv = 120,weight = 12,career = 2};
get(512) ->
#base_mysterious_shop{id = 512,goods_id = 90214000,goods_num = 1,consume = [{1,120}],lv = 120,weight = 12,career = 2};
get(513) ->
#base_mysterious_shop{id = 513,goods_id = 90227000,goods_num = 1,consume = [{1,120}],lv = 120,weight = 12,career = 2};
get(514) ->
#base_mysterious_shop{id = 514,goods_id = 90229000,goods_num = 1,consume = [{1,120}],lv = 120,weight = 12,career = 2};
get(515) ->
#base_mysterious_shop{id = 515,goods_id = 90109000,goods_num = 1,consume = [{1,120}],lv = 20,weight = 12,career = 1};
get(516) ->
#base_mysterious_shop{id = 516,goods_id = 90121000,goods_num = 1,consume = [{1,120}],lv = 20,weight = 12,career = 1};
get(517) ->
#base_mysterious_shop{id = 517,goods_id = 90109000,goods_num = 1,consume = [{1,120}],lv = 30,weight = 12,career = 1};
get(518) ->
#base_mysterious_shop{id = 518,goods_id = 90121000,goods_num = 1,consume = [{1,120}],lv = 30,weight = 12,career = 1};
get(519) ->
#base_mysterious_shop{id = 519,goods_id = 90109000,goods_num = 1,consume = [{1,120}],lv = 40,weight = 12,career = 1};
get(520) ->
#base_mysterious_shop{id = 520,goods_id = 90121000,goods_num = 1,consume = [{1,120}],lv = 40,weight = 12,career = 1};
get(521) ->
#base_mysterious_shop{id = 521,goods_id = 90109000,goods_num = 1,consume = [{1,120}],lv = 50,weight = 12,career = 1};
get(522) ->
#base_mysterious_shop{id = 522,goods_id = 90121000,goods_num = 1,consume = [{1,120}],lv = 50,weight = 12,career = 1};
get(523) ->
#base_mysterious_shop{id = 523,goods_id = 90109000,goods_num = 1,consume = [{1,120}],lv = 60,weight = 12,career = 1};
get(524) ->
#base_mysterious_shop{id = 524,goods_id = 90121000,goods_num = 1,consume = [{1,120}],lv = 60,weight = 12,career = 1};
get(525) ->
#base_mysterious_shop{id = 525,goods_id = 90109000,goods_num = 1,consume = [{1,120}],lv = 70,weight = 12,career = 1};
get(526) ->
#base_mysterious_shop{id = 526,goods_id = 90121000,goods_num = 1,consume = [{1,120}],lv = 70,weight = 12,career = 1};
get(527) ->
#base_mysterious_shop{id = 527,goods_id = 90109000,goods_num = 1,consume = [{1,120}],lv = 80,weight = 12,career = 1};
get(528) ->
#base_mysterious_shop{id = 528,goods_id = 90121000,goods_num = 1,consume = [{1,120}],lv = 80,weight = 12,career = 1};
get(529) ->
#base_mysterious_shop{id = 529,goods_id = 90109000,goods_num = 1,consume = [{1,120}],lv = 90,weight = 12,career = 1};
get(530) ->
#base_mysterious_shop{id = 530,goods_id = 90121000,goods_num = 1,consume = [{1,120}],lv = 90,weight = 12,career = 1};
get(531) ->
#base_mysterious_shop{id = 531,goods_id = 90109000,goods_num = 1,consume = [{1,120}],lv = 100,weight = 12,career = 1};
get(532) ->
#base_mysterious_shop{id = 532,goods_id = 90121000,goods_num = 1,consume = [{1,120}],lv = 100,weight = 12,career = 1};
get(533) ->
#base_mysterious_shop{id = 533,goods_id = 90109000,goods_num = 1,consume = [{1,120}],lv = 110,weight = 12,career = 1};
get(534) ->
#base_mysterious_shop{id = 534,goods_id = 90121000,goods_num = 1,consume = [{1,120}],lv = 110,weight = 12,career = 1};
get(535) ->
#base_mysterious_shop{id = 535,goods_id = 90209000,goods_num = 1,consume = [{1,120}],lv = 20,weight = 12,career = 2};
get(536) ->
#base_mysterious_shop{id = 536,goods_id = 90221000,goods_num = 1,consume = [{1,120}],lv = 20,weight = 12,career = 2};
get(537) ->
#base_mysterious_shop{id = 537,goods_id = 90209000,goods_num = 1,consume = [{1,120}],lv = 30,weight = 12,career = 2};
get(538) ->
#base_mysterious_shop{id = 538,goods_id = 90221000,goods_num = 1,consume = [{1,120}],lv = 30,weight = 12,career = 2};
get(539) ->
#base_mysterious_shop{id = 539,goods_id = 90209000,goods_num = 1,consume = [{1,120}],lv = 40,weight = 12,career = 2};
get(540) ->
#base_mysterious_shop{id = 540,goods_id = 90221000,goods_num = 1,consume = [{1,120}],lv = 40,weight = 12,career = 2};
get(541) ->
#base_mysterious_shop{id = 541,goods_id = 90209000,goods_num = 1,consume = [{1,120}],lv = 50,weight = 12,career = 2};
get(542) ->
#base_mysterious_shop{id = 542,goods_id = 90221000,goods_num = 1,consume = [{1,120}],lv = 50,weight = 12,career = 2};
get(543) ->
#base_mysterious_shop{id = 543,goods_id = 90209000,goods_num = 1,consume = [{1,120}],lv = 60,weight = 12,career = 2};
get(544) ->
#base_mysterious_shop{id = 544,goods_id = 90221000,goods_num = 1,consume = [{1,120}],lv = 60,weight = 12,career = 2};
get(545) ->
#base_mysterious_shop{id = 545,goods_id = 90209000,goods_num = 1,consume = [{1,120}],lv = 70,weight = 12,career = 2};
get(546) ->
#base_mysterious_shop{id = 546,goods_id = 90221000,goods_num = 1,consume = [{1,120}],lv = 70,weight = 12,career = 2};
get(547) ->
#base_mysterious_shop{id = 547,goods_id = 90209000,goods_num = 1,consume = [{1,120}],lv = 80,weight = 12,career = 2};
get(548) ->
#base_mysterious_shop{id = 548,goods_id = 90221000,goods_num = 1,consume = [{1,120}],lv = 80,weight = 12,career = 2};
get(549) ->
#base_mysterious_shop{id = 549,goods_id = 90209000,goods_num = 1,consume = [{1,120}],lv = 90,weight = 12,career = 2};
get(550) ->
#base_mysterious_shop{id = 550,goods_id = 90221000,goods_num = 1,consume = [{1,120}],lv = 90,weight = 12,career = 2};
get(551) ->
#base_mysterious_shop{id = 551,goods_id = 90209000,goods_num = 1,consume = [{1,120}],lv = 100,weight = 12,career = 2};
get(552) ->
#base_mysterious_shop{id = 552,goods_id = 90221000,goods_num = 1,consume = [{1,120}],lv = 100,weight = 12,career = 2};
get(553) ->
#base_mysterious_shop{id = 553,goods_id = 90209000,goods_num = 1,consume = [{1,120}],lv = 110,weight = 12,career = 2};
get(554) ->
#base_mysterious_shop{id = 554,goods_id = 90221000,goods_num = 1,consume = [{1,120}],lv = 110,weight = 12,career = 2};
get(Var1) -> ?WARNING_MSG("get not find ~p", [{Var1}]),
[].

get_all_id() ->
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255,256,257,258,259,260,261,262,263,264,265,266,267,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,301,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326,327,328,329,330,331,332,333,334,335,336,337,338,339,340,341,342,343,344,345,346,347,348,349,350,351,352,353,354,355,356,357,358,359,360,361,362,363,364,365,366,367,368,369,370,371,372,373,374,375,376,377,378,379,380,381,382,383,384,385,386,387,388,389,390,391,392,393,394,395,396,397,398,399,400,401,402,403,404,405,406,407,408,409,410,411,412,413,414,415,416,417,418,419,420,421,422,423,424,425,426,427,428,429,430,431,432,433,434,435,436,437,438,439,440,441,442,443,444,445,446,447,448,449,450,451,452,453,454,455,456,457,458,459,460,461,462,463,464,465,466,467,468,469,470,471,472,473,474,475,476,477,478,479,480,481,482,483,484,485,486,487,488,489,490,491,492,493,494,495,496,497,498,499,500,501,502,503,504,505,506,507,508,509,510,511,512,513,514,515,516,517,518,519,520,521,522,523,524,525,526,527,528,529,530,531,532,533,534,535,536,537,538,539,540,541,542,543,544,545,546,547,548,549,550,551,552,553,554].

get_id_by_lv(10) ->
[321,320,319,318,317,316,315,257,55,54,53,52,51,50,49];
get_id_by_lv(15) ->
[296,287,278,269];
get_id_by_lv(20) ->
[536,535,516,515,341,340,339,338,337,336,335,328,327,326,325,324,323,322,75,74,73,72,71,70,69,62,61,60,59,58,57,56];
get_id_by_lv(25) ->
[297,288,279,270,258];
get_id_by_lv(30) ->
[538,537,518,517,361,360,359,358,357,356,355,348,347,346,345,344,343,342,334,333,332,331,330,329,263,249,95,94,93,92,91,90,89,82,81,80,79,78,77,76,68,67,66,65,64,63,22,19,16,13,10,7,4,1];
get_id_by_lv(35) ->
[298,289,280,271];
get_id_by_lv(40) ->
[540,539,520,519,381,380,379,378,377,376,375,368,367,366,365,364,363,362,354,353,352,351,350,349,259,250,115,114,113,112,111,110,109,102,101,100,99,98,97,96,88,87,86,85,84,83];
get_id_by_lv(45) ->
[299,290,281,272,264];
get_id_by_lv(50) ->
[542,541,522,521,401,400,399,398,397,396,395,388,387,386,385,384,383,382,374,373,372,371,370,369,251,135,134,133,132,131,130,129,122,121,120,119,118,117,116,108,107,106,105,104,103,46,43,40,37,34,31,28,25];
get_id_by_lv(55) ->
[310,305,300,291,282,273,260];
get_id_by_lv(60) ->
[544,543,524,523,421,420,419,418,417,416,415,408,407,406,405,404,403,402,394,393,392,391,390,389,265,252,155,154,153,152,151,150,149,142,141,140,139,138,137,136,128,127,126,125,124,123,23,20,17,14,11,8,5,2];
get_id_by_lv(65) ->
[311,306,301,292,283,274];
get_id_by_lv(70) ->
[546,545,526,525,441,440,439,438,437,436,435,428,427,426,425,424,423,422,414,413,412,411,410,409,261,253,175,174,173,172,171,170,169,162,161,160,159,158,157,156,148,147,146,145,144,143,47,44,41,38,35,32,29,26];
get_id_by_lv(75) ->
[312,307,302,293,284,275,266];
get_id_by_lv(80) ->
[548,547,528,527,461,460,459,458,457,456,455,448,447,446,445,444,443,442,434,433,432,431,430,429,254,195,194,193,192,191,190,189,182,181,180,179,178,177,176,168,167,166,165,164,163];
get_id_by_lv(85) ->
[313,308,303,294,285,276,262];
get_id_by_lv(90) ->
[550,549,530,529,481,480,479,478,477,476,475,468,467,466,465,464,463,462,454,453,452,451,450,449,267,255,215,214,213,212,211,210,209,202,201,200,199,198,197,196,188,187,186,185,184,183,24,21,18,15,12,9,6,3];
get_id_by_lv(95) ->
[314,309,304,295,286,277];
get_id_by_lv(100) ->
[552,551,532,531,501,500,499,498,497,496,495,488,487,486,485,484,483,482,474,473,472,471,470,469,256,235,234,233,232,231,230,229,222,221,220,219,218,217,216,208,207,206,205,204,203];
get_id_by_lv(105) ->
[268];
get_id_by_lv(110) ->
[554,553,534,533,508,507,506,505,504,503,502,494,493,492,491,490,489,242,241,240,239,238,237,236,228,227,226,225,224,223,48,45,42,39,36,33,30,27];
get_id_by_lv(120) ->
[514,513,512,511,510,509,248,247,246,245,244,243];
get_id_by_lv(Var1) -> ?WARNING_MSG("get_id_by_lv not find ~p", [{Var1}]),
[].

get_all_lv() ->
[10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90,95,100,105,110,120].

get_id_by_career(0) ->
[314,313,312,311,310,309,308,307,306,305,304,303,302,301,300,299,298,297,296,295,294,293,292,291,290,289,288,287,286,285,284,283,282,281,280,279,278,277,276,275,274,273,272,271,270,269,268,267,266,265,264,263,262,261,260,259,258,257,256,255,254,253,252,251,250,249,48,47,46,45,44,43,42,41,40,39,38,37,36,35,34,33,32,31,30,29,28,27,26,25,24,23,22,21,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1];
get_id_by_career(1) ->
[534,533,532,531,530,529,528,527,526,525,524,523,522,521,520,519,518,517,516,515,248,247,246,245,244,243,242,241,240,239,238,237,236,235,234,233,232,231,230,229,228,227,226,225,224,223,222,221,220,219,218,217,216,215,214,213,212,211,210,209,208,207,206,205,204,203,202,201,200,199,198,197,196,195,194,193,192,191,190,189,188,187,186,185,184,183,182,181,180,179,178,177,176,175,174,173,172,171,170,169,168,167,166,165,164,163,162,161,160,159,158,157,156,155,154,153,152,151,150,149,148,147,146,145,144,143,142,141,140,139,138,137,136,135,134,133,132,131,130,129,128,127,126,125,124,123,122,121,120,119,118,117,116,115,114,113,112,111,110,109,108,107,106,105,104,103,102,101,100,99,98,97,96,95,94,93,92,91,90,89,88,87,86,85,84,83,82,81,80,79,78,77,76,75,74,73,72,71,70,69,68,67,66,65,64,63,62,61,60,59,58,57,56,55,54,53,52,51,50,49];
get_id_by_career(2) ->
[554,553,552,551,550,549,548,547,546,545,544,543,542,541,540,539,538,537,536,535,514,513,512,511,510,509,508,507,506,505,504,503,502,501,500,499,498,497,496,495,494,493,492,491,490,489,488,487,486,485,484,483,482,481,480,479,478,477,476,475,474,473,472,471,470,469,468,467,466,465,464,463,462,461,460,459,458,457,456,455,454,453,452,451,450,449,448,447,446,445,444,443,442,441,440,439,438,437,436,435,434,433,432,431,430,429,428,427,426,425,424,423,422,421,420,419,418,417,416,415,414,413,412,411,410,409,408,407,406,405,404,403,402,401,400,399,398,397,396,395,394,393,392,391,390,389,388,387,386,385,384,383,382,381,380,379,378,377,376,375,374,373,372,371,370,369,368,367,366,365,364,363,362,361,360,359,358,357,356,355,354,353,352,351,350,349,348,347,346,345,344,343,342,341,340,339,338,337,336,335,334,333,332,331,330,329,328,327,326,325,324,323,322,321,320,319,318,317,316,315];
get_id_by_career(Var1) -> ?WARNING_MSG("get_id_by_career not find ~p", [{Var1}]),
[].

get_all_career() ->
[0,1,2].

get_id_by_lv_and_career({10, 0}) ->
[257];
get_id_by_lv_and_career({10, 1}) ->
[55,54,53,52,51,50,49];
get_id_by_lv_and_career({10, 2}) ->
[321,320,319,318,317,316,315];
get_id_by_lv_and_career({15, 0}) ->
[296,287,278,269];
get_id_by_lv_and_career({20, 1}) ->
[516,515,75,74,73,72,71,70,69,62,61,60,59,58,57,56];
get_id_by_lv_and_career({20, 2}) ->
[536,535,341,340,339,338,337,336,335,328,327,326,325,324,323,322];
get_id_by_lv_and_career({25, 0}) ->
[297,288,279,270,258];
get_id_by_lv_and_career({30, 0}) ->
[263,249,22,19,16,13,10,7,4,1];
get_id_by_lv_and_career({30, 1}) ->
[518,517,95,94,93,92,91,90,89,82,81,80,79,78,77,76,68,67,66,65,64,63];
get_id_by_lv_and_career({30, 2}) ->
[538,537,361,360,359,358,357,356,355,348,347,346,345,344,343,342,334,333,332,331,330,329];
get_id_by_lv_and_career({35, 0}) ->
[298,289,280,271];
get_id_by_lv_and_career({40, 0}) ->
[259,250];
get_id_by_lv_and_career({40, 1}) ->
[520,519,115,114,113,112,111,110,109,102,101,100,99,98,97,96,88,87,86,85,84,83];
get_id_by_lv_and_career({40, 2}) ->
[540,539,381,380,379,378,377,376,375,368,367,366,365,364,363,362,354,353,352,351,350,349];
get_id_by_lv_and_career({45, 0}) ->
[299,290,281,272,264];
get_id_by_lv_and_career({50, 0}) ->
[251,46,43,40,37,34,31,28,25];
get_id_by_lv_and_career({50, 1}) ->
[522,521,135,134,133,132,131,130,129,122,121,120,119,118,117,116,108,107,106,105,104,103];
get_id_by_lv_and_career({50, 2}) ->
[542,541,401,400,399,398,397,396,395,388,387,386,385,384,383,382,374,373,372,371,370,369];
get_id_by_lv_and_career({55, 0}) ->
[310,305,300,291,282,273,260];
get_id_by_lv_and_career({60, 0}) ->
[265,252,23,20,17,14,11,8,5,2];
get_id_by_lv_and_career({60, 1}) ->
[524,523,155,154,153,152,151,150,149,142,141,140,139,138,137,136,128,127,126,125,124,123];
get_id_by_lv_and_career({60, 2}) ->
[544,543,421,420,419,418,417,416,415,408,407,406,405,404,403,402,394,393,392,391,390,389];
get_id_by_lv_and_career({65, 0}) ->
[311,306,301,292,283,274];
get_id_by_lv_and_career({70, 0}) ->
[261,253,47,44,41,38,35,32,29,26];
get_id_by_lv_and_career({70, 1}) ->
[526,525,175,174,173,172,171,170,169,162,161,160,159,158,157,156,148,147,146,145,144,143];
get_id_by_lv_and_career({70, 2}) ->
[546,545,441,440,439,438,437,436,435,428,427,426,425,424,423,422,414,413,412,411,410,409];
get_id_by_lv_and_career({75, 0}) ->
[312,307,302,293,284,275,266];
get_id_by_lv_and_career({80, 0}) ->
[254];
get_id_by_lv_and_career({80, 1}) ->
[528,527,195,194,193,192,191,190,189,182,181,180,179,178,177,176,168,167,166,165,164,163];
get_id_by_lv_and_career({80, 2}) ->
[548,547,461,460,459,458,457,456,455,448,447,446,445,444,443,442,434,433,432,431,430,429];
get_id_by_lv_and_career({85, 0}) ->
[313,308,303,294,285,276,262];
get_id_by_lv_and_career({90, 0}) ->
[267,255,24,21,18,15,12,9,6,3];
get_id_by_lv_and_career({90, 1}) ->
[530,529,215,214,213,212,211,210,209,202,201,200,199,198,197,196,188,187,186,185,184,183];
get_id_by_lv_and_career({90, 2}) ->
[550,549,481,480,479,478,477,476,475,468,467,466,465,464,463,462,454,453,452,451,450,449];
get_id_by_lv_and_career({95, 0}) ->
[314,309,304,295,286,277];
get_id_by_lv_and_career({100, 0}) ->
[256];
get_id_by_lv_and_career({100, 1}) ->
[532,531,235,234,233,232,231,230,229,222,221,220,219,218,217,216,208,207,206,205,204,203];
get_id_by_lv_and_career({100, 2}) ->
[552,551,501,500,499,498,497,496,495,488,487,486,485,484,483,482,474,473,472,471,470,469];
get_id_by_lv_and_career({105, 0}) ->
[268];
get_id_by_lv_and_career({110, 0}) ->
[48,45,42,39,36,33,30,27];
get_id_by_lv_and_career({110, 1}) ->
[534,533,242,241,240,239,238,237,236,228,227,226,225,224,223];
get_id_by_lv_and_career({110, 2}) ->
[554,553,508,507,506,505,504,503,502,494,493,492,491,490,489];
get_id_by_lv_and_career({120, 1}) ->
[248,247,246,245,244,243];
get_id_by_lv_and_career({120, 2}) ->
[514,513,512,511,510,509];
get_id_by_lv_and_career(Var1) -> [].
