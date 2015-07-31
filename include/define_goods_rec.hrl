-ifndef(DEFINE_GOODS_REC_HRL).
-define(DEFINE_GOODS_REC_HRL,true).

%% 背包类型
-define(CONTAINER_BAG,        10).   %% 背包
-define(CONTAINER_EQUIP,      20).   %% 身上装备
%% -define(CONTAINER_WEARS_FASHION,     30). %% 已穿戴的时装
-define(CONTAINER_FASHION,           40). %% 未穿戴的时装


%%1，会变的数据（攻击力等） 2，用的多的不变数据 

-record(goods, {id             = 0,          
                version = goods_version:current_version(),
                base_id        = 0,
                player_id      = 0,
                type           = 0,
                subtype        = 0,
                sum            = 0,          %%数量
                bind           = 0,
                quality        = 0,          %%品质
                str_lv         = 0,          %%强化等级
                star_lv        = 0,
                max_overlap    = 0,
                container      = ?CONTAINER_BAG,
                position       = 0,          %%装备位置
                hp             = 0,
                mana_lim       = 0,
                mana_lim_ext   = 0,
                mana_rec       = 0,
                mana_rec_ext   = 0,
                hp_ext         = 0,         %%额外属性
                attack         = 0,
                attack_ext     = 0, 
                def            = 0,
                def_ext        = 0,
                hit            = 0,
                hit_ext        = 0,
                dodge          = 0,          %%闪避
                dodge_ext      = 0,
                crit           = 0,
                crit_ext       = 0,
                anti_crit      = 0,
                anti_crit_ext  = 0,
                stiff          = 0,         %%僵直
                anti_stiff     = 0,
                attack_speed   = 0,
                move_speed     = 0,
                ice            = 0,
                fire           = 0,
                honly          = 0,
                dark           = 0,
                anti_ice       = 0,
                anti_fire      = 0,
                anti_honly     = 0,
                anti_dark      = 0,
                opear_type     = 0,          %%是否能在背包使用
                power          = 0,          %%战斗力
                jewels         = [],
                skill_card_exp = 0,          %%当前经验
                card_pos_1     = 0,          %%技能卡装备的位置
                card_pos_2     = 0,
                card_pos_3     = 0,
                timestamp      = 0,          %%红包过期时间
                value          = [],         %%红包价值[{goods_id, goods_num}]
                card_status    = 0,          %% 0自身卡, 1学艺中未冻结, 2学艺中冻结, 3出师卡  
                is_dirty       = 0
               }).

-endif.
