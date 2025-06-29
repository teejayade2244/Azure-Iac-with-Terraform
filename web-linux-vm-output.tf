# output "web_linux_vm_public_ip" {
#   # value = [azurerm_linux_virtual_machine.web_vm[*].public_ip_address]
#   value = [for vm in azurerm_linux_virtual_machine.web_vm : vm.public_ip_address]
# }

output "web_linux_vm_id" {
  # value = [azurerm_linux_virtual_machine.web_vm[*].id]

  # Using a for loop to create a list of VM IDs
  # This allows for easy access to each VM's ID in the output
  # value = [for vm in azurerm_linux_virtual_machine.web_vm : vm.id]

  # Using a map to output VM names as keys and their IDs as values
  # This allows for easier reference to specific VMs by name
  value = {
    for vm in azurerm_linux_virtual_machine.web_vm : vm.name => vm.id
  }
}

output "web_linux_vm_private_ip_address" {
  # value = [azurerm_linux_virtual_machine.web_vm[*].private_ip_address]
  # value = [for vm in azurerm_linux_virtual_machine.web_vm : vm.private_ip_address]
  value = {
    for vm in azurerm_linux_virtual_machine.web_vm : vm.name => vm.private_ip_address
  }
}

output "web_linux_vm_name" {
  # value = [azurerm_linux_virtual_machine.web_vm[*].name]
  # value = [for vm in azurerm_linux_virtual_machine.web_vm : vm.name]
  value = keys({
    for vm in azurerm_linux_virtual_machine.web_vm : vm.name => vm.name
  })
  # # Using keys to get a list of VM names. this takes a map and returns its keys as a list
  # using values would return a lisst of the values in the map
}

output "web_linux_network_interface_id" {
  # value = [azurerm_network_interface.web_nic[*].id]
  # value = [for nic in azurerm_network_interface.web_nic : nic.id]
  value = {
    for vm, nic in azurerm_network_interface.web_nic : vm => nic.id
  }
  # # Using a map to output VM names as keys and their NIC IDs as values
}





