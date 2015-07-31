%%%------------------------------------
%%% @Module  : mod_kernel
%%% @Created : 2010.10.05
%%% @Description: 核心服务
%%%------------------------------------
-module(mod_kernel).
-behaviour(gen_server).
-export([
         start_link/0,
         init_base_data/1,
         load_base_data/1,
         init_ets/0
        ]).
-export([
         init/1,
         handle_call/3,
         handle_cast/2,
         handle_info/2,
         terminate/2,
         code_change/3
        ]).
-include("common.hrl").
-include("define_push.hrl").

-define(AUTO_RELOAD_BASE, 3*60*1000).  %%每3分钟加载一次数据(正式上线后，去掉)

start_link() ->
    gen_server:start_link({local,?MODULE}, ?MODULE, [], []).

%% --------------------------------------------------------------------
%% Function: init/1
%% Description: Initiates the server
%% Returns: {ok, State}          |
%%          {ok, State, Timeout} |
%%          ignore               |
%%          {stop, Reason}
%% --------------------------------------------------------------------
init([]) ->
    misc:write_monitor_pid(self(),?MODULE, {0}),

    %%初始ets表
    ok = init_ets(),
    io:format("                Init ets ok!~n", []),        
    %%加载基础数据 
    ok = init_base_data(0),    

    %% 启动重复加载数据(正式上线后，去掉)
    %%      erlang:send_after(?AUTO_RELOAD_BASE, self(), {event, reload_data}),  %% 重复加载一次数据
    {ok, 1}.

%% --------------------------------------------------------------------
%% Function: handle_call/3
%% Description: Handling call messages
%% Returns: {reply, Reply, State}          |
%%          {reply, Reply, State, Timeout} |
%%          {noreply, State}               |
%%          {noreply, State, Timeout}      |
%%          {stop, Reason, Reply, State}   | (terminate/2 is called)
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------

