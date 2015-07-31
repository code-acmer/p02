%%%-------------------------------------------------------------------
%%% @author Arno <>
%%% @copyright (C) 2014, Arno
%%% @doc
%%%
%%% @end
%%% Created :  9 Jan 2014 by Arno <>
%%%-------------------------------------------------------------------
-module(update).

-behaviour(gen_server).
-include_lib("kernel/include/file.hrl").
-include("define_logger.hrl").

%% API
-export([start_link/0]).
-export([
         update_all/2,
         update/2,
         get_changed_mods/1,
         set_mods_updated/1,
         stop/0,
         start/0
        ]).

%% gen_server callbacks
%% -define(RERODER_CHECK_TIME,  5000).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-define(SERVER, ?MODULE). 

-record(state, {last, 
                tref}).
%% -record(state, {sended_nodes        = [],  %% 发送命令成功的节点
%%                 recved_nodes        = []   %% 已经收到返回信息的节点
%%                }).

%%%===================================================================
%%% API
%%%===================================================================
get_changed_mods(Now) ->
    gen_server:call(?MODULE, {get_changed_mods, Now}).

set_mods_updated(Now) ->
    gen_server:call(?MODULE, {set_mods_updated, Now}).

start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%% @spec start() -> ServerRet
%% @doc Start the reloader.
start() ->
    gen_server:start({local, ?MODULE}, ?MODULE, [], []).

%% @spec stop() -> ok
%% @doc Stop the reloader.
stop() ->
    gen_server:call(?MODULE, stop).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================
init([]) ->
    {ok, #state{last = stamp()
               }}.

handle_call({get_changed_mods, Now}, _From, State) ->
    Reply = inner_get_changed_mods(State#state.last, Now),
    {reply, Reply, State};
handle_call({set_mods_updated, Last}, _From, State) ->
    Reply = ok,
    {reply, Reply, State#state{last = Last
                              }};
%% @spec handle_call(Args, From, State) -> tuple()
%% @doc gen_server callback.
handle_call(stop, _From, State) ->
    {stop, shutdown, stopped, State};
handle_call(_Req, _From, State) ->
    {reply, {error, badrequest}, State}.


handle_cast(_Msg, State) ->
    {noreply, State}.


handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_Vsn, State, _Extra) ->
    {ok, State}.

inner_print_result(Node, Result) ->
    case Result of
        {OutputGitPull, OutputUpdateDeps, OutputCompile, OutputReloder} ->
            ?WARNING_MSG("~nNode : ~w, update done. ~ngit pull :~s~nupdate_deps:~s~ncompile:~s relader : ~p~n",
                         [Node, OutputGitPull, OutputUpdateDeps, OutputCompile, OutputReloder]);
        {OutputGitPull, OutputReloder}->
            ?WARNING_MSG("~nNode : ~w, update done. ~ngit pull :~s~nreloader:~p~n",
                         [Node, OutputGitPull, OutputReloder])
    end.

%% %% Execute Fun using the IO system of the local node (i.e. the node on
%% %% which the code is executing).
%% with_local_io(Fun) ->
%%     GL = group_leader(),
%%     group_leader(whereis(user), self()),
%%     try
%%         Fun()
%%     after
%%         group_leader(GL, self())
%%     end.

%% %% Log an info message on the local node using the standard logger.
%% %% Use this if rabbit isn't running and the call didn't originate on
%% %% the local node (e.g. rabbitmqctl calls).
%% local_info_msg(Format, Args) ->
%%     with_local_io(fun () -> error_logger:info_msg(Format, Args) end).


update_all(Type, Modules) ->
    Nodes = [node()|nodes()],
    lists:foreach(fun(Node) ->
                          erlang:spawn(fun() ->
                                               case catch rpc:call(Node, update, update, [Type, Modules]) of
                                                   {_, _ , _, _} = RET1 ->
                                                       inner_print_result(Node, RET1);
                                                   {_, RET2} ->
                                                       inner_print_result(Node, RET2);
                                                   _Other ->
                                                       ?WARNING_MSG("~p update fail~p~n", [Node, _Other])
                                               end
                                       end)
                  end, Nodes),
    ok.

update(Type, Modules) ->
    OutputGitPull = os:cmd("git pull"),    
    case Type of
        debug ->
            OutputUpdateDeps = os:cmd("rebar update-deps"),
            OutputCompile    = os:cmd("rebar compile"),
            Now = stamp(),
            NewModules = case Modules of
                             [] ->
                                 update:get_changed_mods(Now);
                             Mods ->
                                 Mods
                         end,
            OutputReloder = reload_modules(NewModules),
            update:set_mods_updated(Now),
            ?WARNING_MSG("~nnode ~p~n cmd: git pull ~s~n update-deps ~s~n rebar compile ~s~n relaoder:~p~n", 
                         [node(), OutputGitPull, OutputUpdateDeps, OutputCompile, OutputReloder]),
            {OutputGitPull, OutputUpdateDeps, OutputCompile, OutputReloder};
        _ ->
            Now = stamp(),
            NewModules = case Modules of
                             [] ->
                                 Now = stamp(),
                                 update:get_changed_mods(Now);
                             Mods ->
                                 Mods
                         end,
            OutputReloder = reload_modules(NewModules),
            update:set_mods_updated(Now),
            ?WARNING_MSG("~nnode ~s~n cmd: git pull ~s~n reload module ~p~n", [node(), OutputGitPull, OutputReloder]),          
            {OutputGitPull, OutputReloder}
    end.



%% @spec reload_modules([atom()]) -> [{module, atom()} | {error, term()}]
%% @doc code:purge/1 and code:load_file/1 the given list of modules in order,
%%      return the results of code:load_file/1.
reload_modules(Modules) ->
    [begin reload(M) end || M <- Modules].

inner_get_changed_mods(From, To) ->
    lists:foldl(fun({Module, FileName}, ChangedMods) ->
                        case catch file:read_file_info(FileName) of
                            {ok, #file_info{mtime = Mtime}} when Mtime >= From, Mtime < To ->
                                [Module|ChangedMods];
                            {ok, _} ->
                                ChangedMods;
                            {error, Reason} ->
                                error_logger:error_msg("Error reading ~s's file info: ~p~n",
                                                       [FileName, Reason]),
                                ChangedMods
                        end
                end, [], code:all_loaded()).

reload(Module) ->
    error_logger:info_msg("Reloading ~p ...", [Module]),
    code:purge(Module),
    case code:load_file(Module) of
        {module, Module} = Ret ->
            error_logger:info_msg("reload ~w ok.~n", [Module]),
            Ret;
        {error, Reason} = Ret ->
            error_logger:error_msg("reload fail: ~p.~n", [Reason]),
            Ret
    end.


stamp() ->
    erlang:localtime().

