/*
## keyvaults and then permissions for keyvaults
## Date Updated 2-15-24 LRW - moved code out of main.tf 
##
*/

resource "azurecaf_name" "vault" {
  name          = var.application_name
  resource_type = "azurerm_key_vault"
  suffixes      = [var.environment, var.location_pri]
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "vault" {
  name                          = azurecaf_name.vault.result
  location                      = var.location_pri
  resource_group_name           = var.resource_group_pri
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  sku_name                      = "standard"
  soft_delete_retention_days    = 7
  public_network_access_enabled = "false"
  enable_rbac_authorization     = "true"
}

resource "azurecaf_name" "vault_private_endpoint" {
  name          = "Vault"
  resource_type = "azurerm_private_endpoint"
  suffixes      = [var.application_name, var.environment, var.location_pri]
}

resource "azurerm_private_endpoint" "vault_private_endpoint" {
  name                = azurecaf_name.vault_private_endpoint.result
  location            = var.location_pri
  resource_group_name = var.resource_group_pri
  subnet_id           = azurerm_subnet.backend_subnet.id

  private_service_connection {
    name                           = "private-${azurecaf_name.vault_private_endpoint.result}"
    private_connection_resource_id = azurerm_key_vault.vault.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }
  private_dns_zone_group {
    name                 = "privatelink-${azurecaf_name.vault_private_endpoint.result}"
    private_dns_zone_ids = ["${azurerm_private_dns_zone.privatedns_vault.id}"]
  }
}

## End Keyvault Creation


#Keyvault secrets Access
resource "azurerm_role_assignment" "vault_role1" {
  scope                = azurerm_key_vault.vault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_windows_web_app.admin-apiservice.identity[0].principal_id
}

resource "azurerm_role_assignment" "vault_role2" {
  scope                = azurerm_key_vault.vault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_windows_web_app.reportapiservice.identity[0].principal_id
}

resource "azurerm_role_assignment" "vault_role3" {
  scope                = azurerm_key_vault.vault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_windows_function_app.funcservice.identity[0].principal_id
}

resource "azurerm_role_assignment" "vault_role4" {
  scope                = azurerm_key_vault.vault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_windows_web_app.apiservice.identity[0].principal_id
}

## End keyvault Access