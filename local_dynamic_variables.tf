#used by all the Web_apps for app_setting the dynamic variables

locals {
  application_settings_local = merge(
    {"StorageAccountName" = azurerm_storage_account.appstorage.name},
    {"Updated App_Settings on" = formatdate("MM-DD-YYYY hh:mm:ss ZZZ", timestamp())},
    {"APPINSIGHTS_INSTRUMENTATIONKEY"        = azurerm_application_insights.appinsights.instrumentation_key},
    {"APPLICATIONINSIGHTS_CONNECTION_STRING" = azurerm_application_insights.appinsights.connection_string},
    {"StorageAccountName"                    = azurerm_storage_account.appstorage.name},
    var.application_settings1  # list devined in tvars file.  should be last in the list of this merge.
    )
}


