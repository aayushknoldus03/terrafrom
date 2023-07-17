# Configure the Azure provider
provider "azurerm" {
  features {}
}

# Create an AKS cluster
resource "azurerm_kubernetes_cluster" "example" {
  name                = "my-aks-cluster"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  dns_prefix          = "myakscluster"


  identity {
    type = "SystemAssigned"
  }
  
  default_node_pool {
    name                 = "default"
    node_count           = 1
    vm_size              = "Standard_DS2_v2"
    vnet_subnet_id       = azurerm_subnet.example-1.id
    enable_auto_scaling  = true
    min_count            = 1
    max_count            = 2
    type                 = "VirtualMachineScaleSets"
  }

  network_profile {
    network_plugin     = "kubenet"
    dns_service_ip     = "192.168.1.1"
    service_cidr       = "192.168.0.0/16"
    pod_cidr           = "172.16.0.0/22"
  }
  private_cluster_enabled = true
}

resource "azurerm_private_dns_zone_virtual_network_link" "link_vnet" {
  name = "dnslink-vnet02"
  private_dns_zone_name = join(".", slice(split(".", azurerm_kubernetes_cluster.example.private_fqdn), 1, length(split(".", azurerm_kubernetes_cluster.example.private_fqdn))))
  resource_group_name   = "MC_${azurerm_resource_group.example.name}_${azurerm_kubernetes_cluster.example.name}_${azurerm_resource_group.example.location}"
  virtual_network_id    = azurerm_virtual_network.example-2.id
}
