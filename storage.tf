/*
## Azure Storage
## Date Updated 2-15-24 LRW - moved code out of main.tf 
##
*/


#Storage Account (picStorage)
resource "azurerm_storage_account" "appstorage" {
  name                            = lower("stimages${var.application_name}${var.environment}")
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


/*
resource "azapi_resource" "container" {
  type      = "Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01"
  name      = var.apiservice_dr
  parent_id = "${azurerm_storage_account.appstorage.id}/blobServices/default"
  body = jsonencode({
    properties = {
    }
  })
}

*/


resource "azurecaf_name" "app_private_endpoint" {
  name          = "app"
  resource_type = "azurerm_private_endpoint"
  suffixes      = [var.application_name, var.environment, var.location_pri]
}


resource "azurerm_private_endpoint" "app_private_endpoint" {
  name                = azurecaf_name.app_private_endpoint.result
  location            = var.location_pri
  resource_group_name = var.resource_group_pri
  subnet_id           = azurerm_subnet.backend_subnet.id

  private_service_connection {
    name                           = "private-${azurecaf_name.app_private_endpoint.result}"
    private_connection_resource_id = azurerm_storage_account.appstorage.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }
  private_dns_zone_group {
    name                 = "privatelink-${azurecaf_name.app_private_endpoint.result}"
    private_dns_zone_ids = ["${azurerm_private_dns_zone.privatedns_blob.id}"]
  }
}
### Create Blob Storage 
###


## app blob storage access Added 2-16-24

resource "azurerm_role_assignment" "appblob_storage_role1_owner" {
  scope                = azurerm_storage_account.appstorage.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = azurerm_windows_web_app.admin-apiservice.identity[0].principal_id
}

resource "azurerm_role_assignment" "appblob_storage_role2_owner" {
  scope                = azurerm_storage_account.appstorage.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = azurerm_windows_web_app.reportapiservice.identity[0].principal_id
}

resource "azurerm_role_assignment" "appblob_storage_role3_owner" {
  scope                = azurerm_storage_account.appstorage.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = azurerm_windows_function_app.funcservice.identity[0].principal_id
}

resource "azurerm_role_assignment" "appblob_storage_role4_owner" {
  scope                = azurerm_storage_account.appstorage.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = azurerm_windows_web_app.apiservice.identity[0].principal_id
}

resource "azurerm_role_assignment" "appblob_storage_role1_contributor" {
  scope                = azurerm_storage_account.appstorage.id
  role_definition_name = "Storage Account Contributor"
  principal_id         = azurerm_windows_web_app.admin-apiservice.identity[0].principal_id
}

resource "azurerm_role_assignment" "appblob_storage_role2_contributor" {
  scope                = azurerm_storage_account.appstorage.id
  role_definition_name = "Storage Account Contributor"
  principal_id         = azurerm_windows_web_app.reportapiservice.identity[0].principal_id
}

resource "azurerm_role_assignment" "appblob_storage_role3_contributor" {
  scope                = azurerm_storage_account.appstorage.id
  role_definition_name = "Storage Account Contributor"
  principal_id         = azurerm_windows_function_app.funcservice.identity[0].principal_id
}

resource "azurerm_role_assignment" "appblob_storage_role4_contributor" {
  scope                = azurerm_storage_account.appstorage.id
  role_definition_name = "Storage Account Contributor"
  principal_id         = azurerm_windows_web_app.apiservice.identity[0].principal_id
}


##End App Blob Storage access