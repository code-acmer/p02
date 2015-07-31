-module(mails_version).
-behaviour(db_version).
-export([current_version/0, version/1]).
current_version() ->
    3.

version(1) ->
    [{id,0},{version,1},{player_id,0},{type,0},{state,0},{timestamp,0},{sname,0},{splayer_id,0},{title,[]},{content,[]},{attachment1,{}},{attachment2,{}},{attachment3,{}},{attachment4,{}},{attachment5,{}}];
version(2) ->
    [{id,0},{version,2},{player_id,0},{type,0},{state,0},{timestamp,0},{sname,0},{splayer_id,0},{title,[]},{content,[]},{attachment,[]}];
version(3) ->
    [{id,0},{version,3},{player_id,0},{type,0},{state,0},{timestamp,0},{sname,0},{splayer_id,0},{title,[]},{content,[]},{base_id,undefined},{args,[]},{attachment,[]}];
version(Version) ->
    throw({version_error, Version}).
