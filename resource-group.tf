# This Terraform configuration creates an Azure Resource Group with a specified name and location.
resource "azurerm_resource_group" "my_resource_group" {
  name     = "${var.resource_group_name}-${local.resource_name_prefix}"
  location = "${var.resource_group_location}"
  tags     = local.common_tags
}