%%%------------------------------------
%%% @Module  : mod_task_cache
%%% @Created : 2010.10.05
%%% @Description: 任务数据回写
%%%------------------------------------

-module(mod_task_cache).

%% -behaviour(gen_server).
%% -export(
%%     [
%%      start_link/0,
%%      stop/0,
%%      add_log/6,
%%      del_log/2,
%%      add_trigger/7,
%%      upd_trigger/4,
%%      del_trigger/2,
%%      force_del_trigger/2,
%%      compress/2,
%%      write_back/1,
%%      write_back_all/0
%%     ]
%% ).
%% -export([
%%          init/1,
%%          handle_call/3,
%%          handle_cast/2,
%%          handle_info/2,
%%          terminate/2,
%%          code_change/3
%%         ]).

%% -include("define_logger.hrl").
%% -include("define_task.hrl").

%% %% -record(state, {id = 1, interval = 0, limit = 0, cache = []}).
%% %% 定时器1间隔时间
%% -define(TIMER_1, 60*1000).

%% %% 添加完成日志
%% add_log(Rid, Tid, Type, TriggerTime, FinishTime, _Sn) ->
%% 	Data=[Rid, Tid, Type,TriggerTime, FinishTime],
%% 	erlang:spawn(db_agent,syn_db_task_log_insert,[Data]).
%% %%     gen_server:cast(?MODULE, {log, Rid, Tid, [Rid, Tid, Type,TriggerTime, FinishTime]}).

%% %%  删除完成日志
%% del_log(Rid, Tid) ->
%% 	Data = [Rid, Tid],
%% 	erlang:spawn(db_agent,syn_db_task_log_delete,[Data]).
%% %%     gen_server:cast(?MODULE, {del_log, Rid, Tid, [Rid, Tid]}).

%% %% 添加触发
%% add_trigger(Rid, Tid, TriggerTime, TaskState, TaskEndState, TaskMark,TaskType) ->
%% 	Data = [Rid, Tid, TriggerTime, TaskState, TaskEndState, TaskMark,TaskType],
%% 	db_agent:syn_db_task_bag_insert(Data).
%% %%     gen_server:cast(?MODULE, {add, Rid, Tid, [Rid, Tid, TriggerTime, TaskState, TaskEndState, TaskMark,TaskType]}).

%% %% 更新任务记录器
%% upd_trigger(Rid, Tid, TaskState, TaskMark) ->
%%     Data = [TaskState, TaskMark, Rid, Tid],
%%     db_agent:syn_db_task_bag_update(Data).
%% %% gen_server:cast(?MODULE, {upd, Rid, Tid, [TaskState, TaskMark, Rid, Tid]}).

%% %% 删除触发的任务
%% del_trigger(Rid, Tid) ->
%% 	Data = [Rid, Tid],
%% 	db_agent:syn_db_task_bag_delete(Data).
%% %%     gen_server:cast(?MODULE, {del, Rid, Tid, [Rid, Tid]}).

%% %% 强制删除任务
%% force_del_trigger(Rid, Tid) ->
%%     db_agent:syn_db_task_bag_force_delete([Rid, Tid]).

%% %% 立即回写单个玩家缓存
%% write_back(Rid) ->
%%     gen_server:cast(?MODULE, {cmd_commit, Rid}).

%% %%回写所有数据
%% write_back_all() ->
%% 	gen_server:cast(?MODULE, {cmd_commit_all}).

%% start_link()->
%%     gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% %% 关闭服务器时回调
%% stop() ->
%%     ok.

%% %% --------------------------------------------------------------------
%% %% Function: init/1
%% %% Description: Initiates the server
%% %% Returns: {ok, State}          |
%% %%          {ok, State, Timeout} |
%% %%          ignore               |
%% %%          {stop, Reason}
%% %% --------------------------------------------------------------------
%% init([])->
%% 	misc:write_monitor_pid(self(),?MODULE, {}),
%% 	case  config:get_db_type(db_game) =:= db_mysql of
%% 		true->
%%     		erlang:send_after(10000, self(), syn_db);
%% 		_->skip
%% 	end,
%% 	{ok,[task_cache]}.

