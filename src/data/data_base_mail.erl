%% coding: utf-8
%% Warning:本文件由data_generate自动生成，请不要手动修改
-module(data_base_mail).
-export([get/1]).
-include("common.hrl").
-include("db_base_mail.hrl").
get(3) ->
#base_mail{id = 3,title = <<"竞技场排行榜奖励"/utf8>>,content = <<"恭喜你在竞技场中英勇奋战，获得第~w名，这是你的奖励"/utf8>>,mail_define = 0};
get(2) ->
#base_mail{id = 2,title = <<"通天塔排行榜奖励"/utf8>>,content = <<"恭喜你在通天塔中英勇奋战，获得第~w名，这是你的奖励"/utf8>>,mail_define = 0};
get(1) ->
#base_mail{id = 1,title = <<"投放幸运币奖励"/utf8>>,content = <<"这是你投放幸运币返还的奖励，奖励在附件中收取"/utf8>>,mail_define = 0};
get(Var1) -> ?WARNING_MSG("get not find ~p", [{Var1}]),
[].
