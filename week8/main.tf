provider "azurerm" {
  features {
    
  }
}
terraform {
  backend "azurerm" {
    resource_group_name = "aayush-rg"
    storage_account_name = "mybackendstraccount"
    container_name = "tfstatefile"
    key = "backend.tfstate"
  }
  
}
data "azurerm_resource_group" "name" {
  name = "aayush-rg"
}

resource "azurerm_virtual_network" "name" {
  name = "vnet001"
  resource_group_name = data.azurerm_resource_group.name.name
  location = data.azurerm_resource_group.name.location
  address_space = ["10.0.0.0/22"]
}
resource "azurerm_subnet" "name" {
  name = "subnet02"
  resource_group_name = data.azurerm_resource_group.name.name
  virtual_network_name = azurerm_virtual_network.name.name
  address_prefixes = ["10.0.0.0/26"]
}