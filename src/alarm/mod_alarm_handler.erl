-module(mod_alarm_handler).
-behaviour(gen_event).

-export([init/1, handle_event/2, handle_call/2, handle_info/2, terminate/2, code_change/3]).   

-export([start/0]).


-include("define_logger.hrl").
-include("define_mail_notify.hrl").

%%gen_envent callbacks.
-record(state, {}).

start() ->
    case lists:member(?MODULE, gen_event:which_handlers(alarm_handler)) of
        true ->
            ok;
        false ->
            alarm_handler:add_alarm_handler(?MODULE)
    end.

init(Args) ->
	?DEBUG("misc_alarm_handler init : ~p.", [Args]),   
	{ok, #state{}}.   
  
handle_event({set_alarm, What}, State) ->   
    mail_misc:send(?SET_ALARM, list_to_binary(io_lib:format("node: ~p ~p", [node(), What]))),
    handle_set_alarm(What),
	{ok, State};   
 
handle_event({clear_alarm, What}, _State) ->   
    mail_misc:send(?CLEAR_ALARM, list_to_binary(io_lib:format("node: ~p ~p", [node(), What]))),
	{ok, _State};   
  
handle_event(Event, State) ->   
	?WARNING_MSG("unmatched event: ~p.", [Event]),   
	{ok, State}.   
  
handle_call(Req, State) ->  
    ?WARNING_MSG("Unknow Req ~p~n", [Req]),
	{ok, ok, State}.
       
handle_info(_Info, State) ->   
	{ok, State}.   
  
terminate(_Reason, _State) ->   
	ok.   

code_change(_OldVsn, State, _Extra) ->   
    {ok, State}.


handle_set_alarm({system_memory_high_watermark, []}) ->   
    gc();
handle_set_alarm({process_memory_high_watermark, _Pid}) -> 
    gc();
handle_set_alarm(_) -> 
    ignore.

gc() ->
    [garbage_collect(P) || P <- processes(),
                           {status, waiting} == process_info(P, status)],
    garbage_collect(), %% since we will never be waiting...
    ok.
