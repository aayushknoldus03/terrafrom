resource "azurerm_storage_account" "example" {
  name                     = var.storage_account_name
  resource_group_name      = data.azurerm_resource_group.example.name
  location = data.azurerm_resource_group.example.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
}

data "azurerm_storage_account" "example" {
  name                = azurerm_storage_account.example.name
  resource_group_name = data.azurerm_resource_group.example.name

}

resource "azurerm_storage_container" "example" {
  name                  = var.azurerm_storage_container_name
  storage_account_name  = azurerm_storage_account.example.name
  container_access_type = var.container_access_type
}

resource "azurerm_storage_blob" "example" {
  name                   = var.storage_name
  storage_account_name   = azurerm_storage_account.example.name
  storage_container_name = azurerm_storage_container.example.name
  type                   = var.storage_type
  source_uri             = var.storage_source_uri
}
resource "azurerm_storage_share" "fileshare" {
  name                 = "sharename011"
  storage_account_name = azurerm_storage_account.example.name
  quota                = 50
}

resource "azurerm_role_assignment" "Storage_role" {
  scope                = data.azurerm_resource_group.example.id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = data.azuread_user.example.object_id

}
