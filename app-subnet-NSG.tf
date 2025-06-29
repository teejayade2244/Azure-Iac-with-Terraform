# This Terraform configuration creates a subnet for the app within an existing virtual network
# It uses the variables defined in Vnet-input-variable.tf for the subnet name and address prefix
resource "azurerm_subnet" "app_subnet" {
  name                 = "${local.resource_name_prefix}-${var.app_subnet_name}"
  resource_group_name  = azurerm_resource_group.my_resource_group.name
  virtual_network_name = azurerm_virtual_network.my_vnet.name
  address_prefixes     = var.app_subnet_address_prefix
 }


# This Terraform configuration creates a Network Security Group (NSG) for the app subnet
 resource "azurerm_network_security_group" "app_subnet_nsg" {
  name                = "${local.resource_name_prefix}-${var.app_subnet_name}-nsg"
  location            = azurerm_resource_group.my_resource_group.location
  resource_group_name = azurerm_resource_group.my_resource_group.name


  tags = local.common_tags
}

# This Terraform configuration associates the Network Security Group (NSG) with the app subnet
# It also creates inbound security rules for the app subnet NSG to allow traffic on specified ports
resource "azurerm_subnet_network_security_group_association" "app_subnet_nsg_association" {
  subnet_id                 = azurerm_subnet.app_subnet.id
  depends_on = [ azurerm_network_security_rule.app_subnet_nsg_rule ]
  network_security_group_id = azurerm_network_security_group.app_subnet_nsg.id
}

locals {
  app_inbound_ports = {
    "100" :  "22"
    "110" : "80"
    "120" = "443"
  }
}

# This Terraform configuration creates inbound security rules for the app subnet NSG
# The rules allow inbound traffic on specified ports (22, 80, 443) from any source to any destination.
# when starting a map with number make sure to use colon (:) instead of equals (=)
resource "azurerm_network_security_rule" "app_subnet_nsg_rule" {
  for_each = local.app_inbound_ports
  name                        = "Allow-${each.value}-Inbound"
  priority                    = each.key
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = each.value
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.my_resource_group.name
  network_security_group_name = azurerm_network_security_group.app_subnet_nsg.name
}