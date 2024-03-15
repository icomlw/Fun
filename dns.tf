##
resource "azurerm_private_dns_zone" "privatedns_sql" {
  name                = "privatelink.database.windows.net"
  resource_group_name = var.resource_group_pri
}

resource "azurerm_private_dns_zone" "privatedns_blob" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = var.resource_group_pri
}

resource "azurerm_private_dns_zone" "privatedns_vault" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = var.resource_group_pri
}

resource "azurerm_private_dns_zone" "privatedns_sites" {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = var.resource_group_pri
}


resource "azurerm_private_dns_zone_virtual_network_link" "link_sql" {
  name                  = "example-link"
  resource_group_name   = var.resource_group_pri
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_sql.name
  virtual_network_id    = azurerm_virtual_network.virtual_network.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "link_blob" {
  name                  = "example-link"
  resource_group_name   = var.resource_group_pri
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_blob.name
  virtual_network_id    = azurerm_virtual_network.virtual_network.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "link_vault" {
  name                  = "example-link"
  resource_group_name   = var.resource_group_pri
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_vault.name
  virtual_network_id    = azurerm_virtual_network.virtual_network.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "link_sites" {
  name                  = "example-link"
  resource_group_name   = var.resource_group_pri
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_sites.name
  virtual_network_id    = azurerm_virtual_network.virtual_network.id
}