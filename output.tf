output "storage_account_tier" {
  value = azurerm_storage_account.example.account_tier
}
output "user_display_name" {
  value = data.azuread_user.example.display_name
}
