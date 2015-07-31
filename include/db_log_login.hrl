%%%------------------------------------------------	
%%% File    : db_log_login.hrl	
%%% Description: 从mysql表生成的record	
%%% Warning:  由程序自动生成，请不要随意修改！	
%%%------------------------------------------------    	
	
-ifndef(DB_LOG_LOGIN_HRL).	
-define(DB_LOG_LOGIN_HRL, true).	
	
%% 	
%% log_login ==> log_login 	
-record(log_login, {	
      pid = 0,                                %% 玩家ID	
      type = 1,                               %% 登录类型：1创建角色，2登录游戏	
      date,                                   %% 天数	
      time,                                   %% 时间	
      lv = 0,                                 %% 登出时的角色等级	
      dungeon = 0,                            %% 通关副本id	
      timestamp = 0                           %% 时间戳函数	
    }).	
	
-endif.	
