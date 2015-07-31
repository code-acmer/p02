-module(radar_msg_version).
-behaviour(db_version).
-export([current_version/0, version/1]).
current_version() ->
    3.

version(1) ->
    [{player_id,undefined},{version,1},{accuracy_thousand,undefined},{accuracy_five_hundred,undefined},{accuracy_two_hundred,undefined},{longitude,undefined},{latitude,undefined},{player_state,0}];

version(2) ->
    [{player_id,undefined},{version,2},{accuracy_thousand,undefined},{accuracy_five_hundred,undefined},{accuracy_two_hundred,undefined},{thousand_str_list,[]},{five_hundred_str_list,[]},{two_hundred_str_list,[]},{longitude,undefined},{latitude,undefined},{player_state,0}];

version(3) ->
[{player_id,undefined},{version,3},{accuracy_thousand,undefined},{accuracy_five_hundred,undefined},{accuracy_two_hundred,undefined},{longitude,undefined},{latitude,undefined},{player_state,0}];

version(Version) ->
    throw({version_error, Version}).
