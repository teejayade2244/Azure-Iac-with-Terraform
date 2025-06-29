# resource "azurerm_linux_virtual_machine_scale_set" "web_vmss" {
#   name                = "${local.resource_name_prefix}-web-vmss"
#   location            = azurerm_resource_group.my_resource_group.location
#   resource_group_name = azurerm_resource_group.my_resource_group.name
#   sku                 = "Standard_F2"
#   instances           = 3
#   admin_username      = "adminuser"

#   admin_ssh_key {
#     username   = "adminuser"
#     public_key = local.first_public_key
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

#   network_interface {
#     name    = "example"
#     primary = true

#     ip_configuration {
#       name      = "internal"
#       primary   = true
#       subnet_id = azurerm_subnet.internal.id
#     }
#   }
# }