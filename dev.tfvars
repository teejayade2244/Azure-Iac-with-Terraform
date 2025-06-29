resource_group_name = "my-resource-group"
resource_group_location = "ukwest"
environment = "dev"
vnet_name = "my-vnet"
vnet_address_space = ["10.0.0.0/16"]
web_subnet_name = "web-subnet"
web_subnet_address_prefix  = ["10.0.1.0/24"]
app_subnet_name  = "app-subnet"
app_subnet_address_prefix  = ["10.0.2.0/24"]
bastion_subnet_name = "AzureBastionSubnet"
bastion_subnet_address_prefix = ["10.0.101.0/24"]
# web_vm_instance_count = {
#   "vm1" = "1",
#   "vm2" = "2"
# }
web_vm_nsg_inbound_ports = [
  "22",
  "80",
  "443"
]

