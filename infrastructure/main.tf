terraform {
  required_version = ">= 1.3.0"
  required_providers {
    azapi = {
      source  = "Azure/azapi"
      version = "1.0.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.31.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azapi" {
}

variable "location" {
  default = "eastus"
}

variable "rg_name" {
  default = "container-apps-playground-1-eus"
}

variable "acr_name" {
  default = "pmacreus1"
}

variable "identity_name" {
  default = "pmacreuspull"
}

variable "law_name" {
  default = "pmlaweus1"
}

variable "env_name" {
  default = "container-apps-playground-env"
}

# variable "my_little_secret" {
#   type = string
#   description = "The secret value"
# }

resource "azurerm_resource_group" "rg" {
  location = var.location
  name     = var.rg_name
}

resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  sku                 = "Basic"
}

resource "azurerm_user_assigned_identity" "uaid" {
  name                = var.identity_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
}

resource "azurerm_role_assignment" "acr_pull_role_assignment" {
  principal_id                     = azurerm_user_assigned_identity.uaid.principal_id
  scope                            = azurerm_container_registry.acr.id
  role_definition_name             = "AcrPull"
  skip_service_principal_aad_check = true
}

resource "azurerm_log_analytics_workspace" "law" {
  name = var.law_name
  resource_group_name = azurerm_resource_group.rg.name
  location = var.location
}

resource "azapi_resource" "env" {
  type = "Microsoft.App/managedEnvironments@2022-03-01"
  name = var.env_name
  parent_id = azurerm_resource_group.rg.id
  location = var.location

  # identity {
  #   type = "UserAssigned"
  #   identity_ids = [ azurerm_user_assigned_identity.uaid.id ]
  # }
  
  body = jsonencode({
    properties = {
      appLogsConfiguration = {
        destination = "log-analytics"
        logAnalyticsConfiguration = {
          customerId = azurerm_log_analytics_workspace.law.workspace_id
          sharedKey = azurerm_log_analytics_workspace.law.primary_shared_key
        }
      }
    }
  })

}

output "user_assigned_identity" {
   value = {
    id = azurerm_user_assigned_identity.uaid.id
    principalId = azurerm_user_assigned_identity.uaid.principal_id
   }
}

output "asa_env" {
  value = {
    id = azapi_resource.env.id
  }
}