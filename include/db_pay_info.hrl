%%%------------------------------------------------	
%%% File    : db_pay_info.hrl	
%%% Description: 从mysql表生成的record	
%%% Warning:  由程序自动生成，请不要随意修改！	
%%%------------------------------------------------    	
	
-ifndef(DB_PAY_INFO_HRL).	
-define(DB_PAY_INFO_HRL, true).	
	
%% 	
%% pay_info ==> ets_pay_info 	
-record(ets_pay_info, {	
      id = "",                                %% 	
      server_id,                              %% 充入的服务器id	
      uid,                                    %% 	
      pay_way,                                %% 	
      amount,                                 %% 	
      callback_info,                          %% 充值回调信息	
      order_state,                            %% 订单状态（0：充值失败1：充值成功）	
      failed_desc,                            %% 充值失败原因	
      charge_state = 0,                       %% 充值状态（0-未使用；1-已使用）	
      player_id = 0,                          %% 角色id	
      lv = 0,                                 %% 角色当前等级	
      charge_times = 0,                       %% 充值次数（1为首充）	
      timestamp,                              %% 充值时间戳	
      goods_id = 0,                           %% 	
      goods_info,                             %% 	
      goods_count,                            %% 	
      original_money = 0,                     %% 	
      order_money = 0,                        %% 	
      create_time,                            %% 	
      consume_stream_id,                      %% 	
      note                                    %% 	
    }).	
	
-endif.	
