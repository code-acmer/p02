%% coding: utf-8
%% Warning:本文件由data_generate自动生成，请不要手动修改
-module(data_base_player).
-export([get/1]).
-export([get_player_max_lv/0]).
-include("common.hrl").
-include("db_base_player.hrl").
get(1) ->
#ets_base_player{lv = 1,exp_curr = 0,exp_next = 276,cost = 0,vigor = 200,friends = 20,hp_lim = 500,mana_lim = 250,hp_rec = 0,mana_rec = 10,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 50,def = 25,hit = 15,dodge = 15,crit = 15,anti_crit = 15,stiff = 103,anti_stiff = 103,attack_speed = 1000,move_speed = 2000};
get(2) ->
#ets_base_player{lv = 2,exp_curr = 276,exp_next = 314,cost = 0,vigor = 200,friends = 20,hp_lim = 518,mana_lim = 250,hp_rec = 0,mana_rec = 10,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 51,def = 25,hit = 16,dodge = 16,crit = 16,anti_crit = 16,stiff = 106,anti_stiff = 106,attack_speed = 1000,move_speed = 2000};
get(3) ->
#ets_base_player{lv = 3,exp_curr = 590,exp_next = 358,cost = 0,vigor = 200,friends = 20,hp_lim = 536,mana_lim = 250,hp_rec = 0,mana_rec = 10,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 53,def = 26,hit = 16,dodge = 16,crit = 16,anti_crit = 16,stiff = 109,anti_stiff = 109,attack_speed = 1000,move_speed = 2000};
get(4) ->
#ets_base_player{lv = 4,exp_curr = 948,exp_next = 407,cost = 0,vigor = 200,friends = 21,hp_lim = 554,mana_lim = 250,hp_rec = 0,mana_rec = 11,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 55,def = 27,hit = 17,dodge = 17,crit = 17,anti_crit = 17,stiff = 112,anti_stiff = 112,attack_speed = 1000,move_speed = 2000};
get(5) ->
#ets_base_player{lv = 5,exp_curr = 1355,exp_next = 463,cost = 0,vigor = 200,friends = 21,hp_lim = 574,mana_lim = 250,hp_rec = 0,mana_rec = 11,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 57,def = 28,hit = 18,dodge = 18,crit = 18,anti_crit = 18,stiff = 115,anti_stiff = 115,attack_speed = 1000,move_speed = 2000};
get(6) ->
#ets_base_player{lv = 6,exp_curr = 1818,exp_next = 527,cost = 0,vigor = 200,friends = 21,hp_lim = 594,mana_lim = 250,hp_rec = 0,mana_rec = 11,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 59,def = 29,hit = 18,dodge = 18,crit = 18,anti_crit = 18,stiff = 118,anti_stiff = 118,attack_speed = 1000,move_speed = 2000};
get(7) ->
#ets_base_player{lv = 7,exp_curr = 2345,exp_next = 600,cost = 0,vigor = 200,friends = 22,hp_lim = 615,mana_lim = 250,hp_rec = 0,mana_rec = 12,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 61,def = 30,hit = 19,dodge = 19,crit = 19,anti_crit = 19,stiff = 121,anti_stiff = 121,attack_speed = 1000,move_speed = 2000};
get(8) ->
#ets_base_player{lv = 8,exp_curr = 2945,exp_next = 683,cost = 0,vigor = 200,friends = 22,hp_lim = 636,mana_lim = 250,hp_rec = 0,mana_rec = 12,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 63,def = 31,hit = 20,dodge = 20,crit = 20,anti_crit = 20,stiff = 124,anti_stiff = 124,attack_speed = 1000,move_speed = 2000};
get(9) ->
#ets_base_player{lv = 9,exp_curr = 3628,exp_next = 778,cost = 0,vigor = 200,friends = 22,hp_lim = 658,mana_lim = 250,hp_rec = 0,mana_rec = 13,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 65,def = 32,hit = 21,dodge = 21,crit = 21,anti_crit = 21,stiff = 127,anti_stiff = 127,attack_speed = 1000,move_speed = 2000};
get(10) ->
#ets_base_player{lv = 10,exp_curr = 4406,exp_next = 885,cost = 0,vigor = 200,friends = 27,hp_lim = 681,mana_lim = 250,hp_rec = 0,mana_rec = 13,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 68,def = 34,hit = 21,dodge = 21,crit = 21,anti_crit = 21,stiff = 130,anti_stiff = 130,attack_speed = 1000,move_speed = 2000};
get(11) ->
#ets_base_player{lv = 11,exp_curr = 5291,exp_next = 1008,cost = 0,vigor = 200,friends = 27,hp_lim = 705,mana_lim = 250,hp_rec = 0,mana_rec = 14,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 70,def = 35,hit = 22,dodge = 22,crit = 22,anti_crit = 22,stiff = 133,anti_stiff = 133,attack_speed = 1000,move_speed = 2000};
get(12) ->
#ets_base_player{lv = 12,exp_curr = 6299,exp_next = 1147,cost = 0,vigor = 200,friends = 27,hp_lim = 730,mana_lim = 250,hp_rec = 0,mana_rec = 14,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 72,def = 36,hit = 23,dodge = 23,crit = 23,anti_crit = 23,stiff = 137,anti_stiff = 137,attack_speed = 1000,move_speed = 2000};
get(13) ->
#ets_base_player{lv = 13,exp_curr = 7446,exp_next = 1306,cost = 0,vigor = 200,friends = 28,hp_lim = 756,mana_lim = 250,hp_rec = 0,mana_rec = 15,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 75,def = 37,hit = 24,dodge = 24,crit = 24,anti_crit = 24,stiff = 141,anti_stiff = 141,attack_speed = 1000,move_speed = 2000};
get(14) ->
#ets_base_player{lv = 14,exp_curr = 8752,exp_next = 1486,cost = 0,vigor = 200,friends = 28,hp_lim = 782,mana_lim = 250,hp_rec = 0,mana_rec = 15,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 78,def = 39,hit = 25,dodge = 25,crit = 25,anti_crit = 25,stiff = 145,anti_stiff = 145,attack_speed = 1000,move_speed = 2000};
get(15) ->
#ets_base_player{lv = 15,exp_curr = 10238,exp_next = 1691,cost = 0,vigor = 200,friends = 28,hp_lim = 809,mana_lim = 250,hp_rec = 0,mana_rec = 16,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 80,def = 40,hit = 26,dodge = 26,crit = 26,anti_crit = 26,stiff = 149,anti_stiff = 149,attack_speed = 1000,move_speed = 2000};
get(16) ->
#ets_base_player{lv = 16,exp_curr = 11929,exp_next = 1925,cost = 0,vigor = 200,friends = 29,hp_lim = 838,mana_lim = 250,hp_rec = 0,mana_rec = 16,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 83,def = 41,hit = 27,dodge = 27,crit = 27,anti_crit = 27,stiff = 153,anti_stiff = 153,attack_speed = 1000,move_speed = 2000};
get(17) ->
#ets_base_player{lv = 17,exp_curr = 13854,exp_next = 2191,cost = 0,vigor = 200,friends = 29,hp_lim = 867,mana_lim = 250,hp_rec = 0,mana_rec = 17,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 86,def = 43,hit = 28,dodge = 28,crit = 28,anti_crit = 28,stiff = 157,anti_stiff = 157,attack_speed = 1000,move_speed = 2000};
get(18) ->
#ets_base_player{lv = 18,exp_curr = 16045,exp_next = 2494,cost = 0,vigor = 200,friends = 29,hp_lim = 897,mana_lim = 250,hp_rec = 0,mana_rec = 17,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 89,def = 44,hit = 29,dodge = 29,crit = 29,anti_crit = 29,stiff = 161,anti_stiff = 161,attack_speed = 1000,move_speed = 2000};
get(19) ->
#ets_base_player{lv = 19,exp_curr = 18539,exp_next = 2838,cost = 0,vigor = 200,friends = 30,hp_lim = 929,mana_lim = 250,hp_rec = 0,mana_rec = 18,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 92,def = 46,hit = 30,dodge = 30,crit = 30,anti_crit = 30,stiff = 165,anti_stiff = 165,attack_speed = 1000,move_speed = 2000};
get(20) ->
#ets_base_player{lv = 20,exp_curr = 21377,exp_next = 3231,cost = 0,vigor = 200,friends = 30,hp_lim = 961,mana_lim = 250,hp_rec = 0,mana_rec = 19,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 96,def = 48,hit = 32,dodge = 32,crit = 32,anti_crit = 32,stiff = 169,anti_stiff = 169,attack_speed = 1000,move_speed = 2000};
get(21) ->
#ets_base_player{lv = 21,exp_curr = 24608,exp_next = 3677,cost = 0,vigor = 200,friends = 30,hp_lim = 995,mana_lim = 250,hp_rec = 0,mana_rec = 19,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 99,def = 49,hit = 33,dodge = 33,crit = 33,anti_crit = 33,stiff = 173,anti_stiff = 173,attack_speed = 1000,move_speed = 2000};
get(22) ->
#ets_base_player{lv = 22,exp_curr = 28285,exp_next = 4185,cost = 0,vigor = 200,friends = 31,hp_lim = 1030,mana_lim = 250,hp_rec = 0,mana_rec = 20,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 102,def = 51,hit = 34,dodge = 34,crit = 34,anti_crit = 34,stiff = 178,anti_stiff = 178,attack_speed = 1000,move_speed = 2000};
get(23) ->
#ets_base_player{lv = 23,exp_curr = 32470,exp_next = 4763,cost = 0,vigor = 200,friends = 31,hp_lim = 1066,mana_lim = 250,hp_rec = 0,mana_rec = 21,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 106,def = 53,hit = 36,dodge = 36,crit = 36,anti_crit = 36,stiff = 183,anti_stiff = 183,attack_speed = 1000,move_speed = 2000};
get(24) ->
#ets_base_player{lv = 24,exp_curr = 37233,exp_next = 5421,cost = 0,vigor = 200,friends = 31,hp_lim = 1103,mana_lim = 250,hp_rec = 0,mana_rec = 22,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 110,def = 55,hit = 37,dodge = 37,crit = 37,anti_crit = 37,stiff = 188,anti_stiff = 188,attack_speed = 1000,move_speed = 2000};
get(25) ->
#ets_base_player{lv = 25,exp_curr = 42654,exp_next = 6170,cost = 0,vigor = 200,friends = 32,hp_lim = 1142,mana_lim = 250,hp_rec = 0,mana_rec = 22,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 114,def = 57,hit = 38,dodge = 38,crit = 38,anti_crit = 38,stiff = 193,anti_stiff = 193,attack_speed = 1000,move_speed = 2000};
get(26) ->
#ets_base_player{lv = 26,exp_curr = 48824,exp_next = 7023,cost = 0,vigor = 200,friends = 32,hp_lim = 1182,mana_lim = 250,hp_rec = 0,mana_rec = 23,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 118,def = 59,hit = 40,dodge = 40,crit = 40,anti_crit = 40,stiff = 198,anti_stiff = 198,attack_speed = 1000,move_speed = 2000};
get(27) ->
#ets_base_player{lv = 27,exp_curr = 55847,exp_next = 7993,cost = 0,vigor = 200,friends = 32,hp_lim = 1223,mana_lim = 250,hp_rec = 0,mana_rec = 24,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 122,def = 61,hit = 42,dodge = 42,crit = 42,anti_crit = 42,stiff = 203,anti_stiff = 203,attack_speed = 1000,move_speed = 2000};
get(28) ->
#ets_base_player{lv = 28,exp_curr = 63840,exp_next = 9097,cost = 0,vigor = 200,friends = 33,hp_lim = 1266,mana_lim = 250,hp_rec = 0,mana_rec = 25,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 126,def = 63,hit = 43,dodge = 43,crit = 43,anti_crit = 43,stiff = 208,anti_stiff = 208,attack_speed = 1000,move_speed = 2000};
get(29) ->
#ets_base_player{lv = 29,exp_curr = 72937,exp_next = 10354,cost = 0,vigor = 200,friends = 33,hp_lim = 1310,mana_lim = 250,hp_rec = 0,mana_rec = 26,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 131,def = 65,hit = 45,dodge = 45,crit = 45,anti_crit = 45,stiff = 214,anti_stiff = 214,attack_speed = 1000,move_speed = 2000};
get(30) ->
#ets_base_player{lv = 30,exp_curr = 83291,exp_next = 11392,cost = 0,vigor = 200,friends = 33,hp_lim = 1356,mana_lim = 250,hp_rec = 0,mana_rec = 27,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 135,def = 67,hit = 47,dodge = 47,crit = 47,anti_crit = 47,stiff = 220,anti_stiff = 220,attack_speed = 1000,move_speed = 2000};
get(31) ->
#ets_base_player{lv = 31,exp_curr = 94683,exp_next = 12504,cost = 0,vigor = 200,friends = 34,hp_lim = 1403,mana_lim = 250,hp_rec = 0,mana_rec = 28,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 140,def = 70,hit = 49,dodge = 49,crit = 49,anti_crit = 49,stiff = 226,anti_stiff = 226,attack_speed = 1000,move_speed = 2000};
get(32) ->
#ets_base_player{lv = 32,exp_curr = 107187,exp_next = 12737,cost = 0,vigor = 200,friends = 34,hp_lim = 1453,mana_lim = 250,hp_rec = 0,mana_rec = 29,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 145,def = 72,hit = 51,dodge = 51,crit = 51,anti_crit = 51,stiff = 232,anti_stiff = 232,attack_speed = 1000,move_speed = 2000};
get(33) ->
#ets_base_player{lv = 33,exp_curr = 119924,exp_next = 13161,cost = 0,vigor = 200,friends = 34,hp_lim = 1503,mana_lim = 250,hp_rec = 0,mana_rec = 30,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 150,def = 75,hit = 53,dodge = 53,crit = 53,anti_crit = 53,stiff = 238,anti_stiff = 238,attack_speed = 1000,move_speed = 2000};
get(34) ->
#ets_base_player{lv = 34,exp_curr = 133085,exp_next = 13792,cost = 0,vigor = 200,friends = 35,hp_lim = 1556,mana_lim = 250,hp_rec = 0,mana_rec = 31,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 155,def = 77,hit = 55,dodge = 55,crit = 55,anti_crit = 55,stiff = 244,anti_stiff = 244,attack_speed = 1000,move_speed = 2000};
get(35) ->
#ets_base_player{lv = 35,exp_curr = 146877,exp_next = 14649,cost = 0,vigor = 200,friends = 35,hp_lim = 1610,mana_lim = 250,hp_rec = 0,mana_rec = 32,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 161,def = 80,hit = 57,dodge = 57,crit = 57,anti_crit = 57,stiff = 250,anti_stiff = 250,attack_speed = 1000,move_speed = 2000};
get(36) ->
#ets_base_player{lv = 36,exp_curr = 161526,exp_next = 15749,cost = 0,vigor = 200,friends = 35,hp_lim = 1667,mana_lim = 250,hp_rec = 0,mana_rec = 33,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 166,def = 83,hit = 59,dodge = 59,crit = 59,anti_crit = 59,stiff = 257,anti_stiff = 257,attack_speed = 1000,move_speed = 2000};
get(37) ->
#ets_base_player{lv = 37,exp_curr = 177275,exp_next = 17114,cost = 0,vigor = 200,friends = 36,hp_lim = 1725,mana_lim = 250,hp_rec = 0,mana_rec = 34,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 172,def = 86,hit = 62,dodge = 62,crit = 62,anti_crit = 62,stiff = 264,anti_stiff = 264,attack_speed = 1000,move_speed = 2000};
get(38) ->
#ets_base_player{lv = 38,exp_curr = 194389,exp_next = 18763,cost = 0,vigor = 200,friends = 36,hp_lim = 1786,mana_lim = 250,hp_rec = 0,mana_rec = 35,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 178,def = 89,hit = 64,dodge = 64,crit = 64,anti_crit = 64,stiff = 271,anti_stiff = 271,attack_speed = 1000,move_speed = 2000};
get(39) ->
#ets_base_player{lv = 39,exp_curr = 213152,exp_next = 20721,cost = 0,vigor = 200,friends = 36,hp_lim = 1848,mana_lim = 250,hp_rec = 0,mana_rec = 36,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 184,def = 92,hit = 67,dodge = 67,crit = 67,anti_crit = 67,stiff = 278,anti_stiff = 278,attack_speed = 1000,move_speed = 2000};
get(40) ->
#ets_base_player{lv = 40,exp_curr = 233873,exp_next = 23010,cost = 0,vigor = 200,friends = 41,hp_lim = 1913,mana_lim = 250,hp_rec = 0,mana_rec = 38,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 191,def = 95,hit = 69,dodge = 69,crit = 69,anti_crit = 69,stiff = 285,anti_stiff = 285,attack_speed = 1000,move_speed = 2000};
get(41) ->
#ets_base_player{lv = 41,exp_curr = 256883,exp_next = 25656,cost = 0,vigor = 200,friends = 41,hp_lim = 1980,mana_lim = 250,hp_rec = 0,mana_rec = 39,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 197,def = 98,hit = 72,dodge = 72,crit = 72,anti_crit = 72,stiff = 293,anti_stiff = 293,attack_speed = 1000,move_speed = 2000};
get(42) ->
#ets_base_player{lv = 42,exp_curr = 282539,exp_next = 28684,cost = 0,vigor = 200,friends = 41,hp_lim = 2049,mana_lim = 250,hp_rec = 0,mana_rec = 40,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 204,def = 102,hit = 75,dodge = 75,crit = 75,anti_crit = 75,stiff = 301,anti_stiff = 301,attack_speed = 1000,move_speed = 2000};
get(43) ->
#ets_base_player{lv = 43,exp_curr = 311223,exp_next = 32124,cost = 0,vigor = 200,friends = 42,hp_lim = 2121,mana_lim = 250,hp_rec = 0,mana_rec = 42,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 212,def = 106,hit = 78,dodge = 78,crit = 78,anti_crit = 78,stiff = 309,anti_stiff = 309,attack_speed = 1000,move_speed = 2000};
get(44) ->
#ets_base_player{lv = 44,exp_curr = 343347,exp_next = 36004,cost = 0,vigor = 200,friends = 42,hp_lim = 2195,mana_lim = 250,hp_rec = 0,mana_rec = 43,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 219,def = 109,hit = 81,dodge = 81,crit = 81,anti_crit = 81,stiff = 317,anti_stiff = 317,attack_speed = 1000,move_speed = 2000};
get(45) ->
#ets_base_player{lv = 45,exp_curr = 379351,exp_next = 40355,cost = 0,vigor = 200,friends = 42,hp_lim = 2272,mana_lim = 250,hp_rec = 0,mana_rec = 45,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 227,def = 113,hit = 84,dodge = 84,crit = 84,anti_crit = 84,stiff = 325,anti_stiff = 325,attack_speed = 1000,move_speed = 2000};
get(46) ->
#ets_base_player{lv = 46,exp_curr = 419706,exp_next = 45211,cost = 0,vigor = 200,friends = 43,hp_lim = 2351,mana_lim = 250,hp_rec = 0,mana_rec = 47,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 235,def = 117,hit = 88,dodge = 88,crit = 88,anti_crit = 88,stiff = 334,anti_stiff = 334,attack_speed = 1000,move_speed = 2000};
get(47) ->
#ets_base_player{lv = 47,exp_curr = 464917,exp_next = 50605,cost = 0,vigor = 200,friends = 43,hp_lim = 2433,mana_lim = 250,hp_rec = 0,mana_rec = 48,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 243,def = 121,hit = 91,dodge = 91,crit = 91,anti_crit = 91,stiff = 343,anti_stiff = 343,attack_speed = 1000,move_speed = 2000};
get(48) ->
#ets_base_player{lv = 48,exp_curr = 515522,exp_next = 56576,cost = 0,vigor = 200,friends = 43,hp_lim = 2519,mana_lim = 250,hp_rec = 0,mana_rec = 50,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 251,def = 125,hit = 95,dodge = 95,crit = 95,anti_crit = 95,stiff = 352,anti_stiff = 352,attack_speed = 1000,move_speed = 2000};
get(49) ->
#ets_base_player{lv = 49,exp_curr = 572098,exp_next = 63160,cost = 0,vigor = 200,friends = 44,hp_lim = 2607,mana_lim = 250,hp_rec = 0,mana_rec = 52,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 260,def = 130,hit = 99,dodge = 99,crit = 99,anti_crit = 99,stiff = 361,anti_stiff = 361,attack_speed = 1000,move_speed = 2000};
get(50) ->
#ets_base_player{lv = 50,exp_curr = 635258,exp_next = 70398,cost = 0,vigor = 200,friends = 44,hp_lim = 2698,mana_lim = 250,hp_rec = 0,mana_rec = 53,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 269,def = 134,hit = 103,dodge = 103,crit = 103,anti_crit = 103,stiff = 371,anti_stiff = 371,attack_speed = 1000,move_speed = 2000};
get(51) ->
#ets_base_player{lv = 51,exp_curr = 705656,exp_next = 78334,cost = 0,vigor = 200,friends = 44,hp_lim = 2792,mana_lim = 250,hp_rec = 0,mana_rec = 55,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 279,def = 139,hit = 107,dodge = 107,crit = 107,anti_crit = 107,stiff = 381,anti_stiff = 381,attack_speed = 1000,move_speed = 2000};
get(52) ->
#ets_base_player{lv = 52,exp_curr = 783990,exp_next = 87011,cost = 0,vigor = 200,friends = 45,hp_lim = 2890,mana_lim = 250,hp_rec = 0,mana_rec = 57,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 289,def = 144,hit = 111,dodge = 111,crit = 111,anti_crit = 111,stiff = 391,anti_stiff = 391,attack_speed = 1000,move_speed = 2000};
get(53) ->
#ets_base_player{lv = 53,exp_curr = 871001,exp_next = 96478,cost = 0,vigor = 200,friends = 45,hp_lim = 2991,mana_lim = 250,hp_rec = 0,mana_rec = 59,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 299,def = 149,hit = 115,dodge = 115,crit = 115,anti_crit = 115,stiff = 401,anti_stiff = 401,attack_speed = 1000,move_speed = 2000};
get(54) ->
#ets_base_player{lv = 54,exp_curr = 967479,exp_next = 106784,cost = 0,vigor = 200,friends = 45,hp_lim = 3096,mana_lim = 250,hp_rec = 0,mana_rec = 61,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 309,def = 154,hit = 120,dodge = 120,crit = 120,anti_crit = 120,stiff = 412,anti_stiff = 412,attack_speed = 1000,move_speed = 2000};
get(55) ->
#ets_base_player{lv = 55,exp_curr = 1074263,exp_next = 117980,cost = 0,vigor = 200,friends = 46,hp_lim = 3204,mana_lim = 250,hp_rec = 0,mana_rec = 64,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 320,def = 160,hit = 125,dodge = 125,crit = 125,anti_crit = 125,stiff = 423,anti_stiff = 423,attack_speed = 1000,move_speed = 2000};
get(56) ->
#ets_base_player{lv = 56,exp_curr = 1192243,exp_next = 130123,cost = 0,vigor = 200,friends = 46,hp_lim = 3317,mana_lim = 250,hp_rec = 0,mana_rec = 66,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 331,def = 165,hit = 130,dodge = 130,crit = 130,anti_crit = 130,stiff = 434,anti_stiff = 434,attack_speed = 1000,move_speed = 2000};
get(57) ->
#ets_base_player{lv = 57,exp_curr = 1322366,exp_next = 143270,cost = 0,vigor = 200,friends = 46,hp_lim = 3433,mana_lim = 250,hp_rec = 0,mana_rec = 68,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 343,def = 171,hit = 135,dodge = 135,crit = 135,anti_crit = 135,stiff = 446,anti_stiff = 446,attack_speed = 1000,move_speed = 2000};
get(58) ->
#ets_base_player{lv = 58,exp_curr = 1465636,exp_next = 157482,cost = 0,vigor = 200,friends = 47,hp_lim = 3553,mana_lim = 250,hp_rec = 0,mana_rec = 71,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 355,def = 177,hit = 140,dodge = 140,crit = 140,anti_crit = 140,stiff = 458,anti_stiff = 458,attack_speed = 1000,move_speed = 2000};
get(59) ->
#ets_base_player{lv = 59,exp_curr = 1623118,exp_next = 172822,cost = 0,vigor = 200,friends = 47,hp_lim = 3677,mana_lim = 250,hp_rec = 0,mana_rec = 73,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 367,def = 183,hit = 146,dodge = 146,crit = 146,anti_crit = 146,stiff = 470,anti_stiff = 470,attack_speed = 1000,move_speed = 2000};
get(60) ->
#ets_base_player{lv = 60,exp_curr = 1795940,exp_next = 189358,cost = 0,vigor = 200,friends = 47,hp_lim = 3806,mana_lim = 250,hp_rec = 0,mana_rec = 76,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 380,def = 190,hit = 152,dodge = 152,crit = 152,anti_crit = 152,stiff = 482,anti_stiff = 482,attack_speed = 1000,move_speed = 2000};
get(61) ->
#ets_base_player{lv = 61,exp_curr = 1985298,exp_next = 207161,cost = 0,vigor = 200,friends = 48,hp_lim = 3939,mana_lim = 250,hp_rec = 0,mana_rec = 76,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 393,def = 196,hit = 158,dodge = 158,crit = 158,anti_crit = 158,stiff = 495,anti_stiff = 495,attack_speed = 1000,move_speed = 2000};
get(62) ->
#ets_base_player{lv = 62,exp_curr = 2192459,exp_next = 226303,cost = 0,vigor = 200,friends = 48,hp_lim = 4077,mana_lim = 250,hp_rec = 0,mana_rec = 77,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 407,def = 203,hit = 164,dodge = 164,crit = 164,anti_crit = 164,stiff = 508,anti_stiff = 508,attack_speed = 1000,move_speed = 2000};
get(63) ->
#ets_base_player{lv = 63,exp_curr = 2418762,exp_next = 246863,cost = 0,vigor = 200,friends = 48,hp_lim = 4220,mana_lim = 250,hp_rec = 0,mana_rec = 78,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 421,def = 210,hit = 171,dodge = 171,crit = 171,anti_crit = 171,stiff = 521,anti_stiff = 521,attack_speed = 1000,move_speed = 2000};
get(64) ->
#ets_base_player{lv = 64,exp_curr = 2665625,exp_next = 268922,cost = 0,vigor = 200,friends = 49,hp_lim = 4367,mana_lim = 250,hp_rec = 0,mana_rec = 78,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 436,def = 218,hit = 177,dodge = 177,crit = 177,anti_crit = 177,stiff = 535,anti_stiff = 535,attack_speed = 1000,move_speed = 2000};
get(65) ->
#ets_base_player{lv = 65,exp_curr = 2934547,exp_next = 292566,cost = 0,vigor = 200,friends = 49,hp_lim = 4520,mana_lim = 250,hp_rec = 0,mana_rec = 79,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 452,def = 226,hit = 185,dodge = 185,crit = 185,anti_crit = 185,stiff = 549,anti_stiff = 549,attack_speed = 1000,move_speed = 2000};
get(66) ->
#ets_base_player{lv = 66,exp_curr = 3227113,exp_next = 317885,cost = 0,vigor = 200,friends = 49,hp_lim = 4678,mana_lim = 250,hp_rec = 0,mana_rec = 80,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 467,def = 233,hit = 192,dodge = 192,crit = 192,anti_crit = 192,stiff = 564,anti_stiff = 564,attack_speed = 1000,move_speed = 2000};
get(67) ->
#ets_base_player{lv = 67,exp_curr = 3544998,exp_next = 344972,cost = 0,vigor = 200,friends = 50,hp_lim = 4842,mana_lim = 250,hp_rec = 0,mana_rec = 81,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 484,def = 242,hit = 200,dodge = 200,crit = 200,anti_crit = 200,stiff = 579,anti_stiff = 579,attack_speed = 1000,move_speed = 2000};
get(68) ->
#ets_base_player{lv = 68,exp_curr = 3889970,exp_next = 373926,cost = 0,vigor = 200,friends = 50,hp_lim = 5012,mana_lim = 250,hp_rec = 0,mana_rec = 81,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 501,def = 250,hit = 208,dodge = 208,crit = 208,anti_crit = 208,stiff = 594,anti_stiff = 594,attack_speed = 1000,move_speed = 2000};
get(69) ->
#ets_base_player{lv = 69,exp_curr = 4263896,exp_next = 404852,cost = 0,vigor = 200,friends = 50,hp_lim = 5187,mana_lim = 250,hp_rec = 0,mana_rec = 82,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 518,def = 259,hit = 216,dodge = 216,crit = 216,anti_crit = 216,stiff = 610,anti_stiff = 610,attack_speed = 1000,move_speed = 2000};
get(70) ->
#ets_base_player{lv = 70,exp_curr = 4668748,exp_next = 437857,cost = 0,vigor = 200,friends = 50,hp_lim = 5369,mana_lim = 250,hp_rec = 0,mana_rec = 83,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 536,def = 268,hit = 225,dodge = 225,crit = 225,anti_crit = 225,stiff = 626,anti_stiff = 626,attack_speed = 1000,move_speed = 2000};
get(71) ->
#ets_base_player{lv = 71,exp_curr = 5106605,exp_next = 473055,cost = 0,vigor = 200,friends = 50,hp_lim = 5556,mana_lim = 250,hp_rec = 0,mana_rec = 84,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 555,def = 277,hit = 234,dodge = 234,crit = 234,anti_crit = 234,stiff = 643,anti_stiff = 643,attack_speed = 1000,move_speed = 2000};
get(72) ->
#ets_base_player{lv = 72,exp_curr = 5579660,exp_next = 510565,cost = 0,vigor = 200,friends = 50,hp_lim = 5751,mana_lim = 250,hp_rec = 0,mana_rec = 84,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 575,def = 287,hit = 243,dodge = 243,crit = 243,anti_crit = 243,stiff = 660,anti_stiff = 660,attack_speed = 1000,move_speed = 2000};
get(73) ->
#ets_base_player{lv = 73,exp_curr = 6090225,exp_next = 550512,cost = 0,vigor = 200,friends = 50,hp_lim = 5952,mana_lim = 250,hp_rec = 0,mana_rec = 85,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 595,def = 297,hit = 253,dodge = 253,crit = 253,anti_crit = 253,stiff = 677,anti_stiff = 677,attack_speed = 1000,move_speed = 2000};
get(74) ->
#ets_base_player{lv = 74,exp_curr = 6640737,exp_next = 593028,cost = 0,vigor = 200,friends = 50,hp_lim = 6160,mana_lim = 250,hp_rec = 0,mana_rec = 86,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 616,def = 308,hit = 263,dodge = 263,crit = 263,anti_crit = 263,stiff = 695,anti_stiff = 695,attack_speed = 1000,move_speed = 2000};
get(75) ->
#ets_base_player{lv = 75,exp_curr = 7233765,exp_next = 638249,cost = 0,vigor = 200,friends = 50,hp_lim = 6376,mana_lim = 250,hp_rec = 0,mana_rec = 87,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 637,def = 318,hit = 273,dodge = 273,crit = 273,anti_crit = 273,stiff = 713,anti_stiff = 713,attack_speed = 1000,move_speed = 2000};
get(76) ->
#ets_base_player{lv = 76,exp_curr = 7872014,exp_next = 686318,cost = 0,vigor = 200,friends = 50,hp_lim = 6599,mana_lim = 250,hp_rec = 0,mana_rec = 88,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 659,def = 329,hit = 284,dodge = 284,crit = 284,anti_crit = 284,stiff = 732,anti_stiff = 732,attack_speed = 1000,move_speed = 2000};
get(77) ->
#ets_base_player{lv = 77,exp_curr = 8558332,exp_next = 737386,cost = 0,vigor = 200,friends = 50,hp_lim = 6830,mana_lim = 250,hp_rec = 0,mana_rec = 88,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 683,def = 341,hit = 296,dodge = 296,crit = 296,anti_crit = 296,stiff = 751,anti_stiff = 751,attack_speed = 1000,move_speed = 2000};
get(78) ->
#ets_base_player{lv = 78,exp_curr = 9295718,exp_next = 791611,cost = 0,vigor = 200,friends = 50,hp_lim = 7069,mana_lim = 250,hp_rec = 0,mana_rec = 89,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 706,def = 353,hit = 307,dodge = 307,crit = 307,anti_crit = 307,stiff = 771,anti_stiff = 771,attack_speed = 1000,move_speed = 2000};
get(79) ->
#ets_base_player{lv = 79,exp_curr = 10087329,exp_next = 849156,cost = 0,vigor = 200,friends = 50,hp_lim = 7317,mana_lim = 250,hp_rec = 0,mana_rec = 90,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 731,def = 365,hit = 320,dodge = 320,crit = 320,anti_crit = 320,stiff = 791,anti_stiff = 791,attack_speed = 1000,move_speed = 2000};
get(80) ->
#ets_base_player{lv = 80,exp_curr = 10936485,exp_next = 910195,cost = 0,vigor = 200,friends = 50,hp_lim = 7573,mana_lim = 250,hp_rec = 0,mana_rec = 91,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 757,def = 378,hit = 332,dodge = 332,crit = 332,anti_crit = 332,stiff = 812,anti_stiff = 812,attack_speed = 1000,move_speed = 2000};
get(81) ->
#ets_base_player{lv = 81,exp_curr = 11846680,exp_next = 974908,cost = 0,vigor = 200,friends = 50,hp_lim = 7838,mana_lim = 250,hp_rec = 0,mana_rec = 92,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 783,def = 391,hit = 346,dodge = 346,crit = 346,anti_crit = 346,stiff = 834,anti_stiff = 834,attack_speed = 1000,move_speed = 2000};
get(82) ->
#ets_base_player{lv = 82,exp_curr = 12821588,exp_next = 1043484,cost = 0,vigor = 200,friends = 50,hp_lim = 8112,mana_lim = 250,hp_rec = 0,mana_rec = 92,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 811,def = 405,hit = 360,dodge = 360,crit = 360,anti_crit = 360,stiff = 856,anti_stiff = 856,attack_speed = 1000,move_speed = 2000};
get(83) ->
#ets_base_player{lv = 83,exp_curr = 13865072,exp_next = 1116119,cost = 0,vigor = 200,friends = 50,hp_lim = 8396,mana_lim = 250,hp_rec = 0,mana_rec = 93,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 839,def = 419,hit = 374,dodge = 374,crit = 374,anti_crit = 374,stiff = 879,anti_stiff = 879,attack_speed = 1000,move_speed = 2000};
get(84) ->
#ets_base_player{lv = 84,exp_curr = 14981191,exp_next = 1193021,cost = 0,vigor = 200,friends = 50,hp_lim = 8690,mana_lim = 250,hp_rec = 0,mana_rec = 94,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 868,def = 434,hit = 389,dodge = 389,crit = 389,anti_crit = 389,stiff = 902,anti_stiff = 902,attack_speed = 1000,move_speed = 2000};
get(85) ->
#ets_base_player{lv = 85,exp_curr = 16174212,exp_next = 1274406,cost = 0,vigor = 200,friends = 50,hp_lim = 8994,mana_lim = 250,hp_rec = 0,mana_rec = 95,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 899,def = 449,hit = 404,dodge = 404,crit = 404,anti_crit = 404,stiff = 926,anti_stiff = 926,attack_speed = 1000,move_speed = 2000};
get(86) ->
#ets_base_player{lv = 86,exp_curr = 17448618,exp_next = 1360500,cost = 0,vigor = 200,friends = 50,hp_lim = 9309,mana_lim = 250,hp_rec = 0,mana_rec = 96,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 930,def = 465,hit = 421,dodge = 421,crit = 421,anti_crit = 421,stiff = 951,anti_stiff = 951,attack_speed = 1000,move_speed = 2000};
get(87) ->
#ets_base_player{lv = 87,exp_curr = 18809118,exp_next = 1451538,cost = 0,vigor = 200,friends = 50,hp_lim = 9635,mana_lim = 250,hp_rec = 0,mana_rec = 97,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 963,def = 481,hit = 437,dodge = 437,crit = 437,anti_crit = 437,stiff = 976,anti_stiff = 976,attack_speed = 1000,move_speed = 2000};
get(88) ->
#ets_base_player{lv = 88,exp_curr = 20260656,exp_next = 1547769,cost = 0,vigor = 200,friends = 50,hp_lim = 9972,mana_lim = 250,hp_rec = 0,mana_rec = 98,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 997,def = 498,hit = 455,dodge = 455,crit = 455,anti_crit = 455,stiff = 1002,anti_stiff = 1002,attack_speed = 1000,move_speed = 2000};
get(89) ->
#ets_base_player{lv = 89,exp_curr = 21808425,exp_next = 1649449,cost = 0,vigor = 200,friends = 50,hp_lim = 10321,mana_lim = 250,hp_rec = 0,mana_rec = 99,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 1032,def = 516,hit = 473,dodge = 473,crit = 473,anti_crit = 473,stiff = 1029,anti_stiff = 1029,attack_speed = 1000,move_speed = 2000};
get(90) ->
#ets_base_player{lv = 90,exp_curr = 23457874,exp_next = 1756849,cost = 0,vigor = 200,friends = 50,hp_lim = 10682,mana_lim = 250,hp_rec = 0,mana_rec = 99,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 1068,def = 534,hit = 492,dodge = 492,crit = 492,anti_crit = 492,stiff = 1056,anti_stiff = 1056,attack_speed = 1000,move_speed = 2000};
get(91) ->
#ets_base_player{lv = 91,exp_curr = 25214723,exp_next = 1870252,cost = 0,vigor = 200,friends = 50,hp_lim = 11056,mana_lim = 250,hp_rec = 0,mana_rec = 100,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 1105,def = 552,hit = 512,dodge = 512,crit = 512,anti_crit = 512,stiff = 1084,anti_stiff = 1084,attack_speed = 1000,move_speed = 2000};
get(92) ->
#ets_base_player{lv = 92,exp_curr = 27084975,exp_next = 1989951,cost = 0,vigor = 200,friends = 50,hp_lim = 11443,mana_lim = 250,hp_rec = 0,mana_rec = 101,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 1144,def = 572,hit = 532,dodge = 532,crit = 532,anti_crit = 532,stiff = 1113,anti_stiff = 1113,attack_speed = 1000,move_speed = 2000};
get(93) ->
#ets_base_player{lv = 93,exp_curr = 29074926,exp_next = 2116255,cost = 0,vigor = 200,friends = 50,hp_lim = 11844,mana_lim = 250,hp_rec = 0,mana_rec = 102,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 1184,def = 592,hit = 554,dodge = 554,crit = 554,anti_crit = 554,stiff = 1142,anti_stiff = 1142,attack_speed = 1000,move_speed = 2000};
get(94) ->
#ets_base_player{lv = 94,exp_curr = 31191181,exp_next = 2249485,cost = 0,vigor = 200,friends = 50,hp_lim = 12258,mana_lim = 250,hp_rec = 0,mana_rec = 103,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 1225,def = 612,hit = 576,dodge = 576,crit = 576,anti_crit = 576,stiff = 1172,anti_stiff = 1172,attack_speed = 1000,move_speed = 2000};
get(95) ->
#ets_base_player{lv = 95,exp_curr = 33440666,exp_next = 2389978,cost = 0,vigor = 200,friends = 50,hp_lim = 12687,mana_lim = 250,hp_rec = 0,mana_rec = 104,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 1268,def = 634,hit = 599,dodge = 599,crit = 599,anti_crit = 599,stiff = 1203,anti_stiff = 1203,attack_speed = 1000,move_speed = 2000};
get(96) ->
#ets_base_player{lv = 96,exp_curr = 35830644,exp_next = 2538084,cost = 0,vigor = 200,friends = 50,hp_lim = 13131,mana_lim = 250,hp_rec = 0,mana_rec = 105,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 1313,def = 656,hit = 623,dodge = 623,crit = 623,anti_crit = 623,stiff = 1235,anti_stiff = 1235,attack_speed = 1000,move_speed = 2000};
get(97) ->
#ets_base_player{lv = 97,exp_curr = 38368728,exp_next = 2694171,cost = 0,vigor = 200,friends = 50,hp_lim = 13591,mana_lim = 250,hp_rec = 0,mana_rec = 106,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 1359,def = 679,hit = 648,dodge = 648,crit = 648,anti_crit = 648,stiff = 1268,anti_stiff = 1268,attack_speed = 1000,move_speed = 2000};
get(98) ->
#ets_base_player{lv = 98,exp_curr = 41062899,exp_next = 2858621,cost = 0,vigor = 200,friends = 50,hp_lim = 14066,mana_lim = 250,hp_rec = 0,mana_rec = 107,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 1406,def = 703,hit = 673,dodge = 673,crit = 673,anti_crit = 673,stiff = 1302,anti_stiff = 1302,attack_speed = 1000,move_speed = 2000};
get(99) ->
#ets_base_player{lv = 99,exp_curr = 43921520,exp_next = 3031833,cost = 0,vigor = 200,friends = 50,hp_lim = 14559,mana_lim = 250,hp_rec = 0,mana_rec = 108,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 1455,def = 727,hit = 700,dodge = 700,crit = 700,anti_crit = 700,stiff = 1337,anti_stiff = 1337,attack_speed = 1000,move_speed = 2000};
get(100) ->
#ets_base_player{lv = 100,exp_curr = 46953353,exp_next = 3214226,cost = 0,vigor = 200,friends = 50,hp_lim = 15068,mana_lim = 250,hp_rec = 0,mana_rec = 109,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 1506,def = 753,hit = 728,dodge = 728,crit = 728,anti_crit = 728,stiff = 1372,anti_stiff = 1372,attack_speed = 1000,move_speed = 2000};
get(101) ->
#ets_base_player{lv = 101,exp_curr = 50167579,exp_next = 3406235,cost = 0,vigor = 200,friends = 50,hp_lim = 15596,mana_lim = 250,hp_rec = 0,mana_rec = 110,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 1559,def = 779,hit = 758,dodge = 758,crit = 758,anti_crit = 758,stiff = 1408,anti_stiff = 1408,attack_speed = 1000,move_speed = 2000};
get(102) ->
#ets_base_player{lv = 102,exp_curr = 53573814,exp_next = 3608314,cost = 0,vigor = 200,friends = 50,hp_lim = 16142,mana_lim = 250,hp_rec = 0,mana_rec = 111,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 1614,def = 807,hit = 788,dodge = 788,crit = 788,anti_crit = 788,stiff = 1445,anti_stiff = 1445,attack_speed = 1000,move_speed = 2000};
get(103) ->
#ets_base_player{lv = 103,exp_curr = 57182128,exp_next = 3820939,cost = 0,vigor = 200,friends = 50,hp_lim = 16707,mana_lim = 250,hp_rec = 0,mana_rec = 112,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 1670,def = 835,hit = 819,dodge = 819,crit = 819,anti_crit = 819,stiff = 1483,anti_stiff = 1483,attack_speed = 1000,move_speed = 2000};
get(104) ->
#ets_base_player{lv = 104,exp_curr = 61003067,exp_next = 4044605,cost = 0,vigor = 200,friends = 50,hp_lim = 17291,mana_lim = 250,hp_rec = 0,mana_rec = 113,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 1729,def = 864,hit = 852,dodge = 852,crit = 852,anti_crit = 852,stiff = 1522,anti_stiff = 1522,attack_speed = 1000,move_speed = 2000};
get(105) ->
#ets_base_player{lv = 105,exp_curr = 65047672,exp_next = 4279830,cost = 0,vigor = 200,friends = 50,hp_lim = 17896,mana_lim = 250,hp_rec = 0,mana_rec = 114,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 1789,def = 894,hit = 886,dodge = 886,crit = 886,anti_crit = 886,stiff = 1562,anti_stiff = 1562,attack_speed = 1000,move_speed = 2000};
get(106) ->
#ets_base_player{lv = 106,exp_curr = 69327502,exp_next = 4527151,cost = 0,vigor = 200,friends = 50,hp_lim = 18523,mana_lim = 250,hp_rec = 0,mana_rec = 115,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 1852,def = 926,hit = 922,dodge = 922,crit = 922,anti_crit = 922,stiff = 1603,anti_stiff = 1603,attack_speed = 1000,move_speed = 2000};
get(107) ->
#ets_base_player{lv = 107,exp_curr = 73854653,exp_next = 4787133,cost = 0,vigor = 200,friends = 50,hp_lim = 19171,mana_lim = 250,hp_rec = 0,mana_rec = 116,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 1917,def = 958,hit = 959,dodge = 959,crit = 959,anti_crit = 959,stiff = 1645,anti_stiff = 1645,attack_speed = 1000,move_speed = 2000};
get(108) ->
#ets_base_player{lv = 108,exp_curr = 78641786,exp_next = 5060362,cost = 0,vigor = 200,friends = 50,hp_lim = 19842,mana_lim = 250,hp_rec = 0,mana_rec = 117,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 1984,def = 992,hit = 997,dodge = 997,crit = 997,anti_crit = 997,stiff = 1689,anti_stiff = 1689,attack_speed = 1000,move_speed = 2000};
get(109) ->
#ets_base_player{lv = 109,exp_curr = 83702148,exp_next = 5347452,cost = 0,vigor = 200,friends = 50,hp_lim = 20537,mana_lim = 250,hp_rec = 0,mana_rec = 118,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 2053,def = 1026,hit = 1037,dodge = 1037,crit = 1037,anti_crit = 1037,stiff = 1734,anti_stiff = 1734,attack_speed = 1000,move_speed = 2000};
get(110) ->
#ets_base_player{lv = 110,exp_curr = 89049600,exp_next = 5649041,cost = 0,vigor = 200,friends = 50,hp_lim = 21255,mana_lim = 250,hp_rec = 0,mana_rec = 119,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 2125,def = 1062,hit = 1078,dodge = 1078,crit = 1078,anti_crit = 1078,stiff = 1780,anti_stiff = 1780,attack_speed = 1000,move_speed = 2000};
get(111) ->
#ets_base_player{lv = 111,exp_curr = 94698641,exp_next = 5965795,cost = 0,vigor = 200,friends = 50,hp_lim = 21999,mana_lim = 250,hp_rec = 0,mana_rec = 120,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 2199,def = 1099,hit = 1121,dodge = 1121,crit = 1121,anti_crit = 1121,stiff = 1827,anti_stiff = 1827,attack_speed = 1000,move_speed = 2000};
get(112) ->
#ets_base_player{lv = 112,exp_curr = 100664436,exp_next = 6298409,cost = 0,vigor = 200,friends = 50,hp_lim = 22769,mana_lim = 250,hp_rec = 0,mana_rec = 122,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 2276,def = 1138,hit = 1166,dodge = 1166,crit = 1166,anti_crit = 1166,stiff = 1875,anti_stiff = 1875,attack_speed = 1000,move_speed = 2000};
get(113) ->
#ets_base_player{lv = 113,exp_curr = 106962845,exp_next = 6647609,cost = 0,vigor = 200,friends = 50,hp_lim = 23566,mana_lim = 250,hp_rec = 0,mana_rec = 123,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 2356,def = 1178,hit = 1213,dodge = 1213,crit = 1213,anti_crit = 1213,stiff = 1925,anti_stiff = 1925,attack_speed = 1000,move_speed = 2000};
get(114) ->
#ets_base_player{lv = 114,exp_curr = 113610454,exp_next = 7014150,cost = 0,vigor = 200,friends = 50,hp_lim = 24391,mana_lim = 250,hp_rec = 0,mana_rec = 124,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 2439,def = 1219,hit = 1261,dodge = 1261,crit = 1261,anti_crit = 1261,stiff = 1976,anti_stiff = 1976,attack_speed = 1000,move_speed = 2000};
get(115) ->
#ets_base_player{lv = 115,exp_curr = 120624604,exp_next = 7398819,cost = 0,vigor = 200,friends = 50,hp_lim = 25245,mana_lim = 250,hp_rec = 0,mana_rec = 125,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 2524,def = 1262,hit = 1312,dodge = 1312,crit = 1312,anti_crit = 1312,stiff = 2028,anti_stiff = 2028,attack_speed = 1000,move_speed = 2000};
get(116) ->
#ets_base_player{lv = 116,exp_curr = 128023423,exp_next = 7802439,cost = 0,vigor = 200,friends = 50,hp_lim = 26128,mana_lim = 250,hp_rec = 0,mana_rec = 126,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 2612,def = 1306,hit = 1364,dodge = 1364,crit = 1364,anti_crit = 1364,stiff = 2082,anti_stiff = 2082,attack_speed = 1000,move_speed = 2000};
get(117) ->
#ets_base_player{lv = 117,exp_curr = 135825862,exp_next = 8225865,cost = 0,vigor = 200,friends = 50,hp_lim = 27043,mana_lim = 250,hp_rec = 0,mana_rec = 127,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 2704,def = 1352,hit = 1419,dodge = 1419,crit = 1419,anti_crit = 1419,stiff = 2137,anti_stiff = 2137,attack_speed = 1000,move_speed = 2000};
get(118) ->
#ets_base_player{lv = 118,exp_curr = 144051727,exp_next = 8669991,cost = 0,vigor = 200,friends = 50,hp_lim = 27989,mana_lim = 250,hp_rec = 0,mana_rec = 128,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 2798,def = 1399,hit = 1476,dodge = 1476,crit = 1476,anti_crit = 1476,stiff = 2194,anti_stiff = 2194,attack_speed = 1000,move_speed = 2000};
get(119) ->
#ets_base_player{lv = 119,exp_curr = 152721718,exp_next = 9135745,cost = 0,vigor = 200,friends = 50,hp_lim = 28969,mana_lim = 250,hp_rec = 0,mana_rec = 130,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 2896,def = 1448,hit = 1535,dodge = 1535,crit = 1535,anti_crit = 1535,stiff = 2252,anti_stiff = 2252,attack_speed = 1000,move_speed = 2000};
get(120) ->
#ets_base_player{lv = 120,exp_curr = 161857463,exp_next = 9624099,cost = 0,vigor = 200,friends = 50,hp_lim = 29983,mana_lim = 250,hp_rec = 0,mana_rec = 131,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 2998,def = 1499,hit = 1596,dodge = 1596,crit = 1596,anti_crit = 1596,stiff = 2312,anti_stiff = 2312,attack_speed = 1000,move_speed = 2000};
get(121) ->
#ets_base_player{lv = 121,exp_curr = 171481562,exp_next = 10136062,cost = 0,vigor = 200,friends = 50,hp_lim = 31032,mana_lim = 250,hp_rec = 0,mana_rec = 132,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 3103,def = 1551,hit = 1660,dodge = 1660,crit = 1660,anti_crit = 1660,stiff = 2373,anti_stiff = 2373,attack_speed = 1000,move_speed = 2000};
get(122) ->
#ets_base_player{lv = 122,exp_curr = 181617624,exp_next = 10672688,cost = 0,vigor = 200,friends = 50,hp_lim = 32118,mana_lim = 250,hp_rec = 0,mana_rec = 133,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 3211,def = 1605,hit = 1726,dodge = 1726,crit = 1726,anti_crit = 1726,stiff = 2436,anti_stiff = 2436,attack_speed = 1000,move_speed = 2000};
get(123) ->
#ets_base_player{lv = 123,exp_curr = 192290312,exp_next = 11235073,cost = 0,vigor = 200,friends = 50,hp_lim = 33242,mana_lim = 250,hp_rec = 0,mana_rec = 134,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 3324,def = 1662,hit = 1795,dodge = 1795,crit = 1795,anti_crit = 1795,stiff = 2501,anti_stiff = 2501,attack_speed = 1000,move_speed = 2000};
get(124) ->
#ets_base_player{lv = 124,exp_curr = 203525385,exp_next = 11824362,cost = 0,vigor = 200,friends = 50,hp_lim = 34406,mana_lim = 250,hp_rec = 0,mana_rec = 136,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 3440,def = 1720,hit = 1867,dodge = 1867,crit = 1867,anti_crit = 1867,stiff = 2567,anti_stiff = 2567,attack_speed = 1000,move_speed = 2000};
get(125) ->
#ets_base_player{lv = 125,exp_curr = 215349747,exp_next = 12441743,cost = 0,vigor = 200,friends = 50,hp_lim = 35610,mana_lim = 250,hp_rec = 0,mana_rec = 137,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 3561,def = 1780,hit = 1942,dodge = 1942,crit = 1942,anti_crit = 1942,stiff = 2635,anti_stiff = 2635,attack_speed = 1000,move_speed = 2000};
get(126) ->
#ets_base_player{lv = 126,exp_curr = 227791490,exp_next = 13088460,cost = 0,vigor = 200,friends = 50,hp_lim = 36856,mana_lim = 250,hp_rec = 0,mana_rec = 138,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 3685,def = 1842,hit = 2020,dodge = 2020,crit = 2020,anti_crit = 2020,stiff = 2705,anti_stiff = 2705,attack_speed = 1000,move_speed = 2000};
get(127) ->
#ets_base_player{lv = 127,exp_curr = 240879950,exp_next = 13765803,cost = 0,vigor = 200,friends = 50,hp_lim = 38146,mana_lim = 250,hp_rec = 0,mana_rec = 139,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 3814,def = 1907,hit = 2100,dodge = 2100,crit = 2100,anti_crit = 2100,stiff = 2777,anti_stiff = 2777,attack_speed = 1000,move_speed = 2000};
get(128) ->
#ets_base_player{lv = 128,exp_curr = 254645753,exp_next = 14475119,cost = 0,vigor = 200,friends = 50,hp_lim = 39482,mana_lim = 250,hp_rec = 0,mana_rec = 141,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 3948,def = 1974,hit = 2184,dodge = 2184,crit = 2184,anti_crit = 2184,stiff = 2851,anti_stiff = 2851,attack_speed = 1000,move_speed = 2000};
get(129) ->
#ets_base_player{lv = 129,exp_curr = 269120872,exp_next = 15217810,cost = 0,vigor = 200,friends = 50,hp_lim = 40863,mana_lim = 250,hp_rec = 0,mana_rec = 142,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 4086,def = 2043,hit = 2272,dodge = 2272,crit = 2272,anti_crit = 2272,stiff = 2927,anti_stiff = 2927,attack_speed = 1000,move_speed = 2000};
get(130) ->
#ets_base_player{lv = 130,exp_curr = 284338682,exp_next = 15995337,cost = 0,vigor = 200,friends = 50,hp_lim = 42294,mana_lim = 250,hp_rec = 0,mana_rec = 143,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 4229,def = 2114,hit = 2363,dodge = 2363,crit = 2363,anti_crit = 2363,stiff = 3005,anti_stiff = 3005,attack_speed = 1000,move_speed = 2000};
get(131) ->
#ets_base_player{lv = 131,exp_curr = 300334019,exp_next = 16809221,cost = 0,vigor = 200,friends = 50,hp_lim = 43774,mana_lim = 250,hp_rec = 0,mana_rec = 145,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 4377,def = 2188,hit = 2457,dodge = 2457,crit = 2457,anti_crit = 2457,stiff = 3085,anti_stiff = 3085,attack_speed = 1000,move_speed = 2000};
get(132) ->
#ets_base_player{lv = 132,exp_curr = 317143240,exp_next = 17661044,cost = 0,vigor = 200,friends = 50,hp_lim = 45306,mana_lim = 250,hp_rec = 0,mana_rec = 146,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 4530,def = 2265,hit = 2555,dodge = 2555,crit = 2555,anti_crit = 2555,stiff = 3167,anti_stiff = 3167,attack_speed = 1000,move_speed = 2000};
get(133) ->
#ets_base_player{lv = 133,exp_curr = 334804284,exp_next = 18552456,cost = 0,vigor = 200,friends = 50,hp_lim = 46892,mana_lim = 250,hp_rec = 0,mana_rec = 147,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 4689,def = 2344,hit = 2658,dodge = 2658,crit = 2658,anti_crit = 2658,stiff = 3251,anti_stiff = 3251,attack_speed = 1000,move_speed = 2000};
get(134) ->
#ets_base_player{lv = 134,exp_curr = 353356740,exp_next = 19485173,cost = 0,vigor = 200,friends = 50,hp_lim = 48533,mana_lim = 250,hp_rec = 0,mana_rec = 149,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 4853,def = 2426,hit = 2764,dodge = 2764,crit = 2764,anti_crit = 2764,stiff = 3337,anti_stiff = 3337,attack_speed = 1000,move_speed = 2000};
get(135) ->
#ets_base_player{lv = 135,exp_curr = 372841913,exp_next = 20460985,cost = 0,vigor = 200,friends = 50,hp_lim = 50232,mana_lim = 250,hp_rec = 0,mana_rec = 150,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 5023,def = 2511,hit = 2874,dodge = 2874,crit = 2874,anti_crit = 2874,stiff = 3425,anti_stiff = 3425,attack_speed = 1000,move_speed = 2000};
get(136) ->
#ets_base_player{lv = 136,exp_curr = 393302898,exp_next = 21481750,cost = 0,vigor = 200,friends = 50,hp_lim = 51990,mana_lim = 250,hp_rec = 0,mana_rec = 151,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 5198,def = 2599,hit = 2989,dodge = 2989,crit = 2989,anti_crit = 2989,stiff = 3516,anti_stiff = 3516,attack_speed = 1000,move_speed = 2000};
get(137) ->
#ets_base_player{lv = 137,exp_curr = 414784648,exp_next = 22549407,cost = 0,vigor = 200,friends = 50,hp_lim = 53809,mana_lim = 250,hp_rec = 0,mana_rec = 153,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 5380,def = 2690,hit = 3109,dodge = 3109,crit = 3109,anti_crit = 3109,stiff = 3609,anti_stiff = 3609,attack_speed = 1000,move_speed = 2000};
get(138) ->
#ets_base_player{lv = 138,exp_curr = 437334055,exp_next = 23665973,cost = 0,vigor = 200,friends = 50,hp_lim = 55693,mana_lim = 250,hp_rec = 0,mana_rec = 154,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 5569,def = 2784,hit = 3233,dodge = 3233,crit = 3233,anti_crit = 3233,stiff = 3705,anti_stiff = 3705,attack_speed = 1000,move_speed = 2000};
get(139) ->
#ets_base_player{lv = 139,exp_curr = 461000028,exp_next = 24833546,cost = 0,vigor = 200,friends = 50,hp_lim = 57642,mana_lim = 250,hp_rec = 0,mana_rec = 156,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 5764,def = 2882,hit = 3363,dodge = 3363,crit = 3363,anti_crit = 3363,stiff = 3803,anti_stiff = 3803,attack_speed = 1000,move_speed = 2000};
get(140) ->
#ets_base_player{lv = 140,exp_curr = 485833574,exp_next = 26054310,cost = 0,vigor = 200,friends = 50,hp_lim = 59659,mana_lim = 250,hp_rec = 0,mana_rec = 157,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 5965,def = 2982,hit = 3497,dodge = 3497,crit = 3497,anti_crit = 3497,stiff = 3904,anti_stiff = 3904,attack_speed = 1000,move_speed = 2000};
get(141) ->
#ets_base_player{lv = 141,exp_curr = 511887884,exp_next = 27330541,cost = 0,vigor = 200,friends = 50,hp_lim = 61747,mana_lim = 250,hp_rec = 0,mana_rec = 158,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 6174,def = 3087,hit = 3637,dodge = 3637,crit = 3637,anti_crit = 3637,stiff = 4007,anti_stiff = 4007,attack_speed = 1000,move_speed = 2000};
get(142) ->
#ets_base_player{lv = 142,exp_curr = 539218425,exp_next = 28664604,cost = 0,vigor = 200,friends = 50,hp_lim = 63909,mana_lim = 250,hp_rec = 0,mana_rec = 160,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 6390,def = 3195,hit = 3783,dodge = 3783,crit = 3783,anti_crit = 3783,stiff = 4113,anti_stiff = 4113,attack_speed = 1000,move_speed = 2000};
get(143) ->
#ets_base_player{lv = 143,exp_curr = 567883029,exp_next = 30058962,cost = 0,vigor = 200,friends = 50,hp_lim = 66145,mana_lim = 250,hp_rec = 0,mana_rec = 161,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 6614,def = 3307,hit = 3934,dodge = 3934,crit = 3934,anti_crit = 3934,stiff = 4222,anti_stiff = 4222,attack_speed = 1000,move_speed = 2000};
get(144) ->
#ets_base_player{lv = 144,exp_curr = 597941991,exp_next = 31516178,cost = 0,vigor = 200,friends = 50,hp_lim = 68460,mana_lim = 250,hp_rec = 0,mana_rec = 163,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 6846,def = 3423,hit = 4091,dodge = 4091,crit = 4091,anti_crit = 4091,stiff = 4334,anti_stiff = 4334,attack_speed = 1000,move_speed = 2000};
get(145) ->
#ets_base_player{lv = 145,exp_curr = 629458169,exp_next = 33038917,cost = 0,vigor = 200,friends = 50,hp_lim = 70857,mana_lim = 250,hp_rec = 0,mana_rec = 164,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 7085,def = 3542,hit = 4255,dodge = 4255,crit = 4255,anti_crit = 4255,stiff = 4449,anti_stiff = 4449,attack_speed = 1000,move_speed = 2000};
get(146) ->
#ets_base_player{lv = 146,exp_curr = 662497086,exp_next = 34629954,cost = 0,vigor = 200,friends = 50,hp_lim = 73337,mana_lim = 250,hp_rec = 0,mana_rec = 166,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 7333,def = 3666,hit = 4425,dodge = 4425,crit = 4425,anti_crit = 4425,stiff = 4567,anti_stiff = 4567,attack_speed = 1000,move_speed = 2000};
get(147) ->
#ets_base_player{lv = 147,exp_curr = 697127040,exp_next = 36292175,cost = 0,vigor = 200,friends = 50,hp_lim = 75903,mana_lim = 250,hp_rec = 0,mana_rec = 167,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 7590,def = 3795,hit = 4602,dodge = 4602,crit = 4602,anti_crit = 4602,stiff = 4688,anti_stiff = 4688,attack_speed = 1000,move_speed = 2000};
get(148) ->
#ets_base_player{lv = 148,exp_curr = 733419215,exp_next = 38028584,cost = 0,vigor = 200,friends = 50,hp_lim = 78560,mana_lim = 250,hp_rec = 0,mana_rec = 169,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 7855,def = 3927,hit = 4786,dodge = 4786,crit = 4786,anti_crit = 4786,stiff = 4812,anti_stiff = 4812,attack_speed = 1000,move_speed = 2000};
get(149) ->
#ets_base_player{lv = 149,exp_curr = 771447799,exp_next = 39842303,cost = 0,vigor = 200,friends = 50,hp_lim = 81310,mana_lim = 250,hp_rec = 0,mana_rec = 170,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 8130,def = 4065,hit = 4978,dodge = 4978,crit = 4978,anti_crit = 4978,stiff = 4940,anti_stiff = 4940,attack_speed = 1000,move_speed = 2000};
get(150) ->
#ets_base_player{lv = 150,exp_curr = 811290102,exp_next = 41736583,cost = 0,vigor = 200,friends = 50,hp_lim = 84155,mana_lim = 250,hp_rec = 0,mana_rec = 172,ice = 0,fire = 0,honly = 0,dark = 0,anti_ice = 0,anti_fire = 0,anti_honly = 0,anti_dark = 0,attack = 8415,def = 4207,hit = 5177,dodge = 5177,crit = 5177,anti_crit = 5177,stiff = 5071,anti_stiff = 5071,attack_speed = 1000,move_speed = 2000};
get(Var1) -> ?WARNING_MSG("get not find ~p", [{Var1}]),
[].

get_player_max_lv() ->
150.
