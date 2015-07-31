-ifndef(DEFINE_CT_ROBOT_HRL).
-define(DEFINE_CT_ROBOT_HRL, true).

-record(account_info,{
          accid,
          accname,
          password,
          register_name,
          sn = 1,
          ip,
          port
         }).

-record(ct_robot, {
          account = #account_info{},   % 登陆前需要的数据
          player_id = 0,
          session = 123456789,
          socket,
          pid,
          user = #pbuser{},            % 收到的玩家数据 
          task = #pbtasklist{},
          goods_list = [],
          mail       = [],
          dungeon_info = #pbdungeon{},
          friendslist = [],
          skill_list = [],
          boss_list = [],
          entry_boss_id,
          cur_boss,
          dungeon_list = [],
          pbfriendlist = #pbfriendlist{},
          team = #pbteam{},
          sterious_shop = #pbsteriousshop{},
          selling_shop_list = #pbsellinglist{}
         }).

-define(ROBOT_ACCOUNT, #ct_robot.account).
-define(ROBOT_LAST_DUNGEON, #ct_robot.user#pbuser.last_dungeon).
-define(ROBOT_ACCID, ?ROBOT_ACCOUNT#account_info.accid).
-define(ROBOT_ACCNAME, ?ROBOT_ACCOUNT#account_info.accname).
-define(ROBOT_PASSWORD, ?ROBOT_ACCOUNT#account_info.password).
-define(ROBOT_LV, #ct_robot.user#pbuser.lv).
-define(ROBOT_ID, #ct_robot.player_id).
-define(ROBOT_VIGOR, #ct_robot.user#pbuser.vigor).
-define(ROBOT_GOLD, #ct_robot.user#pbuser.gold).
-define(ROBOT_COIN, #ct_robot.user#pbuser.coin).

-define(CT_MATCHES(Guard, Expr),
        ((fun () ->
                  case (Expr) of
                      Guard -> 
                          ok;
                      __V -> 
                          {not_match, {??Guard, __V}}
                  end
          end)())).
-endif.
