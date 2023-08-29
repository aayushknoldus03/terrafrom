provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "test" {
  name     = "rg1"
  location = "eastus2"
  lifecycle {
    # create_before_destroy = true
    # ignore_changes = [ tags ]
    prevent_destroy = true
  }
  tags = {
    a = "b"
  }

}

# resource "azurerm_virtual_network" "test" {
#   name                = "vnet"
#   location            = azurerm_resource_group.test.location
#   resource_group_name = azurerm_resource_group.test.name
#   address_space       = ["10.0.0.0/16"]

#   lifecycle {
#     precondition {
#       condition     = azurerm_resource_group.test.name == "rg2"
#       error_message = "resource name should  be rg2"

#     }
#     }

    # postcondition {
    #   condition = azurerm_resource_group.test.tags["a"] == "b"
    #   error_message = "resource group must have tags this a = b"
    # }
    # replace_triggered_by = [ azurerm_resource_group.test ]
#   }

