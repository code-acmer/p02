%% Warning:本文件由make_record自动生成，请不要手动修改
-ifndef(DB_BASE_TWIST_EGG_HRL).
-define(DB_BASE_TWIST_EGG_HRL, true).
%% base_twist_egg => base_twist_egg
-record(base_twist_egg, {
          id = 0,                               %% 斗魂ID
          goods_id,                             %% 斗魂id
          type,                                 %% 类型，1友情，2元宝，3特殊
          rate,                                 %% 率概
          att_lv,                               %% 加附属性-等级
          star                                  %% 星级
         }).
-endif.
