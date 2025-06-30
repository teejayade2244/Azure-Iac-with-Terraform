terraform {
  backend "azurerm" {
    resource_group_name  = "my-resource-group-ukwest-dev"
    storage_account_name = "ukwest-dev-storageaccount"
    container_name       = "ukwest-dev-container"
    key                  = "terraform.tfstate"
  }
}