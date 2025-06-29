resource "azurerm_network_security_group" "web_vmss_nsg" {
  name                = "${local.resource_name_prefix}-web-vmss-nsg"
  location            = azurerm_resource_group.my_resource_group.location
  resource_group_name = azurerm_resource_group.my_resource_group.name
  tags                = local.common_tags

  dynamic "security_rule" {
    for_each = var.web_vm_nsg_inbound_ports
    content {
      name                       = "Allow-${security_rule.value}-Inbound"
      priority                   = 100 + index(var.web_vm_nsg_inbound_ports, security_rule.value)
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

resource "azurerm_linux_virtual_machine_scale_set" "web_vmss" {
  name                = "${local.resource_name_prefix}-web-vmss"
  location            = azurerm_resource_group.my_resource_group.location
  resource_group_name = azurerm_resource_group.my_resource_group.name
  sku                 = "Standard_F1"
  instances           = 2
  admin_username      = "adminuser"

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("my-key.pub")
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  upgrade_mode = "Automatic"
  tags = local.common_tags

  network_interface {
    name    = "web-vmss-nic"
    primary = true
    network_security_group_id = azurerm_network_security_group.web_vmss_nsg.id

    ip_configuration {
      name      = "web-vmss-ipconfig"
      primary   = true
      subnet_id = azurerm_subnet.web_subnet.id
      load_balancer_backend_address_pool_ids = [
        azurerm_lb_backend_address_pool.web_lb_backend_pool.id
      ]
    }
  }
}

# This Terraform configuration creates a Linux VM in Azure with a public IP address.
# resource "azurerm_public_ip" "web_pip" {
#   name                = "${local.resource_name_prefix}-web-pip"
#   location            = azurerm_resource_group.my_resource_group.location
#   resource_group_name = azurerm_resource_group.my_resource_group.name
#   sku = "Standard"
#   allocation_method   = "Static"
#   domain_name_label   = "${local.resource_name_prefix}-web-pip"
#   tags = local.common_tags
# }

# # Create a Linux VM in Azure with a public IP address and a network interface
# resource "azurerm_network_interface" "web_nic" {
#   # count =  var.web_vm_instance_count
#   for_each = var.web_vm_instance_count
#   name                = "${local.resource_name_prefix}-web-nic-${each.key}"
#   location            = azurerm_resource_group.my_resource_group.location
#   resource_group_name = azurerm_resource_group.my_resource_group.name

#   tags                = local.common_tags
#   ip_configuration {
#     name                          = "${local.resource_name_prefix}-web-ipconfig"
#     subnet_id                     = azurerm_subnet.web_subnet.id
#     private_ip_address_allocation = "Dynamic"
#     # public_ip_address_id          = azurerm_public_ip.web_pip.id
#   }
# }

#  resource "azurerm_network_security_group" "web_vmnic_nsg" {
#   for_each = var.web_vm_instance_count
#   name                = "${azurerm_network_interface.web_nic[each.key].name}-nsg"
#   location            = azurerm_resource_group.my_resource_group.location
#   resource_group_name = azurerm_resource_group.my_resource_group.name
#   tags = local.common_tags

#     dynamic "security_rule" {
#     for_each = var.web_vm_nsg_inbound_ports
#     content {
#       name                       = "Allow-${security_rule.value}-Inbound"
#       priority                   = 100 + index(var.web_vm_nsg_inbound_ports, security_rule.value)
#       direction                  = "Inbound"
#       access                     = "Allow"
#       protocol                   = "Tcp"
#       source_port_range          = "*"
#       destination_port_range     = security_rule.value
#       source_address_prefix      = "*"
#       destination_address_prefix = "*"
#     }
#   }
# }

# resource "azurerm_network_interface_security_group_association" "web_nic_nsg_association" {
#   depends_on = [ azurerm_network_security_group.web_vmss_nsg ]
#   network_interface_id      = azurerm_network_interface.web_nic[each.key].id
#   network_security_group_id = azurerm_network_security_group.web_vmss_nsg[each.key].id
# }

