/*
## API Plans -- Admin and API
## Date Updated 2-15-24 LRW - moved code out of main.tf 
## Date Updated 2-23-24 LRW - added  StorageAccountBlobURI and variables Per Dev Team request.
##
*/

#
##API - PLan 
### Plan-API-DI





resource "azurecaf_name" "apiservice_plan" {
  name          = "API"
  resource_type = "azurerm_app_service_plan"
  suffixes      = [var.application_name, var.environment, var.location_pri]
}

resource "azurerm_service_plan" "apiservice_plan" {
  name                   = azurecaf_name.apiservice_plan.result
  location               = var.location_pri
  os_type                = "Windows"
  worker_count           = var.reportingservice_plan_instances
  resource_group_name    = var.resource_group_pri
  sku_name               = var.apiservice_plan_sku
  zone_balancing_enabled = true

  tags = {
    "environment"      = var.environment
    "application-name" = var.application_name
  }
}


resource "azurecaf_name" "apiservice" {
  name          = "API"
  resource_type = "azurerm_app_service"
  suffixes      = [var.application_name, var.environment, var.location_pri]
}


resource "azurerm_windows_web_app" "apiservice" {
  app_settings = local.application_settings_local 
  ## local.application_settings_local is created in API.TF at the top.


  client_affinity_enabled       = true
  https_only                    = true
  location                      = var.location_pri
  name                          = azurecaf_name.apiservice.result
  resource_group_name           = var.resource_group_pri
  service_plan_id               = azurerm_service_plan.apiservice_plan.id
  virtual_network_subnet_id     = azurerm_subnet.api_integration_subnet.id #Find the Subnet Duplication.
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
    scm_minimum_tls_version = "1.2"
    use_32_bit_worker       = false
    vnet_route_all_enabled  = true
    application_stack {
      current_stack  = "dotnet"
      dotnet_version = "v4.0"
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
