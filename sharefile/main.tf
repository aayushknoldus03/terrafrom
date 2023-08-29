## Create a Resource Group for Storage
data "azurerm_resource_group" "name" {
  name = "blogrg01"
}

resource "azurerm_storage_account" "storage" {
  name                     = var.str_name
  resource_group_name      = data.azurerm_resource_group.name.name
  location                 = data.azurerm_resource_group.name.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
}

resource "azurerm_storage_share" "fileshare" {
  name                 = "sharenam"
  storage_account_name = azurerm_storage_account.storage.name
  quota                = 50
}

resource "azurerm_storage_share_file" "example" {
  name             = "my-awesome-content.zip"
  storage_share_id = azurerm_storage_share.fileshare.id
  source           = "/home/knoldus/hard1.txt"
  lifecycle {
    prevent_destroy = true
  }
}
