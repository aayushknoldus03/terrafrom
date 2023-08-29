provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "test" {
  name     = "acctestRG-share-test02"
  location = "eastus2"
}

resource "azurerm_storage_account" "test" {
  name                     = "acctestsa0123422"
  resource_group_name      = azurerm_resource_group.test.name
  location                 = azurerm_resource_group.test.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_share" "test" {
  name                 = "fileshare1"
  storage_account_name = azurerm_storage_account.test.name
  quota                = 50
}

resource "azurerm_storage_share_directory" "parent" {
  name                 = "parent"
  share_name           = azurerm_storage_share.test.name
  storage_account_name = azurerm_storage_account.test.name
}

resource "azurerm_storage_share_directory" "child" {
  name                 = "${azurerm_storage_share_directory.parent.name}/child"
  share_name           = azurerm_storage_share.test.name
  storage_account_name = azurerm_storage_account.test.name
}


resource "azurerm_storage_share_file" "example" {
  name             = "script"
  storage_share_id = azurerm_storage_share.test.id
  path             = "${azurerm_storage_share_directory.child.name}"
  source           = "/home/knoldus/change.txt"

}
