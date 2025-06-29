output "web_linux_vmss_id" {
  value = azurerm_linux_virtual_machine_scale_set.web_vmss.id
}

output "web_linux_vmss_name" {
  value = azurerm_linux_virtual_machine_scale_set.web_vmss.name
}

output "web_linux_vmss_instance_count" {
  value = azurerm_linux_virtual_machine_scale_set.web_vmss.instances
}

output "web_linux_vmss_primary_network_interface_id" {
  value = azurerm_linux_virtual_machine_scale_set.web_vmss.network_interface[0].id
}

output "web_linux_vmss_private_ip_addresses" {
  description = "Private IP addresses of the VMSS instances"
  value       = azurerm_linux_virtual_machine_scale_set.web_vmss.network_interface[0].ip_configuration[0].private_ip_address
}