-ifndef(DEFINE_STORE_RECEIPT_HRL).
-define(DEFINE_STORE_RECEIPT_HRL, true).

-include("db_store_receipt.hrl").
-include("db_base_app_store_product.hrl").
-include("db_pay_info.hrl").

%% app store receipt数据 
%% app store商品list
-define(ETS_STORE_RECEIPT, ets_store_receipt).
-define(ETS_APP_STORE_PRODUCT, ets_app_store_product).

-define(SEND_RECEIPT_NOT_DEAL, 1).
-define(SEND_RECEIPT_DEAL_SUCCESS, 2).
-define(SEND_RECEIPT_DEAL_FAIL, 3).
-define(SEND_RECEIPT_MAX_TIMES, 5).
-define(RESEND_RECEIPT_MILLISECONDS, 5000).

-endif.

