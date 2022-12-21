resource "azurerm_cosmosdb_account" "main" {
  name                = var.cosmos_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  offer_type = "Standard"

  public_network_access_enabled = false
  enable_automatic_failover     = false

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = var.location
    failover_priority = 0
  }

  #   virtual_network_rule {
  #     id = azurerm_subnet
  #   }
}

resource "azurerm_cosmosdb_sql_database" "app" {
  account_name        = azurerm_cosmosdb_account.main.name
  resource_group_name = azurerm_cosmosdb_account.main.resource_group_name
  throughput          = 400
  name                = "app"
}