handle_call({create_ets_table, PlayerGoodsEts, PlayerPractiseEts},_FROM, Status) ->
                                                %       ?DEBUG("~n Create Player Ets Table ~p ~p~n",[PlayerGoodsEts, PlayerPractiseEts]),
    case ets:info(PlayerGoodsEts) of
        undefined ->
            ets:new(PlayerGoodsEts,[{keypos,#goods.id},named_table, public, set]),
            ets:new(PlayerPractiseEts,[{keypos,#ets_equip_practise_attribute.id},named_table, public, set]);
        _ ->
                                                %                       ?DEBUG("~n Exist Ets Table ~p ~n",[PlayerGoodsEts]),
            skip
    end,
    {reply, {PlayerGoodsEts, PlayerPractiseEts}, Status};

handle_call(_R , _FROM, Status) ->
    {reply, ok, Status}.

%% --------------------------------------------------------------------
%% Function: handle_cast/2
%% Description: Handling cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
handle_cast({delete_ets_table, PlayerGoodsEts, PlayerPractiseEts}, Status) ->
    %% ?DEBUG("~n Delete Player Ets Table ~p ~p~n",[PlayerGoodsEts, PlayerPractiseEts]),
    case ets:info(PlayerGoodsEts) of
        undefined ->
            skip;
        _ ->
            ets:delete(PlayerGoodsEts)
    end,
    case ets:info(PlayerPractiseEts) of
        undefined ->
            skip;
        _ ->
            ets:delete(PlayerPractiseEts)
    end,
    {noreply, Status};

handle_cast(_R , Status) ->
    {noreply, Status}.

%% --------------------------------------------------------------------
%% Function: handle_info/2
%% Description: Handling all non call/cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
handle_info({event, reload_data}, Status) ->
    %% 加载基础数据
    init_base_data(1),
    erlang:send_after(?AUTO_RELOAD_BASE, self(), {event, reload_data}),  %% 重复加载一次数据
    {noreply, Status};

handle_info(_Reason, Status) ->
    {noreply, Status}.

%% --------------------------------------------------------------------
%% Function: terminate/2
%% Description: Shutdown the server
%% Returns: any (ignored by gen_server)
%% --------------------------------------------------------------------
terminate(normal, Status) ->
    misc:delete_monitor_pid(self()),
    {ok, Status}.

%% --------------------------------------------------------------------
%% Func: code_change/3
%% Purpose: Convert process state when code is changed
%% Returns: {ok, NewState}
%% --------------------------------------------------------------------
code_change(_OldVsn, Status, _Extra)->
    {ok, Status}.

%% ================== 私有函数 =================
%% 加载基础数据
init_base_data(_Parm) ->
    %% load_base_data(goods),
    load_base_data(protocol),
    %% load_base_data(pet),
    load_base_data(beast),
    load_base_data(scene),
    load_base_data(career),
    load_base_data(player),
    load_base_data(combat),
    %% load_base_data(camp),
    %% load_base_data(five_elements),
    load_base_data(task),
    %% load_base_data(meridian),
    %% load_base_data(meridian_cd),
    %% load_base_data(target),
    %% load_base_data(business),
    %% load_base_data(privity),
    %% load_base_data(herocard),
    load_base_data(base_rank),
    load_base_data(base_tavern),
    load_base_data(partner),
    load_base_data(goods),
    load_base_data(buff),
    load_base_data(online_gift),
    load_base_data(train_room),
    load_base_data(arena),
    %% load_base_data(bless),
    load_base_data(treasure),
    load_base_data(boss),
    load_base_data(guild),
    load_base_data(base_activity),
    load_base_data(artifact),
    load_base_data(fight_soul),
    load_base_data(star_power),
    load_base_data(fight_report),
    load_base_data(kilo_ride),
    load_base_data(trial),
    load_base_data(warcraft),
    load_base_data(sys_acm),
    load_base_data(reward),
    load_base_data(ver_words),
    load_base_data(white_ip),
    load_base_data(achieve),
    load_base_data(southern),
    load_base_data(base_lv),
    load_base_data(base_eight_fight_rank_reward),
    load_base_data(base_app_store_product),
    load_base_data(base_activity_rate),
    load_base_data(base_forage),
    load_base_data(activation_code),
    load_base_data(base_ups_reward),
    load_base_data(base_troop),
    ok.


%% 输出信息
output_msg(Msg) ->
    ?WARNING_MSG("                load_base_data(~w) ok!~n", [Msg]).

%% 初始化协议信息
load_base_data(protocol) ->
    lib_protocol:load_all(),
    output_msg(protocol),
    ok;
%%初始化装备相关基础表
load_base_data(goods) ->
    goods_tools:init_goods(),
    output_msg(goods),
    ok;
load_base_data(pet) ->
    %%初始化基础宠物信息
    %% lib_pet:load_base_pet(),
    %% %%初始化基础宠物技能
    %% lib_pet:load_base_pet_skill(),
    %% %%初始化基础宠物性格技能
    %% lib_pet:load_base_pet_character_skill(),
    %% %%初始化基础宠物被动技能
    %% lib_pet:load_base_pet_passive_skill(),
    %% %%初始化宠物采集信息
    %% lib_pet:load_base_pet_collect(),
    %% %%初始化宠物喂食信息
    %% lib_pet:load_base_pet_feed(),
    %% %%初始化宠物性格配置
    %% lib_pet:load_base_pet_character(),
    %% %%初始化宠物经验
    %% lib_pet:load_base_pet_exp(),
    %% %%初始化宠物训练花费
    %% lib_pet:load_base_pet_train_cost(),
    ok; 
load_base_data(beast) ->
    lib_beast:load_beast_system_conf(),
    output_msg(beast),
    ok;
load_base_data(scene) ->
    %%初始化基础Npc
    lib_npc:init_base_npc(),
    %%初始化基础mon
    lib_mon:init_base_mon(),        
    %%初始化基础场景信息(包括场景Npc和场景怪物)
    lib_scene:init_base_scene(),
    %%初始化副本信息
    lib_scene:init_base_dungeon(),  
    %%初始化国家场景分类信息
    lib_npc:init_base_scene_class(),
    output_msg(scene),
    ok;
load_base_data(career) ->
    %%初始化基础职业属性
    lib_player:init_base_career(),  
    output_msg(career),
    ok;

load_base_data(player) ->
    %%初始化基础职业属性
    lib_player:init_base_player(),  
    lib_vip:init_base_vip(),
    output_msg(player),
    ok;

load_base_data(combat) ->
    %%初始化基础技能
    %% lib_skill:init_base_skill(),

    %%初始化新的技能配置信息
    lib_combat_skill:init_combat_skill(),
    lib_combat_skill:init_combat_skill_passive(),
    lib_combat_buff:init_base_combat_buff(),
    %% ?DEBUG("combat_skill reloaded~n",[]),
    output_msg(combat),
    ok;

%% load_base_data(camp) ->
%%     %%初始化基础阵法
%%     lib_camp:init_base_camp(),
%%      ok;

%% load_base_data(five_elements) ->
%%     %%初始化五行属性
%%     lib_camp:init_base_five_elements(),
%%      ok;

load_base_data(task) ->
    %%初始化基础任务
    lib_task:init_base_task(),      
    %%初始化基础对话
    lib_npc:init_base_talk(),
    output_msg(task),
    ok;
load_base_data(meridian) ->
    %%初始化经脉基础数据
    %% lib_meridian:init_base_meridian(),
    %% output_msg(meridian),
    ok;
load_base_data(meridian_cd) ->
    %% lib_meridian:init_base_meridian_cd(),
    %% output_msg(meridian_cd),
    ok;
load_base_data(target)->
    %% 初始化目标奖励
    lib_target_gift:init_base_target_gift(),
    output_msg(target),
    ok;
load_base_data(business)->
    %% 初始化跑商
    lib_business:init_base_business(),
    output_msg(business),
    ok;
load_base_data(privity)->
    %% 初始化默契度测试题目
    lib_love:init_base_privity(),
    output_msg(privity),
    ok;
load_base_data(herocard)->
    %% 初始化封神贴奖励
    lib_hero_card:init_base_award(),
    output_msg(herocard),
    ok;
load_base_data(buff)->
    %% 初始化基础buff
    lib_player_buff:load_base_buff(),
    output_msg(buff),
    ok;
load_base_data(online_gift) ->
    %% 在线奖励
    lib_online_gift:load_base_online_gift(),
    output_msg(online_gift),
    ok;

load_base_data(arena)->
    %%初始化竞技场
    lib_arena_new:init_base_arena_member(),
    lib_arena_new:init_base_arena_monster(),
    lib_arena_new:init_base_arena_reward(),
    lib_arena_new:init_base_arena_winning_reward(),
    output_msg(arena),
    ok;
load_base_data(bless)->
    %%初始化祝福基础配置
    lib_relationship:load_base_bless(),
    output_msg(bless),
    ok;
load_base_data(treasure)->
    %%初始化宝物系统基础数据
    lib_treasure:init_base_treasure(),
    lib_treasure:init_base_treasure_explore(),
    output_msg(treasure),
    ok;

load_base_data(train_room) ->
    %% 初始化基础训练师数据
    lib_train_room:load_base_trainer(),
    output_msg(train_room),
    ok;
load_base_data(guild)->
    %%加载帮派术法基础数据
    %% lib_guild:init_base_guild_magic(),
    ok = lib_guild:init_base_guild_skill(),
    ok = lib_guild:init_base_guild(),
    ok = lib_guild:init_base_guild_position(),
    %% ok = lib_guild:init_base_guild_donate(),
    ok;
load_base_data(boss) ->
    %%初始化boss数据
    lib_boss:load_base_boss(),
    lib_boss:load_base_boss_upgrade(),
    %% util:compile_base_data(base_boss, base_boss, [#base_boss.scene]),
    %% util:compile_base_data(base_boss, base_boss_config, [#base_boss.time_config]),
    %% util:compile_base_data(base_boss_upgrade, base_boss_upgrade, 
    %%                        [#base_boss_upgrade.scene_id, #base_boss_upgrade.lv]),
    output_msg(boss),
    ok;

load_base_data(base_activity) ->
    %%初始化活动配置
    lib_syssetting:init_base_activity(0),
    lib_syssetting:init_base_activity(),
    lib_syssetting:init_base_op_activities(),
    output_msg(base_activity),
    ok;
load_base_data(artifact) ->
    %% 载入法宝相关配置
    ok = lib_artifact:init_base_artifact_info(),
    output_msg(artifact),
    ok;
load_base_data(star_power) ->
    %% 载入法宝相关配置
    ok = lib_star_power:init_base_star_power(),
    output_msg(star_power),
    ok;
load_base_data(fight_report) ->
    %% 载入战报相关数据
    ok = lib_fight_report:load_fight_report(),
    output_msg(fight_report),
    ok;
load_base_data(fight_soul) ->
    %%初始化武魂配置表
    ok = lib_fight_soul:init_base_fight_soul(),
    output_msg(fight_soul),
    ok;
load_base_data(partner) ->
    %% 初始化基础伙伴
    ok = lib_parter:init_base_partner_conf(),
    output_msg(partner),
    ok;
load_base_data(base_tavern) ->
    %% 初始化酒馆数据
    ok = lib_tavern:init_base_tavern_data(),
    output_msg(base_tavern),
    ok;
load_base_data(base_rank) ->
    %% 初始化军衔基础
    ok = lib_base_rank:init_base_rank_data(),
    output_msg(base_rank),
    ok;
load_base_data(kilo_ride) ->
    %% 初始化过关斩将
    ok = lib_kilo_ride:load_kilo_ride_conf(),
    output_msg(kilo_ride),
    ok;
load_base_data(trial) ->
    %% 初始化试炼/小助手系统配置表
    ok = lib_trial:load_base_trial(),
    ok = lib_trial:load_base_trial_reward(),
    output_msg(trial),
    ok;
load_base_data(activity) ->
    %% 活动配置表
    ok = lib_syssetting:init_base_activity(),
    output_msg(activity),
    ok;
load_base_data(warcraft) ->
    %% 群雄争霸表
    ok = lib_warcraft:load_base_warcraft(),
    output_msg(warcraft),
    ok;
load_base_data(sys_acm) ->
    %% 系统公告配置表
    ok = lib_sys_acm:load_base_sys_acm(),
    output_msg(sys_acm),
    ok;
load_base_data(reward) ->
    %% 宝箱奖励
    ok = lib_reward:load_reward_conf(),
    output_msg(reward),
    ok;
load_base_data(ver_words) ->
    %% 敏感词过滤
    ?DEBUG("load data word~n", []),
    lib_words_ver:init_data_words(),
    output_msg(ver_words),
    ok;
load_base_data(white_ip) ->
    %% 加载白名单
    ?DEBUG("load white ip ~n", []),
    data_config:load(),
    output_msg(white_ip),
    ok;
load_base_data(achieve) ->
    %% 加载成就基础数据
    ?DEBUG("load achieve~n", []),
    lib_achieve:load_base_achieve(),
    output_msg(achieve),
    ok;
load_base_data(southern) ->
    %% 加载白名单
    ok = lib_southern_attack:load_base_southern_upgrade(),
    output_msg(white_ip),
    ok;
load_base_data(base_lv) ->   
    lib_guild:load_base_lv(),
    output_msg(base_lv),
    ok;
load_base_data(base_eight_fight_rank_reward) ->
    lib_guild:load_base_eight_fight_rank_reward(),
    output_msg(base_eight_fight_rank_reward),
    ok;
load_base_data(base_app_store_product) ->
    lib_verifying_store_receipts:load_app_store_product(),
    output_msg(base_app_store_product),
    ok;
load_base_data(base_activity_rate) ->
    lib_activity_rate:load_base_activity_rate(),
    output_msg(base_activity_rate),
    ok;
load_base_data(base_forage) ->
    lib_forage:load_base_forage(),
    output_msg(base_forage),
    ok;
%%加载新手礼包激活码
load_base_data(activation_code) ->
    lib_activation_code:load_activation_code(),
    output_msg(activation_code),
    ok;
load_base_data(base_ups_reward) ->
    lib_ups:load_base_ups_reward(),
    output_msg(base_ups_reward),
    ok;
%% 加载兵力系统数据
load_base_data(base_troop) ->
    lib_troop:load_base_troop(),
    output_msg(base_troop),
    ok;
load_base_data(Other) ->
    ?WARNING_MSG("load_base_data: ~w failed~n", [Other]),
    ok.

%%初始ETS表
init_ets() ->
    %% 敏感词表
    ets:new(?ETS_WORDS, [named_table, public, set, {read_concurrency, true}]),
    %% 基础协议信息
    ets:new(?ETS_BASE_PROTOCOL, [{keypos, #ets_base_protocol.id}, named_table, public, set, {read_concurrency, true}]),
    ets:new(?ETS_BASE_MON, [{keypos, #ets_mon.mid}, named_table, public, set, {read_concurrency, true}]),           %%基础_怪物信息
    ets:new(?ETS_BASE_NPC, [{keypos, #ets_npc.nid}, named_table, public, set, {read_concurrency, true}]),               %%基础_NPC信息
    ets:new(?ETS_BASE_ARTIFACT, 
            [{keypos, #ets_base_artifact.id}, named_table, public, set, {read_concurrency, true}]),
    ets:new(?ETS_BASE_SCENE, [{keypos, #ets_scene.id}, named_table, public, set, {read_concurrency, true}]), %%基础_场景信息
    ets:new(?ETS_BASE_SCENE_POSES, [named_table, public, bag]),                                              %%基本_场景坐标表
    ets:new(?ETS_BASE_SCENE_MON, [{keypos, #ets_mon.unique_key}, named_table, public, set, {read_concurrency, true}]), %%基础_场景怪物信息
    ets:new(?ETS_BASE_SCENE_NPC, [{keypos, #ets_npc.unique_key}, named_table, public, set, {read_concurrency, true}]), %%基础_场景NPC信息
    ets:new(?ETS_BASE_DUNGEON, [{keypos, #dungeon.def}, named_table, public, set, {read_concurrency, true}]),  %%基础_副本信息

    ets:new(?ETS_BASE_CAREER, [{keypos, #ets_base_career.career_id}, named_table, public, set, {read_concurrency, true}]), %% 基础职业属性
    ets:new(?ETS_BASE_COMBAT_BUFF,[{keypos,#rec_base_combat_buff.buff_id}, named_table, public, set, {read_concurrency, true}]), %%基础战斗Buff表
    ets:new(?ETS_BASE_PLAYER, [{keypos, #rec_base_player.id}, named_table, public, set, {read_concurrency, true}]), 
    ets:new(?ETS_BASE_GOODS, [{keypos, #ets_base_goods.goods_id}, named_table, public, set, {read_concurrency, true}]),
    %% ets:new(?ETS_BASE_GOODS_ADD_ATTRIBUTE, [{keypos, #ets_base_goods_add_attribute.id}, named_table, public, set]),
    %% ets:new(?ETS_BASE_GOODS_SUIT_ATTRIBUTE, [{keypos, #ets_base_goods_suit_attribute.id}, named_table, public, set]),
    %% ets:new(?ETS_BASE_GOODS_SUIT,[{keypos,#ets_base_goods_suit.suit_id},named_table,public,set]),
    %% ets:new(?ETS_BASE_GOODS_STRENGTHEN, [{keypos, #ets_base_goods_strengthen.id}, named_table, public, set]),
    %% ets:new(?ETS_BASE_GOODS_STRENGTHEN_ANTI,[{keypos,#ets_base_goods_strengthen_anti.id},named_table,public,set]),
    %% ets:new(?ETS_BASE_GOODS_STRENGTHEN_EXTRA,[{keypos,#ets_base_goods_strengthen_extra.level},named_table,public,set]),
    %% ets:new(?ETS_BASE_GOODS_PRACTISE,[{keypos,#ets_base_goods_practise.id},named_table,public,set]),
    %% ets:new(?ETS_BASE_GOODS_COMPOSE, [{keypos, #ets_base_goods_compose.id}, named_table, public, set]),
    %% ets:new(?ETS_BASE_GOODS_INLAY, [{keypos, #ets_base_goods_inlay.id}, named_table, public, set]),
    %% ets:new(?ETS_BASE_GOODS_IDECOMPOSE,[{keypos,#ets_base_goods_idecompose.id},named_table,public,set]),
    %% ets:new(?ETS_BASE_GOODS_ICOMPOSE,[{keypos,#ets_base_goods_icompose.id},named_table,public,set]),
    %% ets:new(?ETS_BASE_GOODS_REFINE, [{keypos,#ets_base_goods_refine.id},named_table,public,set]),

    ets:new(?ETS_BASE_EQUIP_FORGE, [{keypos,#ets_base_equip_forge.id},named_table,public,set, {read_concurrency, true}]),

    %% ets:new(?ETS_BASE_EQUIP_UPGRADE, [{keypos,#ets_base_equip_upgrade.id},named_table,public,set]),


    ets:new(?ETS_BASE_GOODS_DROP_NUM, [{keypos, #ets_base_goods_drop_num.id}, named_table, public, set, {read_concurrency, true}]),
    ets:new(?ETS_BASE_GOODS_DROP_RULE, [{keypos, #ets_base_goods_drop_rule.id}, named_table, public, set, {read_concurrency, true}]),
    %% ets:new(?ETS_BASE_GOODS_ORE,[{keypos,#ets_base_goods_ore.goods_id},named_table,public,set]), 
    %% ets:new(?ETS_BASE_SHOP, [{keypos, #ets_shop.id}, named_table, public, set]),
    ets:new(?ETS_SHOP_GOODS, [{keypos, #ets_shop_goods.id}, named_table, public, set, {read_concurrency, true}]),
    %% ets:new(?ETS_SHOP_PANIC_GOODS, [{keypos, #ets_shop_panic_goods.id}, named_table, public,set]),

    ets:new(?ETS_BASE_TALK, [{keypos, #talk.id}, named_table, public, set, {read_concurrency, true}]),
    ets:new(?ETS_BASE_TASK, [{keypos, #task.id}, named_table, public, set, {read_concurrency, true}]),
    %% ets:new(?ETS_BASE_SKILL, [{keypos, #ets_skill.skill_id}, named_table, public, set]),     

    %% ets:new(?ETS_BASE_CAMP,[{keypos,#ets_camp.camp_id},named_table,public,set]),

    %% ets:new(?ETS_BASE_FIVE_ELEMENTS,[{keypos,#ets_five_elements.id},named_table,public,set]), %%五行信息

    ets:new(?ETS_ONLINE, [{keypos,#player.id}, named_table, public, set]),                      %%本节点在线用户列表
    ets:new(?ETS_OFFLINE,
            [{keypos, #player.id}, named_table, public, set]),                      %%本节点离线用户列表
    ets:new(?ETS_ONLINE_SCENE, [{keypos,#player.id}, named_table, public, set]),    %%本节点加载场景在线用户列表    

    ets:new(?ETS_SCENE, [{keypos, #ets_scene.id}, named_table, public, set]),                   %%本节点场景信息
    ets:new(?ETS_SCENE_MON, [{keypos, #ets_mon.unique_key}, named_table, public, set]), %%本节点怪物信息
    ets:new(?ETS_SCENE_NPC, [{keypos, #ets_npc.unique_key}, named_table, public, set]), %%本节点NPC信息
    ets:new(?ETS_BLACKLIST,[{keypos,#ets_blacklist.id},named_table,public,set]),    %%黑名单操作记录表

    %% ets:new(?ETS_GOODS_ONLINE, [{keypos, #goods.id}, named_table, public, set]),                %% 本节点在线玩家的背包物品表
    %% ets:new(?ETS_GOODS_ATTRIBUTE, [{keypos, #goods_attribute.id}, named_table, public, set]),   %% 本节点在线玩家的物品属性表
    %% ets:new(?ETS_GOODS_DROP, [{keypos, #ets_goods_drop.id}, named_table, public, set]),         %% 物品掉落表
    %% ets:new(?ETS_GOODS_BUFF, [{keypos, #goods_buff.id}, named_table, public ,set]),             %% 物品buff表
    %% ets:new(?ETS_GOODS_CD, [{keypos,#ets_goods_cd.id}, named_table,public ,set]),               %% 物品使用cd表 

    ets:new(?ETS_ROLE_TASK, [{keypos, #role_task.id}, named_table, public, set]),       %% 角色任务记录
    ets:new(?ETS_ROLE_TASK_LOG, [named_table, public, bag]),                            %% 角色任务历史记录
    %% ets:new(?ETS_TASK_QUERY_CACHE, [named_table, public, set]),                      %% 当前所有可接任务
    ets:new(?ETS_TASK_CACHE, [named_table, public, set]),                               %% 玩家任务缓存

    ets:new(?ETS_RELA, [{keypos, #ets_rela.id}, named_table, public, set]),             %% 玩家关系记录
    %% ets:new(?ETS_BASE_BLESS,[{keypos, #ets_base_bless.id}, named_table, public, set]), %%基础祝福配置
    %% ets:new(?ETS_DAILY_BLESS,[{keypos, #ets_daily_bless.player_id}, named_table, public, set]), %%玩家每日的祝福信息

    ets:new(?ETS_DELAYER, [{keypos,#ets_delayer.id}, named_table, public, set]),    %% 玩家延时信息
    ets:new(?ETS_BLACKBOARD, [{keypos,#ets_blackboard.id}, named_table, public, set]),              %% 招募小黑板

    %% 其实不用每个节点都创建这个ets
    %% ets:new(?ETS_TEAM_INFO, [{keypos,#ets_team_info.team_id}, named_table, public, set]),                %% 组队信息的ETS

    %% ets:new(?ETS_BASE_PET_CHARACTER_SKILL, [{keypos,#ets_base_pet_character_skill.id}, named_table, public, set]),   %%宠物性格技能
    %% ets:new(?ETS_BASE_PET_PASSIVE_SKILL, [{keypos,#ets_base_pet_passive_skill.id}, named_table, public, set]),            %%宠物被动技能
    %% ets:new(?ETS_BASE_PET_ACTIVE_SKILL, [{keypos,#ets_base_pet_active_skill.id}, named_table, public, set]),      %%宠物主动技能
    %% ets:new(?ETS_BASE_PET_COLLECT, [{keypos,#ets_base_pet_collect.id}, named_table, public, set]),   %%宠物采集配置
    %% ets:new(?ETS_BASE_PET_FEED_CD, [{keypos,#ets_base_pet_feed_cd.id}, named_table, public, set]),   %%宠物喂食配置
    %% ets:new(?ETS_BASE_PET, [{keypos,#ets_base_pet.goods_id}, named_table, public, set]),   %%基础宠物配置
    %% ets:new(?ETS_BASE_PET_CHARACTER,[{keypos,#ets_base_pet_character.character_id}, named_table, public, set]),%%基础宠物性格
    %% ets:new(?ETS_BASE_PET_EXP, [{keypos, #ets_base_pet_exp.lv}, named_table, public, set]),%%宠物经验配置
    %% ets:new(?ETS_BASE_PET_TRAIN_COST, [{keypos, #ets_base_pet_train_cost.level}, named_table, public, set]),%%宠物训练花费
    %% ets:new(?ETS_PET, [{keypos,#ets_pet.id}, named_table, public, set]),                   %%宠物


    %% ets:new(?ETS_MANOR_ENTER, [{keypos, #ets_manor_enter.player_id}, named_table, public, set]), %%用户进入农场信息 Add By ZKJ
    %% ets:new(?ETS_FARM_INFO, [{keypos, #ets_farm_info.mid}, named_table, public, set]),  %%田地信息 Add By ZKJ
    %% ets:new(?ETS_MANOR_STEAL, [{keypos, #ets_manor_steal.steal_id}, named_table, public, set]), %%偷菜信息 Add By ZKJ 

    %% ets:new(?ETS_BASE_MERIDIAN, [{keypos, #ets_base_meridian.mer_id}, named_table, public, set]), %%经脉基础属性
    %% ets:new(?ETS_BASE_MERIDIAN_CD,[{keypos, #ets_base_meridian_cd.id}, named_table, public, set]),
    %% ets:new(?ETS_MERIDIAN, [{keypos, #ets_meridian.id}, named_table, public, set]), %%玩家经脉属性
    %% ets:new(?ETS_MERIDIAN_LOG, [{keypos, #ets_meridian_log.player_id}, named_table, public, set]),
    ets:new(?ETS_UPCAMP, [{keypos, #ets_upcamp.id}, named_table, public, set]),

    ets:new(?ETS_ONLINE_GIFT, [{keypos, #ets_online_gift.player_id}, named_table, public, set]),     %% 在线奖励玩家表
    ets:new(?ETS_BASE_ONLINE_GIFT,[{keypos, #ets_base_online_gift.times}, named_table, public,set,{read_concurrency, true}]), %% 奖励物品表
    ets:new(?ETS_BASE_LOGIN_GIFT,
            [{keypos, #ets_base_login_gift.id}, named_table, public, ordered_set,
             {read_concurrency, true}]),                                                             %% 登录奖励列表
    ets:new(?ETS_BASE_SCENE_CLASS, [{keypos, #ets_base_scene_class.scene_id}, named_table, public, set, {read_concurrency, true}]),%%场景分类
    ets:new(?ETS_REALM, [named_table, public, set]),                                                %% 阵营玩家统计缓存
    ets:new(?ETS_TARGET_GIFT, [{keypos, #ets_target_gift.player_id}, named_table, public, set]), %%目标奖励玩家表
    ets:new(?ETS_BASE_TARGET_GIFT,[{keypos, #ets_base_target_gift.day}, named_table, public,set,{read_concurrency, true}]), %%目标奖励物品表
    ets:new(?ETS_TASK_CONSIGN, [{keypos, #ets_task_consign.id}, named_table, public, set]), %%系统委托任务
    ets:new(?ETS_CONSIGN_TASK, [{keypos, #ets_consign_task.id}, named_table, public, set]),         %% 角色委托任务列表
    ets:new(?ETS_CONSIGN_PLAYER, [{keypos, #ets_consign_player.pid}, named_table, public, set]),    %% 委托任务角色数值列表
    ets:new(?ETS_OFFLINE_AWARD,[{keypos, #ets_offline_award.pid}, named_table, public, set]), %%离线经验累积
    ets:new(?ETS_ONLINE_AWARD,[{keypos, #ets_online_award.pid}, named_table, public, set]), %%在线累积奖励
    ets:new(?ETS_VIP_MAIL, [named_table, public, bag]), %%vip邮件服务
    ets:new(?ETS_TITLE_MAIL, [named_table, public, bag]), %%称号邮件服务
    %% ets:new(?ETS_BASE_BUSINESS, [{keypos, #ets_base_business.id}, named_table, public, set]),
    %% ets:new(?ETS_BUSINESS,[{keypos, #ets_business.player_id}, named_table, public, set]), %%跑商数据表
    %% ets:new(?ETS_SAME_CAR,[named_table, public, set]), %%被劫商数据
    %% ets:new(?ETS_LOG_ROBBED,[named_table, public, bag]), %%劫商数据表
    ets:new(?ETS_ONLINE_AWARD_HOLIDAY,[{keypos, #ets_online_award_holiday.pid}, named_table, public, set]), %%节日登陆奖励
    ets:new(?ETS_HERO_CARD,[{keypos, #ets_hero_card.pid}, named_table, public, set]), %%英雄帖表 
    ets:new(?ETS_BASE_HERO_CARD, [{keypos, #ets_base_hero_card.id}, named_table, public, set,{read_concurrency, true}]),
    %% ets:new(?ETS_LOVE,[{keypos, #ets_love.pid}, named_table, public, set]), %%仙侣情缘
    %% 时装洗炼属性表
    %% ets:new(?ETS_BASE_GOODS_FASHION,
    %%         [{keypos, #ets_base_goods_fashion.goods_id}, named_table, public, set]),
    %% 默契度测试题库
    %% ets:new(?ETS_BASE_PRIVITY,[{keypos, #ets_base_privity.id}, named_table, public, set]),
    %% 酒馆 base 数据表
    ets:new(?ETS_BASE_TAVERN, 
            [{keypos, #ets_base_tavern.id}, named_table, public, set,
             {read_concurrency, true}]),
    %% 玩家酒馆数据表
    ets:new(?ETS_PLAYER_TAVERN, 
            [{keypos, #ets_player_tavern.id}, named_table, public, set]),
    ets:new(?ETS_PLAYER_GIFT,
            [{keypos, #ets_player_gift.id}, named_table, public, set]),
    %% 军衔需要用有序表，配置表开启并发读操作
    ets:new(?ETS_BASE_RANK, 
            [{keypos, #ets_base_rank.id}, named_table, public, ordered_set, 
             {read_concurrency, true}]),
    %% 基础伙伴表
    ets:new(?ETS_BASE_PARTER,
            [{keypos, #ets_base_parter.parter_id}, named_table, public, set, {read_concurrency, true}]),
    ets:new(?ETS_BASE_PARTNER_GROW,
            [{keypos, #ets_base_partner_grow.lv}, named_table, public, set, {read_concurrency, true}]),
    ets:new(?ETS_BASE_PARTNER_BEYOND,
            [{keypos, #ets_base_partner_beyond.id}, 
             named_table, public, set, {read_concurrency, true}]),
    ets:new(?ETS_BASE_PARTNER_PRAY,
            [{keypos, #ets_base_partner_pray.id}, named_table, public, {read_concurrency, true}]),
    ets:new(?ETS_BASE_PARTNER_DESTINY,
            [{keypos, #rec_base_partner_destiny.partner_uid}, named_table, public, set, {read_concurrency, true}]),
    ets:new(?ETS_BASE_PARTNER_FATE,
            [{keypos, #rec_base_partner_fate.fate_id}, named_table, public, set, {read_concurrency, true}]),
    %% 角色伙伴表
    ets:new(?ETS_PARTER, [{keypos, #ets_parter.id}, named_table, public, set]),
    ets:new(?ETS_PARTNER_RANK, [{keypos, #rec_partner_rank.key}, named_table, public, set]),
    ets:new(?ETS_OFFLINE_PARTER, [{keypos, #ets_parter.id}, named_table, public, set]),
    %% 离线角色装备表
    ets:new(?ETS_OFFLINE_GOODS, [{keypos,#goods.id},named_table, public, set]),

    %% 装备强化规则表
    ets:new(?ETS_BASE_EQUIP_STRENGTHEN_RULE,
            [{keypos,#ets_base_equip_strengthen_rule.id}, named_table, public, set, {read_concurrency, true}]),
    %% ets:new(?ETS_BASE_EQUIP_SUIT,[{keypos,#ets_base_equip_suit.suit_id},named_table, public, set]),  %%装备套装基础表
    ets:new(?ETS_BASE_EQUIP_SUIT_ATTRIBUTE,
            [{keypos,#ets_base_equip_suit_attribute.id},named_table, public, set, {read_concurrency, true}]),  %%装备套装属性表
    %% ets:new(?ETS_BASE_EQUIP_PRACTISE_RULE,[{keypos,#ets_base_equip_practise_rule.id},named_table, public, set]),    %%装备冶炼规则表
    %% 冶炼星级表
    ets:new(?ETS_BASE_EQUIP_PRACTISE_STAR,
            [{keypos, #ets_base_practise_star.id}, named_table, public, set, 
             {read_concurrency, true}]),
    ets:new(?ETS_BASE_EQUIP_PRACTISE_NUM,[{keypos,#ets_base_practise_num.id},named_table, public, set, {read_concurrency, true}]),    %%冶炼属性个数表
    ets:new(?ETS_BASE_EQUIP_PRACTISE_ATTRIBUTE,[{keypos,#ets_base_practise_attribute.id},named_table, public, set, {read_concurrency, true}]),        %%冶炼属性配置表

    ets:new(?ETS_BASE_EQUIP_ATTRIBUTE,[{keypos,#rec_base_equip_attribute.id},named_table, public, set, {read_concurrency, true}]),    %%装备强化属性提升表
    %% 怪物掉落控制数据
    ets:new(?ETS_BASE_GOODS_DROP_CONTROL, [{keypos,#ets_base_goods_drop_control.goods_id},named_table, public, set, {read_concurrency, true}]),
    ets:new(?ETS_BASE_BUFF, [{keypos,#ets_base_buff.buff_id},named_table, public, set, {read_concurrency, true}]),    %%基础buff表
    ets:new(?ETS_PLAYER_INFO, [{keypos,#ets_player_info.cash_id},named_table, public, set]),        %%玩家信息表

    %% 基础训练师表
    ets:new(?ETS_BASE_TRAINER,
            [{keypos, #ets_base_trainer.id}, named_table, public, set, {read_concurrency, true}]),
    ets:new(?ETS_PLAYER_TRAINER,
            [{keypos, #dic_player_trainer.id}, named_table, public, set]),

    %% 公共数据表，可供存储服务器运行中产生的一些公共数据
    ets:new(?ETS_PUBLIC_DATA, [{keypos,1}, named_table, public, set]),
    %% 玩家战斗属性表
    ets:new(?ETS_BATTLE_ATTRIBUTE, 
            [{keypos, #battle_attribute.key}, named_table, public, set]),

    ets:new(?ETS_BASE_ARENA_MEMBER,
            [{keypos, #ets_base_arena_member.id}, named_table, public, set, {read_concurrency, true}]),
    ets:new(?ETS_BASE_ARENA_MONSTER,
            [{keypos, #ets_mon.unique_key}, named_table, public, set, {read_concurrency, true}]),
    ets:new(?ETS_BASE_ARENA_REWARD,
            [{keypos, #ets_base_arena_reward.id}, named_table, public, set, {read_concurrency, true}]),
    ets:new(?ETS_BASE_ARENA_WINNING_REWARD,
            [{keypos, #ets_base_arena_winning_reward.id}, named_table, public, set, {read_concurrency, true}]), 

    %% 宝藏相关数据表映射
    ets:new(?ETS_BASE_TREASURE_EXPLORE,
            [{keypos,#ets_base_treasure_explore.id}, named_table, public, set, {read_concurrency, true}]),
    ets:new(?ETS_BASE_TREASURE,
            [{keypos,#ets_base_treasure.id}, named_table, public, set, {read_concurrency, true}]),
    ets:new(?ETS_TREASURE, 
            [{keypos, #ets_treasure.id}, named_table, public, set]),
    ets:new(?ETS_TREASURE_EQUIP,
            [{keypos, #ets_treasure_equip.id}, named_table, public, set]),   
    
    ets:new(?ETS_TREASURE_EQUIP_OFFLINE, [{keypos, #ets_treasure_equip.id}, named_table, public, set]),   

    %% 世界boss战一些比较大量的数据的存储。
    ets:new(?ETS_BOSS_WAR,
            [{keypos, #dic_player_boss.player_id}, named_table, public, set]),
    ets:new(?ETS_LINE_COUNT, [{keypos, #line_count.key}, named_table, public, set]),                        %% 分线数据

    ets:new(?ETS_BASE_GUILD_MAGIC, [{keypos, #ets_base_guild_magic.id}, named_table, public, set, {read_concurrency, true}]),
    ets:new(?ETS_PLAYER_MAGIC, [{keypos, #ets_player_magic.id}, named_table, public, set]), %%玩家术法表
    ets:new(?ETS_COMBAT_SKILL, [{keypos, #rec_combat_skill.id},named_table,public,set]),                %%主动技能表
    ets:new(?ETS_COMBAT_SKILL_PASSIVE,[{keypos,#rec_combat_skill_passive.id},named_table,public,set]),  %%被技能表

    %% Beast相关
    ets:new(?ETS_BASE_BEAST,[{keypos, #rec_base_beast.id}, named_table, public, set, {read_concurrency, true}]),
    %% ets:new(?ETS_BASE_BEAST_SKILL_RULE,[{keypos, #rec_base_beast_skill_rule.id}, named_table, public, set]),
    %% ets:new(?ETS_BASE_BEAST_SKILL_COST,[{keypos, #rec_base_beast_skill_cost.id}, named_table, public, set]),
    ets:new(?ETS_BASE_BEAST_KEEP_ATTRI,[{keypos, #rec_base_beast_keep_attri.id}, named_table, public, set, {read_concurrency, true}]),
    %% ets:new(?ETS_BASE_BEAST_KEEP_ATTRI_RULE,[{keypos, #rec_base_beast_keep_attri_rule.id}, named_table, public, set]),
    %% ets:new(?ETS_BASE_BEAST_EXP,[{keypos, #rec_base_beast_exp.id}, named_table, public, set]),
    ets:new(?ETS_BASE_BEAST_CAMP,[{keypos, #rec_base_beast_camp.id}, named_table, public, set, {read_concurrency, true}]),
    ets:new(?ETS_BASE_BEAST_CHANGE,[{keypos, #rec_base_beast_change.id}, named_table, public, set, {read_concurrency, true}]),
    %% ets:new(?ETS_BASE_BEAST_CAMP_RULE,[{keypos, #rec_base_beast_camp_rule.id}, named_table, public, set]),
    ets:new(?ETS_BEAST,[{keypos, #rec_beast.id}, named_table, public, set]),

    ets:new(?ETS_BASE_FIGHT_SOUL,[{keypos, #rec_base_fight_soul.id}, named_table, public, set, {read_concurrency, true}]),
    ets:new(?ETS_FIGHT_SOUL,[{keypos, #rec_fight_soul.id}, named_table, public, set]),
    ets:new(?ETS_PLAYER_DUMGEON,[{keypos, #player_dungeon.id}, named_table, public, set]),

    %% 战报
    ets:new(?ETS_FIGHT_REPORT, [{keypos, #rec_fight_report.uuid}, named_table, public, set]),
    %% 战报查询使用
    ets:new(?ETS_FIGHT_REPORT_INFO, [{keypos, #rec_fight_report_info.key}, named_table, public, set]),

    %% 神秘商店
    ets:new(?ETS_MYSTERY_SHOP, [{keypos, #ets_player_mystery_shop.player_id}, named_table, public, set]),

    ets:new(?ETS_CAMP,[{keypos,#rec_camp.id}, named_table, public ,set]),

    %% 星力配置表
    ets:new(?ETS_BASE_STAR_POWER, [{keypos,#rec_base_star_power.id}, named_table, public, set, {read_concurrency, true}]),

    %% 战斗属性相关
    ets:new(?ETS_PLAYER_COMBAT_ATTRI, [{keypos, #rec_player_combat_attri.id}, named_table, public ,set]),
    ets:new(?ETS_PLAYER_COMBAT_ATTRIBUTE_EX,
            [{keypos, #ets_player_combat_attribute_ex.id}, named_table, public ,set]),

    %% VIP相关
    ets:new(?ETS_BASE_VIP, [{keypos, #rec_base_vip.vip_lv}, named_table, public ,set, {read_concurrency, true}]),

    %% 过关斩将相关ETS表
    ets:new(?ETS_BASE_KILO_RIDE, [{keypos, #rec_base_kilo_ride.layer_id}, named_table, public, set, {read_concurrency, true}]),
    %% ets:new(?ETS_BASE_CHALLENGE_REWARD,
    %%         [{keypos, #rec_base_challenge_reward.layer_id}, named_table, public ,set]),
    ets:new(?ETS_BASE_KILO_RIDE_RANK_REWARD,
            [{keypos, #rec_base_kilo_ride_rank_reward.id}, named_table, public ,set, {read_concurrency, true}]),
    ets:new(?ETS_BASE_CHEST,
            [{keypos, #rec_base_chest.id}, named_table, public, set, {read_concurrency, true}]),
    ets:new(?ETS_KILO_RIDE,
            [{keypos, #rec_kilo_ride.player_id}, named_table, public, set]),

    %% 试炼/小助手相关
    ets:new(?ETS_BASE_TRIAL,    [{keypos, #base_trial_data.trial_id}, named_table, public ,set, {read_concurrency, true}]),
    ets:new(?ETS_BASE_TRIAL_REWARD, [{keypos, #base_trial_award.reward_id}, named_table, public ,set,  {read_concurrency, true}]),
    ets:new(?ETS_PLAYER_TRIAL,  [{keypos, #dic_player_trial.player_id}, named_table, public ,set]),

    ets:new(?ETS_BASE_ACTIVITY, [{keypos, #base_activity.id}, named_table, public, set,  {read_concurrency, true}]),
    ets:new(?ETS_BASE_OP_ACTIVITIES, 
            [{keypos, #ets_base_op_activities.id}, 
             named_table, public, set, {read_concurrency, true}]),
    ets:new(?ETS_BASE_BOSS,     [{keypos, #base_boss.scene}, named_table, public, set,  {read_concurrency, true}]),

    ets:new(?ETS_BASE_BOSS_UPGRADE, [{keypos, #base_boss_upgrade.id}, named_table, public, set, {read_concurrency, true}]),

    ets:new(?ETS_BASE_WARCRAFT, [{keypos, #rec_base_warcraft.wid}, named_table, public, set, {read_concurrency, true}]),
    ets:new(?ETS_WARCRAFT,      [{keypos, #rec_warcraft.id}, named_table, public ,set]),
    ets:new(?ETS_WORLD_BOSS,    [{keypos, #mod_boss_state.boss_scene_id}, named_table, public ,set]),
    ets:new(?ETS_SYS_ACM,       [{keypos, #rec_sys_acm.id}, named_table, public ,set]),

    ets:new(?ETS_BASE_SYS_ACM,  [{keypos, #rec_base_sys_acm.id}, named_table, public ,set, {read_concurrency, true}]),
    ets:new(?ETS_RANK_PLAYER,   [{keypos, #rec_rank_data.id}, named_table, public, ordered_set]),
    ets:new(?ETS_WHITE_IP,      [named_table, public, set]),

    %% 帮派配置表
    ets:new(?ETS_BASE_GUILD,         [{keypos,#ets_base_guild.lv}, named_table,public,set,{read_concurrency, true}]),
    ets:new(?ETS_BASE_GUILD_SKILL,   [{keypos,#ets_base_guild_skill.id},named_table,public,set,{read_concurrency, true}]),
    ets:new(?ETS_BASE_GUILD_DONATE,  [{keypos,#ets_base_guild_donate.id},named_table,public,set,{read_concurrency, true}]),
    ets:new(?ETS_BASE_GUILD_POSITION,[{keypos,#ets_base_guild_position.id},named_table,public,set,{read_concurrency, true}]), 

    %% 帮派数据ETS表
    ets:new(?ETS_GUILD,       [{keypos,#ets_guild.id},named_table,public,set]),
    ets:new(?ETS_GUILD_SKILL, [{keypos,#ets_guild_skill.id},named_table,public,set]),
    ets:new(?ETS_GUILD_APPLY, [{keypos,#ets_guild_apply.id},named_table,public,set]),
    ets:new(?ETS_GUILD_INVITE,[{keypos,#ets_guild_invite.id},named_table,public,set]),
    ets:new(?ETS_GUILD_MEMBER,[{keypos,#ets_guild_member.player_id},named_table,public,set]),
    ets:new(?ETS_GUILD_LOG,   [{keypos,#ets_guild_log.id},named_table,public,set]),
    ets:new(?ETS_GUILD_MAGIC, [{keypos, #ets_guild_magic.id}, named_table, public, set]),
    ets:new(?ETS_GUILD_SCORE, [{keypos, #rec_guild_score.guild_id}, named_table, public, set]),  %% 军团战斗积分排名表
    ets:new(?ETS_GUILD_FIGHT_LIST, [{keypos, #rec_guild_fight_list.key}, named_table, public, set]), %% 军团战列表
    ets:new(?ETS_GUILD_FIGHT_LIST_DUMP, [{keypos, #rec_guild_fight_list.key}, named_table, public, set]), %% 军团战八强列表，供非积分时候查询

    ets:new(?ETS_GUILD_FIGHT_MEMBER, [{keypos, #rec_guild_fight_member.key}, named_table, public, set]), %% 军团战列表
    ets:new(?ETS_GUILD_FIGHT_REPORT, [{keypos, #rec_guild_fight_report.key}, named_table, public, set]), %% 军团战战报列表
    ets:new(?ETS_GUILD_FIGHT_MEMBER_BOARD, [{keypos, #rec_guild_fight_member_board.player_id}, named_table, public, set]), %% 军团战世界8强玩家
    ets:new(?ETS_GUILD_FIGHT_GUILD_BOARD, [{keypos, #rec_guild_fight_guild_board.guild_id}, named_table, public, set]), %% 军团战世界8强军团
    ets:new(?ETS_GUILD_FIGHT_GAMBLE, [{keypos, #rec_guild_fight_gamble.id}, named_table, public, set]), %% 军团战投注表

    ets:new(?ETS_BASE_LV, [{keypos, #rec_base_lv.lv}, named_table, public, set, {read_concurrency, true}]), %% 等级标准表 
    ets:new(?ETS_BASE_EIGHT_FIGHT_RANK_REWARD, [{keypos, #rec_base_eight_fight_rank_reward.id}, named_table, public, set, {read_concurrency, true}]), %% 8强排名奖励表
    %% 成就系统
    ets:new(?ETS_BASE_ACHIEVE, [{keypos, #base_achieve.achieve_id}, named_table, public, set, {read_concurrency, true}]), %% 成就基础数据
    ets:new(?ETS_PLAYER_ACHIEVE, [{keypos, #dic_player_achieve.key}, named_table, public, set]), %% 玩家成就数据
    %% ets:new(?ETS_PLAYER_ACHIEVE_TIMES, [{keypos, #dic_player_achieve_times.id}, named_table, public, set]), %% 玩家某类次数，暂不做
    ets:new(?ETS_SOUTHER_BOSS,  [{keypos, #rec_southern_boss.key}, named_table, public ,set]),
    ets:new(?ETS_SOUTHER_INFO,    [{keypos, #rec_southern_info.player_id}, named_table, public ,set]),
    ets:new(?ETS_BASE_SOUTHER_UPGRADE,    [{keypos, #rec_base_southern_upgrade.layer}, named_table, public ,set, {read_concurrency, true}]),
    ets:new(?ETS_STORE_RECEIPT, [{keypos, #rec_store_receipt.id}, named_table, public ,set]),  %%给苹果服务器发送的receipt的储存
    ets:new(?ETS_APP_STORE_PRODUCT, [{keypos, #rec_app_store_product.product_id}, named_table, public ,set, {read_concurrency, true}]),  %%苹果平台product

    %% 奴隶系统
    ets:new(?ETS_PLAYER_MASTER_SLAVE, 
            [{keypos, #ets_player_master_slave.id}, named_table, public, set]),

    %% 推送系统
    ets:new(?ETS_PUSH_SCHEDULE,
            [{keypos, #ets_push_schedule.id}, named_table, public, set]),

    ets:new(?ETS_ACTIVATION_CODE, [{keypos, #rec_activation_code.cardstring}, named_table, public, set, {read_concurrency, true}]), %% 新手礼包激活码配置表

    ets:new(?ETS_UPS_FIGHTER,       [{keypos, #rec_ups_fighter.key},     named_table, public ,set]),
    ets:new(?ETS_UPS_FIGHT_REPORT,  [{keypos, #rec_ups_fight_report.id}, named_table, public ,set]),
    ets:new(?ETS_BASE_ACTIVITY_RATE, [{keypos, #rec_base_activity_rate.id}, named_table, public ,set, {read_concurrency, true}]),

    ets:new(?ETS_UPS_GAMBLE, [{keypos, #rec_ups_gamble.key}, named_table, public ,set]),
    ets:new(?ETS_BASE_UPS_REWARD, [{keypos, #rec_base_ups_reward.id}, named_table, public ,set, {read_concurrency, true}]),

    ets:new(?ETS_BASE_FORAGE, [{keypos, #rec_base_forage.guild_lv}, named_table, public, set, {read_concurrency, true}]),
    ets:new(?ETS_FORAGE_GUILD, [{keypos, #rec_forage_guild.guild_id}, named_table, public, set]),
    ets:new(?ETS_FORAGE_PLAYER, [{keypos, #rec_forage_player.player_id}, named_table, public, set]),

    ets:new(?ETS_BASE_TROOP, [{keypos, #rec_base_troop.id}, named_table, public, set, {read_concurrency, true}]),
    ets:new(?ETS_TROOP, [{keypos, #rec_troop.id}, named_table, public, set]),

    ets:new(?ETS_DRAGON_TOTEM_GUILD_MEMBER, [{keypos, #rec_dragon_totem_guild_member.player_id}, named_table, public, set]),
    ets:new(?ETS_DRAGON_TOTEM_GUILD, [{keypos, #rec_dragon_totem_guild.guild_id}, named_table, public, set]),
    ok.

