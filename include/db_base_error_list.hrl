%%%------------------------------------------------	
%%% File    : db_base_error_list.hrl	
%%% Description: 从mysql表生成的record	
%%% Warning:  由程序自动生成，请不要随意修改！	
%%%------------------------------------------------    	
	
-ifndef(DB_BASE_ERROR_LIST_HRL).	
-define(DB_BASE_ERROR_LIST_HRL, true).	
	
%% 	
%% base_error_list ==> base_error_list 	
-record(base_error_list, {	
      error_code,                             %% 错误码唯一KEY	
      error_define,                           %% 服务器宏定义	
      error_desc                              %% 错误描述	
    }).	
	
-endif.	
