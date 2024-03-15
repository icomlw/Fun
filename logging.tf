## Application Insights and Logs
##


## moved to loging
resource "azurecaf_name" "appinsights" {
  name          = var.application_name
  resource_type = "azurerm_application_insights"
  suffixes      = [var.environment, var.location_pri]
}

resource "azurerm_application_insights" "appinsights" {
  name                = azurecaf_name.appinsights.result
  location            = var.location_pri
  resource_group_name = var.resource_group_pri
  application_type    = "web"
  workspace_id        = azurerm_log_analytics_workspace.appsworkspace.id
}

/*
variable "appinsights_instrumentationkey_key" { type = string }

module "appinsite" {
  source = "./modules"
  appinsights_instrumentationkey_key = resource.appinsights.instrumentation_key
  #APPINSIGHTS_INSTRUMENTATIONKEY                  = azurerm_application_insightsresource.appinsights.instrumentation_key
}
*/

resource "azurecaf_name" "appsworkspace" {
  name          = "apps"
  resource_type = "azurerm_log_analytics_workspace"
  suffixes      = [var.application_name, var.environment, var.location_pri]
}

resource "azurerm_log_analytics_workspace" "appsworkspace" {
  name                = azurecaf_name.appsworkspace.result
  location            = var.location_pri
  resource_group_name = var.resource_group_pri
  sku                 = var.appsworkspacesku
  #sku                 = "PerGB2018"
  retention_in_days = 30
}


resource "azurecaf_name" "infraworkspace" {
  name          = "infra"
  resource_type = "azurerm_log_analytics_workspace"
  suffixes      = [var.application_name, var.environment, var.location_pri]
}

resource "azurerm_log_analytics_workspace" "infraworkspace" {
  name                = azurecaf_name.infraworkspace.result
  location            = var.location_pri
  resource_group_name = var.resource_group_pri
  sku                 = "PerGB2018"
  retention_in_days   = 30
}


