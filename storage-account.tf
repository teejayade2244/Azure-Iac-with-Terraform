resource "azurerm_storage_account" "storage_account" {
  name                     = "${local.resource_name_prefix}-storageaccount"
  resource_group_name = azurerm_resource_group.my_resource_group.name
  location            = azurerm_resource_group.my_resource_group.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  tags = local.common_tags
}

resource "azurerm_storage_container" "storage_container" {
  name                  = "${local.resource_name_prefix}-container"
  storage_account_id    = azurerm_storage_account.storage_account.id
  container_access_type = "private"
}

