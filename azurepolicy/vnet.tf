resource "azurerm_virtual_network" "container" {
  name = "vnet01"
  resource_group_name = azurerm_resource_group.example.name
  location = azurerm_resource_group.example.location
  address_space = ["10.0.0.0/16"]
  depends_on = [ azurerm_policy_definition.example ]
}
resource "azurerm_subnet" "container" {
  name = "default"
  resource_group_name = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.container.name
  address_prefixes = ["10.0.0.0/24"]
  
}
