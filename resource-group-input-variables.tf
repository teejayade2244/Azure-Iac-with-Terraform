variable "resource_group_name" {
  description = "The name of the resource group to create."
  type        = string
}

variable "resource_group_location" {
  description = "The Azure region where the resource group will be created."
  type        = string
}

variable "environment" {
  description = "The environment for which the resources are being createdu."
  type        = string
}

