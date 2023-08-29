variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "vnet1_name" {
  type = string
}

# variable "vnet1_address_space" {
#   type = list(string)
# }

variable "vnet2_name" {
  type = string
}

# variable "vnet2_address_space" {
#   type = list(string)
# }

variable "subnet1_name" {
  type = string
}

variable "subnet1_address_prefix" {
  type = string
}

variable "subnet2_name" {
  type = string
}

variable "subnet2_address_prefix" {
  type = string
}

variable "gateway1_name" {
  type = string
}

variable "gateway2_name" {
  type = string
}

variable "gateway_type" {
  type    = string
  default = "Vpn"
}

variable "vpn_type" {
  type    = string
  default = "RouteBased"
}

variable "gateway_sku" {
  type    = string
  default = "VpnGw1"
}

variable "gateway_size" {
  type    = string
  default = "Standard_v2"
}

variable "gateway1_ip_config_name" {
  type = string
}

variable "gateway2_ip_config_name" {
  type = string
}

variable "connection_name1" {
  type = string
}

variable "connection_name2" {
  type = string
}

variable "connection_type" {
  type    = string
  default = "Vnet2Vnet"
}

