
# Create a virtual network
resource "azurerm_virtual_network" "example-1" {
  name                = var.vnet_name
  address_space       = ["10.1.0.0/16"]
  location            = var.rg_location
  resource_group_name = var.rg_name
}

# Create a subnet within the virtual network
resource "azurerm_subnet" "example-1" {
  name                 = var.subnet_name
  resource_group_name = var.rg_name
  virtual_network_name = azurerm_virtual_network.example-1.name
  address_prefixes     = ["10.1.0.0/24"]

}



