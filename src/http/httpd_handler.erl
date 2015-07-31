%%% @author Roowe <bestluoliwe@gmail.com>
%%% @copyright (C) 2013, Roowe
%%% @doc
%%%
%%% @end
%%% Created :  3 Nov 2013 by Roowe <bestluoliwe@gmail.com>

-module(httpd_handler).

-export([start/1, stop/0, loop/1]).

-include("define_logger.hrl").
-include("define_chat.hrl").
-include("define_player.hrl").
%% External API

start(Options) ->
    ?INFO_MSG("mochiweb start on: ~p~n", [Options]),
    Loop = {?MODULE, loop},
    mochiweb_http:start([{name, ?MODULE}, {loop, Loop} | Options]).

stop() ->
    mochiweb_http:stop(?MODULE).

%% -节点信息查询:   /get_node_status?            (ok)
%% -节点信息查询:   /get_node_info?type=1[cpu]2[memory]3[queue](ok)
%% -进程信息查询    /get_process_info?p=pid      (ok)
%% -获取进程信息    /get_proc_info?p=<0,1,2>     (ok)
%% -关闭节点       /close_nodes?t=1|2
%% -设置禁言:      /donttalk?id=stoptime(分钟)   (ok)
%% -解除禁言:      /donttalk?id=0&stoptime=0    (ok)
%% -踢人下线：     /kickuser?id                 (ok)
%% -封/开角色：    /banrole?id=1/0              (ok)
%% -通知客户端增减金钱    /notice_change_money?id=parm
%% -GM群发：      /broadmsg?gmid_content[中文？] (ok)
%% -安全退出游戏服务器：  /safe_quit?node          (ok)
%% -禁言列表：     /donttalklist?  
%% -获取在线人数   /online_count?                (ok)
%% -获取场景人数   /scene_online_count?          (ok)
%% -重新加载模块   /cl?module_name=Module 

loop(Req) ->
    lib_misc_admin:treat_http_request(Req).


