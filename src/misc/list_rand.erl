%% 本数据结构大概目的，维护大规模数据选取小范围来随机，并定长维护，剔除老数据
-module(list_rand).

-export([new/0, new/2, 
         cur/1, cur/2, 
         in/2]).

-define(SIZE, 5000).
-define(CHOOSE_COUNT, 5).

-record(list_rand,{
          max_size = ?SIZE,
          size = 0,
          every_count = ?CHOOSE_COUNT,
          all_list = queue:new(),
          rest_list = []
         }).
new() ->
    new(?SIZE, ?CHOOSE_COUNT).

new(MaxSize, Count) ->
    #list_rand{
       max_size = MaxSize,
       every_count = Count
      }.

%% cur(#list_rand{
%%        all_list = Q,
%%        rest_list = []
%%       } = ListRand) ->
%%     case queue:is_empty(Q) of
%%         true ->
%%             {[], ListRand};
%%         false ->
%%             cur(ListRand#list_rand{
%%                   rest_list = lists:reverse(queue:to_list(Q))
%%                  })
%%     end;

cur(#list_rand{
       every_count = EveryCount
      } = ListRand) ->
    cur(ListRand, EveryCount).

cur(#list_rand{
       all_list = Q,
       rest_list = []
      } = ListRand, Num) ->
    case queue:is_empty(Q) of
        true ->
            {[], ListRand};
        false ->
            cur(ListRand#list_rand{
                  rest_list = lists:reverse(queue:to_list(Q))
                 }, Num)
    end;

cur(#list_rand{
       rest_list = RestList
      } = ListRand, Num) ->
    {OutList, NewRestList} = split(Num, RestList),
    {OutList, ListRand#list_rand{
                rest_list = NewRestList
               }}.
    
            
in(X, #list_rand{
         size = Size,
         all_list = Q
        } = ListRand) ->
    out(ListRand#list_rand{
          size = Size + 1,
          all_list = queue:in(X, Q)
         }).

out(#list_rand{
       max_size = MaxSize,
       size = Size,
       all_list = Q
      } = ListRand) 
  when Size > MaxSize ->
    out(ListRand#list_rand{
          size = Size - 1,
          all_list = element(2, queue:out(Q))
         });
out(ListRand) ->
    ListRand.

split(N, List) ->
    split(N, List, []).

split(_, [], R) ->
    {R, []};
split(0, L, R) ->
    {R, L};
split(N, [H|T], R) ->
    split(N-1, T, [H|R]).
