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

variable "app_name" {
  type = string
}
variable "location" {
  type = string
}

variable "rg_id" {
  type = string
}

variable "env_id" {
  type = string
}

variable "identity" {
  type = string
}

variable "my_little_secret" {
  type = string
}

variable "open_config" {
  type = string
}

variable "image" {
  type = string
}

variable "registry" {
  type = string
}

resource "azapi_resource" "app" {

  identity {
    type         = "UserAssigned"
    identity_ids = [var.identity]
  }

  type      = "Microsoft.App/containerApps@2022-03-01"
  parent_id = var.rg_id
  name      = var.app_name
  location  = var.location

  body = jsonencode({
    properties = {
      configuration = {
        ingress = {
          external      = true
          targetPort    = 3000
          allowInsecure = false
        }
        secrets = [{
          name  = "my-little-secret",
          value = var.my_little_secret
        }]
        activeRevisionsMode = "Single"
        registries = [{
          identity = var.identity
          server   = var.registry
        }]
      }
      managedEnvironmentId = var.env_id
      template = {
        containers = [{
          name = "app"
          image = var.image
          env = [{
            name      = "SECRET_VALUE"
            secretRef = "my-little-secret"
          },
          {
            name = "OPEN_VALUE"
            value = var.open_config
          }]
          # probes = []
          resources = {
            cpu    = 0.25
            memory = "0.5Gi"
          }
        }]
        scale = {
          minReplicas = 1
          maxReplicas = 5
          # rules = [{http = {
          #     metadata = {

          #     }
          # }}]
        }
      }
    }
  })
}