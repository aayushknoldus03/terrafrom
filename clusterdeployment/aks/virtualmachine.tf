resource "azurerm_network_interface" "my_terraform_nic" {
  name                = "myNIC"
  location            = azurerm_resource_group.example-2.location
  resource_group_name = azurerm_resource_group.example-2.name

  ip_configuration {
    name                          = "my_nic_configuration"
    subnet_id                     = azurerm_subnet.example-2.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.my_terraform_public_ip.id
  }
}

# Create public IPs
resource "azurerm_public_ip" "my_terraform_public_ip" {
  name                = "myPublicIP"
  location            = azurerm_resource_group.example-2.location
  resource_group_name = azurerm_resource_group.example-2.name
  allocation_method   = "Dynamic"
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "my_terraform_nsg" {
  name                = "myNetworkSecurityGroup"
  location            = azurerm_resource_group.example-2.location
  resource_group_name = azurerm_resource_group.example-2.name

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
  network_interface_id      = azurerm_network_interface.my_terraform_nic.id
  network_security_group_id = azurerm_network_security_group.my_terraform_nsg.id
}

# Create (and display) an SSH key
resource "tls_private_key" "example_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "my_terraform_vm" {
  name                  = "myVM1"
  location              = azurerm_resource_group.example-2.location
  resource_group_name   = azurerm_resource_group.example-2.name
  network_interface_ids = [azurerm_network_interface.my_terraform_nic.id]
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
  admin_password = var.pass
  disable_password_authentication = false

 

  # admin_ssh_key {
  #   username   = "azureuser"
  #   public_key = tls_private_key.example_ssh.public_key_openssh
  # }
 
provisioner "file" {
    source      = "/home/knoldus/session/clusterdeployment/deployment.yml"
    destination = "./file"

    connection {
      type        = "ssh"
      host        = azurerm_linux_virtual_machine.my_terraform_vm.public_ip_address
      user        = "azureuser"
      password =  var.pass # Path to your private key file
    }
  }

  #  provisioner "remote-exec" {
  #       connection {
  #     type        = "ssh"
  #     host        = azurerm_linux_virtual_machine.my_terraform_vm.public_ip_address
  #     user        = "azureuser"
  #     password =  "Admin_152012345" # Path to your private key file
  #   }

  #       inline = [
  #         "kubectl apply -f ./file"
  #       ]
      
  #   }
   provisioner "remote-exec" {
        connection {
      type        = "ssh"
      host        = azurerm_linux_virtual_machine.my_terraform_vm.public_ip_address
      user        = "azureuser"
      password =  var.pass # Path to your private key file
    }

        inline = [
          "sudo apt-get update",
          "curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash",
          # "sudo apt-get install ca-certificates curl apt-transport-https lsb-release gnupg -y",
          # "sudo mkdir -p /etc/apt/keyrings",
          # "curl -sLS https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/keyrings/microsoft.gpg > /dev/null",
          # "sudo chmod go+r /etc/apt/keyrings/microsoft.gpg",
          # "AZ_REPO=$(lsb_release -cs)",
          # "echo 'deb [arch=`dpkg --print-architecture` signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main' | sudo tee /etc/apt/sources.list.d/azure-cli.list",
          "sudo apt-get update",
          "sudo apt-get install azure-cli -y",
          "sudo snap install kubectl --classic",
        ]
    }

}