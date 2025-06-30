output "web_lb_public_ip" {
  description = "value of the public IP address for the web load balancer"
  value = azurerm_public_ip.web_lb_pip.ip_address
}

output "web_lb_frontend_ip_configuration" {
  description = "value of the frontend IP configuration for the web load balancer"
  value = azurerm_lb.web_lb.frontend_ip_configuration[0].private_ip_address
}

output "web_lb_backend_address_pool_id" {
  description = "ID of the backend address pool for the web load balancer"
  value = azurerm_lb_backend_address_pool.web_lb_backend_pool.id
}

output "web_lb_probe_id" {
  description = "ID of the probe for the web load balancer"
  value = azurerm_lb_probe.web_lb_probe.id
}

output "web_lb_rule_id" {
  description = "ID of the rule for the web load balancer"
  value = azurerm_lb_rule.web_lb_rule.id
}

output "web_linux_vmss_id" {
  value = azurerm_linux_virtual_machine_scale_set.web_vmss.id
}

output "web_linux_vmss_name" {
  value = azurerm_linux_virtual_machine_scale_set.web_vmss.name
}

output "web_linux_vmss_instance_count" {
  value = azurerm_linux_virtual_machine_scale_set.web_vmss.instances
}


# output "web_nic_backend_pool_association_id" {
#   description = "IDs of the backend address pool associations for the web NICs"
#   value = { for k, v in azurerm_network_interface_backend_address_pool_association.web_nic_backend_pool_association : k => v.id }
# }

# # output "web_linux_vm_public_ip" {
# #   # value = [azurerm_linux_virtual_machine.web_vm[*].public_ip_address]
# #   value = [for vm in azurerm_linux_virtual_machine.web_vm : vm.public_ip_address]
# # }

# output "web_linux_vmss_id" {
#   # value = [azurerm_linux_virtual_machine.web_vm[*].id]

#   # Using a for loop to create a list of VM IDs
#   # This allows for easy access to each VM's ID in the output
#   # value = [for vm in azurerm_linux_virtual_machine.web_vm : vm.id]

#   # Using a map to output VM names as keys and their IDs as values
#   # This allows for easier reference to specific VMs by name
#   value = {
#     for vm in azurerm_linux_virtual_machine.web_vm : vm.name => vm.id
#   }
# }

# output "web_linux_vm_private_ip_address" {
#   # value = [azurerm_linux_virtual_machine.web_vm[*].private_ip_address]
#   # value = [for vm in azurerm_linux_virtual_machine.web_vm : vm.private_ip_address]
#   value = {
#     for vm in azurerm_linux_virtual_machine.web_vm : vm.name => vm.private_ip_address
#   }
# }

# output "web_linux_vm_name" {
#   # value = [azurerm_linux_virtual_machine.web_vm[*].name]
#   # value = [for vm in azurerm_linux_virtual_machine.web_vm : vm.name]
#   value = keys({
#     for vm in azurerm_linux_virtual_machine.web_vm : vm.name => vm.name
#   })
#   # # Using keys to get a list of VM names. this takes a map and returns its keys as a list
#   # using values would return a lisst of the values in the map
# }

# output "web_linux_network_interface_id" {
#   # value = [azurerm_network_interface.web_nic[*].id]
#   # value = [for nic in azurerm_network_interface.web_nic : nic.id]
#   value = {
#     for vm, nic in azurerm_network_interface.web_nic : vm => nic.id
#   }
#   # # Using a map to output VM names as keys and their NIC IDs as values
# }





