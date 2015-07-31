%% coding: utf-8
%% Warning:本文件由data_generate自动生成，请不要手动修改
-module(data_base_login_reward).
-export([get/1]).
-include("common.hrl").
-include("db_base_login_reward.hrl").
get(1) ->
#base_login_reward{id = 1,day_info = <<"1"/utf8>>,reward = [{3,5000},{240100101,50},{270102,1},{90113000,1},{90213000,1},{300003,2}],desc = <<""/utf8>>};
get(2) ->
#base_login_reward{id = 2,day_info = <<"2"/utf8>>,reward = [{3,10000},{240100101,100},{270102,2},{90113000,1},{90213000,1},{300003,3}],desc = <<""/utf8>>};
get(3) ->
#base_login_reward{id = 3,day_info = <<"3"/utf8>>,reward = [{3,15000},{240100101,150},{270102,3},{90113000,1},{90213000,1},{300003,4}],desc = <<""/utf8>>};
get(4) ->
#base_login_reward{id = 4,day_info = <<"4"/utf8>>,reward = [{3,20000},{240100101,200},{270102,4},{90113000,1},{90213000,1},{300003,5}],desc = <<""/utf8>>};
get(5) ->
#base_login_reward{id = 5,day_info = <<"5"/utf8>>,reward = [{3,25000},{240100101,250},{270102,5},{90113000,2},{90213000,2},{300003,6}],desc = <<""/utf8>>};
get(6) ->
#base_login_reward{id = 6,day_info = <<"6"/utf8>>,reward = [{3,30000},{240100101,300},{270102,6},{90113000,2},{90213000,2},{300003,7}],desc = <<""/utf8>>};
get(7) ->
#base_login_reward{id = 7,day_info = <<"7"/utf8>>,reward = [{3,35000},{240100101,350},{270102,7},{90113000,2},{90213000,2},{300003,8}],desc = <<""/utf8>>};
get(Var1) -> ?WARNING_MSG("get not find ~p", [{Var1}]),
[].
