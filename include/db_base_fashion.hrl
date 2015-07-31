-ifndef(DB_BASE_FASHION_HRL).	
-define(DB_BASE_FASHION_HRL, true).	
	
%% 	
%% data_base_fashion ==> base_fashion 	
-record(data_base_fashion, {	
      id  = 0,                                 %% 时装ID
      nid = 0,                                 %% 资源ID
      name,                                    %% 时装名称
      fashion_desc,                            %% 时装详细信息
      career = 0,                              %% 职业类型
      property = 0,                            %% 属性索引
      price = 0                                %% 累计充值元宝数量可以获得
      }).	
	
-endif.