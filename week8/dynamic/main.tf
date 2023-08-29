provider "azurerm" {
  features {  
  }
}
module "rg" {
  source = "../../module/resourcegroup"
  rg_name= "aayush-rg10"
  rg_location = "eastus"
}
module "vnet" {
  source = "../../module/vnet"
  vnet_name = "vnet01"
  subnet_name = "subnet01"
  rg_name = module.rg.rg_name
  rg_location = module.rg.rg_location
  depends_on = [ module.rg ]
}
resource "azurerm_network_interface" "my_nic" {
  name                = "myNIC"
  location            = module.rg.rg_location
  resource_group_name = module.rg.rg_name


  ip_configuration {
    name                          = "my_nic_configuration"
    subnet_id                     = module.vnet.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.my_public_ip.id
  }
}

# Create public IPs
resource "azurerm_public_ip" "my_public_ip" {
  name                = "myPublicIP"
  location            = module.rg.rg_location
  resource_group_name = module.rg.rg_name
  allocation_method   = "Dynamic"
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "my_nsg" {
  name                = "myNetworkSecurityGroup"
  location            = module.rg.rg_location
  resource_group_name = module.rg.rg_name

  dynamic"security_rule" {
    for_each = var.nsg_rule
    content {
    name                       = security_rule.value["name"]
    priority                   = security_rule.value["priority"]
    direction                  = security_rule.value["direction"]
    access                     = security_rule.value["access"]
    protocol                   = security_rule.value["protocol"]
    source_port_range          = security_rule.value["source_port_range"]
    destination_port_range     = security_rule.value["destination_port_range"]
    source_address_prefix      = security_rule.value["source_address_prefix"]
    destination_address_prefix = security_rule.value["destination_address_prefix"]
    }
 
  }
}

# Create network interface


# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.my_nic.id
  network_security_group_id = azurerm_network_security_group.my_nsg.id
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "my_vm" {
  name                  = "myVM1"
  location            = module.rg.rg_location
  resource_group_name = module.rg.rg_name

  network_interface_ids = [azurerm_network_interface.my_nic.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  computer_name                   = "myvm"
  admin_username                  = "azureuser"
  admin_password = var.password
  disable_password_authentication = false

}