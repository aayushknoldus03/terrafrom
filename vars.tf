variable "resource_group_name" {
  type = string
}
variable "storage_account_name" {
  type = string
}
variable "location" {
  type = string
}

variable "account_tier" {
  type = string
}

variable "account_replication_type" {
  type = string
}

variable "azurerm_storage_container_name" {
  type = string
}

variable "container_access_type" {
  type = string
}

variable "storage_name" {
  type = string
}

variable "storage_type" {
  type = string
}

variable "storage_source_uri" {
  type = string

}
variable "user_principal_name" {
  type = string
}

variable "user_pass" {
  type = string
}