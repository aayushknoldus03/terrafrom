data "azurerm_resource_group" "name" {
  name = var.resource_group_name
}
data "azurerm_virtual_network" "name" {
  name = var.virtual_network_name[0]
  resource_group_name = data.azurerm_resource_group.name
}
data "azurerm_virtual_network" "name01" {
  name = var.virtual_network_name[1]
  resource_group_name = data.azurerm_resource_group.name
}