resource "azurerm_virtual_network" "main" {
  name                = var.vnet_name
  count               = var.vnet_create ? 1 : 0
  resource_group_name = azurerm_resource_group.main.name

  location = azurerm_resource_group.main.location

  address_space = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "env" {
  name                 = "${var.vnet_name}_apps"
  count                = var.vnet_create ? 1 : 0
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main[0].name
  address_prefixes     = ["10.0.0.0/21"]
  service_endpoints    = ["Microsoft.AzureCosmosDB"]
}