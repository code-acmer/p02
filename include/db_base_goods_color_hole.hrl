%% Warning:本文件由make_record自动生成，请不要手动修改
-ifndef(DB_BASE_GOODS_COLOR_HOLE_HRL).
-define(DB_BASE_GOODS_COLOR_HOLE_HRL, true).
%% base_goods_color_hole => base_goods_color_hole
-record(base_goods_color_hole, {
          id,                                   %% 物品颜色id
          desc = <<""/utf8>>,                   %% 颜色描述
          hole = 0                              %% 孔数
         }).
-endif.
