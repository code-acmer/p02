%%%-------------------------------------------------------------------
%%% @author Arno <>
%%% @copyright (C) 2013, Arno
%%% @doc
%%%
%%% @end
%%% Created : 30 Nov 2013 by Arno <>
%%%-------------------------------------------------------------------
-module(mod_mnesia_statistics).

-include_lib("leshu_db/include/leshu_db.hrl").
-include("define_logger.hrl").
-behaviour(gen_server).

-export([
         counting/2,
         counting_cmd/1,
         mnesia_top_op/1,
         mnesia_top_tables/1,
         cmd_top/1
        ]).

%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-define(SERVER, ?MODULE). 

-record(state, {op_list,
                cmd_list}).

%%%===================================================================
%%% API
%%%===================================================================
counting(Table, Op) ->
    gen_server:cast(?MODULE, {counting, Table, Op}).
counting_cmd(Cmd) ->
    gen_server:cast(?MODULE, {counting_cmd, Cmd}).
cmd_top(Num) ->
    gen_server:call(?MODULE, {cmd_top, Num}).

mnesia_top_op(N) ->
    gen_server:call(?MODULE, {get_cnt_top_op, N}).

mnesia_top_tables(N) ->
    gen_server:call(?MODULE, {get_cnt_top_tables, N}).
                         

%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @spec start_link() -> {ok, Pid} | ignore | {error, Error}
%% @end
%%--------------------------------------------------------------------
start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Initializes the server
%%
%% @spec init(Args) -> {ok, State} |
%%                     {ok, State, Timeout} |
%%                     ignore |
%%                     {stop, Reason}
%% @end
%%--------------------------------------------------------------------
init([]) ->
    erlang:send_after(3000, self(), auto_save),
    {ok, #state{op_list = dict:new(),
                cmd_list = []}}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling call messages
%%
%% @spec handle_call(Request, From, State) ->
%%                                   {reply, Reply, State} |
%%                                   {reply, Reply, State, Timeout} |
%%                                   {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, Reply, State} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
handle_call({cmd_top, Num}, _, State) ->
    CmdList = State#state.cmd_list,
    Reply = get_cmd_top(CmdList, Num),
    {reply, Reply, State};
handle_call({get_cnt_top_op, N}, _From, State) ->
    Reply = get_cnt_top_op(N),
    %% io:format("Top op cnt N:~w , Top : ~p",[N, Reply]),
    {reply, Reply, State};
handle_call({get_cnt_top_tables, N}, _From, State) ->
    Reply = get_cnt_top_tables(N),
    %%io:format("Top tables cnt N:~w , Top : ~p",[N, Reply]),
    {reply, Reply, State};
handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.

%% handle_cast({counting, Table, Op}, State) ->
%%     try 
%%         add_cnt_for_static(Table, Op)
%%     catch _:R ->
%%             io:format("mnesia_statistics faile R:~w Stack:~p~n",[R, erlang:get_stacktrace()])
%%     end,
%%     {noreply, State};
handle_cast({counting, Table, Op}, #state{op_list = Dict} = State) ->
    NewDict = dict:update_counter({Table, Op}, 1, Dict),
    {noreply, State#state{op_list = NewDict}};
handle_cast({counting_cmd, Cmd}, #state{cmd_list = CmdList} = State) ->
    NewCmdList = orddict:update_counter(Cmd, 1, CmdList),
    {noreply, State#state{cmd_list = NewCmdList}};
handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(auto_save, #state{op_list = Dict} = State) ->
    %?DEBUG("~p ready to auto save ~n", [?MODULE]),
    erlang:send_after(1000*60, self(), auto_save),
    OpList = dict:to_list(Dict),
    try 
        [add_cnt_for_static(Table, Op, Count) || {{Table, Op}, Count} <- OpList]
    catch _:R ->
            ?WARNING_MSG("mnesia_statistics faile R:~w Stack:~p~n",[R, erlang:get_stacktrace()])
    end,
    {noreply, State#state{op_list = dict:new()}};
handle_info(_Info, State) ->
    {noreply, State}.


terminate(_Reason, _State) ->
    ?WARNING_MSG("~p terminate reason ~p~n", [?MODULE, _Reason]),
    ok.


code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
%% add_cnt_for_static(Table, Op) ->
%%     add_cnt_for_static(Table, Op, 1).

add_cnt_for_static(Table, Op, Count) ->
    Node = node(),
    Fun = fun() ->
                  case mnesia:dirty_read(mnesia_statistics, {Node, Table, Op}) of
                      [] ->
                          mnesia:dirty_write(mnesia_statistics, #mnesia_statistics{
                                                                   key      = {Node, Table, Op},
                                                                   node     = Node,
                                                                   table    = Table,
                                                                   op       = Op,
                                                                   count    = Count
                                                                  });
                      [MnesiaStatistics] ->
                          mnesia:dirty_write(mnesia_statistics, MnesiaStatistics#mnesia_statistics{
                                                                  count = MnesiaStatistics#mnesia_statistics.count + Count
                                                                 })
                  end
          end,
    mnesia:activity(sync_dirty, Fun, [], mnesia_frag).


get_cnt_top_tables(N) ->
    case mnesia:dirty_match_object(mnesia_statistics, #mnesia_statistics{_ = '_'}) of
        [] ->
            ignore;
        StatisticsList ->
            CountedByTable = count_by_table([], StatisticsList),
            SortedList = lists:sort(fun(A, B) ->
                                            A#mnesia_statistics.count >= B#mnesia_statistics.count
                                    end, CountedByTable),
            RetList = lists:sublist(SortedList, N),
            lists:map(fun(#mnesia_statistics{node  = _Node,
                                             table = Table,
                                             count = Count
                                            }) ->
                              {Table, Count}
                      end, RetList)
    end.

count_by_table(Ret, []) ->
    Ret;
count_by_table(Ret, [H|T]) ->
    case lists:keyfind(H#mnesia_statistics.table, #mnesia_statistics.table, Ret) of
        false ->
            count_by_table([H|Ret], T);
        Find ->
            NewFind = Find#mnesia_statistics{
                        count = Find#mnesia_statistics.count + H#mnesia_statistics.count
                       },
            NewRet = lists:keyreplace(H#mnesia_statistics.table, #mnesia_statistics.table, Ret, NewFind),
            count_by_table(NewRet, T)
    end.


get_cnt_top_op(N) ->
    case mnesia:dirty_match_object(mnesia_statistics, #mnesia_statistics{_ = '_'}) of
        [] ->
            ignore;
        StatisticsList ->
            SortedList = lists:sort(fun(A, B) ->
                                            A#mnesia_statistics.count >= B#mnesia_statistics.count
                                    end, StatisticsList),
            RetList = lists:sublist(SortedList, N),
            lists:map(fun(#mnesia_statistics{node  = Node,
                                             table = Table,
                                             count = Count,
                                             op    = Op
                                            }) ->
                              {Node, Table, Count, Op}
                      end, RetList)
    end.

get_cmd_top(CmdList, Num) ->
    lists:sublist(lists:reverse(lists:keysort(2, CmdList)), Num).
