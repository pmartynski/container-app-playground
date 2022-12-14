resource "azurerm_container_registry" "main" {
  name                = var.acr_name
  count               = var.acr_create ? 1 : 0
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  sku                 = "Basic"
}

resource "azurerm_user_assigned_identity" "app" {
  name                = var.identity_name
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
}

resource "azurerm_role_assignment" "acr_pull_role_assignment" {
  principal_id                     = azurerm_user_assigned_identity.app.principal_id
  count                            = var.acr_create ? 1 : 0
  scope                            = azurerm_container_registry.main[0].id
  role_definition_name             = "AcrPull"
  skip_service_principal_aad_check = true
}

resource "azurerm_log_analytics_workspace" "law" {
  name                = var.law_name
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
}

resource "azapi_resource" "env" {
  type      = "Microsoft.App/managedEnvironments@2022-03-01"
  name      = var.env_name
  parent_id = azurerm_resource_group.main.id
  location  = var.location

  body = jsonencode({
    properties = {
      appLogsConfiguration = {
        destination = "log-analytics"
        logAnalyticsConfiguration = {
          customerId = azurerm_log_analytics_workspace.law.workspace_id
          sharedKey  = azurerm_log_analytics_workspace.law.primary_shared_key
        }
      }
      vnetConfiguration = {
        infrastructureSubnetId = var.vnet_create ? azurerm_subnet.env[0].id : null
      }
    }
  })
}

resource "azapi_resource" "app_tls_cert" {
  type = "Microsoft.App/managedEnvironments/certificates@2022-03-01"
  name = var.app_custom_domain
  location = azapi_resource.env.location
  parent_id = azapi_resource.env.id

  body = jsonencode({
    properties = {
      password = file(var.app_tls_cert_pass_file)
      value = filebase64(var.app_tls_cert_file)
    }
  })
}


locals {
  cdb_cs = var.cosmos_create ? azurerm_cosmosdb_account.main[0].connection_strings[0] : ""
}

resource "azapi_resource" "app" {

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.app.id]
  }

  type      = "Microsoft.App/containerApps@2022-03-01"
  name      = var.app_name
  parent_id = azurerm_resource_group.main.id
  location  = azurerm_resource_group.main.location

  body = jsonencode({
    properties = {
      configuration = {
        ingress = {
          external      = true
          targetPort    = var.app_port
          allowInsecure = false
          customDomains = [{
            certificateId = azapi_resource.app_tls_cert.id
            name = azapi_resource.app_tls_cert.name
          }]
        }
        secrets = [
          {
            name  = "my-little-secret",
            value = var.my_little_secret
          },
          {
            name  = "cosmos-connection-string"
            value = local.cdb_cs
          }
        ]
        activeRevisionsMode = "Single"
        registries = var.acr_create ? [{
          identity = azurerm_user_assigned_identity.app.id
          server   = azurerm_container_registry.main[0].login_server
        }] : []
      }
      managedEnvironmentId = azapi_resource.env.id
      template = {
        containers = [{
          name  = "app"
          image = var.image
          env = [
            {
              name      = "SECRET_VALUE"
              secretRef = "my-little-secret"
            },
            {
              name  = "OPEN_VALUE"
              value = var.open_config
            },
            {
              name      = "COSMOS_CONNECTION_STRING"
              secretRef = "cosmos-connection-string"
            }
          ]
          resources = {
            cpu    = 0.25
            memory = "0.5Gi"
          }
        }]
        scale = {
          minReplicas = 1
          maxReplicas = 5
        }
      }
    }
  })
}
