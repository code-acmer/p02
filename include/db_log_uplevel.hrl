%%%------------------------------------------------	
%%% File    : db_log_uplevel.hrl	
%%% Description: 从mysql表生成的record	
%%% Warning:  由程序自动生成，请不要随意修改！	
%%%------------------------------------------------    	
	
-ifndef(DB_LOG_UPLEVEL_HRL).	
-define(DB_LOG_UPLEVEL_HRL, true).	
	
%% 	
%% log_uplevel ==> log_uplevel 	
-record(log_uplevel, {	
      id,                                     %% 增自ID	
      time = 0,                               %% 升级时间	
      player_id,                              %% 玩家ID	
      accname = "",                           %% 平台账号	
      nickname = "",                          %% 角色名	
      lv = 0,                                 %% 当前等级	
      exp = 0,                                %% 当前经验	
      scene = 0,                              %% 场景ID	
      x = 0,                                  %% x坐标	
      y = 0                                   %% y坐标	
    }).	
	
-endif.	
