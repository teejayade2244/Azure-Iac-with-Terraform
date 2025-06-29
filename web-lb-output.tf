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

output "web_nic_backend_pool_association_id" {
  description = "IDs of the backend address pool associations for the web NICs"
  value = { for k, v in azurerm_network_interface_backend_address_pool_association.web_nic_backend_pool_association : k => v.id }
}

