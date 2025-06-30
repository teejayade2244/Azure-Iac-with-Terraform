terraform {
  backend "azurerm" {
    resource_group_name  = "my-resource-group-ukwest-dev"
    storage_account_name = "ukwestdevstorageaccount"   # <-- match exactly
    container_name       = "ukwestdev-container"        # <-- match exactly
    key                  = "terraform.tfstate"
  }
}