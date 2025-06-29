

# resource "azurerm_linux_virtual_machine" "web_vm" {
#   # count = var.web_vm_instance_count
#   for_each = var.web_vm_instance_count
#   name                = "${local.resource_name_prefix}-web-vm-${each.key}"
#   resource_group_name = azurerm_resource_group.my_resource_group.name
#   location            = azurerm_resource_group.my_resource_group.location
#   tags                = local.common_tags
#   size                = "Standard_F1" 
#   admin_username      = "adminuser"
#   network_interface_ids = [
#     # Use the element function to get the correct NIC for each VM instance
#     # This allows for multiple VMs to be created with unique NICs
#     # element([azurerm_network_interface.web_nic[*].id], count.index)
#     azurerm_network_interface.web_nic[each.key].id,
#   ]

#   admin_ssh_key {
#     username   = "adminuser"
#     public_key = file("my-key.pub")
#   }

#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }

#   source_image_reference {
#     publisher = "Canonical"
#     offer     = "0001-com-ubuntu-server-jammy"
#     sku       = "22_04-lts"
#     version   = "latest"
#   }
# }