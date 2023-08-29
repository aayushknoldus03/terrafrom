resource_group_name = "shubham-tf-rg"
location            = "West US"

vnet1_name          = "vnet1"

vnet2_name          = "vnet2"

subnet1_name           = "GatewaySubnet"
subnet1_address_prefix = "10.1.0.0/24"

subnet2_name           = "GatewaySubnet"
subnet2_address_prefix = "10.2.0.0/24"

gateway1_name           = "gateway1"
gateway2_name           = "gateway2"
gateway1_ip_config_name = "gw1-ip-config"
gateway2_ip_config_name = "gw2-ip-config"

connection_name1 = "vnet1-to-vnet2"
connection_name2 = "vnet2-to-vnet1"
