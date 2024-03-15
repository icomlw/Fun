## Create SQL TF
##SQL Server Build Primary Zone
##

resource "azurecaf_name" "database_server" {
  name          = var.application_name
  resource_type = "azurerm_mssql_server"
  suffixes      = [var.environment, var.location_pri]
}

resource "azurerm_mssql_server" "database_server" {
  name                          = azurecaf_name.database_server.result
  resource_group_name           = var.resource_group_pri
  location                      = var.location_pri
  version                       = "12.0"
  minimum_tls_version           = "1.2"
  public_network_access_enabled = false



  azuread_administrator {
    login_username = var.sql_username
    object_id      = var.sql_username_object_id
    #Variable above - object_id      = "e09c3311-a77f-40c8-8453-6cead7ea66a8"
    azuread_authentication_only = true
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    "environment"      = var.environment
    "application-name" = var.application_name
  }
}

resource "azurecaf_name" "database" {
  name          = var.application_name
  resource_type = "azurerm_mssql_database"
  suffixes      = [var.environment, var.location_pri]
}

resource "azurerm_mssql_database" "database" {
  name                                = azurecaf_name.database.result
  server_id                           = azurerm_mssql_server.database_server.id
  sku_name                            = var.sql_db_sku
  transparent_data_encryption_enabled = true
  max_size_gb                         = var.sql_db_maxsize
  zone_redundant                      = var.sql_db_zone_redundant
  storage_account_type                = "Geo"
  read_scale                          = true
  tags = {
    "environment"      = var.environment
    "application-name" = var.application_name
  }
}


resource "azurecaf_name" "sql_private_endpoint" {
  name          = "SQL"
  resource_type = "azurerm_private_endpoint"
  suffixes      = [var.application_name, var.environment, var.location_pri]
}

resource "azurerm_private_endpoint" "sql_private_endpoint" {
  name                = azurecaf_name.sql_private_endpoint.result
  location            = var.location_pri
  resource_group_name = var.resource_group_pri
  subnet_id           = azurerm_subnet.backend_subnet.id

  private_service_connection {
    name                           = "private-${azurecaf_name.sql_private_endpoint.result}"
    private_connection_resource_id = azurerm_mssql_server.database_server.id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "privatelink-${azurecaf_name.sql_private_endpoint.result}"
    private_dns_zone_ids = ["${azurerm_private_dns_zone.privatedns_sql.id}"]
  }

  depends_on = [azurerm_private_dns_zone_virtual_network_link.link_sql]
}




/* Drag along with SQL Code***************
resource "azurerm_monitor_diagnostic_setting" "appsqldiagnostic" {
  name                       = "SQL_Auditing"
  target_resource_id         = "${azurerm_mssql_server.database_server.id}/databases/master"
  log_analytics_workspace_id = var.log_analytics_infra_id

  enabled_log {
    #category = "SQLSecurityAuditEvents"
    category_group = "allLogs"
  }

  metric {
    category = "AllMetrics"
  }

  lifecycle {
    ignore_changes = [log, metric]
  }
depends_on = [ azurerm_mssql_database.database1 ]
}

resource "azurerm_mssql_database_extended_auditing_policy" "app_databasemaster_audit" {
  database_id            = "${azurerm_mssql_server.database_server.id}/databases/master"
  log_monitoring_enabled = true
  depends_on = [ azurerm_monitor_diagnostic_setting.appsqldiagnostic ]
}

resource "azurerm_mssql_database_extended_auditing_policy" "app_database1_audit" {
  database_id            = azurerm_mssql_database.database1.id
  log_monitoring_enabled = true
  depends_on = [ azurerm_monitor_diagnostic_setting.appsqldiagnostic ]
}

resource "azurerm_mssql_database_extended_auditing_policy" "app_database2_audit" {
  database_id            = azurerm_mssql_database.database2.id
  log_monitoring_enabled = true
  depends_on = [ azurerm_monitor_diagnostic_setting.appsqldiagnostic ]
}

resource "azurerm_mssql_server_extended_auditing_policy" "server_audit" {
  server_id              = azurerm_mssql_server.database_server.id
  log_monitoring_enabled = true
  depends_on = [ azurerm_monitor_diagnostic_setting.appsqldiagnostic ]
}
*/

