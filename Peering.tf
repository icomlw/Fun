
resource "azurecaf_name" "virtual_peering_out" {
  name          = var.application_name
  resource_type = "azurerm_virtual_network_peering"
  suffixes      = [var.environment, var.location_dr]
}

resource "azurecaf_name" "virtual_peering_in" {
  name          = var.application_name
  resource_type = "azurerm_virtual_network_peering"
  suffixes      = [var.environment, var.location_pri]
}

resource "azurerm_virtual_network_peering" "virtual_peering_out" {

  name                 = azurecaf_name.virtual_peering_out.name
  resource_group_name  = var.resource_group_dr
  virtual_network_name = "vnet-DI-Dev-eastUS2"
  #virtual_network_name      = "vnet-${var.application_name}-${var.environment}-${var.location_dr}"
  #tenant_environment = "${var.tenant}_${var.environment}"
  remote_virtual_network_id = "/subscriptions/b249b7be-1190-4b84-9bfb-b6c9274752c7/resourceGroups/rg-di-dev-centralus/providers/Microsoft.Network/virtualNetworks/vnet-DI-Dev-CentralUS"
}

resource "azurerm_virtual_network_peering" "virtual_peering_in" {

  name                 = azurecaf_name.virtual_peering_in.name
  resource_group_name  = var.resource_group_pri
  virtual_network_name = "vnet-DI-Dev-CentralUS"
  #virtual_network_name      = "vnet-${var.application_name}-${var.environment}-${var.location_pri}"
  #remote_virtual_network_id = resource.virtual_network.id 
  remote_virtual_network_id = "/subscriptions/b249b7be-1190-4b84-9bfb-b6c9274752c7/resourceGroups/rg-di-dev-eastus2/providers/Microsoft.Network/virtualNetworks/vnet-DI-Dev-EastUS2"
}



/*
resource "azurerm_virtual_network_peering" "virtual_peering_in" {
  name                = azurecaf_name.virtual_peering_in.result
  resource_group_name = var.resource_group
  #virtual_network_name = azurecaf_name.virtual_network.result
  #remote_virtual_network_id = var.remote_virtual_network
  remote_virtual_network_id = azurecaf_name.virtual_network.result
  virtual_network_name      = var.remote_virtual_network
}
*/

