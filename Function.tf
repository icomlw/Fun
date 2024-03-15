/*
## Azure Function App 
## Date Updated 2-15-24 LRW - moved code out of main.tf 
##
*/

resource "azurecaf_name" "funcservice" {
  name          = var.application_name
  resource_type = "azurerm_function_app"
  suffixes      = [var.environment, var.location_pri]
}


##Function App
resource "azurerm_windows_function_app" "funcservice" {
  app_settings = local.application_settings_local 
  ## local.application_settings_local is created in API.TF at the top.


  https_only                    = true
  location                      = var.location_pri
  name                          = azurecaf_name.funcservice.result
  resource_group_name           = var.resource_group_pri
  service_plan_id               = azurerm_service_plan.reportapiservice_plan.id
  virtual_network_subnet_id     = azurerm_subnet.report_integration_subnet.id
  storage_account_name          = azurerm_storage_account.funcstorage.name
  storage_uses_managed_identity = true
  public_network_access_enabled = true

  connection_string {
    name  = "RWAzureSQLDB"
    type  = "SQLAzure"
    value = "Server=tcp:${azurerm_mssql_server.database_server.name}.database.windows.net,1433;Database=${azurerm_mssql_database.database.name};ApplicationIntent=ReadWrite;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;Authentication='Active Directory Default';"
  }
  connection_string {
    name  = "ROAzureSQLDB"
    type  = "SQLAzure"
    value = "Server=tcp:${azurerm_mssql_server.database_server.name}.database.windows.net,1433;Database=${azurerm_mssql_database.database.name};ApplicationIntent=ReadOnly;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;Authentication='Active Directory Default';"
    #ApplicationIntent=ReadOnly or ReadWrite
  }
  identity {
    type = "SystemAssigned"
  }

  site_config {
    always_on                              = true
    scm_minimum_tls_version                = "1.2"
    use_32_bit_worker                      = false
    vnet_route_all_enabled                 = true
    application_insights_connection_string = azurerm_application_insights.appinsights.connection_string
    application_insights_key               = azurerm_application_insights.appinsights.instrumentation_key
    application_stack {
      powershell_core_version = 7.2
    }
    ip_restriction {
      action     = "Allow"
      ip_address = "64.64.193.228/32"
      name       = "VPN Access"
    }
    scm_ip_restriction {
      action     = "Allow"
      ip_address = "64.64.193.228/32"
      name       = "VPN Access"
    }
  }
}

#Storage Account (stfuncdidev)
resource "azurerm_storage_account" "funcstorage" {
  name                            = lower("stfunc${var.application_name}${var.environment}")
  resource_group_name             = var.resource_group_pri
  location                        = var.location_pri
  account_tier                    = "Standard"
  account_kind                    = "StorageV2"
  account_replication_type        = "GRS"
  public_network_access_enabled   = "false"
  default_to_oauth_authentication = "true"
  shared_access_key_enabled       = "true"
  allow_nested_items_to_be_public = "false"
  allowed_copy_scope              = "AAD"

  blob_properties {
    change_feed_enabled = "true"
    #change_feed_retention_in_days = 90
    versioning_enabled       = "true"
    last_access_time_enabled = "true"
    delete_retention_policy {
      days = 31
    }
    #restore_policy {
    #  days = 30
    #}
  }
  tags = {
    Environment = var.environment
  }
}

resource "azurecaf_name" "blob_private_endpoint" {
  name          = "Blob"
  resource_type = "azurerm_private_endpoint"
  suffixes      = [var.application_name, var.environment, var.location_pri]
}

resource "azurerm_private_endpoint" "blob_private_endpoint" {
  name                = azurecaf_name.blob_private_endpoint.result
  location            = var.location_pri
  resource_group_name = var.resource_group_pri
  subnet_id           = azurerm_subnet.backend_subnet.id

  private_service_connection {
    name                           = "private-${azurecaf_name.blob_private_endpoint.result}"
    private_connection_resource_id = azurerm_storage_account.funcstorage.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }
  private_dns_zone_group {
    name                 = "privatelink-${azurecaf_name.blob_private_endpoint.result}"
    private_dns_zone_ids = ["${azurerm_private_dns_zone.privatedns_blob.id}"]
  }
}

### End Create Blob Storage 
###


#Func blob Storage access
resource "azurerm_role_assignment" "funcsqlservice_storage_contributor" {
  scope                = azurerm_storage_account.funcstorage.id
  role_definition_name = "Storage Account Contributor"
  principal_id         = azurerm_windows_function_app.funcservice.identity[0].principal_id
}

resource "azurerm_role_assignment" "funcsqlservice_storage_owner" {
  scope                = azurerm_storage_account.funcstorage.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = azurerm_windows_function_app.funcservice.identity[0].principal_id
}


##end funct blob storage access



