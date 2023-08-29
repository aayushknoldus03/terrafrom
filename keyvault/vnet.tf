# Create a virtual network
resource "azurerm_virtual_network" "example-1" {
  name                = "my-vnet01"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg_1.location
  resource_group_name = azurerm_resource_group.rg_1.name
}

resource "azurerm_subnet" "example-1" {
  name = "my-subnet02"
  resource_group_name = azurerm_resource_group.rg_1.name
  virtual_network_name = azurerm_virtual_network.example-1.name
  address_prefixes = ["10.0.0.0/24"]
}