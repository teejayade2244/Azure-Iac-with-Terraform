locals {
  environment = var.environment
  region      = var.resource_group_location
  resource_name_prefix = "${var.resource_group_location}-${var.environment}"
  common_tags = {
    environment = var.environment
    region      = var.resource_group_location
  }
}