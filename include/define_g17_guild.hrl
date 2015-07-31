-ifndef(DEFINE_G17_GUILD_HRL).
-define(DEFINE_G17_GUILD, true).

%% 新浪公会信息|仅限游戏内部涉及
-record(g17_guild,          {guild_id      = 0,
                             version       = g17_guild_version:current_version(),
                             guild_name    = "",
                             guild_logo    = "",
                             owner_user_id = "",
                             status        = 0         %% 内存字段，申请状态
                            }).

%% 新浪公会成员信息|仅限游戏内部涉及成员
-record(g17_guild_member,   {user_id   = "",   %% 帐号id
                             version = g17_guild_member_version:current_version(),
                             guild_id  = 0,     %% 公会id 
                             title_id  = 0,     %% 称号id
                             number_id = 0,     %% 公会第N号人物
                             live_ness = 0      %% 活跃度
                            }).

-record(g17_guild_apply,    {key            = undefined,                             
                             version        = g17_guild_apply_version:current_version(),
                             guild_id       = 0,
                             user_id        = "",
                             apply_guild_id = 0,
                             status         = 0,        %% 0, 等待审核 1, 申请通过, 2申请拒绝
                             delete_time    = 0         %% 过期时间
                            }).

-define(G17_TITLE_BOSS,   1).
-define(G17_TITLE_COMMON, 0).

-define(G17_APPLY_STATUS_NONE,    0).
-define(G17_APPLY_STATUS_WAIT,    1).
-define(G17_APPLY_STATUS_PASS,    2).
-define(G17_APPLY_STATUS_REJECT,  3).


-endif.
