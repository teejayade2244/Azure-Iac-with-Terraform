resource "azurerm_subnet" "web_subnet" {
  name                 = "${local.resource_name_prefix}-${var.web_subnet_name}"
  resource_group_name  = azurerm_resource_group.my_resource_group.name
  virtual_network_name = azurerm_virtual_network.my_vnet.name
  address_prefixes     = var.web_subnet_address_prefix
 }


 resource "azurerm_network_security_group" "web_subnet_nsg" {
  name                = "${local.resource_name_prefix}-${var.web_subnet_name}-nsg"
  location            = azurerm_resource_group.my_resource_group.location
  resource_group_name = azurerm_resource_group.my_resource_group.name
  tags = local.common_tags

# A dynamic block is used to generate repeated nested blocks (like security_rule) based on a list or map.
# "For each value in var.web_vmss_nsg_inbound_ports, create a security_rule block with the given settings"
  dynamic "security_rule" {
    for_each = var.web_vmss_nsg_inbound_ports
    content {
      name                       = "Allow-${security_rule.value}-Inbound"
      priority                   = 100 + index(var.web_vmss_nsg_inbound_ports, security_rule.value)
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = security_rule.value
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "web_subnet_nsg_association" {
  subnet_id                 = azurerm_subnet.web_subnet.id
  depends_on = [azurerm_network_security_group.web_subnet_nsg]
  network_security_group_id = azurerm_network_security_group.web_subnet_nsg.id
}

# locals {
#   web_inbound_ports = {
#     "100" :  "22"
#     "110" : "80"
#     "120" = "443"
#   }
# }
# when starting a map with number make sure to use colon (:) instead of equals (=)
# resource "azurerm_network_security_rule" "web_subnet_nsg_rule" {
#   for_each = local.web_inbound_ports
#   name                        = "Allow-${each.value}-Inbound"
#   priority                    = each.key
#   direction                   = "Inbound"
#   access                      = "Allow"
#   protocol                    = "Tcp"
#   source_port_range           = "*"
#   destination_port_range      = each.value
#   source_address_prefix       = "*"
#   destination_address_prefix  = "*"
#   resource_group_name         = azurerm_resource_group.my_resource_group.name
#   network_security_group_name = azurerm_network_security_group.web_subnet_nsg.name
# }