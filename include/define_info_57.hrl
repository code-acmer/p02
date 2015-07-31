-ifndef(DEFINE_INFO_57_HRL).
-define(DEFINE_INFO_57_HRL, true).

-include("define_info_0.hrl").


-define(INFO_SLAVE_QUERY_SUCCESS,               57000).   %% 查询属臣信息成功
-define(INFO_SLAVE_QUERY_FAILED,                57001).   %% 查询属臣信息失败
-define(INFO_SLAVE_TARGET_NOT_FOUND,            57002).   %% 征服目标未找到或目标尚未开启该功能
-define(INFO_SLAVE_INFO_NOT_FOUND,              57003).   %% 属臣信息获取失败
-define(INFO_SLAVE_ENSLAVE_COMBAT_SUCCESS,      57010).   %% 你征服了 %s ！他成为了你的属臣
-define(INFO_SLAVE_ENSLAVE_COMBAT_FAILED,       57011).   %% 征服战斗发起失败
-define(INFO_SLAVE_CANT_ENSLAVE_MASTER,         57012).   %% 对方是您的宗主，不可征服，您可以先[反叛]他
-define(INFO_SLAVE_TARGET_NOT_COOLDOWN,         57013).   %% 对方刚刚被征服了，还在30分钟保护时间内
-define(INFO_SLAVE_ENSLAVE_TIMES_OUT,           57014).   %% 今日的征服次数耗尽，请明天再进行征服吧
-define(INFO_SLAVE_SLAVE_EXCEED,                57015).   %% 无法征服，你所拥有的属臣已达上限
-define(INFO_SLAVE_CANT_ENSLAVE_SLAVE,          57016).   %% 该玩家已经是你的属臣
-define(INFO_SLAVE_REBEL_SUCCESS,               57020).   %% 反叛战斗发起成功
-define(INFO_SLAVE_REBEL_FAILED,                57021).   %% 反叛战斗发起失败
-define(INFO_SLAVE_REBEL_NO_MASTER,             57022).   %% 你现在属于自由身，无需反叛
-define(INFO_SLAVE_REBEL_TIMES_OUT,             57023).   %% 今日的反叛次数已经使用完毕
-define(INFO_SLAVE_RESCUE_SUCCESS,              57030).   %% 解救战斗发起成功
-define(INFO_SLAVE_RESCUE_FAILED,               57031).   %% 解救战斗发起失败
-define(INFO_SLAVE_RESCUE_TIMES_OUT,            57032).   %% 今日的解救次数已经使用完毕
-define(INFO_SLAVE_RESCUE_NO_MASTER,            57034).   %% 对方已经是自由身了，无需解救
-define(INFO_SLAVE_RESCUE_SELF_SLAVE,           57035).   %% 您确定要解救自己的属臣么？
-define(INFO_SLAVE_INTERACT_SUCCESS,            57040).   %% 属臣交互成功
-define(INFO_SLAVE_INTERACT_FAILED,             57041).   %% 属臣交互失败
-define(INFO_SLAVE_TARGET_NOT_SLAVE,            57042).   %% 目标不是您的属臣
-define(INFO_SLAVE_WRONG_INTERACT_TYPE,         57043).   %% 错误的交互类型，操作失败
-define(INFO_SLAVE_TARGET_NOT_MASTER,           57044).   %% 目标不是您的宗主
-define(INFO_SLAVE_INTERACT_TIMES_OUT,          57045).   %% 今日的互动次数已经使用完毕，请明日再来
-define(INFO_SLAVE_KICKOUT_SUCCESS,             57050).   %% 成功将 %s 释放
-define(INFO_SLAVE_KICKOUT_FAILED,              57051).   %% 释放属臣失败
-define(INFO_SLAVE_SOS_SUCCESS,                 57060).   %% 军团求救信息发送成功
-define(INFO_SLAVE_SOS_FAILED,                  57061).   %% 求救信息发送失败
-define(INFO_SLAVE_SOS_NO_GUILD,                57062).   %% 您还没有加入军团，无法求救
-define(INFO_SLAVE_SOS_NOT_READY,               57063).   %% 已经发送过求救信息，请稍后尝试
-define(INFO_SLAVE_SOS_NO_MASTER,               57064).   %% 您已经是自由身了，无需求救
-define(INFO_SLAVE_BONUS_INFO,                  57070).   %% 属臣上缴合计：经验 %s、铜钱 %s、声望 %s，属臣互动合计：经验 %s、铜钱 %s、声望 %s


-endif.

