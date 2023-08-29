# Create a resource group
resource "azurerm_resource_group" "example" {
  name     = "my-resource-group"
  location = "japan east"
}
