provider "azurerm" {
  features {

  }
}
terraform {
  backend "azurerm" {
    resource_group_name  = "importantgroup"
    storage_account_name = "impaccount8368"
    container_name       = "aayushtfstatefile"
    key                  = "backend.tfstate"
  }
}

module "vnet" {
  source      = "../../module/vnet"
  vnet_name   = "vnet01"
  subnet_name = "subnet01"
  rg_name     = data.azurerm_resource_group.example.name
  rg_location = data.azurerm_resource_group.example.location
  depends_on  = [data.azurerm_resource_group.example]
}
locals {
  security_rules_for = [{
    name     = "rule1"
    port     = 22
    priority = 100
    },
    {
      name     = "rule2"
      port     = 80
      priority = 101
    },
    {
      name     = "rule3"
      port     = 3389
      priority = 102
  }]
}
resource "azurerm_network_interface" "my_nic" {
  name                = "myNIC"
  location            = data.azurerm_resource_group.example.location
  resource_group_name = data.azurerm_resource_group.example.name


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
  location            = data.azurerm_resource_group.example.location
  resource_group_name = data.azurerm_resource_group.example.name
  allocation_method   = "Dynamic"
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "my_nsg" {
  name                = "myNetworkSecurityGroup"
  location            = data.azurerm_resource_group.example.location
  resource_group_name = data.azurerm_resource_group.example.name

  dynamic "security_rule" {
    for_each = local.security_rules_for
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = security_rule.value.port
      source_address_prefix      = "*"
      destination_address_prefix = "*"

    }
  }

}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.my_nic.id
  network_security_group_id = azurerm_network_security_group.my_nsg.id
}
# Create virtual machine
resource "azurerm_linux_virtual_machine" "my_vm" {
  name                = "myVM1"
  location            = data.azurerm_resource_group.example.location
  resource_group_name = data.azurerm_resource_group.example.name

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
  admin_password                  = var.admin_password
  disable_password_authentication = false
  #user_data                       = base64encode(file(base64decode(file("./encrypted_file.base64.txt")))) // built-in function
  #custom_data = base64encode(file(""))
  provisioner "file" {
    source      = "/home/knoldus/session/week8/vmprac/secret.sh.gpg"
    destination = "./file.sh"

    connection {
      type        = "ssh"
      host        = azurerm_linux_virtual_machine.my_vm.public_ip_address
      user        = "azureuser"
      password =  var.admin_password # Path to your private key file
    }
  }
  provisioner "remote-exec" {
        connection {
      type        = "ssh"
      host        = azurerm_linux_virtual_machine.my_vm.public_ip_address
      user        = "azureuser"
      password =  var.admin_password # Path to your private key file
    }

        inline = [
          "gpg -do secret.sh ./file.sh",
          "./secret.sh"
        ]
      
    }
}
