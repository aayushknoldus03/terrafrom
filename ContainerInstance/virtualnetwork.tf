resource "azurerm_virtual_network" "container" {
  name = "containervnet01"
  resource_group_name = data.azurerm_resource_group.example.name
  location = data.azurerm_resource_group.example.location
  address_space = ["10.0.0.0/16"]
}
resource "azurerm_subnet" "container" {
  name = "default"
  resource_group_name = data.azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.container.name
  address_prefixes = ["10.0.1.0/24"]
   delegation {
    name = "subnet-delegation"
    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}
resource "azurerm_subnet" "application-gateway" {
  name = "applicationsubnet"
  resource_group_name = data.azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.container.name
  address_prefixes = ["10.0.2.0/24"]
}