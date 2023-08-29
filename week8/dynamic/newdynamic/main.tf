provider "azurerm" {
  features {
    
  }
}
data "azurerm_resource_group" "example" {
  name = "aayush-rg"

}

locals {
  security_rules_for = [{
    name = "rule1"
    port = 22
    priority = 100
  },
  {
    name = "rule2"
    port = 80
    priority = 101
  },
  {
    name= "rule3"
    port = 3389
    priority = 102
  }]
}
resource "azurerm_network_security_group" "nsg" {
  name                = "prac-nsg"
  location            = data.azurerm_resource_group.example.location
  resource_group_name = data.azurerm_resource_group.example.name
dynamic "security_rule" {
  for_each = local.security_rules_for
  
  content{
    name                       = security_rule.value.name
    priority                   = security_rule.value.priority
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = security_rule.value.port
    source_address_prefix      = "*"
    destination_address_prefix = "*"

  }
}
}