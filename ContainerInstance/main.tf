data "azurerm_resource_group" "example" {
 name  = "aayush-rg"
}
# data "location" "example" {
#   value = "Central US"
# }

resource "azurerm_container_group" "example" {
  name                = var.container_group_name
  resource_group_name = data.azurerm_resource_group.example.name
  location = data.azurerm_resource_group.example.location
  os_type = "Linux"
  ip_address_type     = "Private"
  subnet_ids = [azurerm_subnet.container.id]

  container {
    name   = var.container_name
    image  = "aayush0307/pythonmyapp:V.35"
    cpu    = var.cpu_cores
    memory = var.memory_in_gb

    ports {
      port     = var.port
      protocol = "TCP"
    }
  }
  restart_policy = var.restart_policy
}
