provider "azurerm" {
  features {  
  }
}
module "resourcegroup" {
  source = "../resourcegroup"
  rg_name= "aayush-rg"
 rg_location = "eastus"
}
module "vnet" {
  source = "../vnet"
  vnet_name = "vnet01"
  subnet_name = "subnet01"
  rg_name = module.resourcegroup.rg_name
  rg_location = module.resourcegroup.rg_location
  depends_on = [ module.resourcegroup ]
}
resource "azurerm_network_interface" "my_nic" {
  name                = "myNIC"
  location            = module.resourcegroup.rg_location
  resource_group_name = module.resourcegroup.rg_name
  depends_on = [ module.vnet ]

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
  location            = module.resourcegroup.rg_location
  resource_group_name = module.resourcegroup.rg_name
  allocation_method   = "Dynamic"
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "my_nsg" {
  name                = "myNetworkSecurityGroup"
  location            = module.resourcegroup.rg_location
  resource_group_name = module.resourcegroup.rg_name


  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Create network interface


# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.my_nic.id
  network_security_group_id = azurerm_network_security_group.my_nsg.id
}

# Create (and display) an SSH key
resource "tls_private_key" "example_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "my_vm" {
  name                  = "myVM1"
  location            = module.resourcegroup.rg_location
  resource_group_name = module.resourcegroup.rg_name

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
  admin_password = "Admin_123456"
  disable_password_authentication = false
  custom_data = var.csdata

}