# Resource Group
resource "azurerm_resource_group" "azfuncci" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Storage
resource "azurerm_storage_account" "azfuncci" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.azfuncci.name
  location                 = azurerm_resource_group.azfuncci.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = var.tags
}

# Storage Container
resource "azurerm_storage_container" "azfuncci" {
  container_access_type = "private"
  name                  = var.function_app_name
  storage_account_name  = azurerm_storage_account.azfuncci.name
}

module "api" {
  source = "./app-service"
  resource_group_name = azurerm_resource_group.azfuncci.name
  location = var.location
  app_service_plan_name = var.api_service_plan_name
  app_name = var.api_name
}

module "function" {
  source = "./function-ase"
  resource_group_name = azurerm_resource_group.azfuncci.name
  app_service_plan_name = var.app_service_plan_name
  storage_account_name = azurerm_storage_account.azfuncci.name
  function_app_name = var.function_app_name
  dataapi_url = var.dataapi_url
  location = var.location
  primary_access_key =  azurerm_storage_account.azfuncci.primary_access_key
  tags = var.tags
}
