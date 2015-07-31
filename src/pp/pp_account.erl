%%%--------------------------------------
%%% @Module  : pp_account
%%% @Created : 2010.10.05
%%% @Description:用户账户管理
%%%--------------------------------------
-module(pp_account).
-export([handle/3]).

-include("define_logger.hrl").
-include("fcm.hrl").
-include("pb_10_pb.hrl").
-include("define_info_10.hrl").
-include("define_login.hrl").
-include("define_server.hrl").
-include("define_player.hrl").
-include("define_goods.hrl").
-include("db_base_function_open.hrl").
-include("define_log.hrl").
-include("db_log_player_mini.hrl").

-define(RELOGIN_PROTECT_TIME,     5).  %% 重登录保护间隔
%% 登录验证的回调 #pbaccount
%% handle(10000, #client{} = Client, OData) 
%%   when is_record(OData, pbaccount) ->
%%     case check_account_pass(OData) of
%%         {fail, Reason} ->
%%             {fail, Client, Reason};
%%         {true, Data} ->
%%             RoleInfo = 
%%                 mod_player:get_role_by_accid(Data#pbaccount.suid),
%%             case may_start_mod_player(Data, Client, RoleInfo) of
%%                 {ok, Client1, NewRole} ->
%%                     ?DEBUG("Client1 ~p~n", [Client1]),
%%                     {ok, BinData} = 
%%                         pt:pack(10000, 
%%                                 #pbaccountlogin{
%%                                    result = ?LOGIN_SUCCESS,
%%                                    acc_id = get_accid(Data#pbaccount.suid),
%%                                    session = Client1#client.session,
%%                                    user_info = to_pbuserlogininfo(NewRole)
%%                                   }),
%%                     packet_misc:put_packet(BinData),
%%                     {ok, Client1};
%%                 {fail, Reason} ->
%%                     {fail, Client, Reason};
%%                 {fail, NClient, Reason} ->
%%                     {fail, NClient, Reason}
%%             end
%%     end;
%%单单是登陆成功，没有去开玩家进程
handle(10000, Client, OData)
  when is_record(OData, pbaccount) ->
    ?DEBUG("10000 OData ~p~n", [OData]),
    case check_account_pass(OData) of
        {fail, Reason} ->
            {fail, Reason};
        {true, Data} ->
            NewClient = login_success_client(Data, Client),
            RoleInfo = 
                mod_player:get_role_by_accid(Data#pbaccount.suid),
            ?DEBUG("RoleInfo: ~p", [RoleInfo]),
            NewRoleInfo = [Player || Player <- RoleInfo, Player#player.sn =:= Data#pbaccount.server_id],
            {ok, BinData} = 
                pt:pack(10000, 
                        #pbaccountlogin{
                           result = ?LOGIN_SUCCESS,
                           acc_id = get_accid(Data#pbaccount.suid),
                           session = NewClient#client.session,
                           user_info = to_pbuserlogininfo(NewRoleInfo)
                          }),
            packet_misc:put_packet(BinData),
            {ok, NewClient#client{player_list = NewRoleInfo}}
    end;

%%角色登陆(貌似发空包就可以了，玩家id在前面带上)
handle(10001, #client{player_list = PlayerList} = Client, PlayerId) ->
    case lists:keytake(PlayerId, #player.id, PlayerList) of
        false ->
            {fail, ?INFO_LOGIN_ROLE_NOT_EXIST};
        {value, Player, _} ->
            may_start_mod_player(Client, Player)
    end;

%% 创建角色
handle(10003, #client{player_list = PlayerList} = Client,
       #pbuserlogininfo{nickname = OriginNickname} = Data)
  when is_record(Data, pbuserlogininfo) ->
    AllRoleInfos = PlayerList,
    RoleCount = length(AllRoleInfos),
    if
        RoleCount >= ?MAX_ROLE_NUM ->
            {fail, ?INFO_LOGIN_ROLE_NUM_LIMIT};
        true ->
            case inner_check_nickname(OriginNickname) of
                {fail, Reason} ->
                    {fail, Reason};
                {ok, NickNameBin} ->
                    DataNew = Data#pbuserlogininfo{
                                acc_id = Client#client.accid,
                                acc_name = hmisc:to_utf8_string(Client#client.accname),
                                %% 需要首先将角色名转成
                                nickname = NickNameBin
                               },
                    case create_role(DataNew) of
                        false ->
                            {fail, ?INFO_LOGIN_CREATE_ROLE_FAILED};
                        {ok, Player} ->
                            [PbUserLoginInfo] = to_pbuserlogininfo([Player]),
                            %% 创建角色成功
                            {ok, BinData} = pt:pack(10003, PbUserLoginInfo),
                            packet_misc:put_packet(BinData),
                            CreateLog = #log_player{
                                           event_id = ?LOG_EVENT_CREATE_ROLE,
                                           arg1 = Client#client.accid
                                          },
                            mod_base_log:log(log_player_p, CreateLog#log_player{
                                                             player_id = Player#player.id
                                                            }),
                            {ok, Client#client{player_list = [Player|PlayerList]}}
                    end
            end
    end;

handle(10004, Client, _) ->
    case mod_login:login(Client) of
        {ok, NewClient} ->
            {ok, NewClient};
        {error, Reason} ->
            %%告诉玩家登陆失败
            ?WARNING_MSG("login_fail ~p, ~p~n", [Client, Reason]),	
	    {error, Client}
    end;
handle(10100, Client, #pbrc4{p = P,  %% P是一个大素数
                             g = G,  %% G是素数的原根
                             pub = CPubilc %% CPub = G^CPri mod P 
                            }) ->
    {PubServer, PrivServer} = crypto:generate_key(dh, [P, G]),
    %% 通过 g p B a 生成 s
    S = crypto:compute_key(dh, CPubilc, PrivServer, [P, G]), %% CPub^SPri mod p =:= SPub^CPri mod p = S
    ?DEBUG("RC4 S: ~p~n",[bin_to_hex:bin_to_hex(S)]),
    %% %% 初始化 rc4 状态
    RC4 = crypto:stream_init(rc4, S),
    {ok, Binary} = pt_10:write(10100, PubServer),
    packet_misc:put_packet(Binary),
    {rc4, RC4Bin} = RC4,
    ?DEBUG("RC4 : ~p~n",[bin_to_hex:bin_to_hex(RC4Bin)]),
    put(rc4_key, RC4),
    {ok, Client#client{p = P,
                       g = G,
                       rc_s = S,
                       rc_priv = PrivServer,
                       rc_pub  = PubServer,
                       c_rc_pub = CPubilc,
                       rc4 = RC4
                      }};
%% 绑定账号
%% handle(10006, #client{
%%                  socket = Socket
%%                 } = Client, Data) ->
%%     case check_account_pass(Data) of
%%         true ->
%%             Result = lib_account:db_bind_account(Client#client.accid, Client#client.accname),
%%             if
%%                 is_integer(Result) andalso Result > 0 ->
%%                     %% 更新成功，通知客户端
%%                     {ok, BinData} = pt:pack(10006, #pbuserresult{result = 1}),
%%                     gen_tcp:send(Socket, BinData);
%%                 true -> 
%%                     ok
%%             end;
%%         false ->
%%             ok
%%     end;

%% 按照accid创建一个角色，或自动分配一个角色
%% handle(10010, _Client, Data)
%%   when is_record(Data, pbaccount) ->
%%     ?DEBUG("Try to Create a Role.~n",[]),
%%     %%不用 Data#pbaccount.server_id By Roowe At Mon Sep  9 18:57:40 2013
%%     get_player_id(config:get_one_server_no(),
%%                   Data#pbaccount.acc_id);

%% %% 创建角色后进入游戏类型
%% handle(10022, _Socket, _Client, Info) ->
%%      {_Client, Type} = Info,
%%      Sn = config:get_server_no(),
%%      lib_account:enter_game_type(Sn, Type);

%% 不匹配的协议
handle(_Cmd,  _, _Data) ->
    ?WARNING_MSG("pp_handle no match, /Cmd/Data/ = /~p/~p/~n", [_Cmd, _Data]),
    {error, "pp_handle no match"}.

inner_check_nickname(OriginNickname) ->
    NameLen = length(OriginNickname),
    NickNameBin = unicode:characters_to_binary(OriginNickname),
    if
        NameLen > 8 orelse NameLen < 2 ->
            {fail, ?INFO_LOGIN_INVALID_LENGTH};
        true ->
            case sensitive_word_misc:is_sensitive_word(NickNameBin) of
                true ->
                    {fail, ?INFO_LOGIN_BAN_WORDS};
                false ->
                    NickNameBin = unicode:characters_to_binary(OriginNickname),
                    {ok, NickNameBin};
                _ ->
                    {fail, ?INFO_LOGIN_SERVER_ERROR_ID}
            end
    end.

may_start_mod_player(Client, Player) ->
    case check_player_stat(Player) of
        ok ->
            case mod_login:login(Client#client{
                                   player_id = Player#player.id
                                  }) of
                {ok, NewClient} ->
                    {ok, NewClient};
                {fail, Reason} ->
                    %%告诉玩家登陆失败
                    ?WARNING_MSG("login_fail ~p, ~p~n", [Client, Reason]),
                    {fail, Reason}
            end;
        Reason ->
            {fail, Reason}
    end.

login_success_client(Data, Client) ->
    Client#client{
      sn = Data#pbaccount.server_id,
      login = ?LOGIN_SUCCESS,
      accid =  Data#pbaccount.suid,
      accname = Data#pbaccount.acc_name,
      session = hmisc:new_session(),
      session_timestamp = time_misc:unixtime()
     }.

check_player_stat(#player{
                     unlock_role_timestamp = UnLockTimestamp,
                     status = ?PLAYER_STATUS_BANNED
                    }) ->
    NowTime = time_misc:unixtime(),
    if 
        NowTime >= UnLockTimestamp ->
            ok;
        true ->
            ?INFO_SERVER_KICK_OUT
    end;
check_player_stat(_) ->
    ok.


get_accid(ServerAccId) ->    
    %% 客户端数据未必合法
    case catch lists:last(string:tokens(ServerAccId, "_")) of
        AccId when is_list(AccId) ->
            AccId;
        _ ->
            undefined
    end.

check_account_pass(Data) ->
    case app_misc:get_env(server_state) of
        debug ->
            {fail, ?INFO_LOGIN_SERVER_ON_UPDATE};
        _ ->
            case catch server_misc:get_mnesia_sn(Data#pbaccount.server_id) of
                MnesiaSn when is_integer(MnesiaSn) ->                    
                    Now = time_misc:unixtime(),
                    case Now > time_misc:get_server_start_time() of
                        true ->
                            case app_misc:get_env(strict_md5) of
                                0 ->
                                    ?WARNING_MSG("strict_md5 is not open ~n", []),
                                    {true, Data};
                                _ ->
                                    check_account_pass2(Data)
                            end;
                        _ ->
                            {fail, ?INFO_LOGIN_NOT_SERVER_TIME}
                    end;
               _ ->
                    {fail, ?INFO_LOGIN_SERVER_ERROR_ID}
            end
    end.

%% 通行证验证
check_account_pass2(#pbaccount{
                      suid = Accid,
                      platform = Platform} = Data) ->
    ?DEBUG("Platform ~ts~n", [Platform]),
    case Platform of
        "pp" ->
            ?DEBUG("pp coming~n", []),
            case platform_check:check_pp_account_pass(Data) of
                false ->
                    {fail, ?INFO_LOGIN_ACCID_FAIL};
                {AccName, _Uid} ->
                    NewUid = "pp_" ++ hmisc:to_list(Accid),
                    {true, Data#pbaccount{suid = NewUid, acc_name = AccName}}
            end;
        "g17" ->
            ?DEBUG("g17 coming",[]),
            case platform_check:check_g17_account_pass(Data) of
                false ->
                    {fail, ?INFO_LOGIN_ACCID_FAIL};
                {ok, UserId, G17GuildId, G17GuildTitle, G17NumberId} ->
                    mod_g17_srv:update_g17_user_info(UserId, G17GuildId, G17GuildTitle, G17NumberId),
                    {true, Data#pbaccount{suid = UserId, acc_id = UserId}}
            end;
        "weibo" ->
            case platform_check:check_sina_account_pass(Data) of
                false ->
                    {fail, ?INFO_LOGIN_ACCID_FAIL};
                {ok, UserId, Token} ->
                    {true, Data#pbaccount{suid = UserId, 
                                          acc_id = UserId, 
                                          login_ticket = Token}}
            end;
        _ ->
            %% 默认采用4399的登录流程
            ?DEBUG("4399 coming~n", []),
            case check_4399_account_pass(Data) of
                false ->
                    {fail, ?INFO_LOGIN_ACCID_FAIL};
                true ->
                    Uid = hmisc:to_list(Accid),
                    {true, Data#pbaccount{acc_id = Uid,
                                          suid = Uid}}
            end
    end.

check_4399_account_pass(Data)
  when is_record(Data, pbaccount) ->
    case app_misc:get_env(strict_md5) of
        1 ->
            SSuid = case Data#pbaccount.suid of
                        undefined ->
                            "";
                        Suid ->
                            Suid
                    end,
            Md5 = SSuid ++ "&" ++
                integer_to_list(Data#pbaccount.timestamp) ++ "&" ++
                app_misc:get_env(ticket, []),
            Hex = hmisc:md5(Md5),
            ?DEBUG("suid: ~ts~ntimestamp: ~ts~nsign: ~ts~n",
                   [SSuid, 
                    integer_to_list(Data#pbaccount.timestamp),
                    Data#pbaccount.login_ticket]),
            ?DEBUG("Login pass verify: ~nmd5 ~ts~ncmd5 ~ts~n",
                   [Hex, Data#pbaccount.login_ticket]),
            Hex =:= Data#pbaccount.login_ticket;
        _ ->
            true
    end.

%% %% 角色名合法性检测
%% validate_name(PlayerInfo) 
%%   when is_record(PlayerInfo, pbuserlogininfo) ->
%%     validate_name(len, PlayerInfo);
%% validate_name(Data) ->
%%     ?DEBUG("~w is not record of pbuserlogininfo.~n", [Data]),
%%     {false, 0}.

%% %% 角色名合法性检测:长度
%% validate_name(len, PlayerInfo) ->
%%     %% 传过来的角色名可能会是undefined，因此需要进行处理
%%     UserName = 
%%         case PlayerInfo#pbuserlogininfo.nickname of
%%             undefined ->
%%                 "";
%%             Name ->
%%                 Name
%%         end,
%%     case asn1rt:utf8_binary_to_list(list_to_binary(UserName)) of
%%         {ok, CharList} ->
%%             case name_ver(CharList) of
%%                 true ->
%%                     validate_name(existed, PlayerInfo);
%%                 _ ->
%%                     {false, 4}
%%             end;
%%         {error, _Reason} ->
%%             %% 非法字符
%%             {false, 4}
%%     end; 

%% %%判断角色名是否已经存在
%% %%Name:角色名
%% validate_name(existed, PlayerInfo) ->
%%     %% case lib_player:is_exists_global_name(
%%     %%        PlayerInfo#pbuserlogininfo.server_id,
%%     %%        PlayerInfo#pbuserlogininfo.acc_id,
%%     %%        PlayerInfo#pbuserlogininfo.nickname) of
%%     %%     true -> 
%%     %%         %% 角色名称已经被使用
%%     %%         {false, 3};    
%%     %%     false ->
%%     %%         validate_name(sen_words, PlayerInfo#pbuserlogininfo.nickname)
%%     %% end;
%%     validate_name(sen_words, PlayerInfo#pbuserlogininfo.nickname);
%% %% @doc 是否包含敏感词
%% %% Name:角色名
%% validate_name(sen_words, Name) ->
%%     case lib_words_ver:words_ver_name(Name) of
%%         true ->
%% 	    true;  
%%         false ->
%%             %% 包含敏感词
%%             {false, 8} 
%%     end;

%% validate_name(_, _Name) ->
%%     {false, 2}.

%% 字符宽度，1汉字=2单位长度，1数字字母=1单位长度
%% string_width(String) ->
%%     string_width(String, 0).
%% string_width([], Len) ->
%%     Len;
%% string_width([H | T], Len) ->
%%     case H > 255 of
%%         true ->
%%             string_width(T, Len + 2);
%%         false ->
%%             string_width(T, Len + 1)
%%     end.

%% name_ver(Names_for) ->
%%     Sumxx = 
%%         lists:foldl(fun(Name_Char, Sum) ->
%%                             if
%%                                 Name_Char =:= 8226 orelse 
%%                                 Name_Char < 48 orelse 
%%                                 (Name_Char > 57 andalso Name_Char < 65) orelse 
%%                                 (Name_Char > 90 andalso Name_Char < 95) orelse
%%                                 (Name_Char > 122 andalso Name_Char < 130) ->
%%                                     Sum + 1;
%%                                 true -> Sum + 0
%%                             end
%%                     end,
%%                     0, 
%%                     Names_for),
%%     if 
%% 	Sumxx =:= 0 ->
%% 	    true;
%% 	true ->
%% 	    false
%%     end.

%% @doc 创建角色
create_role(PlayerInfo)
  when is_record(PlayerInfo, pbuserlogininfo) ->
    ?DEBUG("Creating Role PlayerInfo = ~p~n", [PlayerInfo]),
    CareerID = 
        case PlayerInfo#pbuserlogininfo.career of
            ?MAI ->
                ?MAI;
            _ -> 
                %% 客户端传入的参数有误，使用默认的职业
                ?YAGAMI
        end,
    %% 性别修正
    Sex = case PlayerInfo#pbuserlogininfo.sex of
              ?MALE ->
                  %% 男性
                  ?MALE;
              ?FEMALE ->
                  %% 女性
                  ?FEMALE;
              _ ->
                  %% 其他职业均需要转换成女性
                  ?FEMALE
          end,
    NPlayerInfo = PlayerInfo#pbuserlogininfo{
                    career = CareerID,
                    sex = Sex},                   
    Lv = 1,
    ActiveSills = case data_base_function_open:get(0, CareerID, 1) of
                      #base_function_open{
                         open = {InitActiveSills, PassiveSkill}
                        } ->
                          InitActiveSills ++ PassiveSkill;   %%服务器其实不管主被动技能了
                      _ ->
                          []
                  end,
    %% BagLimit = case data_base_params:get_value_by_name(init_bag_limit) of
    %%                [] ->
    %%                    %% 默认值为40
    %%                    40;
    %%                Value ->
    %%                    Value
    %%            end,
    BagLimit = 400,
    NewId = lib_counter:update_counter(player_uid, 1),
    PlayerSkills = 
        lists:map(fun(SkillId) ->
                          lib_player:to_player_skill(NewId, SkillId)
                  end, ActiveSills),
    lists:foreach(fun(Skill) ->
                          hdb:dirty_write(player_skill, Skill)
                  end, PlayerSkills),
    ?DEBUG("PlayerSkills: ~p", [PlayerSkills]),
    Player = #player{
                id       = NewId,
                accid    = NPlayerInfo#pbuserlogininfo.acc_id,
                accname  = NPlayerInfo#pbuserlogininfo.acc_name,
                nickname = NPlayerInfo#pbuserlogininfo.nickname,
                lv       = Lv,
                sn       = NPlayerInfo#pbuserlogininfo.server_id,
                coin     = 0,
                gold     = 100,
                bag_cnt  = 0,    %%物品的具体格子post_role_created这里决定
                bag_limit= BagLimit,
                career   = CareerID,
                %normal_skill_ids = ActiveSills,
                vigor    = lib_player:get_max_vigor(Lv),
                friends_limit = lib_player:get_base_player_val(Lv, #ets_base_player.friends),
                create_timestamp = time_misc:unixtime()
               },    
    NewPlayer = post_role_created(Player),
    case hdb:dirty_write(NewPlayer) of
        ok ->
            %% write successful
            %% ?DEBUG("AccId ~p player_id ~p~n",[NewPlayer#player.accid, NewPlayer#player.id]),
            mod_base_log:log(log_player_mini_p, #log_player_mini{
                                                   acc_id    = unicode:characters_to_binary(NewPlayer#player.accid),
                                                   player_id = NewPlayer#player.id,
                                                   acc_name  = unicode:characters_to_binary(NewPlayer#player.accname),
                                                   nick_name = unicode:characters_to_binary(NewPlayer#player.nickname)
                                                  }),

            {ok, Player};
        Other ->
            ?WARNING_MSG("dirty_write(NewPlayer) ~p ~p~n", [NewPlayer, Other]),
            false
    end.

%% 角色创建成功后的回调函数，用于处理角色创建之后的处理逻辑
post_role_created(IPlayer) ->
    %% 增加默认斗魂
    Player = lib_player:reset_by_lv(IPlayer),
    ?DEBUG("Player: ~p", [Player]),
    lib_task:create_role_add_main(Player),
    lib_dungeon:create_role(Player#player.id),
    lib_goods:create_role(Player).

to_pbuserlogininfo(RoleInfoList) ->
    lists:map(
      fun(RoleInfo) ->
              #pbuserlogininfo{user_id  = hmisc:to_integer(RoleInfo#player.id),
                               nickname = RoleInfo#player.nickname,
                               career   = RoleInfo#player.career,
                               level    = RoleInfo#player.lv,
                               list     = lists:map(fun(Info) -> 
                                                            to_pbuserloginfashioninfo(Info) 
                                                    end, lib_goods:get_player_fashion_info(RoleInfo#player.id))
                              }
      end, RoleInfoList).

to_pbuserloginfashioninfo({BaseId, SubType}) ->
    #pbuserloginfashioninfo{
       fashion_base_id = BaseId,
       sub_type = SubType
      }.

%% 处理老代码，不建议这样做
%% hash_create_role_error_code(Code) ->
%%     case Code of
%%         0 ->
%%             %% 创建角色失败
%%             ?INFO_LOGIN_CREATE_ROLE_FAILED;
%%         2 ->
%%             %% 位置错误，创建角色失败
%%             ?INFO_LOGIN_CREATE_ROLE_FAILED;
%%         3 ->
%%             %% 重复的角色名，无法创建角色
%%             ?INFO_LOGIN_USED_NAME;
%%         4 ->
%%             %% 角色名非法，无法创建角色
%%             ?INFO_LOGIN_INVALID_NAME;
%%         5 ->
%%             %% 角色名长度非法，无法创建角色
%%             ?INFO_LOGIN_INVALID_LENGTH;
%%         6 ->
%%             %% 已经创建过角色了，无法创建角色
%%             ?INFO_LOGIN_ROLE_EXIST;
%%         7 ->
%%             %% 该账号已经创建过3个角色了，无法创建角色
%%             ?INFO_LOGIN_ROLE_MAX;
%%         8 ->
%%             %% 角色名中包含屏蔽字符，无法创建角色
%%             ?INFO_LOGIN_BAN_WORDS
%%     end.


