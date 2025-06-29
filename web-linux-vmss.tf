# resource "azurerm_linux_virtual_machine_scale_set" "web_vmss" {
#   name                = "${local.resource_name_prefix}-web-vmss"
#   location            = azurerm_resource_group.my_resource_group.location
#   resource_group_name = azurerm_resource_group.my_resource_group.name
#   sku                 = "Standard_F2"
#   instances           = 3
#   admin_username      = "adminuser"

#   admin_ssh_key {
#     username   = "adminuser"
#     public_key = file("~/.ssh/id_rsa.pub")
#   }

#   source_image_reference {
#     publisher = "Canonical"
#     offer     = "0001-com-ubuntu-server-jammy"
#     sku       = "22_04-lts"
#     version   = "latest"
#   }

#   os_disk {
#     storage_account_type = "Standard_LRS"
#     caching              = "ReadWrite"
#   }
 
#   upgrade_mode = "Automatic"
#   tags = local.common_tags
#   network_interface {
#     name    = "web-vmss-nic"
#     primary = true
#     network_security_group_id = azurerm_network_security_group.web_vmss_nsg.id

#     ip_configuration {
#       name      = "web-vmss-ipconfig"
#       primary   = true
#       subnet_id = azurerm_subnet.web_subnet.id
#       load_balancer_backend_address_pool_ids = [
#         azurerm_lb_backend_address_pool.web_lb_backend_pool.id
#       ]
#     }
#   }
# }