provider "azurerm" {
    # The "feature" block is required for AzureRM provider 2.x.
    features {}
}
variable "prefix" {
  default = "tfvmex"
}
module "rg" {
  source = "../module/resourcegroup"
  rg_name= "aayush-rg"
 rg_location = "eastus"
}
module "vnet" {
  source = "../module/vnet"
  vnet_name = "vnet01"
  subnet_name = "subnet01"
  rg_name = module.rg.rg_name
  rg_location = module.rg.rg_location
  depends_on = [ module.rg ]
}
module "vm" {
  source = "../module/virtualmachine"
  rg_name = module.rg.rg_name
  rg_location = module.rg.rg_location
  subnet_id = module.vnet.subnet_id
  admin_password = "Admin_123456"
  vm_name = "mynewvm10"
  csdata = base64encode(file("./script.sh"))
}

# resource "azurerm_resource_group" "main" {
#   name     = "${var.prefix}-resources"
#   location = "West Europe"
# }

# resource "azurerm_virtual_network" "main" {
#   name                = "${var.prefix}-network"
#   address_space       = ["10.0.0.0/16"]
#   location            = azurerm_resource_group.main.location
#   resource_group_name = azurerm_resource_group.main.name
# }

# resource "azurerm_subnet" "internal" {
#   name                 = "internal"
#   resource_group_name  = azurerm_resource_group.main.name
#   virtual_network_name = azurerm_virtual_network.main.name
#   address_prefixes     = ["10.0.2.0/24"]
# }

# resource "azurerm_network_interface" "main" {
#   name                = "${var.prefix}-nic"
#   location            = azurerm_resource_group.main.location
#   resource_group_name = azurerm_resource_group.main.name

#   ip_configuration {
#     name                          = "testconfiguration1"
#     subnet_id                     = azurerm_subnet.internal.id
#     private_ip_address_allocation = "Dynamic"
#   }
# }

# resource "azurerm_virtual_machine" "main" {
#   name                  = "${var.prefix}-vm"
#   location              = azurerm_resource_group.main.location
#   resource_group_name   = azurerm_resource_group.main.name
#   network_interface_ids = [azurerm_network_interface.main.id]
#   vm_size               = "Standard_DS1_v2"

#   # Uncomment this line to delete the OS disk automatically when deleting the VM
#   # delete_os_disk_on_termination = true

#   # Uncomment this line to delete the data disks automatically when deleting the VM
#   # delete_data_disks_on_termination = true

#   storage_image_reference {
#     publisher = "Canonical"
#     offer     = "UbuntuServer"
#     sku       = "16.04-LTS"
#     version   = "latest"
#   }
#   storage_os_disk {
#     name              = "myosdisk1"
#     caching           = "ReadWrite"
#     create_option     = "FromImage"
#     managed_disk_type = "Standard_LRS"
#   }
  
#     computer_name  = "hostname"
#     admin_username = "azureuser"
#     admin_password = "Password1234!"
  
# }
resource "azurerm_storage_account" "main" {
  name                     = "vmstorageraccount"
  resource_group_name      = module.rg.rg_name
  location                 = module.rg.rg_location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

resource "azurerm_log_analytics_workspace" "law02" {
  name                = "logAnalytics"
 resource_group_name      = module.rg.rg_name
  location                 = module.rg.rg_location
 sku                 = "PerGB2018"
  retention_in_days   = 30
}



resource "azurerm_log_analytics_solution" "example" {
  solution_name         = "ContainerInsights"
 resource_group_name      = module.rg.rg_name
  location                 = module.rg.rg_location
  workspace_resource_id = azurerm_log_analytics_workspace.law02.id
  workspace_name        = azurerm_log_analytics_workspace.law02.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}

#===================================================================
# Set Monitoring and Log Analytics Workspace
#===================================================================
resource "azurerm_virtual_machine_extension" "oms_mma02" {
  name                       = "test-OMSExtension"
  virtual_machine_id         =  module.vm.vm_id
  publisher = "Microsoft.EnterpriseCloud.Monitoring"
 type = "OmsAgentForLinux"
 type_handler_version  = "1.13"


  auto_upgrade_minor_version = true
  depends_on = [ module.vm ]
  settings = <<SETTINGS
    {
      "workspaceId" : "${azurerm_log_analytics_workspace.law02.workspace_id}"
    }
  SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
    {
      "workspaceKey" : "${azurerm_log_analytics_workspace.law02.primary_shared_key}"
    }
  PROTECTED_SETTINGS
}