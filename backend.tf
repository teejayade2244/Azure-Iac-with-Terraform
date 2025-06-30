terraform {
  backend "azurerm" {
    resource_group_name  = "my-resource-group-ukwest-dev"
    storage_account_name = "ukwestdev-storageaccount"   # <-- match exactly
    container_name       = "ukwestdev-container"        # <-- match exactly
    key                  = "terraform.tfstate"
  }
}