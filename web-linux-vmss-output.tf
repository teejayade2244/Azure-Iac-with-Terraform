output "web_linux_vmss_id" {
  value = azurerm_linux_virtual_machine_scale_set.web_vmss.id
}

output "web_linux_vmss_name" {
  value = azurerm_linux_virtual_machine_scale_set.web_vmss.name
}

output "web_linux_vmss_instance_count" {
  value = azurerm_linux_virtual_machine_scale_set.web_vmss.instances
}

