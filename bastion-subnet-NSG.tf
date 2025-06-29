resource "azurerm_subnet" "bastion_subnet" {
  name                 = "${var.bastion_subnet_name}"
  resource_group_name  = azurerm_resource_group.my_resource_group.name
  virtual_network_name = azurerm_virtual_network.my_vnet.name
  address_prefixes     = var.bastion_subnet_address_prefix
 }


 resource "azurerm_network_security_group" "bastion_subnet_nsg" {
  name                = "${local.resource_name_prefix}-${var.bastion_subnet_name}-nsg"
  location            = azurerm_resource_group.my_resource_group.location
  resource_group_name = azurerm_resource_group.my_resource_group.name
  tags = local.common_tags
}

resource "azurerm_subnet_network_security_group_association" "bastion_subnet_nsg_association" {
  subnet_id                 = azurerm_subnet.bastion_subnet.id
  depends_on = [ azurerm_network_security_rule.bastion_subnet_nsg_rule ]
  network_security_group_id = azurerm_network_security_group.bastion_subnet_nsg.id
}

locals {
  bastion_inbound_ports = {
    "100" :  "22"
    "110" : "80"
    "120" = "443"
  }
}
# when starting a map with number make sure to use colon (:) instead of equals (=)
resource "azurerm_network_security_rule" "bastion_subnet_nsg_rule" {
  for_each = local.bastion_inbound_ports
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
  network_security_group_name = azurerm_network_security_group.bastion_subnet_nsg.name
}