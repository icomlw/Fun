/*
## Providers
## Date Updated 2-15-24 LRW - added betr-io/mssql.
    This provides resources to add and remove users to mssql
##
*/


terraform {
  required_providers {
    azurecaf = {
      source = "aztfmod/azurecaf"
    }
    azurerm = {
      source = "hashicorp/azurerm"
    }
    mssql = {
      source  = "betr-io/mssql"
      version = "0.3.0"
      ##Built into Terraform
      ##Used to update user permissions on SQL servers and databases.
      ##Amoung other things.
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "=1.6.0"
      ##Read Azure AD.
      ## Used to update/Create Groups and userid's
    }
    azapi = {
      source = "Azure/azapi"
    }

  }
}

provider "azapi" {}


provider "azurerm" {
  skip_provider_registration = true
  features {}
}

/*
## Investigate Providers below for future usage requirements.check "name"
AzureML --by orobix -- Provides resources to interact with Azure Machine Learning



*/
