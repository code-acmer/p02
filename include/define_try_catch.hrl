-ifndef(DEFINE_TRY_CATCH_HRL).
-define(DEFINE_TRY_CATCH_HRL, true).

%% try ... catch end
-define(TRY_BEGIN, try
                       begin).
-define(TRY_END, end
        catch
            _:R ->
                ?ERROR_MSG("error R:~w, Stack:~p~n",[R, erlang:get_stacktrace()]),
                error
        end).

-define(DO_HANDLE_CALL(Req, From, State),
        try 
            begin
                do_handle_call(Req, From, State)
            end             
        catch _:R ->
                lager:error("do_handle_call crash R:~w, Stack:~p~n", [R, erlang:get_stacktrace()]),
                {reply, error, State}
        end).

-define(DO_HANDLE_CAST(Req, State),
        try 
            begin
                do_handle_cast(Req, State)
            end
        catch _:R ->
                lager:error("do_handle_call crash R:~w, Stack:~p~n", [R, erlang:get_stacktrace()]),
                {noreply, State}
        end).

-define(DO_HANDLE_INFO(Req, State),
        try 
            begin
                do_handle_info(Req, State)
            end             
        catch _:R ->
                lager:error("do_handle_call crash R:~w, Stack:~p~n", [R, erlang:get_stacktrace()]),
                {noreply, State}
        end).






-endif.

