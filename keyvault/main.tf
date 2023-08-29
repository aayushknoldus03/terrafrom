

data "azurerm_client_config" "current" {}


resource "azurerm_key_vault" "keyvault" {
  name                        = var.keyvault_name
  location                    = azurerm_resource_group.rg_1.location
  resource_group_name         = azurerm_resource_group.rg_1.name
  # enabled_for_disk_encryption = false
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  # soft_delete_enabled         = true
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id         

    key_permissions = [
       "Create",
      "Delete",
      "Get",
      "List",
      "Update"
    ]

    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete",
      "Purge"
    ]

  }
}

resource "azurerm_key_vault_secret" "vm_password" {
  name         = var.secret_name
  value        = var.secret_value
  key_vault_id = azurerm_key_vault.keyvault.id
  depends_on = [ azurerm_key_vault.keyvault ]
}