%% %% 同步任务数据
%% syn_db([]) ->
%%     ok;
%% %%添加任务日志
%% syn_db([{log, _, _, Data, Sn} | List]) ->
%% 	erlang:spawn(db_agent, syn_db_task_log_insert, [Data, Sn]),
%%     syn_db(List);

%% %%添加任务信息
%% syn_db([{add, _, _, Data} | List]) ->
%% %%     db_agent:syn_db_task_bag_insert(Data),
%% 	erlang:spawn(db_agent,syn_db_task_bag_insert,[Data]),
%% 	syn_db(List);

%% %%更新任务信息
%% syn_db([{upd, _, _, Data} | List]) ->
%% %%     db_agent:syn_db_task_bag_update(Data),
%% 	erlang:spawn(db_agent,syn_db_task_bag_update,[Data]),
%%     syn_db(List);

%% %%删除任务信息
%% syn_db([{del, _, _, Data} | List]) ->
%% %%     db_agent:syn_db_task_bag_delete(Data),
%% 	erlang:spawn(db_agent,syn_db_task_bag_delete,[Data]),
%%     syn_db(List);

%% %%删除任务日志
%% syn_db([{del_log, Rid, Tid, _} | List]) ->
%%     Data = [Rid, Tid],
%% %%     db_agent:syn_db_task_log_delete(Data),
%% 	erlang:spawn(db_agent,syn_db_task_log_delete,[Data]),
%%     syn_db(List).

%% %% 数据压缩
%% compress([], Result) ->
%%     Result; %% 旧 -> 新

%% compress([{FirType, FirRid, FirTid, FirData} | T ], Result) ->
%%     R = lists:foldl(fun(X, R)-> compress(X, R) end, {FirType, FirRid, FirTid, FirData, []}, T),
%%     {_, _, _, _, Cache} = R,
%%     compress(lists:reverse(Cache), [{FirType, FirRid, FirTid, FirData} | Result]);
    
%% % compress({XType, XRid, XTid, XData}, {add, Rid, Tid, Data, Cache}) ->
%% %     case  XRid =:= Rid andalso XTid =:= Tid andalso XType =:= upd of
%% %         false -> {add, Rid, Tid, Data, [{XType, XRid, XTid, XData} | Cache]};
%% %         true -> {add, Rid, Tid, Data, Cache}
%% %     end;

%% compress({XType, XRid, XTid, XData}, {upd, Rid, Tid, Data, Cache}) ->
%%     case  XRid =:= Rid andalso XTid =:= Tid andalso XType =:= upd of
%%         false -> {upd, Rid, Tid, Data, [{XType, XRid, XTid, XData} | Cache]};
%%         true -> {upd, Rid, Tid, Data, Cache}
%%     end;

%% compress({XType, XRid, XTid, XData}, {del, Rid, Tid, Data, Cache}) ->
%%     case  XRid =:= Rid andalso XTid =:= Tid andalso (XType =:= upd orelse XType =:= add) of
%%         false -> {del, Rid, Tid, Data, [{XType, XRid, XTid, XData} | Cache]};
%%         true -> {del, Rid, Tid, Data, Cache}
%%     end;

%% %% 测试用
%% compress({XType, XRid, XTid, XData}, {del_log, Rid, Tid, Data, Cache}) ->
%%     case  XRid =:= Rid andalso XTid =:= Tid andalso XType =:= log of
%%         false -> {del_log, Rid, Tid, Data, [{XType, XRid, XTid, XData} | Cache]};
%%         true -> {del_log, Rid, Tid, Data, Cache}
%%     end;

%% compress(Elem, {Type, Rid, Tid, Data, Cache}) ->
%%     {Type, Rid, Tid, Data, [Elem | Cache]}.


%% %% --------------------------------------------------------------------
%% %% Function: handle_call/3
%% %% Description: Handling call messages
%% %% Returns: {reply, Reply, State}          |
%% %%          {reply, Reply, State, Timeout} |
%% %%          {noreply, State}               |
%% %%          {noreply, State, Timeout}      |
%% %%          {stop, Reason, Reply, State}   | (terminate/2 is called)
%% %%          {stop, Reason, State}            (terminate/2 is called)
%% %% --------------------------------------------------------------------
%% handle_call(_Request, _From, State) ->
%%     {noreply, State}.

