/*
## Networks and DNS File
## Date Updated 2-15-24 LRW - moved code out of main.tf 
##
*/

#done
resource "azurecaf_name" "virtual_network" {
  name          = var.application_name
  resource_type = "azurerm_virtual_network"
  suffixes      = [var.environment, var.location_pri]
}

resource "azurerm_virtual_network" "virtual_network" {
  name                = azurecaf_name.virtual_network.result
  address_space       = [var.address_space]
  location            = var.location_pri
  resource_group_name = var.resource_group_pri

  tags = {
    "environment"      = var.environment
    "application-name" = var.application_name
  }
}

#done
resource "azurecaf_name" "app_integration_subnet" {
  name          = var.application_name
  resource_type = "azurerm_subnet"
  suffixes      = [var.environment, "appintegration"]
}


resource "azurerm_subnet" "app_integration_subnet" {
  name                                      = azurecaf_name.app_integration_subnet.result
  resource_group_name                       = var.resource_group_pri
  virtual_network_name                      = azurerm_virtual_network.virtual_network.name
  address_prefixes                          = [var.app_integration_subnet_prefix]
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
resource "azurecaf_name" "api_integration_subnet" {
  name          = var.application_name
  resource_type = "azurerm_subnet"
  suffixes      = [var.environment, "apiintegration"]
}

resource "azurerm_subnet" "api_integration_subnet" {
  name                                      = azurecaf_name.api_integration_subnet.result
  resource_group_name                       = var.resource_group_pri
  virtual_network_name                      = azurerm_virtual_network.virtual_network.name
  address_prefixes                          = [var.api_integration_subnet_prefix]
  private_endpoint_network_policies_enabled = false

  delegation {
    name = "delegation"

    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}


resource "azurecaf_name" "report_integration_subnet" {
  name          = var.application_name
  resource_type = "azurerm_subnet"
  suffixes      = [var.environment, "rep_integration"]
}

resource "azurerm_subnet" "report_integration_subnet" {
  name                                      = azurecaf_name.report_integration_subnet.result
  resource_group_name                       = var.resource_group_pri
  virtual_network_name                      = azurerm_virtual_network.virtual_network.name
  address_prefixes                          = [var.rep_integration_subnet_prefix]
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
resource "azurecaf_name" "backend_subnet" {
  name          = var.application_name
  resource_type = "azurerm_subnet"
  suffixes      = [var.environment, "backend"]
}

#Done azurecaf
resource "azurerm_subnet" "backend_subnet" {
  name                                      = azurecaf_name.backend_subnet.result
  resource_group_name                       = var.resource_group_pri
  virtual_network_name                      = azurerm_virtual_network.virtual_network.name
  address_prefixes                          = [var.backend_subnet_prefix]
  private_endpoint_network_policies_enabled = false
}

/*
resource "azurecaf_name" "frontend_subnet" {
  name          = var.application_name
  resource_type = "azurerm_subnet"
  suffixes      = [var.environment, "frontend"]
}

resource "azurerm_subnet" "frontend_subnet" {
  name                 = azurecaf_name.frontend_subnet.result
  resource_group_name  = var.resource_group_pri
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = [var.frontend_subnet_prefix]
  private_endpoint_network_policies_enabled = false
}
*/

#done
resource "azurecaf_name" "build_subnet" {
  name          = var.application_name
  resource_type = "azurerm_subnet"
  suffixes      = [var.environment, "build"]
}

resource "azurerm_subnet" "build_subnet" {
  name                                      = azurecaf_name.build_subnet.result
  resource_group_name                       = var.resource_group_pri
  virtual_network_name                      = azurerm_virtual_network.virtual_network.name
  address_prefixes                          = [var.build_subnet_prefix]
  private_endpoint_network_policies_enabled = false
}


