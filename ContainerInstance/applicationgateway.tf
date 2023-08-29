resource "azurerm_public_ip" "application-gateway" {
  name                = "public-ip"
  resource_group_name = data.azurerm_resource_group.example.name
  location = data.azurerm_resource_group.example.location
  allocation_method   = "Static"
  sku = "Standard"
}
resource "azurerm_application_gateway" "application-gateway" {
  name                = "app-gateway"
  resource_group_name = data.azurerm_resource_group.example.name
  location = data.azurerm_resource_group.example.location
  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 1
  }
gateway_ip_configuration {
    name      = "gateway-ip-config"
    subnet_id = azurerm_subnet.application-gateway.id
  }
frontend_port {
    name = var.frontend_port_name
    port = 80
  }
    frontend_ip_configuration {
    name                 = var.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.application-gateway.id
  }
 backend_address_pool {
    name = var.backend_address_pool_name
    ip_addresses = [azurerm_container_group.example.ip_address]
  }

  backend_http_settings {
    name                  = var.backend_http_settings_name
    cookie_based_affinity = "Disabled"
    path = ""
    port                  = var.port
    protocol              = "Http"
    request_timeout       = 1
  }


  http_listener {
    name                           = "listner"
    frontend_ip_configuration_name = var.frontend_ip_configuration_name
    frontend_port_name             = var.frontend_port_name
    protocol                       = "Http"
  }

  
  request_routing_rule {
    name                       = "rule1"
    rule_type                  = "Basic"
    priority                   = 2
    http_listener_name         = "listner"
    backend_address_pool_name  = var.backend_address_pool_name
    backend_http_settings_name = var.backend_http_settings_name
}
}