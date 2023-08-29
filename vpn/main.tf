provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "new-group" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "vnet1" {
  name                = var.vnet1_name
  address_space       = ["10.1.0.0/16"]
  resource_group_name = azurerm_resource_group.new-group.name
  location            = azurerm_resource_group.new-group.location
}

resource "azurerm_virtual_network" "vnet2" {
  name                = var.vnet2_name
  address_space       = ["10.2.0.0/16"]
  resource_group_name = azurerm_resource_group.new-group.name
  location            = azurerm_resource_group.new-group.location

}

resource "azurerm_subnet" "subnet1" {
  name                 = var.subnet1_name
  resource_group_name  = azurerm_resource_group.new-group.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = [var.subnet1_address_prefix]
}

resource "azurerm_subnet" "subnet2" {
  name                 = var.subnet2_name
  resource_group_name  = azurerm_resource_group.new-group.name
  virtual_network_name = azurerm_virtual_network.vnet2.name
  address_prefixes     = [var.subnet2_address_prefix]
}

resource "azurerm_public_ip" "gw1-ip" {
  name                = "gw1-ip"
  location            = azurerm_resource_group.new-group.location
  resource_group_name = azurerm_resource_group.new-group.name
  allocation_method = "Dynamic"
}

resource "azurerm_public_ip" "gw2-ip" {
  name                = "gw2-ip"
  location            = azurerm_resource_group.new-group.location
  resource_group_name = azurerm_resource_group.new-group.name
  allocation_method = "Dynamic"
}

resource "azurerm_virtual_network_gateway" "gateway1" {
  name                = var.gateway1_name
  resource_group_name = azurerm_resource_group.new-group.name
  location            = azurerm_resource_group.new-group.location
  type                = var.gateway_type
  vpn_type            = var.vpn_type
  sku                 = var.gateway_sku
  ip_configuration {
    name                          = var.gateway1_ip_config_name
    public_ip_address_id          = azurerm_public_ip.gw1-ip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.subnet1.id
  }
}

resource "azurerm_virtual_network_gateway" "gateway2" {
  name                = var.gateway2_name
  resource_group_name = azurerm_resource_group.new-group.name
  location            = azurerm_resource_group.new-group.location
  type                = var.gateway_type
  vpn_type            = var.vpn_type
  sku                 = var.gateway_sku
  ip_configuration {
    name                          = var.gateway2_ip_config_name
    public_ip_address_id          = azurerm_public_ip.gw2-ip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.subnet2.id
  }
}

resource "azurerm_virtual_network_gateway_connection" "connection1" {
  name                            = var.connection_name1
  resource_group_name             = azurerm_resource_group.new-group.name
  location                        = azurerm_resource_group.new-group.location
  virtual_network_gateway_id      = azurerm_virtual_network_gateway.gateway1.id
  peer_virtual_network_gateway_id = azurerm_virtual_network_gateway.gateway2.id
  type                            = var.connection_type
  shared_key = "hello-moto"
}

resource "azurerm_virtual_network_gateway_connection" "connection2" {
  name                            = var.connection_name2
  resource_group_name             = azurerm_resource_group.new-group.name
  location                        = azurerm_resource_group.new-group.location
  virtual_network_gateway_id      = azurerm_virtual_network_gateway.gateway2.id
  peer_virtual_network_gateway_id = azurerm_virtual_network_gateway.gateway1.id
  type                            = var.connection_type
  shared_key = "hello-moto"
}

# resource "azurerm_storage_account" "tf-storage" {
#   name                     = var.storage_account_name
#   resource_group_name      = azurerm_resource_group.new-group.name
#   location                 = azurerm_resource_group.new-group.location
#   account_tier             = var.storage_account_tier
#   account_replication_type = var.storage_account_replication_type
# }

# resource "azurerm_storage_container" "backend-container" {
#   name                  = var.storage_container_name
#   storage_account_name  = azurerm_storage_account.tf-storage.name
#   container_access_type = var.storage_container_access_type
# }