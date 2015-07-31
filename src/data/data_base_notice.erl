%% coding: utf-8
%% Warning:本文件由data_generate自动生成，请不要手动修改
-module(data_base_notice).
-export([get/1]).
-export([notice_all_id/0]).
-include("common.hrl").
-include("db_base_notice.hrl").
get(1) ->
#base_notice{id = 1,notice_id = 1001,sort_id = 1,type = 2,server_id = [],notice_name = <<"欢庆删档测试"/utf8>>,show_time = [{2015,7,8,23,30,0},{2015,7,30,12,30,0}],activity_time = [{2015,7,9,10,0,0},{2015,7,18,23,59,59}],headline = <<"欢庆删档测试"/utf8>>,des = <<"欢迎大家来参加[fdff52]<<黄雀在后·真·格斗无双>>[-]的删档测试，祝游戏愉快！                      [fdff52]官方玩家QQ群 115402128[-]"/utf8>>,function_id = 0};
get(2) ->
#base_notice{id = 2,notice_id = 1001,sort_id = 2,type = 2,server_id = [],notice_name = <<"欢庆删档测试"/utf8>>,show_time = [{2015,7,8,23,30,0},{2015,7,30,12,30,0}],activity_time = [{2015,7,9,10,0,0},{2015,7,16,23,59,59}],headline = <<"打副本 抢Q币"/utf8>>,des = <<"活动期间打[fdff52]《朗德》之后的王者副本[-]PK胜利之后很大概率掉[fdff52]Q币券[-]，记得[fdff52]绑定QQ[-]，活动结束就可以兑换Q币。赶快去抢吧！"/utf8>>,function_id = 900001};
get(Var1) -> ?WARNING_MSG("get not find ~p", [{Var1}]),
[].

notice_all_id() ->
[1,2].
