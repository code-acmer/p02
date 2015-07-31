-ifndef(DEFINE_FASHION_HRL).
-define(DEFINE_FASHION_HRL,true).

-record(fashion, {  
          id  = 0,                                 %%
          version = fashion_version:current_version(),
          player_id = 0,                           %% 玩家ID
          fashion_id = 0,                          %% 时装ID
          container  = 0,                          %% 所处容器，身上或时装背包
          property = 0,                            %% 属性索引ID
          nid = 0,                                 %% 资源ID
          name = <<"">>,                           %% 时装名称
          fashion_desc = <<"">>,                   %% 时装详细信息
          price = 0      
         }).

-endif.
