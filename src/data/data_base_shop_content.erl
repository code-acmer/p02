%% coding: utf-8
%% Warning:本文件由data_generate自动生成，请不要手动修改
-module(data_base_shop_content).
-export([get/1]).
-export([all/0]).
-include("common.hrl").
-include("db_base_shop_content.hrl").
get(100) ->
#base_shop_content{shop_id = 100,content = 8};
get(200) ->
#base_shop_content{shop_id = 200,content = 8};
get(300) ->
#base_shop_content{shop_id = 300,content = 8};
get(401) ->
#base_shop_content{shop_id = 401,content = 16};
get(402) ->
#base_shop_content{shop_id = 402,content = 16};
get(403) ->
#base_shop_content{shop_id = 403,content = 16};
get(404) ->
#base_shop_content{shop_id = 404,content = 16};
get(405) ->
#base_shop_content{shop_id = 405,content = 16};
get(406) ->
#base_shop_content{shop_id = 406,content = 16};
get(407) ->
#base_shop_content{shop_id = 407,content = 16};
get(408) ->
#base_shop_content{shop_id = 408,content = 16};
get(409) ->
#base_shop_content{shop_id = 409,content = 16};
get(410) ->
#base_shop_content{shop_id = 410,content = 16};
get(411) ->
#base_shop_content{shop_id = 411,content = 16};
get(412) ->
#base_shop_content{shop_id = 412,content = 16};
get(413) ->
#base_shop_content{shop_id = 413,content = 16};
get(Var1) -> ?WARNING_MSG("get not find ~p", [{Var1}]),
[].

all() ->
[100,200,300,401,402,403,404,405,406,407,408,409,410,411,412,413].
