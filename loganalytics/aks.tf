resource "azurerm_kubernetes_cluster" "default" {
  name                              = "mynewaks-aks"
  location                          = azurerm_resource_group.example.location
  resource_group_name               = azurerm_resource_group.example.name
  dns_prefix                        = "myakscluster01"
  
  default_node_pool {
    name                 = "default"
    node_count           = 1
    vm_size              = "Standard_DS2_v2"
    enable_auto_scaling  = true
    min_count            = 1
    max_count            = 2
    type                 = "VirtualMachineScaleSets"
  }

  identity {
    type        = "SystemAssigned"
  }

  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id
  }
}