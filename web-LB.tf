# This Terraform configuration creates a Linux VM in Azure with a public IP address.
resource "azurerm_public_ip" "web_lb_pip" {
  name                = "${local.resource_name_prefix}-web-lb-pip"
  location            = azurerm_resource_group.my_resource_group.location
  resource_group_name = azurerm_resource_group.my_resource_group.name
  sku = "Standard"
  allocation_method   = "Static"
  domain_name_label   = "${local.resource_name_prefix}-web-lb-pip"
  tags = local.common_tags
}


# This Terraform configuration creates a load balancer in Azure for the web application.
# The load balancer will distribute incoming traffic across multiple VMs in the backend pool.
resource "azurerm_lb" "web_lb" {
  name                = "${local.resource_name_prefix}-web-lb"
  location            = azurerm_resource_group.my_resource_group.location
  resource_group_name = azurerm_resource_group.my_resource_group.name

  frontend_ip_configuration {
    name                 = "${local.resource_name_prefix}-web-lb-frontend"
    public_ip_address_id = azurerm_public_ip.web_lb_pip.id
  }
}

# This Terraform configuration creates a backend address pool for the web load balancer.
# The backend address pool is used to route traffic to the VMs associated with the load balancer.
resource "azurerm_lb_backend_address_pool" "web_lb_backend_pool" {
  loadbalancer_id = azurerm_lb.web_lb.id
  name            = "${local.resource_name_prefix}-web-lb-backend-pool"
}

# This Terraform configuration creates a load balancer probe for the web load balancer.
resource "azurerm_lb_probe" "web_lb_probe" {
  loadbalancer_id = azurerm_lb.web_lb.id
  name            = "${local.resource_name_prefix}-web-lb-probe"
  protocol        = "Tcp"
  port            = 80
  
}

# This Terraform configuration creates a load balancer rule for the web load balancer.
# The rule maps incoming traffic on port 80 to the backend pool and uses a probe for health checks.
resource "azurerm_lb_rule" "web_lb_rule" {
  loadbalancer_id            = azurerm_lb.web_lb.id
  name                       = "${local.resource_name_prefix}-web-lb-rule"
  protocol                   = "Tcp"
  frontend_port              = 80
  backend_port               = 80
  frontend_ip_configuration_name = azurerm_lb.web_lb.frontend_ip_configuration[0].name
  backend_address_pool_ids   = [azurerm_lb_backend_address_pool.web_lb_backend_pool.id]
  probe_id                   = azurerm_lb_probe.web_lb_probe.id
}

 # Associate the network interface with the backend address pool
resource "azurerm_network_interface_backend_address_pool_association" "web_nic_backend_pool_association" {
  # count                   = var.web_vm_instance_count
  for_each                = var.web_vm_instance_count
  network_interface_id    = azurerm_network_interface.web_nic[each.key].id
  ip_configuration_name   = azurerm_network_interface.web_nic[each.key].ip_configuration[0].name
  backend_address_pool_id  = azurerm_lb_backend_address_pool.web_lb_backend_pool.id
}

# # NAT rule for SSH access to the web load balancer
# # This allows SSH access to the web load balancer on port 1022, mapping it to port 22 on the backend VMs.
# resource "azurerm_lb_nat_rule" "web_lb_nat_rule" {
#   resource_group_name            = azurerm_resource_group.my_resource_group.name
#   loadbalancer_id                = azurerm_lb.web_lb.id
#   name                           = "${local.resource_name_prefix}-web-lb-nat-rule-ssh"
#   protocol                       = "Tcp"
#   frontend_port                  = 1022
#   backend_port                   = 22
#   frontend_ip_configuration_name = azurerm_lb.web_lb.frontend_ip_configuration[0].name
#   backend_address_pool_id        = azurerm_lb_backend_address_pool.web_lb_backend_pool.id
# }