%% %% --------------------------------------------------------------------
%% %% Function: handle_cast/2
%% %% Description: Handling cast messages
%% %% Returns: {noreply, State}          |
%% %%          {noreply, State, Timeout} |
%% %%          {stop, Reason, State}            (terminate/2 is called)
%% %% --------------------------------------------------------------------
%% %% 回写单个玩家数据到数据库
%% handle_cast({cmd_commit, PlayerId}, _State) ->
%%     NewCache = compress(get_task_cache(PlayerId), []), 
%%     syn_db(NewCache),
%% 	delete_task_cache(PlayerId),
%% 	{noreply,ok};

%% %%回写所有玩家数据到数据库
%% handle_cast({cmd_commit_all}, _State) ->
%%     [save_player_task(PlayerId,TaskCache)||{PlayerId,TaskCache}<-get_task_cache_all()],
%% 	{reply,ok};

%% %% 将要更新的数据加入到缓存中
%% handle_cast(Elem, _State) ->
%% 	case config:get_db_type(db_game) =:= db_mysql of
%% 		true->
%%    			{_,PlayId,_,_} = Elem,
%% 			TaskCache = get_task_cache(PlayId),
%% 			{noreply, insert_task_cache(PlayId,[Elem|TaskCache])};
%% 		_ ->
%% 			NewCache = compress([Elem], []), 
%%     		syn_db(NewCache), 
%% 			{noreply, ok}
%% 	end.

%% %% handle_cast(_Message, State)->
%% %% 	{noreply, State}.

%% %% --------------------------------------------------------------------
%% %% Function: handle_info/2
%% %% Description: Handling all non call/cast messages
%% %% Returns: {noreply, State}          |
%% %%          {noreply, State, Timeout} |
%% %%          {stop, Reason, State}            (terminate/2 is called)
%% %% --------------------------------------------------------------------
%% handle_info(syn_db, State) ->
%%     %% 开始异步回写
%%     spawn(
%%         fun() -> 
%% 			[save_player_task(PlayerId,TaskCache)||{PlayerId,TaskCache}<-get_task_cache_all()]
%%             %% ?DEBUG("需回写任务数据[~w]，压缩并回写[~w]", [length(State#state.cache), length(NewCache)]) 
%%         end
		
%%     ),
%%     %% 再次启动闹钟
%%     erlang:send_after(?TIMER_1, self(), syn_db),
%% 	 {noreply, State};
%% %%     {noreply, State#state{cache = []}};

%% handle_info(_Info, State) ->
%%     {noreply, State}.

%% %% --------------------------------------------------------------------
%% %% Function: terminate/2
%% %% Description: Shutdown the server
%% %% Returns: any (ignored by gen_server)
%% %% --------------------------------------------------------------------
%% terminate(_Reason, _State) ->
%% 	misc:delete_monitor_pid(self()),
%%     ok.

%% %% --------------------------------------------------------------------
%% %% Func: code_change/3
%% %% Purpose: Convert process state when code is changed
%% %% Returns: {ok, NewState}
%% %% --------------------------------------------------------------------
%% code_change(_OldVsn, State, _Extra) ->
%%     {ok, State}.

%% %%==========处理函数====
%% save_player_task(Id,Cache)->
%% 	NewCache = compress(Cache, []),
%% 	syn_db(NewCache),
%% 	delete_task_cache(Id).

%% %%**************缓存区操作**************%%
%% %% 获取单个玩家任务信息
%% get_task_cache(PlayerId) ->
%%     case ets:lookup(?ETS_TASK_CACHE, PlayerId) of
%%         [] ->[];
%%         [{_,TaskCache}] -> TaskCache
%%     end.

%% %%获取所有玩家任务信息
%% get_task_cache_all()->
%%    	ets:tab2list(?ETS_TASK_CACHE).

%% insert_task_cache(PlayerId,Cache) ->
%% 	ets:insert(?ETS_TASK_CACHE, {PlayerId,Cache}).

%% delete_task_cache(PlayerId) ->
%% 	ets:match_delete(?ETS_TASK_CACHE,{PlayerId,_='_'}).

