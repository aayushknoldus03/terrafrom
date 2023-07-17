# Create a resource group
resource "azurerm_resource_group" "example" {
  name     = "my-resource-group"
  location = "japan east"
}
resource "azurerm_resource_group" "example-2" {
  name     = "my-resource-group01"
  location = "east us"
}