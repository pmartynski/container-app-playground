resource "azurerm_cosmosdb_account" "main" {
  name                = var.cosmos_name
  count = var.cosmos_create ? 1 : 0
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  offer_type = "Standard"

  enable_automatic_failover         = false
  is_virtual_network_filter_enabled = true

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = var.location
    failover_priority = 0
  }

  dynamic "virtual_network_rule" {
    for_each = azurerm_subnet.env
    content {
      id = each.id
    }
  }
}

resource "azurerm_cosmosdb_sql_database" "app" {
  account_name        = azurerm_cosmosdb_account.main[0].name
  resource_group_name = azurerm_cosmosdb_account.main[0].resource_group_name
  throughput          = 400
  name                = "app"
  count = var.cosmos_create ? 1 : 0
}
