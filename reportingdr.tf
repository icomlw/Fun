
/*
## Reporting API Plan
## Date Updated 2-15-24 LRW - moved code out of main.tf 
##
*/

resource "azurecaf_name" "reportapiservice_plan_dr" {
  name          = "ReportAPI"
  resource_type = "azurerm_app_service_plan"
  suffixes      = [var.application_name, var.environment, var.location_dr]
}

resource "azurerm_service_plan" "reportapiservice_plan_dr" {
  location            = var.location_dr
  name                = azurecaf_name.reportapiservice_plan_dr.result
  os_type             = "Windows"
  resource_group_name = var.resource_group_dr
  #zone_balancing_enabled = var.zonal
  worker_count = var.reportingservice_plan_instances
  sku_name = var.reportingservice_plan_sku
  #Created a SKU in Variables 2-2-24.
  tags = {
    "environment"      = var.environment
    "application-name" = var.application_name
  }
}

#Reporting
#reportingservice_plan_instances = 1
#reportingservice_plan_sku = "P1v3"
#reportingservice_plan_zonal = false 


resource "azurecaf_name" "reportapiservice_dr" {
  name          = "ReportAPI"
  resource_type = "azurerm_app_service"
  suffixes      = [var.application_name, var.environment, var.location_dr]
}

resource "azurerm_windows_web_app" "reportapiservice_dr" {
  app_settings = local.application_settings_local 
  ## local.application_settings_local is created in API.TF at the top.


  client_affinity_enabled       = true
  https_only                    = true
  location                      = var.location_dr
  name                          = azurecaf_name.reportapiservice_dr.result
  resource_group_name           = var.resource_group_dr
  service_plan_id               = azurerm_service_plan.reportapiservice_plan_dr.id
  virtual_network_subnet_id     = azurerm_subnet.sec_app_integration_subnet.id
  public_network_access_enabled = true
  connection_string {
    name  = "RWAzureSQLDB"
    type  = "SQLAzure"
    value = "Server=tcp:${azurerm_mssql_server.database_server_dr.name}.database.windows.net,1433;Database=${azurerm_mssql_database.database.name};ApplicationIntent=ReadWrite;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;Authentication='Active Directory Default';"
  }
  connection_string {
    name  = "ROAzureSQLDB"
    type  = "SQLAzure"
    value = "Server=tcp:${azurerm_mssql_server.database_server_dr.name}.database.windows.net,1433;Database=${azurerm_mssql_database.database.name};ApplicationIntent=ReadOnly;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;Authentication='Active Directory Default';"
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




#AdminAPI Plan
resource "azurecaf_name" "admin-apiservice_dr" {
  name          = "ADMIN"
  resource_type = "azurerm_app_service"
  suffixes      = [var.application_name, var.environment, var.location_dr]
}


resource "azurerm_windows_web_app" "admin-apiservice_dr" {
  app_settings = local.application_settings_local 
  ## local.application_settings_local is created in API.TF at the top.

  client_affinity_enabled = true
  https_only              = true
  location                = var.location_dr
  name                    = azurecaf_name.admin-apiservice_dr.result
  resource_group_name     = var.resource_group_dr
  ##
  #service_plan_id               = azurerm_service_plan.apiservice_plan.id
  #irtual_network_subnet_id     = azurerm_subnet.api_integration_subnet.id #Find the Subnet Duplication.
  ### Change the ServicePlan ID and Virtual Network. 
  service_plan_id               = azurerm_service_plan.reportapiservice_plan_dr.id
  virtual_network_subnet_id     = azurerm_subnet.sec_app_integration_subnet.id
  public_network_access_enabled = true
  connection_string {
    name  = "RWAzureSQLDB"
    type  = "SQLAzure"
    value = "Server=tcp:${azurerm_mssql_server.database_server_dr.name}.database.windows.net,1433;Database=${azurerm_mssql_database.database.name};ApplicationIntent=ReadWrite;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;Authentication='Active Directory Default';"
  }
  connection_string {
    name  = "ROAzureSQLDB"
    type  = "SQLAzure"
    value = "Server=tcp:${azurerm_mssql_server.database_server_dr.name}.database.windows.net,1433;Database=${azurerm_mssql_database.database.name};ApplicationIntent=ReadOnly;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;Authentication='Active Directory Default';"
    #ApplicationIntent=ReadOnly or ReadWrite

  }

  identity {
    type = "SystemAssigned"
  }
  site_config {
    scm_minimum_tls_version = "1.2"
    use_32_bit_worker       = false
    vnet_route_all_enabled  = true
    http2_enabled           = true
    application_stack {
      current_stack  = "dotnet"
      dotnet_version = "v6.0"
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



