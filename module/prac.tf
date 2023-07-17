provider "azurerm" {
  features {
    
  }
}
module "rg" {
  source = "./resourcegroup"
  rg_name= "aayush-rg"
 rg_location = "eastus"
}
module "vnet" {
  source = "./vnet"
  vnet_name = "vnet01"
  subnet_name = "subnet01"
  rg_name = module.rg.rg_name
  rg_location = module.rg.rg_location
}
module "vm" {
  source = "./virtualmachine"
  csdata = filebase64(var.data)
}