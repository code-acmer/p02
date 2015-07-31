-ifndef(DEFINE_HTTP_91_HRL).
-define(DEFINE_HTTP_91_HRL, true).
%% 引用自官方文档
%% 错误码(0=失败,1=成功(SessionId 有效),2= AppId 无效,3=
%% Act 无效,4=参数无效,5= Sign 无效,11=SessionId 无效)
-define(ACT4_FAIL, 0).
-define(ACT4_SUCCESS, 1).
-define(ACT4_APPID_INVALID, 2).
-define(ACT4_ACT_INVALID, 3).
-define(ACT4_PARAMETER_INVALID, 4).
-define(ACT4_SIGN_INVALID, 5).
-define(ACT4_SESSIONID_INVALID, 11).

-define(ACT4_TONGBU_WRONGPARA, -1).
-define(ACT4_TONGBU_FAILED,     0).
-define(ACT4_TONGBU_SUCCESS,    1).

-define(MI_SESSION_SUCCESS, 200).
-define(MI_SESSION_APPID_INVALID, 1515).
-define(MI_SESSION_UID_INVALID, 1516).
-define(MI_SESSION_SESSION_INVALID, 1520).
-define(MI_SESSION_SIGNATURE_INVALID, 1525).

-define(UC_SESSION_SUCCESS, 1).
-define(UC_SESSION_USER_NOT_LOGIN, 11).
-define(UC_SESSION_PARAM_INVALID, 10).

-define(DL_SESSION_SUCCESS, 0).
-define(DL_SESSION_NULL, 220).
-define(DL_SESSION_ERROR, 221).
-define(DL_SESSION_TIMEOUT, 222).


-endif.




