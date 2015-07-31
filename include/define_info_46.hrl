-ifndef(DEFINE_INFO_46_HRL).
-define(DEFINE_INFO_46_HRL, true).

-include("define_info_0.hrl").


-define(INFO_BEAST_TOO_FAST,                    46000).   %% 操作太过频繁，请稍后再做尝试
-define(INFO_MAKE_BEAST_FAILED,                 46001).   %% 生成灵兽失败
-define(INFO_GET_BEAST,                         46002).   %% 恭喜您获得灵兽[%s]
-define(INFO_BEAST_MAX_LV,                      46003).   %% 灵兽已最高等级
-define(INFO_BEAST_ATTRI_MAX,                   46004).   %% 属性已达最高等级，无法再升级！！
-define(INFO_BEAST_ATTRI_NO_FOUND,              46005).   %% 未找到相应的灵兽属性！！！
-define(INFO_BEAST_ATTRI_LV_UP_FAILED,          46006).   %% 灵兽属性升级失败
-define(INFO_BEAST_NO_FOUND,                    46007).   %% 还未拥有灵兽，无法进行该操作
-define(INFO_BEAST_NOT_OWNER,                   46008).   %% 不是灵兽拥有者
-define(INFO_BEAST_SKILL_MAX,                   46009).   %% 技能已达最高等级
-define(INFO_BEAST_SKILL_LV_UP_FAILED,          46010).   %% 灵兽技能升级失败
-define(INFO_BASE_SKILL_NO_FOUND,               46011).   %% 技能数据未找到
-define(INFO_BEAST_CAMP_MAX,                    46012).   %% 阵法已达最高等级
-define(INFO_BEAST_CAMP_NO_FOUND,               46013).   %% 未找到阵法数据
-define(INFO_BASE_CAMP_NO_FOUND,                46014).   %% 未找到基础阵法数据
-define(INFO_BEAST_CAMP_LV_UP_FAILED,           46015).   %% 阵法升级失败
-define(INFO_BASE_BEAST_NO_FOUND,               46016).   %% 基础灵兽数据未找到
-define(INFO_BEAST_UPDATE_FAILED,               46017).   %% 更新灵兽数据失败
-define(INFO_BEAST_LV_LIMIT,                    46018).   %% 灵兽等级不够
-define(INFO_BEAST_LV_TOO_HIGHT,                46019).   %% 灵兽等级不能超过玩家等级
-define(INFO_BEAST_CHANGE_CONF_ERR,             46020).   %% 灵兽幻化配置错误
-define(INFO_BEAST_CHANGE_OWN,                  46021).   %% 已经拥有此灵兽幻化
-define(INFO_BEAST_CHANGE_CANNOT_NEW,           46022).   %% 未达到获取该宠物的条件，请再接再厉
-define(INFO_BEAST_CHANGE_NOT_OWN,              46023).   %% 未获得该宠物
-define(INFO_STAR_POWER_MAX,                    46500).   %% 星力已经达上限！！！
-define(INFO_STAR_POWER_SUCCESS,                46501).   %% 星力激活成功


-endif.

