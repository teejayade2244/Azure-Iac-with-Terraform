variable "vnet_name" {
  description = "The name of the virtual network to create."
  type        = string
}

variable "vnet_address_space" {
  description = "The address space for the virtual network."
  type        = list(string)
}

# web
variable "web_subnet_name" {
  description = "The name of the subnet within the virtual network."
  type        = string
}

variable "web_subnet_address_prefix" {
  description = "The address prefix for the web subnet."
  type        = list(string)
}

# app
variable "app_subnet_name" {
  description = "The name of the subnet within the virtual network."
  type        = string
}

variable "app_subnet_address_prefix" {
  description = "The address prefix for the app subnet."
  type        = list(string)
}

# bastion
variable "bastion_subnet_name" {
  description = "The name of the subnet for the Azure Bastion service."
  type        = string
}

variable "bastion_subnet_address_prefix" {
  description = "The address prefix for the Azure Bastion subnet."
  type        = list(string)
}

variable "web_vm_instance_count" {
  description = "The number of web VMs to create."
  type        = map(string)
}

variable "web_vmss_nsg_inbound_ports" {
  description = "The number of web VMs to create."
  type        = list(string)
}



