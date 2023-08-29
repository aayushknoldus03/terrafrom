provider "azurerm" {
  features {
    
  }
}
module "rg" {
  source = "../module/resourcegroup"
  rg_name= "aayush-rg100"
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
  admin_password = var.pass
  vm_name = "mynewvm10"
  usdata = filebase64("${path.module}/script.sh")
}

resource "azurerm_monitor_action_group" "ag" {
  name                = "myactiongroup"
  resource_group_name = module.rg.rg_name
  short_name          = "expactiongrp"
   email_receiver {
    name          = "sendtoadmin"
    email_address = "aayush.bisht@knoldus.com"
  }

}
resource "azurerm_monitor_metric_alert" "alert" {
  name                = "example-metricalert"
  resource_group_name = module.rg.rg_name
  scopes              = [module.vm.vm_id]
  severity = 3
 
  
  criteria { 
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Percentage CPU"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 80
  }
  frequency = "PT1M"

  action {
    action_group_id = azurerm_monitor_action_group.ag.id
  }
}