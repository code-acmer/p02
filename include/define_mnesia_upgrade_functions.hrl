-ifndef(DEFINE_MNESIA_UPGRADE_FUNCTIONS_HRL).
-define(DEFINE_MNESIA_UPGRADE_FUNCTIONS_HRL, true).
-record(mnesia_upgrade_conf, {
          get_old_field_fun,
          get_new_field_fun,
          get_default_val_fun = fun(_) ->
                                        undefined
                                end,
          get_field_change_fun = fun(_) -> 
                                         [] 
                                 end,
          get_new_record_name_fun = fun(TableName) -> 
                                            mnesia:table_info(TableName, record_name)
                                    end
         }).
-endif.
