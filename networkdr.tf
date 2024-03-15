/*
## Networks and DNS File
## Date Updated 2-15-24 LRW - moved code out of main.tf 
##
*/

###Adjust DNS
###Adjust Resource Groups for Primary and Secondary.check "name" {
##  

#done
resource "azurecaf_name" "sec_virtual_network" {
  name          = var.application_name
  resource_type = "azurerm_virtual_network"
  suffixes      = [var.environment, var.location_dr]
}

resource "azurerm_virtual_network" "sec_virtual_network" {
  name                = azurecaf_name.sec_virtual_network.result
  address_space       = [var.sec_address_space]
  location            = var.location_dr
  resource_group_name = var.resource_group_dr

  tags = {
    "environment"      = var.environment
    "application-name" = var.application_name
  }
}

#done
resource "azurecaf_name" "sec_app_integration_subnet" {
  name          = var.application_name
  resource_type = "azurerm_subnet"
  suffixes      = [var.environment, "appintegration"]
}

resource "azurerm_subnet" "sec_app_integration_subnet" {

  name                                      = azurecaf_name.sec_app_integration_subnet.result
  resource_group_name                       = var.resource_group_dr
  virtual_network_name                      = azurerm_virtual_network.sec_virtual_network.name
  address_prefixes                          = [var.sec_app_integration_subnet_prefix]
  private_endpoint_network_policies_enabled = false

  delegation {
    name = "delegation"

    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}


#done
resource "azurecaf_name" "sec_api_integration_subnet" {
  name          = var.application_name
  resource_type = "azurerm_subnet"
  suffixes      = [var.environment, "apiintegration"]
}

resource "azurerm_subnet" "sec_api_integration_subnet" {

  name                                      = azurecaf_name.sec_api_integration_subnet.result
  resource_group_name                       = var.resource_group_dr
  virtual_network_name                      = azurerm_virtual_network.sec_virtual_network.name
  address_prefixes                          = [var.sec_api_integration_subnet_prefix]
  private_endpoint_network_policies_enabled = false

  delegation {
    name = "delegation"

    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}


resource "azurecaf_name" "sec_report_integration_subnet" {
  name          = var.application_name
  resource_type = "azurerm_subnet"
  suffixes      = [var.environment, "rep_integration"]
}

resource "azurerm_subnet" "sec_report_integration_subnet" {

  name                                      = azurecaf_name.sec_report_integration_subnet.result
  resource_group_name                       = var.resource_group_dr
  virtual_network_name                      = azurerm_virtual_network.sec_virtual_network.name
  address_prefixes                          = [var.sec_rep_integration_subnet_prefix]
  private_endpoint_network_policies_enabled = false

  delegation {
    name = "delegation"

    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}


#Done
resource "azurecaf_name" "sec_backend_subnet" {
  name          = var.application_name
  resource_type = "azurerm_subnet"
  suffixes      = [var.environment, "backend"]
}

#Done azurecaf
resource "azurerm_subnet" "sec_backend_subnet" {

  name                                      = azurecaf_name.sec_backend_subnet.result
  resource_group_name                       = var.resource_group_dr
  virtual_network_name                      = azurerm_virtual_network.sec_virtual_network.name
  address_prefixes                          = [var.sec_backend_subnet_prefix]
  private_endpoint_network_policies_enabled = false
}

#done
resource "azurecaf_name" "sec_build_subnet" {
  name          = var.application_name
  resource_type = "azurerm_subnet"
  suffixes      = [var.environment, "build"]
}

resource "azurerm_subnet" "sec_build_subnet" {

  name                                      = azurecaf_name.sec_build_subnet.result
  resource_group_name                       = var.resource_group_dr
  virtual_network_name                      = azurerm_virtual_network.sec_virtual_network.name
  address_prefixes                          = [var.sec_build_subnet_prefix]
  private_endpoint_network_policies_enabled = false
}



