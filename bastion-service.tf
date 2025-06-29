resource "azurerm_subnet" "bastion_subnet" {
  name                 = "${var.bastion_subnet_name}"
  resource_group_name  = azurerm_resource_group.my_resource_group.name
  virtual_network_name = azurerm_virtual_network.my_vnet.name
  address_prefixes     = var.bastion_subnet_address_prefix
 }


resource "azurerm_public_ip" "bastion_pip" {
  name                = "${local.resource_name_prefix}-bastion-pip"
  resource_group_name = azurerm_resource_group.my_resource_group.name
  location            = azurerm_resource_group.my_resource_group.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = local.common_tags
}

resource "azurerm_bastion_host" "bastion" {
  name                = "${local.resource_name_prefix}-bastion"
  location            = azurerm_resource_group.my_resource_group.location
  resource_group_name = azurerm_resource_group.my_resource_group.name

  ip_configuration {
    name                 = "bastion-config"
    subnet_id            = azurerm_subnet.bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.bastion_pip.id
  }

  tags = local.common_tags
}
