## Application Insights and Logs
##


## moved to loging
resource "azurecaf_name" "appinsights_dr" {
  name          = var.application_name
  resource_type = "azurerm_application_insights"
  suffixes      = [var.environment, var.location_dr]
}

resource "azurerm_application_insights" "appinsights_dr" {
  name                = azurecaf_name.appinsights_dr.result
  location            = var.location_dr
  resource_group_name = var.resource_group_dr
  application_type    = "web"
  workspace_id        = azurerm_log_analytics_workspace.appsworkspace_dr.id
}

/*
variable "appinsights_instrumentationkey_key" { type = string }

module "appinsite" {
  source = "./modules"
  appinsights_instrumentationkey_key = resource.appinsights.instrumentation_key
  #APPINSIGHTS_INSTRUMENTATIONKEY                  = azurerm_application_insightsresource.appinsights.instrumentation_key
}
*/

resource "azurecaf_name" "appsworkspace_dr" {
  name          = "apps"
  resource_type = "azurerm_log_analytics_workspace"
  suffixes      = [var.application_name, var.environment, var.location_dr]
}

resource "azurerm_log_analytics_workspace" "appsworkspace_dr" {
  name                = azurecaf_name.appsworkspace_dr.result
  location            = var.location_dr
  resource_group_name = var.resource_group_dr
  sku                 = var.appsworkspacesku
  #sku                 = "PerGB2018"
  retention_in_days = 30
}


resource "azurecaf_name" "infraworkspace_dr" {
  name          = "infra"
  resource_type = "azurerm_log_analytics_workspace"
  suffixes      = [var.application_name, var.environment, var.location_dr]
}

resource "azurerm_log_analytics_workspace" "infraworkspace_dr" {
  name                = azurecaf_name.infraworkspace.result
  location            = var.location_dr
  resource_group_name = var.resource_group_dr
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

