terraform {
  backend "azurerm" {
    resource_group_name  = "my-resource-group-ukwest-dev"
    storage_account_name = "ukwestdevstorageaccount"   
    container_name       = "ukwestdev-container"        
    key                  = "terraform.tfstate"
  }
}