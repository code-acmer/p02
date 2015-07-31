-ifndef(DEFINE_INFO_48_HRL).
-define(DEFINE_INFO_48_HRL, true).

-include("define_info_0.hrl").


-define(INFO_BASE_WARCRAFT_NO_FOUND,            48501).   %% 未找到配置数据
-define(INFO_WARCRAFT_NOT_FOUND,                48502).   %% 不存在城池
-define(INFO_WARCRAFT_LV_LIMIT,                 48503).   %% 等级不足，无法占领
-define(INFO_WARCRAFT_MOBI_LIMIT,               48504).   %% 军粮不足，发兵失败
-define(INFO_WARCRAFT_30_MIN_CD,                48505).   %% 城池仍在30分钟保护期内
-define(INFO_RETREAT_AFTER_30_MIN,              48506).   %% 30分钟后方能撤出占领
-define(INFO_WARCRAFT_HAVE_SNATCHED,            48507).   %% 你已经掠夺过他了。
-define(INFO_WARCRAFT_OWNER_MINE,               48508).   %% 不能攻击自己的城池
-define(INFO_WARCRAFT_NO_OWNER,                 48509).   %% 不能掠夺没有被占领的城池
-define(INFO_WARCRAFT_NO_OWNER_RETREAT,         48510).   %% 非自己的城池不能撤出
-define(INFO_WARCRAFT_LV_TOO_HIGHT,             48511).   %% 已有更多高级城池可攻击，切勿再贪。
-define(INFO_WARCRAFT_SNATCH_TIMES_LIMIT,       48512).   %% 该城池被打劫多次，已是城破楼空了。


-endif.

