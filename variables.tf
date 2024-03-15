/*
## Variables
## Date Updated 2-14-24 LRW - added sql server userid variables
## Date Updated 2-15-24 LRW - added tenant_id
##
*/

#General Global
variable "environment" {
  type        = string
  description = "The environment (dev, test, prod...)"
}

variable "application_name" {
  type        = string
  description = "The name of your application"
}

##Primary 
variable "location_pri" {
  type        = string
  description = "The Primary Azure region where all resources in this example should be created"
}

variable "resource_group_pri" {
  type        = string
  description = "Name of the Primary resource group for the Application"
}

##Primary 
variable "location_dr" {
  type        = string
  description = "The Secondary Azure region where all resources in this example should be created"
}

variable "resource_group_dr" {
  type        = string
  description = "Name of the Secondary resource group for the Application"
}

variable "build_dr" {
  type        = bool
  description = "Build out DR"
  default     = false

}



## Function Variables 

#APPINSIGHTS_INSTRUMENTATIONKEY                  = azurerm_application_insights.appinsights.instrumentation_key

variable "application_settings1" {}
#variable "application_settings_local" {}


## End Function Variables

## Global Variables



variable "reportingservice_plan_sku" {
  type        = string
  description = "The SKU needed to setup ReportAPIService"
}

variable "reportingservice_plan_instances" {
  type    = number
}

variable "reportingservice_plan_zonal" {
  type    = bool
}

variable "apiservice_plan_sku" {
  type        = string
  description = "Api Service SKu"
}

variable "apiservice_plan_instances" {
  type    = number
}

variable "apiservice_plan_zonal" {
  type    = bool
}

#SQL Server Variable Declarations
variable "zonal" {
  type    = bool
  default = false
}

variable "sql_username" {
  type        = string
  description = "Sql Server Admin"
}

variable "sql_username_object_id" {
  type        = string
  description = "Sql Server User Object ID"
  default     = ""

}

variable "sql_db_sku" {
  type        = string
  description = "SQL Database SKU"
}

variable "sql_db_maxsize" {
  type        = number
  description = "SQL Database Max Size"
  default     = 100
}

variable "sql_db_zone_redundant" {
  type    = bool
  default = false
}

variable "sql_group_1" {
  type = string
}

variable "sql_group_2" {
  type = string
}

variable "sql_group_3" {
  type = string
}

variable "sql_group_1_role" {
  type = string
}

variable "sql_group_2_role" {
  type = string
}

variable "sql_group_3_role" {
  type = string
}

variable "sql_user_1" {
  type = string
}

variable "sql_user_1_role" {
  type = string
}

#End SQL Variables

#storage variables

variable "apiservice_dr" { type = string }
##variable "app_storage_container_2" {type = string}
##variable "app_storage_container_3" {type = string}
##variable "app_storage_container_4" {type = string}

##variable "func_storage_container_1" {type = string}
##variable "func_storage_container_2" {type = string}
##variable "func_storage_container_3" {type = string}
##variable "func_storage_container_4" {type = string}

variable "appsworkspacesku" {
  type    = string
  default = "not_set_properly"
}




###Primary Networks Primary
variable "address_space" {
  type        = string
  description = "VNet address space"
}

variable "rep_integration_subnet_prefix" {
  type        = string
  description = "Report network subnet"
}

variable "build_subnet_prefix" {
  type        = string
  description = "Build network subnet"
}

variable "api_integration_subnet_prefix" {
  type        = string
  description = "API Integration network subnet"
}

variable "backend_subnet_prefix" {
  type        = string
  description = "Backend network subnet"
}

variable "frontend_subnet_prefix" {
  type        = string
  description = "Frontend network subnet"
}

variable "app_integration_subnet_prefix" {
  type        = string
  description = "APP Integration network subnet"
}


###Secondary Networks Secondary
variable "sec_address_space" {
  type        = string
  description = "VNet address space"
}

variable "sec_rep_integration_subnet_prefix" {
  type        = string
  description = "Report network subnet"
}

variable "sec_build_subnet_prefix" {
  type        = string
  description = "Build network subnet"
}

variable "sec_api_integration_subnet_prefix" {
  type        = string
  description = "API Integration network subnet"
}

variable "sec_backend_subnet_prefix" {
  type        = string
  description = "Backend network subnet"
}

variable "sec_frontend_subnet_prefix" {
  type        = string
  description = "Frontend network subnet"
}

variable "sec_app_integration_subnet_prefix" {
  type        = string
  description = "APP Integration network subnet"
}
