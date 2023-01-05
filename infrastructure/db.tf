resource "azurerm_cosmosdb_account" "main" {
  name                = var.cosmos_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  offer_type = "Standard"

  enable_automatic_failover     = false
  is_virtual_network_filter_enabled = true

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = var.location
    failover_priority = 0
  }

  virtual_network_rule {
    id = azurerm_subnet.env.id
  }
}

resource "azurerm_cosmosdb_sql_database" "app" {
  account_name        = azurerm_cosmosdb_account.main.name
  resource_group_name = azurerm_cosmosdb_account.main.resource_group_name
  throughput          = 400
  name                = "app"
}
