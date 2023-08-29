provider "azurerm" {
  features {
  }
}
output "virtual_network_name" {
  
  value = data.azurerm_virtual_network.name.id
}

resource "azurerm_virtual_network_peering" "example-1" {
  name                      = "peer1to2"
  resource_group_name       = data.azurerm_resource_group.name.name
  virtual_network_name      = data.azurerm_virtual_network.name01.name
  remote_virtual_network_id = data.azurerm_virtual_network.name.id
}

resource "azurerm_virtual_network_peering" "example-2" {
  name                      = "peer2to1"
  resource_group_name       = data.azurerm_resource_group.name.name
  virtual_network_name      = data.azurerm_virtual_network.name.name
  remote_virtual_network_id = data.azurerm_virtual_network.name01.id
}