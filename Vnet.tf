# This file is part of the Terraform configuration for Azure resources.
# It defines the creation of a virtual network (VNet) in Azure using the azurerm provider.
resource "azurerm_virtual_network" "my_vnet" {
  name                = "${local.resource_name_prefix}-${var.vnet_name}"
  location            = azurerm_resource_group.my_resource_group.location
  resource_group_name = azurerm_resource_group.my_resource_group.name
  address_space       = var.vnet_address_space
  tags               = local.common_tags
}