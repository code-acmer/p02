-ifndef(DEFINE_INFO_54_HRL).
-define(DEFINE_INFO_54_HRL, true).

-include("define_info_0.hrl").


-define(INFO_ARTIFACT_UPGRADE_SUCCESS,          54000).   %% 法宝进阶成功
-define(INFO_ARTIFACT_UPGRADE_FAILED,           54001).   %% 法宝进阶失败
-define(INFO_ARTIFACT_NOT_ARTIFACT,             54002).   %% 非法宝数据，无法进行此操作
-define(INFO_ARTIFACT_WRONG_OWNER,              54003).   %% 该法宝并不是你的，无法进阶
-define(INFO_ARTIFACT_ITEM_NOT_SATISFIED,       54004).   %% 升级所需物品不足，无法进阶
-define(INFO_ARTIFACT_LEVEL_NOT_SATISFIED,      54005).   %% 角色等级不足，无法进阶
-define(INFO_ARTIFACT_MAX_LEVEL,                54006).   %% 已达升级上限，无法进阶
-define(INFO_ARTIFACT_WRONG_BASE_INFO,          54007).   %% 法宝升级数据获取失败，无法进阶
-define(INFO_ARTIFACT_WRONG_UPGRADE_INFO,       54008).   %% 法宝升级信息错误，无法进阶
-define(INFO_ARTIFACT_VIP_LEVEL_LOWER,          54009).   %% vip等级不足，无法使用法宝炼化材料补齐功能


-endif.

