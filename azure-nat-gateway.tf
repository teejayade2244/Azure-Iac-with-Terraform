resource "azurerm_public_ip" "nat_gateway_pip" {
  name                = "${local.resource_name_prefix}-nat-gateway-pip"
resource_group_name = azurerm_resource_group.my_resource_group.name
  location            = azurerm_resource_group.my_resource_group.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_nat_gateway" "nat_gateway" {
  name                = "${local.resource_name_prefix}-nat-gateway"
  resource_group_name = azurerm_resource_group.my_resource_group.name
  location            = azurerm_resource_group.my_resource_group.location
  sku_name            = "Standard"
}

resource "azurerm_nat_gateway_public_ip_association" "nat_gateway_pip_association" {
  nat_gateway_id       = azurerm_nat_gateway.nat_gateway.id
  public_ip_address_id = azurerm_public_ip.nat_gateway_pip.id
}

resource "azurerm_subnet_nat_gateway_association" "web_subnet_nat_gateway_association" {
  subnet_id      = azurerm_subnet.web_subnet.id
  nat_gateway_id = azurerm_nat_gateway.nat_gateway.id
}