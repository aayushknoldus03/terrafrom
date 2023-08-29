resource "azurerm_monitor_action_group" "example" {
  name                = "example-action-group"
  resource_group_name = azurerm_resource_group.example.name
  short_name          = "examplegroup"
   email_receiver {
    name          = "sendtoadmin"
    email_address = "aayush.bisht@knoldus.com"
  }
}
resource "azurerm_storage_account" "example" {
  name                     = "storageaccountname8368"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "example" {
  name                       = "examplekeyvault8368288"
  location                   = azurerm_resource_group.example.location
  resource_group_name        = azurerm_resource_group.example.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days = 7
  purge_protection_enabled   = false
  sku_name                   = "standard"
}

resource "azurerm_log_analytics_workspace" "law" {
  name                = "myworkspacelog"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_monitor_diagnostic_setting" "example" {
  name               = "example-diagnostic-settings"
  storage_account_id = azurerm_storage_account.example.id
 target_resource_id = azurerm_key_vault.example.id
  partner_solution_id = azurerm_log_analytics_workspace.law.id
 enabled_log {
    category = "AuditEvent"
   
    retention_policy {
      enabled = false
    }
  }

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = false
    }
  }
}