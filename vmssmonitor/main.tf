provider "azurerm" {
  features {
    
  }
}
resource "azurerm_resource_group" "example" {
  name     = "autoscalingTest01"
  location = "japan west"
}

resource "azurerm_virtual_network" "example" {
  name                = "acctvn"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
  name                 = "acctsub"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}
 # Create public IPs


resource "azurerm_linux_virtual_machine_scale_set" "example" {
  name                = "exampleset"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  upgrade_mode        = "Manual"
  sku                 = "Standard_D2"
  instances           = 1
  admin_username      = "myadmin"

  admin_ssh_key {
    username   = "myadmin"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC8pzTB7DJ4Vh3w72NCf/y/lpsFum81nYAe53iy/NPpBr7ngG8c2WAPAvHjLpgqM5ewnYhkkBJzfjTgscaSdN5BmVNYH4VP611Tiy+ZJhUhiJyD6F/8MZitF/P+MgUMuCm69LxE2ixKbARdZXE1HJxDYTPS773RcCk9g+DBCdIxTqaLnJOlfGL5aLCwdhbxste780C55JaFZ5cDMIsiO9wf61xCDDQvHZ65JcWvRKZ+rm3I+89Xfmoo0P2dInD04ZBNU3RWmNWq9bBMxgESJVmx7xHbznOuoC7IN5kWMNZKtvB3hRfnQOns7kpf+5MIeLOk/9eWb/SrlrTL04MqXaII5hP+CYBREoLe99GxUsLAeP9fPPJxBErewJGuBZvtaIwGicoHry23ZTQXc6OZ+f7Zbwy0QBKDMm+WCdHUIiyLGcajHySnneScIiJXdJ27XG7F/s3IgOjS2Ud40+th/9xrhIj/VZXzW6QAmKDlT9duvVRr19+BfYQ2wqIfu75F58k= knoldus@knoldus-Vostro-3500"
  }


  network_interface {
    name    = "TestNetworkProfile"
    primary = true

    ip_configuration {
      name      = "TestIPConfiguration"
      primary   = true
      subnet_id = azurerm_subnet.example.id

     public_ip_address {
        name = "my-ip"
      }
    }
  }
 
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }


}

resource "azurerm_monitor_autoscale_setting" "example" {
  name                = "myAutoscaleSetting"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  target_resource_id  = azurerm_linux_virtual_machine_scale_set.example.id

  profile {
    name = "defaultProfile"

    capacity {
      default = 1
      minimum = 1
      maximum = 10
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.example.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 75
        metric_namespace   = "microsoft.compute/virtualmachinescalesets"
        dimensions {
          name     = "AppName"
          operator = "Equals"
          values   = ["App1"]
        }
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.example.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 25
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }
  }

  predictive {
    scale_mode      = "Enabled"
    look_ahead_time = "PT5M"
  }

  notification {
    email {
      send_to_subscription_administrator    = true
      send_to_subscription_co_administrator = true
      custom_emails                         = ["aayush.bisht@knoldus.com"]
    }
  }
}