-module(mod_cache).
-behaviour(gen_server).

-include("define_cache.hrl").
-define(CLEAN_INTERVAL, timer:minutes(10)).

-export([
         start_link/0
        ]).
-export([
         init/1,
         handle_call/3,
         handle_cast/2,
         handle_info/2,
         terminate/2,
         code_change/3
        ]).

-record(state, {}).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    ets:new(?CACHE_DATA_TABLE, [
                                named_table, 
                                public,
                                {read_concurrency, true},
                                {write_concurrency, true}
                               ]),
    erlang:send_after(?CLEAN_INTERVAL, self(), cleanup),
    {ok, #state{}}.

handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(cleanup, State) ->
    ets:select_delete(?CACHE_DATA_TABLE, 
                      [
                       {
            {'_', '_', '$1'},
            [{'<', '$1', time_misc:unixtime()}],
            [true]
        }
    ]),
    erlang:send_after(?CLEAN_INTERVAL, self(), cleanup),
    {noreply, State};

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
