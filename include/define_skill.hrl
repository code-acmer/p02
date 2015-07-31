-ifndef(DEFINE_SKILL_HRL).
-define(DEFINE_SKILL_HRL,true).



%%-----------------------------------------------
%%此文件用于保存技能的相关定义
%%-----------------------------------------------

%%记录技能的效果
-record
	(effect,
	 	{	
		 	object = 0,					%%目标(1自己，2敌人)
			object_count = 0,			%%目标数量(1.本人2.第一个3最后一个4.横排 5.竖排 6.全体)
			times = 0,					%%攻击次数,多次则要增加buff
			type = 0,					%%类型
			resource_id = 0,			%%buff效果資源ID
			value = 0,					%%值(正为增加/负为减少)
			rate = 0,					%%概率(如果是无概率设为100)
			
			%TODO:增加字段请在unique_id 前面增加因为后面的字段是init ets的在数据库表的基础上增加的!)
			unique_id = 0,				%%数据库没有存存储该字段
			skill_id = 0				%%绝技ID
		 }
    ).

 
%%目标
-define(SKILL_OBJECT_TYPE_MYSELF ,1).	%%己方
-define(SKILL_OBJECT_TYPE_ENEMY ,2).	%%敌方

%%目标数量
-define(SKILL_OBJECT_COUNT_MYSELF ,1).	%%本人
-define(SKILL_OBJECT_COUNT_FIRST ,2).	%%第一个
-define(SKILL_OBJECT_COUNT_LAST ,3).	%%最后一个
-define(SKILL_OBJECT_COUNT_ROW ,4).		%%横排
-define(SKILL_OBJECT_COUNT_COLUMN ,5).	%%竖排
-define(SKILL_OBJECT_COUNT_ALL ,6).		%%全体

%%默认概率
-define(SKILL_DEFAULT_RATE ,100).		%%默认概率100%


%%技能的效果类型(对应数据库和后台管理系统!)
-define(SKILL_EFFECT_TYPE_STRAIGHT_HURT ,1).   	%%直接伤害(则value设为0,由伤害计算公式)
-define(SKILL_EFFECT_TYPE_MP ,2).				%%气势(一次性效果)
-define(SKILL_EFFECT_TYPE_MAGIC ,3).			%%法术
-define(SKILL_EFFECT_TYPE_DEF ,4).				%%防御
-define(SKILL_EFFECT_TYPE_MAGIC_DEF ,5).		%%法术防御
-define(SKILL_EFFECT_TYPE_SKILL_DEF ,6).		%%绝技防御
-define(SKILL_EFFECT_TYPE_DODGE ,7).			%%闪避
-define(SKILL_EFFECT_TYPE_PARRY ,8).			%%格挡
-define(SKILL_EFFECT_TYPE_COUNTER ,9).			%%反击
-define(SKILL_EFFECT_TYPE_ATTACK ,10).			%%攻击
-define(SKILL_EFFECT_TYPE_MAGIC_ATTACK ,11).	%%法术攻击
-define(SKILL_EFFECT_TYPE_SKILL_ATTACK ,12).	%%绝技攻击
-define(SKILL_EFFECT_TYPE_HIT ,13).				%%命中
-define(SKILL_EFFECT_TYPE_CRIT ,14).			%%暴击
-define(SKILL_EFFECT_TYPE_SLEEP ,15).			%%催眠
-define(SKILL_EFFECT_TYPE_DIZZY ,16).			%%晕眩
-define(SKILL_EFFECT_TYPE_HP ,17).				%%掉血/加血   

%%技能概率加成(宠物系统调用)
-record(
   		skill_rate,
		{
		 	straight_hurt = 0,					%%直接伤害
			mp = 0,								%%气势
			def = 0,							%%防御
			magic_def = 0,						%%法术防御
			dodge = 0,							%%闪避
			parry = 0,							%%格挡
			counter = 0,						%%反击
			attack = 0,							%%攻击
			magic_attack = 0,					%%法术攻击
			skill_attack = 0,					%%技能攻击
			hit = 0,							%%命中
			crit = 0,							%%暴击
			sleep = 0,							%%催眠
			dizzy = 0,							%%晕眩
			hp = 0								%%气血类
		 }	
   		).

-endif.
