%%%--------------------------------------
%%% @Module  : pp_skill
%%% @Created : 2010.10.06 
%%% @Description:  技能管理
%%%--------------------------------------
-module(pp_skill).
%% -export([handle/3]).
%% -include("common.hrl").
%% 
%% %%学习技能
%% handle(21001, Status, SkillId) ->
%%     lib_skill:upgrade_skill(Status, SkillId, 0);
%% 	
%% 
%% %%获取技能列表
%% handle(21002, Status, _) ->
%%     All = data_agent:skill_get_id_list(Status#player.career),
%% 	All1 = lists:sort(All),
%%     {ok, BinData} = pt_21:write(21002, [All1, Status#player.other#player_other.skill]),
%%     lib_send:send_to_sid(Status#player.other#player_other.pid_send, BinData);
%% 
%% handle(_Cmd, _Status, _Data) ->
%%     {error, "pp_skill no match"}.
