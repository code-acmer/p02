-ifndef(DEFINE_FLASH_HRL).
-define(DEFINE_FLASH_HRL, true).

%% flash843安全沙箱
-define(FL_POLICY_REQ, <<"<polic">>).
-define(FL_POLICY_FILE,
        <<"<cross-domain-policy><allow-access-from domain='*' to-ports='*' /></cross-domain-policy>">>).

-endif.

