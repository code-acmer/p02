%%%------------------------------------------------	
%%% File    : db_base_app_store_product.hrl	
%%% Description: 从mysql表生成的record	
%%% Warning:  由程序自动生成，请不要随意修改！	
%%%------------------------------------------------    	
	
-ifndef(DB_BASE_APP_STORE_PRODUCT_HRL).	
-define(DB_BASE_APP_STORE_PRODUCT_HRL, true).	
	
%% 	
%% base_app_store_product ==> ets_base_app_store_product 	
-record(ets_base_app_store_product, {	
      id,                                     %% 	
      product_id,                             %% app store配置的product_id	
      gold,                                   %% 充值获得的金钱	
      reward_gold,                            %% 充值赠送的金钱	
      money,                                  %% 所需要的人民币	
      icon,                                   %% 	
      act_reward_gold,                        %% 活动期间充值赠送的金钱	
      act_time_start,                         %% 活动开始时间	
      act_time_end                            %% 活动结束时间	
    }).	
	
-endif.	
