%%%-------------------------------------------------------------------
%%% @author Zhangr <zhangr011@gmail.com>
%%% @copyright (C) 2013, Zhangr
%%% @doc
%%%
%%% @end
%%% Created :  6 Nov 2013 by Zhangr <zhangr011@gmail.com>
%%%-------------------------------------------------------------------
-module(mod_player_rec_test).

-compile(export_all).

-include_lib("eunit/include/eunit.hrl").
-include("define_player.hrl").

player_rec_test() ->
    mod_player_recommened:start_link(),
    mod_player_recommened:update(#player{id=10111,lv=6}),
    timer:sleep(100),
    ?assertMatch([#player{id=10111,lv=6}], mod_player_recommened:query_recommened(2, 6)),        
    ?assertMatch([], mod_player_recommened:query_recommened(2, 60)).

        
